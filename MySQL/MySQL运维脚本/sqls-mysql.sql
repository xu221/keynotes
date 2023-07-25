-- 批量查杀会话
SELECT CONCAT('kill ', id, ';') FROM information_schema.`PROCESSLIST` WHERE INFO LIKE 'SELECT wc.corp_id%' ;
SELECT db, USER, COUNT(*) FROM information_schema.processlist GROUP BY USER;
SELECT CONCAT('kill ',ID, ';') FROM information_schema.processlist WHERE db = 'interstellar_00' AND COMMAND='Sleep';

-- 统计数据库占用的磁盘空间
SELECT TABLE_SCHEMA AS DB_NAME, 
CONCAT(ROUND(SUM(DATA_LENGTH)/1024/1024/1024, 2), ' GB') AS 'DATA_SIZE', 
CONCAT(ROUND(SUM(INDEX_LENGTH)/1024/1024/1024, 2), ' GB') AS 'INDEX_SIZE'
FROM information_schema.tables
WHERE TABLE_SCHEMA NOT IN ('information_schema', 'mysql','sys')
GROUP BY TABLE_SCHEMA
ORDER BY SUM(DATA_LENGTH) DESC;

-- 统计数据表占用的磁盘空间
SELECT TABLE_NAME, TABLE_SCHEMA,
CONCAT(ROUND(DATA_LENGTH/1024/1024/1024, 2), ' GB') AS 'DATA_SIZE', 
CONCAT(ROUND(INDEX_LENGTH/1024/1024/1024, 2), ' GB') AS 'INDEX_SIZE',
CONCAT(ROUND(DATA_FREE/1024/1024/1024, 2), ' GB') AS '碎片空间'
FROM information_schema.tables
WHERE TABLE_SCHEMA NOT IN ('information_schema', 'mysql','sys')
ORDER BY DATA_LENGTH DESC;

-- 正则匹配分表tbname_xxxx
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.`TABLES` WHERE TABLE_SCHEMA='tb_00' AND TABLE_NAME REGEXP '^tb_[0-9][0-9][0-9][0-9]$';

-- 查询数据表的字段(排序): 查询INFORMATION_SCHEMA中的各个内存表，最好都带上TABLE_SCHEMA、TABLE_NAME以增强查询效率。
SELECT COLUMN_NAME AS Field, COLUMN_TYPE AS Type FROM INFORMATION_SCHEMA.`COLUMNS` WHERE TABLE_SCHEMA='dbname' AND TABLE_NAME='tbname' ORDER BY COLUMN_NAME;

-- 查询自增字段当前值并生成跳段语句
SELECT CONCAT('alter table ', table_schema, '.', table_name, ' auto_increment=', AUTO_INCREMENT+3000, ';') FROM information_schema.tables WHERE table_schema LIKE "db_%" AND AUTO_INCREMENT IS NOT NULL ;
