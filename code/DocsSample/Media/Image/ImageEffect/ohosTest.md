# ImageEffect测试用例归档

## 用例表

| 测试功能               | 预置条件         | 输入                                                         | 预期输出                       | 是否自动 | 测试结果 |
|--------------------| ---------------- | ------------------------------------------------------------ | ------------------------------ | -------- | -------- |
| 拉起应用               | 设备正常运行     |                                                              | 成功拉起应用                   | 是       | Pass     |
| 申请相机权限 | 进入主界面 | 点击允许按钮 | 成功获取相机权限 | 是 | Pass |
| 关闭参数设置页面           | 进入参数设置页面 | 点击dialog取消按钮                                           | 成功关闭参数设置页面           | 是       | Pass     |
| 亮度滤镜功能             | 进入参数设置页面 | 点击Brightness按钮，滑动Brightness滑动条，点击确认与Apply按钮 | 成功调节图片亮度               | 是       | Pass     |
| 对比度滤镜功能            | 进入参数设置页面 | 点击Contrast按钮，滑动Contrast滑动条，点击确认与Apply按钮    | 成功调节图片对比度             | 是       | Pass     |
| 裁剪滤镜功能             | 进入参数设置页面 | 点击Crop按钮，滑动Crop滑动条，点击确认与Apply按钮            | 成功裁剪图片大小               | 是       | Pass     |
| 自定义亮度滤镜功能          | 进入参数设置页面 | 点击CustomBright按钮，滑动CustomBright滑动条，点击确认与Apply按钮        | CustomBright滤镜效果应用成功         | 是       | Pass     |
| 自定义裁剪滤镜功能          | 进入参数设置页面 | 点击CustomCrop按钮，滑动CustomCrop滑动条，点击确认与Apply按钮        | CustomCrop滤镜效果应用成功         | 是       | Pass     |
| 重置滤镜功能             | 进入主界面       | 点击Reset按钮                                                | 图像效果成功复原               | 是       | Pass     |
| 查询Brightness滤镜信息   | 进入参数设置页面 | 点击Brightness滑动条旁的查询按钮                             | 显示Brightness滤镜信息         | 是       | Pass     |
| 查询Contrast滤镜信息     | 进入参数设置页面 | 点击Contrast滑动条旁的查询按钮                               | 显示Contrast滤镜信息           | 是       | Pass     |
| 查询Crop滤镜信息         | 进入参数设置页面 | 点击Crop滑动条旁的查询按钮                                   | 显示Crop滤镜信息               | 是       | Pass     |
| 查询CustomBright滤镜信息 | 进入参数设置页面 | 点击CustomBright滑动条旁的查询按钮                                 | 显示CustomBright滤镜信息             | 是       | Pass     |
| 查询CustomCrop滤镜信息   | 进入参数设置页面 | 点击CustomCrop滑动条旁的查询按钮                                 | 显示CustomCrop滤镜信息             | 是       | Pass     |
| 根据编码格式查询滤镜信息       | 进入参数设置页面 | 点击查询按钮，点击编码格式                                   | 显示对应编码格式支持的滤镜信息 | 是       | Pass     |
| 测试NativeBuffer输入场景 | 进入参数设置页面 | 切换输入场景为NativeBuffer，点击确认与Apply按钮 | 在NativeBuffer场景下成功应用滤镜链 | 是 | Pass |
| 测试URI输入场景 | 进入参数设置页面 | 切换输入场景为URI，点击确认与Apply按钮 | 在URI场景下成功应用滤镜链 | 是 | Pass |
| 测试NativeWindow输入场景 | 进入参数设置页面 | 切换输入场景为NativeWindow，点击确认与Apply按钮 | 在NativeWindow场景下成功应用滤镜链 | 是 | Pass |