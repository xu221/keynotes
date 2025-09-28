#### linux进程僵死排查

```
#!/bin/bash
# process_diag.sh
# 用途: 一键排查进程卡住位置
# 用法: ./process_diag.sh <PID>

PID=$1

if [ -z "$PID" ]; then
  echo "用法: $0 <PID>"
  exit 1
fi

echo "==== [1] 进程状态 (ps) ===="
ps -o pid,ppid,user,state,%cpu,%mem,etime,cmd -p $PID

echo
echo "==== [2] 打开的文件 (lsof) ===="
lsof -p $PID | head -20
echo "...(仅显示前20行，如需更多请手动执行 lsof -p $PID )"

echo
echo "==== [3] 系统调用快照 (strace, 3秒) ===="
timeout 3 strace -p $PID -s 128 -o /tmp/strace_$PID.log 2>/dev/null
tail -n 20 /tmp/strace_$PID.log

echo
echo "==== [4] 如果怀疑是死循环，可用 top/htop 查看CPU使用 ===="
echo "  top -p $PID"

```
