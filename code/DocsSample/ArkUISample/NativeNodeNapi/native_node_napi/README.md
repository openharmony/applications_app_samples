# Native_node_napi

## 介绍

本示例展示了如何通过调用CAPI提供的相关方法来获取navigation组件等组件的相关属性和信息。

## 效果预览

| 首页 | navigation页面                                           |
| ---- | -------------------------------------------------------- |
|      | <img src='.\screenshots\page_navigation.jpeg' width=300> |

## 使用说明

1. 安装编译生成的hap包，并打开应用；
2. 进入首页，可选择不同模块页面。
3. 点击navigation选择框进入navigation组件相关的CAPI接口展示界面，通过点击不同的按钮来触发不同的事件，具体结果在log中查看；


## 工程目录

```
native_type_sample
entry/src/main/ets/
└── pages
    ├── Index.ets (获取导航页面)
    └── page_navigation.ets (获取导航页面)
entry/src/main/
├── cpp
│   ├── types
│   │   └── libentry
│   │       └── Index.d.ts (函数对应的js映射)
│   ├── CMakeLists.txt (CMake脚本)
|   ├── manager.cpp 
|   ├── manager.h
│   ├── napi_init.cpp
|   ├── .......
|   ├── NavigationContext.cpp
│   └── NavigationContext.h
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

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API20版本SDK，版本号：6.0.0.36;

3. 本示例已支持使DevEco Studio 5.1.1 Release (构建版本：5.1.1.840，构建 2025年9月20日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NativeNodeNapi/native_node_napi > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```