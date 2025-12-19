# 实现音频播放功能

## 介绍

本示例基于AudioRenderer能力，实现了音频播放、设置音量、低时延模式选择以及音频工作组管理等功能，包含了功能调用接口的完整链路。

## 效果图预览

**图1**：主界面

<img src='./screenshots/render_c.png' width=320>

- 点击'创建播放流'按钮，即可创建音频流并播放。
- 点击'销毁播放流'按钮，即可销毁音频流。
- 点击'设置音量'按钮，即可设置音频流音量为0.5。
- 点击'设置时延模式'按钮，即可设置播放流为低时延模式。
- 点击'获取时延模式'按钮，即可查看播放流是否为低时延模式。
- 点击'创建工作组'按钮，即可创建一个音频工作组并将关键线程加入其中。
- 点击'处理工作组'按钮，即可开始一个工作周期的进程处理，处理结束后将线程从工作组中移除并销毁音频工作组。
- 点击'自定义的回调方法'按钮，即可通过设置非监听内容为空指针实现回调函数初始化。
- 点击'空指针初始化回调方法'按钮，即可通过归零结构体实现回调函数初始化。
- 点击'设置同时写入回调'按钮，即可初始化流类型为Vivid的音频流，并且设置写入数据回调同时写入PCM数据和元数据。

## 工程结构&模块类型

```
├───entry/src/main/ets
|   ├───cpp
|   |   ├───types/libentry
|   |   |   └───Index.d.ts                      //NAPI接口声明
|   |   ├───CMakeLists.txt                      //CMake编译配置文件
|   |   └───renderer.cpp                        //NAPI接口配置
|   ├───ets
│       ├───entryability                        
│       │   └───EntryAbility.ets                // Ability的生命周期回调内容。
│       ├───entrybackupability                  
│       │   └───EntryBackupAbility.ets          // BackupAbility的生命周期回调内容。
│       ├───pages                               
│           └───Index.ets                       // 主界面。
└───entry/src/main/resources                    // 资源目录。
```
### 具体实现

### 使用AudioRenderer实现音频播放
- 源码参考：[renderer.cpp](entry/src/main/cpp/renderer.cpp)  
- 使用流程：
  - 点击'创建播放流'按钮，首先调用`OH_AudioStreamBuilder_Create`创建音频构造器。接着配置播放参数，包括采样率、声道数、采样格式、编码类型等。然后调用`OH_AudioStreamBuilder_SetRendererInterruptCallback`、`OH_AudioStreamBuilder_SetRendererErrorCallback`、`OH_AudioStreamBuilder_SetRendererWriteDataCallback`配置音频中断事件、音频异常事件监听以及输出数据回调。再调用`OH_AudioStreamBuilder_SetLatencyMode`设置播放流为低时延模式。最后调用`OH_AudioStreamBuilder_GenerateRenderer`构造音频流。
  - 点击'销毁播放流'按钮，调用`OH_AudioStreamBuilder_Destroy`销毁音频流。
  - 点击'设置音量'按钮，调用`OH_AudioRenderer_SetVolume`设置流音量为0.5，音量的取值范围为[0, 1]。
  - 点击'设置时延模式'按钮，调用`OH_AudioStreamBuilder_SetLatencyMode`设置音频流为低时延模式。
  - 点击'获取时延模式'按钮，调用`OH_AudioRenderer_GetLatencyMode`来查询当前音频流是否为低时延模式，查询结果在NAPI返回信息栏打印。
  - 点击'创建工作组'按钮，首先调用`OH_AudioManager_GetAudioResourceManager`创建资源管理实例，然后调用`OH_AudioResourceManager_CreateWorkgroup`创建音频工作组，最后调用`OH_AudioWorkgroup_AddCurrentThread`将线程加入音频工作组。
  - 点击'处理工作组'按钮，首先配置工作周期相关参数，即任务开始时间和预期完成时间。并调用`OH_AudioWorkgroup_Start`与`OH_AudioWorkgroup_Stop`来开启工作周期。接着调用`OH_AudioWorkgroup_RemoveThread`将线程从音频工作组中移除。最后调用`OH_AudioResourceManager_ReleaseWorkgroup`销毁音频工作组。
  - 点击'自定义的回调方法'按钮，使用`OH_AudioCapturer_Callbacks`来配置写入数据回调，并通过将监听内容赋值、非监听内容设置为`nullptr`实现初始化。
  - 点击'空指针初始化的回调方法'按钮，使用`OH_AudioCapturer_Callbacks`来配置写入数据回调，并通过`memset`将结构体清零再将监听内容赋值实现初始化。
  - 点击'设置同时写入回调'按钮，首先调用`OH_AudioStreamBuilder_Create`创建音频构造器。接着配置播放参数，包括采样率、声道数、采样格式、编码类型等，其中编码类型为`AUDIOSTREAM_ENCODING_TYPE_AUDIOVIVID`。然后调用`OH_AudioStreamBuilder_SetWriteDataWithMetadataCallback`来设置写入数据回调可以同时写入PCM数据和元数据。


## 相关权限

不涉及。

## 模块依赖

不涉及。

## 约束与限制

1.  本示例支持在标准系统上运行，支持设备：RK3568。

2.  本示例支持API version 20，版本号： 6.0.0.43。

3.  本示例已支持使Build Version: 6.0.0.43, built on August 24, 2025。

4.  高等级APL特殊签名说明：无。