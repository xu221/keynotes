#### MySQL事务并发控制
> 数据库内核月报202110-数据库系统 · 事物并发控制 · Two-phase Lock Protocol 
>
> 写得好！ http://mysql.taobao.org/monthly/2021/10/02/

1.普通读查询SELECT
```
SELECT * FROM t;
InnoDB 的快照读不加任何锁
一致性由 MVCC (undo log + Read View) 保证
```
2.SQL加意锁情况
| SQL                             | 行锁 | 表级意向锁   |
| ------------------------------- | -- | ------- |
| `SELECT`                        | 无  | 无       |
| `SELECT ... LOCK IN SHARE MODE` | S  | IS      |
| `SELECT ... FOR UPDATE`         | X  | IX      |
| `UPDATE`                        | X  | IX      |
| `DELETE`                        | X  | IX      |
| `INSERT`                        | X  | IX      |
| `LOCK TABLES t READ`            | —  | S       |
| `LOCK TABLES t WRITE`           | —  | X / SIX |

```
意向锁让「表锁 vs 行锁」的冲突判断从 O(N) 变成 O(1)
```

3.兼容矩阵
| 已持有 \ 请求 | IS | IX | S | X | SIX |
| -------- | -- | -- | - | - | --- |
| IS       | Y  | Y  | Y | N | N   |
| IX       | Y  | Y  | N | N | N   |
| S        | Y  | N  | Y | N | N   |
| X        | N  | N  | N | N | N   |
| SIX      | Y  | N  | N | N | N   |
