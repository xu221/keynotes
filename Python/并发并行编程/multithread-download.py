import threading
import requests
import time
from time import sleep
from rich.progress import Progress, SpinnerColumn, BarColumn, TextColumn

def Handler(start, end, url, filename, processbar, threadnum):
    headers = {'Range': 'bytes=%d-%d' % (start, end)}
    with requests.get(url, headers=headers, stream=True) as r:
        with open(filename, "r+b") as fp:
            fp.seek(start)
            taskid = processbar.add_task('Tread-'+str(threadnum), total=(end-start)//2048)
            # 启动进度条
            with processbar as p:
                for chunk in r.iter_content(chunk_size=2048):
                    if chunk:
                        fp.write(chunk)
                    p.update(taskid, advance=1)
                while not processbar.finished:
                    time.sleep(0.5)
            # var = fp.tell()
            # fp.write(r.content)
def download(url, tittle, num_thread = 1): # <-下载链接，本地文件名称，线程数
    r = requests.head(url)
    # sometimes:  r = requests.get(url, stream=True)
    print(r.headers)
    try:
        file_name = tittle  
        file_size = int(r.headers['content-length'])
    except:
        print("检查URL，可能不支持多线程下载")
        return
    fp = open(file_name, "wb")
    fp.truncate(file_size)
    fp.close()
    part = file_size // num_thread
    # 创建进度条
    processbar = Progress("{task.description}",SpinnerColumn(),BarColumn(bar_width=None),TextColumn("[progress.percentage]{task.percentage:>3.0f}%"))
    for i in range(num_thread):
        start = part * i
        if i == num_thread - 1:
            end = file_size
        else:
            end = start + part
        t = threading.Thread(target=Handler, kwargs={'start': start, 'end': end, 'url': url, 'filename': file_name, 'processbar': processbar, 'threadnum': i})
        t.setDaemon(True)
        t.start()
    # 等待所有线程下载完成
    main_thread = threading.current_thread()
    for t in threading.enumerate():
        sleep(0.1)
        if t is main_thread:
            continue
        t.join()
    print('%s 下载完成' % file_name)

download('https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel80-5.0.3.tgz', 'aaaa', 5)
