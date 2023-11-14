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

#### mongos集群备份

> BACKUP

```
wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-rhel80-x86_64-100.5.0.tgz
```

1.备份指定库

```
mongodump --host 127.0.0.1 --port 20004 --username=dba --password=dba --authenticationDatabase admin -d testdb1 -o /root/mongosbakup
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

