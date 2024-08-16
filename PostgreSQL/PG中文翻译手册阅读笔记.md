**PG中文翻译手册阅读笔记**

> PostgreSQL是一种*关系型数据库管理系统* （RDBMS），同时拥有丰富的技术插件

# 第一章 从头开始

1.安装
```
su - other_user
```

```
wget http://ftp.postgresql.org/pub/source/v13.0/postgresql-13.0.tar.bz2

tar xjvf postgresql*.bz2 #解压至一个目录

cd postgresql-13.0

./configure --prefix=/home/mypgdb-13.0 #拟安装至/home/mypgdb-13.0
# 这步可以配置一些环境，这里可以配置一下调试源码的参数。
# 可参考：http://www.postgres.cn/docs/12/install-procedure.html

make
make install
```

```
此时，已经得到postgresql服务器的二进制包，剩下的与MySQL类似，分为初始化数据库和启动。
```

```
# 初始化数据库
/home/mypgdb-13.0/bin/initdb -D /home/mypgdb-13.0/data
```

```
# 启动数据库服务
/home/mypgdb-13.0/bin/pg_ctl -D /home/mypgdb-13.0/data -l /home/mypgdb-13.0/logfile start
# logfile这里暂且理解为MySQL的error.log,记录服务运行情况。
```

2.测试

> 默认存在一个名称为 postgres 的数据库

```
/home/mypgdb-13.0/bin/psql postgres # 登录名叫postgres的库
```

```
postgres=# CREATE USER dbuser WITH PASSWORD 'password';  
CREATE ROLE          # 创建开发数据库用户
postgres=# CREATE DATABASE exampledb OWNER dbuser;
CREATE DATABASE      # 创建开发数据库
postgres=# GRANT ALL PRIVILEGES ON DATABASE exampledb to dbuser;
GRANT                # 给用户赋权限
postgres-# \q
exit
```

```
/home/mypgdb-13.0/bin/psql exampledb
# 支持基本的SQL语法
```
  <BR>
  
 
# 第二章 SQL语言

1.特别的字段类型

```
real : 存储单精度浮点数的类型
point : 地理位置,'(-194.0, 53.0)'
```
  <BR>
  
# 第三章 高级特性

1.窗口函数

2.表继承

```
# ONLY查询仅父表有的数据
CREATE TABLE cities (
  name       text,
  population real,
  altitude   int     -- (in ft)
);

CREATE TABLE capitals (
  state      char(2)
) INHERITS (cities);

SELECT name, altitude
    FROM ONLY cities
    WHERE altitude > 500;
```
  <BR>
  
# 四……十七. 跳过
  <BR>
  
# 第十八章 服务器设置和操作

1.Linux共享内存大小

```
vim /etc/sysctl.conf
$ sysctl -w kernel.shmmax=17179869184
$ sysctl -w kernel.shmall=4194304
```

2.Linux内存过量使用

```
Out of Memory: Killed process 12345 (postgres).
```

```
在某些情况中，降低内存相关的配置参数可能有所帮助，特别是shared_buffers、work_mem和hash_mem_multiplier
```

```
在其他情况中，允许太多连接到数据库服务器本身也可能导致该问题。在很多情况下，最好减小max_connections并且转而利用外部连接池软件
```

```
sysctl -w vm.overcommit_memory=2
用sysctl选择严格的过量使用模式来实现尽量不会“过量使用”内存。
```

3.Linux 大页

```
当PostgreSQL使用大量连续的内存块时，使用大页面会减少开销
```

4.关闭服务器

```
kill -INT `head -1 /usr/local/pgsql/data/postmaster.pid`
```

5.升级

6.使用SSH隧道端口转发给过程流量加密

```
ssh -L 63333:localhost:5432 joe@foo.com
or 
ssh -L 63333:db.foo.com:5432 joe@shell.foo.com
```

```
psql -h localhost -p 63333 postgres
```
  <BR>
  
# 第十九章 服务器配置
1.默认配置文件被保存在数据目录中：postgresql.conf

2.通过SQL修改参数   
```
ALTER SYSTEM : 提供了一种改变全局默认值的从SQL可访问的方法；它在功效上等效于编辑postgresql.conf
ALTER DATABASE : 允许针对一个数据库覆盖其全局设置。
ALTER ROLE :  允许用用户指定的值来覆盖全局设置和数据库设置。
```

```
SET configuration_parameter TO DEFAULT;
UPDATE pg_settings SET setting = reset_val WHERE name = 'configuration_parameter';
```

3.参数

```
shared_buffers (integer): 一个合理的shared_buffers开始值是系统内存的 25%
```

4.基于代价的清理延迟

5.WAL参数

6.归档与恢复

7.复制参数

8.优化器的选择

