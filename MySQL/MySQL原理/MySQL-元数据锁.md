#### MySQL MDL
> 数据库内核月报202110-MySQL · 源码分析 · 常用SQL语句的MDL加锁源码分析 
>
> 先记录一下MDL锁的场景！ http://mysql.taobao.org/monthly/2018/02/01/

1.
```
元数据锁是服务器server层面的，行锁是引擎InnoDB层面的。
```

2.
```
DDL变更时，获取不到元数据锁，可能是被某些客户端线程不提交事务阻塞，用下面命令观察可疑线程。
SELECT
	*
FROM
	`PROCESSLIST` a
	INNER JOIN `INNODB_TRX` b ON a.id = b.trx_mysql_thread_id;
```
