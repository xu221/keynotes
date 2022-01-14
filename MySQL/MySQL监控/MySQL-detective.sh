#!bin/bash
USER='root'
PORT=3306
HOST=127.0.0.1
export MYSQL_PWD='xxx'
mysqlconnectstring="mysql -u${USER} -h${HOST} -P${PORT} "
number=0
################################################################
#主函数
funcmain(){
if [ `${mysqlconnectstring} -e "select 1;" | awk 'NR>1' |awk '{print $1}'` ]
    then

      check_mysqld_user
      check_mysql_user_exist_root
      check_mysql_user_modifydata
      check_mysql_user_0password
      check_mysql_user_0name
      check_mysql_user_anyip
      check_mysqld_port
      check_mysql_connect_ssl
      check_mysqld_datadir
      check_mysql_historyc
      check_mysqld_binlog
      check_mysqld_errorlog
      check_mysqld_generalog
      check_mysqld_waring
      check_mysql_local_infile
      check_mysql_version
      check_mysqld_dengine
      check_mysqld_trxiso
      check_mysqld_binlogformat
      check_mysqld_binlogexpire
      check_mysqld_qcache
      check_mysqld_pidb
      check_mysqld_pundo
      check_mysqld_ibtmpmax
      check_mysqld_nameresolve
      check_mysqld_slowqt
      check_mysqld_tables_fk
      check_mysqld_binlogsync
      check_mysqld_log_slave_updates
      
fi
}

################################################################
#检查函数
check_mysqld_user(){
ps -ef|grep mysqld |awk 'NR>1'| awk '{print $1}'| while read line
do
    if test $line = 'root'
        then
          let number++
          echo $number.'MySQL启动用户须禁止使用root'
          echo $number > tmp.pid
    fi
done
if [ -f "tmp.pid" ]
then
    number=`cat tmp.pid`
    rm -f tmp.pid
fi
}

check_mysql_user_exist_root(){
tag=`${mysqlconnectstring} -e "SELECT count(*) from mysql.user where user='root';" | awk 'NR>1' `
    if [ $tag -gt 0 ]
        then
          let number++
          echo $number.'MySQL客户端用户须禁止使用root名称'
    fi
}

check_mysql_user_modifydata(){
tag=`${mysqlconnectstring} -e "SELECT count(*) FROM mysql.user WHERE
    (Update_priv = 'Y')  OR
    (Delete_priv = 'Y')  OR
    (Drop_priv = 'Y')    OR
    (Grant_priv = 'Y') ;" | awk 'NR>1' `
    if [ $tag -gt 0 ]
        then
          let number++
          echo $number.'请检查具有修改数据权限的用户!'
          ${mysqlconnectstring} -e "SELECT
          user, host,Update_priv,Delete_priv,Drop_priv,Grant_priv
          FROM mysql.user
          WHERE
          (Update_priv = 'Y')  OR
          (Delete_priv = 'Y')  OR
          (Drop_priv = 'Y')    OR
          (Grant_priv = 'Y') ;"
    fi
}

check_mysql_user_0password(){
tag=`${mysqlconnectstring} -e "SELECT count(*) FROM mysql.user WHERE authentication_string=''" | awk 'NR>1' `
    if [ $tag -gt 0 ]
        then
          let number++
          echo $number.'MySQL客户端用户须禁止使用空密码'
          ${mysqlconnectstring} -e "SELECT User,host
          FROM mysql.user
          WHERE authentication_string='';"
    fi
}
check_mysql_user_0name(){
tag=`${mysqlconnectstring} -e "SELECT count(*) FROM mysql.user WHERE user = '';" | awk 'NR>1' `
    if [ $tag -gt 0 ]
        then
          let number++
          echo $number.'MySQL客户端用户须禁止使用空名'
          ${mysqlconnectstring} -e "SELECT user,host FROM mysql.user WHERE user = '';"
    fi
}

check_mysql_user_anyip(){
tag=`${mysqlconnectstring} -e "SELECT count(*) FROM mysql.user WHERE host = '%';" | awk 'NR>1' `
    if [ $tag -gt 0 ]
        then
          let number++
          echo $number.'MySQL数据库须禁止用户从任意IP访问'
          ${mysqlconnectstring} -e "SELECT user, host FROM mysql.user WHERE host = '%';"
    fi
}

check_mysqld_port(){
if [ `show_variable port` -eq 3306 ]
    then
      let number++
      echo $number.'MySQL数据库服务须禁止使用默认端口3306'
fi
}

check_mysql_connect_ssl(){
if [ `show_variable have_ssl` = 'DISABLED' ]
    then
      echo -n ''
    else
      let number++
      echo $number.'MySQL客户端连接使用ssl'
fi
}

check_mysqld_datadir(){
df -h |awk 'NR>1'|awk '{print $1,int($5)}' | while read disk userate
do
    if [ $userate -gt 80 ]
        then
        let number++
        echo $number.$disk'磁盘空间使用超过80%'
        echo $number > tmp.pid
    fi
done

if [ -f tmp.pid ]
    then
    number=`cat tmp.pid`
    rm -f tmp.pid
fi

}

