from pymongo import MongoClient
from pymongo import WriteConcern
from pymongo import InsertOne, DeleteOne, ReplaceOne, UpdateOne, DeleteMany
from pymongo.errors import BulkWriteError
import time, json
import bson.timestamp
from rich.table import Table
from rich.console import Console


def func1():
    """
    查询文档函数
    """
    client = MongoClient('mongodb://127.0.0.1:27017/')  # 建立连接
    collection = client['blogdb']['posts']              # 选择集合
    for i in collection.find():                         # 遍历集合
        print(i)
    time.sleep(2)

def func2():
    """
    批量插入文档函数
    """
    client = MongoClient('mongodb://127.0.0.1:27017/')  # 建立连接
    collection = client['blogdb'].get_collection('posts', write_concern=WriteConcern(w=1, j=True, wtimeout=1)) # 选择集合
        # write_concern控制何时调用getLastError()
        # write_concern=1：mongod在写入内存之后，返回响应
        # write_concern=1 & journal:true：mongod在写入内存、journal日志之后，返回响应
        # write_concern=2：在集群模式生效，2时表示只有secondary从primary完成复制之后，返回响应
    try:
        insertData =[InsertOne({'title': i}) for i in range(4)] # 插入文档
        otherData = [
                    DeleteMany({}),                             # Remove all documents.
                    InsertOne({'_id': 1}),
                    InsertOne({'_id': 2}),
                    InsertOne({'_id': 3}),
                    UpdateOne({'_id': 1}, {'$set': {'foo': 'bar'}}),
                    UpdateOne({'_id': 4}, {'$inc': {'j': 1}}, upsert=True),
                    ReplaceOne({'j': 1}, {'j': 2}),
                    DeleteOne({'_id': 2})
        ]
        collection.bulk_write(otherData + insertData, ordered=True) 
    except BulkWriteError as bwe:
        print(bwe.details)

def func3():
    """
    统计指定库的所有文档记录数
    """
    client = MongoClient('mongodb://127.0.0.1:27017/')
    db_dictionary = {}
    collention_dictionary = {}
    for collection in client['mission'].list_collection_names():
        collention_dictionary[collection] = client[db][collection].estimated_document_count()
    db_dictionary['mission'] = collention_dictionary
    return db_dictionary

def func4(connection_url):
    """
    统计库内所有文档记录数
    """
    client = MongoClient(connection_url)
    db_dictionary = {}
    for db in (x for x in client.list_database_names() if x not in ['admin', 'config']):
        collention_dictionary = {}
        for collection in client[db].list_collection_names():
            collention_dictionary[collection] = client[db][collection].estimated_document_count()
        db_dictionary[db] = collention_dictionary
    print(json.dumps(db_dictionary, indent=4))

def func5():
    """
    查询近一个小时内活跃的数据库
    """
    client = MongoClient('mongodb://127.0.0.1:27017/')  # 建立连接
    c = client['local']['oplog']                        # 选择oplog集合
    result = {} 
    pas_timestamp = round(time.time()) - 86400
    # 正则匹配：过滤config、admin、空字符开头的namespace，并过滤大于指定时间的日志
    for i in c.rs.find({"$and":[{"ns": {"$regex": r"^(?!^config)(?!^admin)(?!^$)"}},{"ts": {"$gt" : bson.timestamp.Timestamp(pas_timestamp,1) }}]}):
        result[i["ns"]]=i["wall"].strftime("%Y-%m-%d %H:%M:%S")
    print(json.dumps(result, indent=4))

def compare_dictionary(d1: dict, d2: dict, db: str) ->print: 
    """
    字典对比函数
    """
    console = Console()
    table = Table(show_header=True, show_lines=True, header_style="bold magenta",)
    table.add_column("集合")
    table.add_column("源库-" + db, justify="left")
    table.add_column("对比库-" + db, justify="left")
    
    for i in set(d1.keys()).difference(set(d2.keys())):
        table.add_row(i, json.dumps(d1[i], indent=4), '')
    for i in set(d2.keys()).difference(set(d1.keys())):
        table.add_row(i, '', json.dumps(d2[i], indent=4))
    for i in set(d1.keys()).intersection(set(d2.keys())):
        if d1[i] != d2[i]:
            table.add_row(i, json.dumps(d1[i], indent=4), json.dumps(d2[i], indent=4))
    
    console.print(table)

if __name__ == "__main__":
    func4("mongodb://x21:x21@127.0.0.1:27017/?authSource=admin")
