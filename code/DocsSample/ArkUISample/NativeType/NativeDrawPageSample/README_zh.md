# 自定义绘制示例

### 介绍

本示例展示了如何使用 ArkUI 的 Native API 实现自定义绘制功能。

具体实现请参考[自定义绘制](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-user-defined-draw.md)。

接口详情请参考[native_node.h](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-node-h.md)。

### 效果预览


|主页|
|--------------------------------|
|!<img src="./screenshots/DrawPage.png" width="300;" />|

### 具体实现

- 自定义绘制实现：自定义节点的创建，通过ArkUI_NativeNodeAPI_1的create接口，传入ARKUI_NODE_CUSTOM创建自定义节点。在事件注册过程中，需将事件注册为绘制事件，通过查阅ArkUI_NodeCustomEventType枚举值获取事件类型及含义。 创建自定义节点：通过ArkUI_NativeNodeAPI_1的create接口，传入ARKUI_NODE_CUSTOM创建自定义节点。在事件注册时，将自定义节点、事件类型、事件ID和UserData作为参数传入。在回调函数中，通过获取自定义事件的事件类型、事件ID和UserData来执行不同的逻辑。

### 工程目录

```
entry/src/main/cpp
|---CMakeLists.txt                   // 编译脚本
|---napi_init.cpp                    // NAPI 接口注册
|---NativeEntry.cpp                  // 绘制节点创建实现
|---Drawing.h                        // 绘制逻辑实现
entry/src/main/ets/
|---entryability
|   |---EntryAbility.ets             // 应用入口
|---pages
|   |---Index.ets                    // 主页面
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568 等。

2. 本示例为 Stage 模型，支持 API22 版本 SDK，版本号：6.0.2.56，镜像版本号：OpenHarmony_6.0.2.56。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NativeType/NativeDrawPageSample > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````
