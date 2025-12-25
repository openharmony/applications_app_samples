# ArkUI使用NativeModule指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，帮助开发者更好的理解并合理使用ArkUI提供的通用类型接口。接口详情请参考[native_interface.h](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-interface-h.md)。

### 使用说明

在主界面，点击CreateNodeTree的按钮，查看日志。

## 效果预览

| 预览                                      | 
| -------------------------------------------- | 
<img src="./screenshots/NativeNodeInterfacePage.png" width="300;" />

### 具体实现

- 本示例通过调用CAPI提供的统一入口函数来初始化初始化C-API环境。

### 工程目录
```
entry/src/main/cpp
|---ArkUIBaseNode.h                   //节点封装扩展类
|---CMakeLists.txt                   // 编译脚本
|---napi_init.cpp                      // 实现创建、设置、获取、重置组件属性
|---NativeEntry.cpp                    // 多线程节点管理与自定义组件实现
|---NativeEntry.h                      // 核心管理类声明
|---types
    |---Index.d.ts                      // 接口导出
entry/src/main/ets/
|---entryability
|---pages
|   |---index.ets                      // 应用主页面
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例支持标准系统上运行，支持设备：RK3568等。

2.本示例为Stage模型，支持API12版本SDK，版本号：5.0.0.21，镜像版本号：OpenHarmony 5.0.0.20及以后。

3.本示例需要使用DevEco Studio版本号（DevEco Studio 5.0.0 Release）及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NativeNodeInterfaceSample > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````