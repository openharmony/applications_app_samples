# ArkGuard字节码混淆开启指南、混淆原理及功能

## 介绍

本示例主要介绍了ArkGuard字节码混淆开启指南、混淆原理及功能。

## 效果预览

不涉及。

## 工程目录

```
entry/src/main/cpp/
└── types
    └── libentry
        └── Index.d.ts
entry/src/main/ets/
└── bytecodeobfuscation
    └── BytecodeObfuscation.ets
    └── BytecodeObfuscation.js
    └── BytecodeObfuscation.ts
    └── file1.ts
    └── file2.ts
    └── test.json
└── test1
    └── test2.ts
entry/
└── obfuscation-rules.txt
└── consumer-rules.txt
```

## 具体实现

* ArkGuard字节码混淆开启指南
  * 开启混淆开关，源码参考：[build-profile.json5](./entry/build-profile.json5)
  * 混淆选项配置指导，源码参考：[BytecodeObfuscation.ts](./entry/src/main/ets/bytecodeobfuscation/BytecodeObfuscation.ts)
* ArkGuard字节码混淆原理及功能
    * 混淆能力局限性，源码参考：[BytecodeObfuscation.ts](./entry/src/main/ets/bytecodeobfuscation/BytecodeObfuscation.ts)
    * 混淆选项，源码参考：[BytecodeObfuscation.ts](./entry/src/main/ets/bytecodeobfuscation/BytecodeObfuscation.ts)
    * 保留选项，源码参考：[BytecodeObfuscation.ts](./entry/src/main/ets/bytecodeobfuscation/BytecodeObfuscation.ts)

## 依赖

不涉及。

## 相关权限

不涉及。

## 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例支持API23版本的SDK，版本号：6.1.0.25；

3.  本示例已支持使用Build Version: 6.0.1.251, built on November 22, 2025；

4.  高等级APL特殊签名说明：无；

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/Toolchain/BytecodeObfuscation/ArkGuardBytecodeObfuscation/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```