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
