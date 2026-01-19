# 在build-profile.json5中配置arkOptions

## 介绍

arkOptions主要提供ArkTS编译相关配置。当前文档介绍以下配置项：types配置类型，maxFlowDepth配置用于控制流的最大栈深度等。更多配置项请参考build-profile.json5。

## 效果预览

| 初始页面                           |
|--------------------------------|
| ![Index](./screenshots/ag.png) |

## 使用说明

1. 点击“测试特定字段”按钮，将创建从依赖中引入的Chai.Message对象、Mocha.HookFunction对象，以及创建从global.d.ts中引入的Global.ObjectType对象。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── global.d.ts // 导出命名空间代码。
    └── Index.ets // 主页面。
entry/src/ohosTest/
└── ets
    └── test
        └── Ability.test.ets // UI自动化用例。
```

## 具体实现

* 函数调用
    * 创建从依赖中引入的Chai.Message对象，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 创建从依赖中引入的Mocha.HookFunction对象，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 创建global.d.ts中引入的Global.ObjectType对象，源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)

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
echo code/DocsSample/ArkTS/Toolchain/Configuring/ArkoptionsGuide/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```

## 说明

此工程依赖外部库@types/chai及@types/mocha库，编译此工程前需手动安装上述库，安装过程如下：
1.在工程根目录下执行如下指令：
```
npm install --save-dev @types/chai@latest @types/mocha@latest
npm install -g @types/chai@latest @types/mocha@latest
```
2.查看安装库的版本：
```
npm view @types/mocha version
npm view @types/chai version
```
3.确定库安装版本正确即可通过IDF编译运行。