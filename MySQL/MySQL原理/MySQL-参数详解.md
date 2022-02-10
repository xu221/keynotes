#### MySQL服务参数详解
> 会话级别
max_heap_table_size 和 tmp_table_size 
```
两个参数决定了每个会话连接子查询或者游标可以占用的内部临时表，阈值为min(max_heap_table_size, tmp_table_size)。当小于这个阈值时，临时数据表为MEMORY表，超过时会落盘为MyISAM表。
```
> 服务级别
