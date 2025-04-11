# NDKGraphicsDraw

## 介绍

本示例基于开发>图形->ArkGraphics 2D（方舟2D图形服务）-> [图形绘制与显示](https://gitee.com/openharmony/docs/tree/OpenHarmony-5.0.1-Release/zh-cn/application-dev/graphics#/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/graphics/textblock-drawing-arkts.md)中的NDK部分开发。

本示例主要功能如下：

- 演示画布的获取与绘制结果的显示，画布的类型分为直接画布与离屏画布。
- 演示画布操作及状态处理，通过对画布进行裁剪、平移等操作控制绘图结果
- 演示绘制效果，绘制经过填充、描边、着色器、滤波器等效果处理过后的图形。
- 演示图元绘制，绘制多种几何形状、绘制位图及绘制字块。

## 效果预览

| 主页                              | 画布获取                            | 绘制效果                            | 图元绘制                          |
| --------------------------------- | ----------------------------------- | ----------------------------------- | --------------------------------- |
| ![index](./screenshot/index.jpeg) | ![canvas](./screenshot/canvas.jpeg) | ![effect](./screenshot/effect.jpeg) | ![shape](./screenshot/Shape.jpeg) |


使用说明：

1. 点击主页的导航标签组件，进入对应的演示页面。演示页面包括：
   - 画布的获取与绘制结果的显示
   - 画布操作及状态处理
   - 基础绘制效果
   - 复杂绘制效果
   - 几何图形绘制
   - 图片绘制
   - 字块绘制
2. 在演示页面内点击绘制按钮，界面绘制出对应图案。
3. 点击返回按钮，退出应用。

## 工程目录

```
NDKGraphicsDraw
entry/src/main
├──cpp                           
│  ├──common
│  │  └──log_common.h (Log相关定义声明)
│  ├──plugin
│  │  ├──plugin_manager.cpp (生命周期管理类)
│  │  └──plugin_manager.h
│  ├──samples
│  │  ├──sample_graphics.cpp (图形绘制类)
│  │  └──sample_graphics.h
│  ├──CMakeLists.txt (CMake编译配置文件)
│  └──napi_init.cpp (初始化Napi接口)
├──ets
│  ├──drawing
|  |  └──pages
|  |  	├──BasicEffect.ets (基础渲染效果界面)
|  |  	├──CanvasGetResult.ets (画布的获取与绘制结果的显示界面)
|  |  	├──CanvasOperationState.ets (画布操作及状态处理界面)
|  |  	├──ComplexEffect.ets (复杂绘制效果界面)
|  |  	├──PixelMapDrawing.ets (图片绘制界面)
|  |  	├──ShapeDrawing.ets (几何形状绘制界面)
|  |  	└──TextBlockDrawing.ets (字块绘制界面)
|  ├──interface
│  │  └──XComponentContext.ts (声明Napi接口，供ts侧调用)
│  └──pages                      
│     └──Index.ets (UI主界面)
└──resources (资源文件)
entry/src/ohosTest/ets/
├── test
|   ├── Ability.test.ets (UI测试代码)
|   └── List.test.ets (测试套件列表)
└── utils
    └── Logger.ets (logger日志类)
```

## 具体实现

1. 利用Native XComponent来获取NativeWindow实例、获取布局/事件信息、注册事件回调并通过Drawing API实现在页面上绘制形状。功能主要包括演示画布获取、画布操作、绘制效果和绘制图形、图形、文字。
2. 通过在IDE中创建Native c++ 工程，在c++代码中定义对外接口为draw，在js侧调用该接口。draw通过解析传入的参数创建不同的画布类型，初始化并调用对应的具体绘图函数。
3. 在XComponent的OnSurfaceCreated回调中获取NativeWindow实例并初始化NativeWindow环境。调用OH_NativeXComponent_GetXComponentSize接口获取XComponent的宽高，并以此为输入调用Drawing相关的绘制接口在NativeWindow上绘制出图案。

## 相关权限

不涉及

## 依赖

不涉及。

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API14版本SDK，版本号：5.0.2.58；
   
3. 本示例已支持使DevEco Studio 5.0.1 Release (构建版本：5.0.5.306，构建 2024年12月6日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Drawing/NDKGraphicsDraw/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```