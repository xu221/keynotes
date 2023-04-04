#### MySQL字符数据转换与存储

| 字符集      | 定义                                   | 字符编码规则          |
| ----------- | -------------------------------------- | --------------------- |
| ASCII字符集 | 基于拉丁字母的单字节编码系统           | ASCII                 |
| ISO 8859-1  | 扩展于ASCII字符集的西欧语言            | Latin-1               |
| ...         | ...                                    | ...                   |
| ISO 8859-16 | 扩展于ASCII字符集的罗马尼亚语言        | Latin-10              |
| GBK字符集   | 微软制定的两个字节编码中文标准         | GBK                   |
| Unicode     | 统一码联盟制定的包含几乎所有字符的集合 | utf-8、utf-16、utf-32 |

---

1.MySQL客户端连接输入字符

```
当使用SSH终端通过MySQL客户端程序mysql连接数据库时，输入法输入的字符根据SSH终端当时设置的编码规则转换为字节流。
```

```
1.设备SSH终端输入字符，将字符转换为字节流数据。
2.字节流通过数据库客户端mysql连接，由character_set_client设定的编码规则解码字节数据，并根据character_set_connection设定的编码规则将结果编码为字节流，用于服务器内部数据交互。
3.字节流进入到存储环节时，由character_set_connection设定的编码规则解码字节数据，并根据字段character设定的编码规则将结果编码为字节流存入文件，若两边字符编码规则一致，则直接存储到文件中。
```

![image-1](https://github.com/xu221/keynotes/blob/pictures/MySQL/%E5%AE%A2%E6%88%B7%E7%AB%AF%E4%BA%A4%E4%BA%92%E6%95%B0%E6%8D%AE%E8%BE%93%E5%85%A5.png)




```
字段存储编码规则：
1.使用每个字段的character set设置。
2.若创建字段时未设置character，创建表时指明，则字段编码规则继承于表
3.若创建字段时未设置character，创建表时也未指明，则字段编码规则继承于库
4.若创建字段时未设置character，创建表时也未指明，创建库时也未指明，则字段编码规则继承于character_set_server
```



2.MySQL客户端数据输出字符

```
1.数据库根据字段编码规则读取存储在二进制文件中的数据，将其解码并编码为character_set_connection。
2.字节流到达输出边界，由character_set_connection设定的编码规则解码字节数据，并根据character_set_results设定的编码规则将结果编码为字节流，传输到程序或者终端中，最后依据终端编码规则解码字节流，输出相应的字符到连接终端屏幕上。
```

![image-2](https://github.com/xu221/keynotes/blob/pictures/MySQL/%E5%AE%A2%E6%88%B7%E7%AB%AF%E4%BA%A4%E4%BA%92%E6%95%B0%E6%8D%AE%E8%BE%93%E5%87%BA.png)

3.不妨考虑以下情况

1.

| variables                | value  |
| ------------------------ | ------ |
| character_set_client     | latin1 |
| character_set_connection | utf8   |
| 字段character            | utf8   |
| character_set_connection | utf8   |
| character_set_results    | latin1 |

```
字节流在转换和存储过程中仅发生了由小字符集转换为兼容性大字符集，不会产生由于无法编码导致的乱码，所以数据存储是正常的，但存储空间大小是不一样的。
```

2.

| variables                | value  |
| ------------------------ | ------ |
| character_set_client     | latin1 |
| character_set_connection | utf8   |
| 字段character            | utf8   |
| character_set_connection | utf8   |
| character_set_results    | utf8   |

```
假设将案例1中character_set_results设为utf8，此时输入的 "兴" 将会输出为 "å…´"，原理如下：
```

![image-3](https://github.com/xu221/keynotes/blob/pictures/MySQL/%E6%A1%88%E4%BE%8B.png)

```
原因在于，字节流传入时，被character_set_client编码，应该同样使用相同编码的character_set_results对称输出。
```

3.

| variables                | value  |
| ------------------------ | ------ |
| character_set_client     | utf8   |
| character_set_connection | latin1 |
| 字段character            | utf8   |

```
假设前端传入均统一为utf8编码字节流，当转换为character_set_connection（latin1）时，由于存在中文字符无法被latin1字符集编码，所以产生无法编码错误（不会暴露），此时存储进的数据为乱码
```

4.MySQL-JDBC驱动连接

1. jdbc连接url中characterEncoding参数的作用：

```
1.jvm虚拟机用编译时设定的编码规则或者web容器编码规则读取传入的字节流解码为数据字符。
2.jdbc会用characterEncoding指定规则编码外部应用传入的数据字符(可能是设置了character_set_client、character_set_connection类似)。
3.如果characterEncoding未设置，则会自动选择数据库服务器character_set_server值，作为字符编码。
4.如何使用utf8mb4:
  如果用的是java服务器，升级或确保你的mysql connector版本不低于5.1.13，否则不支持utf8mb4；
  当版本不高于5.1.46时，characterEncoding=UTF-8对应的是MySQLutf8mb3，所以会造成特殊字符无法插入问题。
      解决1：设置character_set_server=utf8mb4，并缺省characterEncoding参数，当版本高于5.1.46时，characterEncoding=UTF-8对应的是MySQLutf8mb4，所以可以使用该参数。
      解决2：连接设置初始化语句：SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci
```

2. 举一个jdbc转码时导致乱码的例子：

![image-4](https://github.com/xu221/keynotes/blob/pictures/MySQL/jdbc%E6%95%B0%E6%8D%AE%E8%BE%93%E5%85%A5.png)



3. jdbc连接url中characterSetResults参数的作用：

```
1.设置数据库会话级别的character_set_results
```

4. 举一个存储正常、输出不正确的例子：

```
"jdbc:mysql://localhost:3306/RUNOOB?useUnicode=true&characterEncoding=UTF-8&characterSetResults=ISO-8859-1";
```

字符集列表如下：

| variables                | value  |
| ------------------------ | ------ |
| character_set_client     | utf8   |
| character_set_connection | utf8   |
| 字段character            | utf8   |
| character_set_connection | utf8   |
| character_set_results    | latin1 |

```
存储是正常的，"兴"字符存储在数据库中为0xE585B4，但是如之前流程所示，在character_set_connection转为character_set_results字符编码时，latin1无法编码该字符，所以产生输出乱码，将character_set_results改为utf8即可。
```

5. jdbc源码调用

```
mysql-connector-java-8.0.24
-->com.mysql.cj.jdbc
  -->ConnectionImpl.createNewIO(false)
    -->ConnectionImpl.connectOneTryOnly(isForReconnect);
      -->ConnectionImpl.initializePropsFromServer();
        -->NativeSession.configureClientCharacterSet(false);
               this.protocol.getServerSession().getServerVariables().put("character_set_client", utf8CharsetName);            this.protocol.getServerSession().getServerVariables().put("character_set_connection", utf8CharsetName);
```

![image-5](https://github.com/xu221/keynotes/blob/pictures/MySQL/jdbc%E8%B0%83%E7%94%A8.png)

5.判断存储是否乱码

```mysql
mysql> select hex(column) from table;
```











