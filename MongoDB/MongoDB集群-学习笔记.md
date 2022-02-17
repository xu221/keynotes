## mongodb集群搭建

#### 实例部署

1.

```
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel80-5.0.3-rc0.tgz
```

2.

```
mkdir data
mkdir log
touch mongodb.conf
```

3.

```
cp -R mongodb mongodb1
cp -R mongodb mongodb2
cp -R mongodb mongodb3
```

4.

```
vim mongodb.conf
```

```
port=27017
dbpath=/root/services/mongodb-5.0.3-host1/data
logpath=/root/services/mongodb-5.0.3-host1/log/mongo.log
logappend=true
```

```
port=27018
dbpath=/root/services/mongodb-5.0.3-host2/data
logpath=/root/services/mongodb-5.0.3-host2/log/mongo.log
logappend=true
```

```
port=27019
dbpath=/root/services/mongodb-5.0.3-host3/data
logpath=/root/services/mongodb-5.0.3-host3/log/mongo.log
logappend=true
```

5.

```
/bin/mongod --config=mongodb.conf --fork
```

#### 副本集构建

1.新增配置

```
vim mongodb.conf
# add
bind_ip=127.0.0.1
shardsvr=true
directoryperdb=true
replSet=replicamg
```

2.重启三个mongodb实例

```
/root/services/mongodb-5.0.3-host1/bin/mongod --shutdown --config=/root/services/mongodb-5.0.3-host1/mongodb.conf
```

```
/root/services/mongodb-5.0.3-host1/bin/mongod --config=/root/services/mongodb-5.0.3-host1/mongodb.conf --fork
/root/services/mongodb-5.0.3-host2/bin/mongod --config=/root/services/mongodb-5.0.3-host2/mongodb.conf --fork
/root/services/mongodb-5.0.3-host3/bin/mongod --config=/root/services/mongodb-5.0.3-host3/mongodb.conf --fork
```

3.登录其一实例

```
mongo 127.0.0.1:27017
```

4.初始化并增加副本节点

```
> rs.initiate()
{
	"info2" : "no configuration specified. Using a default configuration for the set",
	"me" : "127.0.0.1:27017",
	"ok" : 1
}
replicamg:PRIMARY> 
replicamg:PRIMARY> rs.add("127.0.0.1:27018")
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1631601711, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1631601711, 1)
}
replicamg:PRIMARY> rs.add("127.0.0.1:27019")
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1631601739, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1631601739, 1)
}
```

5.检查副本集配置

```
replicamg:PRIMARY> rs.conf()
{
	"_id" : "replicamg",
	"version" : 3,
	"term" : 1,
	"members" : [
		{
			"_id" : 0,
			"host" : "127.0.0.1:27017",
			"arbiterOnly" : false,
			"buildIndexes" : true,
			"hidden" : false,
			"priority" : 1,
			"tags" : {
				
			},
			"slaveDelay" : NumberLong(0),
			"votes" : 1
		},
		{
			"_id" : 1,
			"host" : "127.0.0.1:27018",
			"arbiterOnly" : false,
			"buildIndexes" : true,
			"hidden" : false,
			"priority" : 1,
			"tags" : {
				
			},
			"slaveDelay" : NumberLong(0),
			"votes" : 1
		},
		{
			"_id" : 2,
			"host" : "127.0.0.1:27019",
			"arbiterOnly" : false,
			"buildIndexes" : true,
			"hidden" : false,
			"priority" : 1,
			"tags" : {
				
			},
			"slaveDelay" : NumberLong(0),
			"votes" : 1
		}
	],
	"protocolVersion" : NumberLong(1),
	"writeConcernMajorityJournalDefault" : true,
	"settings" : {
		"chainingAllowed" : true,
		"heartbeatIntervalMillis" : 2000,
		"heartbeatTimeoutSecs" : 10,
		"electionTimeoutMillis" : 10000,
		"catchUpTimeoutMillis" : -1,
		"catchUpTakeoverDelayMillis" : 30000,
		"getLastErrorModes" : {
			
		},
		"getLastErrorDefaults" : {
			"w" : 1,
			"wtimeout" : 0
		},
		"replicaSetId" : ObjectId("614043d73fff4e6800f288b5")
	}
}
```

6.设置从节点只读

```
replicamg:SECONDARY> db.getMongo().setSecondaryOk()
replicamg:SECONDARY> db.getMongo().setSecondaryOk()
```

7.查看集群状态

```shell
replicamg:SECONDARY> rs.status()
# 其中state值为1表示主节点，2为副本节点
```

8.运维操作

