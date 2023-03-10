#### 这里讲的是关于linux安装一些软件包的方法

1.编译安装失败之找不到so文件
> /usr/bin/ld: cannot find -l-pthread 
> 该报错是找不到链接库lib-pthread.so(注意-l是lib的意思)

```
解决方法：
# 检索相关信息
ld  -l-pthread --verbose
==================================================
attempt to open //usr/x86_64-redhat-linux/lib64/lib-pthread.so failed
attempt to open //usr/x86_64-redhat-linux/lib64/lib-pthread.a failed
attempt to open //usr/lib64/lib-pthread.so failed
attempt to open //usr/lib64/lib-pthread.a failed
attempt to open //usr/local/lib64/lib-pthread.so failed
attempt to open //usr/local/lib64/lib-pthread.a failed
attempt to open //lib64/lib-pthread.so failed
attempt to open //lib64/lib-pthread.a failed
attempt to open //usr/x86_64-redhat-linux/lib/lib-pthread.so failed
attempt to open //usr/x86_64-redhat-linux/lib/lib-pthread.a failed
attempt to open //usr/local/lib/lib-pthread.so failed
attempt to open //usr/local/lib/lib-pthread.a failed
attempt to open //lib/lib-pthread.so failed
attempt to open //lib/lib-pthread.a failed
attempt to open //usr/lib/lib-pthread.so failed
attempt to open //usr/lib/lib-pthread.a failed
ld: cannot find -l-pthread

# 可以看到主要是attempt to open /usr/lib64/lib-pthread.so failed
# lib64和lib主要是用户对包类型的区分，其中一个存在即可
cd /usr/lib64
ls -lh *pthread*
lrwxrwxrwx  1 root root   30 Oct 26  2016 libevent_pthreads-2.0.so.5 -> libevent_pthreads-2.0.so.5.1.9
-rwxr-xr-x  1 root root  11K Jun 14  2014 libevent_pthreads-2.0.so.5.1.9
lrwxrwxrwx  1 root root   30 Oct 27  2016 libevent_pthreads.so -> libevent_pthreads-2.0.so.5.1.9
lrwxrwxrwx. 1 root root   26 Nov 21  2014 libgpgme-pthread.so.11 -> libgpgme-pthread.so.11.8.1
-rwxr-xr-x. 1 root root 208K Jun 10  2014 libgpgme-pthread.so.11.8.1
lrwxrwxrwx  1 root root   27 Sep  6  2017 libOpenIPMIpthread.so.0 -> libOpenIPMIpthread.so.0.0.1
-rwxr-xr-x  1 root root  33K Nov  6  2016 libOpenIPMIpthread.so.0.0.1
-rwxr-xr-x  1 root root 139K Apr 28  2021 libpthread-2.17.so
-rw-r--r--  1 root root 1.8K Apr 28  2021 libpthread_nonshared.a
-rw-r--r--  1 root root  222 Apr 28  2021 libpthread.so
lrwxrwxrwx  1 root root   18 Nov 12  2021 libpthread.so.0 -> libpthread-2.17.so

# 发现这里包名称有点不一致，这个少了一个横杠
# 做一个软链接吧
ln -s libpthread-2.17.so lib-pthread.so

# 后面就能安装了0.0
```
