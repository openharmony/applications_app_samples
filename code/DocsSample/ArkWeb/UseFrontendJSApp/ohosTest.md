### entry:

| 测试功能                | 预置条件     | 输入                                | 预期输出                       | 是否自动 | 测试结果 |
| ----------------------- | ------------ | ----------------------------------- | ------------------------------ | -------- | -------- |
| 应用侧调用前端页面函数  | 设备运转正常 | 应用启动成功，点击runJavaScript按钮 | 文本字体变绿                   | Yes      | Pass     |
| runJavaScriptCodePassed | 设备运转正常 | 点击runJavaScriptCodePassed按钮     | 向前端传递自定义JavaScript代码 | Yes      | Pass     |
| callArkTS               | 设备运转正常 | 点击 Click Me! 按钮                 | 文本字体变红                   | Yes      | Pass     |

### entry2:

#### JavaScriptProxy

| 测试功能               | 预置条件     | 输入                                           | 预期输出                  | 是否自动 | 测试结果 |
| ---------------------- | ------------ | ---------------------------------------------- | ------------------------- | -------- | -------- |
| 前端页面调用应用侧函数 | 设备运转正常 | 应用启动成功，点击deleteJavaScriptRegister按钮 | 从 Web 端删除已注册对象   | Yes      | Pass     |
| 触发callArkTS函数      | 设备运转正常 | 点击Click Me!按钮                              | 界面显示ArkTS Hello world | Yes      | Pass     |

#### RegisterJavaScriptProxy

| 测试功能               | 预置条件            | 输入                                  | 预期输出                       | 是否自动 | 测试结果 |
| ---------------------- | ------------------- | ------------------------------------- | ------------------------------ | -------- | -------- |
| 前端页面调用应用侧函数 | 设备运转正常        | 应用启动成功，点击refresh按钮         | 刷新网页                       | Yes      | Pass     |
| 注册 testObj           | 设备运转正常        | 点击Register JavaScript To Window按钮 | 将 testObj 注册到前端          | Yes      | Pass     |
| 删除testObjName        | 注册testObjName对象 | 点击deleteJavaScriptRegister按钮      | 删除Web端注册的testObjName对象 | Yes      | Pass     |
| callArkTS              | testObj 注册到前端  | 点击Click Me!按钮                     | 触发callArkTS函数              | Yes      | Pass     |

#### UsageOfComplexTypes_one

| 测试功能               | 预置条件            | 输入                                  | 预期输出                       | 是否自动 | 测试结果 |
| ---------------------- | ------------------- | ------------------------------------- | ------------------------------ | -------- | -------- |
| 前端页面调用应用侧函数 | 设备运转正常        | 应用启动成功，点击refresh按钮         | 刷新网页                       | Yes      | Pass     |
| 注册 testObj           | 设备运转正常        | 点击Register JavaScript To Window按钮 | 将 testObj 注册到前端          | Yes      | Pass     |
| 删除testObjName        | 注册testObjName对象 | 点击deleteJavaScriptRegister按钮      | 删除Web端注册的testObjName对象 | Yes      | Pass     |
| callArkTS              | testObj 注册到前端  | 点击Click Me!按钮                     | 触发callArkTS函数              | Yes      | Pass     |

#### UsageOfComplexTypes_two

| 测试功能               | 预置条件            | 输入                                  | 预期输出                       | 是否自动 | 测试结果 |
| ---------------------- | ------------------- | ------------------------------------- | ------------------------------ | -------- | -------- |
| 前端页面调用应用侧函数 | 设备运转正常        | 应用启动成功，点击refresh按钮         | 刷新网页                       | Yes      | Pass     |
| 注册 testObj           | 设备运转正常        | 点击Register JavaScript To Window按钮 | 将 testObj 注册到前端          | Yes      | Pass     |
| 删除testObjName        | 注册testObjName对象 | 点击deleteJavaScriptRegister按钮      | 删除Web端注册的testObjName对象 | Yes      | Pass     |
| callArkTS              | testObj 注册到前端  | 点击Click Me!按钮                     | 触发callArkTS函数              | Yes      | Pass     |

#### UsageOfComplexTypes_three

| 测试功能               | 预置条件            | 输入                                  | 预期输出                       | 是否自动 | 测试结果 |
| ---------------------- | ------------------- | ------------------------------------- | ------------------------------ | -------- | -------- |
| 前端页面调用应用侧函数 | 设备运转正常        | 应用启动成功，点击refresh按钮         | 刷新网页                       | Yes      | Pass     |
| 注册 testObj           | 设备运转正常        | 点击Register JavaScript To Window按钮 | 将 testObj 注册到前端          | Yes      | Pass     |
| 删除testObjName        | 注册testObjName对象 | 点击deleteJavaScriptRegister按钮      | 删除Web端注册的testObjName对象 | Yes      | Pass     |
| callArkTS              | testObj 注册到前端  | 点击Click Me!按钮                     | 触发callArkTS函数              | Yes      | Pass     |

#### UsageOfComplexTypes_four

| 测试功能               | 预置条件            | 输入                                  | 预期输出                       | 是否自动 | 测试结果 |
| ---------------------- | ------------------- | ------------------------------------- | ------------------------------ | -------- | -------- |
| 前端页面调用应用侧函数 | 设备运转正常        | 应用启动成功，点击refresh按钮         | 刷新网页                       | Yes      | Pass     |
| 注册 testObj           | 设备运转正常        | 点击Register JavaScript To Window按钮 | 将 testObj 注册到前端          | Yes      | Pass     |
| 删除testObjName        | 注册testObjName对象 | 点击deleteJavaScriptRegister按钮      | 删除Web端注册的testObjName对象 | Yes      | Pass     |
| callArkTS              | testObj 注册到前端  | 点击Click Me!按钮                     | 触发callArkTS函数              | Yes      | Pass     |

