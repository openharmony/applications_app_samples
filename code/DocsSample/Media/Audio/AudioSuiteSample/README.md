# AudioSuite 音频编创示例

## 介绍

本示例基于 AudioSuite 能力，实现了音频编辑、音源分离、混音和实时预览渲染等功能，包含了离线编辑和实时预览渲染两种模式，以及功能调用接口的完整链路。

## 效果图预览

**图1：主界面**

<img src='./screenshots/audioSuite.png' width=320>


点击'播放音频'按钮，即可创建音频流并播放原始音频。

点击'停止播放'按钮，即可销毁音频流。

点击'添加默认均衡器效果'按钮，即可对音频添加均衡器效果（异步处理）。

点击'播放加均衡器效果后音频'按钮，即可播放添加均衡器效果后的音频。

点击'音源分离'按钮，即可将音频分离为人声和伴奏（异步处理）。

点击'播放伴奏'按钮，即可播放分离后的伴奏。

点击'播放人声'按钮，即可播放分离后的人声。

点击'混音与级联'按钮，即可将音频分离的人声与音频分离的伴奏音频进行混音（异步处理）。

点击'播放混音'按钮，即可播放混音后的音频。

点击'播放实时预览渲染'按钮，即可实时处理并播放音频（预览效果）。

## 工程结构&模块类型

```
├── entry/src/main/
│   ├── cpp/                        # C++ 原生代码
│   │   ├── types/libentry/
│   │   │   └── Index.d.ts         # NAPI 接口声明
│   │   ├── CMakeLists.txt         # CMake 编译配置文件
│   │   ├── audioSuite.cpp         # NAPI 接口和音频播放实现
│   │   ├── manualRendering.cpp    # 离线编辑实现
│   │   ├── realTimeRendering.cpp  # 实时预览渲染实现
│   │   └── pcmFileUtils.cpp      # PCM 文件工具类
│   ├── ets/
│   │   ├── entryability/
│   │   │   └── EntryAbility.ets   # Ability 的生命周期回调内容
│   │   ├── entrybackupability/
│   │   │   └── EntryBackupAbility.ets  # BackupAbility 的生命周期回调内容
│   │   └── pages/
│   │       └── Index.ets          # 主界面
│   └── resources/                 # 资源目录
```

## 具体实现

### 使用 AudioSuite 实现离线编辑（离线编辑）

**源码参考：** [manualRendering.cpp](entry/src/main/cpp/manualRendering.cpp)

**使用流程：**

#### 均衡器效果

点击'添加默认均衡器效果'按钮，首先调用 `OH_AudioSuiteEngine_Create` 创建音频编创引擎，然后调用 `OH_AudioSuiteEngine_CreatePipeline` 创建管线（使用 `AUDIOSUITE_PIPELINE_EDIT_MODE` 编辑模式）。接着创建输入节点、均衡器节点和输出节点，并设置节点格式和回调。然后调用 `OH_AudioSuiteEngine_ConnectNodes` 连接各个节点组成组网。最后调用 `OH_AudioSuiteEngine_ProcessFrame` 处理音频帧并将结果写入文件。

#### 音源分离

点击'音源分离'按钮，首先创建引擎和管线，然后创建输入节点和音源分离节点。接着设置节点格式和回调，连接节点组成组网。最后处理音频帧并将分离后的人声和伴奏分别写入文件。

#### 混音与级联

点击'混音与级联'按钮，首先创建引擎和管线，然后创建输入节点、声场节点和输出节点。接着设置节点格式和回调，连接节点组成组网。最后处理音频帧并将混音后的音频写入文件。

### 使用 AudioSuite 实现实时预览渲染

**源码参考：** [realTimeRendering.cpp](entry/src/main/cpp/realTimeRendering.cpp)

**使用流程：**

点击'播放实时预览渲染'按钮，首先调用 `OH_AudioSuiteEngine_Create` 创建音频编创引擎，然后调用 `OH_AudioSuiteEngine_CreatePipeline` 创建管线（使用 `AUDIOSUITE_PIPELINE_REALTIME_MODE` 实时模式）。接着创建输入节点、均衡器节点和输出节点，并设置节点格式和回调。然后调用 `OH_AudioSuiteEngine_ConnectNodes` 连接各个节点组成组网。再创建 AudioRenderer 并设置写入数据回调，在回调中调用 `OH_AudioSuiteEngine_RenderFrame` 实时获取处理后的音频数据。最后调用 `OH_AudioSuiteEngine_StartPipeline` 启动管线并调用 `OH_AudioRenderer_Start` 开始播放。

点击'停止播放'按钮，调用 `OH_AudioRenderer_Stop` 停止播放，然后调用 `OH_AudioSuiteEngine_StopPipeline` 停止管线，最后释放所有资源。

### 按钮依赖关系

本示例实现了按钮依赖关系管理，确保操作按正确顺序执行：

- '播放加均衡器效果后音频'：需先完成均衡器效果处理
- '播放伴奏'和'播放人声'：需先完成音源分离
- '混音与级联'：需先完成音源分离
- '播放混音'：需先完成混音与级联

异步操作（均衡器效果、音源分离、混音与级联）处理过程中会显示 Loading 遮罩，处理完成后自动启用相关播放按钮。

## 相关权限

不涉及。

## 模块依赖

依赖以下模块：
- libohaudio.so
- libohaudiosuite.so

## 约束与限制

1.  本示例支持在标准系统上运行，支持设备：RK3568。

2.  本示例支持API version 23，版本号： 6.1.0。

3.  本示例已支持使Build Version: 6.1.0, built on May 21, 2026.

4.  高等级APL特殊签名说明：无。

**音频格式限制：**
- 仅支持 PCM

**功能限制：**
- 使用真机测试

## 高等级APL特殊签名说明

无。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Media/Audio/AudioSuiteSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```