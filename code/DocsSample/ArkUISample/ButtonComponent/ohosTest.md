| 测试功能        | 预置条件     | 输入        | 预期输出             | 测试结果 |
|-------------| ------------ |-----------|------------------| -------- |
| 创建上弧形按钮 | 设备正常运行 | 点击"ButtonAlignTop" | 页面和按钮创建成功          | Pass |
| 按钮点击事件   | 设备正常运行 | 点击"ButtonAlignTop"后点击页面上的OK | 打印日志“ArcButton onClick” | Pass |
| 创建下弧形按钮 | 设备正常运行 | 点击"ButtonAlignBottom" | 页面和按钮创建成功          | Pass |
| 按钮触摸事件   | 设备正常运行 | 点击"ButtonAlignBottom"后点击页面上的OK | 打印日志“ArcButton onTouch” | Pass |
| 设置按钮背景色 | 设备正常运行 | 点击"ButtonBcgColor" | 页面和按钮创建成功 | Pass |
| 设置按钮文本色 | 设备正常运行 | 点击"ButtonFontColor" | 页面和按钮创建成功      | Pass |
| 设置按钮阴影色 | 设备正常运行 | 点击"ButtonShadow" | 页面和按钮创建成功      | Pass |
| 通过按钮更改界面亮度值 | 设备正常运行 | 点击"ButtonBrightness"后点击页面上的OK | 当前亮度调数值更改 | Pass |