# ArkTS语法适配背景

## 介绍

ArkTS在保留TypeScript（简称TS）基本语法风格的基础上，进一步通过规范强化了静态检查和分析，使得开发者在程序开发阶段能够检测出更多错误，提升程序的稳定性和运行性能。本文将详细解释为什么建议将TS代码适配为ArkTS代码。

## 效果预览

| 初始页面                            |
|---------------------------------|
| ![Index](./screenshots/amb.png) |

## 使用说明

1. 点击“测试类属性”按钮，将创建当前文件中定义的Person类对象并调用getName函数，返回结果并在页面上显示结果“len: 0”。

2. 点击“测试类属性不确定类型”按钮，将创建当前文件中定义的Person1类对象并调用getName函数，返回结果并在页面上显示结果“len: undefined”。

3. 点击“测试程序性能”按钮，将调用当前文件中定义的notify函数，输出日志“Dear Jack, a message for you: You look great today”。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── bar.ets // 导入对象示例代码。
    └── foo.ets // 导入对象示例代码。
    └── Index.ets // 主页面。
entry/src/ohosTest/
└── ets
    └── test
        └── Ability.test.ets // UI自动化用例。
```

## 具体实现

* 函数调用
    * 调用当前文件中定义的Person类中getName函数，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 调用当前文件中定义的Person1类中getName函数，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 调用当前文件中定义的notify函数，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)

## 依赖

无。

## 相关权限

无。

## 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例支持API20版本SDK，版本号： 6.0.0.43；

3.  本示例已支持使Build Version: 6.0.0.43, built on August 24, 2025；

4.  高等级APL特殊签名说明：无；

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/Start/LearningArkTS/ArkTSMigration/MigrationBackground/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```