# 增强路由设备选择测试用例归档

## 用例表

| 测试功能                             | 预置条件       | 输入                                 | 预期输出                         | 是否自动 |
|----------------------------------|--------------|------------------------------------|------------------------------|---------|
| 拉起应用                             | 设备正常运行     | -                                  | 成功拉起应用，进入增强路由设备选择页面        | 是      |
| 查询增强路由支持                        | 增强路由设备页面    | 点击"查询增强路由支持"                      | 调用OH_AudioDeviceEnhanceManager_IsEnhancedRoutingSupported，NAPI返回信息显示是否支持增强路由功能 | 是      |
| 创建AudioRenderer                 | 增强路由设备页面    | 点击"创建AudioRenderer"               | 成功创建AudioRenderer实例        | 是      |
| 创建AudioCapturer                 | 增强路由设备页面    | 点击"创建AudioCapturer"               | 请求麦克风权限后成功创建AudioCapturer实例  | 是      |
| 为应用选择输出                          | 增强路由设备页面    | 点击"为应用选择输出"，在弹出列表中选择设备           | 弹出可选输出设备列表，选中后调用OH_AudioDeviceEnhanceManager_SelectOutputDevice为应用选择输出设备 | 是      |
| 为应用选择输入                          | 增强路由设备页面    | 点击"为应用选择输入"，在弹出列表中选择设备           | 弹出可选输入设备列表，选中后调用OH_AudioDeviceEnhanceManager_SelectInputDevice为应用选择输入设备 | 是      |
| 为Renderer选择输出                    | 增强路由设备页面，已创建Renderer | 点击"为Renderer选择输出"            | 弹出可选输出设备列表，选中后调用OH_AudioDeviceEnhanceManager_SelectOutputDeviceForAudioRenderer为播放流选择输出设备。未创建AudioRenderer时提示错误 | 是      |
| 为Capturer选择输入                    | 增强路由设备页面，已创建Capturer | 点击"为Capturer选择输入"            | 弹出可选输入设备列表，选中后调用OH_AudioDeviceEnhanceManager_SelectInputDeviceForAudioCapturer为录制流选择输入设备。未创建AudioCapturer时提示错误 | 是      |
