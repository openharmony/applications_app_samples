# 音频设备路由管理功能示例

## 介绍

本示例基于AudioRender能力，实现了查询和监听音频输入设备、查询和监听音频输出设备、实现音频输入设备路由切换、实现音频输出设备路由切换、响应输出设备变更时合理暂停等功能，包含了功能调用接口的完整链路。

## 效果图预览

**图1**：首页

选择跳转到对应功能页面。

<img src='screenShots/Routing_Index.png' width=320>


**图2**：查询和监听音频输入设备页

点击'获取输入设备列表'按钮，即可进行设备连接状态监听、获取当前所有输入设备信息以及注销设备连接状态监听操作。获取到的输入设备信息在日志信息下方打印。

  <img src='screenShots/FindAndListenAudioInputDevice.png' width=320>

**图3**：查询和监听音频输出设备页

- 点击'获取输出设备列表'按钮，即可进行设备连接状态监听、获取当前所有输出设备信息以及注销设备连接状态监听等操作。获取到的输出设备信息在日志信息下方打印。
- 点击'获取优先输出设备'按钮，即可进行高优先级输出设备变化监听、获取当前最高优先级输出设备以及注销高优先级输出设备变化监听操作。获取到的最高优先级输出设备信息在日志信息下方打印。

  <img src='screenShots/FindAndListenAudioOutputDevice.png' width=320>

**图4**：实现音频输出设备路由切换页

- 点击'设置蓝牙/近场优选低时延'按钮，即可在蓝牙或星闪设备连接时优先使用其作为输入设备进行录制。
- 点击'获取并选择输入设备'按钮，即可设置当前输入设备。实际设置的输入设备取决于外设连接情况。
- 点击'查询已选输入设备'按钮，即可查询选择输入设备是否成功。获取到的信息在日志信息下方打印。
- 点击'清空已选输入设备'按钮，即可将输入设备设置回默认设备。

  <img src='screenShots/InputDeviceRoutingSwitching.png' width=320>

**图5**：查询和监听音频输入设备页

- 点击'设置为扬声器'按钮，即可设置当前输出设备为扬声器。
- 点击'设置为默认输出'按钮，即可设置当前输出设备为默认输出设备。
- 点击'获取当前默认输出'按钮，即可查询当前输出设备信息。获取到的信息在日志信息下方打印。

  <img src='screenShots/ListenDeviceByAudioSession.png' width=320>

**图6**：查询和监听音频输入设备页

- 点击'创建音频播放实例'按钮，会进行音频流输出设备变化及原因监听、创建播放控制实例以及初始化播放流等动作。
- 点击'设置为本机扬声器'按钮，即可设置默认输出设备为本机扬声器。
- 点击'设置为系统默认设备'按钮，即可设置默认输出设备为系统默认设备。

  <img src='screenShots/OutputDeviceChangePause.png' width=320>

## 工程结构&模块类型

```
├───entry/src/main/ets
│   ├───pages                               
│   │   └───Index.ets                                        // 首页。
│   │   └───FindAndListenAudioInputDevice.ets                // 查询和监听音频输入设备页。
│   │   └───FindAndListenAudioOutputDevice.ets               // 查询和监听音频输出设备页面。
│   │   └───InputDeviceRoutingSwitching.ets                  // 实现音频输入设备路由切换页面。
│   │   └───ListenDeviceByAudioSession.ets                   // 通过AudioSession查询和监听音频输出设备页。
│   │   └───OutputDeviceChangePause.ets                      // 响应输出设备变更时合理暂停和实现音频输出设备路由切换页。
└───entry/src/main/resources                                 // 资源目录。         
```
### 具体实现

### 查询和监听音频输入设备
- 源码参考：[FindAndListenAudioInputDevice.ets](entry/src/main/ets/pages/FindAndListenAudioInputDevice.ets)
- 使用流程：
  点击'获取输出设备列表'按钮，具体处理流程如下。
  - 调用`audioRoutingManager.on`监听设备连接状态，对设备接入与断开事件进行响应。
  - 调用`audioRoutingManager.getDevices`获取当前所有输入设备信息。
  - 调用`audioRoutingManager.off`注销设备连接状态监听。

