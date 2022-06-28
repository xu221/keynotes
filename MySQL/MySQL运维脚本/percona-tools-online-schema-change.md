#### pt-online-schema-change
1.pt-online-schema-change在percona-toolkit工具包内
```
percona源安装
yum install https://downloads.percona.com/downloads/percona-release/percona-release-1.0-9/redhat/percona-release-1.0-27.noarch.rpm
percona工具包安装
yum install percona-toolkit.x86_64
```

2.执行命令
```
pt-online-schema-change \
--host='127.0.0.1' \
--user=dba \
--password='' \
--alter 'modify col varchar(20) NOT NULL' \
--print \
--execute D=tst,t=tb2
```

3.执行过程
```
Creating new table...
CREATE TABLE `tst`.`_tb1_new` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `col` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `col2` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'aa',
  PRIMARY KEY (`id`),
  KEY `idx_col` (`col`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin
Created new table tst._tb1_new OK.
-----------------------------------------------------------
Altering new table...
ALTER TABLE `tst`.`_tb1_new` modify col varchar(20) NOT NULL
Altered `tst`.`_tb1_new` OK.
-----------------------------------------------------------
2022-06-27T17:07:59 Creating triggers...
-----------------------------------------------------------
Event : DELETE
Name  : pt_osc_tst_tb1_del
SQL   : CREATE TRIGGER `pt_osc_tst_tb1_del` AFTER DELETE ON `tst`.`tb1` FOR EACH ROW BEGIN DECLARE CONTINUE HANDLER FOR 1146 begin end; DELETE IGNORE FROM `tst`.`_tb1_new` WHERE `tst`.`_tb1_new`.`id` <=> OLD.`id`; END
Suffix: del
Time  : AFTER
-----------------------------------------------------------
-----------------------------------------------------------
Event : UPDATE
Name  : pt_osc_tst_tb1_upd
SQL   : CREATE TRIGGER `pt_osc_tst_tb1_upd` AFTER UPDATE ON `tst`.`tb1` FOR EACH ROW BEGIN DECLARE CONTINUE HANDLER FOR 1146 begin end; DELETE IGNORE FROM `tst`.`_tb1_new` WHERE !(OLD.`id` <=> NEW.`id`) AND `tst`.`_tb1_new`.`id` <=> OLD.`id`; REPLACE INTO `tst`.`_tb1_new` (`id`, `col`, `col2`) VALUES (NEW.`id`, NEW.`col`, NEW.`col2`); END
Suffix: upd
Time  : AFTER
-----------------------------------------------------------
-----------------------------------------------------------
Event : INSERT
Name  : pt_osc_tst_tb1_ins
SQL   : CREATE TRIGGER `pt_osc_tst_tb1_ins` AFTER INSERT ON `tst`.`tb1` FOR EACH ROW BEGIN DECLARE CONTINUE HANDLER FOR 1146 begin end; REPLACE INTO `tst`.`_tb1_new` (`id`, `col`, `col2`) VALUES (NEW.`id`, NEW.`col`, NEW.`col2`);END
Suffix: ins
Time  : AFTER
-----------------------------------------------------------
# 根据主键值的范围，循环只读锁住chunksize大小的记录进行拷贝。
2022-06-27T17:07:59 Copying approximately 1000 rows...
INSERT LOW_PRIORITY IGNORE INTO `tst`.`_tb1_new` (`id`, `col`, `col2`) SELECT `id`, `col`, `col2` FROM `tst`.`tb1` LOCK IN SHARE MODE /*pt-online-schema-change 39704 copy table*/
# 循环一万次
2022-06-27T17:07:59 Copied rows OK.
-----------------------------------------------------------
2022-06-27T17:07:59 Analyzing new table...
2022-06-27T17:07:59 Swapping tables...
# 进行互相改名，此时可能会导致一个元数据锁的竞争
RENAME TABLE `tst`.`tb1` TO `tst`.`_tb1_old`, `tst`.`_tb1_new` TO `tst`.`tb1`
2022-06-27T17:07:59 Swapped original and new tables OK.
2022-06-27T17:07:59 Dropping old table...
DROP TABLE IF EXISTS `tst`.`_tb1_old`
2022-06-27T17:07:59 Dropped old table `tst`.`_tb1_old` OK.
2022-06-27T17:07:59 Dropping triggers...
DROP TRIGGER IF EXISTS `tst`.`pt_osc_tst_tb1_del`
DROP TRIGGER IF EXISTS `tst`.`pt_osc_tst_tb1_upd`
DROP TRIGGER IF EXISTS `tst`.`pt_osc_tst_tb1_ins`
2022-06-27T17:07:59 Dropped triggers OK.
-----------------------------------------------------------
Successfully altered `tst`.`tb1`.
```

4.注意事项
> 默认值变更
```
当数据表字段从默认为NULL值变更为NOT NULL时，pt工具并不会预校验，所以存在可能执行到一半时报错。
```
