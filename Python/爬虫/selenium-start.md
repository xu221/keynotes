#### Selenium

1.安装

```shell
pip3 install selenium
```

```shell
yum install chromium
yum -y groupinstall Fonts # 解决linux下chrome中文方块乱码
```

```shell
chromium-browser --version
#Chromium 94.0.4606.81 Fedora Project,下载同版本驱动
wget https://chromedriver.storage.googleapis.com/94.0.4606.61/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
```

2.示例-全页截图

```python
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.options import Options
import time

driver_options = Options()
driver_options.add_argument('--no-sandbox')
driver_options.add_argument('--headless')
with webdriver.Chrome(executable_path='/root/softwares/chromedriver', chrome_options=driver_options) as driver:
    # 代码中默认通过PATH变量调用chrome驱动
    driver.get("https://movie.douban.com/top250")
    driver.execute_script("document.body.style.zoom='150%'")
    width = driver.execute_script("return document.documentElement.scrollWidth")
    height = driver.execute_script("return document.documentElement.scrollHeight")
    print(width,height)
    driver.set_window_size(width, height)
    time.sleep(1)
    driver.save_screenshot('aaa.png')
```

3.新增的驱动管理
```
# 之前
from selenium import webdriver
driver = webdriver.Chrome('/home/user/drivers/chromedriver')

# 现在
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
driver = webdriver.Chrome(ChromeDriverManager().install())
```

