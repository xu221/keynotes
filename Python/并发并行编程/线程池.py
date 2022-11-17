import concurrent.futures
import ctypes
import threading

THREAD_POOL = concurrent.futures.ThreadPoolExecutor(max_workers=5)

def slow_op(*args):
    thread_ident_id = getThreadIdentId()
    print("thread_ident_id: " + str(thread_ident_id))
    with open("/dev/urandom", "rb") as f:
        return f.read(1000000)

def do_something():

    future = THREAD_POOL.submit(slow_op, "a", "b", "c")
    THREAD_POOL.shutdown()
    assert future.done() and not future.cancelled()
    print(f"got the result from slow_op: {len(future.result())}")

    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as pool:
        tasks = []
        future = pool.submit(slow_op, "a", "b", "c")
        tasks.append(future)
        future1 = pool.submit(slow_op, "a", "b")
        tasks.append(future1)
        for fut in concurrent.futures.as_completed(tasks):
            assert fut.done() and not fut.cancelled()
            print(f"got the result from slow_op: {len(fut.result())}")


# 获取系统线程ID，实际上没什么卵用
# System dependent, see e.g. /usr/include/x86_64-linux-gnu/asm/unistd_64.h
libc = ctypes.cdll.LoadLibrary('libc.so.6')
SYS_gettid = 186
def getThreadId():
    """Returns OS thread id - Specific to Linux"""
    return libc.syscall(SYS_gettid)

# 获取线程池标识ID，有大用
def getThreadIdentId():
    """Returns THREADPOOL thread ident id"""
    return threading.get_ident()

# 可以让子线程程序捕获系统异常而正常退出
def killThreadOfPoolbyException(thread_ident_id):
    res = ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(thread_ident_id), ctypes.py_object(SystemExit))  
    print(res)
    if res > 1:
        ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(thread_ident_id), 0) 
        print('Exception raise failure') 

if __name__ == "__main__":
    print("program started")
    do_something()
    print("program complete")
