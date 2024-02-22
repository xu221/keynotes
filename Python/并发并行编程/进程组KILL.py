```python3
import psutil

def kill_process_and_children(pid):
    try:
        # 获取指定 PID 的进程对象
        process = psutil.Process(int(pid))

        # 获取该进程的所有子进程
        children = process.children(recursive=True)

        # 杀死子进程
        for child in children:
            child.terminate()

        # 杀死父进程
        process.terminate()

        print(f"Process {pid} and its children terminated successfully.")
    except psutil.NoSuchProcess as e:
        print(f"Process {pid} not found: {e}")
    except Exception as e:
        print(f"Error terminating process {pid} and its children: {e}")

def read_pid_from_file(file_path):
    # 从文件中读取保存的 PID
    try:
        with open(file_path, 'r') as pid_file:
            pid = int(pid_file.read())
            return pid
    except (IOError, ValueError) as e:
        print(f"Error reading PID from file: {e}")
        return None

# 替换为实际的进程 PID
saved_pid = read_pid_from_file("process.pid")

if saved_pid is not None:
    # 调用函数杀死保存的进程及其所有子进程
    kill_process_and_children(saved_pid)
else:
    print("No saved PID found.")
```
