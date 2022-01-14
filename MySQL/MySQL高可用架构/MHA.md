#### MHA架构使用
1.构建主从复制环境

```
必须事先创建好主从复制环境才能使用MHA。MHA Manager节点建议运行在独立服务器。MHA Node节点需要运行在所有服务器上，包括Manager服务器。
```

2.每个服务器安装MHA Node节点

```
根据操作系统版本到github下载最近2018年的rpm包：mha4mysql-node-0.58-0.el7.centos.noarch.rpm
```

```
yum install mha4mysql-node-0.58-0.el7.centos.noarch.rpm
```

3.选择独立服务器安装MHA Manager节点

```
yum install perl-DBD-MySQL
yum install perl-Config-Tiny
yum install perl-Log-Dispatch
  -->依赖
     -->perl-Email-Date-Format-1.002-15.el7.noarch.rpm
     -->perl-Mail-Sender-0.8.23-1.el7.noarch.rpm
     -->perl-Mail-Sendmail-0.79-21.el7.noarch.rpm
     -->perl-MailTools-2.12-2.el7.noarch.rpm
     -->perl-MIME-Lite-3.030-1.el7.noarch.rpm
     -->perl-MIME-Types-1.38-2.el7.noarch.rpm
yum install perl-Parallel-ForkManager
# 可参考上一级MHA4perlrequires目录中安装包
yum install mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
```

4.创建MHA Manager配置文件

```
manager_host$ cat /etc/app1.cnf
[server default]
# mysql user and password
user=root
password=!qazxsw@
port=
ssh_user=root
# working directory on the manager
manager_workdir=/root/mha4mysql/app/
# working directory on MySQL servers
remote_workdir=/root/mha4mysql/app/
# log
manager_log=/root/mha4mysql/log/manager.log

[server1]
hostname=192.168.56.10
port=8001

[server2]
hostname=192.168.56.11
port=8001

[server3]
hostname=192.168.56.12
port=8001
#server1不代表主库，MHA Manager能自行检测
```

```
创建配置文件中涉及的目录
```



5.节点之间配置root免密

```
ssh-keygen -t rsa
ssh-copy-id -i root@192.168.56.10
# mannager节点需配置自己的免密登陆
```

```
# 检查
[root@vm3 ~]# masterha_check_ssh --conf=/root/mha4mysql/etc/manager.cnf
Thu Feb 25 22:09:22 2021 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Thu Feb 25 22:09:22 2021 - [info] Reading application default configuration from /root/mha4mysql/etc/manager.cnf..
Thu Feb 25 22:09:22 2021 - [info] Reading server configuration from /root/mha4mysql/etc/manager.cnf..
Thu Feb 25 22:09:22 2021 - [info] Starting SSH connection tests..
Thu Feb 25 22:09:44 2021 - [debug]
Thu Feb 25 22:09:23 2021 - [debug]  Connecting via SSH from root@192.168.56.11(192.168.56.11:22) to root@192.168.56.10(192.168.56.10:22)..
Thu Feb 25 22:09:33 2021 - [debug]   ok.
Thu Feb 25 22:09:33 2021 - [debug]  Connecting via SSH from root@192.168.56.11(192.168.56.11:22) to root@192.168.56.12(192.168.56.12:22)..
Thu Feb 25 22:09:44 2021 - [debug]   ok.
Thu Feb 25 22:09:44 2021 - [debug]
Thu Feb 25 22:09:22 2021 - [debug]  Connecting via SSH from root@192.168.56.10(192.168.56.10:22) to root@192.168.56.11(192.168.56.11:22)..
Thu Feb 25 22:09:33 2021 - [debug]   ok.
Thu Feb 25 22:09:33 2021 - [debug]  Connecting via SSH from root@192.168.56.10(192.168.56.10:22) to root@192.168.56.12(192.168.56.12:22)..
Thu Feb 25 22:09:44 2021 - [debug]   ok.
Thu Feb 25 22:10:06 2021 - [debug]
Thu Feb 25 22:09:23 2021 - [debug]  Connecting via SSH from root@192.168.56.12(192.168.56.12:22) to root@192.168.56.10(192.168.56.10:22)..
Thu Feb 25 22:09:44 2021 - [debug]   ok.
Thu Feb 25 22:09:44 2021 - [debug]  Connecting via SSH from root@192.168.56.12(192.168.56.12:22) to root@192.168.56.11(192.168.56.11:22)..
Thu Feb 25 22:10:05 2021 - [debug]   ok.
Thu Feb 25 22:10:06 2021 - [info] All SSH connection tests passed successfully.
```

