#### MySQL ONLINE DDL
> 数据库内核月报202103-MySQL · 源码阅读 · 白话Online DDL
> 
> 写得好！ http://mysql.taobao.org/monthly/2021/03/06/

```
关于MySQL原生的COPY方式，参看上述文章段落(各版本支持)，在不支持INPLACE列，同样是不支持并发DML的，所以原生DDL的COPY算法是会阻塞查询的。
```

```
关于pt-osc工具，本质是创建新表，在触发器之后，可以允许原表的DML，同时进行类似COPY算法的数据复制，但它过程中是不阻塞查询的。
（关于触发器增量与全量数据一致性逻辑可以自行分增删改方式理解一下） 

关于gh-ost工具，本质是利用binlog增量同步数据，相比触发器，触发器方面存在一些问题：
Triggers, overhead: 触发器是用存储过程的实现的，就无法避免存储过程本身需要的开销。
Triggers, locks: 增大了同一个事务的执行步骤，更多的锁争抢。
Trigger based migration, no pause: 整个过程无法暂停，假如发现影响主库性能，停止 Online DDL，那么下次就需要从头来过。
Triggers, multiple migrations: 他们认为多个并行的操作是不安全的。
Trigger based migration, no reliable production test: 无法在生产环境做测试。
Trigger based migration, bound to server: 触发器和源操作还是在同一个事务空间。
```

```
所以，在各版本不支持ONLINE DDL的场景下，使用pt-osc或者gh-ost，其他场景选择原生ONLINE DDL(INPLACE)似乎是合适的？
特殊场景一：当数据库存在主从拓扑时，请注意原生ONLINE DDL为一个整体，故而从库会存在一个DDL执行时间的延迟，如果是支持并行复制，那对其他表的延迟并不明显；否则整个从实例将会受到影响。
特殊场景二：当数据库负载较高，cpu或者IO接近瓶颈时，开源工具能够设置chunksize大小，可以避免负载打满，而原生ONLINE DDL可能会让实例业务运行缓慢。
特殊场景三：当该表写请求非常大或者每一行记录数据很大，存在写压力时，gh-ost可能永远也无法在最后一步切换表名。
```
![image-1](https://github.com/xu221/keynotes/blob/pictures/MySQL/ONLINEDDL.png)


```
MySQL的InnoDB引擎参数innodb_online_alter_log_max_size控制执行期间的增量日志。
```

```
关于修改字符集，都是全表加只读锁，选择无锁变更工具执行。
ALTER TABLE `sbtest1` MODIFY COLUMN `pad` CHAR(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '修改字段默认字符集';
ALTER TABLE `sbtest1` CONVERT TO CHARACTER SET utf8mb4 COLLATE UTF8MB4_UNICODE_CI COMMENT '修改表默认字符集';
ALTER TABLE `sbtest1` CHANGE `pad` `pad` CHAR(60) CHARACTER SET utf8mb4 COLLATE UTF8MB4_UNICODE_CI COMMENT '修改字段默认字符集';
```

```
无论执行什么样的DDL时，在一个新的窗口刷新检查SHOW FULL PROCESSLIST(SELECT * FROM information_schema.processlist WHERE db = 'dbx_00' AND state like 'Waiting for table %';)是有必要的，
发现正常会话执行SQL等待某些锁时（通常出现在DDL快要结束，变更表名时争夺元数据锁），能及时KILL DDL会话或者KILL慢查询以便让DDL正常结束。
```
