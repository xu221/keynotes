#### xtrabackup物理备份

> 下载xtrabackup二进制包、安装qpress.rpm

| 配置           | 值    |
| -------------- | ----- |
| cpu            | 2核   |
| 表1            | 400MB |
| 表2            | 500MB |
| 表3            | 500MB |
| 数据文件总大小 | 1.4G  |



---

> **全量备份**

1.全备不压缩，并行度1

```shell
xtrabackup --defaults-file=/home/mysql/usr/local/mysql/conf/my8001.cnf \
--user=root \
--password='!qazxsw@' \
--host=127.0.0.1 \
--port=8001 \
--backup \
--throttle=30 \
--parallel=1 \
--ftwrl-wait-timeout=120 \
--ftwrl-wait-threshold=120 \
--ftwrl-wait-query-type=all \
--target-dir=/home/backups/1

# io限制300MB/s
```

2.全备不压缩，并行度2

```shell
xtrabackup --defaults-file=/home/mysql/usr/local/mysql/conf/my8001.cnf \
--user=root \
--password='!qazxsw@' \
--host=127.0.0.1 \
--port=8001 \
--backup \
--throttle=30 \
--parallel=2 \
--ftwrl-wait-timeout=120 \
--ftwrl-wait-threshold=120 \
--ftwrl-wait-query-type=all \
--target-dir=/home/backups/2
```

3.全备压缩，并行度2

```shell
xtrabackup --defaults-file=/home/mysql/usr/local/mysql/conf/my8001.cnf  \
--user=root \
--password='!qazxsw@' \
--host=127.0.0.1 \
--port=8001 \
--backup \
--throttle=30 \
--compress \
--compress-threads=2 \
--no-timestamp \
--parallel=2 \
--ftwrl-wait-timeout=120 \
--ftwrl-wait-threshold=120 \
--ftwrl-wait-query-type=all \
--target-dir=/home/backups/3
```

4.全备压缩流备份，并行度2

```shell
xtrabackup --defaults-file=/home/mysql/usr/local/mysql/conf/my8001.cnf  \
--user=root \
--password='!qazxsw@' \
--host=127.0.0.1 \
--port=8001 \
--backup \
--compress \
--compress-threads=2 \
--throttle=30 \
--stream=xbstream \
--parallel=2 \
--tmpdir=/tmp \
--ftwrl-wait-timeout=120 \
--ftwrl-wait-threshold=120 \
--ftwrl-wait-query-type=all \
> /home/backups/4
```



| 序号 | 耗时 | 最大写IO | 最大读IO | 最大cpu | 空间占用 |
| ---- | ---- | -------- | -------- | ------- | -------- |
| 1    | 17s  | 140MB/s  | 120MB/s  | 30%     | 1.4G     |
| 2    | 17s  | 192MB/s  | 164MB/s  | 30%     | 1.4G     |
| 3    | 11s  | 100MB/s  | 210MB/s  | 120%    | 485MB    |
| 4    | 10s  | 85MB/s   | 195MB/s  | 120%    | 485MB    |

---

> **增量备份**

```shell
# 增加参数incremental-lsn="to_lsn"
xtrabackup --backup --incremental-lsn
```

---

> **解压备份**

1.解压xbsteam

```shell
xbstream -x < back.xtream -C /放置指定目录
```

2.解压qp文件

xtrabackup2.1.4之前需要用如下命令解压qp文件
```shell
for bf in `find . -iname "*\.qp"`; do qpress -d $bf $(dirname $bf) && rm $bf; done
```

xtrabackup2.1.4之后
```shell
xtrabackup --decompress --target-dir='全备存储目录'
```

---


> **应用redo日志**

1.全备应用

```shell
xtrabackup --prepare --use-memory --target-dir='全备存储目录'
```

2.增备应用

```shell
1.xtrabackup --prepare --use-memory --apply-log-only --target-dir='全备存储目录'
2.xtrabackup --prepare --use-memory --apply-log-only --target-dir='全备存储目录' --incremental-dir='增备1存储目录'
3.xtrabackup --prepare --use-memory --apply-log-only --target-dir='全备存储目录' --incremental-dir='增备2存储目录'
4.xtrabackup --prepare --use-memory --target-dir='全备存储目录'
```

---

> **数据恢复**

在redo日志应用结束之后，全备存储目录内的文件可为mysqld使用

1.

```shell
shell> systemctl stop mysqld
shell> mv data databack 
shell> xtrabackup --defaults-file='' --copyback
shell> chown mysql:mysql ./data
shell> systemctl start mysqld
```

2.

```shell
shell> systemctl stop mysqld
shell> mv data databack 
shell> mv /backup ./data
shell> chown mysql:mysql ./data
shell> systemctl start mysqld
```