6.manager检查MySQL服务器的主从复制状态

```
[root@vm3 etc]# masterha_check_repl --conf=/root/mha4mysql/etc/manager.cnf
Thu Feb 25 22:20:46 2021 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Thu Feb 25 22:20:46 2021 - [info] Reading application default configuration from /root/mha4mysql/etc/manager.cnf..
Thu Feb 25 22:20:46 2021 - [info] Reading server configuration from /root/mha4mysql/etc/manager.cnf..
Thu Feb 25 22:20:46 2021 - [info] MHA::MasterMonitor version 0.58.
Thu Feb 25 22:20:47 2021 - [info] GTID failover mode = 1
Thu Feb 25 22:20:47 2021 - [info] Dead Servers:
Thu Feb 25 22:20:47 2021 - [info] Alive Servers:
Thu Feb 25 22:20:47 2021 - [info]   192.168.56.10(192.168.56.10:8001)
Thu Feb 25 22:20:47 2021 - [info]   192.168.56.11(192.168.56.11:8001)
Thu Feb 25 22:20:47 2021 - [info]   192.168.56.12(192.168.56.12:8001)
Thu Feb 25 22:20:47 2021 - [info] Alive Slaves:
Thu Feb 25 22:20:47 2021 - [info]   192.168.56.11(192.168.56.11:8001)  Version=5.7.26-debug-log (oldest major version between slaves) log-bin:enabled
Thu Feb 25 22:20:47 2021 - [info]     GTID ON
Thu Feb 25 22:20:47 2021 - [info]     Replicating from 192.168.56.10(192.168.56.10:8001)
Thu Feb 25 22:20:47 2021 - [info]   192.168.56.12(192.168.56.12:8001)  Version=5.7.26-debug-log (oldest major version between slaves) log-bin:enabled
Thu Feb 25 22:20:47 2021 - [info]     GTID ON
Thu Feb 25 22:20:47 2021 - [info]     Replicating from 192.168.56.10(192.168.56.10:8001)
Thu Feb 25 22:20:47 2021 - [info] Current Alive Master: 192.168.56.10(192.168.56.10:8001)
Thu Feb 25 22:20:47 2021 - [info] Checking slave configurations..
Thu Feb 25 22:20:47 2021 - [info]  read_only=1 is not set on slave 192.168.56.11(192.168.56.11:8001).
Thu Feb 25 22:20:47 2021 - [info]  read_only=1 is not set on slave 192.168.56.12(192.168.56.12:8001).
Thu Feb 25 22:20:47 2021 - [info] Checking replication filtering settings..
Thu Feb 25 22:20:47 2021 - [info]  binlog_do_db= , binlog_ignore_db=
Thu Feb 25 22:20:47 2021 - [info]  Replication filtering check ok.
Thu Feb 25 22:20:47 2021 - [info] GTID (with auto-pos) is supported. Skipping all SSH and Node package checking.
Thu Feb 25 22:20:47 2021 - [info] Checking SSH publickey authentication settings on the current master..
Thu Feb 25 22:20:47 2021 - [info] HealthCheck: SSH to 192.168.56.10 is reachable.
Thu Feb 25 22:20:47 2021 - [info]
192.168.56.10(192.168.56.10:8001) (current master)
 +--192.168.56.11(192.168.56.11:8001)
 +--192.168.56.12(192.168.56.12:8001)

Thu Feb 25 22:20:47 2021 - [info] Checking replication health on 192.168.56.11..
Thu Feb 25 22:20:47 2021 - [info]  ok.
Thu Feb 25 22:20:47 2021 - [info] Checking replication health on 192.168.56.12..
Thu Feb 25 22:20:47 2021 - [info]  ok.
Thu Feb 25 22:20:47 2021 - [warning] master_ip_failover_script is not defined.
Thu Feb 25 22:20:47 2021 - [warning] shutdown_script is not defined.
Thu Feb 25 22:20:47 2021 - [info] Got exit code 0 (Not master dead).

MySQL Replication Health is OK.
```