```
提高优化器选择的计划质量的更好的方式包括：
1.调整规划器的代价常数（见第 19.7.2 节）。
2.手工运行ANALYZE。
3.增加default_statistics_target配置参数的值。
4.以及使用ALTER TABLE SET STATISTICS增加为特定列收集的统计信息量。
```

9.优化器代价变量

```
seq_page_cost
random_page_cost
min_parallel_table_scan_size
min_parallel_index_scan_size
JIT编译
```

10.logging_collector

```
像程序一样的日志收集，包括各种定制，csv日志
```

11.锁管理

```
deadlock_timeout (integer)
```

12.开发者选项

```
请注意许多这些参数要求特殊的源代码编译标志才能工作
```
  <BR>
  
# 第二十章 客户端认证

1.客户端认证[客户防火墙]

```
pg_hba.conf文件
# 允许本地系统上的任何用户
# 通过 Unix 域套接字以任意
# 数据库用户名连接到任意数据库（本地连接的默认值）。
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     trust

# 相同的规则，但是使用本地环回 TCP/IP 连接。
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             127.0.0.1/32            trust 
```
  <BR>
  
# 第二十一章 数据库角色

1.角色ROLE

```
在PostgreSQL版本 8.1 之前，用户和组是完全不同的两种实体，但是现在只有角色
```

2.查看

```
SELECT rolname FROM pg_roles;
\du
```

3.默认角色superuser[除非在运行initdb时修改]

```
运行用户[x21]
```

4.删除角色

```
REASSIGN OWNED BY doomed_role TO successor_role;
DROP OWNED BY doomed_role;
-- 在每一个数据库中重复上述命令
DROP ROLE doomed_role;
```

5.默认角色

| 角色                     | 允许的访问                                                                                                     |
|--------------------------|----------------------------------------------------------------------------------------------------------------|
| **pg_read_all_settings**  | 读取所有配置变量，甚至是那些通常只对超级用户可见的变量。                                                       |
| **pg_read_all_stats**     | 读取所有的 `pg_stat_*` 视图并使用与扩展相关的各种统计信息，甚至是那些通常只对超级用户可见的信息。               |
| **pg_stat_scan_tables**   | 执行可能会在表上取得 `ACCESS SHARE` 锁的监控函数（可能会持锁很长时间）。                                       |
| **pg_monitor**            | 读取/执行各种不同的监控视图和函数。此角色是 `pg_read_all_settings`、`pg_read_all_stats` 和 `pg_stat_scan_tables` 的成员。 |
| **pg_signal_backend**     | 发信号到其他后端以取消查询或中止它的会话。                                                                     |
| **pg_read_server_files**  | 允许使用 `COPY` 以及其他文件访问函数从服务器上该数据库可访问的任意位置读取文件。                              |
| **pg_write_server_files** | 允许使用 `COPY` 以及其他文件访问函数在服务器上该数据库可访问的任意位置中写入文件。                            |
| **pg_execute_server_program** | 允许用运行该数据库的用户执行数据库服务器上的程序来配合 `COPY` 和其他允许执行服务器端程序的函数。           |


```
pg_monitor、pg_read_all_settings、pg_read_all_stats和pg_stat_scan_tables角色的目的是：
允许管理员能为监控数据库服务器的目的很容易地配置角色。
它们授予一组常用的特权，这些特权允许角色读取各种有用的配置设置、统计信息以及通常仅限于超级用户的其他系统信息
```

```
GRANT pg_signal_backend TO admin_user;
```
  <BR>
  
# 第二十二章 数据库角色

1.超级用户给别人建库

```
CREATE DATABASE dbname OWNER rolename;
```

2.通过模板建库

```
CREATE DATABASE dbname TEMPLATE template0;
# template0库是不应改变的标准库
# template1库是默认被继承的可变库
```

3.修改库级别的参数

```
ALTER DATABASE mydb SET geqo TO off;
ALTER DATABASE dbname RESET varname;
```

4.表空间

```
表空间一旦被创建，就可以被任何数据库使用。
表空间允许管理员根据数据库对象的使用模式来优化性能。
例如，一个很频繁使用的索引可以被放在非常快并且非常可靠的磁盘上，如一种非常贵的固态设备。
同时，一个很少使用的或者对性能要求不高的存储归档数据的表可以存储在一个便宜但比较慢的磁盘系统上。
```

```
CREATE TABLESPACE space1 LOCATION '/ssd1/postgresql/data';
CREATE TABLE foo(i int) TABLESPACE space1;
SET default_tablespace = space1;
CREATE TABLE foo(i int);
```

```
默认初始表空间：
pg_global表空间被用于共享系统目录。
pg_default表空间是template1和template0数据库的默认表空间
（并且，因此也将是所有其他数据库的默认表空间，除非被一个CREATE DATABASE中的TABLESPACE子句覆盖）
```
  <BR>
  
# 第二十三章 本地化

