#### 字典差异对比函数
> import json  
> from rich.table import Table  
> from rich.console import Console  

```
def compare_dictionary(d1: dict, d2: dict) ->print :
    """
    字典对比函数
    """
    console = Console()
    table = Table(show_header=True, show_lines=True, header_style="bold magenta",)
    table.add_column("Title")
    table.add_column("源", justify="left")
    table.add_column("目标", justify="left")
    for i in set(d1.keys()).difference(set(d2.keys())):
        table.add_row(i, json.dumps(d1[i], indent=4), '')
    for i in set(d2.keys()).difference(set(d1.keys())):
        table.add_row(i, '', json.dumps(d2[i], indent=4))
    for i in set(d1.keys()).intersection(set(d2.keys())):
        if d1[i] != d2[i]:
            table.add_row(i, json.dumps(d1[i], indent=4), json.dumps(d2[i], indent=4))
    console.print(table)

ss = r"""{"key1":"1", "key2":{"b1":"1", "b2":"2"}, "key3":4, "key4":7, "key6":{"b1":"1"}}"""
dd = r"""{"key1":"1", "key2":{"b1":"1"},           "key3":5, "key5":9, "key6":{"b1":"2"}}"""
compare_dictionary(json.loads(ss), json.loads(dd))
```

#### 时间消耗wrapper
> from contextlib import contextmanager  
> from random import randint  
> import time  
```
@contextmanager
def timeblock(label):
    start = time.perf_counter()
    try:
        yield
    finally:
        end = time.perf_counter()
        print('{} : {}'.format(label, end - start))

with timeblock("test1"):
    func1()

with timeblock("test2"):
    func2()
```


#### 脚本生成及调度运行
```
def taskexecfunc(job_id, script_id, script_name, script_code, script_code_language, task_parameters):
    try:
        if script_code_language != 'shell':
            script_file_name = script_name + '_' + str(job_id) + '_{0}.py'.format(script_code_language)
            script_log_name = script_name + '_' + str(job_id) + '.log'

            task_ins = TaskRunStatus()
            pats_execfunc = re.compile(r'(.*$)', re.M)

            # 脚本写入磁盘
            exec_code = (
            "# *- coding: utf-8 -*-\n"
            "import sys\n"
            "import os\n"
            "sys.path.append(os.path.abspath(os.path.join(os.getcwd())))\n"
            "import warnings\n"
            "warnings.filterwarnings(action='ignore',message='Python 3.6 is no longer supported')\n"
            "WORKPATH = os.path.join(os.path.abspath(os.path.dirname('workspace')) , 'workspace', '{job_id}')\n"
            "def progress_set(percent):\n"
            "    if not isinstance(percent, (int)):\n"
            "        raise TypeError('参数必须是数字类型')\n"
            "    with open(os.path.join(WORKPATH, 'progress.rate'), 'w+') as f:\n"
            "        f.write(str(percent))\n"
            "\n"
            "def jobmain({parameter_strings}):\n"
            "{tool_code}\n"
            "\n"
            "jobmain()\n"
            "\n"
            ).format(job_id=job_id,
                     tool_code=pats_execfunc.sub(r'    \1', script_code),
                     parameter_strings=' , '.join(str(k)+'='+str(v) if not isinstance(v, str) else str(k)+'='+"'"+ str(v).replace("'","\\\'").replace('"', "\\\"") +"'" for k, v in task_parameters.items())
                    )
            # 创建JOB运行目录
            os.makedirs('workspace/{0}'.format(job_id), mode=511, exist_ok=True)
            # 创建JOB调用脚本
            WORKPATH = os.path.abspath(os.path.dirname("workspace")) + "/workspace/{0}".format(job_id)
            with open(os.path.join(WORKPATH, script_file_name), 'w') as fcode:
                fcode.write(exec_code)
            # 进程执行与埋点
            f21 =  open(os.path.join(WORKPATH, script_log_name), 'at')
            cmd = "{0} {1}".format(script_code_language, os.path.join(WORKPATH, script_file_name))
            sub = subprocess.Popen([cmd], stdout=f21, stderr=subprocess.PIPE, encoding="utf-8", shell=True, bufsize=0, preexec_fn=os.setsid)
            current_taskrun_id = sub.pid
            task_ins.push_task_run_current_process_id(job_id=job_id, script_log_name=script_log_name, process_id=current_taskrun_id)
            sub.wait()
            stderr = sub.stderr.read()
            if stderr:
                task_ins.push_task_error_time(job_id=job_id, execption_message=stderr)
            else:
                time.sleep(3)
                task_ins.push_task_end_time(job_id=job_id)

        elif script_code_language == "shell":
            script_file_name = script_name + '_' + str(job_id) + '_{0}.sh'.format(script_code_language)
            script_log_name = script_name + '_' + str(job_id) + '.log'

            task_ins = TaskRunStatus()
            pats_execfunc = re.compile(r'(.*$)', re.M)
            exec_code = (
            "WORKPATH='workspace/{job_id}'\n"
            "progress_set() {{\n"
            "    if [[ $1 =~ ^[0-9]+$ ]]; then\n"
            "        echo $1 > $WORKPATH/progress.rate\n"
            "    else\n"
            "        echo '请输入一个整数作为参数'\n"
            "        exit 1\n"
            "    fi\n"
            "}}\n"
            "{tool_code}\n"
            "sleep 3"
            ).format(tool_code=pats_execfunc.sub(r'    \1', script_code), job_id=job_id)
            # 创建JOB运行目录
            os.makedirs('workspace/{0}'.format(job_id), mode=511, exist_ok=True)
            # 创建JOB调用脚本
            WORKPATH = os.path.abspath(os.path.dirname("workspace")) + "/workspace/{0}".format(job_id)
            with open(os.path.join(WORKPATH, script_file_name), 'w') as fcode:
                fcode.write(exec_code)

            # 进程执行与埋点
            f21 =  open(os.path.join(WORKPATH, script_log_name), 'at')
            cmd = "sed -i 's/\r//' {0} && sh {0} {1}".format(os.path.join(WORKPATH, script_file_name), ' '.join(i for i in task_parameters.values()))
            sub = subprocess.Popen([cmd], stdout=f21, stderr=subprocess.PIPE, encoding="utf-8", shell=True, bufsize=0, preexec_fn=os.setsid)
            current_taskrun_id = sub.pid
            task_ins.push_task_run_current_process_id(job_id=job_id, script_log_name=script_log_name, process_id=current_taskrun_id)
            sub.wait()
            stderr = sub.stderr.read()
            if stderr:
                task_ins.push_task_error_time(job_id=job_id, execption_message=stderr)
            else:
                time.sleep(3)
                task_ins.push_task_end_time(job_id=job_id)

    except SystemExit as e:
        with open(os.path.join(WORKPATH, script_log_name), 'at') as f:
            print(datetime.now().strftime('%Y-%m-%d %H:%M:%S : ') + '正在终止(KILL)该运行中的任务...', file=f)
        task_ins.push_task_kill_time(job_id=job_id)
    finally:
        task_ins.push_script_run_times(script_id=script_id)

```
