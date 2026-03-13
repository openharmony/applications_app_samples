## 应用侧调用前端页面函数

### 介绍

1. 本示例主要介绍应用侧调用前端页面函数，应用侧可以通过runJavaScript()和runJavaScriptExt()方法调用前端页面的JavaScript相关函数。
2. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-in-app-frontend-page-function-invoking.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

### 效果预览

| 主页                                                         | 绿色字体                                                     | 红色字体                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="screenshots\AppCallFrontendFn_1.png" width="360;" /> | <img src="screenshots\AppCallFrontendFn_2.png" width="360;" /> | <img src="screenshots\AppCallFrontendFn_3.png" width="360;" /> |

使用说明

1. 点击 runJavaScript 按钮，文本字体变绿，此操作调用前端 htmlTest() 方法实现。
2. 点击 runJavaScriptCodePassed 按钮，通过向前端传递自定义JavaScript代码改变颜色。
3. 点击 Click Me! 按钮触发前端 callArkTS() 函数，开启交互逻辑，文本字体变红。

### 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```


### 具体实现
* 通过runJavaScript方法调用前端页面的JavaScript相关函数或向Web页面注入JavaScript代码

### 相关权限

无。

## 前端页面调用应用侧函数

### 介绍

1. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-in-page-app-function-invoking.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

### JavaScriptProxy

#### 介绍

1. 本示例主要介绍前端页面调用应用侧函数。在Web组件初始化使用javaScriptProxy()接口注册应用侧代码。

#### 效果预览

| 主页                                                         | 触发callArkTS                                                |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="screenshots\JavaScriptProxy_1.png" width="360;" /> | <img src="screenshots\JavaScriptProxy_2.png" width="360;" /> |

使用说明

1. 点击deleteJavaScriptRegister按钮从 Web 端删除已注册对象。
1. 点击Click Me!按钮，触发callArkTS函数。

### Promise_one

#### 介绍

1. 本示例主要介绍前端页面调用应用侧函数，Promise使用场景，在应用侧new Promise。

#### 效果预览

| 主页                                                   |
| ------------------------------------------------------ |
| <img src="screenshots\Promise_one.png" width="360;" /> |

使用说明

1. 点击refresh按钮刷新网页。
2. 点击Register JavaScript To Window按钮将testObj注册到前端。
3. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
4. 点击Click Me!按钮，触发callArkTS函数。

### Promise_two

#### 介绍

1. 本示例主要介绍前端页面调用应用侧函数，Promise使用场景，在前端页面new Promise。

#### 效果预览

| 主页                                                   |
| ------------------------------------------------------ |
| <img src="screenshots\Promise_two.png" width="360;" /> |

使用说明

1. 点击refresh按钮刷新网页。
2. 点击Register JavaScript To Window按钮将 testObj 注册到前端。
3. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
4. 点击Click Me!按钮，触发callArkTS函数。

### RegisterJavaScriptProxy

#### 介绍

1. 本示例主要介绍前端页面调用应用侧函数，在Web组件初始化使用registerJavaScriptProxy()接口注册应用侧代码。

#### 效果预览

| 主页                                                         | 触发callArkTS                                                |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="screenshots\RegisterJavaScriptProxy_1.png" width="360;" /> | <img src="screenshots\RegisterJavaScriptProxy_2.png" width="360;" /> |

使用说明

1. 点击refresh按钮刷新网页。
2. 点击Register JavaScript To Window按钮将 testObj 注册到前端。
3. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
4. 点击Click Me!按钮，触发callArkTS函数。

### RegisterJavaScriptProxyOne

#### 介绍

本示例用于补充介绍前端页面调用应用侧函数方式，在Web组件初始时使用registerJavaScriptProxy()接口注册应用侧代码。

#### 效果预览

| 主页                                                         | 触发callArkTS                                                |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="screenshots\RegisterJavaScriptProxy_one_1.png" width="360;" /> | <img src="screenshots\RegisterJavaScriptProxy_one_2.png" width="360;" /> |

使用说明

1. 直接点击Click Me!按钮，触发callArkTS函数。
2. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
3. 点击Click Me!按钮，不会触发callArkTS函数。

### RegisterJavaScriptProxyTwo

#### 介绍

本示例用于补充介绍前端页面调用应用侧函数方式，在页面加载完成后使用registerJavaScriptProxy()接口注册应用侧代码。

#### 效果预览

| 主页                                                         | 触发callArkTS                                                |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="screenshots\RegisterJavaScriptProxy_two_1.png" width="360;" /> | <img src="screenshots\RegisterJavaScriptProxy_two_2.png" width="360;" /> |

使用说明

1. 直接点击Click Me!按钮，触发callArkTS函数。
2. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
3. 点击Click Me!按钮，不会触发callArkTS函数。

