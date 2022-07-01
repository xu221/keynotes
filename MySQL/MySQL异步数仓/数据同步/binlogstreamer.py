# -*- coding: utf-8 -*-

#
# Dump all replication events from a remote mysql server
#

import time
from pymysqlreplication import BinLogStreamReader
from pymysqlreplication.row_event import DeleteRowsEvent, WriteRowsEvent, UpdateRowsEvent
import pymysql
from collections import deque
import datetime

class BinLogProcesser():
    def __init__(self, MYSQL_SETTINGS, server_id=222) -> None:
        # server_id is your slave identifier, it should be unique.
        # set blocking to True if you want to block and wait for the next event at
        # the end of the stream
        self.stream = BinLogStreamReader(connection_settings=MYSQL_SETTINGS,
                                    server_id=server_id,
                                    blocking=False,
                                    resume_stream=True,
                                    only_events = [DeleteRowsEvent, WriteRowsEvent, UpdateRowsEvent]
                                    )
        self.sqlsqueue = {}
        self.targettable = {}
        self.run_queue = {}
        self.preparequeue = deque()
        self.applyqueue = deque()
       
    def add_target_table(self, target_table):
        self.targettable.setdefault(target_table, 1)
    # def del_target_table(self, target_table):
    #     pass
    def join_run_queue(self, target_table):
        self.run_queue.setdefault(target_table, 1)
    # def exit_run_queue(self, target_table):
    #     pass
    def sql_turn(self, sqltype, dictt):
        temp_list=[]
        if sqltype == 'delete':
            for col, val in dictt.items():
                if val == None:
                    temp_list.append(col+' is null')
                elif isinstance(val, str) :
                    temp_list.append(col+'='+"'"+val+"'")
                elif isinstance(val, datetime.datetime):
                    temp_list.append(col+'='+"'"+str(val)+"'")
                else:
                    temp_list.append(col+'='+str(val))
            return ' AND '.join(temp_list)
        elif sqltype == 'insert':
            for val in dictt.values():
                if val == None:
                    temp_list.append('null')
                elif isinstance(val, str) or isinstance(val, datetime.datetime):
                    temp_list.append("'"+val+"'")
                elif isinstance(val, datetime.datetime):
                    temp_list.append("'"+str(val)+"'")
                else:
                    temp_list.append(str(val))
            return ', '.join(temp_list)
        elif sqltype == 'update':
            for col, val in dictt.items():
                if val == None:
                    temp_list.append(col+'=null')
                elif isinstance(val, str):
                    temp_list.append(col+'='+"'"+val+"'")
                elif isinstance(val, datetime.datetime):
                    temp_list.append(col+'='+"'"+str(val)+"'")
                else:
                    temp_list.append(col+'='+str(val))
            return ', '.join(temp_list)
        else:
            pass
            

    def produce_sqls(self):
        while True:
            if self.preparequeue:
                self.add_target_table(self.preparequeue.popleft())
            for binlogevent in self.stream:
                # print(binlogevent.timestamp)
                # print(binlogevent.schema)
                # print(binlogevent.table)
                target_table = "{0}.{1}".format(binlogevent.schema, binlogevent.table)
                if target_table in self.targettable:
                    if isinstance(binlogevent, DeleteRowsEvent):      #删除SQL
                        for row in binlogevent.rows:
                            template = '/* x21:del */ DELETE FROM `{0}` WHERE {1} LIMIT 1;'.format(
                            # binlogevent.schema, 
                            binlogevent.table, 
                            self.sql_turn('delete', row['values'])
                            )
                            self.sqlsqueue.setdefault(target_table, deque()).append(template)

                    elif isinstance(binlogevent, WriteRowsEvent):     #插入SQL
                        for row in binlogevent.rows:
                            template = '/* x21:ins */ INSERT INTO `{0}` VALUES ({1});'.format(
                            # binlogevent.schema, 
                            binlogevent.table, 
                            self.sql_turn('insert', row['values'])
                            )
                            self.sqlsqueue.setdefault(target_table, deque()).append(template)

                    else:                                             #更新SQL
                        for row in binlogevent.rows:
                            template = '/* x21:update */ UPDATE `{0}` SET {1} WHERE {2} LIMIT 1;'.format(
                            # binlogevent.schema, 
                            binlogevent.table, 
                            self.sql_turn('update', row['after_values']),
                            self.sql_turn('delete', row['before_values'])
                            )
                            self.sqlsqueue.setdefault(target_table, deque()).append(template)

            print(self.sqlsqueue) 
            time.sleep(1)
            yield

        self.stream.close()

    def customer_sqls(self, target_connection, chunksize):
        connection_destination = pymysql.connect(host=target_connection["host"], user=target_connection["user"], password=target_connection["password"], database=target_connection["database"], cursorclass = pymysql.cursors.SSCursor)
        with connection_destination:
            with connection_destination.cursor() as cursor_destination:
                cursor_destination.execute("SET SQL_LOG_BIN=OFF")
                while True:
                    if self.applyqueue:
                        self.join_run_queue(self.applyqueue.popleft())
                    for readytable in self.run_queue:
                        if self.sqlsqueue.get(readytable):
                            try:
                                for _ in range(chunksize if chunksize < len(self.sqlsqueue[readytable]) else len(self.sqlsqueue[readytable])):
                                    print(len(self.sqlsqueue[readytable]))
                                    cursor_destination.execute(self.sqlsqueue[readytable].popleft())
                                connection_destination.commit()
                            except Exception as e:
                                print(e)
                        else:
                            pass
                            # print("haven't found binlog stream:{0}".format(readytable))
                        yield

if __name__ == "__main__":
    MYSQL_SETTINGS = {
        "host": "127.0.0.1",
        "port": 3306,
        "user": "x21",
        "passwd": "******"}
    streamer = BinLogProcesser(MYSQL_SETTINGS)
    streamer.preparequeue.append('test2.tb1')
    streamer.produce_sqls()  # 运行测试需除去yield
    