7.确保以下条件，以启动MHA Manager监控

+ MySQL服务器、MHA Manager所在服务器均安装MHA Node
+ 确保masterha_check_ssh免密检查OK
+ 确保masterha_check_repl复制检查OK

```
启动MHA Manager监控，它会一直监控主库状态直到宕机。
[root@vm3 ~]# masterha_manager --conf=/root/mha4mysql/etc/manager.cnf
Thu Feb 25 22:30:56 2021 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Thu Feb 25 22:30:56 2021 - [info] Reading application default configuration from /root/mha4mysql/etc/manager.cnf..
Thu Feb 25 22:30:56 2021 - [info] Reading server configuration from /root/mha4mysql/etc/manager.cnf..
Thu Feb 25 22:30:56 2021 - [info] MHA::MasterMonitor version 0.58.
Thu Feb 25 22:30:57 2021 - [info] GTID failover mode = 1
Thu Feb 25 22:30:57 2021 - [info] Dead Servers:
Thu Feb 25 22:30:57 2021 - [info] Alive Servers:
Thu Feb 25 22:30:57 2021 - [info]   192.168.56.10(192.168.56.10:8001)
Thu Feb 25 22:30:57 2021 - [info]   192.168.56.11(192.168.56.11:8001)
Thu Feb 25 22:30:57 2021 - [info]   192.168.56.12(192.168.56.12:8001)
Thu Feb 25 22:30:57 2021 - [info] Alive Slaves:
Thu Feb 25 22:30:57 2021 - [info]   192.168.56.11(192.168.56.11:8001)  Version=5.7.26-debug-log (oldest major version between slaves) log-bin:enabled
Thu Feb 25 22:30:57 2021 - [info]     GTID ON
Thu Feb 25 22:30:57 2021 - [info]     Replicating from 192.168.56.10(192.168.56.10:8001)
Thu Feb 25 22:30:57 2021 - [info]   192.168.56.12(192.168.56.12:8001)  Version=5.7.26-debug-log (oldest major version between slaves) log-bin:enabled
Thu Feb 25 22:30:57 2021 - [info]     GTID ON
Thu Feb 25 22:30:57 2021 - [info]     Replicating from 192.168.56.10(192.168.56.10:8001)
Thu Feb 25 22:30:57 2021 - [info] Current Alive Master: 192.168.56.10(192.168.56.10:8001)
Thu Feb 25 22:30:57 2021 - [info] Checking slave configurations..
Thu Feb 25 22:30:57 2021 - [info]  read_only=1 is not set on slave 192.168.56.11(192.168.56.11:8001).
Thu Feb 25 22:30:57 2021 - [info]  read_only=1 is not set on slave 192.168.56.12(192.168.56.12:8001).
Thu Feb 25 22:30:57 2021 - [info] Checking replication filtering settings..
Thu Feb 25 22:30:57 2021 - [info]  binlog_do_db= , binlog_ignore_db=
Thu Feb 25 22:30:57 2021 - [info]  Replication filtering check ok.
Thu Feb 25 22:30:57 2021 - [info] GTID (with auto-pos) is supported. Skipping all SSH and Node package checking.
Thu Feb 25 22:30:57 2021 - [info] Checking SSH publickey authentication settings on the current master..
Thu Feb 25 22:31:02 2021 - [warning] HealthCheck: Got timeout on checking SSH connection to 192.168.56.10! at /usr/share/perl5/vendor_perl/MHA/HealthCheck.pm line 343.
Thu Feb 25 22:31:02 2021 - [info]
192.168.56.10(192.168.56.10:8001) (current master)
 +--192.168.56.11(192.168.56.11:8001)
 +--192.168.56.12(192.168.56.12:8001)

Thu Feb 25 22:31:02 2021 - [warning] master_ip_failover_script is not defined.
Thu Feb 25 22:31:02 2021 - [warning] shutdown_script is not defined.
Thu Feb 25 22:31:02 2021 - [info] Set master ping interval 3 seconds.
Thu Feb 25 22:31:02 2021 - [warning] secondary_check_script is not defined. It is highly recommended setting it to check master reachability from two or more routes.
Thu Feb 25 22:31:02 2021 - [info] Starting ping health check on 192.168.56.10(192.168.56.10:8001)..
Thu Feb 25 22:31:02 2021 - [info] Ping(SELECT) succeeded, waiting until MySQL doesn't respond..

# 使用nohup挂在后台一直运行
# nohup masterha_manager --conf=/root/mha4mysql/etc/manager.cnf &
```

