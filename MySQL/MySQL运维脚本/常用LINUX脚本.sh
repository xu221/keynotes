#!/bin/bash

# <批量SQL生成>
function sql_repeat(){
    for db in `seq $1 $1`
    do
        for tb in `seq $2 $3`
        do
            printf "UPDATE test_db_%02d.atb_%04d SET is_delete = 'Y' WHERE id = 10 AND customer_id = 100; \n" ${db} ${tb}
        done
    done
}

sql_repeat 0 0 7
sql_repeat 1 8 15
sql_repeat 2 16 23
sql_repeat 3 24 31
# </>

# <查询结果导出为CSV>
mysql -u'' -p'' -h'' -e 'select 1' | sed -e "s/\t/,/g" -e "s/\n/\r\n/g" > aaa.csv
# </>

# <追溯binlog日志时间GTID>
export MYSQL_PWD='******'
function traceBinlog(){ # <-USER, <-HOST
    loglist=`/mysql-8.0.25/bin/mysql -u$1 -h$2 -e "show binary logs;" |awk 'NR>1' |awk '{print $1}'`
    for one in ${loglist}
    do
        echo ${one}:
        /mysql-8.0.25/bin/mysqlbinlog -R -vv -u$1 -h$2 --base64-output=decode-rows ${one} | grep -A 1 'Previous-GTIDs'
    done
}

traceBinlog root '127.0.0.1'

# <远程导出DML关键字匹配到的binlog信息>
mysqlbinlog -R -vv -h'' -u'' -p'' --start-datetime='2020-11-17 14:20:10' --stop-datetime='2020-11-18 14:20:10' --base64-output=decode-rows binlog_0001.logbin  | grep -A [int(columncounts)+1]*2 'UPDATE'> aaa.log
# 后面变量columncounts为希望查找的表的字段数量
# </>

# <将多行SQL合并为一个INSERT语句>
awk -F'VALUES' '{if(NR>1) print $2;else print $0 }' abs.sql | sed -r '$s/;[[:space:]]*$//' | sed -r "s/;[[:space:]]*$/,/" > d.log
# </>

# <从SQL文件中过滤出想要的建表语句(比如：以_0000结尾)>
# 方式一
cat createdb.sql | sed ':a;N;$!ba;s/\r\n//g' | sed 's/;/;\n/g' | sed 's/CREATE/\nCREATE/g' |grep '_0000' > result.sql
# 方式二
cat createdb.sql | tr "\r\n" " " | sed 's/;/;\n/g' | sed 's/CREATE/\nCREATE/g' | grep '_0000' > resultc.sql
# </>

# <mysqldump开启RR事务导出数据>
mysqldump -u'' -p'' -h'xx' --quick --set-gtid-purged=OFF --single-transaction --no-create-info --hex-blob --complete-insert db_00 > db.sql
mysqldump -u'' -p'' -h'xx' --quick --set-gtid-purged=OFF --single-transaction --skip-add-drop-table --hex-blob --complete-insert db_00 > db.sql
mysqldump -u'' -p'' -h'xx' --quick --set-gtid-purged=OFF --single-transaction --skip-add-drop-table --hex-blob --complete-insert db_00 tablename --where='id="775"' > filter_by_id.sql
# </>
# <mysqldump开启RR事务导出所有>
mysqldump -u'' -p'' -h'xx' --quick --set-gtid-purged=OFF --single-transaction --master-data=2 --hex-blob --routines --events --triggers --all-databases > alldb.sql
# </>

# <分批删除数据，可开多进程并发>
#!/bin/bash

# 数据库连接信息
DB_HOST=""
DB_USER=""
DB_PASS=""
DB_NAME="dd"

# 设置目标表名称
TABLE_NAME="tt"

# 设置每批删除的记录数
BATCH_SIZE=1000

# 设置删除条件，这里使用 created_at 作为示例
DELETE_CONDITION='WHERE created_at < "2022-10-01 00:00:00" AND  created_at >= "2022-09-01 00:00:00"'

# 设置每隔多少次循环检查一次是否还有需要删除的记录
CHECK_INTERVAL=600

# 初始化循环计数器
counter=0

while true; do
    # 删除当前批次的数据
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -e "DELETE FROM $TABLE_NAME $DELETE_CONDITION LIMIT $BATCH_SIZE"

    # 增加循环计数器
    ((counter++))

    # 检查是否需要检查是否还有需要删除的记录
    if [ $((counter % CHECK_INTERVAL)) -eq 0 ]; then
        # 获取需要删除的记录总数
        TOTAL_RECORDS=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -D $DB_NAME -se "SELECT COUNT(*) FROM $TABLE_NAME $DELETE_CONDITION")

        # 检查是否还有需要删除的记录
        if [ "$TOTAL_RECORDS" -eq "0" ]; then
            break
        fi
        echo "继续跑，还有 " $TOTAL_RECORDS " 行数据。"
    fi

    # 每删除一批数据后，暂停1秒钟
    sleep 1
done

echo "Data deletion completed."
# </>
