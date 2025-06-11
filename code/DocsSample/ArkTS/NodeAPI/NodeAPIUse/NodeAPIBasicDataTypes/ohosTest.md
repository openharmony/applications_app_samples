#  使用Node-API进行basic_data_types相关开发测试用例归档

## 用例表

| 测试功能                                  | 预置条件     | 输入                                     | 预期输出                                                     | 测试结果 |
| ----------------------------------------- | ------------ | ---------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                  | 设备正常运行 |                                          | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口getValueUint32 | 位于主页     | 点击文本为1.napiGetValueUint32的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiGetValueUint32Success | Pass     |
| ArkTS端成功调用native侧接口getValueInt32  | 位于主页     | 点击文本为2.napiGetValueInt32的文本组件  | 成功调用函数输出日志，页面顶端文本变为Result: napiGetValueInt32Success | Pass     |
| ArkTS端成功调用native侧接口getValueInt64  | 位于主页     | 点击文本为3.napiGetValueInt64的文本组件  | 成功调用函数输出日志，页面顶端文本变为Result: napiGetValueInt64Success | Pass     |
| ArkTS端成功调用native侧接口getDouble      | 位于主页     | 点击文本为4.napiGetValueDouble的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiGetValueDoubleSuccess | Pass     |
| ArkTS端成功调用native侧接口createInt32    | 位于主页     | 点击文本为5.napiCreateInt32的文本组件    | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateInt32Success | Pass     |
| ArkTS端成功调用native侧接口createUInt32   | 位于主页     | 点击文本为6.napiCreateUint32的文本组件   | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateUint32Success | Pass     |
| ArkTS端成功调用native侧接口createInt64    | 位于主页     | 点击文本为7.napiCreateInt64的文本组件    | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateInt64Success | Pass     |
| ArkTS端成功调用native侧接口createDouble   | 位于主页     | 点击文本为8.napiCreateDouble的文本组件   | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateDoubleSuccess | Pass     |