8.随时检查MHA Manager状态

```
[root@vm3 ~]# nohup masterha_manager --conf=/root/mha4mysql/etc/manager.cnf &
[1] 1753
[root@vm3 ~]# nohup: 忽略输入并把输出追加到"nohup.out"
[root@vm3 ~]# masterha_check_status --conf=/root/mha4mysql/etc/manager.cnf
manager monitoring program is now on initialization phase(10:INITIALIZING_MONITOR). Wait for a while and try checking again.
[root@vm3 ~]# masterha_check_status --conf=/root/mha4mysql/etc/manager.cnf
manager (pid:1753) is running(0:PING_OK), master:192.168.56.10
```

9.停止MHA Manager

```
[root@vm3 ~]# masterha_stop --conf=/root/mha4mysql/etc/manager.cnf 
```

or

```
[root@vm3 ~]# ps -ef|grep masterha
[root@vm3 ~]# kill it
```

10.测试主从切换

```
[root@vm3 ~]# nohup masterha_manager --conf=/root/mha4mysql/etc/manager.cnf &
[root@vm1 ~]# 关闭MySQL主库
1.此时，从二个从库中选择GTID最接近主库的从库，等待GTID执行完毕，将另一个从库chang master。
2.masterha_manager停止，在app目录下具有manager.failover.complete标识，在每次masterha_manager启动前应删除。
[root@vm3 ~]# masterha_check_repl --conf=/root/mha4mysql/etc/manager.cnf
#此时，若没有删除配置文件中的宕机server，则masterha_check_repl复制检查会失败，只有重新建立一主两从才可。
```

11.新增IP漂移

方法一：

```
# manager配置文件新增VIP切换配置
[root@vm3 ~]# vim /root/mha4mysql/etc/manager.cnf 
master_ip_failover_script= /script/master_ip_failover.pl
# 注意给该文件赋予可执行权限
```

