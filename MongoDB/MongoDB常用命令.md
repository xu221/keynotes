#### 常用命令

> OP LOG相关:仅在shard登录可查询

1.查询oplog状态

```shell
use local
rs.printReplicationInfo()
db.getReplicationInfo()
```

2.查询近期3600秒内，ns为dbname开头的的oplog

```shell
use local
var SECS_PER_HOUR = 608400
var now_time = Math.floor((new Date().getTime()) / 1000) 
db.oplog.rs.find({ "ts" : { "$lt" : Timestamp(now_time, 1), "$gt" : Timestamp(now_time - SECS_PER_HOUR, 1) },"ns": /^dbname/ })
```

3.查询文档最新记录

```shell
db.realtimeBuildMessage.find().sort({_id:-1}).limit(1)
```

> 数据相关

1.更新集合中的所有文档

```shell
db.collectionxxx.find({}).forEach(
    function(item){                 
        db.collectionxxx.update({"_id":item._id},{"$set":{"userName":item.username}}) 
    }
)
```

2.查询库下所有集合大小

```shell
var db = db.getSiblingDB('xxxdb'); // 替换为你的数据库名称

var collections = db.getCollectionNames();

collections.forEach(function(collection) {
    var storageSize = db[collection].totalSize()/1024/1024/1024;
    print("Collection: " + collection + ", Storage Size: " + storageSize + " Gbytes");
});
```

3.分批次删除数据
```
var delete_date = "2023-08-01";
var start_time = new Date();
rows = db.collection_tst.find({"Time": {$lt: delete_date}}).count() //1
print("total rows:", rows);
var batch_num = 2000;
while (rows > 0) {
    if (rows < batch_num) {
        batch_num = rows;
    }
    var cursor = db.collection_tst.find({"Time": {$lt: delete_date}}, {"_id": 1}).sort({"_id": 1}).limit(batch_num); //2
    rows = rows - batch_num;
    var delete_ids = [];
    // 将满足条件的主键值放入到数组中。
    cursor.forEach(function (each_row) {
        delete_ids.push(each_row["_id"]);
    });
    // 通过deleteMany一次删除5000条记录。
    db.collection_tst.deleteMany({   //3
        '_id': {"$in": delete_ids},
        "Time": {'$lt': delete_date} //4
    },{w: "majority"})
}
var end_time = new Date();
print((end_time - start_time) / 1000);
```

> 分片集群相关:mongos登录

1.创建开启分片的数据库

```shell
sh.enableSharding("dbname", "primary_shard_id");
```

2.删除数据库

```shell
db.getSiblingDB("dbname").dropDatabase(); 
```

3.给集合指定分片策略

```shell
sh.shardCollection("dbname.collection", { parkey: 1 } )
sh.shardCollection("dbname.collection", { parkey: "hashed" } )
# 1：表示RANGE分片
# hashed：表示哈希分片
# 如果是空集合，命令会自动创建分片键索引；如果是非空集合，需要提前创建对应分片键索引，可以是联合索引的前缀
```

> 更多选项根据版本参考：https://www.mongodb.com/docs/v4.2/reference/command/shardCollection/#dbcmd.shardCollection



> 用户权限相关:mongodb,每个用户和角色都在各自数据库范围下



1.创建角色

```shell
use testdb
db.createRole(    
{    
    role: "udf_readWrite",    
    privileges: 
        [{ 
        resource: { db: "testdb", collection: "" }, 
        actions: [ "update", "insert", "remove", "createCollection", "renameCollectionSameDB", "dropCollection", "createIndex", "dropIndex" ]
        }],
    roles: [{"role": "read", "db": "testdb"}]  
}    
)
# use哪个库就在哪个库下建角色
```

2.创建用户

```shell
use testdb
db.createUser( {user: "",pwd: "",roles: [ { role: "readAnyDatabase", db: "testdb" } ]});
use testdb
db.createUser( {user: "",pwd: "",roles: [ { role: "read", db: "testdb" } ]});
use admin
db.createUser( {user: "x21",pwd: "x21",roles: [ { role: "root", db: "testdb" } ]});
# use哪个库就在哪个库下建用户,roles为继承用户
```

3.查看用户

```shell
use testdb
show users
```
4.查看用户权限

```shell
use testdb
db.getUser('userlocal')
```

4.删除角色

```shell
use testdb
db.revokeRolesFromUser('userlocal',[{role : "udf_readWrite",db : "testdb"}])
```

5.增加角色

```shell
use testdb
db.grantRolesToUser("userlocal",[{role:"udf_readWrite",db:"testdb"}])
```

6.修改角色权限

```shell
use testdb
db.updateRole('udf_readWrite',
{
    privileges: 
        [{ 
        resource: { db: "testdb", collection: "" }, 
        actions: [ "update", "insert", "remove", "createCollection", "renameCollectionSameDB", "dropCollection", "createIndex", "dropIndex" ] 
        }],    
    roles: [{"role": "read", "db": "testdb"}]
}
)
```

