# -*- coding: utf-8 -*-

#
# Dump all replication events from a remote mysql server
#
import time
from pymysqlreplication import BinLogStreamReader
from pymysqlreplication.row_event import DeleteRowsEvent, WriteRowsEvent, UpdateRowsEvent
import pymysql
from collections import deque


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

    def produce_sqls(self):
        """连接源MySQL，解析binlog并生成sql的方法"""
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
                            template = 'DELETE FROM `{0}` WHERE {1} LIMIT 1;'.format(
                            # binlogevent.schema, 
                            binlogevent.table, 
                            ' AND '.join(map(lambda x: x[0]+'='+"'"+str(x[1])+"'" if isinstance(x[1], str) else x[0]+'='+str(x[1]), row['values'].items()))
                            )

                    elif isinstance(binlogevent, WriteRowsEvent):     #插入SQL
                        for row in binlogevent.rows:
                            template = 'INSERT INTO `{0}`({1}) VALUES ({2});'.format(
                            # binlogevent.schema, 
                            binlogevent.table, 
                            ', '.join(map(lambda key: '`%s`' % key, row['values'].keys())),
                            ', '.join(map(lambda value: "'"+value+"'" if isinstance(value, str) else str(value), row['values'].values()))
                            )

                    else:                                             #更新SQL
                        for row in binlogevent.rows:
                            template = 'UPDATE `{0}` SET {1} WHERE {2} LIMIT 1;'.format(
                            # binlogevent.schema, 
                            binlogevent.table, 
                            ', '.join(map(lambda x: x[0]+'='+"'"+str(x[1])+"'" if isinstance(x[1], str) else x[0]+'='+str(x[1]), row['after_values'].items())),
                            ' AND '.join(map(lambda x: x[0]+'='+"'"+str(x[1])+"'" if isinstance(x[1], str) else x[0]+'='+str(x[1]), row['before_values'].items()))
                            )
                    self.sqlsqueue.setdefault(target_table, deque()).append(template)

            print(self.sqlsqueue) 
            time.sleep(1)
            # yield

        self.stream.close()

    def customer_sqls(self, target_connection, chunksize):
        """连接目标MySQL，将生成sql回放的方法。
           如何指定表：dbname.tbname字符串join_run_queue加入applyqueue队列
        """
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
                                for i in range(chunksize if chunksize < len(self.sqlsqueue[readytable]) else len(self.sqlsqueue[readytable])):
                                    print(len(self.sqlsqueue[readytable]))
                                    cursor_destination.execute(self.sqlsqueue[readytable].popleft())
                                connection_destination.commit()
                            except Exception:
                                pass # 插入冲突逻辑上可以忽略
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
    
