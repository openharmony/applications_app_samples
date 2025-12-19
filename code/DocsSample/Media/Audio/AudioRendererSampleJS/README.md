# 实现音频播放功能

## 介绍

本示例基于AudioRenderer、AudioHaptic、AVPlayer等能力，实现了音频播放、音振协同播放、音频播放流管理以及音播放量等功能，包含了功能调用接口的完整链路。

## 效果图预览

**图1**：首页

选择跳转到对应功能页面。

<img src='screenshots/index.png' width=320> 

**图2**：音振协同播放页

- 点击'使用注册源注册'按钮，即可通过文件URI来注册资源。
- 点击'使用描述符注册'按钮，即可通过文件描述符来注册资源。
- 点击'音振协同播放开始'按钮，即可开启音频播放并同步开启振动。
- 点击'音振协同播放停止'按钮，即可停止音频播放并同步停止振动。
- 点击'音振协同播放释放'按钮，即可释放实例将已注册的音频及振动资源移除注册。

  <img src='screenshots/haptic.png' width=320>

**图3**：音频播放页

- 点击'初始化'按钮，即可创建实例，设置监听事件。
- 点击'开始播放'按钮，开始音频渲染。
- 点击'暂停播放'按钮，暂停渲染。
- 点击'停止播放'按钮，停止渲染。
- 点击'释放资源'按钮，可以销毁实例，释放资源。
- 点击'获取音频流音量'按钮，可以获取指定流类型的音量信息。
- 点击'设置应用的音量'按钮，可以设置应用的音量。
- 点击'设置音频流音量'按钮，可以设置音频流音量。
- 点击'是否支持空间音频'按钮，可以查询设备是否支持空间音频渲染能力。
- 点击'查询空间音频开关状态'按钮，可以查询当前发声设备的空间音频渲染效果开关状态。
- 点击'订阅开关状态事件'按钮，可以订阅当前发声设备空间音频渲染效果的开关状态变化事件。
- 点击'取消订阅'按钮，可以取消订阅当前发声设备空间音频渲染效果的开关状态变化事件。
- 点击'查看播放的状态'按钮，可以直接查看音频播放的状态。
- 点击'获取所有流信息'按钮，可以获取所有音频播放流的信息。

  <img src='screenshots/renderer.png' width=320>

## 工程结构&模块类型

```
├───entry/src/main/ets
│   ├───pages                               
│   │   └───Index.ets                       // 首页。
│   │   └───Haptic.ets                      // 音振协同播放页。
│   │   └───Renderer.ets                    // 音频播放页。
└───entry/src/main/resources                // 资源目录。
```

## 具体实现

### 音振协同播放功能
- 源码参考：[haptic.ets](entry/src/main/ets/pages/haptic.ets)
- 使用流程：
    - 需申请`ohos.permission.VIBRATE`权限来获取振动权限保证音振协同可以正常进行。
    - 点击'使用注册源注册'按钮，调用`audioHapticManagerInstance.registerSource`，通过文件URI来注册振动资源。
    - 点击'使用描述符注册'按钮，调用`audioHapticManagerInstance.registerSourceFromFd`，通过文件描述符来注册振动资源，后续的音振协同播放都是根据该方法注册的资源进行。
    - 点击'音振协同播放开始'按钮，调用`audioHapticManagerInstance.start`，开启音频播放并同步开启振动。
    - 点击'音振协同播放停止'按钮，调用`audioHapticManagerInstance.stop`，停止音频播放并同步停止振动。
    - 点击'音振协同播放释放'按钮，调用`audioHapticManagerInstance.release`，销毁实例，释放资源。

### 音频播放功能
- 源码参考：[renderer.ets](entry/src/main/ets/pages/renderer.ets)
- 使用流程：
    - 点击'初始化'按钮，调用`audio.createAudioRenderer`，创建AudioRenderer实例。
    - 点击'开始播放'按钮，调用`audioRenderer.start`，渲染音频。
    - 点击'暂停播放'按钮，调用`audioRenderer.pause`，暂停渲染。
    - 点击'停止播放'按钮，调用`audioRenderer.stop`，停止渲染。
    - 点击'释放资源'按钮，调用`audioRenderer.release`，销毁实例，释放资源。
    - 点击'获取音频流音量'按钮，调用`audioVolumeManager.getVolumeByStream`、`audioVolumeManager.getMinVolumeByStream`、`audioVolumeManager.getMaxVolumeByStream`，获取指定流类型的音量信息，获取到的信息在日志信息栏下方打印。
    - 点击'设置应用的音量'按钮，调用`audioVolumeManager.setAppVolumePercentage`，设置应用的音量为20，音量的取值范围为[0, 100]。
    - 点击'设置音频流音量'按钮，调用`audioRenderer.setVolume`，设置音频流音量0.5，音量的取值范围为[0, 1]。
    - 点击'是否支持空间音频'按钮，调用`audioRoutingManager.getDevicesSync`，查询设备是否支持空间音频渲染能力，查询结果在日志信息栏下方打印。
    - 点击'查询空间音频开关状态'按钮，调用`audioSpatializationManager.isSpatializationEnabledForCurrentDevice`，查询当前发声设备的空间音频渲染效果开关状态，查询结果在日志信息栏下方打印。
    - 点击'订阅开关状态事件'按钮，调用`audioSpatializationManager.on`，监听当前发声设备空间音频渲染效果的开关状态变化事件，触发回调时在回调信息栏下方打印回调日志。
    - 点击'取消订阅'按钮，调用`audioSpatializationManager.off`，取消监听当前发声设备空间音频渲染效果的开关状态变化事件。
    - 点击'查看播放的状态'按钮，调用`audioRenderer.state`，获取播放流的状态，获取到的信息在日志信息栏下方打印。
    - 点击'获取所有流信息'按钮，调用`audioStreamManager.getCurrentAudioRendererInfoArray`，获取所有音频播放流的信息，获取到的信息在日志信息栏下方打印。

## 相关权限

振动权限：ohos.permission.VIBRATE

## 模块依赖

不涉及。

## 约束与限制

1.  本示例支持在标准系统上运行，支持设备：RK3568。

2.  本示例支持API version 20，版本号： 6.0.0.43。

3.  本示例已支持使Build Version: 6.0.0.43, built on August 24, 2025。

4.  高等级APL特殊签名说明：无。