#### Django迁移部署
> 初始化迁移

1.拷贝所有代码
```
scp
cp
```

2.生成改代码需要的包，并安装
```
pipreqs ./
pip3 install -r requirements.txt
```

3.删除app目录下的__pycache__、migrations
```
rm -r __pycache__
rm -r migrations
```

4.修改settings.py数据库连接
```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'xzl_00',
        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '3306',
    }
}
```

5.初始化数据表
```
# 生成初始化APP的SQL
python3 manage.py makemigrations APP_NAME
Migrations for 'catools_app':
  catools_app/migrations/0001_initial.py
    - Create model Modules
    - Create model TasksRunState
    - Create model Tool
    - Create model Params
```
```
# 应用SQL
python3 manage.py migrate
```

6.创建管理员用户
```
python3 manage.py createsuperuser
```

7.启动它
```
python3 manage.py runserver 0:8001
```

> 全量迁移

1.数据迁移
```
mysql data -> mysql data
```

2.拷贝所有代码
```
scp
cp
```

3.生成改代码需要的包，并安装
```
pipreqs ./
pip3 install -r requirements.txt
```

4.修改settings.py数据库连接
```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'xzl_00',
        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '3306',
    }
}
```

5.启动它
```
python3 manage.py runserver 0:8001
```

> HTTPS部署


1.用openssl生成个人用证书(3650days)
```
openssl genrsa -out server.key 1024
openssl req -new -key server.key -out server.csr
openssl x509 -req -in server.csr -out server.crt -signkey server.key -days 3650
```

2.用daphne运行Django服务
```
pip install daphne
```


```
nohup python3 manage.py runsslserver 0:8000 --certificate ./server.crt --key ./server.key > django_server.log &
nohup daphne -e ssl:9000:privateKey=./server.key:certKey=./server.crt webpl.asgi:application -v2 > daphne_wss.log &
```

3.客户端浏览器导入server.crt到受信任的根目录

> 虚拟环境迁移

1.拷贝所有venv目录下的文件传到对应服务器

2.修改active中的VIRTUAL_ENV变量为目标服务器的目录
```
VIRTUAL_ENV="/home/new/webpl_pyvenv"
export VIRTUAL_ENV
```

3.重新设置webpl_pyvenv/bin目录下的python软链接
```
rm python
rm python3
ln -s 源python3 ./
ln -s python3 python
```

4.重新设置pip的#!注释路径[如果有需要]
```
vim pip
#! xxxx
vim pip3
```
