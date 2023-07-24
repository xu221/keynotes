#### 利用pt-archiver归档数据到历史数据库

> 数据归档本质可以理解为迁移或删除，这里单论删除。删除要注意的点主要由MySQL主从架构决定：1、主库的IO写压力，binlog压力，内存大小压力等要求写入batch不能过大，避免各种资源不足。 2、batch过大会导致其他表的主从延迟，容易影响其他业务，所以一般取小batch作删除。那么迁移的注意点也类似。

1.安装pt工具包

```
地址：https://downloads.percona.com/downloads/percona-toolkit/3.3.1/binary/redhat/7/x86_64/percona-toolkit-3.3.1-1.el7.x86_64.rpm
yum install percona-toolkit-3.3.1-1.el7.x86_64.rpm
如果有依赖问题，需要解决perl包依赖
```

2.列出需要迁移的表

```
一般选择大数据量的表归档，例如
table1、
table2、
table3
```

3.在历史主机创建相同结构的库表

```
1.创建同版本数据库服务
2.启动配置文件中添加secure-file-priv=''
3.create database db_history       #创建历史库
3.create table table1_history(...);#创建不加任何索引约束的历史表
```

4.使用pt-archiver归档数据

![image-1](https://github.com/xu221/keynotes/blob/pictures/MySQL/%E5%A4%9A%E8%A1%A8%E8%BF%81%E7%A7%BB.png)


```
源数据库建议选择从库,以减少对主库业务的影响
```

如：迁移db1.table1==全表数据归档，每10000条记录做批量插入，不删除原表数据

```
pt-archiver \
--source h=ip1,P=3306,u=admin,p='xxx',D=db1,t=table1,A=utf8 \
--dest   h=ip2,P=3306,u=admin,p='xxx',D=db2,t=table2,A=utf8 \
--where '1=1' \
--txn-size 10000 --limit=10000 --progress 10000 --no-delete --bulk-insert
```

如：迁移db1.table2

...

5.迁移

```
一、制定测试计划，将所有需要归档的表按照计划归档
二、制定检查策略，检查历史库数据是否与源数据一致（通过业务SQL或者数量）
```

6.批量删除源数据（主库）

```
制定分批计划，在主库执行删除数据
for i in range(xx):
    delete from where timecolumn < '2021-01-01' limit 10000;
```

7.待归档数据删除完毕，检查数据空间是否回收

```
du -sh /data/*
df -h
```

8.利用pt-online-schema-change工具执行表空间回收

```
pt-online-schema-change  \
-uadmin -p'xxx' -h主库 --port=3306 --alter='engine="innodb"' \
--recurse=0 --execute D=db1,t=table1  -A utf8 --print
```

9.考虑将历史库数据库到出为文本SQL用作逻辑备份

```
mysqldump -u -p -h -P --set-gitd-purgerd=OFF --databases db1_history > db1_history.sql
mysqldump -u -p -h -P --set-gitd-purgerd=OFF --databases db2_history > db2_history.sql
mysqldump -u -p -h -P --set-gitd-purgerd=OFF --databases db3_history > db3_history.sql
```

```
注意历史库磁盘空间占用情况
```







