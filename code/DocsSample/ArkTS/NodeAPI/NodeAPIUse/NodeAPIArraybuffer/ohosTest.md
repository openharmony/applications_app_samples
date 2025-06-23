#  使用Node-API进行arraybuffer相关开发测试用例归档

## 用例表

| 测试功能                                         | 预置条件     | 输入                                         | 预期输出                                                     | 测试结果 |
| ------------------------------------------------ | ------------ | -------------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                         | 设备正常运行 |                                              | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口isArrayBuffer         | 位于主页     | 点击文本为1.napiIsArraybuffer的文本组件      | 成功调用函数输出日志，页面顶端文本变为Result: napiIsArraybufferSuccess | Pass     |
| ArkTS端成功调用native侧接口getArraybufferInfo    | 位于主页     | 点击文本为2.napiGetArraybufferInfo的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiGetArraybufferInfoSuccess | Pass     |
| ArkTS端成功调用native侧接口isDetachedArraybuffer | 位于主页     | 点击文本为3.napiDetachArraybuffer的文本组件  | 成功调用函数输出日志，页面顶端文本变为Result: napiDetachArraybufferSuccess | Pass     |
| ArkTS端成功调用native侧接口createArraybuffer     | 位于主页     | 点击文本为4.napiCreateArraybuffer的文本组件  | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateArraybufferSuccess | Pass     |