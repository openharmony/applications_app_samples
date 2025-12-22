# 实现音频焦点功能

## 介绍

本示例基于AudioSession能力，实现了通过AudioSession主动管理应用内音频流的焦点、自定义本应用音频流的焦点策略、调整本应用音频流释放音频焦点的时机等功能，包含了功能调用接口的完整链路。

## 效果图预览

**图1**：主界面

<img src='./screenshots/focus_c.png' width=320> 

- 点击'设置场景+激活焦点+注册监听'按钮，即可激活音频焦点。音频焦点的配置中，音频场景为媒体，焦点策略为混合播放。
- 点击'注销焦点+注销监听'按钮，即可注销音频焦点。

## 工程结构&模块类型

```
├───entry/src/main/ets
|   ├───cpp
|   |   ├───types/libentry
|   |   |   └───Index.d.ts                      //NAPI接口声明
|   |   ├───CMakeLists.txt                      //CMake编译配置文件
|   |   └───audiosession.cpp                    //NAPI接口配置
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

### 使用AudioSession管理应用音频焦点
- 源码参考：[audiosession.cpp](entry/src/main/ets/cpp/audiosession.cpp)  
- 使用流程：
  - 点击'设置场景+激活焦点+注册监听'按钮，首先调用`OH_AudioSessionManager_SetScene`设置当前音频场景为`MEDIA`。然后配置焦点策略为`CONCURRENCY_MIX_WITH_OTHERS`并调用`OH_AudioSessionManager_ActivateAudioSession`激活音频焦点。最后通过调用`OH_AudioSessionManager_RegisterSessionDeactivatedCallback`与`OH_AudioSessionManager_RegisterStateChangeCallback`监听焦点变化事件与焦点注销事件，监听事件触发后回调内容在返回信息栏打印。
  - 点击'注销焦点+注销监听'按钮，首先调用`OH_AudioSessionManager_DeactivateAudioSession`停用当前应用的音频会话。再调用`OH_AudioSessionManager_UnregisterSessionDeactivatedCallback`与`OH_AudioSessionManager_UnregisterStateChangeCallback`注销对焦点变化事件与焦点注销事件的监听。


## 相关权限

不涉及。

## 模块依赖

不涉及。

## 约束与限制

1.  本示例支持在标准系统上运行，支持设备：RK3568。

2.  本示例支持API version 20，版本号： 6.0.0.43。

3.  本示例已支持使Build Version: 6.0.0.43, built on August 24, 2025。

4.  高等级APL特殊签名说明：无。