```shell
# 副本集信息
rs.status();
# 删除节点
rs.remove("ip:port");
# 增加节点
rs.add("ip:port");
# 增加仲裁节点
rs.addArb("ip:port");
# 节点降级,主从切换
rs.stepDown()
```

#### mongos分片集群

1.规划

| type                   | name           | port  | host      | replSet    |
| ---------------------- | -------------- | ----- | --------- | ---------- |
| config server(mongodb) | config server1 | 20001 | 127.0.0.1 | configmg   |
| config server(mongodb) | config server2 | 20002 | 127.0.0.1 | configmg   |
| config server(mongodb) | config server3 | 20003 | 127.0.0.1 | configmg   |
| shard(mongodb)         | shard1-host1   | 27017 | 127.0.0.1 | replicamg  |
| shard(mongodb)         | shard1-host2   | 27018 | 127.0.0.1 | replicamg  |
| shard(mongodb)         | shard1-host3   | 27019 | 127.0.0.1 | replicamg  |
| shard(mongodb)         | shard2-host1   | 27020 | 127.0.0.1 | replicamg1 |
| shard(mongodb)         | shard2-host2   | 27021 | 127.0.0.1 | replicamg1 |
| shard(mongodb)         | shard2-host3   | 27022 | 127.0.0.1 | replicamg1 |
| mongos                 | mongos-host1   | 20004 | 127.0.0.1 | /          |
| mongos                 | mongos-host2   | 20005 | 127.0.0.1 | /          |
| mongos                 | mongos-host3   | 20006 | 127.0.0.1 | /          |

2.config server集群搭建

> mongodb3.4以后需要构建config server副本集

```
# 配置如下
port=20001
dbpath=/root/services/mongodb-5.0.3-config-host1/data
logpath=/root/services/mongodb-5.0.3-config-host1/log/mongo.log
logappend=true
bind_ip=127.0.0.1
configsvr=true
directoryperdb=true
replSet=configmg
```

```
port=20002
dbpath=/root/services/mongodb-5.0.3-config-host2/data
logpath=/root/services/mongodb-5.0.3-config-host2/log/mongo.log
logappend=true
bind_ip=127.0.0.1
configsvr=true
directoryperdb=true
replSet=configmg
```

```
port=20003
dbpath=/root/services/mongodb-5.0.3-config-host3/data
logpath=/root/services/mongodb-5.0.3-config-host3/log/mongo.log
logappend=true
bind_ip=127.0.0.1
configsvr=true
directoryperdb=true
replSet=configmg
```

```shell
启动及初始化如上，略
rs.initiate()
rs.add("127.0.0.1:20002")
rs.add("127.0.0.1:20003")
```

3.shard集群部署

```
部署如上，略，注意replSet不为相同
```

4.mongos路由节点部署

```
# 配置如下
port=20004
logpath=/root/services/mongodb-5.0.3-mongos-host1/log/mongo.log
logappend=true
bind_ip=127.0.0.1
configdb=configmg/127.0.0.1:20001,127.0.0.1:20002,127.0.0.1:20003
# configmg为config server集群名称
```

```
port=20005
logpath=/root/services/mongodb-5.0.3-mongos-host2/log/mongo.log
logappend=true
bind_ip=127.0.0.1
configdb=configmg/127.0.0.1:20001,127.0.0.1:20002,127.0.0.1:20003
# configmg为config server集群名称
```

```
port=20006
logpath=/root/services/mongodb-5.0.3-mongos-host3/log/mongo.log
logappend=true
bind_ip=127.0.0.1
configdb=configmg/127.0.0.1:20001,127.0.0.1:20002,127.0.0.1:20003
# configmg为config server集群名称
```

```
...
```

5.启动每个mongos

```shell
/root/services/mongodb-5.0.3-mongos-host1/bin/mongos --config=/root/services/mongodb-5.0.3-mongos-host1/mongodb.conf --fork
```

6.登录其一mongos，给config server增加分片shard信息

```shell
./mongo 127.0.0.1:20004
sh.addShard("replicamg/127.0.0.1:27017,127.0.0.1:27018,127.0.0.1:27019")
sh.addShard("replicamg1/127.0.0.1:27020,127.0.0.1:27021,127.0.0.1:27022")
```

> 事实上每个mongos相互之间无联系，依赖于config server的统一数据

7.检查分片集群状态

