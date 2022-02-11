import time
import queue

"""
A task is a wrapper around a coroutine
"""
class Task(object):
    """
    创建调度系统os中的任务实例
    """
    taskid = 0
    def __init__(self, target):
        Task.taskid += 1
        self.tid = Task.taskid
        self.target = target
        self.sendval = None
    def run(self):
        return self.target.send(self.sendval)

class Scheduler(object):
    """
    创建调度系统os实例
    """
    def __init__(self):
        self.ready = queue.Queue()       # 就绪队列
        self.taskmap = {}                # 任务字典
        self.exit_waiting = {}           # 退出字典
        self.read_waiting = {}           # 读任务
        self.write_waiting = {}          # 写任务
    def exit(self, task):
        # print("Task {} terminated".format(task.tid))
        del self.taskmap[task.tid]       # 删除任务
    def new(self, target):
        newtask = Task(target)
        self.taskmap[newtask.tid] = newtask
        self.schedule(newtask)
        return newtask.tid
    def schedule(self, task):
        self.ready.put(task)
    def mainloop(self):
        while self.taskmap:
            task = self.ready.get()      # 取出任务，queue队列当满或者空时会发生阻塞
            try:
                task.run()               # 执行一步，直到下一个yield
            except StopIteration:        # 当send无法遇到yield时，会吐出StopIteration异常：此处表示全表已备份
                self.exit(task)
                continue
            self.schedule(task)          # 就绪任务

"""
代码块运行时间上下文管理器
"""
from contextlib import contextmanager

@contextmanager
def timeblock(label):
    start = time.perf_counter()
    try:
        yield
    finally:
        end = time.perf_counter()
        print('{} : {}'.format(label, end - start))
