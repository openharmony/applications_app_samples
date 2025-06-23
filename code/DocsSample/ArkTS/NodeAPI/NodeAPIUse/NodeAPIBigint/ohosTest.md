#  使用Node-API进行bigInt相关开发测试用例归档

## 用例表

| 测试功能                                         | 预置条件     | 输入                                           | 预期输出                                                     | 测试结果 |
| ------------------------------------------------ | ------------ | ---------------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                         | 设备正常运行 |                                                | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口createBigintInt64t    | 位于主页     | 点击文本为1.napiCreateBigintInt64的文本组件    | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateBigintInt64Success | Pass     |
| ArkTS端成功调用native侧接口createBigintUint64t   | 位于主页     | 点击文本为2.napiCreateBigintUint64的文本组件   | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateBigintUint64Success | Pass     |
| ArkTS端成功调用native侧接口createBigintWords     | 位于主页     | 点击文本为3.napiCreateBigintWords的文本组件    | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateBigintWordsSuccess | Pass     |
| ArkTS端成功调用native侧接口getValueBigintInt64t  | 位于主页     | 点击文本为4.napiGetValueBigintInt64的文本组件  | 成功调用函数输出日志，页面顶端文本变为Result: napiGetValueBigintInt64Success | Pass     |
| ArkTS端成功调用native侧接口getValueBigintUint64t | 位于主页     | 点击文本为5.napiGetValueBigintUint64的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiGetValueBigintUint64Success | Pass     |
| ArkTS端成功调用native侧接口getValueBigintWords   | 位于主页     | 点击文本为6.napiGetValueBigintWords的文本组件  | 成功调用函数输出日志，页面顶端文本变为Result: napiGetValueBigintWordsSuccess | Pass     |