#### git使用

1.创建中央代码仓库
```
git init --bare develop.git
```

2.初始化本地代码
```
cd mycodes
git init
git config --global user.email "x21@xxx.com"
git config --global user.name "x21"
git remote add origin /path/to/develop.git
```

3.推送本地代码到中央
```
git add code_project
git commit -m "Initial commit"
# 默认是本地的master分支
git push origin master
```

4.如何在新服务器拉取代码
> SSH协议，先配置好配置x21用户免密
```
git clone xzl@172.26.18.164:develop.git
cd develop
ls -la
drwxrwxr-x  4 dba dba 4096 May 15 15:44 .
drwx------  8 dba dba 4096 May 15 15:44 ..
drwxrwxr-x  8 dba dba 4096 May 15 15:44 .git
drwxrwxr-x 12 dba dba 4096 May 15 15:44 code_project
```

5.代码同步
> 假设有新代码被推送到中央代码仓库
```
# 客户端1
git add code_project
git commit -m "something modify"
git push origin master
```

```
# 客户端2
git pull origin master
# 验证即可
```

6.版本回退
```
# 回退到上一个版本
git reset --hard HEAD^
```
