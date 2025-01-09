#!bin/bash
# @Function  : cd到MySQL二进制包内，在当前目录初始化服务：拷贝下面脚本，并执行。

function_main(){
    function_init
}

function_init(){
    port=3306
    server_id=56789
    basedir=`pwd`
    datadir=`pwd`/mydb/data
    binlogdir=`pwd`/mydb/binlogs/log-bin
    relaylogdir=`pwd`/mydb/relaylogs
    redologdir=`pwd`/mydb/redologs
    confdir=`pwd`/mydb/etc
    tmpdir=`pwd`/mydb/tmp
    errorlogdir=`pwd`/mysqld.error
    socketdir=`pwd`/mydb/mysqld.sock
    piddir=`pwd`/mydb/mysqld.pid
    timestamp=$(date +%Y%m%d%H%M%S)  # 获取当前时间戳
    if [ -d ${datadir} ];
        then
            mv ${datadir} `pwd`/mydb/databak_${timestamp} # 后续可清除这些databak目录
    fi
    if [ -d ${redologdir} ];
        then
            mv ${redologdir} `pwd`/mydb/redologbak_${timestamp} # 后续可清除这些redobak目录
    fi

    mkdir -p ${datadir}
    mkdir -p ${binlogdir}
    mkdir -p ${relaylogdir}
    mkdir -p ${redologdir}
    mkdir -p ${confdir}
    mkdir -p ${tmpdir}

echo "
[mysqld]

# BASE
port = ${port}
server_id = ${server_id}
basedir = ${basedir}
datadir = ${datadir}
log_bin = ${binlogdir}
relay_log = ${relaylogdir}
innodb_log_group_home_dir = ${redologdir}
tmpdir = ${tmpdir}
log_error = ${errorlogdir}
socket = ${socketdir}
pid_file = ${piddir}

# 开启 GTID 模式
gtid_mode=ON
enforce_gtid_consistency=ON
# 主从相关信息存储方式改为 TABLE
master_info_repository=TABLE
relay_log_info_repository=TABLE
# 关闭 binlog 校验和（MGR 要求）
binlog_checksum=NONE
# 允许从库记录 binlog
log_slave_updates=ON
# 开启 binlog
log_bin=binlog
# binlog 格式设置为 ROW
binlog_format=ROW
# 事务写集提取算法
transaction_write_set_extraction=XXHASH64
# MGR 集群名称，需保证集群内唯一且各节点一致
loose-group_replication_group_name="aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
# 启动时不自动启动 MGR（方便后续手动控制初始化等操作）
loose-group_replication_start_on_boot=off
# 本节点用于 MGR 通信的地址和端口
loose-group_replication_local_address= "127.0.0.1:33061"
# 集群各节点用于 MGR 通信的地址和端口列表，包含所有节点
loose-group_replication_group_seeds= "127.0.0.1:33061,127.0.0.1:33061,127.0.0.1:33061"
# 不进行集群初始化引导（除第一次初始化集群的节点外都设为 off）
loose-group_replication_bootstrap_group=off
# 设置默认字符集等（可选，根据实际需求）
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
# 设置 innodb 缓冲池大小等性能相关参数（可选，根据实际情况调整）
innodb_buffer_pool_size=1G" > $confdir/mysqld.conf

# 第一步初始化
`pwd`/bin/mysqld --defaults-file=$confdir/mysqld.conf --initialize

# 第二步启动MySQL：使用屏幕打印出的启动命令，并根据打印出的root密码通过socket登录MySQL。
temp_password=$(grep "A temporary password is generated" "${errorlogdir}" | tail -n 1 |awk '{print $NF}')
if [ -z "${temp_password}" ]; then
    echo "未在错误日志中找到临时密码，请检查mysql错误日志确认是否初始化异常。"
    exit 1
fi

grep "A temporary password is generated" ${errorlogdir} | tail -n 1
mysql_command="`pwd`/bin/mysql -uroot -p'${temp_password}' -S ${socketdir}"
mysqld_command="`pwd`/bin/mysqld --defaults-file=$confdir/mysqld.conf &"

echo "MySQL启动命令: "
echo ${mysqld_command}
echo "MySQL登录命令: "
echo ${mysql_command}
}

function_main

# MySQL服务启动后，自行通过socket登录修改root密码以开始使用。
# ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码';
# 创建真正具有管理权限的用户，并不使用root或者禁用root。
