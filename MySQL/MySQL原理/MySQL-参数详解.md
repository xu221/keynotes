#### MySQL服务参数详解
> 会话级别
max_heap_table_size 和 tmp_table_size 
```
两个参数决定了每个会话连接子查询或者游标可以占用的内部临时表，阈值为min(max_heap_table_size, tmp_table_size)。当小于这个阈值时，临时数据表为MEMORY表，超过时会落盘为MyISAM表。
提高这两个值可以减少查询使用内部MyISAM临时表的概率，但同样地，当会话连接激增时，可能会导致内存占用问题。
```
> 内存池
```
|---------- young ---------|------ old ------|
 ^ LRU 头                   ^ LRU 中点

old ≈ 37%
young ≈ 63%

数据页old to young晋升规则：
1.一个 page 进入 old 区后，在 N 毫秒内被访问，不允许升到 young
SHOW VARIABLES LIKE 'innodb_old_blocks_time';
-- 默认 1000 ms，避免数据抽取污染
2.如果 page 已经在 young 区的前 1/4（最热区域），也不晋升到头部

```
> 热点内存计算
```
SHOW ENGINE INNODB STATUS;
...
young-making rate ≤ 1 / 1000              :   从LRU冷old数据页晋升到热young数据页链表头部，每1000次。
not young-making rate ≤  7 / 1000         :   统计上述1、2两个条件：数值大可能表示大批量数据抽取查询。
young rate >= 1 - 1 / 1000 - 7 / 1000     :   表示热数据收敛，绝大数都在young区。
...

这种热点数据计算= Modified db pages 28128 + Database pages 389374 * 0.63*0.25 ~= 1.2G
```
