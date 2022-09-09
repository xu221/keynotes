#### JavaScript小技巧
1.websocket
```
https:
const newSocket = new WebSocket(
    'wss://'
    + window.location.hostname
    + ':9000'
    + '/ws/logging/'
    + toolid
    + '/'
    + taskid
    + '/'
);
newSocket.onmessage = function(e) {
    const data = JSON.parse(e.data);
    console.log(data)
}
```
```
http:
const newSocket = new WebSocket(
    'ws://'
    + window.location.hostname
    + ':8000'
    + '/ws/logging/'
    + toolid
    + '/'
    + taskid
    + '/'
);
newSocket.onmessage = function(e) {
    const data = JSON.parse(e.data);
    console.log(data)
}
```

2.ajax
```
sub.onclick = function(e) {
    handlemessageevents = JSON.stringify(checkeddict)
    request.open('POST', '/messageevents/handle', false);
    var token = "{{ csrf_token }}"
    request.setRequestHeader("X-CSRFTOKEN", token) //DJANGO CSRF视图
    request.setRequestHeader("Content-type","application/json");
    request.send(handlemessageevents);
    if (request.status === 200) {
        console.log("success")
        for (var key in checkeddict){
            document.getElementById(key).remove()
        }
    }
}
```
> 可以参考https://zh.javascript.info/xmlhttprequest

3.代码高亮
> highlightjs: https://highlightjs.org/
> highlight行号: https://github.com/wcoder/highlightjs-line-numbers.js/
```html
<!-- 代码框背景 -->
<link rel="stylesheet" href="{% static 'catools_app/default.min.css' %}">
<link rel="stylesheet" href="{% static 'catools_app/devibeans.min.css' %}">
<!-- 代码高亮js -->
<script src="{% static 'catools_app/highlight.min.js' %}"></script>
<!-- 引入行号js -->
<script src="{% static 'catools_app/highlightjs-line-numbers.min.js' %}"></script>
 <!-- 渲染 -->
<style>
.hljs-ln-numbers {
    text-align: right;
    color: #ccc;
    border-right: 10px solid rgb(0, 0, 0);
    vertical-align: top;
    padding-right: 5px;
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
}
</style>
<script>
    hljs.highlightAll();
    hljs.initLineNumbersOnLoad();
</script>
```

```html
<div style="padding: 0px; background: #f3f3f5; flex: 1; min-width: 0;">
<pre><code class="python">{{ tool.tool_code }}</code></pre>
</div>
```