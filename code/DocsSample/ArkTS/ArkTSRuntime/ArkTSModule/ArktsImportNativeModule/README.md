# 静态方式加载Native模块

## 介绍

本示例主要演示了如何通过ArkTS适配Native模块导出的内容，并提供了以下几种支持写法：

1.直接导入。

2.间接导入。

3.动态导入。

## 相关概念

在ECMAScript模块设计中，使用import语句加载其它文件导出的内容是ECMA标准定义的语法。
为支持开发者使用该功能导入Native模块（so）导出的内容，ArkTS进行了相关适配。

## 效果预览

| 初始页面                            | 结果                                  |
|---------------------------------|-------------------------------------|
| ![add](./screenshots/index.png) | ![result](./screenshots/result.png) |

## 使用说明

1. 点击“add(2 + 3)”按钮，将调用native模块的add函数,返回调用结果“Test NAPI 2 + 3 = 5”。

2. 本示例交互页面仅展示了一种加载原生模块的方法，用户可根据需求使用本应用其它页面的调用进行替换。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── DefaultImport.ets // 直接导入中的默认导入示例页面。
    └── DynamicExport.ets // 动态导入中的间接导出示例页面。
    └── DynamicImport.ets // 动态导入中的直接导入示例页面。
    └── DynamicImportFromExport.ets // 动态导入中的间接导入示例页面。
    └── Index.ets // 直接导入中的命名空间导入使用实例。
    └── NameExport.ets // 间接导入中的具名导出示例页面。
    └── NameImport.ets // 直接导入中的具名导入示例页面。
    └── NameImportFromExport.ets // 间接导入中的具名导入示例页面。
    └── NamespaceExport.ets // 间接导入中的命名空间导出示例页面。
    └── NamespaceImport.ets // 直接导入中的命名空间导入示例页面。
    └── NamespaceImportFromExport.ets // 间接导入中的命名空间导入示例页面。
entry/src/ohosTest/
└── ets
    └── test
        └── Ability.test.ets // UI自动化用例。
```

## 具体实现

* 函数调用
  * 调用native模块中的add函数。
  * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
  
## 依赖

无。

## 相关权限

无。

## 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568。

2. 本示例支持API23版本的SDK，版本号：6.1.0.25。

3. 本示例已支持使用Build Version: 6.0.1.251, built on November 22, 2025。

4. 高等级APL特殊签名说明：无。

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTSRuntime/ArkTSModule/ArktsImportNativeModule/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```
