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
