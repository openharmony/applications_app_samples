# NativeDialogSample

## 介绍

本示例展示了如何创建自定义弹窗，设置自定义弹窗的背景颜色、圆角半径、对齐方式、边框颜色、边框样式等功能。

## 效果预览

| 首页                                              | CustomDialogController_CAPI页面                                  |OpenCustomDialog_CAPI页面                                              |
| ----------------------------------------------------- |--------------------------------------------------------------| ------------------------------------------------------- |
| <img src="./screenshots/nativeDialog.png" width="300"/> | <img src="./screenshots/CustomDialogController.png" width="300"/> | <img src="./screenshots/OpenCustomDialog.png" width="300"/> |

## 使用说明

1. 安装编译生成的hap包，并打开应用；
2. 首页面会出现CustomDialogController_CAPI对接示例按钮，点击此按钮进入CustomDialogController_CAPI对接示例界面；
3. 首页面会出现OpenCustomDialog_CAPI对接示例按钮，点击此按钮进入OpenCustomDialog_CAPI对接示例界面；
4. 首页面会出现关闭应用按钮，点击此按钮关闭应用；

## 工程目录

```
native_type_sample
entry/src/main/ets/
└── pages
    ├── Index.ets (获取导航页面)
    ├── Index_API.ets (CustomDialogController_CAPI对接示例界面)
    └── Index_func.ets (OpenCustomDialog_CAPI对接示例界面)
entry/src/main/
├── cpp
│   ├── types
│   │   └── libentry
│   │       └── Index.d.ts (函数对应的js映射)
│   ├── common.h
│   ├── CMakeLists.txt (CMake脚本)
|   ├── customdialogexample.cpp 
|   ├── customdialogexample.h
│   ├── napi_init.cpp
│   └── utils.h
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

1. 本示例支持标准系统上运行，支持设备：RK3568等;

2. 本示例支持API20版本SDK，版本号：6.0.0.36;

3. 本示例已支持使DevEco Studio 5.1.1 Release (构建版本：5.1.1.840，构建 2025年9月20日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NativeDialogSample > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
