#### MySQL组复制(MySQL Group Replication)

> 此拓扑解释：强一致MySQL集群确保数据安全，当主库宕机时，从库自动切为主库，应用程序根据MySQL router自动切换为下一个可用节点，形成一定级别的可用性，一般业务都可使用，简单。

0.
```
根据本地情况，在不同服务器上部署三个MySQL 8.0实例，拓扑配置如下：
+------------------+
|  Application(s)  |
+------------------+
         |
         v
+------------------+
|  MySQL Router    |
+------------------+              
         |                    
         v
+----------------------------+
|           MGR              |
|  Node1     Node2     Node3 |
+----------------------------+

# 本地测试，三个实例端口为：
# 3306       3307      3308

```
1.部署MySQL 8.0数据库，可参考[MySQL 8.0部署](../MySQL运维脚本/mysql8.0_install.sh)，注意下面集群参数。
```

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
```

2.
```

```
