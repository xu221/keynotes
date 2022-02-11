# *- coding: utf-8 -*-
import pymysql
import time
from functools import wraps
from concurrent.futures import ThreadPoolExecutor, as_completed
from binlogstreamer import BinLogProcesser
from collections import deque
from scheduler import Scheduler, timeblock

def tabledata_select2insert(tablename, connection_source, connection_destination, chunksize=100, parallel=2, indexcolumn="ID"):
    connection_temp = pymysql.connect( host=connection_source["host"],
                                    user=connection_source["user"],
                                    password=connection_source["password"],
                                    database=connection_source["database"],
                                    cursorclass = pymysql.cursors.SSCursor)
    
    def producer(connection_s, tablename, chunksize, p_pipe, lower_limit, upper_limit):
        sql_s = "select * from {0} where {3} >= {1} and {3} < {2}".format(tablename, lower_limit, upper_limit, indexcolumn)
        print(sql_s)
        with connection_s:
            with connection_s.cursor() as cursor_source:
                cursor_source.execute(sql_s)
                chunkdata=cursor_source.fetchmany(chunksize)
                while chunkdata:
                    p_pipe.append(chunkdata)
                    chunkdata = cursor_source.fetchmany(chunksize)

    def customer(connection_d, sql_i, c_pipe):
        with connection_d:
            with connection_d.cursor() as cursor_destination:
                cursor_destination.execute("/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;")
                cursor_destination.execute("/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;")
                cursor_destination.execute("/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;")
                cursor_destination.execute("/*!40101 SET NAMES utf8 */;")
                cursor_destination.execute("/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;")
                cursor_destination.execute("/*!40103 SET TIME_ZONE='+00:00' */;")
                cursor_destination.execute("/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;")
                cursor_destination.execute("/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;")
                cursor_destination.execute("/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;")
                cursor_destination.execute("/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;")
                cursor_destination.execute("/*!40000 ALTER TABLE `{0}` DISABLE KEYS */;".format(tablename))
                while True:
                    print(len(c_pipe))
                    if c_pipe:
                        chunkdata = c_pipe.popleft()
                        if chunkdata == "over":
                            c_pipe.append("over") 
                            break
                        start = time.perf_counter()
                        cursor_destination.executemany(sql_i, chunkdata)
                        connection_d.commit()
                        print(time.perf_counter() - start)
                    else:
                        time.sleep(0.5)
    
    with connection_temp:
        with connection_temp.cursor() as cursor:
            cursor.execute("SHOW VARIABLES LIKE 'max_allowed_packet%'")
            print(cursor.fetchall())
            cursor.execute("SHOW COLUMNS FROM {0}".format(tablename))
            columns = cursor.fetchall()
            sql_i = "insert into {0}({1}) values({2})".format(tablename,','.join(i[0] for i in columns),','.join('%s' for _ in range(len(columns))))
            cursor.execute("SELECT MIN({0}) FROM {1}".format(indexcolumn, tablename))
            min_value = cursor.fetchall()[0][0]
            cursor.execute("SELECT MAX({0}) FROM {1}".format(indexcolumn, tablename))
            max_value = cursor.fetchall()[0][0]
    try:
        with ThreadPoolExecutor(max_workers=parallel*2) as executor:
            temp_pipe = deque(maxlen=100)
            ranges = []
            result = True
            for i in range(parallel):
                if i == (parallel-1):
                    ranges.append((i*round((max_value-min_value)/parallel) + min_value, max_value+1))
                else:
                    ranges.append((i*round((max_value-min_value)/parallel) + min_value, (i+1)*(round((max_value-min_value)/parallel)) + min_value))
            print(ranges)
            future_producer = [executor.submit(producer, pymysql.connect(host=connection_source["host"],user=connection_source["user"],passwd=connection_source["password"],database=connection_source["database"], cursorclass = pymysql.cursors.SSCursor), tablename, chunksize, temp_pipe, rg[0], rg[1]) for rg in ranges]
            future_customer = [executor.submit(customer, pymysql.connect(host=connection_destination["host"],user=connection_destination["user"],passwd=connection_destination["password"],database=connection_destination["database"]), sql_i, temp_pipe) for _ in range(parallel) ]
            for i in as_completed(future_producer):
                if i.exception():
                    print(i.exception())
                    result = False
            temp_pipe.append("over")
            print("produce over--------------")
            for i in as_completed(future_customer):
                if i.exception():
                    print(i.exception())
                    result = False
            print("--------------customer over")
            return result
    except Exception as e:
        print(e)
        return False
    
def find_all_tables(connection_source):
    connection_source = pymysql.connect(host=connection_source["host"], 
                                        user=connection_source["user"],
                                        password=connection_source["password"],
                                        database=connection_source["database"])
    with connection_source:
        with connection_source.cursor() as cursor_source:
            cursor_source.execute("show tables")
            return [table[0] for table in cursor_source.fetchall()]

def fulldatabackup(tablename, source_connection, destination_connection, sqlstreamer, chunksize=1000, parallel=2, indexcolumn = "ID"):
    with timeblock("     cost-time"):
        readytable = "{0}.{1}".format(source_connection["database"], tablename)
        sqlstreamer.preparequeue.append(readytable)
        while not sqlstreamer.targettable.get(readytable):
            time.sleep(1)
        time.sleep(1)
        result = tabledata_select2insert(tablename, source_connection, destination_connection, chunksize, parallel, indexcolumn)
        if result:
            print("{0} is copied fully!".format(readytable), end='')
            sqlstreamer.applyqueue.append(readytable)
        else:
            print("{0} dump is failed!".format(readytable), end='')

def binlogbackup(taskfun):
    with timeblock("     all-time"):
        sched = Scheduler()          
        sched.new(taskfun)
        sched.mainloop()                

def deltaapply(taskfun):
    with timeblock("     all-time"):
        sched = Scheduler()            
        sched.new(taskfun)
        sched.mainloop()                
   
def future_call_back(future):
    if future.exception():
        print(future.exception())

if __name__ == "__main__":
    """
    schema1.tables --> schema2.tables
    """
    source_connection = {
        'host': '127.0.0.1',
        'user': 'x21',
        'port': 3306,
        'password': '******',
        'database': 'test1'
    }
    destination_connection = {
        'host': '127.0.0.1',
        'user': 'x21',
        'port': 3306,
        'password': '******',
        'database': 'test2'
    }
    tables = find_all_tables(source_connection)
    # tables = ["tb9", "tb8", "tb7"]
    # 开启binlog流
    sqlstreamer = BinLogProcesser(MYSQL_SETTINGS={'host':source_connection["host"],'user':source_connection["user"],'port':source_connection["port"],'passwd':source_connection["password"]})
    # 开启线程池，max_workers设置为CPU核数的一倍
    with ThreadPoolExecutor(max_workers=20) as executor:                                                                                                  
        future_binlog = executor.submit(binlogbackup, sqlstreamer.produce_sqls()).add_done_callback(future_call_back)                                     # binlog备份线程
        future_apply = executor.submit(deltaapply, sqlstreamer.customer_sqls(destination_connection, 1000)).add_done_callback(future_call_back)           # binlog应用线程 
        futures = [executor.submit(fulldatabackup, table, source_connection, destination_connection, sqlstreamer, chunksize=1000, parallel=2, indexcolumn="col").add_done_callback(future_call_back) for table in tables]
