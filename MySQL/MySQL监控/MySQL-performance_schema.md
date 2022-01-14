#### MySQL监控

> Performance_schema

+ Performance_shema storage engine and the database : primarily on performance data

+ Information_schema : for inspection of metadata

+ 默认开启

+ 检查服务器是否支持performance_schema引擎

  ```
  SELECT * FROM INFORMATION_SCHEMA.ENGINES WHERE ENGINE='PERFORMANCE_SCHEMA'\G;	
  ```

> Performance_schema.tables

| Table Name                                                   | Description                                                  |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [`accounts`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-accounts-table.html) | Connection statistics per client account                     |
| [`cond_instances`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-cond-instances-table.html) | synchronization object instances                             |
| [`events_stages_current`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-stages-current-table.html) | Current stage events                                         |
| [`events_stages_history`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-stages-history-table.html) | Most recent stage events per thread                          |
| [`events_stages_history_long`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-stages-history-long-table.html) | Most recent stage events overall                             |
| [`events_stages_summary_by_account_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/stage-summary-tables.html) | Stage events per account and event name                      |
| [`events_stages_summary_by_host_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/stage-summary-tables.html) | Stage events per host name and event name                    |
| [`events_stages_summary_by_thread_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/stage-summary-tables.html) | Stage waits per thread and event name                        |
| [`events_stages_summary_by_user_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/stage-summary-tables.html) | Stage events per user name and event name                    |
| [`events_stages_summary_global_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/stage-summary-tables.html) | Stage waits per event name                                   |
| [`events_statements_current`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-statements-current-table.html) | Current statement events                                     |
| [`events_statements_history`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-statements-history-table.html) | Most recent statement events per thread                      |
| [`events_statements_history_long`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-statements-history-long-table.html) | Most recent statement events overall                         |
| [`events_statements_summary_by_account_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/statement-summary-tables.html) | Statement events per account and event name                  |
| [`events_statements_summary_by_digest`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/statement-summary-tables.html) | Statement events per schema and digest value                 |
| [`events_statements_summary_by_host_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/statement-summary-tables.html) | Statement events per host name and event name                |
| [`events_statements_summary_by_program`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/statement-summary-tables.html) | Statement events per stored program                          |
| [`events_statements_summary_by_thread_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/statement-summary-tables.html) | Statement events per thread and event name                   |
| [`events_statements_summary_by_user_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/statement-summary-tables.html) | Statement events per user name and event name                |
| [`events_statements_summary_global_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/statement-summary-tables.html) | Statement events per event name                              |
| [`events_transactions_current`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-transactions-current-table.html) | Current transaction events                                   |
| [`events_transactions_history`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-transactions-history-table.html) | Most recent transaction events per thread                    |
| [`events_transactions_history_long`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-transactions-history-long-table.html) | Most recent transaction events overall                       |
| [`events_transactions_summary_by_account_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/transaction-summary-tables.html) | Transaction events per account and event name                |
| [`events_transactions_summary_by_host_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/transaction-summary-tables.html) | Transaction events per host name and event name              |
| [`events_transactions_summary_by_thread_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/transaction-summary-tables.html) | Transaction events per thread and event name                 |
| [`events_transactions_summary_by_user_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/transaction-summary-tables.html) | Transaction events per user name and event name              |
| [`events_transactions_summary_global_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/transaction-summary-tables.html) | Transaction events per event name                            |
| [`events_waits_current`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-waits-current-table.html) | Current wait events                                          |
| [`events_waits_history`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-waits-history-table.html) | Most recent wait events per thread                           |
| [`events_waits_history_long`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-events-waits-history-long-table.html) | Most recent wait events overall                              |
| [`events_waits_summary_by_account_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/stage-summary-tables.html) | Wait events per account and event name                       |
| [`events_waits_summary_by_host_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/stage-summary-tables.html) | Wait events per host name and event name                     |
| [`events_waits_summary_by_instance`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/wait-summary-tables.html) | Wait events per instance                                     |
| [`events_waits_summary_by_thread_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/wait-summary-tables.html) | Wait events per thread and event name                        |
| [`events_waits_summary_by_user_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/stage-summary-tables.html) | Wait events per user name and event name                     |
| [`events_waits_summary_global_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/wait-summary-tables.html) | Wait events per event name                                   |
| [`file_instances`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-file-instances-table.html) | File instances                                               |
| [`file_summary_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/file-summary-tables.html) | File events per event name                                   |
| [`file_summary_by_instance`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/file-summary-tables.html) | File events per file instance                                |
| [`global_status`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-status-variable-tables.html) | Global status variables                                      |
| [`global_variables`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-system-variable-tables.html) | Global system variables                                      |
| [`host_cache`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-host-cache-table.html) | Information from the internal host cache                     |
| [`hosts`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-hosts-table.html) | Connection statistics per client host name                   |
| [`memory_summary_by_account_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/memory-summary-tables.html) | Memory operations per account and event name                 |
| [`memory_summary_by_host_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/memory-summary-tables.html) | Memory operations per host and event name                    |
| [`memory_summary_by_thread_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/memory-summary-tables.html) | Memory operations per thread and event name                  |
| [`memory_summary_by_user_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/memory-summary-tables.html) | Memory operations per user and event name                    |
| [`memory_summary_global_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/memory-summary-tables.html) | Memory operations globally per event name                    |
| [`metadata_locks`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-metadata-locks-table.html) | Metadata locks and lock requests                             |
| [`mutex_instances`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-mutex-instances-table.html) | Mutex synchronization object instances                       |
| [`objects_summary_global_by_type`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-objects-summary-global-by-type-table.html) | Object summaries                                             |
| [`performance_timers`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-performance-timers-table.html) | Which event timers are available                             |
| [`prepared_statements_instances`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-prepared-statements-instances-table.html) | Prepared statement instances and statistics                  |
| [`replication_applier_configuration`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-replication-applier-configuration-table.html) | Configuration parameters for the transaction applier on the replica |
| [`replication_applier_status`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-replication-applier-status-table.html) | Current status of the transaction applier on the replica     |
| [`replication_applier_status_by_coordinator`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-replication-applier-status-by-coordinator-table.html) | SQL or coordinator thread applier status                     |
| [`replication_applier_status_by_worker`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-replication-applier-status-by-worker-table.html) | Worker thread applier status (empty unless replica is multithreaded) |
| [`replication_connection_configuration`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-replication-connection-configuration-table.html) | Configuration parameters for connecting to the source        |
| [`replication_connection_status`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-replication-connection-status-table.html) | Current status of the connection to the source               |
| [`rwlock_instances`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-rwlock-instances-table.html) | Lock synchronization object instances                        |
| [`session_account_connect_attrs`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-session-account-connect-attrs-table.html) | Connection attributes per for the current session            |
| [`session_connect_attrs`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-session-connect-attrs-table.html) | Connection attributes for all sessions                       |
| [`session_status`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-status-variable-tables.html) | Status variables for current session                         |
| [`session_variables`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-system-variable-tables.html) | System variables for current session                         |
| [`setup_actors`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-setup-actors-table.html) | How to initialize monitoring for new foreground threads      |
| [`setup_consumers`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-setup-consumers-table.html) | Consumers for which event information can be stored          |
| [`setup_instruments`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-setup-instruments-table.html) | Classes of instrumented objects for which events can be collected |
| [`setup_objects`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-setup-objects-table.html) | Which objects should be monitored                            |
| [`setup_timers`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-setup-timers-table.html) | Current event timer                                          |
| [`socket_instances`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-socket-instances-table.html) | Active connection instances                                  |
| [`socket_summary_by_event_name`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/socket-summary-tables.html) | Socket waits and I/O per event name                          |
| [`socket_summary_by_instance`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/socket-summary-tables.html) | Socket waits and I/O per instance                            |
| [`status_by_account`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-status-variable-summary-tables.html) | Session status variables per account                         |
| [`status_by_host`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-status-variable-summary-tables.html) | Session status variables per host name                       |
| [`status_by_thread`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-status-variable-tables.html) | Session status variables per session                         |
| [`status_by_user`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-status-variable-summary-tables.html) | Session status variables per user name                       |
| [`table_handles`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-table-handles-table.html) | Table locks and lock requests                                |
| [`table_io_waits_summary_by_index_usage`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-table-io-waits-summary-by-index-usage-table.html) | Table I/O waits per index                                    |
| [`table_io_waits_summary_by_table`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-table-io-waits-summary-by-table-table.html) | Table I/O waits per table                                    |
| [`table_lock_waits_summary_by_table`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-table-lock-waits-summary-by-table-table.html) | Table lock waits per table                                   |
| [`threads`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-threads-table.html) | Information about server threads                             |
| [`user_variables_by_thread`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-user-variable-tables.html) | User-defined variables per thread                            |
| [`users`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-users-table.html) | Connection statistics per client user name                   |
| [`variables_by_thread`](https://dev.mysql.com/doc/mysql-perfschema-excerpt/5.7/en/performance-schema-system-variable-tables.html) | Session system variables per session                         |

> 解析监控信息

1. 先看setup_instruments表

```
mysql> select name from setup_instruments;
+--------------------------------------------------------------------------------+
| name                                                                           |
+--------------------------------------------------------------------------------+
# wait/synch/mutex互斥对象
| wait/synch/mutex/sql/TC_LOG_MMAP::LOCK_tc                                      |
| wait/synch/mutex/sql/LOCK_des_key_file                                         |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_commit                                |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_commit_queue                          |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_done                                  |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_flush_queue                           |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_index                                 |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_log                                   |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_binlog_end_pos                        |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_sync                                  |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_sync_queue                            |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_xids                                  |
| wait/synch/mutex/sql/MYSQL_RELAY_LOG::LOCK_commit                              |
| wait/synch/mutex/sql/MYSQL_RELAY_LOG::LOCK_commit_queue                        |
| wait/synch/mutex/sql/MYSQL_RELAY_LOG::LOCK_done                                |
| wait/synch/mutex/sql/MYSQL_RELAY_LOG::LOCK_flush_queue                         |
| wait/synch/mutex/sql/MYSQL_RELAY_LOG::LOCK_index                               |
| wait/synch/mutex/sql/MYSQL_RELAY_LOG::LOCK_log                                 |
| wait/synch/mutex/sql/MYSQL_RELAY_LOG::LOCK_sync                                |
| wait/synch/mutex/sql/MYSQL_RELAY_LOG::LOCK_sync_queue                          |
| wait/synch/mutex/sql/MYSQL_RELAY_LOG::LOCK_xids                                |
| wait/synch/mutex/sql/hash_filo::lock                                           |
| wait/synch/mutex/sql/Gtid_set::gtid_executed::free_intervals_mutex             |
| wait/synch/mutex/sql/LOCK_crypt                                                |
| wait/synch/mutex/sql/LOCK_error_log                                            |
| wait/synch/mutex/sql/LOCK_gdl                                                  |
| wait/synch/mutex/sql/LOCK_global_system_variables                              |
| wait/synch/mutex/sql/LOCK_manager                                              |
| wait/synch/mutex/sql/LOCK_prepared_stmt_count                                  |
| wait/synch/mutex/sql/LOCK_sql_slave_skip_counter                               |
| wait/synch/mutex/sql/LOCK_slave_net_timeout                                    |
| wait/synch/mutex/sql/LOCK_slave_trans_dep_tracker                              |
| wait/synch/mutex/sql/LOCK_server_started                                       |
| wait/synch/mutex/sql/LOCK_keyring_operations                                   |
| wait/synch/mutex/sql/LOCK_socket_listener_active                               |
| wait/synch/mutex/sql/LOCK_start_signal_handler                                 |
| wait/synch/mutex/sql/LOCK_status                                               |
| wait/synch/mutex/sql/LOCK_system_variables_hash                                |
| wait/synch/mutex/sql/LOCK_table_share                                          |
| wait/synch/mutex/sql/THD::LOCK_thd_data                                        |
| wait/synch/mutex/sql/THD::LOCK_thd_query                                       |
| wait/synch/mutex/sql/THD::LOCK_thd_sysvar                                      |
| wait/synch/mutex/sql/LOCK_user_conn                                            |
| wait/synch/mutex/sql/LOCK_uuid_generator                                       |
| wait/synch/mutex/sql/LOCK_sql_rand                                             |
| wait/synch/mutex/sql/LOG::LOCK_log                                             |
| wait/synch/mutex/sql/Master_info::data_lock                                    |
| wait/synch/mutex/sql/Master_info::run_lock                                     |
| wait/synch/mutex/sql/Master_info::sleep_lock                                   |
| wait/synch/mutex/sql/Master_info::info_thd_lock                                |
| wait/synch/mutex/sql/Slave_reporting_capability::err_lock                      |
| wait/synch/mutex/sql/Relay_log_info::data_lock                                 |
| wait/synch/mutex/sql/Relay_log_info::sleep_lock                                |
| wait/synch/mutex/sql/Relay_log_info::info_thd_lock                             |
| wait/synch/mutex/sql/Relay_log_info::log_space_lock                            |
| wait/synch/mutex/sql/Relay_log_info::run_lock                                  |
| wait/synch/mutex/sql/Relay_log_info::pending_jobs_lock                         |
| wait/synch/mutex/sql/Relay_log_info::exit_count_lock                           |
| wait/synch/mutex/sql/Relay_log_info::temp_tables_lock                          |
| wait/synch/mutex/sql/Worker_info::jobs_lock                                    |
| wait/synch/mutex/sql/Query_cache::structure_guard_mutex                        |
| wait/synch/mutex/sql/TABLE_SHARE::LOCK_ha_data                                 |
| wait/synch/mutex/sql/LOCK_error_messages                                       |
| wait/synch/mutex/sql/LOCK_log_throttle_qni                                     |
| wait/synch/mutex/sql/Gtid_state                                                |
| wait/synch/mutex/sql/THD::LOCK_query_plan                                      |
| wait/synch/mutex/sql/Cost_constant_cache::LOCK_cost_const                      |
| wait/synch/mutex/sql/THD::LOCK_current_cond                                    |
| wait/synch/mutex/sql/key_mts_temp_table_LOCK                                   |
| wait/synch/mutex/sql/LOCK_reset_gtid_table                                     |
| wait/synch/mutex/sql/LOCK_compress_gtid_table                                  |
| wait/synch/mutex/sql/key_mts_gaq_LOCK                                          |
| wait/synch/mutex/sql/thd_timer_mutex                                           |
| wait/synch/mutex/sql/Commit_order_manager::m_mutex                             |
| wait/synch/mutex/sql/Relay_log_info::slave_worker_hash_lock                    |
| wait/synch/mutex/sql/LOCK_offline_mode                                         |
| wait/synch/mutex/sql/LOCK_default_password_lifetime                            |
| wait/synch/mutex/mysys/BITMAP::mutex                                           |
| wait/synch/mutex/mysys/IO_CACHE::append_buffer_lock                            |
| wait/synch/mutex/mysys/IO_CACHE::SHARE_mutex                                   |
| wait/synch/mutex/mysys/KEY_CACHE::cache_lock                                   |
| wait/synch/mutex/mysys/THR_LOCK_charset                                        |
| wait/synch/mutex/mysys/THR_LOCK_heap                                           |
| wait/synch/mutex/mysys/THR_LOCK_lock                                           |
| wait/synch/mutex/mysys/THR_LOCK_malloc                                         |
| wait/synch/mutex/mysys/THR_LOCK::mutex                                         |
| wait/synch/mutex/mysys/THR_LOCK_myisam                                         |
| wait/synch/mutex/mysys/THR_LOCK_net                                            |
| wait/synch/mutex/mysys/THR_LOCK_open                                           |
| wait/synch/mutex/mysys/THR_LOCK_threads                                        |
| wait/synch/mutex/mysys/TMPDIR_mutex                                            |
| wait/synch/mutex/mysys/THR_LOCK_myisam_mmap                                    |
| wait/synch/mutex/sql/LOCK_audit_mask                                           |
| wait/synch/mutex/session/LOCK_srv_session_threads                              |
| wait/synch/mutex/sql/LOCK_event_queue                                          |
| wait/synch/mutex/sql/Event_scheduler::LOCK_scheduler_state                     |
| wait/synch/mutex/sql/LOCK_thread_cache                                         |
| wait/synch/mutex/sql/LOCK_connection_count                                     |
| wait/synch/mutex/sql/LOCK_thd_list                                             |
| wait/synch/mutex/sql/LOCK_thd_remove                                           |
| wait/synch/mutex/sql/LOCK_thread_ids                                           |
| wait/synch/mutex/sql/LOCK_load_client_plugin                                   |
| wait/synch/mutex/sql/LOCK_item_func_sleep                                      |
| wait/synch/mutex/sql/DEBUG_SYNC::mutex                                         |
| wait/synch/mutex/sql/MDL_wait::LOCK_wait_status                                |
| wait/synch/mutex/sql/Partiton_share::auto_inc_mutex                            |
| wait/synch/mutex/sql/LOCK_open                                                 |
| wait/synch/mutex/sql/LOCK_table_cache                                          |
| wait/synch/mutex/sql/LOCK_slave_list                                           |
| wait/synch/mutex/sql/LOCK_transaction_cache                                    |
| wait/synch/mutex/sql/LOCK_plugin                                               |
| wait/synch/mutex/sql/LOCK_plugin_delete                                        |
| wait/synch/mutex/csv/tina                                                      |
| wait/synch/mutex/csv/TINA_SHARE::mutex                                         |
| wait/synch/mutex/innodb/commit_cond_mutex                                      |
| wait/synch/mutex/innodb/innobase_share_mutex                                   |
| wait/synch/mutex/innodb/autoinc_mutex                                          |
| wait/synch/mutex/innodb/buf_pool_mutex                                         |
| wait/synch/mutex/innodb/buf_pool_zip_mutex                                     |
| wait/synch/mutex/innodb/cache_last_read_mutex                                  |
| wait/synch/mutex/innodb/dict_foreign_err_mutex                                 |
| wait/synch/mutex/innodb/dict_sys_mutex                                         |
| wait/synch/mutex/innodb/recalc_pool_mutex                                      |
| wait/synch/mutex/innodb/file_format_max_mutex                                  |
| wait/synch/mutex/innodb/fil_system_mutex                                       |
| wait/synch/mutex/innodb/flush_list_mutex                                       |
| wait/synch/mutex/innodb/fts_bg_threads_mutex                                   |
| wait/synch/mutex/innodb/fts_delete_mutex                                       |
| wait/synch/mutex/innodb/fts_optimize_mutex                                     |
| wait/synch/mutex/innodb/fts_doc_id_mutex                                       |
| wait/synch/mutex/innodb/fts_pll_tokenize_mutex                                 |
| wait/synch/mutex/innodb/log_flush_order_mutex                                  |
| wait/synch/mutex/innodb/hash_table_mutex                                       |
| wait/synch/mutex/innodb/ibuf_bitmap_mutex                                      |
| wait/synch/mutex/innodb/ibuf_mutex                                             |
| wait/synch/mutex/innodb/ibuf_pessimistic_insert_mutex                          |
| wait/synch/mutex/innodb/log_sys_mutex                                          |
| wait/synch/mutex/innodb/log_sys_write_mutex                                    |
| wait/synch/mutex/innodb/log_cmdq_mutex                                         |
| wait/synch/mutex/innodb/mutex_list_mutex                                       |
| wait/synch/mutex/innodb/page_cleaner_mutex                                     |
| wait/synch/mutex/innodb/page_zip_stat_per_index_mutex                          |
| wait/synch/mutex/innodb/purge_sys_pq_mutex                                     |
| wait/synch/mutex/innodb/recv_sys_mutex                                         |
| wait/synch/mutex/innodb/recv_writer_mutex                                      |
| wait/synch/mutex/innodb/redo_rseg_mutex                                        |
| wait/synch/mutex/innodb/noredo_rseg_mutex                                      |
| wait/synch/mutex/innodb/rw_lock_debug_mutex                                    |
| wait/synch/mutex/innodb/rw_lock_list_mutex                                     |
| wait/synch/mutex/innodb/rw_lock_mutex                                          |
| wait/synch/mutex/innodb/srv_dict_tmpfile_mutex                                 |
| wait/synch/mutex/innodb/srv_innodb_monitor_mutex                               |
| wait/synch/mutex/innodb/srv_misc_tmpfile_mutex                                 |
| wait/synch/mutex/innodb/srv_monitor_file_mutex                                 |
| wait/synch/mutex/innodb/sync_thread_mutex                                      |
| wait/synch/mutex/innodb/buf_dblwr_mutex                                        |
| wait/synch/mutex/innodb/trx_undo_mutex                                         |
| wait/synch/mutex/innodb/trx_pool_mutex                                         |
| wait/synch/mutex/innodb/trx_pool_manager_mutex                                 |
| wait/synch/mutex/innodb/srv_sys_mutex                                          |
| wait/synch/mutex/innodb/lock_mutex                                             |
| wait/synch/mutex/innodb/lock_wait_mutex                                        |
| wait/synch/mutex/innodb/trx_mutex                                              |
| wait/synch/mutex/innodb/srv_threads_mutex                                      |
| wait/synch/mutex/innodb/rtr_active_mutex                                       |
| wait/synch/mutex/innodb/rtr_match_mutex                                        |
| wait/synch/mutex/innodb/rtr_path_mutex                                         |
| wait/synch/mutex/innodb/rtr_ssn_mutex                                          |
| wait/synch/mutex/innodb/trx_sys_mutex                                          |
| wait/synch/mutex/innodb/thread_mutex                                           |
| wait/synch/mutex/innodb/sync_array_mutex                                       |
| wait/synch/mutex/innodb/zip_pad_mutex                                          |
| wait/synch/mutex/innodb/row_drop_list_mutex                                    |
| wait/synch/mutex/innodb/master_key_id_mutex                                    |
| wait/synch/mutex/myisam/MI_SORT_INFO::mutex                                    |
| wait/synch/mutex/myisam/MYISAM_SHARE::intern_lock                              |
| wait/synch/mutex/myisam/MI_CHECK::print_msg                                    |
| wait/synch/mutex/myisammrg/MYRG_INFO::mutex                                    |
| wait/synch/mutex/archive/Archive_share::mutex                                  |
| wait/synch/mutex/blackhole/blackhole                                           |
| wait/synch/mutex/semisync/LOCK_binlog_                                         |
| wait/synch/mutex/semisync/Ack_receiver::m_mutex                                |
| wait/synch/mutex/sql/tz_LOCK                                                   |
# wait/synch/rwlock读写锁
| wait/synch/rwlock/sql/Binlog_transmit_delegate::lock                           |
| wait/synch/rwlock/sql/Binlog_relay_IO_delegate::lock                           |
| wait/synch/rwlock/sql/LOCK_grant                                               |
| wait/synch/rwlock/sql/LOGGER::LOCK_logger                                      |
| wait/synch/rwlock/sql/LOCK_sys_init_connect                                    |
| wait/synch/rwlock/sql/LOCK_sys_init_slave                                      |
| wait/synch/rwlock/sql/LOCK_system_variables_hash                               |
| wait/synch/rwlock/sql/Query_cache_query::lock                                  |
| wait/synch/rwlock/sql/gtid_commit_rollback                                     |
| wait/synch/rwlock/sql/gtid_mode_lock                                           |
| wait/synch/rwlock/sql/channel_map_lock                                         |
| wait/synch/rwlock/sql/channel_lock                                             |
| wait/synch/rwlock/sql/Trans_delegate::lock                                     |
| wait/synch/rwlock/sql/Server_state_delegate::lock                              |
| wait/synch/rwlock/sql/Binlog_storage_delegate::lock                            |
| wait/synch/rwlock/mysys/SAFE_HASH::lock                                        |
| wait/synch/rwlock/session/LOCK_srv_session_collection                          |
| wait/synch/rwlock/sql/LOCK_dboptions                                           |
| wait/synch/rwlock/sql/MDL_lock::rwlock                                         |
| wait/synch/rwlock/sql/MDL_context::LOCK_waiting_for                            |
| wait/synch/sxlock/innodb/btr_search_latch                                      |
| wait/synch/sxlock/innodb/buf_block_debug_latch                                 |
| wait/synch/sxlock/innodb/dict_operation_lock                                   |
| wait/synch/sxlock/innodb/fil_space_latch                                       |
| wait/synch/sxlock/innodb/checkpoint_lock                                       |
| wait/synch/sxlock/innodb/fts_cache_rw_lock                                     |
| wait/synch/sxlock/innodb/fts_cache_init_rw_lock                                |
| wait/synch/sxlock/innodb/trx_i_s_cache_lock                                    |
| wait/synch/sxlock/innodb/trx_purge_latch                                       |
| wait/synch/sxlock/innodb/index_tree_rw_lock                                    |
| wait/synch/sxlock/innodb/index_online_log                                      |
| wait/synch/sxlock/innodb/dict_table_stats                                      |
| wait/synch/sxlock/innodb/hash_table_locks                                      |
| wait/synch/rwlock/myisam/MYISAM_SHARE::key_root_lock                           |
| wait/synch/rwlock/myisam/MYISAM_SHARE::mmap_lock                               |
| wait/synch/rwlock/sql/THR_LOCK_servers                                         |
| wait/synch/rwlock/sql/THR_LOCK_udf                                             |
| wait/synch/cond/sql/PAGE::cond                                                 |
# wait/synch/cond条件阻塞等待
| wait/synch/cond/sql/TC_LOG_MMAP::COND_active                                   |
| wait/synch/cond/sql/TC_LOG_MMAP::COND_pool                                     |
| wait/synch/cond/sql/MYSQL_BIN_LOG::COND_done                                   |
| wait/synch/cond/sql/MYSQL_BIN_LOG::update_cond                                 |
| wait/synch/cond/sql/MYSQL_BIN_LOG::prep_xids_cond                              |
| wait/synch/cond/sql/MYSQL_RELAY_LOG::COND_done                                 |
| wait/synch/cond/sql/MYSQL_RELAY_LOG::update_cond                               |
| wait/synch/cond/sql/MYSQL_RELAY_LOG::prep_xids_cond                            |
| wait/synch/cond/sql/Query_cache::COND_cache_status_changed                     |
| wait/synch/cond/sql/COND_manager                                               |
| wait/synch/cond/sql/COND_server_started                                        |
| wait/synch/cond/sql/COND_socket_listener_active                                |
| wait/synch/cond/sql/COND_start_signal_handler                                  |
| wait/synch/cond/sql/COND_thr_lock                                              |
| wait/synch/cond/sql/Item_func_sleep::cond                                      |
| wait/synch/cond/sql/Master_info::data_cond                                     |
| wait/synch/cond/sql/Master_info::start_cond                                    |
| wait/synch/cond/sql/Master_info::stop_cond                                     |
| wait/synch/cond/sql/Master_info::sleep_cond                                    |
| wait/synch/cond/sql/Relay_log_info::data_cond                                  |
| wait/synch/cond/sql/Relay_log_info::log_space_cond                             |
| wait/synch/cond/sql/Relay_log_info::start_cond                                 |
| wait/synch/cond/sql/Relay_log_info::stop_cond                                  |
| wait/synch/cond/sql/Relay_log_info::sleep_cond                                 |
| wait/synch/cond/sql/Relay_log_info::pending_jobs_cond                          |
| wait/synch/cond/sql/Worker_info::jobs_cond                                     |
| wait/synch/cond/sql/Relay_log_info::mts_gaq_cond                               |
| wait/synch/cond/sql/TABLE_SHARE::cond                                          |
| wait/synch/cond/sql/User_level_lock::cond                                      |
| wait/synch/cond/sql/Gtid_state                                                 |
| wait/synch/cond/sql/COND_compress_gtid_table                                   |
| wait/synch/cond/sql/Commit_order_manager::m_workers.cond                       |
| wait/synch/cond/sql/Relay_log_info::slave_worker_hash_lock                     |
| wait/synch/cond/mysys/IO_CACHE_SHARE::cond                                     |
| wait/synch/cond/mysys/IO_CACHE_SHARE::cond_writer                              |
| wait/synch/cond/mysys/THR_COND_threads                                         |
| wait/synch/cond/sql/Event_scheduler::COND_state                                |
| wait/synch/cond/sql/COND_queue_state                                           |
| wait/synch/cond/sql/COND_thread_cache                                          |
| wait/synch/cond/sql/COND_flush_thread_cache                                    |
| wait/synch/cond/sql/COND_connection_count                                      |
| wait/synch/cond/sql/COND_thd_list                                              |
| wait/synch/cond/sql/DEBUG_SYNC::cond                                           |
| wait/synch/cond/sql/MDL_context::COND_wait_status                              |
| wait/synch/cond/sql/COND_open                                                  |
| wait/synch/cond/innodb/commit_cond                                             |
| wait/synch/cond/myisam/MI_SORT_INFO::cond                                      |
| wait/synch/cond/myisam/keycache_thread_var::suspend                            |
| wait/synch/cond/semisync/COND_binlog_send_                                     |
| wait/synch/cond/semisync/Ack_receiver::m_cond                                  |
# wait/io/file文件IO
| wait/io/file/sql/map                                                           |
| wait/io/file/sql/binlog                                                        |
| wait/io/file/sql/binlog_cache                                                  |
| wait/io/file/sql/binlog_index                                                  |
| wait/io/file/sql/binlog_index_cache                                            |
| wait/io/file/sql/relaylog                                                      |
| wait/io/file/sql/relaylog_cache                                                |
| wait/io/file/sql/relaylog_index                                                |
| wait/io/file/sql/relaylog_index_cache                                          |
| wait/io/file/sql/io_cache                                                      |
| wait/io/file/sql/casetest                                                      |
| wait/io/file/sql/dbopt                                                         |
| wait/io/file/sql/des_key_file                                                  |
| wait/io/file/sql/ERRMSG                                                        |
| wait/io/file/sql/select_to_file                                                |
| wait/io/file/sql/file_parser                                                   |
| wait/io/file/sql/FRM                                                           |
| wait/io/file/sql/global_ddl_log                                                |
| wait/io/file/sql/load                                                          |
| wait/io/file/sql/LOAD_FILE                                                     |
| wait/io/file/sql/log_event_data                                                |
| wait/io/file/sql/log_event_info                                                |
| wait/io/file/sql/master_info                                                   |
| wait/io/file/sql/misc                                                          |
| wait/io/file/sql/partition_ddl_log                                             |
| wait/io/file/sql/pid                                                           |
| wait/io/file/sql/query_log                                                     |
| wait/io/file/sql/relay_log_info                                                |
| wait/io/file/sql/send_file                                                     |
| wait/io/file/sql/slow_log                                                      |
| wait/io/file/sql/tclog                                                         |
| wait/io/file/sql/trigger_name                                                  |
| wait/io/file/sql/trigger                                                       |
| wait/io/file/sql/init                                                          |
| wait/io/file/mysys/proc_meminfo                                                |
| wait/io/file/mysys/charset                                                     |
| wait/io/file/mysys/cnf                                                         |
| wait/io/file/csv/metadata                                                      |
| wait/io/file/csv/data                                                          |
| wait/io/file/csv/update                                                        |
| wait/io/file/innodb/innodb_data_file                                           |
| wait/io/file/innodb/innodb_log_file                                            |
| wait/io/file/innodb/innodb_temp_file                                           |
| wait/io/file/myisam/data_tmp                                                   |
| wait/io/file/myisam/dfile                                                      |
| wait/io/file/myisam/kfile                                                      |
| wait/io/file/myisam/log                                                        |
| wait/io/file/myisammrg/MRG                                                     |
| wait/io/file/archive/metadata                                                  |
| wait/io/file/archive/data                                                      |
| wait/io/file/archive/FRM                                                       |
| wait/io/file/partition/ha_partition::parfile                                   |
| wait/io/table/sql/handler                                                      |
# wait/lock/table表级锁
| wait/lock/table/sql/handler                                                    |
# stage/sql线程执行阶段
| stage/sql/After create                                                         |
| stage/sql/allocating local table                                               |
| stage/sql/preparing for alter table                                            |
| stage/sql/altering table                                                       |
| stage/sql/committing alter table to storage engine                             |
| stage/sql/Changing master                                                      |
| stage/sql/Checking master version                                              |
| stage/sql/checking permissions                                                 |
| stage/sql/checking privileges on cached query                                  |
| stage/sql/checking query cache for query                                       |
| stage/sql/cleaning up                                                          |
| stage/sql/closing tables                                                       |
| stage/sql/Compressing gtid_executed table                                      |
| stage/sql/Connecting to master                                                 |
| stage/sql/converting HEAP to ondisk                                            |
| stage/sql/Copying to group table                                               |
| stage/sql/Copying to tmp table                                                 |
| stage/sql/copy to tmp table                                                    |
| stage/sql/Creating sort index                                                  |
| stage/sql/creating table                                                       |
| stage/sql/Creating tmp table                                                   |
| stage/sql/deleting from main table                                             |
| stage/sql/deleting from reference tables                                       |
| stage/sql/discard_or_import_tablespace                                         |
| stage/sql/end                                                                  |
| stage/sql/executing                                                            |
| stage/sql/Execution of init_command                                            |
| stage/sql/explaining                                                           |
| stage/sql/Finished reading one binlog; switching to next binlog                |
| stage/sql/Flushing relay log and master info repository.                       |
| stage/sql/Flushing relay-log info file.                                        |
| stage/sql/freeing items                                                        |
| stage/sql/FULLTEXT initialization                                              |
| stage/sql/got handler lock                                                     |
| stage/sql/got old table                                                        |
| stage/sql/init                                                                 |
| stage/sql/insert                                                               |
| stage/sql/invalidating query cache entries (table)                             |
| stage/sql/invalidating query cache entries (table list)                        |
| stage/sql/Killing slave                                                        |
| stage/sql/logging slow query                                                   |
| stage/sql/Making temporary file (append) before replaying LOAD DATA INFILE     |
| stage/sql/Making temporary file (create) before replaying LOAD DATA INFILE     |
| stage/sql/manage keys                                                          |
| stage/sql/Master has sent all binlog to slave; waiting for more updates        |
| stage/sql/Opening tables                                                       |
| stage/sql/optimizing                                                           |
| stage/sql/preparing                                                            |
| stage/sql/Purging old relay logs                                               |
| stage/sql/query end                                                            |
| stage/sql/Queueing master event to the relay log                               |
| stage/sql/Reading event from the relay log                                     |
| stage/sql/Registering slave on master                                          |
| stage/sql/Removing duplicates                                                  |
| stage/sql/removing tmp table                                                   |
| stage/sql/rename                                                               |
| stage/sql/rename result table                                                  |
| stage/sql/Requesting binlog dump                                               |
| stage/sql/reschedule                                                           |
| stage/sql/Searching rows for update                                            |
| stage/sql/Sending binlog event to slave                                        |
| stage/sql/sending cached result to client                                      |
| stage/sql/Sending data                                                         |
| stage/sql/setup                                                                |
| stage/sql/Slave has read all relay log; waiting for more updates               |
| stage/sql/Waiting for an event from Coordinator                                |
| stage/sql/Waiting for slave workers to process their queues                    |
| stage/sql/Waiting for Slave Worker queue                                       |
| stage/sql/Waiting for Slave Workers to free pending events                     |
| stage/sql/Waiting for Slave Worker to release partition                        |
| stage/sql/Waiting for workers to exit                                          |
| stage/sql/Sorting for group                                                    |
| stage/sql/Sorting for order                                                    |
| stage/sql/Sorting result                                                       |
| stage/sql/Waiting until MASTER_DELAY seconds after master executed event       |
| stage/sql/statistics                                                           |
| stage/sql/storing result in query cache                                        |
| stage/sql/storing row into queue                                               |
| stage/sql/System lock                                                          |
| stage/sql/update                                                               |
| stage/sql/updating                                                             |
| stage/sql/updating main table                                                  |
| stage/sql/updating reference tables                                            |
| stage/sql/upgrading lock                                                       |
| stage/sql/User sleep                                                           |
| stage/sql/verifying table                                                      |
| stage/sql/Waiting for GTID to be committed                                     |
| stage/sql/waiting for handler insert                                           |
| stage/sql/waiting for handler lock                                             |
| stage/sql/waiting for handler open                                             |
| stage/sql/Waiting for INSERT                                                   |
| stage/sql/Waiting for master to send event                                     |
| stage/sql/Waiting for master update                                            |
| stage/sql/Waiting for the slave SQL thread to free enough relay log space      |
| stage/sql/Waiting for slave mutex on exit                                      |
| stage/sql/Waiting for slave thread to start                                    |
| stage/sql/Waiting for table flush                                              |
| stage/sql/Waiting for query cache lock                                         |
| stage/sql/Waiting for the next event in relay log                              |
| stage/sql/Waiting for the slave SQL thread to advance position                 |
| stage/sql/Waiting to finalize termination                                      |
| stage/sql/Waiting for preceding transaction to commit                          |
| stage/sql/Waiting for dependent transaction to commit                          |
| stage/sql/Suspending                                                           |
| stage/sql/starting                                                             |
| stage/sql/Waiting for no channel reference.                                    |
| stage/mysys/Waiting for table level lock                                       |
| stage/sql/Waiting on empty queue                                               |
| stage/sql/Waiting for next activation                                          |
| stage/sql/Waiting for the scheduler to stop                                    |
| stage/sql/Waiting for global read lock                                         |
| stage/sql/Waiting for tablespace metadata lock                                 |
| stage/sql/Waiting for schema metadata lock                                     |
| stage/sql/Waiting for table metadata lock                                      |
| stage/sql/Waiting for stored function metadata lock                            |
| stage/sql/Waiting for stored procedure metadata lock                           |
| stage/sql/Waiting for trigger metadata lock                                    |
| stage/sql/Waiting for event metadata lock                                      |
| stage/sql/Waiting for commit lock                                              |
| stage/sql/User lock                                                            |
| stage/sql/Waiting for locking service lock                                     |
| stage/innodb/alter table (end)                                                 |
| stage/innodb/alter table (flush)                                               |
| stage/innodb/alter table (insert)                                              |
| stage/innodb/alter table (log apply index)                                     |
| stage/innodb/alter table (log apply table)                                     |
| stage/innodb/alter table (merge sort)                                          |
| stage/innodb/alter table (read PK and internal sort)                           |
| stage/innodb/buffer pool load                                                  |
| stage/semisync/Waiting for semi-sync ACK from slave                            |
| stage/semisync/Waiting for semi-sync slave connection                          |
| stage/semisync/Reading semi-sync ACK from slave                                |
# statement/sql/命令或者SQL
| statement/sql/select                                                           |
| statement/sql/create_table                                                     |
| statement/sql/create_index                                                     |
| statement/sql/alter_table                                                      |
| statement/sql/update                                                           |
| statement/sql/insert                                                           |
| statement/sql/insert_select                                                    |
| statement/sql/delete                                                           |
| statement/sql/truncate                                                         |
| statement/sql/drop_table                                                       |
| statement/sql/drop_index                                                       |
| statement/sql/show_databases                                                   |
| statement/sql/show_tables                                                      |
| statement/sql/show_fields                                                      |
| statement/sql/show_keys                                                        |
| statement/sql/show_variables                                                   |
| statement/sql/show_status                                                      |
| statement/sql/show_engine_logs                                                 |
| statement/sql/show_engine_status                                               |
| statement/sql/show_engine_mutex                                                |
| statement/sql/show_processlist                                                 |
| statement/sql/show_master_status                                               |
| statement/sql/show_slave_status                                                |
| statement/sql/show_grants                                                      |
| statement/sql/show_create_table                                                |
| statement/sql/show_charsets                                                    |
| statement/sql/show_collations                                                  |
| statement/sql/show_create_db                                                   |
| statement/sql/show_table_status                                                |
| statement/sql/show_triggers                                                    |
| statement/sql/load                                                             |
| statement/sql/set_option                                                       |
| statement/sql/lock_tables                                                      |
| statement/sql/unlock_tables                                                    |
| statement/sql/grant                                                            |
| statement/sql/change_db                                                        |
| statement/sql/create_db                                                        |
| statement/sql/drop_db                                                          |
| statement/sql/alter_db                                                         |
| statement/sql/repair                                                           |
| statement/sql/replace                                                          |
| statement/sql/replace_select                                                   |
| statement/sql/create_udf                                                       |
| statement/sql/drop_function                                                    |
| statement/sql/revoke                                                           |
| statement/sql/optimize                                                         |
| statement/sql/check                                                            |
| statement/sql/assign_to_keycache                                               |
| statement/sql/preload_keys                                                     |
| statement/sql/flush                                                            |
| statement/sql/kill                                                             |
| statement/sql/analyze                                                          |
| statement/sql/rollback                                                         |
| statement/sql/rollback_to_savepoint                                            |
| statement/sql/commit                                                           |
| statement/sql/savepoint                                                        |
| statement/sql/release_savepoint                                                |
| statement/sql/slave_start                                                      |
| statement/sql/slave_stop                                                       |
| statement/sql/group_replication_start                                          |
| statement/sql/group_replication_stop                                           |
| statement/sql/begin                                                            |
| statement/sql/change_master                                                    |
| statement/sql/change_repl_filter                                               |
| statement/sql/rename_table                                                     |
| statement/sql/reset                                                            |
| statement/sql/purge                                                            |
| statement/sql/purge_before_date                                                |
| statement/sql/show_binlogs                                                     |
| statement/sql/show_open_tables                                                 |
| statement/sql/ha_open                                                          |
| statement/sql/ha_close                                                         |
| statement/sql/ha_read                                                          |
| statement/sql/show_slave_hosts                                                 |
| statement/sql/delete_multi                                                     |
| statement/sql/update_multi                                                     |
| statement/sql/show_binlog_events                                               |
| statement/sql/do                                                               |
| statement/sql/show_warnings                                                    |
| statement/sql/empty_query                                                      |
| statement/sql/show_errors                                                      |
| statement/sql/show_storage_engines                                             |
| statement/sql/show_privileges                                                  |
| statement/sql/help                                                             |
| statement/sql/create_user                                                      |
| statement/sql/drop_user                                                        |
| statement/sql/rename_user                                                      |
| statement/sql/revoke_all                                                       |
| statement/sql/checksum                                                         |
| statement/sql/create_procedure                                                 |
| statement/sql/create_function                                                  |
| statement/sql/call_procedure                                                   |
| statement/sql/drop_procedure                                                   |
| statement/sql/alter_procedure                                                  |
| statement/sql/alter_function                                                   |
| statement/sql/show_create_proc                                                 |
| statement/sql/show_create_func                                                 |
| statement/sql/show_procedure_status                                            |
| statement/sql/show_function_status                                             |
| statement/sql/prepare_sql                                                      |
| statement/sql/execute_sql                                                      |
| statement/sql/dealloc_sql                                                      |
| statement/sql/create_view                                                      |
| statement/sql/drop_view                                                        |
| statement/sql/create_trigger                                                   |
| statement/sql/drop_trigger                                                     |
| statement/sql/xa_start                                                         |
| statement/sql/xa_end                                                           |
| statement/sql/xa_prepare                                                       |
| statement/sql/xa_commit                                                        |
| statement/sql/xa_rollback                                                      |
| statement/sql/xa_recover                                                       |
| statement/sql/show_procedure_code                                              |
| statement/sql/show_function_code                                               |
| statement/sql/alter_tablespace                                                 |
| statement/sql/install_plugin                                                   |
| statement/sql/uninstall_plugin                                                 |
| statement/sql/binlog                                                           |
| statement/sql/show_plugins                                                     |
| statement/sql/create_server                                                    |
| statement/sql/drop_server                                                      |
| statement/sql/alter_server                                                     |
| statement/sql/create_event                                                     |
| statement/sql/alter_event                                                      |
| statement/sql/drop_event                                                       |
| statement/sql/show_create_event                                                |
| statement/sql/show_events                                                      |
| statement/sql/show_create_trigger                                              |
| statement/sql/alter_db_upgrade                                                 |
| statement/sql/show_profile                                                     |
| statement/sql/show_profiles                                                    |
| statement/sql/signal                                                           |
| statement/sql/resignal                                                         |
| statement/sql/show_relaylog_events                                             |
| statement/sql/get_diagnostics                                                  |
| statement/sql/alter_user                                                       |
| statement/sql/explain_other                                                    |
| statement/sql/show_create_user                                                 |
| statement/sql/shutdown                                                         |
| statement/sql/alter_instance                                                   |
| statement/sql/error                                                            |
# statement/sp游标fetch
| statement/sp/stmt                                                              |
| statement/sp/set                                                               |
| statement/sp/set_trigger_field                                                 |
| statement/sp/jump                                                              |
| statement/sp/jump_if_not                                                       |
| statement/sp/freturn                                                           |
| statement/sp/hpush_jump                                                        |
| statement/sp/hpop                                                              |
| statement/sp/hreturn                                                           |
| statement/sp/cpush                                                             |
| statement/sp/cpop                                                              |
| statement/sp/copen                                                             |
| statement/sp/cclose                                                            |
| statement/sp/cfetch                                                            |
| statement/sp/error                                                             |
| statement/sp/set_case_expr                                                     |
# statement/scheduler事件调度器
| statement/scheduler/event                                                      |
# statement/com统计com_xx
| statement/com/Sleep                                                            |
| statement/com/Quit                                                             |
| statement/com/Init DB                                                          |
| statement/com/Field List                                                       |
| statement/com/Create DB                                                        |
| statement/com/Drop DB                                                          |
| statement/com/Refresh                                                          |
| statement/com/Shutdown                                                         |
| statement/com/Statistics                                                       |
| statement/com/Processlist                                                      |
| statement/com/Connect                                                          |
| statement/com/Kill                                                             |
| statement/com/Debug                                                            |
| statement/com/Ping                                                             |
| statement/com/Time                                                             |
| statement/com/Delayed insert                                                   |
| statement/com/Change user                                                      |
| statement/com/Binlog Dump                                                      |
| statement/com/Table Dump                                                       |
| statement/com/Connect Out                                                      |
| statement/com/Register Slave                                                   |
| statement/com/Prepare                                                          |
| statement/com/Execute                                                          |
| statement/com/Long Data                                                        |
| statement/com/Close stmt                                                       |
| statement/com/Reset stmt                                                       |
| statement/com/Set option                                                       |
| statement/com/Fetch                                                            |
| statement/com/Daemon                                                           |
| statement/com/Binlog Dump GTID                                                 |
| statement/com/Reset Connection                                                 |
| statement/com/Error                                                            |
# statement/abstract查询的概要信息
| statement/abstract/Query                                                       |
| statement/abstract/new_packet                                                  |
| statement/abstract/relay_log                                                   |
# transaction事务
| transaction                                                                    |
# wait/io/socket通信
| wait/io/socket/sql/server_tcpip_socket                                         |
| wait/io/socket/sql/server_unix_socket                                          |
| wait/io/socket/sql/client_connection                                           |
# idle空闲socket
| idle                                                                           |
# memory/performance_schema内部内存使用
| memory/performance_schema/mutex_instances                                      |
| memory/performance_schema/rwlock_instances                                     |
| memory/performance_schema/cond_instances                                       |
| memory/performance_schema/file_instances                                       |
| memory/performance_schema/socket_instances                                     |
| memory/performance_schema/metadata_locks                                       |
| memory/performance_schema/file_handle                                          |
| memory/performance_schema/accounts                                             |
| memory/performance_schema/events_waits_summary_by_account_by_event_name        |
| memory/performance_schema/events_stages_summary_by_account_by_event_name       |
| memory/performance_schema/events_statements_summary_by_account_by_event_name   |
| memory/performance_schema/events_transactions_summary_by_account_by_event_name |
| memory/performance_schema/memory_summary_by_account_by_event_name              |
| memory/performance_schema/events_stages_summary_global_by_event_name           |
| memory/performance_schema/events_statements_summary_global_by_event_name       |
| memory/performance_schema/memory_summary_global_by_event_name                  |
| memory/performance_schema/hosts                                                |
| memory/performance_schema/events_waits_summary_by_host_by_event_name           |
| memory/performance_schema/events_stages_summary_by_host_by_event_name          |
| memory/performance_schema/events_statements_summary_by_host_by_event_name      |
| memory/performance_schema/events_transactions_summary_by_host_by_event_name    |
| memory/performance_schema/memory_summary_by_host_by_event_name                 |
| memory/performance_schema/threads                                              |
| memory/performance_schema/events_waits_summary_by_thread_by_event_name         |
| memory/performance_schema/events_stages_summary_by_thread_by_event_name        |
| memory/performance_schema/events_statements_summary_by_thread_by_event_name    |
| memory/performance_schema/events_transactions_summary_by_thread_by_event_name  |
| memory/performance_schema/memory_summary_by_thread_by_event_name               |
| memory/performance_schema/events_waits_history                                 |
| memory/performance_schema/events_stages_history                                |
| memory/performance_schema/events_statements_history                            |
| memory/performance_schema/events_statements_history.tokens                     |
| memory/performance_schema/events_statements_history.sqltext                    |
| memory/performance_schema/events_statements_current                            |
| memory/performance_schema/events_statements_current.tokens                     |
| memory/performance_schema/events_statements_current.sqltext                    |
| memory/performance_schema/events_transactions_history                          |
| memory/performance_schema/session_connect_attrs                                |
| memory/performance_schema/users                                                |
| memory/performance_schema/events_waits_summary_by_user_by_event_name           |
| memory/performance_schema/events_stages_summary_by_user_by_event_name          |
| memory/performance_schema/events_statements_summary_by_user_by_event_name      |
| memory/performance_schema/events_transactions_summary_by_user_by_event_name    |
| memory/performance_schema/memory_summary_by_user_by_event_name                 |
| memory/performance_schema/mutex_class                                          |
| memory/performance_schema/rwlock_class                                         |
| memory/performance_schema/cond_class                                           |
| memory/performance_schema/thread_class                                         |
| memory/performance_schema/file_class                                           |
| memory/performance_schema/socket_class                                         |
| memory/performance_schema/stage_class                                          |
| memory/performance_schema/statement_class                                      |
| memory/performance_schema/memory_class                                         |
| memory/performance_schema/setup_actors                                         |
| memory/performance_schema/setup_objects                                        |
| memory/performance_schema/events_statements_summary_by_digest                  |
| memory/performance_schema/events_statements_summary_by_digest.tokens           |
| memory/performance_schema/events_stages_history_long                           |
| memory/performance_schema/events_statements_history_long                       |
| memory/performance_schema/events_statements_history_long.tokens                |
| memory/performance_schema/events_statements_history_long.sqltext               |
| memory/performance_schema/events_transactions_history_long                     |
| memory/performance_schema/events_waits_history_long                            |
| memory/performance_schema/table_handles                                        |
| memory/performance_schema/table_shares                                         |
| memory/performance_schema/table_io_waits_summary_by_index_usage                |
| memory/performance_schema/table_lock_waits_summary_by_table                    |
| memory/performance_schema/events_statements_summary_by_program                 |
| memory/performance_schema/prepared_statements_instances                        |
| memory/performance_schema/scalable_buffer                                      |
# memory/sql数据查询内存使用
| memory/sql/Locked_tables_list::m_locked_tables_root                            |
| memory/sql/display_table_locks                                                 |
| memory/sql/THD::transactions::mem_root                                         |
| memory/sql/Delegate::memroot                                                   |
| memory/sql/sql_acl_mem                                                         |
| memory/sql/sql_acl_memex                                                       |
| memory/sql/acl_cache                                                           |
| memory/sql/thd::main_mem_root                                                  |
| memory/sql/help                                                                |
| memory/sql/new_frm_mem                                                         |
| memory/sql/TABLE_SHARE::mem_root                                               |
| memory/sql/gdl                                                                 |
| memory/sql/Table_triggers_list                                                 |
| memory/sql/servers                                                             |
| memory/sql/Prepared_statement_map                                              |
| memory/sql/Prepared_statement::main_mem_root                                   |
| memory/sql/Protocol_local::m_rset_root                                         |
| memory/sql/Warning_info::m_warn_root                                           |
| memory/sql/THD::sp_cache                                                       |
| memory/sql/sp_head::main_mem_root                                              |
| memory/sql/sp_head::execute_mem_root                                           |
| memory/sql/sp_head::call_mem_root                                              |
| memory/sql/table_mapping::m_mem_root                                           |
| memory/sql/QUICK_RANGE_SELECT::alloc                                           |
| memory/sql/QUICK_INDEX_MERGE_SELECT::alloc                                     |
| memory/sql/QUICK_ROR_INTERSECT_SELECT::alloc                                   |
| memory/sql/QUICK_ROR_UNION_SELECT::alloc                                       |
| memory/sql/QUICK_GROUP_MIN_MAX_SELECT::alloc                                   |
| memory/sql/test_quick_select                                                   |
| memory/sql/prune_partitions::exec                                              |
| memory/sql/MYSQL_BIN_LOG::recover                                              |
| memory/sql/Blob_mem_storage::storage                                           |
| memory/sql/NAMED_ILINK::name                                                   |
| memory/sql/String::value                                                       |
| memory/sql/Sys_var_charptr::value                                              |
| memory/sql/Queue::queue_item                                                   |
| memory/sql/THD::db                                                             |
| memory/sql/user_var_entry                                                      |
| memory/sql/Slave_job_group::group_relay_log_name                               |
| memory/sql/Relay_log_info::group_relay_log_name                                |
| memory/sql/binlog_cache_mngr                                                   |
| memory/sql/Row_data_memory::memory                                             |
| memory/sql/Gtid_set::to_string                                                 |
| memory/sql/Gtid_state::to_string                                               |
| memory/sql/Owned_gtids::to_string                                              |
| memory/sql/Log_event                                                           |
| memory/sql/Incident_log_event::message                                         |
| memory/sql/Rows_query_log_event::rows_query                                    |
| memory/sql/Sort_param::tmp_buffer                                              |
| memory/sql/Filesort_info::merge                                                |
| memory/sql/Filesort_info::record_pointers                                      |
| memory/sql/Filesort_buffer::sort_keys                                          |
| memory/sql/handler::errmsgs                                                    |
| memory/sql/handlerton                                                          |
| memory/sql/XID                                                                 |
| memory/sql/host_cache::hostname                                                |
| memory/sql/user_var_entry::value                                               |
| memory/sql/User_level_lock                                                     |
| memory/sql/MYSQL_LOG::name                                                     |
| memory/sql/TC_LOG_MMAP::pages                                                  |
| memory/sql/my_bitmap_map                                                       |
| memory/sql/QUICK_RANGE_SELECT::mrr_buf_desc                                    |
| memory/sql/Event_queue_element_for_exec::names                                 |
| memory/sql/my_str_malloc                                                       |
| memory/sql/MYSQL_BIN_LOG::basename                                             |
| memory/sql/MYSQL_BIN_LOG::index                                                |
| memory/sql/MYSQL_RELAY_LOG::basename                                           |
| memory/sql/MYSQL_RELAY_LOG::index                                              |
| memory/sql/rpl_filter memory                                                   |
| memory/sql/errmsgs                                                             |
| memory/sql/Gis_read_stream::err_msg                                            |
| memory/sql/Geometry::ptr_and_wkb_data                                          |
| memory/sql/MYSQL_LOCK                                                          |
| memory/sql/NET::buff                                                           |
| memory/sql/NET::compress_packet                                                |
| memory/sql/Event_scheduler::scheduler_param                                    |
| memory/sql/Gtid_set::Interval_chunk                                            |
| memory/sql/Owned_gtids::sidno_to_hash                                          |
| memory/sql/Sid_map::Node                                                       |
| memory/sql/Gtid_state::group_commit_sidno_locks                                |
| memory/sql/Mutex_cond_array::Mutex_cond                                        |
| memory/sql/TABLE_RULE_ENT                                                      |
| memory/sql/Rpl_info_table                                                      |
| memory/sql/Rpl_info_file::buffer                                               |
| memory/sql/db_worker_hash_entry                                                |
| memory/sql/rpl_slave::check_temp_dir                                           |
| memory/sql/rpl_slave::command_buffer                                           |
| memory/sql/binlog_ver_1_event                                                  |
| memory/sql/SLAVE_INFO                                                          |
| memory/sql/binlog_pos                                                          |
| memory/sql/HASH_ROW_ENTRY                                                      |
| memory/sql/binlog_statement_buffer                                             |
| memory/sql/partition_syntax_buffer                                             |
| memory/sql/READ_INFO                                                           |
| memory/sql/JOIN_CACHE                                                          |
| memory/sql/TABLE::sort_io_cache                                                |
| memory/sql/frm                                                                 |
| memory/sql/Unique::sort_buffer                                                 |
| memory/sql/Unique::merge_buffer                                                |
| memory/sql/TABLE                                                               |
| memory/sql/frm::extra_segment_buff                                             |
| memory/sql/frm::form_pos                                                       |
| memory/sql/frm::string                                                         |
| memory/sql/LOG_name                                                            |
| memory/sql/DATE_TIME_FORMAT                                                    |
| memory/sql/DDL_LOG_MEMORY_ENTRY                                                |
| memory/sql/ST_SCHEMA_TABLE                                                     |
| memory/sql/ignored_db                                                          |
| memory/sql/PROFILE                                                             |
| memory/sql/global_system_variables                                             |
| memory/sql/THD::variables                                                      |
| memory/sql/Security_context                                                    |
| memory/sql/Shared_memory_name                                                  |
| memory/sql/bison_stack                                                         |
| memory/sql/THD::handler_tables_hash                                            |
| memory/sql/hash_index_key_buffer                                               |
| memory/sql/dboptions_hash                                                      |
| memory/sql/user_conn                                                           |
| memory/sql/LOG_POS_COORD                                                       |
| memory/sql/XID_STATE                                                           |
| memory/sql/MPVIO_EXT::auth_info                                                |
| memory/sql/opt_bin_logname                                                     |
| memory/sql/Query_cache                                                         |
| memory/sql/READ_RECORD_cache                                                   |
| memory/sql/Quick_ranges                                                        |
| memory/sql/File_query_log::name                                                |
| memory/sql/Table_trigger_dispatcher::m_mem_root                                |
| memory/sql/thd_timer                                                           |
| memory/sql/THD::Session_tracker                                                |
| memory/sql/THD::Session_sysvar_resource_manager                                |
| memory/sql/show_slave_status_io_gtid_set                                       |
| memory/sql/write_set_extraction                                                |
| memory/sql/get_all_tables                                                      |
| memory/sql/fill_schema_schemata                                                |
| memory/sql/native_functions                                                    |
| memory/sql/JSON                                                                |
# memory/client客户端内存使用
| memory/client/mysql_options                                                    |
| memory/client/MYSQL_DATA                                                       |
| memory/client/MYSQL                                                            |
| memory/client/MYSQL_RES                                                        |
| memory/client/MYSQL_ROW                                                        |
| memory/client/MYSQL_STATE_CHANGE_INFO                                          |
| memory/client/MYSQL_HANDSHAKE                                                  |
# --
| memory/vio/ssl_fd                                                              |
| memory/vio/vio                                                                 |
| memory/vio/read_buffer                                                         |
# memory/mysys库sys内存使用
| memory/mysys/max_alloca                                                        |
| memory/mysys/charset_file                                                      |
| memory/mysys/charset_loader                                                    |
| memory/mysys/lf_node                                                           |
| memory/mysys/lf_dynarray                                                       |
| memory/mysys/lf_slist                                                          |
| memory/mysys/LIST                                                              |
| memory/mysys/IO_CACHE                                                          |
| memory/mysys/KEY_CACHE                                                         |
| memory/mysys/SAFE_HASH_ENTRY                                                   |
| memory/mysys/MY_TMPDIR::full_list                                              |
| memory/mysys/MY_BITMAP::bitmap                                                 |
| memory/mysys/my_compress_alloc                                                 |
| memory/mysys/pack_frm                                                          |
| memory/mysys/my_err_head                                                       |
| memory/mysys/my_file_info                                                      |
| memory/mysys/MY_DIR                                                            |
| memory/mysys/MY_STAT                                                           |
| memory/mysys/QUEUE                                                             |
| memory/mysys/DYNAMIC_STRING                                                    |
| memory/mysys/TREE                                                              |
# 内存SQL使用
| memory/sql/Event_basic::mem_root                                               |
| memory/sql/root                                                                |
| memory/sql/load_env_plugins                                                    |
| memory/sql/THD::debug_sync_control                                             |
| memory/sql/debug_sync_control::debug_sync_action                               |
| memory/sql/MDL_context::acquire_locks                                          |
| memory/sql/Partition_share                                                     |
| memory/sql/partition_sort_buffer                                               |
| memory/sql/Partition_admin                                                     |
| memory/sql/plugin_ref                                                          |
| memory/sql/plugin_mem_root                                                     |
| memory/sql/plugin_init_tmp                                                     |
| memory/sql/plugin_int_mem_root                                                 |
| memory/sql/mysql_plugin_dl                                                     |
| memory/sql/mysql_plugin                                                        |
| memory/sql/plugin_bookmark                                                     |
# csv引擎内存使用
| memory/csv/TINA_SHARE                                                          |
| memory/csv/blobroot                                                            |
| memory/csv/tina_set                                                            |
| memory/csv/row                                                                 |
| memory/csv/Transparent_file                                                    |
# InnoDB引擎内存使用
| memory/innodb/adaptive hash index                                              |
| memory/innodb/buf_buf_pool                                                     |
| memory/innodb/dict_stats_bg_recalc_pool_t                                      |
| memory/innodb/dict_stats_index_map_t                                           |
| memory/innodb/dict_stats_n_diff_on_level                                       |
| memory/innodb/other                                                            |
| memory/innodb/row_log_buf                                                      |
| memory/innodb/row_merge_sort                                                   |
| memory/innodb/std                                                              |
| memory/innodb/trx_sys_t::rw_trx_ids                                            |
| memory/innodb/partitioning                                                     |
| memory/innodb/api0api                                                          |
| memory/innodb/btr0btr                                                          |
| memory/innodb/btr0bulk                                                         |
| memory/innodb/btr0cur                                                          |
| memory/innodb/btr0pcur                                                         |
| memory/innodb/btr0sea                                                          |
| memory/innodb/buf0buf                                                          |
| memory/innodb/buf0dblwr                                                        |
| memory/innodb/buf0dump                                                         |
| memory/innodb/buf0flu                                                          |
| memory/innodb/buf0lru                                                          |
| memory/innodb/dict0dict                                                        |
| memory/innodb/dict0mem                                                         |
| memory/innodb/dict0stats                                                       |
| memory/innodb/dict0stats_bg                                                    |
| memory/innodb/eval0eval                                                        |
| memory/innodb/fil0fil                                                          |
| memory/innodb/fsp0file                                                         |
| memory/innodb/fsp0space                                                        |
| memory/innodb/fsp0sysspace                                                     |
| memory/innodb/fts0ast                                                          |
| memory/innodb/fts0config                                                       |
| memory/innodb/fts0fts                                                          |
| memory/innodb/fts0opt                                                          |
| memory/innodb/fts0pars                                                         |
| memory/innodb/fts0que                                                          |
| memory/innodb/fts0sql                                                          |
| memory/innodb/gis0sea                                                          |
| memory/innodb/ha0ha                                                            |
| memory/innodb/ha_innodb                                                        |
| memory/innodb/handler0alter                                                    |
| memory/innodb/hash0hash                                                        |
| memory/innodb/i_s                                                              |
| memory/innodb/ibuf0ibuf                                                        |
| memory/innodb/lexyy                                                            |
| memory/innodb/lock0lock                                                        |
| memory/innodb/log0log                                                          |
| memory/innodb/log0recv                                                         |
| memory/innodb/mem0mem                                                          |
| memory/innodb/os0event                                                         |
| memory/innodb/os0file                                                          |
| memory/innodb/page0cur                                                         |
| memory/innodb/page0zip                                                         |
| memory/innodb/pars0lex                                                         |
| memory/innodb/read0read                                                        |
| memory/innodb/rem0rec                                                          |
| memory/innodb/row0ftsort                                                       |
| memory/innodb/row0import                                                       |
| memory/innodb/row0log                                                          |
| memory/innodb/row0merge                                                        |
| memory/innodb/row0mysql                                                        |
| memory/innodb/row0sel                                                          |
| memory/innodb/row0trunc                                                        |
| memory/innodb/srv0conc                                                         |
| memory/innodb/srv0srv                                                          |
| memory/innodb/srv0start                                                        |
| memory/innodb/sync0arr                                                         |
| memory/innodb/sync0debug                                                       |
| memory/innodb/sync0rw                                                          |
| memory/innodb/sync0types                                                       |
| memory/innodb/trx0i_s                                                          |
| memory/innodb/trx0purge                                                        |
| memory/innodb/trx0roll                                                         |
| memory/innodb/trx0rseg                                                         |
| memory/innodb/trx0sys                                                          |
| memory/innodb/trx0trx                                                          |
| memory/innodb/trx0undo                                                         |
| memory/innodb/usr0sess                                                         |
| memory/innodb/ut0list                                                          |
| memory/innodb/ut0mem                                                           |
| memory/innodb/ut0mutex                                                         |
| memory/innodb/ut0pool                                                          |
| memory/innodb/ut0rbt                                                           |
| memory/innodb/ut0wqueue                                                        |
# MyISAM引擎内存使用
| memory/myisam/MYISAM_SHARE                                                     |
| memory/myisam/MI_INFO                                                          |
| memory/myisam/MI_INFO::ft1_to_ft2                                              |
| memory/myisam/MI_INFO::bulk_insert                                             |
| memory/myisam/record_buffer                                                    |
| memory/myisam/FTB                                                              |
| memory/myisam/FT_INFO                                                          |
| memory/myisam/FTPARSER_PARAM                                                   |
| memory/myisam/ft_memroot                                                       |
| memory/myisam/ft_stopwords                                                     |
| memory/myisam/MI_SORT_PARAM                                                    |
| memory/myisam/MI_SORT_PARAM::wordroot                                          |
| memory/myisam/SORT_FT_BUF                                                      |
| memory/myisam/SORT_KEY_BLOCKS                                                  |
| memory/myisam/filecopy                                                         |
| memory/myisam/SORT_INFO::buffer                                                |
| memory/myisam/MI_DECODE_TREE                                                   |
| memory/myisam/MYISAM_SHARE::decode_tables                                      |
| memory/myisam/preload_buffer                                                   |
| memory/myisam/stPageList::pages                                                |
| memory/myisam/keycache_thread_var                                              |
# 内存类引擎使用
| memory/memory/HP_SHARE                                                         |
| memory/memory/HP_INFO                                                          |
| memory/memory/HP_PTRS                                                          |
| memory/memory/HP_KEYDEF                                                        |
# MyISAM mgr内存使用
| memory/myisammrg/MYRG_INFO                                                     |
| memory/myisammrg/children                                                      |
# 归档引擎内存使用
| memory/archive/FRM                                                             |
| memory/archive/record_buffer                                                   |
# 黑洞内存使用
| memory/blackhole/blackhole_share                                               |
# 分区内存使用
| memory/partition/ha_partition::file                                            |
| memory/partition/ha_partition::engine_array                                    |
| memory/partition/ha_partition::part_ids                                        |
# 半同步内存使用
| memory/semisync/TranxNodeAllocator::block                                      |
# 时间、服务器内存使用
| memory/sql/tz_storage                                                          |
| memory/sql/servers_cache                                                       |
# 用户定义函数内存使用
| memory/sql/udf_mem                                                             |
# 中继日志信息内存使用
| memory/sql/Relay_log_info::mts_coor                                            |
# metadata元数据内存使用
| wait/lock/metadata/sql/mdl                                                     |
+--------------------------------------------------------------------------------+
1037 rows in set (0.09 sec)
```

2.上述检测项，打开后会被记录到performance_schema的表中

+ wait/sync类指标（默认指标和计时关闭）

+ wait/io类指标（默认指标和计时开启）

+ wait/lock类指标（默认指标和计时开启）

  ```
  ENABLE='YES'，则会记录到下面当前线程等待事件表中
  -->performance_schema.events_waits_current
  -->performance_schema.events_waits_history
  -->performance_schema.events_waits_history_long
  -->mutex_instances
  ```

+ stage/sql（默认指标和计时关闭），除copy to tmp table

+ stage/innodb（默认指标和计时开启）

+ stage/semisync（默认指标和计时关闭）

  ```
  ENABLE='YES'，则会记录到下面当前线程执行阶段表中
  -->performance_schema.events_stages_current
  -->performance_schema.events_stages_history
  -->performance_schema.events_stages_history_long
  ```

+ statement（默认指标和计时开启）

  ```
  ENABLE='YES'，则会记录到下面当前线程执行SQL或命令表中
  -->performance_schema.events_statements_current
  -->performance_schema.events_statements_history
  -->performance_schema.events_statements_history_long
  ```

+ transaction（默认指标和计时关闭）

  ```
  ENABLE='YES'，则会记录到下面当前线程执行事务表中
  -->performance_schema.events_transactions_current
  -->performance_schema.events_transactions_history
  -->performance_schema.events_transactions_history_long
  ```

> 上述四类表具备表级别收集开关，由performance_schema.setup_consumers表设置
>
> ```
> mysql> select * from setup_consumers;
> +----------------------------------+---------+
> | NAME                             | ENABLED |
> +----------------------------------+---------+
> | events_stages_current            | YES     |
> | events_stages_history            | YES     |
> | events_stages_history_long       | YES     |
> | events_statements_current        | YES     |
> | events_statements_history        | YES     |
> | events_statements_history_long   | NO      |
> | events_transactions_current      | NO      |
> | events_transactions_history      | NO      |
> | events_transactions_history_long | NO      |
> | events_waits_current             | NO      |
> | events_waits_history             | NO      |
> | events_waits_history_long        | NO      |
> | global_instrumentation           | YES     |
> | thread_instrumentation           | YES     |
> | statements_digest                | YES     |
> +----------------------------------+---------+
> 15 rows in set (0.00 sec)
> # 决定监控是否生效规则
> global_instrumentation->thread_instrumentation=statements_digest->others
> ```

+ wait/io/socket（默认指标和计时关闭）

+ idle（默认指标和计时开启）

  ```
  ENABLE='YES'，则会记录到下面当前会话实例表中
  -->performance_schema.socket_instances
  ```

+ memory/performance_schema（默认指标开启，计时关闭）

+ memory/sql（默认指标开启，计时关闭）

  ```
  ENABLE='YES'，则会记录到下面表中
  -->performance_schema.memory_summary_global_by_event_name
  ```

+ wait/lock/metadata/sql/mdl （5.7默认指标和计时关闭）

  ```
  ENABLE='YES'，则会记录到下面表中
  -->performance_schema.metadata_locks
  ```

3.performance_schema的其他表

1. accounts、hosts、users

```
记录用户、HOST的线程连接信息
```

2. cond_instances

```
记录线程等待条件时，代码在内存中的地址
```

3. xxx_summary_by_xxx

```
聚合纬度的信息统计
```

```
根据执行阶段分类统计
events_stages_summary_by_account_by_event_name
events_stages_summary_by_host_by_event_name
events_stages_summary_by_thread_by_event_name
events_stages_summary_global_by_event_name
events_stages_summary_by_user_by_event_name
```

```
根据SQL执行分类统计
events_statements_summary_by_account_by_event_name
events_statements_summary_by_digest
events_statements_summary_by_host_by_event_name
events_statements_summary_by_program
events_statements_summary_by_thread_by_event_name
events_statements_summary_by_user_by_event_name
events_statements_summary_global_by_event_name
```

```
根据事务分类统计
events_transactions_summary_by_account_by_event_name
events_transactions_summary_by_host_by_event_name
events_transactions_summary_by_thread_by_event_name
events_transactions_summary_by_user_by_event_name
events_transactions_summary_global_by_event_name
```

```
根据等待事项分类统计
events_waits_summary_by_account_by_event_name
events_waits_summary_by_host_by_event_name
events_waits_summary_by_instance
events_waits_summary_by_thread_by_event_name
events_waits_summary_by_user_by_event_name
events_waits_summary_global_by_event_name
```

```
根据数据库事件统计文件使用情况
file_summary_by_event_name
```

```
根据磁盘文件使用情况分类统计
file_summary_by_instance
```

```
根据内存结构按各维度分类统计
memory_summary_by_account_by_event_name
memory_summary_by_host_by_event_name
memory_summary_by_thread_by_event_name
memory_summary_by_user_by_event_name
memory_summary_global_by_event_name
```

```
根据内存对象分类统计
objects_summary_global_by_type
```

```
根据套接字使用统计
socket_summary_by_event_name
socket_summary_by_instance
```

```
根据索引使用统计（逻辑IO）
table_io_waits_summary_by_index_usage
```

```
根据表使用统计（逻辑IO）
table_io_waits_summary_by_table
```

```
根据表锁等待信息统计
table_lock_waits_summary_by_table
```

4. file_instances	

```
系统文件打开执行IO操作时记录信息
```

5. global_status、session_status、status_by_thread、status_by_host、status_by_user

```
记录当前全局、会话、线程状态信息
```

6. global_variables、session_variables、variables_by_thread

```
记录当前全局、会话、线程变量信息
```

7. hot_cache

```
记录HOST、IP信息避免域名解析，大小由变量hot_cache_size决定，当然若host均为IP，设置skip_name_resolve也可
```

8. metadata_locks

```
元信息锁不仅用于表保持数据一致性，而且也用于库、存储项目、表空间、用户锁等
可以检索的信息：
1.shows which sessions own which current metadata locks
2.shows which sessions are waiting for which metadata locks
3.Lock requests that have been killed by the deadlock detector
4.Lock requests that have timed out and are waiting for the requesting session's lock request to be discarded
```

```
LOCK_STATUS:展示锁的状态
+ GRANTED：表示获得锁的持有
+ PENDING：表示请求锁但不能获得锁的持有
+ VICTIM：表示请求由于死锁检测，从阻塞到清除
+ TIMEOUT：表示请求由于超时，从阻塞到超时
+ KILLED：表示请求被中止
+ PRE_ACQUIRE_NOTIFY：向存储引擎请求锁初始阶段
+ POST_RELEASE_NOTIFY：向存储引擎释放锁结束阶段
```

9. mutex_instances

```
互斥对象信息是一种代码同步机制，避免多个代码程序同时进入共享资源区，如a file, a buffer, or some piece of data
```

```
events_waits_current, to see what mutex a thread is waiting for
mutex_instances, to see which other thread currently owns a mutex
```

10. objects_summary_global_by_type

```
数据库内存对象统计，比如performance_schema各种表的使用、复制对象信息、GTID对象信息、表的使用，字段有COUNT_STAR，SUM_TIMER_WAIT
```

11. performance_timer

```
显示可选择的不同计时间隔的计时器种类
```

12. prepared_statements_instances

```
统计预编译查询的执行，包括两种方式：C API和SQL命令，由setup_instruments中指标控制
statement/com/Prepare	COM_STMT
statement/com/Execute	COM_STMT_EXECUTE
statement/sql/prepare_sql	SQLCOM_PREPARE
statement/sql/execute_sql	SQLCOM_EXECUTE
```

13. replication_applier_configuration

```
多源复制以及设置延迟复制信息
```

14. replication_applier_status

```
复制状态
```

15. replication_applier_status_by_coordinator、replication_applier_status_by_worker

```
多源复制具体状态
```

16. replication_connection_configuration

```
复制连接基础信息
```

17. replication_connection_status

```
复制链接基础状态
```

18. rwlock_instances

```
显示线程的读写锁持有
events_waits_current, to see what rwlock a thread is waiting for
rwlock_instances, to see which other thread currently owns an rwlock
```

19. session_account_connect_attrs

```
显示当前线程ID的属性，比如_os=Linux，_client_name=libmysql，_pid=1246等
```

20. session_connect_attrs

```
显示所有线程ID的属性，比如_os=Linux，_client_name=libmysql，_pid=1246等
```

21. table_handles

```
显示表锁信息
```

22. table_io_waits_summary_by_index_usage、table_io_waits_summary_by_table

```
记录索引的IO等待情况，由wait/io/table/sql/handler指标收集
```

23. table_lock_waits_summary_by_table

```
记录表纬度的表锁等待情况，情况如下：
read normal
read with shared locks
read high priority
read no insert
write allow write
write concurrent insert
write delayed
write low priority
write normal
```

24. threads

```
展示MySQL数据库的所有线程情况
```

25. user_variables_by_thread

```
展示当前线程定义的用户级变量
```

> 一些监控例子

1.哪类SQL执行的最多，响应时间如何，排序次数，扫描次数，创建临时表次数等等

```
mysql> desc events_statements_summary_by_digest;
+-----------------------------+---------------------+------+-----+---------------------+-------+
| Field                       | Type                | Null | Key | Default             | Extra |
+-----------------------------+---------------------+------+-----+---------------------+-------+
| SCHEMA_NAME                 | varchar(64)         | YES  |     | NULL                |       |
| DIGEST                      | varchar(32)         | YES  |     | NULL                |       |
| DIGEST_TEXT                 | longtext            | YES  |     | NULL                |       |
| COUNT_STAR                  | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_TIMER_WAIT              | bigint(20) unsigned | NO   |     | NULL                |       |
| MIN_TIMER_WAIT              | bigint(20) unsigned | NO   |     | NULL                |       |
| AVG_TIMER_WAIT              | bigint(20) unsigned | NO   |     | NULL                |       |
| MAX_TIMER_WAIT              | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_LOCK_TIME               | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_ERRORS                  | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_WARNINGS                | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_ROWS_AFFECTED           | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_ROWS_SENT               | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_ROWS_EXAMINED           | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_CREATED_TMP_DISK_TABLES | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_CREATED_TMP_TABLES      | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_SELECT_FULL_JOIN        | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_SELECT_FULL_RANGE_JOIN  | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_SELECT_RANGE            | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_SELECT_RANGE_CHECK      | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_SELECT_SCAN             | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_SORT_MERGE_PASSES       | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_SORT_RANGE              | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_SORT_ROWS               | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_SORT_SCAN               | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_NO_INDEX_USED           | bigint(20) unsigned | NO   |     | NULL                |       |
| SUM_NO_GOOD_INDEX_USED      | bigint(20) unsigned | NO   |     | NULL                |       |
| FIRST_SEEN                  | timestamp           | NO   |     | 0000-00-00 00:00:00 |       |
| LAST_SEEN                   | timestamp           | NO   |     | 0000-00-00 00:00:00 |       |
+-----------------------------+---------------------+------+-----+---------------------+-------+
```

2.物理文件的逻辑读写情况

```
mysql> select FILE_NAME,COUNT_STAR from file_summary_by_instance limit 2;
+------------------------------------------------------+------------+
| FILE_NAME                                            | COUNT_STAR |
+------------------------------------------------------+------------+
| /home/mysql/usr/local/mysql/share/english/errmsg.sys |          5 |
| /home/mysql/usr/local/mysql/share/charsets/Index.xml |          3 |
+------------------------------------------------------+------------+
mysql> desc file_summary_by_instance;
+---------------------------+---------------------+------+-----+---------+-------+
| Field                     | Type                | Null | Key | Default | Extra |
+---------------------------+---------------------+------+-----+---------+-------+
| FILE_NAME                 | varchar(512)        | NO   |     | NULL    |       |
| EVENT_NAME                | varchar(128)        | NO   |     | NULL    |       |
| OBJECT_INSTANCE_BEGIN     | bigint(20) unsigned | NO   |     | NULL    |       |
| COUNT_STAR                | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_WAIT            | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_WAIT            | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_WAIT            | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_WAIT            | bigint(20) unsigned | NO   |     | NULL    |       |
| COUNT_READ                | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_READ            | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_READ            | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_READ            | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_READ            | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_NUMBER_OF_BYTES_READ  | bigint(20)          | NO   |     | NULL    |       |
| COUNT_WRITE               | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_WRITE           | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_WRITE           | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_WRITE           | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_WRITE           | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_NUMBER_OF_BYTES_WRITE | bigint(20)          | NO   |     | NULL    |       |
| COUNT_MISC                | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_MISC            | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_MISC            | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_MISC            | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_MISC            | bigint(20) unsigned | NO   |     | NULL    |       |
+---------------------------+---------------------+------+-----+---------+-------+
```

3.索引使用情况：包括使用次数，查询次数，更新次数，插入次数，删除次数和响应时间等

```
mysql> select OBJECT_TYPE,OBJECT_SCHEMA,OBJECT_NAME,INDEX_NAME,COUNT_STAR,AVG_TIMER_WAIT from table_io_waits_summary_by_index_usage limit 4;
+-------------+---------------+-------------+------------+------------+----------------+
| OBJECT_TYPE | OBJECT_SCHEMA | OBJECT_NAME | INDEX_NAME | COUNT_STAR | AVG_TIMER_WAIT |
+-------------+---------------+-------------+------------+------------+----------------+
| TABLE       | clicktest     | customer    | PRIMARY    |          0 |              0 |
| TABLE       | test          | t2          | PRIMARY    |          0 |              0 |
| TABLE       | test          | t2          | NULL       |         24 |     4597093273 |
| TABLE       | bencbdb10     | t1          | id0        |          0 |              0 |
+-------------+---------------+-------------+------------+------------+----------------+
mysql> desc table_io_waits_summary_by_index_usage;
+------------------+---------------------+------+-----+---------+-------+
| Field            | Type                | Null | Key | Default | Extra |
+------------------+---------------------+------+-----+---------+-------+
| OBJECT_TYPE      | varchar(64)         | YES  |     | NULL    |       |
| OBJECT_SCHEMA    | varchar(64)         | YES  |     | NULL    |       |
| OBJECT_NAME      | varchar(64)         | YES  |     | NULL    |       |
| INDEX_NAME       | varchar(64)         | YES  |     | NULL    |       |
| COUNT_STAR       | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_WAIT   | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_WAIT   | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_WAIT   | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_WAIT   | bigint(20) unsigned | NO   |     | NULL    |       |
| COUNT_READ       | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_READ   | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_READ   | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_READ   | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_READ   | bigint(20) unsigned | NO   |     | NULL    |       |
| COUNT_WRITE      | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_WRITE  | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_WRITE  | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_WRITE  | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_WRITE  | bigint(20) unsigned | NO   |     | NULL    |       |
| COUNT_FETCH      | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_FETCH  | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_FETCH  | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_FETCH  | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_FETCH  | bigint(20) unsigned | NO   |     | NULL    |       |
| COUNT_INSERT     | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_INSERT | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_INSERT | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_INSERT | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_INSERT | bigint(20) unsigned | NO   |     | NULL    |       |
| COUNT_UPDATE     | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_UPDATE | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_UPDATE | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_UPDATE | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_UPDATE | bigint(20) unsigned | NO   |     | NULL    |       |
| COUNT_DELETE     | bigint(20) unsigned | NO   |     | NULL    |       |
| SUM_TIMER_DELETE | bigint(20) unsigned | NO   |     | NULL    |       |
| MIN_TIMER_DELETE | bigint(20) unsigned | NO   |     | NULL    |       |
| AVG_TIMER_DELETE | bigint(20) unsigned | NO   |     | NULL    |       |
| MAX_TIMER_DELETE | bigint(20) unsigned | NO   |     | NULL    |       |
+------------------+---------------------+------+-----+---------+-------+
```

4.等待事件消耗情况

```
mysql> select * from events_waits_summary_global_by_event_name limit 10;
+---------------------------------------------------------+------------+----------------+----------------+----------------+----------------+
| EVENT_NAME                                              | COUNT_STAR | SUM_TIMER_WAIT | MIN_TIMER_WAIT | AVG_TIMER_WAIT | MAX_TIMER_WAIT |
+---------------------------------------------------------+------------+----------------+----------------+----------------+----------------+
| wait/synch/mutex/sql/TC_LOG_MMAP::LOCK_tc               |          0 |              0 |              0 |              0 |              0 |
| wait/synch/mutex/sql/LOCK_des_key_file                  |          0 |              0 |              0 |              0 |              0 |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_commit         |          0 |              0 |              0 |              0 |              0 |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_commit_queue   |          0 |              0 |              0 |              0 |              0 |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_done           |          0 |              0 |              0 |              0 |              0 |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_flush_queue    |          0 |              0 |              0 |              0 |              0 |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_index          |          0 |              0 |              0 |              0 |              0 |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_log            |          0 |              0 |              0 |              0 |              0 |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_binlog_end_pos |          0 |              0 |              0 |              0 |              0 |
| wait/synch/mutex/sql/MYSQL_BIN_LOG::LOCK_sync           |          0 |              0 |              0 |              0 |              0 |
+---------------------------------------------------------+------------+----------------+----------------+----------------+----------------+
```




