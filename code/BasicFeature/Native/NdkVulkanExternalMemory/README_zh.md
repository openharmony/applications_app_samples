# 渲染视频数据

## 项目简介
本示例适用于视频解码后的视频画面直通到Vulkan环境中渲染送显。本示例帮助开发者实现自定义播放器开发，了解视频解码到渲染的全流程。


## 效果预览
如下图所示, 打开应用, 可以点击'播放'按钮会将内置的`sample.mp4`绘制一个上方的XComponent组件上。

![image](screenshots/device/sample.png)


## 使用说明
点击播放即可渲染播放视频。

## 工程目录

```
├───entry/src/main/cpp
│   ├───capbilities
│   │   ├───include
│   │   │   ├───SampleInfo.h                // 视频样本
│   │   │   ├───SampleCallback.h            // 视频回调
│   │   │   ├───Demuxer.h                   // 媒体解析
│   │   │   └───VideoDecoder.h              // 视频解码
│   │   └───src
│   │       ├───SampleCallback.cpp          // 视频回调
│   │       ├───Demuxer.cpp                 // 媒体解析
│   │       └───VideoDecoder.cpp            // 视频解码
│   ├───player
│   │   ├───include
│   │   │   └───Player.h                    // 视频播放
│   │   ├───src
│   │   │   └───Player.cpp                  // 视频播放
│   └───render
│       ├───include
│       │   ├───PluginManager.h             // XComponent管理
│       │   ├───PluginRender.h              // 渲染管理
│       │   ├───VulkanRender.h              // Vulkan渲染上下文
│       │   └───VulkanRenderThread.h        // Vulkan渲染线程
│       └───src
│           ├───PluginManager.cpp           // XComponent管理
│           ├───PluginRender.cpp            // 渲染管理
│           ├───VulkanRender.cpp            // Vulkan渲染上下文
│           └───VulkanRenderThread.cpp      // Vulkan渲染线程
├───entry/src/main/ets
│   ├───entryability
│   │   └-──EntryAbility.ets                // 主Ability的生命周期回调内容
│   ├───entrybackupability
│   │   └───EntryBackupAbility.ets          // Ability的生命周期回调内容
│   └───pages
│       ├───Index.ets                       // 首页
└───entry/src/main/resources                // 资源目录          
```

## 具体实现
### 基于Vulkan渲染视频
1. 创建渲染子线程，在启动子线程时，加载Vulkan的动态链接库。
2. 创建NativeImage对象，并根据NativeImage获取NativeWindow对象。
3. 在XComponent创建时，通过回调函数OnSurfaceCreatedCB获取对应的NativeWindow对象，Vulkan通过XComponent的NativeWindow对象创建Surface。
4. 实现编解码器的基本功能，包括解封装器、解码器等。
5. 实现播放功能，启动输入子线程、输出子线程。
6. 在解码输入子线程中，通过解封装器读取视频数据，并提交给解码器。
7. 在解码输出子线程中，将解码后的数据提交给输出Surface，即NativeImage的NativeWindow对象。
8. 在NativeImage有可用数据后，通过OH_NativeImage_AcquireNativeWindowBuffer()获取视频数据，并通过OH_NativeBuffer_FromNativeWindowBuffer()转化为NativeBuffer的类型。
9. Vulkan获取到NativeBuffer后，将格式转化为RGBA后进行渲染显示。

## 相关权限

不涉及

### 依赖
本示例不依赖其他sample。

### 约束与限制
1. 本示例要求设备底层驱动已实现[Vulkan API接口](https://gitee.com/openharmony/docs/tree/master/zh-cn/application-dev/reference/native-lib), rk开发板目前不支持(需厂商驱动实现)。
2. 本示例基于OpenHarmony API 12 SDK(5.0.0.71)。
   1. 新建一个Native C++工程;
   2. 将本工程AppScope/resources/rawfile目录拷贝至新工程AppScope/resources目录下;
   3. 删除新工程entry/src目录, 将本工程entry目录下所有文件拷贝至新工程的entry目录下。
3. 本示例需要使用DevEco Studio版本号(5.0 Release)及以上版本才可编译运行。


### 下载
如需单独下载本工程,执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Native/NdkVulkanExternalMemory/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```