# MyXComponent

#### 介绍
基于XComponent组件调用Native API来创建EGL/GLES环境，从而使用标准OpenGL ES进行图形渲染。本项目实现了两个示例：1.使用OpenGL实现2D的图形绘制和动画，2.使用OpenGL实现了在主页面绘制一个立方体，可以在当前场景中移动，并实现了光照效果

#### 效果展示

|3D效果1| 3D效果2                                       | 2D效果1                                   | 2D效果2                                 |
|--------------------------------|--------------------------------------------|----------------------------------------|--------------------------------------|
|<img src=".//screenshots/3D_1.jpg" style="zoom:25%;" /> | <img src=".//screenshots/3D_2.jpg" style="zoom:25%;" /> | <img src=".//screenshots/2D_1.jpg" style="zoom:25%;" /> | <img src=".//screenshots/2D_2.jpg" style="zoom:25%;" /> |

#### 视频效果展示
[视频效果演示](.//screenshots/video.mp4)

软件架构说明


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
	|---Algorithm.h
	|---Matrix4x4.h
	|---Matrix4x4.h
	|---Quaternion.h
	|---Quaternion.cpp
	|---Vector3.h
	|---Vector3.cpp
|---include
	|---util
		|---log.h
		|---napi_manager.h
		|---napi_util.h
		|---native_common.h
		|---types.h
	|---app_napi.h
	|---camera.h
	|---opengl_draw.h
	|---shader.h
|---shape
	|---base_shape.h
	|---cube.cpp
	|---cube.h
	|---rectangle.cpp
	|---rectangle.h				//
|---types
	|---libnativerender			
		|---nativerender.d.ts	//
|---app_napi.app				//
|---module.cpp					//
|---napi_manager.cpp			//
|---napi_util.cpp				//
|---opengl_draw.cpp				//
```

#### 具体实现

在主页面设置了两个XComponent控件，通过不同的id来区分绘制不同的图形。
在XComponent初始化完成时，OnSurfaceCreated回调里面，会自动开始图形绘制。源码参考plugin_render.cpp。
在egl_core.cpp里面GLContextInit方法会创建EglWindow和EGLSurface，然后创建上下文EGLContext。根据传递进来的XComponent的id。源码参考egl_core.cpp

---绘制2D图形：egl_core.cpp里面的DrawTransform方法。主要是绘制两个图形，一个进行旋转，一个进行缩放
---绘制3D物体：egl_core.cpp里面的DrawCube方法。绘制了两个立方体，一个在屏幕中间，另一个会围绕中间的物体进行圆周运动。并且设置运动的物体为发光源，在中间物体展示不同角度的光照效果。


#### 相关权限
不涉及


#### 依赖
不涉及


#### 约束与限制
本示例仅支持标准系统上运行，支持设备：RK3568;
本示例已适配API version 9版本SDK，版本号：3.2.10.6
本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)及以上版本才可编译运行；


#### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/XComponentStage/XComponentStage/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