#### UsageOfComplexTypes_five

| 测试功能               | 预置条件            | 输入                                  | 预期输出                       | 是否自动 | 测试结果 |
| ---------------------- | ------------------- | ------------------------------------- | ------------------------------ | -------- | -------- |
| 前端页面调用应用侧函数 | 设备运转正常        | 应用启动成功，点击refresh按钮         | 刷新网页                       | Yes      | Pass     |
| 注册 testObj           | 设备运转正常        | 点击Register JavaScript To Window按钮 | 将 testObj 注册到前端          | Yes      | Pass     |
| 删除testObjName        | 注册testObjName对象 | 点击deleteJavaScriptRegister按钮      | 删除Web端注册的testObjName对象 | Yes      | Pass     |
| callArkTS              | testObj 注册到前端  | 点击Click Me!按钮                     | 触发callArkTS函数              | Yes      | Pass     |

#### Promise_one

| 测试功能               | 预置条件            | 输入                                  | 预期输出                       | 是否自动 | 测试结果 |
| ---------------------- | ------------------- | ------------------------------------- | ------------------------------ | -------- | -------- |
| 前端页面调用应用侧函数 | 设备运转正常        | 应用启动成功，点击refresh按钮         | 刷新网页                       | Yes      | Pass     |
| 注册 testObj           | 设备运转正常        | 点击Register JavaScript To Window按钮 | 将 testObj 注册到前端          | Yes      | Pass     |
| 删除testObjName        | 注册testObjName对象 | 点击deleteJavaScriptRegister按钮      | 删除Web端注册的testObjName对象 | Yes      | Pass     |
| 触发callArkTS函数      | testObj 注册到前端  | 点击Click Me!按钮                     | 控制台在10s左右打印fail        | Yes      | Pass     |

#### Promise_two

| 测试功能               | 预置条件            | 输入                                  | 预期输出                       | 是否自动 | 测试结果 |
| ---------------------- | ------------------- | ------------------------------------- | ------------------------------ | -------- | -------- |
| 前端页面调用应用侧函数 | 设备运转正常        | 应用启动成功，点击refresh按钮         | 刷新网页                       | Yes      | Pass     |
| 注册 testObj           | 设备运转正常        | 点击Register JavaScript To Window按钮 | 将 testObj 注册到前端          | Yes      | Pass     |
| 删除testObjName        | 注册testObjName对象 | 点击deleteJavaScriptRegister按钮      | 删除Web端注册的testObjName对象 | Yes      | Pass     |
| callArkTS              | testObj 注册到前端  | 点击Click Me!按钮                     | 触发callArkTS函数              | Yes      | Pass     |

### entry3:

| 测试功能                     | 预置条件                                   | 输入                              | 预期输出                | 是否自动 | 测试结果 |
| ---------------------------- | ------------------------------------------ | --------------------------------- | ----------------------- | -------- | -------- |
| 建立应用侧与前端页面数据通道 | 设备运转正常                               | 应用启动成功，点击postMessage按钮 | 初始化消息端口          | Yes      | Pass     |
| SendDataToHTML               | 设备运转正常，初始化消息端口               | 点击SendDataToHTML按钮            | 从 ETS 向 HTML 发送消息 | Yes      | Pass     |
| SendToEts                    | 设备运转正常，初始化消息端口，输入框有消息 | 点击SendToEts按钮                 | 从 HTML 向 ETS 发送消息 | Yes      | Pass     |

### entry4:

| 测试功能                          | 预置条件     | 输入                               | 预期输出                   | 是否自动 | 测试结果 |
| --------------------------------- | ------------ | ---------------------------------- | -------------------------- | -------- | -------- |
| 应用侧与前端页面的相互调用(C/C++) | 设备运转正常 | 应用启动成功，点击 runJS hello按钮 | 调用testNapi.runJavaScript | Yes      | Pass     |
| testNdkProxyObjMethod1            | 设备运转正常 | 点击test Native Development Kit method1!按钮          | 调用testNdkProxyObjMethod1 | Yes      | Pass     |

### entry5:

| 测试功能                     | 预置条件     | 输入                                              | 预期输出                                                | 是否自动 | 测试结果 |
| ---------------------------- | ------------ | ------------------------------------------------- | ------------------------------------------------------- | -------- | -------- |
| 创建特殊端口                 | 设备运转正常 | 应用启动成功，点击 createNoControllerTagPort 按钮 | 调用 testNapi.createWebMessagePorts                     | Yes      | Pass     |
| 建立通信通道                 | 设备运转正常 | 点击createPort按钮                                | 调用 testNapi.createWebMessagePorts                     | Yes      | Pass     |
| 注册消息处理的回调           | 成功创建端口 | 点击setHandler按钮                                | 调用 testNapi.setMessageEventHandler                    | Yes      | Pass     |
| 注册消息处理的回调（多线程） | 设备运转正常 | 点击setHandlerThread按钮                          | 调用 testNapi.setMessageEventHandlerThread              | Yes      | Pass     |
| 发送消息                     | 回调注册成功 | 点击SendString按钮                                | TextArea 中显示 H5 recv result: send string from native | Yes      | Pass     |

