# 剪切板 测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|打开应用|设备中存在主题应用|拉起应用|应用启动成功|Pass|
|赋予剪切板权限|应用启动成功|点击权限赋予按钮'仅本次允许'|权限赋予成功|Pass|
|复制文本|文本框输入文本|点击复制按钮|复制文本到剪切板成功|Pass|
|粘贴文本|复制文本成功|点击粘贴按钮|文本粘贴到文本框成功|Pass|
|粘贴控件进行粘贴|复制文本成功|点击粘贴控件|文本粘贴到文本框成功|Pass|
|文本类型粘贴|复制文本成功|点击仅文本粘贴按钮|文本粘贴到文本框成功|Pass|
