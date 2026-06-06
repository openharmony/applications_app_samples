# AudioSnapshotSample

## 简介

本示例演示如何使用 **AudioDebuggingManager** API 捕获音频快照用于调试，涵盖 ArkTS（AudioKit）和 C（OHAudio 原生接口）两种接口。支持并发多流音频录音、PCM 播放以及应用级、录音流级、播放流级的快照打印。

## 使用说明

1. 启动应用并授予麦克风权限。
2. 在**概览**页面，配置全局播放参数（usage、采样率、声道、格式）。
3. 切换到 **TS Stream** 页面，创建一个或多个 TS 录音流，然后点击 **录音快照** 打印各流录音快照。
4. 切换到 **C Stream** 页面，创建一个或多个 C 录音流，然后点击 **录音快照** 通过 OHAudio C API 打印录音快照。
5. 在**概览**页面，点击 **TS应用快照** 或 **C应用快照** 打印包含所有活跃流的应用级快照。
6. 录音后，在任何流上点击 **播放**，然后在播放过程中点击 **播放快照** 打印播放流快照。
7. 在**快照**页面，点击 **捕获所有快照** 一次性打印所有可用快照。

## 工程目录

```
entry/
├── src/main/
│   ├── ets/
│   │   ├── entryability/
│   │   │   └── EntryAbility.ets             // UIAbility 入口
│   │   ├── entrybackupability/
│   │   │   └── EntryBackupAbility.ets       // 备份扩展
│   │   └── pages/
│   │       └── Index.ets                    // 主页面，包含4个Tab
│   ├── cpp/
│   │   ├── CMakeLists.txt                   // CMake 构建配置
│   │   ├── audio.cpp                        // OHAudio 采集/播放/快照 NAPI 实现
│   │   ├── NapiUtils.h                      // NAPI 工具头文件
│   │   ├── NapiUtils.cpp                    // NAPI 工具实现
│   │   └── types/libentry/
│   │       ├── index.d.ts                   // 原生模块 TS 类型声明
│   │       └── oh-package.json5             // SO 包描述文件
│   ├── resources/                           // 应用资源
│   └── module.json5                         // 模块配置
├── build-profile.json5                      // 构建配置
└── oh-package.json5                         // 包依赖
```

## 实现说明

- **TS 录音与播放**：使用 `@kit.AudioKit`（`audio.createAudioCapturer`、`audio.createAudioRenderer`）从 ArkTS 侧创建和管理音频流。
- **C 录音与播放**：通过 NAPI 绑定使用 OHAudio C API（`OH_AudioCapturer`、`OH_AudioRenderer`）实现低延迟原生音频。
- **录音快照**：调用 `AudioDebuggingManager.printCapturerInfo()`（TS）或 `OH_AudioDebuggingManager_PrintCapturerInfo()`（C）将录音流状态输出到文件描述符。
- **播放快照**：调用 `AudioDebuggingManager.printRendererInfo()`（TS）或 `OH_AudioDebuggingManager_PrintRendererInfo()`（C）输出播放流状态。
- **应用级快照**：调用 `AudioDebuggingManager.printAppInfo()`（TS）或 `OH_AudioDebuggingManager_PrintAppInfo()`（C）输出应用所有活跃流的快照。
- **并发验证**：应用同时创建多个流，验证快照 API 在并发流场景下的正确性。

### 关键 API

| API | 说明 |
|-----|-------------|
| `audio.AudioManager.getDebuggingManager()` | 获取 AudioDebuggingManager 实例 |
| `AudioDebuggingManager.printCapturerInfo(capturer, fd)` | 打印录音流快照到 fd |
| `AudioDebuggingManager.printRendererInfo(renderer, fd)` | 打印播放流快照到 fd |
| `AudioDebuggingManager.printAppInfo(fd)` | 打印应用级快照到 fd |
| `OH_AudioManager_GetAudioDebuggingManager()` | 获取 C 侧 AudioDebuggingManager 实例 |
| `OH_AudioDebuggingManager_PrintCapturerInfo()` | C API 打印录音流快照 |
| `OH_AudioDebuggingManager_PrintRendererInfo()` | C API 打印播放流快照 |
| `OH_AudioDebuggingManager_PrintAppInfo()` | C API 打印应用级快照 |

## 所需权限

| 权限 | 说明 | 链接 |
|-----------|-------------|------|
| ohos.permission.MICROPHONE | 音频采集必需 | https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionmicrophone |

> **说明**：后台录音无需额外权限，但需要通过[后台任务管理器](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/performance/background-task-overview.md)申请长时任务，确保录音在后台持续运行。

## 依赖

- @kit.AudioKit
- @kit.AbilityKit
- @kit.ArkUI
- @kit.BasicServicesKit
- @kit.PerformanceAnalysisKit
- OHAudio 原生接口（libohaudio.so）

## 约束与限制

1. 本示例需要 OpenHarmony 6.0.0(26) 及以上版本。
2. AudioDebuggingManager API 需要 API version 26 及以上。
3. 快照文件保存在应用的 files 目录，可通过 hdc 访问。
4. 并发流数量受系统音频策略限制。

## 下载

```bash
git sparse-checkout set code/DocsSample/Media/Audio/AudioSnapshot
```
