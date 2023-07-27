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

4.SQL动态高亮渲染
```
/* 动态渲染SQL输入框*/
const blankline_pattern = /\n(\n)*( )*(\n)*\n/g;
task_elem.addEventListener('focusout', (event) => {
    task_elem.querySelectorAll('.myparameters .sql').forEach((el) => {
        if (!(el.querySelector('.hljs-ln')) && el.innerText){
            newText = el.innerText.replace(blankline_pattern, "\n")
            el.innerHTML = hljs.highlight(newText, {language: 'sql'}).value;
            hljs.lineNumbersBlock(el,  {singleLine: true})
        }
    });
});            
```

5.获取粘贴缓冲区内容
```
/* SQL输入框分页,只取粘贴内容里的前200行 */
var sqltextDict = {};
task_elem.querySelectorAll('.myparameters .sql').forEach((el) => {
    document.addEventListener("paste", function (event) {
        event.preventDefault();
        let items = event.clipboardData && event.clipboardData.items;
        let text = null;
        if (items && items.length) {
            // 检索剪切板items
            for (let i = 0; i < items.length; i++) {
                // ...
                if (items[i].kind === 'string') {
                    text = event.clipboardData.getData('Text'); // 获取文本内容
                    sqltextDict[el.getAttribute('name')] = text
                    task_elem.querySelectorAll('.myparameters code').forEach((el) => {
                                el.innerHTML = text.split('\n', 200).join('\n');
                    });
                    break;
                }
            }
        }
    })
});
```

6.导出表格
```
//导出结果
th1_search_output.onclick = () => {
  exportExcel.exports("resource_table");
};

// 设置自定义文件名，需要加.xls保证即使导出文件有扩展名
var filename = "结果.xls";

class ExportExcel {
  constructor() {
    this.idTmr = null;
    this.uri = 'data:application/vnd.ms-excel;base64,';
    this.template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" ' +
            'xmlns="http://www.w3.org/TR/REC-html40"><head><meta charset="UTF-8">' +
            '<!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions>' +
            '<x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]-->' +
            // 自定义table样式，可以将样式导出到excel表格
            ' <style type="text/css">' +
            'table td,table th {' +
            'width: 200px;' +
            'height: 30px;' +
            ' text-align: center;' +
            ' }' +
            '</style>' +
            '</head><body><table>{table}</table></body></html>';
   }


    // 兼容各大主流浏览器
  getBrowser() {
    var explorer = window.navigator.userAgent;
    //ie 
    if (explorer.indexOf("Trident") >= 0) {
        return 'ie';
    }
    //firefox
    else if (explorer.indexOf("Firefox") >= 0) {
        return 'Firefox';
    }
    //Chrome
    else if (explorer.indexOf("Chrome") >= 0) {
        return 'Chrome';
    }
    //Opera
    else if (explorer.indexOf("Opera") >= 0) {
        return 'Opera';
    }
    //Safari
    else if (explorer.indexOf("Safari") >= 0) {
        return 'Safari';
    }
  };
  exports(tableid) {
    if (this.getBrowser() == 'ie') {
        var curTbl = document.getElementById(tableid);
        var oXL = new ActiveXObject("Excel.Application");
        var oWB = oXL.Workbooks.Add();
        var xlsheet = oWB.Worksheets(1);
        var sel = document.body.createTextRange();
        sel.moveToElementText(curTbl);
        sel.select();
        sel.execCommand("Copy");
        xlsheet.Paste();
        oXL.Visible = true;

        try {
            var fname = oXL.Application.GetSaveAsFilename( filename + "Excel.xls", "Excel Spreadsheets (*.xls), *.xls");
        } catch (e) {
            alert(e);
        } finally {
            oWB.SaveAs(fname);
            oWB.Close(savechanges = false);
            oXL.Quit();
            oXL = null;
            this.idTmr = window.setInterval("Cleanup();", 1);
        }
    } else {
        console.log('not ie, is chorme')
        this.openExport(tableid)
    }
  };
  openExport(table, name) {
    if (!table.nodeType) {
        table = document.getElementById(table)
        var target_table = document.createElement("table")
        var a = table.querySelectorAll('.choose')
        for (var i = 0; i < a.length; i++){
          var tempclonenode = a[i].cloneNode(true)
          target_table.append(tempclonenode)
        }
    }
    var ctx = {
        worksheet: name || 'Worksheet',
        table: target_table.innerHTML
    };
    var a = document.createElement("a");
    a.download = filename;
    a.href = this.uri + this.base64(this.format(this.template, ctx));
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    // window.location.href = this.uri + this.base64(this.format(this.template, ctx));
  };
  base64(s) {
    return window.btoa(unescape(encodeURIComponent(s)))
  };
  format(s, c) {
    return s.replace(/{(\w+)}/g, function (m, p) {
        return c[p];
    });
   };
}
var exportExcel = new ExportExcel();
```
