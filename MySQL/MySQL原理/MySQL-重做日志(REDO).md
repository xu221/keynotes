#### MySQL redo log
> 数据库内核月报202002-MySQL · 引擎特性 · 庖丁解InnoDB之REDO LOG 
>
> redolog作用于持久化内存数据，可实现数据库服务器崩溃后恢复正在执行的事务，已提交的写入数据页，未提交的回滚。
>
> 写得好！ http://mysql.taobao.org/monthly/2020/02/01/

1.redo log和binlog的实际应用
```
innodb_flush_log_at_trx_commit = 1
sync_binlog = 1
```

事务提交：

当一个事务提交时（`COMMIT`），MySQL 的 binlog 写入流程是这样的：

1. **事务执行阶段**

   * 修改 InnoDB 缓冲池中的数据页（dirty page），并写入 InnoDB redo log（prepare 阶段），并将redo log刷盘（`innodb_flush_log_at_trx_commit=1` 时）。

2. **写 binlog 缓存**

   * MySQL Server 层将事务对应的 SQL 事件写入 **binlog 缓存**（由session级变量binlog_cache_size控制，超过会写临时磁盘文件）。

3. **事务提交阶段**

   * 在 `COMMIT` 时：

     1. 把 session 的 binlog 缓存写入 **binlog 文件缓冲区**；
     2. **调用 fsync()** 将 binlog 刷入磁盘（是否立即执行由 `sync_binlog` 控制）；
     3. 通知 InnoDB 提交事务（redo log 标记为 commit）；
     4. 返回客户端 “COMMIT OK”。

崩溃恢复：

当服务器崩溃时，恢复过程扫描redo log：
| 项目                       | 是否可能短暂出现                | 崩溃恢复后结果    |
| ------------------------ | ----------------------- | ---------- |
| redo prepare + binlog 未写 | ✅ 可能                    | 回滚         |
| redo commit + binlog 已写  | ✅ 正常                    | 提交         |
| redo prepare + binlog 已写 | ✅ 可能                    | **恢复时补提交** |
