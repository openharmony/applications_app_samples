# ImageEffect测试用例归档

## 用例表

| 测试功能                     | 预置条件                       | 输入                                                         | 预期输出                       | 是否自动 | 测试结果 |
| ---------------------------- | ------------------------------ | ------------------------------------------------------------ | ------------------------------ | -------- | -------- |
| 拉起应用                     | 设备正常运行                   |                                                              | 成功拉起应用                   | 是       | Pass     |
| 验证弹出参数设置页面         | 进入图片展示页面               | 点击右上角设置按钮                                           | 成功弹出参数设置页面           | 是       | Pass     |
| 验证弹出参数设置页面取消功能 | 参数设置页面弹出               | 点击取消按钮                                                 | 成功关闭参数设置页面           | 是       | Pass     |
| 验证参数设置页面确认功能     | 参数设置页面弹出，参数设置成功 | 点击确认按钮                                                 | 成功关闭参数设置页面           | 是       | Pass     |
| 验证Brightness滑动条功能     | 参数设置页面弹出               | 滑动Brightness滑动条                                         | Brightness滑动条成功滑动       | 是       | Pass     |
| 验证Contrast滑动条功能       | 参数设置页面弹出               | 滑动Contrast滑动条                                           | Contrast滑动条成功滑动         | 是       | Pass     |
| 验证Crop滑动条功能           | 参数设置页面弹出               | 滑动Crop滑动条                                               | Crop滑动条成功滑动             | 是       | Pass     |
| 验证Custom滑动条功能         | 参数设置页面弹出               | 滑动Custom滑动条                                             | Custom滑动条成功滑动           | 是       | Pass     |
| 验证Brightness滤镜功能       | 参数设置页面弹出               | 选中Brightness-滑动滑动条-确认-Apply                         | Brightness滤镜效果应用成功     | 是       | Pass     |
| 验证Contrast滤镜功能         | 参数设置页面弹出               | 选中Contrast-滑动滑动条-确认-Apply                           | Contrast滤镜效果应用成功       | 是       | Pass     |
| 验证Crop滤镜功能             | 参数设置页面弹出               | 选中Crop-滑动滑动条-确认-Apply                               | Crop滤镜效果应用成功           | 是       | Pass     |
| 验证Custom滤镜功能           | 参数设置页面弹出               | 选中Custom-滑动滑动条-确认-Apply                             | Custom滤镜效果应用成功         | 是       | Pass     |
| 验证滤镜链功能               | 参数设置页面弹出               | 选中Brightness-滑动滑动条-确认-Apply；<br>选中Contrast-滑动滑动条-确认-Apply;<br>选中Crop-滑动滑动条-确认-Apply; | 滤镜链效果应用成功             | 是       | Pass     |
| 验证图像效果应用功能         | 滤镜参数设置成功               | 点击Apply按钮                                                | 按钮存在，图像效果改变         | 是       | Pass     |
| 验证图像效果复原功能         | 滤镜效果应用成功               | 点击Reset按钮                                                | 按钮存在，图像效果复原         | 是       | Pass     |
| 验证Brightness滤镜查询功能   | 参数设置页面弹出               | 点击Brightness查询按钮                                       | Brightness滤镜查询页面成功弹出 | 是       | Pass     |
| 验证Contrast滤镜查询功能     | 参数设置页面弹出               | 点击Contrast查询按钮                                         | Contrast滤镜查询页面成功弹出   | 是       | Pass     |
| 验证Crop滤镜查询功能         | 参数设置页面弹出               | 点击Crop查询按钮                                             | Crop滤镜查询页面成功弹出       | 是       | Pass     |
| 验证Custom滤镜查询功能       | 参数设置页面弹出               | 点击Custom查询按钮                                           | Custom滤镜查询页面成功弹出     | 是       | Pass     |
| 验证滤镜查询功能             | 参数设置页面弹出               | 点击查询按钮                                                 | 弹出CategoryMenu页面           | 是       | Pass     |
| 验证CategoryMenu页面         | CategoryMenu页面成功弹出       | 点击CategoryMenu页面指定选项                                 | 弹出FormatMenu页面             | 是       | Pass     |
| 验证FormatMenu页面           | FormatMenu页面成功弹出         | 点击FormatMenu页面指定选项                                   | 弹出滤镜信息页面               | 是       | Pass     |