8.查看角色权限

```shell
use testdb
db.system.roles.find()
# 查看权限
use dbname
db.getRole( "udf_readWrite", { showPrivileges: true } )
# 查看角色
use dbname
show roles
```

> 运行状态

1.服务状态

```
db.serverStatus()
```

2.当前执行

```
db.currentOp()
```

3.杀死会话

```
db.killOp("opid")
```

4.实例连接数查询

```
var commandResult = db.adminCommand({ currentConn: 1 });

// 检查是否有结果以及结果是否是一个数组
if (commandResult['inprog']) {
    var aggregationResult = commandResult['inprog'].reduce(function (acc, doc) {
        var client = doc.client;

        // 提取冒号前缀
        var prefix = client.split(':')[0];

        // 初始化计数
        if (!acc[prefix]) {
            acc[prefix] = 0;
        }

        // 增加计数
        acc[prefix]++;

        return acc;
    }, {});

    // 转换为数组形式
    var resultArray = Object.keys(aggregationResult).map(function (prefix) {
        return { _id: prefix, count: aggregationResult[prefix] };
    });

    // 按计数降序排序
    resultArray.sort(function (a, b) {
        return b.count - a.count;
    });

    // 显示结果
    resultArray.forEach(function (result) {
        print(result._id + ": " + result.count);
    });
} else {
    print("Command did not return expected results.");
}

```


#### mongos集群备份

> BACKUP

```
wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel80-x86_64-100.5.0.tgz
```

1.备份指定库

```
mongodump --host 127.0.0.1 --port 20004 --username=dba --password=dba --authenticationDatabase admin -d testdb1 -o /root/mongosbakup
# ISODate数据类型过滤：-q '{"create_time": {"$gt": {"$date": "2023-09-29T00:00:01.000Z"}, "$lte": {"$date": "2023-10-15T00:00:01.000Z"}}}'
```

2.备份所有库

```
mongodump --host 127.0.0.1 --port 20004  -o /root/mongosbakup
```

3.备份指定集合

```
mongodump --host 127.0.0.1 --port 20004 -d testdb1 -c tb1 -o /root/mongosbakup
```

4.导出指定集合为json

```
mongoexport --host 127.0.0.1 --port 20004 -d testdb1 -c tb -o /root/mongosbakup/tb.json
```

> RESTORE

1.恢复指定库

```
mongorestore --host 127.0.0.1 --port 20004 --username=dba --password=dba --authenticationDatabase admin -d testdb1 --dir=/root/mongosbakup/testdb1
```

2.恢复所有库

```
mongorestore --host 127.0.0.1 --port 20004 /root/mongosbakup
```

3.恢复指定集合

```
mongorestore --host 127.0.0.1 --port 20004 -d testdb1 -c tb --dir=/root/mongosbakup/tb1.bson
```

4.导入指定集合

```
mongoimport --host 127.0.0.1 --port 20004 -d testdb1 -c tb --dir=/root/mongosbakup/tb.json
```

> 集合删数据释放空间

1.先备份部分
```
./mongodump --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col -q '{"time_res":{"$gt": {"$date": "2023-08-01T00:00:01.000Z"}, "$lte": {"$date": "2023-08-02T00:00:01.000Z"}}}' -o ./1
# ISO时间类型写法！！！下面是字符串比较
./mongodump --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col -q '{"time_res":{"$gte": "2023-08-02", "$lt": "2023-08-10"}}' -o ./2
./mongodump --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col -q '{"time_res":{"$gte": "2023-08-10", "$lt": "2023-08-20"}}' -o ./3
./mongodump --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col -q '{"time_res":{"$gte": "2023-08-20", "$lt": "2023-08-30"}}' -o ./4
./mongodump --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col -q '{"time_res":{"$gte": "2023-08-30", "$lt": "2023-09-10"}}' -o ./5
./mongodump --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col -q '{"time_res":{"$gte": "2023-09-10", "$lt": "2023-09-20"}}' -o ./6
./mongodump --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col -q '{"time_res":{"$gte": "2023-09-20", "$lt": "2023-09-30"}}' -o ./7
./mongodump --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col -q '{"time_res":{"$gte": "2023-09-30", "$lt": "2023-10-10"}}' -o ./8
```

2.改名
```
test_col --> test_col_20231012_bak
```

3.备份剩下的
```
./mongodump --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col_20231012_bak -q '{"time_res":{"$gte": "2023-10-10"}}' -o ./9
```
4.恢复插入
```
./mongorestore --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col --dir=./1/test_db/test_col.bson
./mongorestore --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col --dir=./2/test_db/test_col.bson
```

5.
```
./mongorestore --host xx.xx.xx.xx --port 30008 --username=root --password=xxxpas --authenticationDatabase admin -d test_db -c test_col --dir=./9/test_db/test_col_20231012_bak.bson
```