### UsageOfComplexTypes_one

#### 介绍

1. 本示例主要介绍前端页面调用应用侧函数，在应用侧和前端页面之间传递Array。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\UsageOfComplexTypes_one.png" width="360;" /> |

使用说明

1. 点击refresh按钮刷新网页。
2. 点击Register JavaScript To Window按钮将 testObj 注册到前端。
3. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
4. 点击Click Me!按钮，触发callArkTS函数。

### UsageOfComplexTypes_two

#### 介绍

1. 本示例主要介绍前端页面调用应用侧函数，应用侧和前端页面之间传递基础类型，非Function等复杂类型。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\UsageOfComplexTypes_two.png" width="360;" /> |

使用说明

1. 点击refresh按钮刷新网页。
2. 点击Register JavaScript To Window按钮将 testObj 注册到前端。
3. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
4. 点击Click Me!按钮，触发callArkTS函数。

### UsageOfComplexTypes_three

#### 介绍

1. 本示例主要介绍前端页面调用应用侧函数，应用侧调用前端页面的Callback。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\UsageOfComplexTypes_three.png" width="360;" /> |

使用说明

1. 点击refresh按钮刷新网页。
2. 点击Register JavaScript To Window按钮将 testObj 注册到前端。
3. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
4. 点击Click Me!按钮，触发callArkTS函数。

### UsageOfComplexTypes_four

#### 介绍

1. 本示例主要介绍前端页面调用应用侧函数，应用侧调用前端页面Object里的Function。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\UsageOfComplexTypes_four.png" width="360;" /> |

使用说明

1. 点击refresh按钮刷新网页。
2. 点击Register JavaScript To Window按钮将 testObj 注册到前端。
3. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
4. 点击Click Me!按钮，触发callArkTS函数。

### UsageOfComplexTypes_five

#### 介绍

1. 本示例主要介绍前端页面调用应用侧函数，前端页面调用应用侧Object里的Function。

#### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="screenshots\UsageOfComplexTypes_five.png" width="360;" /> |

使用说明

1. 点击refresh按钮刷新网页。
2. 点击Register JavaScript To Window按钮将 testObj 注册到前端。
3. 点击deleteJavaScriptRegister按钮删除Web端注册的testObjName对象。
4. 点击Click Me!按钮，触发callArkTS函数。

### 工程目录

```
entry2/src/main/
|---ets
|---|---entry2ability
|---|---|---Entry2Ability.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---|---|---JavaScriptProxy
|---|---|---Promise_one
|---|---|---Promise_two
|---|---|---RegisterJavaScriptProxy
|---|---|---UsageOfComplexTypes_one
|---|---|---UsageOfComplexTypes_two
|---|---|---UsageOfComplexTypes_three
|---|---|---UsageOfComplexTypes_four
|---|---|---UsageOfComplexTypes_five
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```

### 具体实现
* 通过registerJavaScriptProxy接口注册JavaScript对象，通过refresh使页面下次（重新）加载后生效。
* 点击Click Me!按钮，触发callArkTS函数。
* 通过deleteJavaScriptRegister接口反注册JavaScript对象，通过refresh使页面下次（重新）加载后生效。

### 相关权限

[ohos.permission.INTERNET](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)

## 建立应用侧与前端页面数据通道

### 介绍

1. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-app-page-data-channel.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

### 效果预览

| 主页                                                         | 向 HTML 发送消息                                             | 向 ArkTS 发送消息                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="screenshots\EstabDataChannel_1.png" width="360;" /> | <img src="screenshots\EstabDataChannel_2.png" width="360;" /> | <img src="screenshots\EstabDataChannel_3.png" width="360;" /> |

使用说明

1. 点击postMessage按钮初始化消息端口。
2. 点击SendDataToHTML按钮从 ArkTS 向 ETS 发送消息。
3. 点击SendToEts按钮，从 ETS 向 ArkTS 发送消息。

### 工程目录

```
entry3/src/main/
|---ets
|---|---entry3ability
|---|---|---Entry3Ability.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```

### 具体实现
* 应用侧页面中通过createWebMessagePorts方法创建两个消息端口，再把其中一个端口通过postMessage()接口发送到前端页面，实现在前端页面和应用侧之间互相发送消息。端口使用完毕后或Webview对象销毁前通过close接口关闭端口。


### 相关权限

无。

## 应用侧与前端页面的相互调用(C/C++)

### 介绍

1. 实现文档中提供的示例代码片段的工程化，确保示例代码与sample工程文件同源。文档链接：https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/web/arkweb-ndk-jsbridge.md 。

### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/MutualInvokeCCpp.png" width="360;" /> |

使用说明

