#  使用Node-API进行property相关开发测试用例归档

## 用例表

| 测试功能                                          | 预置条件     | 输入                                           | 预期输出                                                     | 测试结果 |
| ------------------------------------------------- | ------------ | ---------------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                          | 设备正常运行 |                                                | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口   getPropertyNames    | 位于主页     | 点击文本为1.napiGetPropertyNames的文本组件     | 成功调用函数输出日志，页面顶端文本变为Result: napiGetPropertyNamesSuccess | Pass     |
| ArkTS端成功调用native侧接口setProperty            | 位于主页     | 点击文本为2.napiSetProperty的文本组件          | 成功调用函数输出日志，页面顶端文本变为Result: napiSetPropertySuccess | Pass     |
| ArkTS端成功调用native侧接口getProperty            | 位于主页     | 点击文本为3.napiGetProperty的文本组件          | 成功调用函数输出日志，页面顶端文本变为Result: napiGetPropertySuccess | Pass     |
| ArkTS端成功调用native侧接口hasProperty            | 位于主页     | 点击文本为4.napiHasProperty的文本组件          | 成功调用函数输出日志，页面顶端文本变为Result: napiHasPropertySuccess | Pass     |
| ArkTS端成功调用native侧接口napiDeleteProperty     | 位于主页     | 点击文本为5.napiDeleteProperty的文本组件       | 成功调用函数输出日志，页面顶端文本变为Result: napiDeletePropertySuccess | Pass     |
| ArkTS端成功调用native侧接口napiHasOwnProperty     | 位于主页     | 点击文本为6.napiHasOwnProperty的文本组件       | 成功调用函数输出日志，页面顶端文本变为Result: napiHasOwnPropertySuccess | Pass     |
| ArkTS端成功调用native侧接口napiSetNamedProperty   | 位于主页     | 点击文本为7.napiSetNamedProperty的文本组件     | 成功调用函数输出日志，页面顶端文本变为Result: napiSetNamedPropertySuccess | Pass     |
| ArkTS端成功调用native侧接口napiGetNamedProperty   | 位于主页     | 点击文本为8.napiGetNamedProperty的文本组件     | 成功调用函数输出日志，页面顶端文本变为Result: napiGetNamedPropertySuccess | Pass     |
| ArkTS端成功调用native侧接口napiHasNamedProperty   | 位于主页     | 点击文本为9.napiHasNamedProperty的文本组件     | 成功调用函数输出日志，页面顶端文本变为Result: napiHasNamedPropertySuccess | Pass     |
| ArkTS端成功调用native侧接口defineStringProperties | 位于主页     | 点击文本为10.napiDefineProperties的文本组件    | 成功调用函数输出日志，页面顶端文本变为Result: napiDefinePropertiesSuccess | Pass     |
| ArkTS端成功调用native侧接口getAllPropertyNames    | 位于主页     | 点击文本为11.napiGetAllPropertyNames的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiGetAllPropertyNamesSuccess | Pass     |