#  使用Node-API接口进行模块加载测试用例归档

## 用例表

| 测试功能                                 | 预置条件     | 输入                                               | 预期输出                                                     | 测试结果 |
| ---------------------------------------- | ------------ | -------------------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                 | 设备正常运行 |                                                    | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口   loadModule | 位于主页     | 点击按钮为调用Call loadModuleFile的Button组件      | 成功调用函数输出日志，页面顶端文本变为loadModuleFile success | Pass     |
| ArkTS端成功调用native侧接口   loadModule | 位于主页     | 点击按钮为调用Call loadModuleHarName的Button组件   | 成功调用函数输出日志，页面顶端文本变为loadModuleHarName success | Pass     |
| ArkTS端成功调用native侧接口   loadModule | 位于主页     | 点击按钮为调用Call loadModuleRemoteHar的Button组件 | 成功调用函数输出日志，页面顶端文本变为loadModuleRemoteHar success | Pass     |
| ArkTS端成功调用native侧接口   loadModule | 位于主页     | 点击按钮为调用Call loadModuleAPI的Button组件       | 成功调用函数输出日志，页面顶端文本变为loadModuleAPI success  | Pass     |
| ArkTS端成功调用native侧接口   loadModule | 位于主页     | 点击按钮为调用Call loadModuleNative的Button组件    | 成功调用函数输出日志，页面顶端文本变为loadModuleNative success | Pass     |
| ArkTS端成功调用native侧接口   loadModule | 位于主页     | 点击按钮为调用Call loadModuleHarToHar的Button组件  | 成功调用函数输出日志，页面顶端文本变为loadModuleHarToHar success | Pass     |