```
[root@vm3 ~]# cat /root/mha4mysql/script/master_ip_failover.pl
[root@vm3 script]# cat master_ip_failover.pl
#!/usr/bin/env perl
use strict;
use warnings FATAL =>'all';

use Getopt::Long;

my (
$command,          $ssh_user,        $orig_master_host, $orig_master_ip,
$orig_master_port, $new_master_host, $new_master_ip,    $new_master_port
);

my $vip = '192.168.56.244/24';  # Virtual IP
my $netcard = "enp0s3";
my $ssh_start_vip = "ip addr add $vip dev $netcard";
my $ssh_stop_vip = "ip addr del $vip dev $netcard";
my $exit_code = 0;
#ssh_user_vip与配置文件中ssh_user一致
my $ssh_user_vip = 'root';


GetOptions(
'command=s'          => \$command,
'ssh_user=s'         => \$ssh_user,
'orig_master_host=s' => \$orig_master_host,
'orig_master_ip=s'   => \$orig_master_ip,
'orig_master_port=i' => \$orig_master_port,
'new_master_host=s'  => \$new_master_host,
'new_master_ip=s'    => \$new_master_ip,
'new_master_port=i'  => \$new_master_port,
);

exit &main();

sub main {

#print "\n\nIN SCRIPT TEST====$ssh_stop_vip==$ssh_start_vip===\n\n";

if ( $command eq "stop" || $command eq "stopssh" ) {

        # $orig_master_host, $orig_master_ip, $orig_master_port are passed.
        # If you manage master ip address at global catalog database,
        # invalidate orig_master_ip here.
        my $exit_code = 1;
        eval {
            print "\n\n\n***************************************************************\n";
            print "Disabling the VIP - $vip on old master: $orig_master_host\n";
            print "***************************************************************\n\n\n\n";
            &stop_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn "Got Error: $@\n";
            exit $exit_code;
        }
        exit $exit_code;
}
elsif ( $command eq "start" ) {

        # all arguments are passed.
        # If you manage master ip address at global catalog database,
        # activate new_master_ip here.
        # You can also grant write access (create user, set read_only=0, etc) here.
        my $exit_code = 10;
        eval {
            print "\n\n\n***************************************************************\n";
            print "Enabling the VIP - $vip on new master: $new_master_host \n";
            print "***************************************************************\n\n\n\n";
            &start_vip();
            $exit_code = 0;
        };
        if ($@) {
            warn $@;
            exit $exit_code;
        }
        exit $exit_code;
}
elsif ( $command eq "status" ) {
        print "Checking the Status of the script.. OK \n";
        `ssh $ssh_user_vip\@$orig_master_host \" $ssh_start_vip \"`;
        exit 0;
}
else {
&usage();
        exit 1;
}
}

# A simple system call that enable the VIP on the new master
sub start_vip() {
`ssh $ssh_user_vip\@$new_master_host \" $ssh_start_vip \"`;
}
# A simple system call that disable the VIP on the old_master
sub stop_vip() {
`ssh $ssh_user_vip\@$orig_master_host \" $ssh_stop_vip \"`;
}

sub usage {
print
"Usage: master_ip_failover –command=start|stop|stopssh|status –orig_master_host=host –orig_master_ip=ip –orig_master_port=po
rt –new_master_host=host –new_master_ip=ip –new_master_port=port\n";
}
```

12.测试IP漂移

+ 一主两从配置
+ 执行masterha_check_repl检查，若成功则在主库服务器会生成vip
+ 清除manager.failover.complete文件
+ 后台启动
+ nohup masterha_manager --conf=/root/mha4mysql/etc/manager.cnf > /root/mha4mysql/log/manager_run.log & 

```
登陆主库vm2，关闭数据库，此时masterha_manager自行停止
1.检查主从状态
# 现在为切换后的一主一从
2.检查VIP是否漂移
# 新主库VIP已经设置
```

13.修复宕机库并恢复主从

+ 若只是存在数据延迟，重设主从即可，若数据毁坏，可参考数据恢复。

```
CHANGE MASTER TO 
MASTER_HOST='192.168.56.10',
MASTER_PORT=8001,
MASTER_USER='rep',
MASTER_PASSWORD='rep!',
MASTER_AUTO_POSITION=1; 
start slave;
show slave status\G;
```

+ masterha_check_repl检查
+ 清除manager.failover.complete文件
+ 后台启动
+ nohup masterha_manager --conf=/root/mha4mysql/etc/manager.cnf > /root/mha4mysql/log/manager_run.log & 