1.区域 initdb --locale=sv_SE
| 区域设置    | 描述                                              |
|-------------|---------------------------------------------------|
| **LC_COLLATE**   | 字符串排序顺序                                   |
| **LC_CTYPE**     | 字符分类（什么是一个字符？它的大写形式是否等效？） |
| **LC_MESSAGES**  | 消息使用的语言                                   |
| **LC_MONETARY**  | 货币数量使用的格式                               |
| **LC_NUMERIC**   | 数字的格式                                       |
| **LC_TIME**      | 日期和时间的格式                                 |

2.字符集 initdb -E UTF8

```
一个重要的限制是每个数据库的字符集必须和数据库的LC_CTYPE （字符分类）和LC_COLLATE （字符串排序顺序）设置兼容
```

3.客户端的字符集与服务端字符集不同时

```
客户端设置转换
SET CLIENT_ENCODING TO 'value';
SET NAMES 'value';
SHOW client_encoding;
RESET client_encoding;
```
  <BR>
  
# 第二十四章 日常数据库维护工作

> 任何数据库软件一样，PostgreSQL需要定期执行特定的任务来达到最优的性能

1.基础知识
```
PostgreSQL数据库要求周期性的清理维护,VACUUM命令出于几个原因必须定期处理每一个表:
1.释放数据被删除所占用的磁盘空间。
2.收集统计信息。
3.更新可见性映射，可以加速只用索引的扫描(覆盖查询)。
4.保护老数据不会由于事务ID回卷而丢失。
通常管理员应该努力使用标准VACUUM并且避免VACUUM FULL。
```

2.自动清理后台进程

```
PostgreSQL有一个可选的但是被高度推荐的特性autovacuum，它的目的是自动执行VACUUM和ANALYZE 命令。
```

3.重建索引

```
有一种低效的空间利用的可能性：
如果一个页面上除少量索引键之外的全部键被删除，该页面仍然被分配。
对于B树索引，一个新建立的索引比更新了多次的索引访问起来要略快， 因为在新建立的索引上，逻辑上相邻的页面通常物理上也相邻。
```

4.服务器日志轮转

```
通过在postgresql.conf里设置配置参数logging_collector为true的办法启用它
```
  <BR>
  
# 第二十五章 日常数据库维护工作

1.备份

```
1.SQL转储
2.文件系统备份
3.连续归档
```

```
转储
pg_dump dbname > dumpfile 
# -n schema 或-t table

恢复
psql dbname < dumpfile
# --single-transaction：有任何错误回滚
这条命令不会创建数据库dbname，你必须在执行psql前自己从template0创建（例如，用命令createdb -T template0 dbname）

管道
pg_dump -h host1 dbname | psql -h host2 dbname
```

```
pg_dump -j num -F d -f out.dir dbname
# 并行转储，它只能适合于“自定义”归档或者“目录”归档

pg_restore -j来以并行方式恢复一个转储
# 恢复
```

2.连续归档和时间点恢复（PITR）

```
pg_dump和pg_dumpall不会产生文件系统级别的备份，并且不能用于连续归档方案。
这类转储是逻辑的并且不包含足够的信息用于WAL重放。
```

```
1.建立WAL归档（类似MySQL二进制日志作用的 REDO LOG？）
vim postgresql.conf
archive_command = 'test ! -f /mnt/server/archivedir/%f && cp %p /mnt/server/archivedir/%f'  # Unix
archive_command = 'copy "%p" "C:\\server\\archivedir\\%f"'  # Windows
```

```
2.制作基础备份
pg_basebackup
0000000100001234000055CD.007C9330.backup
文件名的第二部分表明WAL文件中的一个准确位置

or

2.用低级API(命令)生成基础备份
```

```
3.使用一个连续归档备份进行恢复
一、停止服务器
二、将数据目录和表空间移走吧，如果不够空间，最少保存pg_wal子目录的内容，里面存在未被归档（应用、落盘）的日志
三、（基础备份）将最近的基础备份拷贝回来
四、（WAL备份）设定postgresql.conf(见第 19.5.4 节)中的恢复配置设置，并且在集簇数据目录中创建一个recovery.signal文件。
    （你可能还想临时修改pg_hba.conf来阻止普通用户在成功恢复之前连接。）
五、启动服务器。服务器将会进入到恢复模式并且进而根据需要读取归档WAL文件

vim postgresql.conf
restore_command = 'cp /mnt/server/archivedir/%f %p'
```

```
19.5.4 归档恢复
recovery_target_timeline、recovery_target_time 、recovery_target_xid 、recovery_target_lsn 
用于恢复的点
```
  <BR>
  
# 第二十六章 高可用、负载均衡和复制

1.高可用方案比较

