# 使用AVPlayer添加外挂字幕（C/C++）

## 概述

本文档介绍如何使用AVPlayer NDK API为视频播放器添加外挂字幕功能。通过读取rawfile中的字幕文件，使用文件描述符方式添加字幕源，并通过回调机制获取字幕内容。

## 功能介绍

AVPlayer支持外挂字幕功能，主要特性包括：
- 支持从rawfile目录加载字幕文件（如SRT格式）
- 使用文件描述符（FD）方式添加字幕源
- 通过信息回调实时获取字幕内容更新
- 获取字幕的时长、起始时间和文本信息

## 开发步骤

### 1. 准备字幕文件

将字幕文件（如`subtitle.srt`）放置到项目的rawfile目录：

```
entry/src/main/resources/rawfile/subtitle.srt
```

字幕文件示例（SRT格式）：
```srt
1
00:00:00,000 --> 00:00:05,000
This is a subtitle demo for video

2
00:00:05,000 --> 00:00:10,000
AVPlayer NDK Video Playback
```

### 2. 添加必要的头文件

```cpp
#include <rawfile/raw_file_manager.h>
#include <rawfile/raw_file.h>
#include <multimedia/player_framework/avplayer.h>
#include "multimedia/player_framework/avplayer_base.h"
```

### 3. 链接必要的库

在`CMakeLists.txt`中添加：

```cmake
target_link_libraries(entry PUBLIC
    libavplayer.so
    librawfile.z.so
)
```

### 4. 实现字幕添加功能

#### 4.1 从rawfile获取文件描述符

```cpp
static napi_value NAPI_Global_AddSubtitle(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    // 获取字幕文件名
    size_t length = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &length);
    char *fileName = new char[length + 1];
    napi_get_value_string_utf8(env, args[0], fileName, length + 1, &length);
    
    // 获取context中的resourceManager
    napi_value resourceManagerObj = nullptr;
    napi_get_named_property(env, args[1], "resourceManager", &resourceManagerObj);
    
    // 初始化NativeResourceManager
    NativeResourceManager *resManager = OH_ResourceManager_InitNativeResourceManager(env, resourceManagerObj);
    
    // 打开rawfile
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(resManager, fileName);
    
    // 获取文件描述符
    RawFileDescriptor descriptor;
    bool result = OH_ResourceManager_GetRawFileDescriptor(rawFile, descriptor);
    if (result) {
        // descriptor包含: fd, start, length
        // fd: 文件描述符
        // start: 文件在HAP中的起始位置
        // length: 文件长度
    }
    
    // ... 后续处理
}
```

#### 4.2 添加字幕源到AVPlayer

```cpp
// 获取AVPlayer实例
auto manager = SampleManager::GetInstance();
OH_AVPlayer *player = manager->player_;

// 使用文件描述符添加字幕源
OH_AVErrCode ret = OH_AVPlayer_AddFdSubtitleSource(
    player, 
    descriptor.fd,      // 文件描述符
    descriptor.start,   // 起始位置
    descriptor.length   // 文件长度
);

// 释放资源
OH_ResourceManager_CloseRawFile(rawFile);
OH_ResourceManager_ReleaseNativeResourceManager(resManager);
```

### 5. 处理字幕回调

#### 5.1 注册信息回调

```cpp
OH_AVPlayer_SetOnInfoCallback(player, OHAVPlayerOnInfoCallback, nullptr);
```

#### 5.2 处理字幕更新回调

```cpp
void OHAVPlayerOnInfoCallback(OH_AVPlayer *player, AVPlayerOnInfoType type, 
                               OH_AVFormat *infoBody, void *userData) {
    switch (type) {
    case AV_INFO_TYPE_SUBTITLE_UPDATE:
        // 获取字幕时长
        int32_t duration = 0;
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_DURATION, &duration);
        
        // 获取字幕起始时间
        int32_t startTime = 0;
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_START_TIME, &startTime);
        
        // 获取字幕文本（注意：使用GetStringValue，类型为string）
        const char *subtitleText = nullptr;
        OH_AVFormat_GetStringValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_TEXT, &subtitleText);
        
        if (subtitleText != nullptr) {
            // 处理字幕文本
            printf("Subtitle: %s, duration: %d, startTime: %d\n", 
                   subtitleText, duration, startTime);
        }
        break;
    }
}
```

### 6. ArkTS层调用

在ArkTS代码中调用Native函数：

