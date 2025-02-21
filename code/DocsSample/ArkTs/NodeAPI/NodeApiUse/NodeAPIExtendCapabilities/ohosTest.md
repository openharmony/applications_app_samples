#  使用Node-API进行扩展能力功能开发测试用例归档

## 用例表

| 测试功能                                                     | 预                 置条件 | 输入                                                         | 预期输出                                                     | 测试结果 |
| ------------------------------------------------------------ | ------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------- |
| 拉起应用                                                     | 设备正常运行              |                                                              | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口   createObjectWithProperties     | 位于主页                  | 点击文本为1.napiCreateObjectWithProperties的文本组件         | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateObjectWithPropertiesSuccess | Pass     |
| ArkTS端成功调用native侧接口createObjectWithNameProperties    | 位于主页                  | 点击文本为2.napiCreateObjectWithNamedProperties的文本组件    | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateObjectWithNamedPropertiesSuccess | Pass     |
| ArkTS端成功调用native侧接口runScriptPath                     | 位于主页                  | 点击文本为3.napiRunScriptPath的文本组件                      | 成功调用函数输出日志，页面顶端文本变为Result: napiRunScriptPathSuccess | Pass     |
| ArkTS端成功调用native侧接口getAddress，getSetSize，store，erase，clear | 位于主页                  | 点击文本为4.napiCoerceToNativeBindingObject的文本组件        | 成功调用函数输出日志，页面顶端文本变为Result: napiCoerceToNativeBindingObjectSuccess | Pass     |
| ArkTS端成功调用native侧接口aboutSerialize                    | 位于主页                  | 点击文本为5.napiAboutSerialize的文本组件                     | 成功调用函数输出日志，页面顶端文本变为Result: napiAboutSerializeSuccess | Pass     |
| ArkTS端成功调用native侧接口isSendable                        | 位于主页                  | 点击文本为6.napiIsSendable的文本组件                         | 成功调用函数输出日志，页面顶端文本变为Result: napiIsSendableSuccess | Pass     |
| ArkTS端成功调用native侧接口SendableClass                     | 位于主页                  | 点击文本为7.napiDefineSendableClass的文本组件                | 成功调用函数输出日志，页面顶端文本变为Result: napiDefineSendableClassSuccess | Pass     |
| ArkTS端成功调用native侧接口getSendableObject                 | 位于主页                  | 点击文本为8.napiCreateSendableObjectWithProperties的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateSendableObjectWithPropertiesSuccess | Pass     |
| ArkTS端成功调用native侧接口getSendableArray                  | 位于主页                  | 点击文本为9.napiCreateSendableArray的文本组件                | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateSendableArraySuccess | Pass     |
| ArkTS端成功调用native侧接口getSendableArrayWithLength        | 位于主页                  | 点击文本为10.napiCreateSendableArrayWithLength的文本组件     | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateSendableArrayWithLengthSuccess | Pass     |
| ArkTS端成功调用native侧接口getSendableArrayBuffer            | 位于主页                  | 点击文本为11.napiCreateSendableArraybuffer的文本组件         | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateSendableArraybufferSuccess | Pass     |
| ArkTS端成功调用native侧接口getSendableTypedArray             | 位于主页                  | 点击文本为12.napiCreateSendableTypedArray的文本组件          | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateSendableTypedArraySuccess | Pass     |
| ArkTS端成功调用native侧接口wrapSendable                      | 位于主页                  | 点击文本为13.napiWrapSendable的文本组件                      | 成功调用函数输出日志，页面顶端文本变为Result: napiWrapSendableSuccess | Pass     |
| ArkTS端成功调用native侧接口wrapSendableWithSize              | 位于主页                  | 点击文本为14.napiWrapSendableWithSize的文本组件              | 成功调用函数输出日志，页面顶端文本变为Result: napiWrapSendableWithSizeSuccess | Pass     |
| ArkTS端成功调用native侧接口unwrapSendable                    | 位于主页                  | 点击文本为15.napiUnwrapSendable的文本组件                    | 成功调用函数输出日志，页面顶端文本变为Result: napiUnwrapSendableSuccess | Pass     |
| ArkTS端成功调用native侧接口removeWrapSendable                | 位于主页                  | 点击文本为16.napiRemoveWrapSendable的文本组件                | 成功调用函数输出日志，页面顶端文本变为Result: napiRemoveWrapSendableSuccess | Pass     |