| 特性                    | 共享磁盘故障转移 | 文件系统复制 | 预写式日志传送 | 逻辑复制           | 基于触发器的主-备复制 | 基于语句的复制中间件 | 异步多主控机复制 | 同步多主控机复制 |
|-------------------------|------------------|--------------|----------------|--------------------|------------------------|----------------------|------------------|------------------|
| **最通用的实现**        | NAS              | DRBD         | 内建流复制     | 内建逻辑复制，pglogical | Londiste，Slony          | pgpool-II            | Bucardo          |                  |
| **通信方法**            | 共享磁盘         | 磁盘块       | WAL            | 逻辑解码            | 表行                   | SQL                  | 表行             | 表行和行锁       |
| **不要求特殊硬件**      |                  | •            | •              | •                  | •                      | •                    | •                | •                |
| **允许多个主控机服务器** |                  |              |                | •                  |                        | •                    | •                | •                |
| **无主服务器负载**      | •                |              | •              | •                  |                        | •                    |                  |                  |
| **不等待多个服务器**    | •                |              | with sync off  | with sync off      | •                      |                      | •                |                  |
| **主控机失效将永不丢失数据** | •            | •            | with sync on   | with sync on       |                        | •                    |                  |          •         |
| **复制体接受只读查询**   |                  |              | with hot       | •                  | •                      | •                    | •                |          •         |
| **每个表粒度**          |                  |              |                | •                  | •                      |                      | •                |         •          |
| **不需要冲突解决**      | •                | •            | •              |                    | •                      |                      |                  | •                |


2.WAL文件备份
```
WAL文件是记录数据物理变更的日志，可以作用于数据库崩溃恢复。
通过某个时间点的全量备份加上定期的WAL日志文件备份，拷贝到其他服务器，实现存在一定传输文件延迟的容灾作用。
当主服务器宕机时，备份服务器通过全量备份启动数据库服务再应用WAL日志，恢复到最近时间点，对应用程序提供访问。
```

```
# 1.主库
vim postgresql.conf

archive_mode = on                         
archive_command = 'cp %p /path/to/archive/%f'     # 参考第二十五章
wal_level = replica                       # 设置 WAL 级别为 replica，以支持归档和复制
max_wal_senders = 3                       # 后备服务器数量
wal_keep_segments = 64                     # （流复制）后备服务器失联时，能够缓存WAL

# 2.Linux定时脚本
rsync -av /path/to/archive /backup/location/

# 3.后备库
pg_restore -d mydb /path/to/full-backup.dump
vim postgresql.conf
restore_command = 'cp /path/to/archive/%f %p'
recovery_target_time = 'YYYY-MM-DD HH:MI:SS'

# 4.重启后备库，自动同步到目标时间点
```

3.流复制
```
流复制允许一台后备服务器比使用基于文件的日志传送更能保持为最新的状态,即跳过了WAL传输过程，直接通过流量传输到后备服务器。
```

```
# 1.建立复制用户
后备服务器必须作为一个超级用户或一个具有REPLICATION特权的账户向主服务器认证
vim pg_hba.conf
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    replication     foo             192.168.1.100/32        md5

# 2.创建复制槽
# 复制槽的作用
1.防止 WAL 文件过早删除，直到被所有订阅的数据库接收处理为止。
2.管理复制进度
3.支持逻辑复制
4.在主数据库上创建物理复制槽：
postgres=# SELECT * FROM pg_create_physical_replication_slot('node_a_slot');
  slot_name  | lsn
-------------+-----
 node_a_slot |
4.在主数据库上创建逻辑复制槽：
postgres=# SELECT * FROM pg_create_logical_replication_slot('my_logical_slot', 'pgoutput');

# 3.从主库创建基础备份
pg_basebackup -h primary_host -D /var/lib/pgsql/data -U replicator -W -P --slot=node_a_slot --wal-method=stream

# 4.后备服务器设置
vim postgresql.conf
# 后备机要连接到的主控机运行在主机 192.168.1.50 上，
# 端口号是 5432，连接所用的用户名是 "foo"，口令是 "foopass"。
standby_mode = 'on'
primary_conninfo = 'host=192.168.1.50 port=5432 user=foo password=foopass'
primary_slot_name = 'node_a_slot'
trigger_file = '/tmp/promote_to_master'
# restore_command = 'cp /path/to/archive/%f %p'
# 如果设置了restore_command，可以通过完整的WAL日志更加快速的让该数据库追上主库。

# 4.启动后备服务器
```

```
trigger_file
# 主要作用是在需要故障切换（failover）或进行手动提升时，简化和自动化从数据库到主数据库的切换过程
touch /tmp/promote_to_master
# 当 PostgreSQL 从库（standby）检测到 trigger_file 并提升为主库（primary）时，它会立即终止恢复模式，并开始接受写操作。
# 此时，系统不会等待从库与主库完全同步到最新的 WAL 日志位置。
# 所以可能需要判断从库是否接收完全，或者接近
SELECT pg_last_xlog_receive_location(), pg_last_xlog_replay_location();
+ pg_last_xlog_receive_location() 返回从库最后接收到的 WAL 日志位置。
+ pg_last_xlog_replay_location() 返回从库最后重放的 WAL 日志位置。
# 更精细的控制通过参数recovery_target_lsn
```

