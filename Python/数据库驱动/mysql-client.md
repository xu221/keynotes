> import pymysql

```
db_connection = {
        "host" : 'host11',
        "user" : 'user',
        "password" : 'pwd',
        "database" : 'jydb',
        "cursorclass" : pymysql.cursors.DictCursor
}
```
1.基本操作
```
with pymysql.connect(**db_connection) as connection:
    with connection.cursor() as cursor:
        # 执行查询
        cursor.execute("SELECT * from testtb;")
        # 获取结果
        cursor.fetchmany(100)
        cursor.fetchall() 

        connection.begin()
        # 准备要插入的数据字典
        temp_ins_data = {'column1': 'value1', 'column2': 'value2', 'column3': 'value3', 'column4': 'value4'}
        # 要插入的表的列名列表
        columns_list = ['column1', 'column2', 'column3', 'column4']
        # 使用生成器表达式生成元组
        data_to_insert = tuple(temp_ins_data.get(i, "") for i in columns_list)
        # 使用参数化查询插入数据:这样的好处在于不用处理内容中的单双引号等特殊字符
        insert_query = f"INSERT INTO your_table_name ({', '.join(columns_list)}) VALUES ({', '.join(['%s']*len(columns_list))})"
        cursor.execute(insert_query, data_to_insert)
        # 提交事务
        connection.commit()
```

2.安全修改数据
```
def done_execute_sql(self, apply_id, detail_id, execute_mode, envCode, dbname, tbname, sql):
    """如何安全地插入数据：意义在于安全插入带特殊符号的字符串"""
    query = """
    INSERT INTO sql_execute 
    (apply_id, detail_id, env, execute_mode, execute_status, dbname, tbname, execute_sql, gmt_created) 
    VALUES (%s, %s, %s, %s, '1', %s, %s, %s, NOW());
    """

    with pymysql.connect(**self.db_connection) as connection:
        with connection.cursor() as cursor_source:
            cursor_source.execute(query, (apply_id, detail_id, envCode, execute_mode, dbname, tbname, sql))
            connection.commit()
            return True if cursor_source.rowcount > 0 else False

def update_sql_entry(self, apply_id, detail_id, new_status, dbname, tbname, sql):
    """如何安全地更新数据"""
    query = """
    UPDATE sql_execute
    SET execute_status = %s, dbname = %s, tbname = %s, execute_sql = %s
    WHERE apply_id = %s AND detail_id = %s;
    """
    
    with pymysql.connect(**self.db_connection) as connection:
        with connection.cursor() as cursor_source:
            cursor_source.execute(query, (new_status, dbname, tbname, sql, apply_id, detail_id))
            connection.commit()
            return True if cursor_source.rowcount > 0 else False
```
        
