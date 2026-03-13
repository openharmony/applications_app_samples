# ArkGuard混淆常见问题

## 介绍

如何排查功能异常，典型报错案例及解决方案，及应用运行后无crash信息，但功能异常的情况。

## 效果预览

| 初始页面                            |
|---------------------------------|
| ![Index](./screenshots/Index.png) |

## 使用说明

1. 点击“测试对象字节码混淆”按钮，将创建从@kit.AbilityKit模块引入的Want类对象，在页面上用字符串形式显示该对象的内容。

2. 点击“测试属性字节码混淆”按钮，将创建从file1.ts引入的MyInfo类对象，在页面上用字符串形式显示该对象的内容。

3. 点击“测试外源函数”按钮，将调用异步函数loadAndUseAdd，动态引入utils.ts中的add函数并调用，返回结果并在页面上显示。

4. 点击“测试外源命名空间”按钮，将调用从export.ts中引入的NS命名空间中的foo函数。

5. 点击“测试Napi”按钮，将调用从Native模块引入的addNum函数，返回结果并在页面上显示。

6. 点击“测试Hsp”按钮，将调用从sharelibrary模块引入的addNum函数，返回结果并在页面上显示。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── ExportNs.ts // 导出命名空间示例页面。
    └── FileInside.ts // 导出接口示例页面。
    └── FileOutside.ts // 导出复合接口示例页面。
    └── Index.ets // 直接导入命名空间及接口使用实例。
    └── ExportUtils.ts // 导出函数示例页面。
entry/src/ohosTest/
└── ets
    └── test
        └── Ability.test.ets // UI自动化用例。
```

## 具体实现

* 函数调用
    * 调用SDK中Want对象，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 调用从./ExportUtils.ts动态导入的add函数，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 调用从./ExportNs.ts导入的命名空间方法，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 调用从./FileInside.ts导入的自定义类型接口，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 调用从libentry.so导入的C++实现的加法函数，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 调用从sharedlibrary共享库导入的加法函数，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)

## 依赖

无。

## 相关权限

无。

## 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568。

2.  本示例支持API23版本的SDK，版本号：6.1.0.25。

3.  本示例已支持使用Build Version: 6.0.1.251, built on November 22, 2025。  

4.  高等级APL特殊签名说明：无。

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/Toolchain/CodeObfuscation/CodeObfuscationIssues/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```
