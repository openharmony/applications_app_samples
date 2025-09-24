# StyledStringSample

## 介绍

本示例展示了如何创建文本、设置文本样式、序列化、反序列化、转换html。

## 效果预览

| 预览                                      | 
| -------------------------------------------- | 
<img src="./screenshots/styledString.png" width="300" />

## 使用说明
1. 安装编译生成的hap包，并打开应用；
2. 查看创建好的文本以及相应的文本样式；
3. 查看log是否序列化成功；


## 工程目录

```
StyledStringNDK
entry/src/main/ets/
└── pages
    └── Index.ets (获取文本界面)
entry/src/main/
├── cpp
│   ├── types
│   │   └── libentry
│   │       └── Index.d.ts (函数对应的js映射)
│   ├── CMakeLists.txt (CMake脚本)
|   ├── manager.cpp (创建文本实现CPP文件)
|   ├── manager.h
│   └── napi_init.cpp
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

3. 本示例已支持使DevEco Studio 5.1.1 Release (构建版本：5.1.1.840，构建 2025年9月19日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/StyledStringSample > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```