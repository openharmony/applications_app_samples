#  使用Node-API进行错误处理开发测试用例归档

## 用例表

| 测试功能                                            | 预置条件     | 输入                                               | 预期输出                                                     | 测试结果 |
| --------------------------------------------------- | ------------ | -------------------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                            | 设备正常运行 |                                                    | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口   getLastErrorInfo      | 位于主页     | 点击文本为1.napiGetLastErrorInfo的文本组件         | 成功调用函数输出日志，页面顶端文本变为Result: napiGetLastErrorInfoSuccess | Pass     |
| ArkTS端成功调用native侧接口creatTypeError           | 位于主页     | 点击文本为2.napiCreateTypeError的文本组件          | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateTypeErrorSuccess | Pass     |
| ArkTS端成功调用native侧接口creatRangeError          | 位于主页     | 点击文本为3.napiCreateRangeError的文本组件         | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateRangeErrorSuccess | Pass     |
| ArkTS端成功调用native侧接口napiThrow                | 位于主页     | 点击文本为4.napiCreateErrorAndNapiThrow的文本组件  | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateErrorAndNapiThrowSuccess | Pass     |
| ArkTS端成功调用native侧接口napiThrowError           | 位于主页     | 点击文本为5.napiThrowError的文本组件               | 成功调用函数输出日志，页面顶端文本变为Result: napiThrowErrorSuccess | Pass     |
| ArkTS端成功调用native侧接口throwTypeError           | 位于主页     | 点击文本为6.napiThrowTypeError的文本组件           | 成功调用函数输出日志，页面顶端文本变为Result: throwTypeErrorSuccess | Pass     |
| ArkTS端成功调用native侧接口throwRangeError          | 位于主页     | 点击文本为7.napiThrowRangeError的文本组件          | 成功调用函数输出日志，页面顶端文本变为Result: throwRangeErrorSuccess | Pass     |
| ArkTS端成功调用native侧接口napiIsError              | 位于主页     | 点击文本为8.napiIsError的文本组件                  | 成功调用函数输出日志，页面顶端文本变为Result: napiIsErrorSuccess | Pass     |
| ArkTS端成功调用native侧接口getAndClearLastException | 位于主页     | 点击文本为9.napiGetAndClearLastException的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiGetAndClearLastExceptionSuccess | Pass     |
| ArkTS端成功调用native侧接口isExceptionPending       | 位于主页     | 点击文本为10.napiIsExceptionPending的文本组件      | 成功调用函数输出日志，页面顶端文本变为Result: napiIsExceptionPendingSuccess | Pass     |