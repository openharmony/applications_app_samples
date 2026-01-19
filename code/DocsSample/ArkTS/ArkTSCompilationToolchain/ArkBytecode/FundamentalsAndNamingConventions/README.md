# 字节码规范与自定义

## 介绍

方舟字节码（Ark Bytecode）是由方舟编译器编译ArkTS/TS/JS生成的，提供给方舟运行时解释执行的二进制文件。方舟字节码中的主要内容是方舟字节码指令。本文旨在介绍方舟字节码指令相关的设计，字节码文件中Method的name_off字段指向的字符串的命名规则。

## 工程目录

```
entry/src/main/ets/
└── pages
    └── Index.ets // 首页。
    └── index.ts // 词法环境和词法变量文件。
    └── module_bar.ts // 导出模块命名空间。
    └── module_foo.ts // 导出模块变量。
    └── module_index.ts // 导入模块命名空间与模块变量。
    └── test1.ts // 作用域名称。
    └── test2.ts // 重名序号。
    └── test3.ts // 原函数名。
```

## 具体实现

* ArkTS编程规范
    * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)

## 依赖

不涉及。

## 相关权限

不涉及。

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
echo code/DocsSample/ArkTS/ArkTSCompilationToolchain/ArkBytecode/FundamentalsAndNamingConventions > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```