```typescript
// NAPI接口声明（Index.d.ts）
export const addSubtitle: (fileName: string, context: Object) => number;
export const getSubtitle: () => string;

// 使用示例
async avSetup() {
    // 先设置视频源
    let fileDescriptor = await this.context.resourceManager.getRawFd('test1.mp4');
    avPlayerNDK.setup('video', fileDescriptor.fd, fileDescriptor.offset, fileDescriptor.length);
    
    // 添加字幕
    avPlayerNDK.addSubtitle('subtitle.srt', this.context);
}
```

## 完整代码示例

### C++ Native层实现

```cpp
// napi_init.cpp
#include <rawfile/raw_file_manager.h>
#include <rawfile/raw_file.h>
#include <multimedia/player_framework/avplayer.h>

class SampleManager {
public:
    OH_AVPlayer *player_ = nullptr;
    std::string currentSubtitle_ = "";
};

static napi_value NAPI_Global_AddSubtitle(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    // 参数1: 字幕文件名
    size_t length = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &length);
    char *fileName = new char[length + 1];
    napi_get_value_string_utf8(env, args[0], fileName, length + 1, &length);
    
    // 参数2: context对象
    napi_value resourceManagerObj = nullptr;
    napi_get_named_property(env, args[1], "resourceManager", &resourceManagerObj);
    
    // 初始化资源管理器
    NativeResourceManager *resManager = OH_ResourceManager_InitNativeResourceManager(env, resourceManagerObj);
    
    // 打开rawfile
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(resManager, fileName);
    if (rawFile == nullptr) {
        OH_ResourceManager_ReleaseNativeResourceManager(resManager);
        delete[] fileName;
        napi_value result;
        napi_create_int32(env, -1, &result);
        return result;
    }
    
    // 获取文件描述符
    RawFileDescriptor descriptor;
    bool getResult = OH_ResourceManager_GetRawFileDescriptor(rawFile, descriptor);
    if (!getResult) {
        OH_ResourceManager_CloseRawFile(rawFile);
        OH_ResourceManager_ReleaseNativeResourceManager(resManager);
        delete[] fileName;
        napi_value result;
        napi_create_int32(env, -1, &result);
        return result;
    }
    
    // 添加字幕源
    auto manager = SampleManager::GetInstance();
    OH_AVErrCode ret = OH_AVPlayer_AddFdSubtitleSource(
        manager->player_, 
        descriptor.fd, 
        descriptor.start, 
        descriptor.length
    );
    
    // 清理资源
    OH_ResourceManager_CloseRawFile(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(resManager);
    delete[] fileName;
    
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

void OHAVPlayerOnInfoCallback(OH_AVPlayer *player, AVPlayerOnInfoType type, 
                               OH_AVFormat *infoBody, void *userData) {
    if (type == AV_INFO_TYPE_SUBTITLE_UPDATE) {
        int32_t duration = 0;
        int32_t startTime = 0;
        const char *subtitleText = nullptr;
        
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_DURATION, &duration);
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_START_TIME, &startTime);
        OH_AVFormat_GetStringValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_TEXT, &subtitleText);
        
        if (subtitleText != nullptr) {
            auto manager = SampleManager::GetInstance();
            manager->currentSubtitle_ = std::string(subtitleText);
        }
    }
}
```

### NAPI接口声明

```typescript
// Index.d.ts
export const addSubtitle: (fileName: string, context: Object) => number;
export const getSubtitle: () => string;
```

## 相关API说明

### 资源管理API

| API | 说明 |
|-----|------|
| `OH_ResourceManager_InitNativeResourceManager` | 初始化Native资源管理器 |
| `OH_ResourceManager_OpenRawFile` | 打开rawfile文件 |
| `OH_ResourceManager_GetRawFileDescriptor` | 获取rawfile的文件描述符 |
| `OH_ResourceManager_CloseRawFile` | 关闭rawfile文件 |
| `OH_ResourceManager_ReleaseNativeResourceManager` | 释放资源管理器 |

### AVPlayer字幕API

| API | 说明 |
|-----|------|
| `OH_AVPlayer_AddFdSubtitleSource` | 通过文件描述符添加字幕源 |
| `OH_AVPlayer_AddUrlSubtitleSource` | 通过URL添加字幕源 |

### 字幕回调信息Key

| Key | 类型 | 说明 | 获取方法 |
|-----|------|------|----------|
| `OH_PLAYER_SUBTITLE_UPDATE_INFO_DURATION` | int32_t | 字幕持续时间 | `OH_AVFormat_GetIntValue()` |
| `OH_PLAYER_SUBTITLE_UPDATE_INFO_START_TIME` | int32_t | 字幕起始时间 | `OH_AVFormat_GetIntValue()` |
| `OH_PLAYER_SUBTITLE_UPDATE_INFO_TEXT` | **string** | 字幕文本内容 | `OH_AVFormat_GetStringValue()` |

