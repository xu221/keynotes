#### ClickHouse数据库
> ClickHouse可以在任何具有x86_64，AArch64或PowerPC64LE CPU架构的Linux，FreeBSD或Mac OS X上运行。
> 官方预构建的二进制文件通常针对x86_64进行编译，并利用SSE 4.2指令集，因此，除非另有说明，支持它的CPU使用将成为额外的系统需求。下面是检查当前CPU是否支持SSE 4.2的命令:
>
> ```
> $ grep -q sse4_2 /proc/cpuinfo && echo "SSE 4.2 supported" || echo "SSE 4.2 not supported"
> ```
>
> 要在不支持SSE 4.2或AArch64，PowerPC64LE架构的处理器上运行ClickHouse，应该通过适当的配置调整从源代码构建ClickHouse。

1.CentOS、RedHat发行版安装官方预编译rpm包

```
yum install yum-utils
rpm --import https://repo.clickhouse.tech/CLICKHOUSE-KEY.GPG
yum-config-manager --add-repo https://repo.clickhouse.tech/rpm/stable/x86_64
```

```
yum install clickhouse-server clickhouse-client
```

2.前台启动

```
chown -R clickhouse:clickhouse /var/lib/clickhouse/
chown -R clickhouse:clickhouse /var/log/clickhouse-server/
sudo -u clickhouse clickhouse-server --config-file=/etc/clickhouse-server/config.xml
```

3.本地登陆并创建MySQL复制库

```
mysql>  create database clicktest; 
clickhouse-client
vm3 :) CREATE DATABASE mysql_db ENGINE = MySQL('127.0.0.1:8001', 'clicktest', 'root', '!qazxsw@')
```

4.导入Star Schema Benchmark数据集到clickhouse

```
mysql> 
CREATE TABLE customer
(
        C_CUSTKEY       int(11) primary key,
        C_NAME          varchar(32),
        C_ADDRESS       varchar(32),
        C_CITY          varchar(32),
        C_NATION        varchar(32),
        C_REGION        varchar(32),
        C_PHONE         varchar(20),
        C_MKTSEGMENT    varchar(32)
);
#此时clickhouse应该具有mysql_db.customer库表
```

```
wget https://github.com/vadimtk/ssb-dbgen/archive/master.zip
unzip ssb-dbgen-master.zip
cd ssb-dbgen-master
make
```

```
创建customer数据脚本，生成customer.tbl
./dbgen -s 10 -T c
# -s 1000将会生成60亿行数据
```

```
clickhouse-client --query "INSERT INTO mysql_db.customer FORMAT CSV" < customer.tbl
# 此时若出现MySQL server has gone away，应适当提高max_allowed_packet 
```

5.MySQL也同步了相关数据

```
mysql> select count(*) from customer;
+----------+
| count(*) |
+----------+
|   300000 |
+----------+
1 row in set (3.19 sec)
```

6.查询性能比较(同一个服务器)

```
1.select C_CITY,count(*) from customer group by C_CITY;
```

| MySQL | clickhouse |
| ----- | ---------- |
| 4.13s | 2.492s     |

```
2.select C_CITY,count(*) from customer group by C_CITY order by count(*);
```

| MySQL | clickhouse |
| ----- | ---------- |
| 4.67s | 2.86s      |

```
3.select C_CITY,C_REGION,count(*) from customer group by C_CITY,C_REGION order by count(*);
```

| MySQL | clickhouse |
| ----- | ---------- |
| 5.78s | 2.94s      |

```
4.select C_CITY,C_NATION,C_REGION,count(*) from customer group by C_CITY,C_NATION,C_REGION order by count(*);
```

| MySQL | clickhouse |
| ----- | ---------- |
| 6.21s | 2.993s     |