check_mysql_historyc(){
    if [ ! -f "~/.mysql_history" ]
        then
        let number++
        echo $number.'MySQL历史命令文件存在，请注意清除'
    fi
}

check_mysqld_binlog(){
    if [ `show_variable log_bin` = 'OFF' ]
        then
        let number++
        echo $number.'MySQL须开启二进制日志'
    fi
}

check_mysqld_errorlog(){
tag=$(grep 'ERROR' `${mysqlconnectstring} -e "show global variables like 'log_error';" | awk 'NR>1' |awk '{print $2}'` | sed -n "/`date -d "5 day ago" +"%Y-%m-%d"`/","/`date +"%Y-%m-%d"`/p" |wc -l)
    if [ $tag -gt 0 ]
        then
        let number++
        echo $number.'MySQL服务器存在近5天的错误记录，共'$tag'个，''请处理'
    fi

}

check_mysqld_generalog(){
    if [ `show_variable general_log` = 'ON' ]
        then
        let number++
        echo $number.'MySQL须关闭通用日志'
    fi
}

check_mysqld_waring(){
    if [ `show_variable log_warnings` -ne 2 ]
        then
        let number++
        echo $number.'MySQL须设置告警等级log_warnings为2'
    fi
}

check_mysql_local_infile(){
    if [ `show_variable local_infile` = 'ON' ]
        then
        let number++
        echo $number.'MySQL须禁止远程数据load到本地'
    fi

}

check_mysql_version(){
    if [[ `show_variable version` < '5.7.26' ]]
        then
        let number++
        echo $number.'MySQL版本建议使用5.7.26以上'
        elif [[ `show_variable version` > '8.0.0' ]] && [[ `show_variable version` < '8.0.19' ]]
          then
          let number++
          echo $number.'MySQL版本建议使用8.0.19以上'

    fi
}

check_mysqld_dengine(){
    if [ `show_variable default_storage_engine` != 'InnoDB' ]
        then
        let number++
        echo $number.'MySQL须使用InnoDB引擎'
    fi
}

check_mysqld_trxiso(){
    if [ `show_variable transaction_isolation` != 'READ-COMMITTED' ]
        then
        let number++
        echo $number.'MySQL事务隔离级别须使用READ-COMMITTED'
    fi
}

check_mysqld_binlogformat(){
    if [ `show_variable binlog_format` != 'ROW' ]
        then
        let number++
        echo $number.'MySQL二进制日志格式须设置为ROW模式'
    fi
}

check_mysqld_binlogexpire(){
    if [ `show_variable expire_logs_days` -eq 0 ]
        then
        let number++
        echo $number.'MySQL二进制日志须设置过期时间'
    fi

}

check_mysqld_qcache(){
    if [ `show_variable query_cache_type` = 'ON' ]
        then
        let number++
        echo $number.'MySQL查询缓存在无特殊情况须关闭'
    fi
}

check_mysqld_pidb(){
    if [ `show_variable innodb_file_per_table` = 'OFF' ]
        then
        let number++
        echo $number.'MySQL服务器须开启独立表空间'
    fi
}

check_mysqld_pundo(){
    if [ `show_variable innodb_undo_tablespaces` -eq 0 ]
        then
        let number++
        echo $number.'MySQL服务器须开启独立undo空间'
    fi

}
check_mysqld_ibtmpmax(){
    if [ `show_variable innodb_temp_data_file_path` = 'ibtmp1:12M:autoextend' ]
        then
        let number++
        echo $number.'MySQL服务器须设置ibtmp上限'
    fi
}

check_mysqld_nameresolve(){
    if [ `show_variable skip_name_resolve` = 'OFF' ]
        then
        let number++
        echo $number.'MySQL服务器须启用skip_name_resolve'
    fi

}

check_mysqld_slowqt(){
    if [ `show_variable long_query_time` -gt 2 ]
        then
        let number++
        echo $number.'MySQL慢查询定义建议设为2秒'
    fi
}

check_mysqld_tables_fk(){
tag=`${mysqlconnectstring} -e "SELECT count(*) from INFORMATION_SCHEMA.KEY_COLUMN_USAGE where REFERENCED_TABLE_NAME is not null;" | awk 'NR>1' `
    if [ $tag -gt 0 ]
        then
          let number++
          echo $number.'MySQL外键建议不使用'
          ${mysqlconnectstring} -e "SELECT table_name,column_name,constraint_name,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME
          from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
          where REFERENCED_TABLE_NAME is not null;"
    fi
}

check_mysqld_binlogsync(){
    if [ `show_variable sync_binlog` -ne 1 ]
        then
        let number++
        echo $number.'MySQL服务器二进制日志刷盘须设置为1'
    fi
}

check_mysqld_log_slave_updates(){
    if [ `show_variable log_slave_updates` = 'OFF' ]
        then
        let number++
        echo $number.'MySQL从库须记录二进制日志到本地'
    fi
}


show_variable(){
${mysqlconnectstring} -e "show global variables like '${1}';" | awk 'NR>1' |awk '{printf $2}'
}

show_status(){
${mysqlconnectstring} -e "show global status like '${1}';" | awk 'NR>1' |awk '{printf "%-20s:%30s\n",$1,$2}'
}

#执行
funcmain
