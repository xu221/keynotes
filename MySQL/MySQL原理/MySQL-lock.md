#### MySQL锁与事务的并发性

> 聊聊事务隔离级别和锁

1.InnoDB引擎的事务隔离级别

| 隔离级别            | 说明                                                         |
| ------------------- | ------------------------------------------------------------ |
| READ UNCOMMITTED    | 事务内能读取还未提交的数据                                   |
| READ COMMITTED(RC)  | 事务内能读取刚提交的数据，最新快照                           |
| REPEATABLE READ(RR) | 事务内数据可重复读，避免在数据区间插入和修改数据，事务开始时刻快照 |
| SERIALIZABLE        | 事务串型执行                                                 |

```
不同的隔离级别的读由多版本机制实现，而写由内存中锁结构实现。
比如：
多版本机制：undo保留还在用的数据版本
锁：RR间隙锁+记录锁、RC记录锁
```



2.InnoDB数据存储结构

+ 聚簇索引：由(主键、记录)生成的B+树
+ 二级索引：由(索引列1、索引列2、...、 主键值)生成的B+树，分唯一约束索引和无约束普通索引



3.锁结构（类型+模式）

类型：

+ 记录锁(record lock but not gap)：索引树上的叶子加锁
+ 间隙锁(gap lock)：索引树上的叶子区间加锁( a, b )
+ next-key锁(record lock)：形式为左开右闭( a, b ]，在特定情况下退化为记录锁或间隙锁

模式：

+ 读锁：S
+ 写锁：X



4.加锁原理

+ 锁加在索引树上 

+ 锁最终落到聚簇索引树上



5.加写锁：锁模式为X

RR：

---------

```
精确查询加锁规则：
搜寻索引树使用next-key加锁算法，若具有唯一约束，命中结果退化为使用记录锁，未命中退化为在叶子区间加间隙锁。
```

+ begin;update test_lock set random_col = 'c_new' where id = 3;聚簇索引命中

> 聚簇索引树记录锁(id=3)

+ begin;update test_lock set random_col = 'b_new' where id = 2;聚簇索引未命中

> 聚簇索引树间隙锁(1, 3)

+ begin;update test_lock set random_col = 'c_new' where unique_col = 3;唯一索引命中

> 聚簇索引树记录锁(id=3)+唯一索引树记录锁(unique_col=3)

+ begin;update test_lock set random_col = 'b_new' where unique_col = 2;唯一索引未命中

> 唯一索引树间隙锁(1, 3)

```
范围查询加锁规则：
搜寻索引树使用next-key加锁算法，命中结果默认使用记录锁和间隙锁( a,b ]，未命中退化为在叶子区间加间隙锁。
注：MySQL8.0.18以前的版本中，在RR可重复读级别下，索引上的范围查询，需要访问到不满足条件的第一个值为止。
```

+ begin;update test_lock set random_col = 'cd_new' where nonunique_col = 3;  普通索引命中

> 普通索引树next-key锁( 1, 3 ],( 3, 3 ],( 3, 5 )+聚簇索引树记录锁(id=3，4)

+ begin;update test_lock set random_col = 'b_new' where nonunique_col = 2;  普通索引未命中

> 普通索引树next-key退化为间隙锁( 1, 3 )

+ begin;update test_lock set random_col = 'all4' where id < 5; 主键范围查询

> 聚簇索引树next-key锁( -∞, 1 ],( 1, 3 ],( 3, 4 ],( 4, 5 ]

+ begin;update test_lock set random_col = 'all4' where nonunique_col <= 4; 普通索引范围查询

> 普通索引树next-key锁( -∞, 1 ],( 1, 3 ],( 3, 3 ],( 3, 5 ]+聚簇索引树记录锁(id=1，3，4，5)

```
全表遍历加锁规则：
从头开始搜寻聚簇索引树，使用next-key加锁算法，在每条记录加( a,b ]，无论是否查到结果，等于表锁。
```

+ begin;update test_lock set random_col = 'all4' where normal_col = 4;非索引条件查询

> 全表锁，无论是否命中

+ begin;update test_lock set random_col = 'all4' where normal_col = 4 limit 1; 非条件查询加limit

> 由于limit短路了搜寻范围，所以加锁为聚簇索引树next-key锁( -∞, 1 ],( 1, 3 ],( 3, 4 ]



RC

----

```
加锁规则：遍历各个索引树，给找到得结果加记录锁，未命中不加锁。
```



