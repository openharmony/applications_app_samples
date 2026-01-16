# 保存媒体库资源示例工程测试用例归档

## 用例表

| 测试功能         | 预置条件            | 输入              | 预期输出      | 是否自动 | 测试结果 |
| -------------- |-----------------| --------------- | ------------- | - | -------- |
| 获取支持的图片和视频格式    | 编译sample工程并安装sample app. | 1. 打开Sample应用进入主界面。界面中有3个Button。<br>2. 点击 “Get Supported Photo Formats”Button。进入"Get Supported Photo Formats"界面。界面上有“example”按钮。<br>3. 点击“example”按钮。查看界面底部文本框上显示的支持的图片视频格式。| 3. 在界面底部的文本框中列出了支持的图片视频格式。  | 否 | Pass     |
| 使用安全控件保存资源到媒体库  | 编译sample工程并安装sample app. | 1. 打开Sample应用进入主界面。存在3个Button. <br>2. 点击按钮“Save with SaveButton Component”。进入保存按钮示例页面，页面存在“Prepare Test Image”和“保存图片”两个Button. <br>3. 点击“准备测试图片”Button。在底部文本框中看到已准备好的图片的文件路径。<br>4. 点击“保存图片”Button. <br>5. 点击“允许”Button. | 4. 弹出“安全保存图片和视频”对话框。<br>5. 在底部文本框中看到已保存图片的媒体库URI。进入图库应用查看，可以看到在第3步中准备的图片。  | 否 | Pass     |
| 使用授权弹框保存资源到媒体库  | 编译sample工程并安装sample app. | 1. 打开Sample应用进入主界面。存在3个Button. <br>2. 点击按钮“Save with Authorization Dialog”。进入授权弹框示例页面，页面存在“Prepare Test Image”和“Example”按钮。<br>3. 点击“Prepare Test Image”Button。在底部文本框中看到已准备好的图片的文件路径。<br>4. 点击“Example”按钮。<br>5. 点击“允许”。| 4. 弹出对话框，标题为“允许SaveButtonSample保存1张图片?”。<br>5. 在底部文本框中看到已保存图片的媒体库URI。进入图库应用查看，可以看到在第3步中准备的图片。  | 否 | Pass     |