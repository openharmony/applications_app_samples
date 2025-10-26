| 测试功能                              | 预置条件     | 输入                        | 预期输出                                | 测试结果 |
|-----------------------------------| ------------ |---------------------------|-------------------------------------|------|
| 查询节点uniqueId及通过uniqueId获取节点信息 | 设备正常运行 | 点击InquireUniqueId进入页面，点击按钮 | 打印日志GetNodeHandleByUniqueId success | Pass |
| OH_ArkUI_NativeModule_InvalidateAttributes接口 | 设备正常运行 | 点击Attribute进入页面，点击切换按钮    | 切换图片正常展示                            | Pass |
| 移动节点                  | 设备正常运行 |  点击MoveTo进入页面，点击按钮MoveTo | Stack节点会移动到目标位置     | Pass     |
| OH_ArkUI_NodeUtils_GetAttachedNodeHandleById接口        | 设备正常运行 |   点击GetNodeById进入页面，点击按钮     | 打印节点获取成功信息                              | Pass |
| 获取对应下标的子节点        | 设备正常运行 |   点击FetchAndLoad进入页面，点击按钮     | 日志打印对应错误码                               | Pass |