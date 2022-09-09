#### Django开发事项
1.内置模板标签和过滤
> https://docs.djangoproject.com/zh-hans/4.1/ref/templates/builtins/

2.markdown
pip:
```
pip3 install markdown
```
view:
```python
from django.utils.html import mark_safe
from markdown import markdown

'tool_describe': mark_safe(markdown(tool_object.tool_describe, safe_mode='escape')
```
html
```
```
<small>{{ tool_describe|safe }} </small>
```