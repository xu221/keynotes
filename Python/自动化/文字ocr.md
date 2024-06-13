#### 截图ocr并移动鼠标点击
> pip3 install pytesseract  
> 模型下载地址：https://github.com/tesseract-ocr/tessdata/blob/main/chi_sim.traineddata  
> 将模型放入tessdata目录
>

```python3
import pytesseract
from PIL import ImageGrab, Image
import time
import pyautogui

# 配置Tesseract路径
pytesseract.pytesseract.tesseract_cmd = r'F:\软件安装\tseocr\tesseract.exe'
# 截图放大倍数
scale_factor = 2

def capture_screen():
    screen = ImageGrab.grab()
    # screen = screen.crop((1300, 400, 1900, 1080))  # 根据实际需要裁剪
    width, height = screen.size
    screen = screen.resize((width * scale_factor, height * scale_factor), Image.LANCZOS)
    screen.save('1.jpg')
    return screen

def ocr_image(image):
    # OCR识别图片中的文字
    custom_config = r'--oem 3 --psm 6'
    return pytesseract.image_to_data(image, lang='chi_sim', config=custom_config, output_type=pytesseract.Output.DICT)

def find_text_position(ocr_data, target_text):
    # 在OCR数据中找到目标文字的位置
    print(ocr_data)
    for i in range(len(ocr_data['text'])):
        if target_text in ocr_data['text'][i]:
            x = ocr_data['left'][i]
            y = ocr_data['top'][i]
            w = ocr_data['width'][i]
            h = ocr_data['height'][i]
            return ((x + w // 2) // scale_factor, (y + h // 2) // scale_factor)
    return None

def move_mouse_to_position(position):
    if position:
        pyautogui.moveTo(position)
        pyautogui.click()

def main(target_text):
    while True:
        screen = capture_screen()
        ocr_data = ocr_image(screen)
        print(ocr_data)
        position = find_text_position(ocr_data, target_text)
        if position:
            print(2)
            move_mouse_to_position(position)
            break
        print(1)
        time.sleep(1)

if __name__ == "__main__":
    target_text = "邮"  # 替换成您要查找的中文文字
    main(target_text)

```
