# AudioSnapshotSample

## Introduction

This sample demonstrates how to use the **AudioDebuggingManager** API to capture audio snapshots for debugging, covering both ArkTS (AudioKit) and C (OHAudio native interface) interfaces. It supports concurrent multi-stream audio recording, PCM playback, and snapshot printing at app-level, recording-level, and playback-level.

## Usage

1. Launch the app and grant microphone permission.
2. On the **Overview** page, configure global playback parameters (usage, sample rate, channels, format).
3. Switch to the **TS Stream** page, create and start one or more TS recording streams, then click **Recording Snap** to print a recording snapshot for each stream.
4. Switch to the **C Stream** page, create and start one or more C recording streams, then click **Recording Snap** to print a recording snapshot via OHAudio C API.
5. On the **Overview** page, click **TS App Snapshot** or **C App Snapshot** to print app-level snapshot containing all active streams.
6. After recording, click **Play** on any stream, then click **Play.Snap** during playback to print a playback snapshot.
7. On the **Snapshot** page, click **Capture All Snapshots** to print all available snapshots at once.

## Project Directory

```
entry/
├── src/main/
│   ├── ets/
│   │   ├── entryability/
│   │   │   └── EntryAbility.ets             // UIAbility entry
│   │   ├── entrybackupability/
│   │   │   └── EntryBackupAbility.ets       // Backup extension
│   │   └── pages/
│   │       └── Index.ets                    // Main page with 4 tabs
│   ├── cpp/
│   │   ├── CMakeLists.txt                   // CMake build config
│   │   ├── audio.cpp                        // OHAudio capture/playback/snapshot NAPI
│   │   ├── NapiUtils.h                      // NAPI utility header
│   │   ├── NapiUtils.cpp                    // NAPI utility implementation
│   │   └── types/libentry/
│   │       ├── index.d.ts                   // TS type declarations for native module
│   │       └── oh-package.json5             // SO package description
│   ├── resources/                           // App resources
│   └── module.json5                         // Module configuration
├── build-profile.json5                      // Build config
└── oh-package.json5                         // Package dependencies
```

## Implementation

- **TS Recording & Playback**: Uses `@kit.AudioKit` (`audio.createAudioCapturer`, `audio.createAudioRenderer`) to create and manage audio streams from ArkTS side.
- **C Recording & Playback**: Uses OHAudio C API (`OH_AudioCapturer`, `OH_AudioRenderer`) via NAPI bindings for low-latency native audio.
- **Recording Snapshot**: Calls `AudioDebuggingManager.printCapturerInfo()` (TS) or `OH_AudioDebuggingManager_PrintCapturerInfo()` (C) to dump recording stream state to a file descriptor.
- **Playback Snapshot**: Calls `AudioDebuggingManager.printRendererInfo()` (TS) or `OH_AudioDebuggingManager_PrintRendererInfo()` (C) to dump playback stream state.
- **App-Level Snapshot**: Calls `AudioDebuggingManager.printAppInfo()` (TS) or `OH_AudioDebuggingManager_PrintAppInfo()` (C) to dump all active streams for the application.
- **Concurrent Verification**: The app creates multiple streams simultaneously and verifies that snapshot APIs work correctly under concurrent stream scenarios.

### Key APIs

| API | Description |
|-----|-------------|
| `audio.AudioManager.getDebuggingManager()` | Get the AudioDebuggingManager instance |
| `AudioDebuggingManager.printCapturerInfo(capturer, fd)` | Print recording snapshot to fd |
| `AudioDebuggingManager.printRendererInfo(renderer, fd)` | Print playback snapshot to fd |
| `AudioDebuggingManager.printAppInfo(fd)` | Print app-level snapshot to fd |
| `OH_AudioManager_GetAudioDebuggingManager()` | Get C AudioDebuggingManager instance |
| `OH_AudioDebuggingManager_PrintCapturerInfo()` | C API for recording snapshot |
| `OH_AudioDebuggingManager_PrintRendererInfo()` | C API for playback snapshot |
| `OH_AudioDebuggingManager_PrintAppInfo()` | C API for app snapshot |

## Required Permissions

| Permission | Description | Link |
|-----------|-------------|------|
| ohos.permission.MICROPHONE | Required for audio capture | https://gitcode.com/openharmony/docs/blob/master/en/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionmicrophone |

> **Note**: Background recording does not require additional permissions, but needs to apply for a long-running task through the [Background Task Manager](https://gitcode.com/openharmony/docs/blob/master/en/application-dev/performance/background-task-overview.md).

## Dependencies

- @kit.AudioKit
- @kit.AbilityKit
- @kit.ArkUI
- @kit.BasicServicesKit
- @kit.PerformanceAnalysisKit
- OHAudio native interface (libohaudio.so)

## Constraints and Limitations

1. This sample requires OpenHarmony 6.0.0(26) or later.
2. The AudioDebuggingManager API requires API version 26 or later.
3. Snapshot files are saved to the application's files directory and can be accessed via hdc.
4. Concurrent stream count is limited by system audio policy.

## Download

```bash
git sparse-checkout set code/DocsSample/Media/Audio/AudioSnapshot
```
