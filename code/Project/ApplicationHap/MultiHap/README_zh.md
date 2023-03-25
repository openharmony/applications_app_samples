# 多HAP

### 介绍

本示例展示多HAP开发，简单介绍了多HAP的使用场景，应用包含了一个entry HAP和两个feature HAP，两个feature HAP分别提供了音频和视频播放组件，entry中使用了音频和视频播放组件。

使用说明：

1.第一步：安装应用，点击桌面MultiHap图标，进入应用

2.第二步：点击audio，进入audio播放页面，点击PlayAudio按钮，播放音频

3.第三步：点击video，进入video播放页面，可点击播放按钮播放视频

### 效果预览

![](screenshots/device/home.jpg)
![](screenshots/device/audio.jpg)
![](screenshots/device/video.jpg)

### 相关概念

entry：应用的主模块，一个应用中，只有一个entry类型的HAP，一般实现应用的入口界面、入口图标、主特性功能等

feature：应用的特性模块，一个应用中可以包含一个或者多个feature类型的HAP，也可以不含

多HAP：一个应用工程中存在一个entry HAP和多个feature HAP

### 相关权限

不涉及。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例已适配API10版本SDK，版本号：4.0.5.1；

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

