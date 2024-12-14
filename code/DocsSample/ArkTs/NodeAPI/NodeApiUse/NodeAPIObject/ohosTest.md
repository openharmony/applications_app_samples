#  使用Node-API进行object相关开发测试用例归档

## 用例表

| 测试功能                                                     | 预置条件     | 输入                                       | 预期输出                                                     | 测试结果 |
| ------------------------------------------------------------ | ------------ | ------------------------------------------ | ------------------------------------------------------------ | -------- |
| 拉起应用                                                     | 设备正常运行 |                                            | 成功拉起应用                                                 | Pass     |
| ArkTS端成功调用native侧接口   napiGetPrototype               | 位于主页     | 点击文本为1.napiGetPrototype的文本组件     | 成功调用函数输出日志，页面顶端文本变为Result: napiGetPrototypeSuccess | Pass     |
| ArkTS端成功调用native侧接口createObject                      | 位于主页     | 点击文本为2.napiCreateObject的文本组件     | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateObjectSuccess | Pass     |
| ArkTS端成功调用native侧接口objectFreeze                      | 位于主页     | 点击文本为3.napiObjectFreeze的文本组件     | 成功调用函数输出日志，页面顶端文本变为Result: napiObjectFreezeSuccess | Pass     |
| ArkTS端成功调用native侧接口objectSeal                        | 位于主页     | 点击文本为4.napiObjectSeal的文本组件       | 成功调用函数输出日志，页面顶端文本变为Result: napiObjectSealSuccess | Pass     |
| ArkTS端成功调用native侧接口napiTypeOf                        | 位于主页     | 点击文本为5.napiTypeof的文本组件           | 成功调用函数输出日志，页面顶端文本变为Result: napiTypeofSuccess | Pass     |
| ArkTS端成功调用native侧接口napiInstanceof                    | 位于主页     | 点击文本为6.napiInstanceof的文本组件       | 成功调用函数输出日志，页面顶端文本变为Result: napiInstanceofSuccess | Pass     |
| ArkTS端成功调用native侧接口setTypeTagToObject，checkObjectTypeTag | 位于主页     | 点击文本为7.napiTypeTagObject的文本组件    | 成功调用函数输出日志，页面顶端文本变为Result: napiTypeTagObjectSuccess | Pass     |
| ArkTS端成功调用native侧接口createExternal，getExternalType   | 位于主页     | 点击文本为8.napiCreateExternal的文本组件   | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateExternalSuccess | Pass     |
| ArkTS端成功调用native侧接口getValueExternal                  | 位于主页     | 点击文本为9.napiGetValueExternal的文本组件 | 成功调用函数输出日志，页面顶端文本变为Result: napiGetValueExternalSuccess | Pass     |
| ArkTS端成功调用native侧接口createSymbol                      | 位于主页     | 点击文本为10.napiCreateSymbol的文本组件    | 成功调用函数输出日志，页面顶端文本变为Result: napiCreateSymbolSuccess | Pass     |