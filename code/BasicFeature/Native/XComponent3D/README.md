# XComponent3D

#### 介绍
基于XComponent组件调用Native API来创建EGL/GLES环境，从而使用标准OpenGL ES进行图形渲染。本项目实现了两个示例：

1. 使用OpenGL实现2D的图形绘制和动画；

2. 使用OpenGL实现了在主页面绘制两个立方体，光源可以在当前场景中移动，并实现了光照效果。

#### 效果展示

| 3D效果1                                                   | 3D效果2                                                   | 2D效果1                                                   | 2D效果2                                                   |
|---------------------------------------------------------|---------------------------------------------------------|---------------------------------------------------------|---------------------------------------------------------|
| <img src=".//screenshots/3D_1.jpg" style="zoom:25%;" /> | <img src=".//screenshots/3D_2.jpg" style="zoom:25%;" /> | <img src=".//screenshots/2D_1.jpg" style="zoom:25%;" /> | <img src=".//screenshots/2D_2.jpg" style="zoom:25%;" /> |


#### 使用说明

在主页面，默认展示的是3D图形绘制效果，通过点击tab可以切换到第二个2D绘制效果

#### 工程目录
```
entry/src/main/ets/
|---entryability
|	|	|---EntryAbility.ts
|---pages
|	|---Index.ets				//首页
entry/src/main/cpp/
|---algorithm
	|---Algorithm.h 			// 实现了Perspective，LookAt。
	|---Matrix4x4.h 			// 4*4的矩阵运算，支持旋转，位移，缩放，矩阵的乘法
	|---Matrix4x4.cpp
	|---Quaternion.h 			// 四元素，用于旋转
	|---Quaternion.cpp
	|---Vector3.h 				// 三维向量运算
	|---Vector3.cpp
|---include
	|---util
		|---log.h 				// 日志工具类
		|---napi_manager.h		// 负责管理注册进来的多个XComponent控件
		|---napi_util.h			// 工具类
		|---native_common.h		// napi函数注册入口
		|---types.h				// 常量类
	|---app_napi.h				// 实现XComponent的生命周期函数，注册napi绘制接口
	|---camera.h				// 相机类
	|---opengl_draw.h			// 3D类绘制类，用于绘制立方体或者长方体
	|---shader.h				// shader编译类
|---shape
	|---base_shape.h			// 形状绘制基类
	|---cube.cpp
	|---cube.h					// 立方体绘制类，继承base_shape
	|---rectangle.cpp
	|---rectangle.h				// 长方体绘制类，继承base_shape
|---types
	|---libnativerender			
		|---nativerender.d.ts	// 对外接口，用于界面进行调用
|---app_napi.app				
|---module.cpp					
|---napi_manager.cpp			
|---napi_util.cpp				
|---opengl_draw.cpp				
```

#### 具体实现

在主页面显示了一个XComponent控件，默认显示立方体。通过用户点击，触发ChangeShape事件，opengl_draw收到事件，完成绘制内容变更。首页启动时，会触发一个定时器，每40ms触发一次，当opengl_draw收到事件时，进行动画更新。

在XComponent初始化完成时，OnSurfaceCreated回调里面，会自动开始图形绘制。源码参考[opengl_draw.cpp](.//entry/src/main/cpp/opengl_draw.cpp) 。在opengl_draw.cpp里面Init方法会创建EglWindow和EGLSurface，然后创建上下文EGLContext， 完成baseShape的初始化，默认使用Cube进行初始化。

---绘制2D图形：rectangle.cpp的Init方法，完成Shader的初始化；   Update方法主要是绘制两个图形，一个进行旋转，一个进行缩放
---绘制3D物体：cube.cpp的Init方法，完成Shader的初始化，相机的初始化。 Update方法绘制了两个立方体，一个在屏幕中间，另一个会围绕中间的物体进行圆周运动。并且设置运动的物体为发光源，在中间物体展示不同角度的光照效果。


#### 相关权限
不涉及


#### 依赖
不涉及


#### 约束与限制
本示例仅支持标准系统上运行，支持设备：RK3568;

本示例已适配API version 10版本SDK，版本号：4.0.10.13

本示例需要使用Build Version: 4.0.0.600 (Build Version: 4.0.0.600, built on October 17, 2023)及以上版本才可编译运行；


#### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Native/XComponent3D > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