4.级联复制

5.同步复制
```
流复制默认是异步的,如果主服务器崩溃，则某些已被提交的事务可能还没有被复制到后备服务器，这会导致数据丢失。
数据的丢失量与故障转移时的复制延迟成比例。

在主库设置同步复制：
vim postgresql.conf
synchronous_commit = on                    # 打开同步复制
synchronous_standby_names = 'FIRST 2 (s1, s2, s3)' # s1，s2优先
# synchronous_standby_names = 'ANY 2 (s1, s2, s3)' # 任意2个
# 如果存在s4，则s4默认为异步复制
```

```
复制视图pg_stat_replication
```

6.热备
```
#!/bin/bash

# 设置变量
PGDATA="/var/lib/pgsql/data"
BACKUPDIR="/path/to/backup"
LABEL="my_backup"

# 切换到 PostgreSQL 用户
sudo -u postgres psql -c "SELECT pg_start_backup('$LABEL');"

# 备份数据目录
rsync -av --exclude postmaster.pid $PGDATA $BACKUPDIR

# 结束备份
sudo -u postgres psql -c "SELECT pg_stop_backup();"

# 备份 WAL 文件
rsync -av $PGDATA/pg_wal $BACKUPDIR

echo "备份完成"
```

7.延迟参数
```
max_standby_archive_delay和max_standby_streaming_delay：  
它们定义了在 WAL 应用中的最大允许延迟。当应用任何新收到的 WAL 数据花费了超过相关延迟设置值时，在从库执行的冲突查询将被取消。
```

8.从库可读
```
hot_standby = on
```

  <BR>
  
# 第二十七章 监控数据库活动

1.服务进程
```
$ ps auxww | grep ^postgres
postgres  15551  0.0  0.1  57536  7132 pts/0    S    18:02   0:00 postgres -i
postgres  15554  0.0  0.0  57536  1184 ?        Ss   18:02   0:00 postgres: background writer
postgres  15555  0.0  0.0  57536   916 ?        Ss   18:02   0:00 postgres: checkpointer
postgres  15556  0.0  0.0  57536   916 ?        Ss   18:02   0:00 postgres: walwriter
postgres  15557  0.0  0.0  58504  2244 ?        Ss   18:02   0:00 postgres: autovacuum launcher
postgres  15558  0.0  0.0  17512  1068 ?        Ss   18:02   0:00 postgres: stats collector
postgres  15582  0.0  0.0  58772  3080 ?        Ss   18:04   0:00 postgres: joe runbug 127.0.0.1 idle
postgres  15606  0.0  0.0  58772  3052 ?        Ss   18:07   0:00 postgres: tgl regression [local] SELECT waiting
postgres  15610  0.0  0.0  58772  3056 ?        Ss   18:07   0:00 postgres: tgl regression [local] idle in transaction
# postgres: user database host activity
# 第一个主进程
# 后面5个后台进程
# 剩下都是客户端连接进程
```

2.动态统计视图
```
pg_stat_activity
pg_stat_replication
pg_stat_wal_receiver
pg_stat_subscription
pg_stat_ssl
pg_stat_gssapi
pg_stat_progress_create_index
pg_stat_progress_vacuum
pg_stat_progress_cluster

# pg_stat_activity -> wait_event
# wait_event -> 
# 查看等待事件
SELECT pid, wait_event_type, wait_event FROM pg_stat_activity WHERE wait_event is NOT NULL;
```

3.已收集统计信息的视图
```
类似MySQL的performance_schema里面的一些使用情况
```

4.查看锁
```
pg_locks
```
  <BR>
  

# 第二十八章  监控磁盘使用
```
在 PostgreSQL 中，TOAST（The Oversized-Attribute Storage Technique）表用于存储超大数据，特别是那些单行中包含非常大数据的情况，例如大型文本或二进制对象（BLOBs）。
TOAST 表的设计目的是为了处理和优化存储大数据，从而提高数据库性能和存储效率。
```

1.显示TOAST表：每个页通常都是 8K 字节
```SQL
SELECT relname, relpages
FROM pg_class,
     (SELECT reltoastrelid
      FROM pg_class
      WHERE relname = 'customer') AS ss
WHERE oid = ss.reltoastrelid OR
      oid = (SELECT indexrelid
             FROM pg_index
             WHERE indrelid = ss.reltoastrelid)
ORDER BY relname;

```

2.找到最大的表和索引
```SQL
SELECT relname, relpages
FROM pg_class
ORDER BY relpages DESC;
```
  <BR>
  
