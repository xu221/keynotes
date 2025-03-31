#### 建库
```
-- 1.postgre
$ gsql -d postgres -p 15400
openGauss=# CREATE USER tc_dev PASSWORD 'xxx@!@#12';
openGauss=# CREATE DATABASE tc WITH ENCODING 'utf8' template = template0 dbcompatibility ='B' owner tc_dev;
openGauss=# GRANT ALL PRIVILEGES ON DATABASE tc TO tc_dev;
openGauss=# ALTER USER tc_dev set search_path to tc_dev;
```
```
-- 2.Please use the original role to connect B-compatibility database first, to load extension dolphin
gsql -d tc -p 15400
```
```
-- 3.tc_dev login
$ gsql -d tc -p 15400 -U tc_dev -h 127.0.0.1
tc=> CREATE SCHEMA tc_dev AUTHORIZATION tc_dev;
```
