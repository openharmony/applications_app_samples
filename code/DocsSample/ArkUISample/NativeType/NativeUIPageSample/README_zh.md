# NativeUIPageSample

## 介绍

本示例展示了如何创建一个自定义绘制组件，该绘制组件能够绘制自定义矩形，同时可以自定义绘制前景和背景，并使用自定义布局容器进行布局排布。

### 效果预览


|主页|
|--------------------------------|
|!<img src="./screenshots/NativeUI.png" width="300;" />|

### 具体实现
创建了一个自定义绘制组件，该绘制组件能够绘制自定义矩形，同时可以自定义绘制前景和背景。
- 自定义绘制前景背景实现：通过ArkUI_NativeNodeAPI_1的createNode接口，传入ARKUI_NODE_CUSTOM枚举值创建自定义节点。在事件注册过程中，需将事件注册为绘制事件，通过查阅ArkUI_NodeCustomEventType枚举值获取事件类型及含义。OnDrawBehind绘制蓝白色矩形，位于最底层，OnDraw绘制浅蓝色矩形，位于中间层，OnDrawFront绘制深蓝色矩形，位于最顶层。绘制层级由低到高依次执行，最终呈现三层嵌套矩形效果。

### 工程目录
```
entry/src/main/cpp
|---ArkUIBaseNode.cpp                // 节点封装扩展类实现。
|---ArkUIBaseNode.h                  // 节点封装扩展类。
|---ArkUICustomContainerNode.cpp     // UICustomContainerNode工具类实现。
|---ArkUICustomContainerNode.h       // UICustomContainerNode工具类。
|---ArkUICustomNode.cpp              // UICustomNode工具类实现。
|---ArkUICustomNode.h                // UICustomNode工具类。
|---ArkUINode.cpp                    // UINode工具类实现。
|---ArkUINode.h                      // UINode工具类。
|---CMakeLists.txt                   // 编译脚本。
|---napi_init.cpp                    // 实现创建、设置、获取、重置组件属性。
|---NativeEntry.cpp                  // NativeEntry工具类实现。
|---NativeEntry.h                    // NativeEntry工具类。
|---NativeModule.cpp                 // NativeMoudle工具类实现。
|---NativeModule.h                   // NativeMoudle工具类。
|---types
    |---Index.d.ts                   // napi对外接口定义。
entry/src/main/ets/
|---entryability
|---pages
|   |---index.ets                    // 应用主页面
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例支持标准系统上运行, 支持设备：RK3568等。

2.本示例为Stage模型，支持API22版本SDK，版本号：6.0.2.56，镜像版本号：OpenHarmony_6.0.2.56。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NativeUIPageSample > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````