## 注意事项

### 1. 字幕文件格式

- 支持常见的字幕格式，如SRT、ASS等
- 字幕文件需放置在`resources/rawfile/`目录下
- 确保字幕时间轴与视频同步

### 2. 文件描述符使用

- 使用`OH_ResourceManager_GetRawFileDescriptor()`获取的文件描述符直接来自HAP包
- **无需创建临时文件**，直接使用descriptor中的fd、start、length参数
- descriptor结构：
  ```cpp
  struct RawFileDescriptor {
      int fd;        // 文件描述符
      long start;    // 在HAP中的起始位置
      long length;   // 文件长度
  };
  ```

### 3. 字幕文本获取

- **重要**：字幕文本类型为`string`，必须使用`OH_AVFormat_GetStringValue()`获取
- 错误示例：
  ```cpp
  // ❌ 错误：使用GetBuffer获取string类型数据
  uint8_t *data;
  OH_AVFormat_GetBuffer(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_TEXT, &data, &size);
  ```
- 正确示例：
  ```cpp
  // ✅ 正确：使用GetStringValue获取string类型数据
  const char *text;
  OH_AVFormat_GetStringValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_TEXT, &text);
  ```

### 4. 字幕添加时机

- 字幕源必须在视频源设置完成后添加
- 建议在`AV_PREPARED`状态后添加字幕
- 可在播放过程中动态添加或切换字幕

### 5. 资源释放

- 使用完rawfile后必须调用`OH_ResourceManager_CloseRawFile()`
- 释放NativeResourceManager以避免内存泄漏
- 添加字幕后，AVPlayer内部会管理字幕资源

## 常见问题

### Q1: 为什么获取字幕文本返回空？

**原因**：使用了错误的API获取string类型数据。

**解决方案**：使用`OH_AVFormat_GetStringValue()`而不是`OH_AVFormat_GetBuffer()`。

### Q2: 字幕回调未触发？

**可能原因**：
1. 未注册信息回调：`OH_AVPlayer_SetOnInfoCallback()`
2. 字幕文件路径错误
3. 字幕文件格式不支持

**调试方法**：
- 检查`OH_AVPlayer_AddFdSubtitleSource()`返回值
- 添加日志验证rawfile是否成功打开
- 确认descriptor获取成功

### Q3: 如何切换字幕？

在播放过程中可以添加多个字幕源，通过`OH_AVPlayer_SelectTrack()`选择字幕轨道：

```cpp
// 选择字幕轨道
OH_AVPlayer_SelectTrack(player, trackIndex);

// 取消字幕显示
OH_AVPlayer_DeselectTrack(player, trackIndex);
```

### Q4: rawfile与本地文件的区别？

| 特性 | rawfile | 本地文件 |
|-----|---------|----------|
| 存储位置 | HAP包内 | 设备存储 |
| 访问方式 | ResourceManager | 文件路径 |
| 适用场景 | 预置资源 | 动态资源 |
| 文件描述符 | RawFileDescriptor | 标准fd |

## 调试建议

### 添加关键日志

建议在关键步骤添加日志，便于排查问题：

```cpp
#define CCLOG(format, ...) OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "AVPlayerNDK", "[cclog] " format, ##__VA_ARGS__)

// 关键日志点
CCLOG("AddSubtitle fileName: %s", fileName);
CCLOG("rawfile opened, size %ld", fileSize);
CCLOG("got descriptor fd=%d, start=%lld, length=%lld", descriptor.fd, descriptor.start, descriptor.length);
CCLOG("OH_AVPlayer_AddFdSubtitleSource result: %d", ret);
CCLOG("AV_INFO_TYPE_SUBTITLE_UPDATE received");
CCLOG("Subtitle text: %s, duration: %d, startTime: %d", text, duration, startTime);
```

### HiLog过滤

在DevEco Studio HiLog窗口中，使用关键字`cclog`或标签`AVPlayerNDK`过滤日志。

## 相关文档

- [使用AVPlayer播放视频(C/C++)](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/using-ndk-avplayer-for-video-playback)
- [NativeResourceManager开发指导](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/native-resource-manager)
- [AVPlayer API参考](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/avplayer)

## 版本要求

- API版本：23及以上
- SDK版本：5.0.3.135及以上
- DevEco Studio：5.0.3 Release及以上