### 查询和监听音频输出设备 
- 查询和监听音频输出设备：[FindAndListenAudioOutputDevice.ets](entry/src/main/ets/pages/FindAndListenAudioOutputDevice.ets)
- 使用流程：
  - 点击'获取输出设备列表'按钮，先调用`audioRoutingManager.on`监听设备连接状态，对设备接入与断开事件进行响应。然后调用`audioRoutingManager.getDevices`获取当前所有输出设备信息。最后调用`audioRoutingManager.off`注销设备连接状态监听。
  - 点击'获取优先输出设备'按钮，先配置`audio.AudioRendererInfo`信息，包括流类型与渲染器标志。接着调用`audioRoutingManager.on`监听高优先级输出设备连接状态，对设备接入与断开事件进行响应。然后调用`audioRoutingManager.getPreferOutputDeviceForRendererInfo`获取当前最高优先级的输出设备。最后调用`audioRoutingManager.off`注销高优先级输出设备连接状态监听。

### 通过AudioSession查询和监听输出设备
- 源码参考：[ListenDeviceByAudioSession.ets](entry/src/main/ets/pages/ListenDeviceByAudioSession.ets)
- 使用流程：
  - 点击'设置为扬声器'按钮，调用`audioRenderer.setDefaultOutputDevice`默认输出设备为本机扬声器。
  - 点击'设置为默认输出'按钮，调用`audioRenderer.setDefaultOutputDevice`设置默认输出设备为系统默认输出设备，即取消应用设置的默认设备，交由系统选择设备。
  - 点击'获取当前默认输出'按钮，调用`audioSessionManager.getDefaultOutputDevice`获取默认输出设备类型，获取到的信息在日志信息栏下方打印。


### 实现音频输入设备路由切换*
- 源码参考：[InputDeviceRoutingSwitching.ets](entry/src/main/ets/pages/InputDeviceRoutingSwitching.ets)
- 使用流程：
  - 点击'设置蓝牙/近场优选低时延'按钮，调用`audioSessionManager.setBluetoothAndNearlinkPreferredRecordCategory`设置蓝牙/星闪设备连接时为优先输入设备。
  - 点击'获取并选择输入设备'按钮，首先调用`audioSessionManager.on`对输入设备连接状态变化以及输入设备变更两个事件进行监听。接着调用`audioSessionManager.getAvailableDevices`获取当前可选的音频输入设备列表，最后调用`audioSessionManager.selectMediaInputDevice`将获取到的输入设备列表中的第一个设置为输入设备。
  - 点击'查询已选输入设备'按钮，调用`audioSessionManager.getSelectedMediaInputDevice`获取已选输入设备信息，获取到的信息在日志信息栏下方打印。
  - 点击'清空已选输入设备'按钮，调用`audioSessionManager.clearSelectedMediaInputDevice`清空通过`selectMediaInputDevice`选择的输入设备，输入设备返回为系统默认设备。

### 实现音频输出设备路由切换与合理暂停*
- 源码参考：[OutputDeviceChangePause.ets](entry/src/main/ets/pages/OutputDeviceChangePause.ets)
- 使用流程：
  - 点击'创建音频播放实例'按钮，首先调用`audio.createAudioRenderer`创建`AudioRenderer`实例，然后配置监听相应音频流输出设备变化及原因，回调内容在输出设备变化回调栏下方打印。
  - 点击'设置为本机扬声器'按钮，调用`audioSessionManager.setDefaultOutputDevice`设置默认输出设备为本机扬声器。
  - 点击'设置为系统默认设备'按钮，调用`audioSessionManager.setDefaultOutputDevice`设置默认输出设备为系统默认输出设备，即取消应用设置的默认设备，交由系统选择设备。

## 相关权限

不涉及。

## 模块依赖

不涉及。

## 约束与限制

1.  本示例支持在标准系统上运行，支持设备：RK3568。

2.  本示例支持API version 20，版本号： 6.0.0.43。

3.  本示例已支持使Build Version: 6.0.0.43, built on August 24, 2025。

4.  高等级APL特殊签名说明：无。