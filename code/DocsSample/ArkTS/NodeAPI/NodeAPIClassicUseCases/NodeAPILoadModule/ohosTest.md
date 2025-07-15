#  使用Node-API接口在主线程中进行模块加载测试用例归档

## 用例表

| 测试功能                                 | 预置条件     | 输入                                            | 预期输出                                                     | 测试结果 |
| ---------------------------------------- | ------------ | ----------------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                 | 设备正常运行 |                                                 | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口 loadModulesSystem | 位于主页     | 点击按钮为调用Call loadModulesSystem的Button组件 | 成功调用函数输出日志，页面顶端文本变为loadModulesSystem success | Pass         |
| ArkTS端成功调用native侧接口 loadEtsDirModule | 位于主页     | 点击按钮为调用Call loadEtsDirModule的Button组件 | 成功调用函数输出日志，页面顶端文本变为loadEtsDirModule success | Pass         |
| ArkTS端成功调用native侧接口 loadModuleFile | 位于主页     | 点击按钮为调用Call loadModuleFile的Button组件   | 成功调用函数输出日志，页面顶端文本变为loadModuleFile success | Pass     |
| ArkTS端成功调用native侧接口 loadHarModule | 位于主页     | 点击按钮为调用Call loadHarModule的Button组件    | 成功调用函数输出日志，页面顶端文本变为loadHarModule success | Pass         |
| ArkTS端成功调用native侧接口 loadHspModule | 位于主页     | 点击按钮为调用Call loadHspModule的Button组件    | 成功调用函数输出日志，页面顶端文本变为loadHspModule success | Pass         |
| ArkTS端成功调用native侧接口 loadFarHarModule | 位于主页     | 点击按钮为调用Call loadFarHarModule的Button组件 | 成功调用函数输出日志，页面顶端文本变为loadFarHarModule success | Pass         |
| ArkTS端成功调用native侧接口 loadOhpmModule | 位于主页     | 点击按钮为调用Call loadOhpmModule的Button组件   | 成功调用函数输出日志，页面顶端文本变为loadOhpmModule success | Pass         |
| ArkTS端成功调用native侧接口 loadNativeModule | 位于主页     | 点击按钮为调用Call loadNativeModule的Button组件 | 成功调用函数输出日志，页面顶端文本变为loadNativeModule success | Pass         |
| ArkTS端成功调用native侧接口 har1LodeHar2 | 位于主页     | 点击按钮为调用Call har1LodeHar2的Button组件     | 成功调用函数输出日志，页面顶端文本变为har1LodeHar2 success | Pass         |