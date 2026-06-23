# 音频设备路由管理功能示例

## 介绍

本示例基于AudioRender能力，实现了查询和监听音频输入设备、查询和监听音频输出设备、实现音频输入设备路由切换、实现音频输出设备路由切换、响应输出设备变更时合理暂停、增强路由设备选择等功能，包含了功能调用接口的完整链路。

## 使用说明

1. 安装编译生成的hap包，并打开应用；
2. 在首页选择跳转到增强路由设备选择页面；
3. 点击'查询增强路由支持'按钮，查询系统是否支持增强路由功能；
4. 点击'创建AudioRenderer'按钮，创建AudioRenderer实例，为流级设备选择做准备；
5. 点击'创建AudioCapturer'按钮，授权麦克风后创建AudioCapturer实例，为流级设备选择做准备；
6. 在应用级选择区域，点击'为应用选择输出/输入'按钮，弹出设备列表，选择目标设备完成应用级路由选择；
7. 在流级选择区域，点击'为Renderer选择输出/为Capturer选择输入'按钮，弹出设备列表，选择目标设备完成流级路由选择。

## 效果图预览

**图1**：首页

选择跳转到对应功能页面。

<img src='screenShots/Routing_Index.png' width=320>

**图2**：增强路由设备选择页

页面按钮按功能分为三个区域：

**准备区**：
- 点击'查询增强路由支持'按钮，调用`audioDeviceEnhanceManager.isEnhancedRoutingSupported`查询系统是否支持增强路由功能。
- 点击'创建AudioRenderer'按钮，调用`audio.createAudioRenderer`创建音频播放实例。
- 点击'创建AudioCapturer'按钮，请求麦克风权限后调用`audio.createAudioCapturer`创建音频录制实例。

**应用级选择区**：
- 点击'为应用选择输出'按钮，弹出可选输出设备列表，选中后直接调用`audioDeviceEnhanceManager.selectOutputDevice`为应用选择输出设备。
- 点击'为应用选择输入'按钮，弹出可选输入设备列表，选中后直接调用`audioDeviceEnhanceManager.selectInputDevice`为应用选择输入设备。

**流级选择区**：
- 点击'为Renderer选择输出'按钮，弹出可选输出设备列表，选中后直接调用`audioDeviceEnhanceManager.selectOutputDeviceForAudioRenderer`为指定播放流选择输出设备（需先创建AudioRenderer）。
- 点击'为Capturer选择输入'按钮，弹出可选输入设备列表，选中后直接调用`audioDeviceEnhanceManager.selectInputDeviceForAudioCapturer`为指定录制流选择输入设备（需先创建AudioCapturer）。

  <img src='screenShots/EnhancedDeviceRouting.png' width=320>

## 工程结构&模块类型

```
├───entry/src/main/ets
│   ├───pages                               
│   │   └───Index.ets                                        // 首页。
│   │   └───EnhancedDeviceRouting.ets                         // 增强路由设备选择页。
└───entry/src/main/resources                                 // 资源目录。         
```
### 具体实现

### 增强路由设备选择*
- 源码参考：[EnhancedDeviceRouting.ets](entry/src/main/ets/pages/EnhancedDeviceRouting.ets)
- 页面按钮按功能分为三个区域，使用流程如下：
- 准备区：
  - 点击'查询增强路由支持'按钮，调用`audioDeviceEnhanceManager.isEnhancedRoutingSupported`查询系统是否支持增强路由功能。
  - 点击'创建AudioRenderer'按钮，调用`audio.createAudioRenderer`创建`AudioRenderer`实例。
  - 点击'创建AudioCapturer'按钮，请求麦克风权限后调用`audio.createAudioCapturer`创建`AudioCapturer`实例。
- 应用级选择区：
  - 点击'为应用选择输出'按钮，通过`audioSessionManager.getAvailableDevices`获取可选输出设备列表并弹出选择框，选中后直接调用`audioDeviceEnhanceManager.selectOutputDevice`为应用选择输出设备。
  - 点击'为应用选择输入'按钮，通过`audioSessionManager.getAvailableDevices`获取可选输入设备列表并弹出选择框，选中后直接调用`audioDeviceEnhanceManager.selectInputDevice`为应用选择输入设备。
- 流级选择区：
  - 点击'为Renderer选择输出'按钮，弹出可选输出设备列表，选中后直接调用`audioDeviceEnhanceManager.selectOutputDeviceForAudioRenderer`为指定播放流选择输出设备。未创建AudioRenderer时提示错误。
  - 点击'为Capturer选择输入'按钮，弹出可选输入设备列表，选中后直接调用`audioDeviceEnhanceManager.selectInputDeviceForAudioCapturer`为指定录制流选择输入设备。未创建AudioCapturer时提示错误。

## 相关权限

麦克风使用权限：ohos.permission.MICROPHONE

## 模块依赖

不涉及。

## 约束与限制

1.  本示例支持在标准系统上运行，支持设备：RK3568。

2.  本示例支持API version 26，版本号： 7.0.0.43。

3.  本示例已支持使Build Version: 7.0.0.43, built on August 24, 2025。

4.  高等级APL特殊签名说明：无。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Media/Audio/AudioEnhanceDeviceSampleJS/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```