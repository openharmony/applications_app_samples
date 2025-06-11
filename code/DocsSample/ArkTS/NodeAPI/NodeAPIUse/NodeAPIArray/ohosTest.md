#  使用Node-API进行array相关开发测试用例归档

## 用例表

| 测试功能                                         | 预置条件     | 输入                                            | 预期输出                                                     | 测试结果 |
| ------------------------------------------------ | ------------ | ----------------------------------------------- | ------------------------------------------------------------ | -------- |
| 拉起应用                                         | 设备正常运行 |                                                 | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口   createArray        | 位于主页     | 点击文本为1.napiCreateArray的文本组件           | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateArraySuccess | Pass     |
| ArkTS端成功调用native侧接口createArrayWithLength | 位于主页     | 点击文本为2.napiCreateArrayWithLength的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateArrayWithLengthSuccess | Pass     |
| ArkTS端成功调用native侧接口getArrayLength        | 位于主页     | 点击文本为3.napiGetArrayLength的文本组件        | 成功调用函数输出日志，页面顶端文本变为Result: napiGetArrayLengthSuccess | Pass     |
| ArkTS端成功调用native侧接口isArray               | 位于主页     | 点击文本为4.napiIsArray的文本组件               | 成功调用函数输出日志，页面顶端文本变为Result: napiIsArraySuccess | Pass     |
| ArkTS端成功调用native侧接口napiSetElement        | 位于主页     | 点击文本为5.napiSetElement的文本组件            | 成功调用函数输出日志，页面顶端文本变为Result: napiSetElementSuccess | Pass     |
| ArkTS端成功调用native侧接口napiGetElement        | 位于主页     | 点击文本为6.napiGetElement的文本组件            | 成功调用函数输出日志，页面顶端文本变为Result: napiGetElementSuccess | Pass     |
| ArkTS端成功调用native侧接口napiHasElement        | 位于主页     | 点击文本为7.napiHasElement的文本组件            | 成功调用函数输出日志，页面顶端文本变为Result: napiHasElementSuccess | Pass     |
| ArkTS端成功调用native侧接口napiDeleteElement     | 位于主页     | 点击文本为8.napiDeleteElement的文本组件         | 成功调用函数输出日志，页面顶端文本变为Result: napiDeleteElementSuccess | Pass     |
| ArkTS端成功调用native侧接口createTypedArray      | 位于主页     | 点击文本为9.napiCreateTypedArray的文本组件      | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateUint8ArraySuccess | Pass     |
| ArkTS端成功调用native侧接口isTypedarray          | 位于主页     | 点击文本为10.napiIsTypedArray的文本组件         | 成功调用函数输出日志，页面顶端文本变为Result: napiIsTypedArraySuccess | Pass     |
| ArkTS端成功调用native侧接口getTypedarrayInfo     | 位于主页     | 点击文本为11.napiGetTypedArrayInfo的文本组件    | 成功调用函数输出日志，页面顶端文本变为Result: napiGetTypedArrayInfoSuccess | Pass     |
| ArkTS端成功调用native侧接口createDataView        | 位于主页     | 点击文本为12.napiCreateDataView的文本组件       | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateDataViewSuccess | Pass     |
| ArkTS端成功调用native侧接口isDataView            | 位于主页     | 点击文本为13.napiIsDataView的文本组件           | 成功调用函数输出日志，页面顶端文本变为Result: napiIsDataViewSuccess | Pass     |
| ArkTS端成功调用native侧接口getDataViewInfo       | 位于主页     | 点击文本为14.napiGetDataViewInfo的文本组件      | 成功调用函数输出日志，页面顶端文本变为Result: napiGetDataViewInfoSuccess | Pass     |