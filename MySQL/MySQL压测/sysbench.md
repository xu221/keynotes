#### sysbench

```
来源：
https://github.com/akopytov/sysbench
```

1.针对OceanBase分区表,在编译之前，修改./src/oltp_common.lua:
```
vim oltp_common.lua

···
CREATE TABLE sbtest%d(
  id %s,
  k INTEGER DEFAULT '0' NOT NULL,
  c CHAR(120) DEFAULT '' NOT NULL,
  pad CHAR(60) DEFAULT '' NOT NULL,
  %s (id, k)
) partition by hash(k) partitions 4 ]]
···
```

2.针对MySQL则直接编译即可:
```
```

3.压测SQL，同样在oltp_common.lua文件中:
```
local stmt_defs = {
   point_selects = {
      "SELECT c FROM sbtest%u WHERE id=?",
      t.INT},
   simple_ranges = {
      "SELECT c FROM sbtest%u WHERE id BETWEEN ? AND ?",
      t.INT, t.INT},
   sum_ranges = {
      "SELECT SUM(k) FROM sbtest%u WHERE id BETWEEN ? AND ?",
       t.INT, t.INT},
   order_ranges = {
      "SELECT c FROM sbtest%u WHERE id BETWEEN ? AND ? ORDER BY c",
       t.INT, t.INT},
   distinct_ranges = {
      "SELECT DISTINCT c FROM sbtest%u WHERE id BETWEEN ? AND ? ORDER BY c",
      t.INT, t.INT},
   index_updates = {
      "UPDATE sbtest%u SET k=k+1 WHERE id=?",
      t.INT},
   non_index_updates = {
      "UPDATE sbtest%u SET c=? WHERE id=?",
      {t.CHAR, 120}, t.INT},
   deletes = {
      "DELETE FROM sbtest%u WHERE id=?",
      t.INT},
   inserts = {
      "INSERT INTO sbtest%u (id, k, c, pad) VALUES (?, ?, ?, ?)",
      t.INT, t.INT, {t.CHAR, 120}, {t.CHAR, 60}},
}

```
4.sysbench启动测试

```
1.数据准备
sysbench /alidata1/xzl/sysbench-1.0.17/src/lua/oltp_read_write.lua \
--mysql-host='' \
--mysql-user='' \
--mysql-password='' \
--mysql-db=sysbenchtest \
--table-size=2000000 \
--tables=4 \
--threads=4  \
prepare
```
```
2.读写测试
sysbench /alidata1/xzl/sysbench-1.0.17/src/lua/oltp_read_write.lua \
--mysql-host='xxx.oceanbase.aliyuncs.com' \
--mysql-user='' \
--mysql-password='' \
--mysql-db=sysbenchtest \
--table-size=2000000 \
--tables=4 \
--threads=24  \
--report-interval=10 \
--time=180 run
```
5.压测结果记录
> 24线程

|                     | OB      | MySQL RDS |
| ------------------- | ------- | --------- |
| tps                 | 495.89  | 634.63    |
| qps                 | 9917.89 | 12692.54  |
| avg(ms)             | 48.38   | 37.81     |
| max(ms)             | 107.23  | 83.44     |
| 95th percentile(ms) | 61.08   | 48.34     |

> 48线程

|                     | OB       | MySQL RDS |
| ------------------- | -------- | --------- |
| tps                 | 986.82   | 1236.06   |
| qps                 | 19736.35 | 24721.30  |
| avg(ms)             | 48.62    | 38.82     |
| max(ms)             | 2044.30  | 128.68    |
| 95th percentile(ms) | 61.08    | 49.21     |
