#### MySQL组复制(MySQL Group Replication)

> 强一致MySQL集群确保数据安全，当主库宕机时，从库自动切为主库。
> 应用程序通过MySQL Router链接到下一个可用节点。

0.
```
# 根据本地情况，在不同服务器上部署三个MySQL 8.0实例，拓扑配置如下：
+------------------+
|  Application(s)  |
+------------------+
         |
         v
+------------------+
|  MySQL Router    |
+------------------+              
         |                    
         v
+----------------------------+
|           MGR              |
|  Node1     Node2     Node3 |
+----------------------------+

# 本地测试，三个实例端口为：
# 3306       3307      3308

```
1.部署MySQL 8.0数据库，可参考[MySQL 8.0部署](../MySQL运维脚本/mysql8.0_install.sh)，注意下面集群参数。
```
# MGR 集群名称，需保证集群内唯一且各节点一致
loose-group_replication_group_name="aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
# 启动时不自动启动 MGR（方便后续手动控制初始化等操作）
loose-group_replication_start_on_boot=off
# 本节点用于 MGR 通信的地址和端口
loose-group_replication_local_address= "127.0.0.1:33061"
# 集群各节点用于 MGR 通信的地址和端口列表，包含所有节点
loose-group_replication_group_seeds= "127.0.0.1:33061,127.0.0.1:33061,127.0.0.1:33061"
# 不进行集群初始化引导（除第一次初始化集群的节点外都设为 off）
loose-group_replication_bootstrap_group=off
```

2.登录每个节点Node，进行配置
```
MySQL >
# 创建复制用户和管理用户
SET SQL_LOG_BIN=0;
CREATE USER repl@'%' IDENTIFIED WITH BY 'xxx';
GRANT REPLICATION SLAVE ON *.* TO repl@'%';
CREATE USER dba@'%' IDENTIFIED BY 'yyy';
GRANT ALL on *.* to dba@'%' with grant option;
FLUSH PRIVILEGES;
CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='xxx' FOR CHANNEL 'group_replication_recovery';
SET SQL_LOG_BIN=1;

# 安装插件
INSTALL PLUGIN group_replication SONAME 'group_replication.so';
SHOW PLUGINS;

```

3.单主模式，选一个节点作为主执行
```
# 初始化集群开关group_replication_bootstrap_group
SET GLOBAL group_replication_bootstrap_group=ON;  
START GROUP_REPLICATION;
SELECT * FROM performance_schema.replication_group_members;
SET GLOBAL group_replication_bootstrap_group=OFF;
```
4.其他节点执行
```
START GROUP_REPLICATION;
# 如果是新搭建，两边GTID值不一致导致START 加入集群失败，可以用RESET MASTER;命令清空当前节点的binlog
# RESET MASTER;
SELECT * FROM performance_schema.replication_group_members;
```

5.部署MySQL Router

```
# 下载并自行解压
wget https://cdn.mysql.com//Downloads/MySQL-Router/mysql-router-8.0.40-linux-glibc2.12-x86_64.tar.xz
```
```
# 配置文件
vim sample_mysqlrouter.conf
# Copyright (c) 2018, 2024, Oracle and/or its affiliates.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2.0,
# as published by the Free Software Foundation.

# This program is designed to work with certain software (including
# but not limited to OpenSSL) that is licensed under separate terms,
# as designated in a particular file or component or in included license
# documentation.  The authors of MySQL hereby grant you an additional
# permission to link the program and your derivative works with the
# separately licensed software that they have either included with
# the program or referenced in the documentation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


# MySQL Router sample configuration
#
# The following is a sample configuration file which shows
# most of the plugins available and most of their options.
#
# The paths used are defaults and should be adapted based
# on how MySQL Router was installed, for example, using the
# CMake option CMAKE_INSTALL_PREFIX
#
# The logging_folder is kept empty so message go to the
# console.
#


# If no plugin is configured which starts a service, keepalive
# will make sure MySQL Router will not immediately exit. It is
# safe to remove once Router is configured.
[keepalive]
interval = 60


[DEFAULT]
# 日志文件存放的位置/目录
logging_folder=/mgrhome/softwares/router_mysql/logs
# MySQL Router插件的位置/目录
plugin_folder=/mgrhome/softwares/router_mysql/lib/mysqlrouter
# MySQL Router配置文件存放的位置/目录
config_folder=/mgrhome/softwares/router_mysql/conf
# MySQL Router运行时数据目录
runtime_folder=/mgrhome/softwares/router_mysql/run
# MySQL Router数据文件目录
data_folder=/mgrhome/softwares/router_mysql/data

[logger]
# MySQL Router日志级别
level = INFO
# 日志文件名称
filename = mysqlrouter.log
# 日志时间戳精度
timestamp_precision = second

# 主节点故障转移配置
[routing:basic_failover]
# To be more transparent, use MySQL Server port 3306
# 绑定IP地址
bind_address = 127.0.0.1
# 写节点的端口
bind_port = 7001
routing_strategy = first-available
# 模式为读写模式
mode = read-write
# 主节点地址：可以配置一个或多个，建议配置多个，因为主库有可能会宕机或切换，Router则会依次**顺序**查找
destinations = 127.0.0.1:3306,127.0.0.1:3307,127.0.0.1:3308

# 从节点负载均衡配置
[routing:secondary]
# 绑定IP地址
bind_address = 127.0.0.1
# 监听端口
bind_port = 7002
# 连接超时时间设置
connect_timeout = 3
# 最大连接数设置
max_connections = 1024
# 后端MySQL Server
destinations = 127.0.0.1:3307,127.0.0.1:3308
routing_strategy = round-robin
# 模式为只读模式
mode = read-only
```

```
# 创建相应目录
mkdir data
mkdir logs
mkdir conf
mkdir run
```

6.启动MySQL Router
```
/mgrhome/softwares/router_mysql/bin/mysqlrouter --config=/mgrhome/softwares/router_mysql/conf/mysqlrouter.conf &
```
```
shell:~ mysql -udba -p'yyy' -h127.0.0.1 -P7001
shell:~ mysql -udba -p'yyy' -h127.0.0.1 -P7002
```
