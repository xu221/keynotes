#### 数据误删不要怕，快速回滚

> 参考：https://github.com/liuhr/my2sql，能用二进制包就用二进制包，简单快速无需编译。

1.条件
```
1.binlog格式必须为row,且binlog_row_image=full。
2.只能回滚DML,不能回滚DDL。
```

2.确定回滚SQL所处时间段的BINLOG
```
有各种方法：
1.如果是本地保留的binlogs,可以看每个binlog的修改时间或者参考-> MySQL运维脚本中追溯binlog时间段，以找到SQL所处binlog。
2.如果是RDS，假设binlog被备份收集了，那只能下载下来，进行本地化的binlog反解析回滚，下面会示例；如果是binlog还在线，没被收集为备份，那或许可以用工具直接进行处理(自动下载)。
```

3.回滚
```
# 假设在2024-03-13 18:23:00执行了delete删除全表testtb操作，并且记录在mysql-bin.000003。
 my2sql -user dba -password xx -host yy -port 3306 -mode file -local-binlog-file ./mysql-bin.000003 -start-file mysql-bin.000003 -sql delete -tables 'testtb' -work-type rollback -start-datetime "2024-03-13 18:20:00" -stop-datetime "2024-03-13 18:25:00" -output-dir ./
```

4.执行回滚语句
```
上述命令生成了rollback.0003.sql：
more rollback.0003.sql
INSERT XXX ;
INSERT XXX ;
```