1. 点击 runJS hello按钮调用testNapi.runJavaScript。
2. 点击test Native Development Kit method1 !按钮调用testNdkProxyObjMethod1。
3. 点击test Native Development Kit method2 !按钮调用testNdkProxyObjMethod2。

### 工程目录

```
entry4/src/main/
|---cpp										// cpp文件夹
|---ets
|---|---entry4ability
|---|---|---Entry4Ability.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```


### 具体实现
* 应用侧与前端页面的相互调用(C/C++)。参考源码：[Index.ets](./entry4/src/main/ets/pages/Index.ets)、[hello.cpp](./entry4/src/main/cpp/hello.cpp)
  * 在ArkTS侧自定义一个标识webTag，并将webTag通过Node-API传至应用Native侧。
  * 在Native侧，通过函数OH_ArkWeb_GetNativeAPI先获取API结构体，调用结构体里的Native API。
  * Native侧，通过ArkWeb_ComponentAPI注册组件生命周期回调。
  * 前端页面通过registerJavaScriptProxyEx将应用侧函数注册至前端页面，注册后在下次加载或者重新加载后生效。
  * 应用侧使用runJavaScript调用前端页面函数。

### 相关权限

无。

## 建立应用侧与前端页面数据通道(C/C++)

### 介绍

1. 实现对以下文档中提供中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/arkweb-ndk-page-data-channel.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

### 效果预览

| 主页                                                         | 通信                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/EstabDataChannelC_C_1.png" width="360;" /> | <img src="./screenshots/EstabDataChannelC_C_2.png" width="360;" /> |

使用说明

1. 点击createNoControllerTagPort按钮ETS侧调用testNapi.createWebMessagePorts("noTag")。
2. 点击createPort按钮ETS侧调用 testNapi.createWebMessagePorts(this.webTaag)。
3. 点击setHandler按钮ETS侧调用testNapi.setMessageEventHandler(this.webTag(3))。
4. 点击setHandlerThread按钮ETS侧调用 testNapi.setMessageEventHandlerThread(this.webTag)。
5. 点击SendString按钮ETS侧清空h5Log,调用 testNapi.postMessage(this.webTag)，通过消息端口将内容发送到前端页面。

### 工程目录

```
entry5/src/main/
|---cpp										// cpp文件夹
|---ets
|---|---entry5ability
|---|---|---Entry5Ability.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```


### 具体实现
* 调用ArkWeb在Native侧接口实现环境初始化、创建端口、发送接收消息等功能，并暴露给arkts侧。源码参考[hello.cpp](./entry5/src/main/cpp/hello.cpp)
* 在arkts侧通过import引入testNapi模块调用Native接口。源码参考[Index.ets](./entry5/src/main/ets/pages/Index.ets)
* H5侧消息端口交互与数据编解码功能封装在前端页面。源码参考[index.html](./entry5/src/main/resources/rawfile/index.html)

### 相关权限

无。

## 应用侧与前端页面的相互调用(C/C++)

### 介绍

1. 实现文档中提供的示例代码片段的工程化，确保示例代码与sample工程文件同源。文档链接：https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/web/arkweb-ndk-jsbridge.md 。

### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/MutualInvokeCCpp.png" width="360;" /> |

使用说明

1. 点击 runJS hello按钮调用testNapi.runJavaScript。
2. 点击test Native Development Kit method1 !按钮调用testNdkProxyObjMethod1。
3. 点击test Native Development Kit method2 !按钮调用testNdkProxyObjMethod2。

### 工程目录

```
entry6/src/main/
|---cpp										// cpp文件夹
|---ets
|---|---entry6ability
|---|---|---Entry6Ability.ets
|---|---pages
|---|---|---Index.ets						// 首页
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```


### 具体实现
* 应用侧与前端页面的相互调用(C/C++)。参考源码：[Index.ets](./entry6/src/main/ets/pages/Index.ets)、[hello.cpp](./entry6/src/main/cpp/hello.cpp)
  * 在ArkTS侧自定义一个标识webTag，并将webTag通过Node-API传至应用Native侧。
  * 在Native侧，通过函数OH_ArkWeb_GetNativeAPI先获取API结构体，调用结构体里的Native API。
  * Native侧，通过ArkWeb_ComponentAPI注册组件生命周期回调。
  * 前端页面通过registerJavaScriptProxyEx将应用侧函数注册至前端页面，注册后在下次加载或者重新加载后生效。
  * 应用侧使用runJavaScript调用前端页面函数。

### 相关权限

无。

## 依赖

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例支持API20版本SDK，SDK版本号(API Version 20 Release)。
3. 本示例需要使用DevEco Studio 版本号(6.0.0Release)及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkWeb/UseFrontendJSApp > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```