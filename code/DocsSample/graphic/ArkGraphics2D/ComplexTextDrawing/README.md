# 文本绘制与显示中多样式文本绘制与显示接口使用说明（ArkTS）

## 介绍

本工程主要实现了对以下指南文档中 [复杂文本绘制与显示](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/graphics/complex-text-arkts.md) 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源，以及除基本文字、排版属性之外，针对应用中不同文本的设计，开发者可能需要设置使用不同的绘制样式或能力，以凸显对应文本的独特表现或风格，此时可以结合使用多种绘制样式进行文本的渲染。

## 效果预览

| ![](screenshots/NoPlaceholderDecorationAndSonON.jpg) | ![](screenshots/ApplyPlaceholderAndSoON.jpg) | ![](screenshots/多行文本.jpg)   | ![](screenshots/多语言.jpg) |
|------------------------------------------------------|----------------------------------------------|-----------------------------|-----------------------------|

**使用方法：**

1. 该工程可以选择在模拟器和开发板上运行。
2. 点击构建，即可在生成的应用中点击对应的按钮进行图案的绘制。
3. 进入”DocsSample/graphic/ArkGraphics2D/ComplexTextDrawing/entry/src/ohosTest/ets/test/Ability.test.ets“文件，可以对本项目进行UI的自动化测试。

## 工程目录

```
ArkTSDrawing
├──entry/src/main
│  ├──ets  // ets代码区
│  │  ├──entryability
|  |  |  └──EntryAbility.ets        // 程序入口类
|  |  ├──entrybackupability
│  │  │  └──EntryBackupAbility.ets   
│  │  └──pages                      // 页面文件
│  │     └──Index.ets               // 主界面
|  ├──resources         			// 资源文件目录
```

## 具体实现

1. 利用Native XComponent来获取NativeWindow实例、获取布局/事件信息、注册事件回调并通过Drawing API实现在页面上绘制形状。
2. 通过在IDE中创建Native ArkTS 工程，在ts代码中定义对外接口为drawText，在js侧调用该接口可在页面上绘制出“1/2 1/3 1/4”阴影文字。
3. 在XComponent的OnSurfaceCreated回调中获取NativeWindow实例并初始化NativeWindow环境。调用Decoration在文本上方、下方或中间添加的装饰性线条，当前支持上划线、下划线、删除线，FontFeature用于增强文本的表现力，使其更符合设计和阅读需求，FontVariation实现文本渲染绘制时的平滑过渡，TextShadow用于提升文本的视觉吸引力或增强可读性，尤其是在色彩对比度较低的场景下。
## 相关权限

不涉及。

## 依赖

不涉及。

## 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568。
2. 本示例支持API14版本SDK，版本号：5.0.2.123。
3. 本示例已支持DevEco Studio 5.0.2 Release (构建版本：5.0.7.210，构建 2025年5月6日)编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/graphic/ArkGraphics2D/ComplexTextDrawing/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```