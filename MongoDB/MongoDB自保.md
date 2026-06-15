## mongodb会话查杀

1.查杀活跃会话过多的情况
```
from pymongo import MongoClient

# ------------------------------
# 配置
# ------------------------------
MONGO_URI = ""
ACTIVE_THRESHOLD = 300  # 活跃会话阈值

client = MongoClient(MONGO_URI)
admin_db = client["admin"]

# ------------------------------
# 获取当前所有连接 / 会话
# ------------------------------
# 4.2 使用 currentConn
result = admin_db.command('currentOp')

# ------------------------------
# 过滤活跃连接
# ------------------------------
active_conns = [op for op in result.get("inprog", []) if op.get("active") and op.get("ns").startswith('tech_pluto')]

print(f"当前tech_pluto活跃连接数: {len(active_conns)}")

# ------------------------------
# 当活跃会话达到阈值时，kill 所有活跃 session
# ------------------------------
if len(active_conns) >= ACTIVE_THRESHOLD:
    print(f"活跃会话 >= {ACTIVE_THRESHOLD}，开始 kill 所有活跃会话...")
    for op in active_conns:
        opid = op.get("opid")
        if opid:
            try:
                res = admin_db.command({"killOp": 1, "op": opid})
                print(f"成功 kill op: {opid}")
            except Exception as e:
                print(f"kill op {opid} 失败: {e}")
else:
    print("活跃会话未超过阈值，无需处理。")
```