# 第二十九章 可靠性和预写式日志WAL
1.WAL检查点CHECKPOINT
```
服务器的检查点进程常常自动地执行一个检查点。
检查点在每checkpoint_timeout秒开始，或者在快要超过 max_wal_size时开始。 默认的设置分别是 5 分钟和 1 GB。

wal_keep_segments：wal_keep_segments + 1 个最近的 WAL 文件将总是被保留。

wal_buffers：XLogInsertRecord写入缓冲，XLogFlush刷出缓冲，我们应该通过修改配置wal_buffers的值来增加WAL缓冲区的数量。

commit_delay：指定了在事务提交时，服务器延迟多长时间才将事务日志写入磁盘。
这段延迟时间可以让多个事务的日志写入操作被组合在一起，以减少磁盘 I/O 操作的频率。这个参数只有在commit_siblings参数指定的最低并发事务数以上时才会生效，默认为0。
“由于commit_delay的目的是允许每次刷写操作的开销能够在并发提交的事务之间进行分摊（可能会以事务延迟为代价），在能够明智地选择该设置之前有必要对代价进行量化。
代价越高，在一定程度上commit_delay对于提高事务吞吐量的效果就越好。注意过高的commit_delay设置也很有可能增加事务延迟甚至于整个事务吞吐量都会受到影响。”

wal_debug在PostgreSQL编译时开启，将导致每次XLogInsertRecord和XLogFlush WAL调用都被记录到服务器日志。

在完成一个检查点并且刷写了日志文件之后，检查点的位置被保存在文件pg_control里。
```

2.WAL设置
```
WAL ~= Redo Log(MySQL)
WAL日志被存放在数据目录的pg_wal目录里
```
  <BR>
  
# 第三十章 逻辑复制
> 在 PostgreSQL 中，逻辑复制是一种允许将数据以逻辑的方式复制到另一台数据库服务器的功能。
> 与物理复制不同，逻辑复制只复制数据库中的特定表或特定类型的数据变化，并且目标数据库可以是非PostgreSQL的数据库。

以下是创建逻辑复制过程的步骤：

### 1.**确保数据库配置允许逻辑复制**
首先，确保PostgreSQL配置文件（通常是`postgresql.conf`）中包含以下设置：
   ```sql
   wal_level = logical
   max_replication_slots = 4
   max_wal_senders = 4
   ```

   - `wal_level` 设置为 `logical` 以启用逻辑复制。
   - `max_replication_slots` 和 `max_wal_senders` 设置的数值根据需要进行调整。

   另外，编辑 `pg_hba.conf` 文件以允许复制连接：

   ```text
   host    replication     replicator    192.168.0.100/24    md5
   ```

### 2. **创建复制用户**

   创建一个专门用于逻辑复制的用户：

   ```sql
   CREATE ROLE replicator WITH REPLICATION PASSWORD 'your_password' LOGIN;
   ```

### 3. **创建逻辑复制槽**

   在主数据库上创建一个逻辑复制槽（replication slot）：

   ```sql
   SELECT * FROM pg_create_logical_replication_slot('my_slot', 'pgoutput');
   ```

   - `my_slot` 是复制槽的名称。
   - `pgoutput` 是输出插件，用于处理逻辑复制。

### 4. **创建发布**

   在主数据库中创建一个发布（publish），指定要复制的表：

   ```sql
   CREATE PUBLICATION my_publication FOR TABLE my_table;
   ```

   - `my_publication` 是发布的名称。
   - `my_table` 是要复制的表。

   如果你想发布多个表，可以将它们列在 `FOR TABLE` 后，或者使用 `FOR ALL TABLES` 来发布所有表。

### 5. **在从数据库上创建订阅**

   在从数据库上创建一个订阅（subscription），连接到主数据库并订阅指定的发布：

   ```sql
   CREATE SUBSCRIPTION my_subscription
   CONNECTION 'host=192.168.0.100 port=5432 user=replicator password=your_password dbname=mydb'
   PUBLICATION my_publication;
   ```

   - `my_subscription` 是订阅的名称。
   - `CONNECTION` 是连接到主数据库的连接字符串。
   - `my_publication` 是主数据库中创建的发布。

### 6. **验证复制状态**

   你可以通过查询以下视图来检查复制状态：

   - 在主库上检查复制槽状态：

     ```sql
     SELECT * FROM pg_replication_slots;
     ```

   - 在从库上检查订阅状态：

     ```sql
     SELECT * FROM pg_stat_subscription;
     ```

### 7. **管理和监控**

   - 通过 `ALTER SUBSCRIPTION` 和 `ALTER PUBLICATION` 可以动态调整订阅和发布。
   - 通过 `DROP SUBSCRIPTION` 和 `DROP PUBLICATION` 可以删除订阅和发布。
   - 通过pg_stat_subscription可以看到运行中的复制链路。
  
