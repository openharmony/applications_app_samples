#  使用Node-API进行primitive相关开发测试用例归档

## 用例表

| 测试功能                                   | 预置条件     | 输入                                     | 预期输出                                                     | 测试结果 |
| ------------------------------------------ | ------------ | ---------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                   | 设备正常运行 |                                          | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口   coerceToBool | 位于主页     | 点击文本为1.napiCoerceToBool的文本组件   | 成功调用函数输出日志，页面顶端文本变为Result: napiCoerceToBoolSuccess | Pass     |
| ArkTS端成功调用native侧接口coerceToNumber  | 位于主页     | 点击文本为2.napiCoerceToNumber的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiCoerceToNumberSuccess | Pass     |
| ArkTS端成功调用native侧接口coerceToObject  | 位于主页     | 点击文本为3.napiCoerceToObject的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiCoerceToObjectSuccess | Pass     |
| ArkTS端成功调用native侧接口coerceToString  | 位于主页     | 点击文本为4.napiCoerceToString的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiCoerceToStringSuccess | Pass     |
| ArkTS端成功调用native侧接口getBoolean      | 位于主页     | 点击文本为5.napiGetBoolean的文本组件     | 成功调用函数输出日志，页面顶端文本变为Result: napiGetBooleanSuccess | Pass     |
| ArkTS端成功调用native侧接口getValueBool    | 位于主页     | 点击文本为6.napiGetValueBool的文本组件   | 成功调用函数输出日志，页面顶端文本变为Result: napiGetValueBoolSuccess | Pass     |
| ArkTS端成功调用native侧接口getGlobal       | 位于主页     | 点击文本为7.napiGetGlobal的文本组件      | 成功调用函数输出日志，页面顶端文本变为Result: napiGetGlobalSuccess | Pass     |
| ArkTS端成功调用native侧接口getNull         | 位于主页     | 点击文本为8.napiGetNull的文本组件        | 成功调用函数输出日志，页面顶端文本变为Result: napiGetNullSuccess | Pass     |
| ArkTS端成功调用native侧接口getUndefined    | 位于主页     | 点击文本为9.napiGetUndefined的文本组件   | 成功调用函数输出日志，页面顶端文本变为Result: napiGetUndefinedSuccess | Pass     |