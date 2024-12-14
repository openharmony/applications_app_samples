#  使用Node-API进行environmental-life-cycle相关开发测试用例归档

## 用例表

| 测试功能                                      | 预置条件     | 输入                                      | 预期输出                                                     | 测试结果 |
| --------------------------------------------- | ------------ | ----------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                      | 设备正常运行 |                                           | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口   setInstanceData | 位于主页     | 点击文本为1.napiSetInstanceData的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiSetInstanceDataSuccess | Pass     |
| ArkTS端成功调用native侧接口getInstanceData    | 位于主页     | 点击文本为2.napiGetInstanceData的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiGetInstanceDataSuccess | Pass     |