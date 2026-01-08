#### MySQL undo log
> 数据库内核月报202110-MySQL · 引擎特性 · 庖丁解InnoDB之UNDO LOG 
> 
> 写得好！ http://mysql.taobao.org/monthly/2021/10/01/


1.MVCC多版本并发控制 = Multi-Version Concurrency Control
```
1.innodb存储引擎每行记录的设计
DB_TRX_ID：记录最后一次修改该行数据的事务ID，递增唯一。
DB_ROLL_PTR：回滚指针，指向undo log中上一个版本记录，可以形成版本追溯链。

2.innodb存储引擎内存记录数据结构
Read View：每一个事务会拷贝生成自己的readview内存结构如下
+ creator_trx_id
+ 当前各个活跃线程的trx_id
+ 当前各个活跃线程的提交状态

3.查询数据
通过自己的trx_id与内存池中的数据页DB_TRX_ID开始比较；
通过DB_ROLL_PTR指针追溯undo log；
直到找到可见或已提交的undo版本。

4.undo日志
buffer pool data (now) : DB_ROLL_PTR->trx a,
undo for trx c         : undo version=trx b data, DB_ROLL_PTR->b,
undo for trx b         : undo version=trx a data, DB_ROLL_PTR->a,
undo for trx a         : undo version=insert flag
```