```shell
mongos> sh.status()
--- Sharding Status --- 
  sharding version: {
  	"_id" : 1,
  	"minCompatibleVersion" : 5,
  	"currentVersion" : 6,
  	"clusterId" : ObjectId("614054aa3687a1d623f79c03")
  }
  shards:
        {  "_id" : "replicamg",  "host" : "replicamg/127.0.0.1:27017,127.0.0.1:27018,127.0.0.1:27019",  "state" : 1,  "topologyTime" : Timestamp(1631608486, 2) }
        {  "_id" : "replicamg1",  "host" : "replicamg1/127.0.0.1:27020,127.0.0.1:27021,127.0.0.1:27022",  "state" : 1,  "topologyTime" : Timestamp(1631608495, 1) }
  active mongoses:
        "5.0.3-rc0" : 1
  autosplit:
        Currently enabled: yes
  balancer:
        Currently enabled: yes
        Currently running: no
        Failed balancer rounds in last 5 attempts: 0
        Migration results for the last 24 hours: 
                No recent migrations
  databases:
        {  "_id" : "config",  "primary" : "config",  "partitioned" : true }
```

8.测试

```shell
use config
db.settings.save( { _id:"chunksize", value: 1 } )
use admin
db.runCommand({ enablesharding : "testdb1" })
db.runCommand({ shardcollection : "testdb1.tb", key:{id:1} })
use testdb1
for (var i = 1; i <= 20000; i++) db.tb.save({id:i,"test1":"testval1needverylongggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg"})
```

```shell
mongos> sh.status()        
{  "_id" : "testdb1",  
   "primary" : "replicamg1",  
   "partitioned" : true,  
   "version" : {  
                 "uuid" : UUID("77698f65-ded0-41ca-bfa7-95d9a5b7d278"),  
                 "timestamp" : Timestamp(1631608712, 36),  
                 "lastMod" : 1 
               } 
}
testdb1.tb
        shard key: { "id" : 1 }
        unique: false
        balancing: true
        chunks:
                replicamg	2
                replicamg1	2
        { "id" : { "$minKey" : 1 } } -->> { "id" : 2 } on : replicamg Timestamp(2, 0) 
        { "id" : 2 } -->> { "id" : 16386 } on : replicamg1 Timestamp(3, 1) 
        { "id" : 16386 } -->> { "id" : 23692 } on : replicamg1 Timestamp(2, 2)           
        { "id" : 23692 } -->> { "id" : { "$maxKey" : 1 } } on : replicamg Timestamp(3, 0) 
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

#### 停止mongodb集群

> 以不同顺序停止或启动分片群集的组件可能会导致成员之间的通信错误

1.禁用平衡器

```shell
sh.stopBalancer()
sh.getBalancerState()
```

2.停止mongos路由器

```shell
use admin
db.shutdownServer()
```

3.停止shard分片副本集

```shell
rs.status()
# 先停SECONDARY角色的节点
use admin
db.shutdownServer()
use admin
db.shutdownServer()
# 再停PRIMARY角色的节点
use admin
db.shutdownServer()
```

4.停止config server配置服务器

```shell
rs.status()
# 先停SECONDARY角色的节点
use admin
db.shutdownServer()
use admin
db.shutdownServer()
# 再停PRIMARY角色的节点
use admin
db.shutdownServer()
```

#### 启动mongodb集群

1.先启动config分片副本集

```shell
/root/services/ mongodb-5.0.3-config-host1/bin/mongod --config=/root/services/ mongodb-5.0.3-config-host1/mongodb.conf --fork
```

2.再启动shard分片副本集

```shell
/root/services/mongodb-5.0.3-host1/bin/mongod --config=/root/services/mongodb-5.0.3-host1/mongodb.conf --fork
/root/services/mongodb-5.0.3-host2/bin/mongod --config=/root/services/mongodb-5.0.3-host2/mongodb.conf --fork
/root/services/mongodb-5.0.3-host3/bin/mongod --config=/root/services/mongodb-5.0.3-host3/mongodb.conf --fork
```

```shell
/root/services/mongodb-5.0.3-host4/bin/mongod --config=/root/services/mongodb-5.0.3-host4/mongodb.conf --fork
/root/services/mongodb-5.0.3-host5/bin/mongod --config=/root/services/mongodb-5.0.3-host5/mongodb.conf --fork
/root/services/mongodb-5.0.3-host6/bin/mongod --config=/root/services/mongodb-5.0.3-host6/mongodb.conf --fork
```

3.最后启动mongos

```shell
/root/services/mongodb-5.0.3-mongos-host1/bin/mongos --config=/root/services/mongodb-5.0.3-mongos-host1/mongodb.conf --fork
```



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

> 分片集群相关:mongos登录

1.创建开启分片的数据库

```shell
sh.enableSharding("dbname", "primary_shard_id");
```

2.删除数据库

```shell
db.getSiblingDB("dbname").dropDatabase(); 
```



> 用户权限相关:mongodb,每个用户和角色都在各自数据库范围下



1.创建角色

```shell
use testdb
db.createRole
(    
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

