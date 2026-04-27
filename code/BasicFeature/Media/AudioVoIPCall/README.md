# AudioVoIPCallSample

### 介绍

本示例主要展示了VoIP通话的相关功能，使用AudioRenderer/AudioCapturer C API实现VoIP通话功能，并使用TS接口实现VoIP来电上报、通话状态管理、音频播放、设备切换以及后台长时任务等功能

### 效果预览

| 主页                                   | 来电页面  | 去电页面 | 通话中页面 |
|--------------------------------------|-----------------------------------------|-----------------------------------------|------------------------------------------------------|
| ![Index](screenshots/index.jpg)|![CallIn](screenshots/call_in.jpg) | ![CallOut](screenshots/call_out.jpg) | ![InCalling](screenshots/in_calling.jpg) |

### 使用说明

1. 在主界面点击"被叫"按钮，进入来电页面
2. 在来电页面，系统会播放来电铃声，并弹出来电横幅通知
3. 在来电页面，点击"接听"按钮，进入通话中页面
4. 在来电页面，点击"拒绝"按钮，返回主页，并停止铃声播放
5. 在主界面点击"主叫"按钮，进入去电页面
6. 在去电页面，点击"对方接听"按钮，进入通话中页面
7. 在去电页面，点击"对方拒绝"按钮，返回主页
8. 在通话中页面，点击AVCastPicker图标，可以切换音频输出设备（听筒、扬声器、蓝牙）
9. 在通话中页面，点击麦克风图标，可以静音/取消静音录音
10. 在通话中页面，点击扬声器图标，可以静音/取消静音播放
11. 在通话中页面，点击挂断按钮，结束通话并返回主页

### 工程目录

```
entry/src/main/ets/
|---pages
|---|---Index.ets                           //主页
|---|---CallIn.ets                          //来电页面
|---|---CallOut.ets                         //去电页面
|---|---InCalling.ets                       //通话中页面
|---|---AudioPlayer.ets                     //音频播放器封装
entry/src/main/cpp/
|---|---audio.cpp                          //C++层音频处理实现
|---|---NapiUtils.cpp                      //NAPI工具类
|---|---NapiUtils.h                        //NAPI工具类头文件
|---|---CMakeLists.txt                     //CMake构建配置
```

### 具体实现

* VoIP来电上报功能封装在CallIn,源码参考：[CallIn.ets](entry/src/main/ets/pages/CallIn.ets)
    * 使用voipCall.reportIncomingCall()接口上报来电信息
    * 使用voipCall.on('voipCallUiEvent')注册VoIP UI事件监听
    * 使用voipCall.off('voipCallUiEvent')取消VoIP UI事件监听
    * 使用AudioPlayer播放来电铃声，支持循环播放和超时自动停止

* VoIP通话状态管理功能封装在CallIn和InCalling,源码参考：[CallIn.ets](entry/src/main/ets/pages/CallIn.ets)和[InCalling.ets](entry/src/main/ets/pages/InCalling.ets)
    * 使用voipCall.reportCallStateChange()上报通话状态变化
    * 支持的通话状态包括：VOIP_CALL_STATE_RINGING（响铃）、VOIP_CALL_STATE_ACTIVE（通话中）、VOIP_CALL_STATE_DISCONNECTED（已断开）

* 音频播放功能封装在AudioPlayer,源码参考：[AudioPlayer.ets](entry/src/main/ets/pages/AudioPlayer.ets)
    * 使用media.createAVPlayer()创建AVPlayer实例
    * 使用AVPlayer.loop属性设置循环播放
    * 使用setTimeout实现超时自动停止播放和弹窗提示
    * 在stop()方法中调用clearTimeout清除定时器，避免提前停止后仍弹窗

* 后台长时任务功能封装在AudioPlayer,源码参考：[AudioPlayer.ets](entry/src/main/ets/pages/AudioPlayer.ets)
    * 使用backgroundTaskManager.requestSuspendDelay()申请后台长时任务
    * 使用backgroundTaskManager.cancelSuspendDelay()取消后台长时任务
    * 使用wantAgent.getWantAgent()创建WantAgent对象用于通知点击后的动作

* 音频设备切换功能封装在InCalling,源码：[InCalling.ets](entry/src/main/ets/pages/InCalling.ets)
    * 使用AVCastPicker组件实现音频输出设备选择
    * 使用audio.getAudioManager()获取音频管理器
    * 使用audioRoutingManager.getPreferredOutputDeviceForRendererInfoSync()获取当前发声设备
    * 使用audioRoutingManager.on('preferOutputDeviceChangeForRendererInfo')监听设备切换事件

* AVSession媒体会话功能封装在InCalling,源码：[InCalling.ets](entry/src/main/ets/pages/InCalling.ets)
    * 使用avSession.createAVSession()创建AVSession实例
    * 创建voice_call类型的会话用于通话场景
    * 使用session.destroy()销毁会话

* C++层音频处理功能封装在audio.cpp,源码：[audio.cpp](entry/src/main/cpp/audio.cpp)
    * 使用OHAudio Native API实现音频采集和播放
    * 实现activateAudioSessionVoIP()激活音频会话
    * 实现audioCapturerInitVoIP()、audioCapturerStartVoIP()、audioCapturerStopVoIP()等音频采集相关方法
    * 实现audioRendererPlayerInitVoIP()、audioRendererPlayerStartVoIP()、audioRendererPlayerStopVoIP()等音频播放相关方法
    * 实现audioCapturerMuteVoIP()、audioCapturerUnMuteVoIP()等静音控制方法

### 相关权限

VoIP通话涉及的权限包括：

1.允许应用使用麦克风：[ohos.permission.MICROPHONE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionmicrophone)

后台长时任务涉及的权限包括：

1.允许应用后台长时运行：[ohos.permission.KEEP_BACKGROUND_RUNNING](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionkeep_background_running)

### 依赖

本示例依赖以下系统API：

* @kit.MediaKit - 媒体播放
* @kit.AudioKit - 音频管理
* @kit.CallServiceKit - VoIP通话服务
* @kit.AVSessionKit - 媒体会话
* @kit.BackgroundTasksKit - 后台任务管理
* @kit.AbilityKit - 能力框架
* @kit.ArkUI - ArkUI框架

### 约束与限制

1. 本示例仅支持在支持VoIP功能的设备上运行；
2. 本示例需要真实设备测试，模拟器可能无法完整展示VoIP功能；
3. 本示例需要使用DevEco Studio 版本号(6.0Release)才可编译运行；
4. C++层代码需要正确编译生成libentry.so动态库；

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Media/AudioVoIPCall > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
