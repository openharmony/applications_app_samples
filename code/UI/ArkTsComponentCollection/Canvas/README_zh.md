# 画布组件

### 介绍

<canvas\>组件可以自定义绘制图形，本示例展示了<canvas\>组件的使用方法。

### 效果预览

|               主页              |
|--------------------------------|
|![](screenshots/device/main.png) |

使用说明

1.点击“RenderingContext”按钮，跳转进入RenderingContext页面查看相关的方法属性；点击按钮可查看对应的方法属性的效果展示。

2.点击“TransformExample”按钮，跳转进入TransformExample页面查看相关的方法属性；点击按钮可查看对应的方法属性的效果展示。

3.点击“ShadowOffset”按钮，跳转进入ShadowOffset页面查看相关的方法属性；点击按钮可查看对应的方法属性的效果展示。

4.点击“Path2D”按钮，跳转进入Path2D页面查看所有相关的方法属性；点击按钮可查看对应的方法属性的效果展示。

5.点击“ImageBitmap”按钮，跳转进入ImageBitmap页面查看图片效果展示。

6.点击“CanvasGrident”按钮，跳转进入CanvasGrident页面可查看两种渐变方法的效果展示。

### 工程目录
```
entry/src/main/ets/MainAbility
|---app.ets
|---pages
|   |---BitmapExample.ets                         // ImageBitmap页面,图片效果展示
|   |---GradientExample.ets                       // CanvasGrident页面, 展示两种渐变方法的效果
|   |---Index.ets                                 // 首页
|   |---PathExample.ets                           // Path2D页面，方法属性的效果展示
|   |---RenderingContext.ets                      // RenderingContext页面，方法属性的效果展示
|   |---RenderingContext1.ets                     // RenderingContext1页面，方法属性的效果展示
|   |---RenderingContext2.ets                     // RenderingContext2页面，方法属性的效果展示
|   |---ShadowOffsetExample.ets                   // ShadowOffset页面，方法属性的效果展示
|   |---TransformExample.ets                      // TransformExample页面，方法属性的效果展示
```

### 具体实现

* 所有模块用到接口：[@ohos.router](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-router.md)

* RenderingContext模块，提供了绘制圆弧(arc)，绘制描边文字(strokeText)，绘制一条路径(closePath)，绘制曲线(quadraticCurveTo)，绘制基线(textBaseline)方法属性

* RenderingContext1模块，提供了颜色设置(strokeStyle)，中线端点(lineCap)，透明度(globalAlpha)，文字水平对齐(textAlign)，创建圆形边角(lineJoin)，最大斜接长度(miterLimit)，合成操作(globalCompositeOperation)方法属性

* RenderingContext2模块，提供了绘制介于两条切线之间的弧(arcTo)，绘制三次贝塞尔曲线(bezierCurveTo)，绘制椭圆(ellipse)，创建矩形(rect)，在指定的方向内重复指定的元素(createPattern)，绘制虚线(lineDashOffset，setLineDash)，画布缩放(scale)方法属性

* TransformExample模块，提供了画布平移(translate)，画布变换(transform)，变换矩阵(setTransform)，图形旋转(rotate)方法属性

* ShadowOffset模块，提供了设置或返回阴影与形状的垂直距离(shadowOffsetY)，设置或返回阴影与形状的水平距离(shadowOffsetX)，设置或返回阴影的模糊级数(shadowBlur)方法属性

* Path2D模块，提供了绘制圆弧(arc)，曲线(quadraticCurveTo)，绘制三次贝塞尔曲线(bezierCurveTo)，绘制介于两条切线之间的弧(arcTo)，绘制椭圆(ellipse)，创建矩形(rect)，绘制一条路径(closePath)，添加路径(addPath)的平面画图属性

* BitmapExample模块，提供了图片效果展示的方法

* CanvasGrident模块，提供了创建(圆形)梯度渐变(createRadialGradient)，创建线条渐变(createLinearGradient)方法

#### 相关概念

Canvas：提供画布组件，用于自定义绘制图形。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统运行。

2.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400 构建 2023年4月7日)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo /code/UI/ArkTsComponentClollection/Canvas > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```