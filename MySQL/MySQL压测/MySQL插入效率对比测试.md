#### MySQL插入效率对比

> 通过以下简单的脚本对比三种数据变更效率。

```
date
mysql -ux21 -p'******' -h127.0.0.1 -Dtest < sss.sql
date
```

1.单条SQL自动提交

```
INSERT INTO tb values (0, 777);
INSERT INTO tb values (1, 777);
INSERT INTO tb values (2, 777);
INSERT INTO tb values (3, 777);
...
INSERT INTO tb values (10000, 777);
```

2.事务批量提交

```
begin;
INSERT INTO tb values (0, 777);
INSERT INTO tb values (1, 777);
INSERT INTO tb values (2, 777);
INSERT INTO tb values (3, 777);
...
INSERT INTO tb values (10000, 777);
commit;
```

3.BATCH插入

```
INSERT INTO tb8 values (0, 777),
 (1, 777),
 (2, 777),
 (3, 777),
 ...
 (10000, 777);
```

| 方式 | 耗时   | 配置                   |
| ---- | ------ | ---------------------- |
| 1    | 60s    | 阿里云ECS1C2G,高效云盘 |
| 2    | 2s     | 阿里云ECS1C2G,高效云盘 |
| 3    | 1s以内 | 阿里云ECS1C2G,高效云盘 |





