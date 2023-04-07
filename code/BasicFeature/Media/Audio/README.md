# 音频管理器

### 介绍

本示例使用[audio](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-audio.md)的相关接口实现发声设备的查询和选择功能

相关概念：

AudioRoutingManager：音频路由管理器，在使用AudioRoutingManager的接口前，需要使用getRoutingManager获取AudioRoutingManager实例。主要用于查询音频相关的设备，监听设备上下线，以及查询发声设备与选择发声设备。

AudioRenderer：提供了渲染音频文件和控制播放的接口。

使用说明：

1.启动应用，点击首页的**音频管理**，进入音频管理界面。

2.点击**音频路由管理**，进入路由管理界面。

3.点击**首选输出设备**，进入首选输出设备界面。

4.首先会查询到当前机器上的所有音频输出设备，在中控台上显示，并会同步到输出设备的下拉框中

5.根据渲染信息，点击**查询发声设备**，可以中控台会显示当前的发声设备，再点击**播放音频数据**，可以听到声音是从哪个设备中发出来。

6.选择下拉框中的输出设备，点击**选择发声设备**，再点击**播放音频数据**，可以听到声音是从哪个设备中发出来。

### 效果预览

|首页|音频管理|
|--------------------------------|--------------------------------|
|![main](screenshots/device/index.jpeg)| ![audiomanager](screenshots/device/audiomanager.jpeg)|

|路由管理|发声设备查询与选择|
|--------------------------------|--------------------------------|
|![routingmanager](screenshots/device/routingmanager.jpeg)| ![preferoutputdevice](screenshots/device/preferoutputdevice.jpeg)|

### 相关权限

权限一：在本设备上允许应用访问通知策略 [ohos.permission.ACCESS_NOTIFICATION_POLICY](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

权限二：允许应用进行全局麦克风静音等操作 [ohos.permission.MANAGE_AUDIO_CONFIG](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

权限三：用户授权，使用麦克风 [ohos.permission.MICROPHONE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)

### 依赖

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例已适配API10版本SDK，版本号：4.0.5.1。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100, built on November 3, 2022)才可编译运行。

4.本示例需要使用@ohos.process系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md)。



