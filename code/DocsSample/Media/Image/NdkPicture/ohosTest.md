# NdkPicture测试用例归档

## 用例表

| 测试功能               | 预置条件     | 输入                        | 预期输出                          | 是否自动 | 测试结果 |
|------------------------|--------------|-----------------------------|-----------------------------------|----------|----------|
| 拉起应用               | 设备正常运行 |                             | 成功拉起应用                      | 是       | Pass     |
| 图片解码功能           | 进入主界面   | 点击 Create Picture 按钮    | 弹窗通知 createPicture Success.  | 是       | Pass     |
| 获取主图功能           | 进入主界面   | 点击位图操作按钮            | 弹窗通知 getMainPixelMap Success.| 是       | Pass     |
| 图片编码到缓冲区功能   | 进入主界面   | 点击 Pack To Data 按钮      | 弹窗通知 packToData Success.     | 是       | Pass     |
| 图片编码到文件功能     | 进入主界面   | 点击 Pack To File 按钮      | 弹窗通知 packToFile Success.     | 是       | Pass     |
| 释放 Picture 功能      | 进入主界面   | 点击 Realease Picture 按钮  | 弹窗通知 pictureRelease Success  | 是       | Pass     |