# ArkTS GC垃圾回收

## 介绍

本示例为ArkTS运行时GC（Garbage Collection，垃圾回收）文档的代码同源示例，对应文档：[GC垃圾回收](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/gc-introduction.md)。

主要包含以下与文档同源的代码示例：

1.引用计数循环引用示例：演示引用计数算法下对象相互持有形成的循环引用，导致内存无法回收的问题。

2.ArkTools.hintGC()使用示例：演示开发者通过ArkTS接口`ArkTools.hintGC()`提示系统进行GC的调用方式。

## 效果预览

| HintGC示例页                       | HintGC示例执行成功页 |
|-----------------------------------|-----------------------------------|
| ![HintGC](./screenshots/HintGC.jpeg)  | ![HintGCSuccess](./screenshots/Success.jpeg)  |

## 使用说明

1. 运行Index主界面。

2. 页面显示"Hello World"文本和"触发HintGC"按钮，点击"触发HintGC"按钮，调用`ArkTools.hintGC()`提示系统进行垃圾回收，页面文本变为"Success"。

3. 运行测试用例HintGCTest.test.ets文件对页面代码进行测试可以全部通过。

## 工程目录

```
├───entry/src/main/ets
│   ├───pages
│   │   └───Index.ets                                       // ArkTools.hintGC() 使用示例页。
│   └───ReferenceCounting.ts                                  // 引用计数循环引用示例（与文档代码同源）。
├───entry/src/main/resources                                 // 资源目录。
└───entry/src/ohosTest/ets/test
    ├───Ability.test.ets                                     // 基础测试用例。
    ├───HintGCTest.test.ets                                  // HintGC功能UI测试用例。
    └───List.test.ets                                        // 测试套件入口。
```

## 具体实现

* ArkTools.hintGC()使用示例
  * 源码参考：[Index.ets](./entry/src/main/ets/pages/Index.ets)
  * 实现说明：
    * 声明`ArkTools`类及静态方法`hintGC()`接口。
    * 页面通过`@State`装饰器管理`message`状态变量，初始值为"Hello World"。
    * 点击"触发HintGC"按钮时，调用`ArkTools.hintGC()`提示系统进行垃圾回收，并将`message`状态更新为"Success"，页面文本随之刷新。

## 依赖

不涉及。

## 相关权限

不涉及。

## 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2.  本示例为Stage模型，支持API24及以上的版本SDK。

## 下载

如需单独下载本工程，执行如下命令：

```git
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTSRuntime/ArkTSGC > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