这些步骤完成后，主数据库的指定表的数据变动将被实时复制到从数据库中。
逻辑复制可以灵活地用于跨不同版本的PostgreSQL数据库，甚至跨不同类型的数据库系统。

### 8. 注意事项

- **复制内容**：逻辑复制只复制表中的行级别的变更，这意味着它仅传输 INSERT、UPDATE 和 DELETE 操作所产生的数据变更。
- **DDL 变更**：任何与表结构相关的变更（例如创建新表、修改表结构、删除表等）不会通过逻辑复制传递到订阅端。
- **DDL 变更**：这意味着如果在主服务器上执行了 DDL 语句，订阅端的数据库不会自动更新这些变化。

为了在使用逻辑复制时处理 DDL 变化，你可以考虑以下几种方式：

1. **手动同步 DDL**：
   - 在主库执行 DDL 操作后，手动在从库上执行相同的 DDL 语句。这样可以确保从库的结构与主库保持一致。

2. **使用工具进行同步**：
   - 使用工具或脚本自动化同步 DDL 操作。例如，`pglogical` 是一个扩展，它支持逻辑复制并提供一些自动化工具来处理 DDL 变化，但也需要一些手动干预。

3. **使用外部工具**：
   - 使用外部工具如 `Liquibase` 或 `Flyway` 来管理数据库的迁移和版本控制，这样你可以在迁移时同时应用相同的 DDL 到多个数据库。


  <BR>
  
# 第三十一章 即时编译JIT

> JIT编译主要可以让长时间运行的CPU密集型的查询受益。

> 如果jit被设置为off或者没有JIT实现可用（例如因为服务器没有用--with-llvm编译），即便基于上述原则能带来很大的好处，JIT也不会被执行。

### 1. **检查 PostgreSQL 是否支持 JIT**

首先，确认 PostgreSQL 是否支持 JIT 编译功能。你可以使用以下 SQL 命令检查：

```sql
SHOW jit;
```

如果 PostgreSQL 支持 JIT，输出将是 `on` 或 `off`。

### 2. **在 PostgreSQL 配置文件中启用或禁用 JIT**

你可以通过修改 PostgreSQL 的配置文件 `postgresql.conf` 来设置 JIT。通常可以找到以下参数：

```ini
# 在 postgresql.conf 中
jit = on   # 开启 JIT（默认开启）
```

- 将 `jit` 设置为 `on` 启用 JIT 编译。
- 将 `jit` 设置为 `off` 禁用 JIT 编译。

修改配置文件后，需要重新启动 PostgreSQL 服务来使更改生效：

```bash
sudo systemctl restart postgresql
```

### 3. **在会话级别设置 JIT**

如果你不想全局设置 JIT，可以在会话级别启用或禁用 JIT。通过以下 SQL 语句可以控制当前会话的 JIT 设置：

```sql
SET jit = on;  -- 启用 JIT
SET jit = off; -- 禁用 JIT
```

### 4. **调整其他 JIT 相关参数**

PostgreSQL 还提供了一些与 JIT 相关的其他配置参数，你可以根据需要调整它们：

- `jit_above_cost`：仅当查询的计划成本超过这个值时，才启用 JIT。默认值为 100000。
- `jit_inline_above_cost`：仅当查询的计划成本超过这个值时，才启用内联（inline）JIT。默认值为 500000。
- `jit_optimize_above_cost`：仅当查询的计划成本超过这个值时，才启用 JIT 优化。默认值为 500000。

你可以在 `postgresql.conf` 中配置这些参数，也可以在会话中通过 `SET` 命令来动态调整它们。例如：

```ini
# 在 postgresql.conf 中
jit_above_cost = 100000
jit_inline_above_cost = 500000
jit_optimize_above_cost = 500000
```

或者在会话中设置：

```sql
SET jit_above_cost = 100000;
SET jit_inline_above_cost = 500000;
SET jit_optimize_above_cost = 500000;
```

### 5. **验证 JIT 的使用**

你可以通过执行一个复杂查询，并使用 `EXPLAIN (ANALYZE, VERBOSE, COSTS, BUFFERS, TIMING)` 来查看是否启用了 JIT 编译。

```sql
EXPLAIN (ANALYZE, VERBOSE, COSTS, BUFFERS, TIMING) SELECT * FROM your_table WHERE complex_condition;
```

在查询计划中，您将看到有关 JIT 的详细信息，例如是否启用了 JIT 编译以及哪些部分被 JIT 编译器优化。

  <BR>
  
# 第三十二章 回归测试


  <BR>
  
# 第三十三章 libpq - C 库


  <BR>
  
# 第三十四章  大对象
在 PostgreSQL 中，大对象（Large Objects, LOBs）用于存储超出常规数据类型大小限制的大数据，例如图像、音频、视频、文档等。
大对象提供了比常规字段更灵活的存储方式，可以存储多达几 GB 的数据。对于那些大得无法以一个整体处理的数据值 ，流式访问非常有用。

