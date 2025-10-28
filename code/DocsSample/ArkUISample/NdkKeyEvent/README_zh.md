# NdkKeyEvent

### 介绍

本示例基于[native_key_event.h](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-key-event-h.md)中的各接口进行构建，以帮助开发者更好地理解按键事件C-API的用法。

### 效果预览

| 首页                                 |
|------------------------------------|
| ![](screenshots/device/image1.jpg) |

### 使用说明

1. 在首页可以查看通过按键事件C-API接口实现监听按键事件示例。

2. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
|---cpp
|     |---types
|     |---CMakeLists.txt
|     |---container.cpp
|     |---container.h
|     |---init.cpp
|     |---manager.cpp                       // native创建与对接
|     |---manager.h                         // manager头文件
|     |---key_event_handler.cpp             // 通过按键事件CAPI接口实现相关示例代码
|     |---key_event_handler.h              
|     |---napi_init.cpp
|---ets
|   |---pages
|   |   |---Index.ets                       // 应用主页面
entry/src/ohosTest/
|---ets
|   |---index.test.ets                       // 示例代码测试代码
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.41，镜像版本号：OpenHarmony_6.0.0.41。

3.本示例需要使用DevEco Studio 5.0.5 Release (Build Version: 5.0.13.200, built on May 13, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NdkKeyEvent > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````