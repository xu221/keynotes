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
mysqlbinlog -R -vv -h'' -u'' -p'' --start-datetime='2020-11-17 14:20:10' --stop-datetime='2020-11-18 14:20:10' --base64-output=decode-rows binlog_0001.logbin  | grep -A int(columncounts)+1 'update'> aaa.log
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