6.锁监控

+ 当事务获得锁时，部分信息将展现在innodb status里，用SET GLOBAL innodb_status_output_locks=ON开启更详细的监控。

```mysql
mysql > show eninge innodb status\G;
...
RECORD LOCKS space id 143 page no 6 n bits 384 index PRIMARY of table `dtadb`.`test_lock` trx id 1800698 lock_mode X locks rec but not gap
# 在聚簇索引PRIMARY上加记录锁，模式为写锁
...
RECORD LOCKS space id 143 page no 5 n bits 1272 index idx2 of table `dtadb`.`test_lock` trx id 1800701 lock_mode X locks gap before rec
# 在二级索引idx2上加间隙锁，模式为写锁
...
RECORD LOCKS space id 143 page no 5 n bits 1272 index idx2 of table `dtadb`.`test_lock` trx id 1800701 lock_mode X
# 在二级索引idx2上加next-key锁，模式为写锁
```





7.根据锁模式兼容矩阵判断事务阻塞

现在已经知道了事务的加锁情况，在并发下，每个事务中的修改数据语句都可能诱发在索引上加锁。当一个事务持有了索引上的某区间锁，另一个事务期望也拥有该区间内的锁，此时需要根据锁模式的兼容矩阵判断，是否能同时持有两把锁，如果不能，后面的事务将出现阻塞情况。更严重的是，每个事务中持有多个区间的锁，当在不同区间互相阻塞时，形成死锁，虽然MySQL具有死锁回退机制，但无疑限制了并发性能。

| type   | 记录 S | 记录 X | GAP X  |
| ------ | ------ | ------ | ------ |
| 记录 S | 兼容   | 不兼容 | 无     |
| 记录 X | 不兼容 | 不兼容 | 不兼容 |
| GAP X  | 无     | 不兼容 | 兼容   |

+ 对结果持有读锁的事务不阻塞其他事务期望持有另一个读锁
+ 对结果持有间隙锁的事务不阻塞其他事务期望持有另一个间隙锁



8.判断锁等待的指标

```
show global status like 'Innodb_row_lock_waits';事务等待锁的次数
show global status like 'Innodb_row_lock_time';事务等待持有锁的总时间(毫秒)
show global status like 'innodb_row_lock_time_max'; #innodb行锁最大等待时间（毫秒）
show global status like 'Innodb_row_lock_time_avg'; #innodb行锁平均等待时间（毫秒）
```

9.举几个例子

一、RR：索引未命中导致间隙锁

```
create table t1 (a int primary key ,b int);
insert into t1 values (1,2),(2,3),(3,4),(11,22);
```

| session1                                                     | session2                                               |
| ------------------------------------------------------------ | ------------------------------------------------------ |
| begin;                                                       | begin;                                                 |
| select * from t1 where a = 5 for update;聚簇索引树间隙锁(3,11) |                                                        |
|                                                              | select * from t1 where a = 5 for update;间隙锁相互兼容 |
| insert into t1 values (4,5); (block,等待session2)            |                                                        |
|                                                              | insert into t1 values (4,5); (等待session1,死锁)       |

+ 当查询未命中时，RR隔离级别加间隙锁，当索引值间断越大，锁间隙空间越大。

二、RR：查询同一时刻的数据

```
两张表：账户、账单(实时更新)
想要校对某一时刻的信用上限、账单事项与余额，采用可重复读隔离级别的查询是基于当前的快照，具备时间一致性。若需要更新信用上限，则根据不同的索引条件，事务会加不同范围的锁。
```

三、RC：加锁过程

```
RC隔离级别的范围扫描查询时，会在未命中的记录上有个快速加锁解锁的过程，速度极快，但当该类查询并发性提高时，锁的开销大大增加了CPU的负载。
```

四、Insert into select

```
RR隔离级别下加锁类似select for update为事务开始快照读；RC隔离级别下为最新快照读，所以不加锁。
```

五、Insert

```
插入意向锁模式为X：
情况一：没有锁阻塞，直接插入，且在各个索引树上加上该记录的写锁
情况二：存在间隙锁，阻塞等待
情况三：存在记录则出现duplicate key错误
情况四：insert ... on duplicate key update将在修改的记录加next-key lock
情况五：自增列具有自增特性，互相阻塞保证序列递增
```



10.总结

```
分析表的所有查询SQL，判断是否存在一定程度的加锁冲突
```



