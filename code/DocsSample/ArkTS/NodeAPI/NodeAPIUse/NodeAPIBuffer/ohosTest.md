#  使用Node-API进行buffer相关开发测试用例归档

## 用例表

| 测试功能                                             | 预置条件     | 输入                                                | 预期输出                                                     | 测试结果 |
| ---------------------------------------------------- | ------------ | --------------------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                             | 设备正常运行 |                                                     | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口createBuffer              | 位于主页     | 点击文本为1.napiCreateBuffer的文本组件              | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateBufferSuccess | Pass     |
| ArkTS端成功调用native侧接口createExternalBuffer      | 位于主页     | 点击文本为2.napiCreateExternalBuffer的文本组件      | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateExternalBufferSuccess | Pass     |
| ArkTS端成功调用native侧接口getBufferInfo             | 位于主页     | 点击文本为3.napiGetBufferInfo的文本组件             | 成功调用函数输出日志，页面顶端文本变为Result: napiGetBufferInfoSuccess | Pass     |
| ArkTS端成功调用native侧接口isBuffer                  | 位于主页     | 点击文本为4.napiIsBuffer的文本组件                  | 成功调用函数输出日志，页面顶端文本变为Result: napiIsBufferSuccess | Pass     |
| ArkTS端成功调用native侧接口createExternalArraybuffer | 位于主页     | 点击文本为5.napiCreateExternalArraybuffer的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateExternalArraybufferSuccess | Pass     |