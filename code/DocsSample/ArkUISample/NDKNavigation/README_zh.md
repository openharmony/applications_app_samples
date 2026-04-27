# NDK 使用页面查询接口示例

## 介绍

本示例通过使用ArkUI指南文档(https://gitcode.com/openharmony)中各种场景的开发示例，帮助开发者更好的理解页面信息查询的使用场景。

1. 使用页面查询接口示例

本示例展示了Navigation以及router的查询接口的使用示例。该工程中的使用接口的详细描述见[native_node_napi.h](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-node-napi-h.md)。

## 效果预览

<img src='./screenshots/queryNavigationInfo.jpg' width=300/>

## 使用说明

1. 安装编译生成的hap包，并打开应用；
2. 点击进入Button，即可进入Navigation信息查询相关功能页面。
3. 点击pageOne按钮，Button颜色为粉色
4. 点击push pageTwo按钮，再次点击pageOne按钮，Button颜色变为黑色。
5. 返回首页，点击进入Text，即可进入查询Page相关信息。

### 工程目录

 ``` text
  entry/src/main
  +--- cpp
  |   ├── CMakeLists.txt
  |   ├── EntryModule.cpp
  |   ├── EntryModule.h
  |   ├── napi_init.cpp
  |   ├── QueryNavigation.h
  |   └── types
  |       └── libentry
  |           ├── Index.d.ts
  |           └── oh-package.json5
  ├── ets
  |   ├── entryability
  |   |   └── EntryAbility.ets
  |   ├── entrybackupability
  |   |   └── EntryBackupAbility.ets
  |   └── pages
  |       └── Index.ets  
  ```

### 具体实现
  
  1. 通过TS页面传入对应的页面跳转参数，页面名称等信息。

  2. 通过传入的页面，创建对应的页面组件，以及设置组件样式等。

### 相关权限

  不涉及。

### 依赖
  
  不涉及。

### 约束与限制

  1.本示例仅支持标准系统上运行, 支持设备：RK3568。

  2.本示例为Stage模型，支持API20版本full-SDK，版本号：6.1.0.36，镜像版本号：OpenHarmony_6.0.0 Release。

  3.本示例需要使用DevEco Studio 6.0.2 Release (Build Version: 6.0.2.642, built on March 5, 2026)及以上版本才可编译运行。

### 下载

  如需单独下载本工程，执行如下命令：

  ```
  git init
  git config core.sparsecheckout true
  echo code/DocsSample/ArkUISample/NdkSwiperSample > .git/info/sparse-checkout
  git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
  git pull origin master
  ```