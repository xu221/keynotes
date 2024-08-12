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
