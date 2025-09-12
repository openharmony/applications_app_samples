# AccessibilityCapi

## 介绍

本示例通过使用[ArkUI指南文档](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [native_node.h](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-node-h.md)。

2. [native_type.h](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/capi-native-type-h.md)。

## 效果预览

| 预览                                      | 
| -------------------------------------------- | 
<img src="./screenshots/accessibility.jpeg" width="300" />

## 使用说明
1. 安装编译生成的hap包，并打开应用；
2. 查看创建好的嵌入式组件，文本以及相应的无障碍属性；


## 工程目录

```
AccessibilityCapi
entry/src/main/ets/
└── pages
    └── Index.ets (获取EmbeddedComponent组件和设置无障碍属性后的文本界面)
entry/src/main/
├── cpp
│   ├── types
│   │   └── libentry
│   │       └── Index.d.ts (NDK函数对应的js映射)
│   ├── CMakeLists.txt (CMake脚本)
|   ├── manager.cpp (创建文本实现CPP文件)
|   ├── manager.h
│   └── napi_init.cpp (NDK函数)
└── resources
    ├── base
    │   ├── element
    │   │   ├── color.json
    │   │   ├── float.json
    │   │   └── string.json
    │   └── media
```

## 相关权限

不涉及

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568，Phone;

2. 本示例支持API20版本SDK，版本号：6.0.0.49;
   
3. 本示例需要使用DevEco Studio 5.1.1 Release（5.1.1.840）及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/AccessibilityCapi > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```