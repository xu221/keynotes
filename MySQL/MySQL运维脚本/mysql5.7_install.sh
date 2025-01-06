#!bin/bash
# @Function  : cd到MySQL二进制包内，在当前目录初始化服务

function_main(){
    function_init
}

function_init(){
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
    mkdir -p ${datadir}
    mkdir -p ${binlogdir}
    mkdir -p ${relaylogdir}
    mkdir -p ${redologdir}
    mkdir -p ${confdir}
    mkdir -p ${tmpdir}
    
echo "
[mysqld]

# BASE
port = 3306
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
default_authentication_plugin=mysql_native_password

# BINLOG
binlog_error_action = ABORT_SERVER
binlog_format = row
binlog_checksum = NONE
binlog_rows_query_log_events = 1
log_slave_updates = 1
master_info_repository = TABLE
max_binlog_size = 1000M
relay_log_info_repository = TABLE
relay_log_recovery = 1
sync_binlog = 1
log_bin_trust_function_creators = 1
binlog_encryption = OFF  

# GTID
gtid_mode = ON
enforce_gtid_consistency = 1
binlog_gtid_simple_recovery = 1

# INNODB ENGINE
default_storage_engine = InnoDB
innodb_buffer_pool_size = 128MB        
innodb_data_file_path = ibdata1:1G:autoextend
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit=1
innodb_flush_method = O_DIRECT
innodb_log_buffer_size = 64M
innodb_log_file_size = 2G
innodb_log_files_in_group = 2
innodb_max_dirty_pages_pct = 75
innodb_print_all_deadlocks=1
innodb_stats_on_metadata = 0
innodb_strict_mode = 1
innodb_io_capacity_max= 2000
innodb_io_capacity = 1000
innodb_write_io_threads= 8
innodb_read_io_threads= 8
innodb_buffer_pool_instances= 8
innodb_max_undo_log_size= 4G
innodb_undo_log_truncate= 1
innodb_purge_threads = 4
innodb_buffer_pool_load_at_startup = 1
innodb_buffer_pool_dump_at_shutdown = 1
innodb_buffer_pool_dump_pct=25
innodb_sort_buffer_size = 8M
innodb_page_cleaners = 8
innodb_lock_wait_timeout = 10
innodb_flush_neighbors = 1
innodb_thread_concurrency = 8
innodb_stats_persistent_sample_pages = 64
innodb_autoinc_lock_mode = 2
innodb_online_alter_log_max_size = 1G
innodb_open_files = 4096
innodb_temp_data_file_path = ibtmp1:12M:autoextend:max:50G
innodb_rollback_segments = 128
innodb_numa_interleave = 1

# CACHE
key_buffer_size = 16M
tmp_table_size = 64M
max_heap_table_size = 64M
max_connections = 2000
max_connect_errors = 1000
thread_cache_size = 200
open_files_limit = 65535
binlog_cache_size = 1M
join_buffer_size = 8M
sort_buffer_size = 2M
read_buffer_size = 8M
read_rnd_buffer_size = 8M
table_definition_cache = 2000
table_open_cache_instances = 8
table_open_cache = 2000

# SLOW LOG
# slow_query_log = 1
# slow_query_log_file = /data/mysql/data/3306/mysql-slow.log
# log_slow_admin_statements = 1
# log_slow_slave_statements = 1
# long_query_time  = 1

# PLUGINS
plugin_load = \"rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so\"

# SEMISYNC
#rpl_semi_sync_master_enabled = 1
#rpl_semi_sync_slave_enabled = 0
#rpl_semi_sync_master_wait_for_slave_count = 1
#rpl_semi_sync_master_wait_no_slave = 0
#rpl_semi_sync_master_timeout = 30000  # 30s
# SLAVE
slave_parallel_type = LOGICAL_CLOCK
slave_parallel_workers=16
slave_preserve_commit_order=on
slave_max_allowed_packet = 1073741824
slave_rows_search_algorithms = 'INDEX_SCAN,HASH_SCAN'

# OTHER
character_set_server = utf8mb4
collation_server = utf8mb4_bin
log_timestamps=SYSTEM
lower_case_table_names = 1
max_allowed_packet = 64M
read_only = 0
super_read_only = 0
skip_external_locking = 1
skip_name_resolve = 1
skip_slave_start = 1
disabled_storage_engines = ARCHIVE,BLACKHOLE,EXAMPLE,FEDERATED,MEMORY,MERGE,NDB
log-output = TABLE,FILE
binlog_expire_logs_seconds = 2592000
transaction_isolation=READ-COMMITTED
log_error_verbosity = 3
binlog_transaction_dependency_tracking = WRITESET
transaction_write_set_extraction = XXHASH64
secure_file_priv = ""
interactive_timeout = 1800
wait_timeout = 1800
explicit_defaults_for_timestamp = 1

# PERFORMANCE-SHCEMA
performance-schema-instrument ='wait/lock/metadata/sql/mdl=ON'
performance-schema-instrument = 'memory/% = COUNTED'
performance-schema-instrument = 'stage/innodb/alter%=ON'
performance-schema-consumer-events-stages-current=ON
performance-schema-consumer-events-stages-history=ON
performance-schema-consumer-events-stages-history-long=ON" > $confdir/mysqld.conf

if [ -d ${datadir} ]
    then
      mv ${datadir} `pwd`/mydb/databak
fi
# 第一步初始化
`pwd`/bin/mysqld --defaults-file=$confdir/mysqld.conf --initialize

# 第二步启动MySQL：使用屏幕打印出的启动命令，并根据打印出的root密码通过socket登录MySQL。
echo "`pwd`/bin/mysqld --defaults-file=$confdir/mysqld.conf &"
grep "A temporary password is generated" ${errorlogdir}
}


function_main
