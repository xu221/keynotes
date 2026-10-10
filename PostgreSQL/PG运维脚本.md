#### 记录一些linux脚本

1.备份
```
pg_dump -h 'xxxx' -U user -p 3433 -Fc xx > ./xx.dump
# Fc足够压缩，可能做到10倍
```

2.恢复
```
pg_restore -h 'xxxx' --no-owner --no-privileges -U user -p 3433 -d dbname -v ./xx.dump
# 云实例或者跨版本需要设置
# --no-owner → 不恢复对象所有者
# --no-privileges → 不恢复 GRANT/REVOKE 权限（ACL）
```

3.检查主从状态
```
SELECT pg_is_in_recovery();
SELECT * from pg_stat_replication; 
```

4.重建非slot的从库
```
1.pg_basebackup -h x.x.x.x -p 5432 -U repl -F p -P -v -X stream -R -D /data/pg10/datanew/
2.mv data databak
3.mv datanew data
4.chmod 700 /data/pg10/data
5.不需要修改配置文件，-R自动改好了
# 主从链接信息pg10在recovery.conf，pg14在postgresql.auto.conf
6.启动从库
```