### 大对象的类型

PostgreSQL 支持两种主要类型的大对象：

1. **TOAST（The Oversized-Attribute Storage Technique）**：
   - 自动管理的方式，PostgreSQL 在需要时将表中的大字段（如 `TEXT`、`BYTEA`、`JSONB` 等）进行压缩和分块存储。
   - 用户不需要显式管理这些数据，PostgreSQL 会自动处理。支持1G。

2. **LOB API（Large Object API）**：
   - 明确管理的方式，用户通过 `lo_*` 函数显式地创建、读取、更新和删除大对象。这个方法适用于更大的数据，如二进制文件或多媒体文件。支持4T。

### 使用大对象 API（LOB API）

> 所有的大对象都存在一个名为pg_largeobject的系统表中。每一个大对象还在系统表pg_largeobject_metadata中有一个对应的项。

#### 1. **创建大对象**

你可以使用 `lo_create()` 函数创建一个新的大对象，并返回一个 OID（对象标识符），这个 OID 是你访问该对象的关键。

```sql
SELECT lo_create(0);
```

如果你提供 `0`，PostgreSQL 将自动分配一个 OID。你也可以指定一个特定的 OID。

#### 2. **写入数据到大对象**

为了写入数据，你需要打开大对象，然后使用 `lo_write()` 函数。首先使用 `lo_open()` 获取一个文件描述符，然后用 `lo_write()` 写入数据。

```sql
-- 获取一个文件描述符
SELECT lo_open(oid, 131072);  -- 131072 表示写入模式

-- 写入数据
SELECT lo_write(fd, 'your data');
```

#### 3. **读取大对象数据**

同样，使用 `lo_open()` 打开大对象后，使用 `lo_read()` 来读取数据。

```sql
-- 获取一个文件描述符
SELECT lo_open(oid, 262144);  -- 262144 表示读取模式

-- 读取数据
SELECT lo_read(fd, length);
```

#### 4. **删除大对象**

你可以使用 `lo_unlink()` 函数删除大对象。

```sql
SELECT lo_unlink(oid);
```

#### 5. **关闭大对象**

完成对大对象的操作后，应该关闭它以释放资源。

```sql
SELECT lo_close(fd);
```

### 示例：将文件存储为大对象

假设你有一个图像文件，并希望将其存储为 PostgreSQL 大对象：

```sql
-- 创建一个新的大对象
SELECT lo_create(0);

-- 假设 OID 返回 12345，打开并写入文件数据
\lo_import '/path/to/your/file.jpg' 12345;
```

然后，你可以从数据库中读取该文件：

```sql
-- 将大对象导出到文件
\lo_export 12345 '/path/to/exported/file.jpg';
```

### 适用场景

- **大型二进制数据**：当需要存储大型二进制文件（如图像、视频、音频）时，大对象是一个理想的选择。
- **细粒度控制**：如果你需要对大型数据进行分块处理，或者希望手动控制数据的读写操作，大对象 API 提供了这种能力。

### 注意事项

- **管理复杂性**：大对象 API 提供了更细粒度的控制，但也带来了更多的管理复杂性，如手动管理 OID。
- **垃圾收集**：删除大对象后，其存储空间不会立即被回收，必须定期运行 `VACUUM` 来回收这些空间。
- **性能**：对于小型数据，建议直接使用常规字段（如 `BYTEA`），因为它们更简单且通常更高效。


  <BR>
  
# 第三十五章  ECPG - C 中的嵌入式 SQL

 <BR>
  
# 第三十六章  信息模式
INFORMATION_SCHEMA

 <BR>
  
# 第三十七章  扩展 SQL

 <BR>
  
# 第三十八章  触发器
```
支持事件触发器，是全局的，且不能用纯SQL编写。捕捉DDL等。
```
 <BR>
  
# 第三十九章  事件触发器

 <BR>
  
# 第四十章  规则系统
```
视图和物化视图
```


 <BR>
  
# 第四十一章  过程语言
```
安装在数据库template1中的过程语言会被后续创建的数据库自动继承，因为template1中与过程语言相关的项会被CREATE DATABASE复制。
```

 <BR>
  
# 第四十二章  ~~SQL TCL PERL PYTHON过程


 <BR>
  
# 第四十六章  服务器编程接口

 <BR>
  
# 第四十七章  后台工作者进程

 <BR>
  
# 第四十八章  逻辑解码

```
逻辑解码是一种将对数据库表的所有持久更改抽取到一种清晰、易于理解的格式 的处理，
这种技术允许在不了解数据库内部状态的详细知识的前提下解释该格式。
可用于复制方案与审计。
```

 <BR>
  
# 其他
> http://www.postgres.cn/docs/12/index.html
