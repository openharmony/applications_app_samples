/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "main.h"

using namespace std;
#define LOG_TAG "ScreenCaptureSample"

FILE *g_micFile = nullptr;
FILE *g_vFile = nullptr;
FILE *g_innerFile = nullptr;

void OpenFile(std::string fileName)
{
    std::string filePath = "data/storage/el2/base/files/MIC_" + fileName + ".pcm";
    g_micFile = fopen(filePath.c_str(), "wb");
    if (g_micFile == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OpenFile g_micFile audio open failed. %{public}s", strerror(errno));
    }
    filePath = "data/storage/el2/base/files/INNER_" + fileName + ".pcm";
    g_innerFile = fopen(filePath.c_str(), "wb");
    if (g_innerFile == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OpenFile g_innerFile audio open failed. %{public}s", strerror(errno));
    }
    filePath = "data/storage/el2/base/files/VIDEO_" + fileName + ".yuv";
    g_vFile = fopen(filePath.c_str(), "wb");
    if (g_vFile == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OpenFile vFile video open failed. %{public}s", strerror(errno));
    }
}

void CloseFile(void)
{
    if (g_micFile != nullptr) {
        fclose(g_micFile);
        g_micFile = nullptr;
    }
    if (g_innerFile != nullptr) {
        fclose(g_innerFile);
        g_innerFile = nullptr;
    }
    if (g_vFile != nullptr) {
        fclose(g_vFile);
        g_vFile = nullptr;
    }
}

void SetConfig01(OH_AVScreenCaptureConfig &config)
{
    // [Start screenCapture_config_buffer_audio]
    // 录屏时获取麦克风，如果同时设置了内录和麦克风音频信息，两者参数设置需保持一致。
    OH_AudioCaptureInfo micCapInfo = {.audioSampleRate = 48000, .audioChannels = 2, .audioSource = OH_MIC};
    // 录屏时获取内录数据，内录参数必填。如果同时设置了内录和麦克风音频信息，两者参数设置需保持一致。
    OH_AudioCaptureInfo innerCapInfo = {.audioSampleRate = 48000, .audioChannels = 2, .audioSource = OH_ALL_PLAYBACK};
    // 录屏音频输出规格配置。audioBitrate保证输出文件的比特率为设置的预期比特率，和audioSampleRate无强关联。
    // 此处音频比特率取值为高质量录屏的取值。如果录屏内容以语音为主，不包含音乐、游戏音效等，可以降低为96000或48000。
    OH_AudioEncInfo audioEncInfo = {
        .audioBitrate = 128000,
        .audioCodecformat = OH_AAC_LC
    };
    OH_AudioInfo audioInfo = {
        .micCapInfo = micCapInfo,
        .innerCapInfo = innerCapInfo,
        .audioEncInfo = audioEncInfo
    };
    // 可以单独设置麦克风开关。
    // [Start screenCapture_buffer_strategy_setMicrophoneEnabled]
    bool isMic = true;
    OH_AVScreenCapture_SetMicrophoneEnabled(g_avCapture, isMic);
    // [End screenCapture_buffer_strategy_setMicrophoneEnabled]
    // [End screenCapture_config_buffer_audio]
    // [Start screenCapture_config_buffer_video]
    // 获取屏幕信息
    uint64_t displayId = 0;
    NativeDisplayManager_ErrorCode ret = OH_NativeDisplayManager_GetDefaultDisplayId(&displayId);

    NativeDisplayManager_DisplayInfo* displayInfo = nullptr;
    ret = OH_NativeDisplayManager_CreateDisplayById(displayId, &displayInfo);
    if (ret != DISPLAY_MANAGER_OK || !displayInfo) {
        return;
    }
    int32_t screenWidth = displayInfo->width;
    int32_t screenHeight = displayInfo->height;
    // 录屏输入规格配置。
    OH_VideoCaptureInfo videoCapInfo = {
        .videoFrameWidth = screenWidth,
        .videoFrameHeight = screenHeight,
        .videoSource = OH_VIDEO_SOURCE_SURFACE_RGBA
    };
    // 录屏输出规格配置。
    OH_VideoEncInfo videoEncInfo = {
        .videoCodec = OH_H264,
        .videoBitrate = 2000000,
        .videoFrameRate = 30
    };

    OH_VideoInfo videoInfo = {
        .videoCapInfo = videoCapInfo,
        .videoEncInfo = videoEncInfo
    };
    // [End screenCapture_config_buffer_video]
    // [Start screenCapture_config_buffer_init]
    // 初始化录屏，传入配置信息OH_AVScreenCaptureConfig。
    config = {
        .captureMode = OH_CAPTURE_HOME_SCREEN, // 录屏模式设置。
        .dataType = OH_ORIGINAL_STREAM, // 录屏数据类型，原始码流或文件
        .audioInfo = audioInfo,
        .videoInfo = videoInfo
    };
    // 在StartScreenCapture01()函数中调用OH_AVScreenCapture_Init方法将配置项设置到OH_AVScreenCapture中。
    // [End screenCapture_config_buffer_init]
}

void SetConfig02(OH_AVScreenCaptureConfig &config)
{
    // [Start screenCapture_config]
    // 录屏时获取麦克风或者内录，内录参数必填，如果都设置了，内录和麦克风的参数设置需要一致。
    OH_AudioCaptureInfo micCapInfo = {
        .audioSampleRate = 48000,
        .audioChannels = 2,
        .audioSource = OH_MIC
    };

    OH_AudioCaptureInfo innerCapInfo = {
        .audioSampleRate = 48000,
        .audioChannels = 2,
        .audioSource = OH_ALL_PLAYBACK
    };
    // 录屏音频输出规格配置。audioBitrate保证输出文件的比特率为设置的预期比特率，和audioSampleRate无强关联。
    // 此处音频比特率取值为高质量录屏的取值。如果录屏内容以语音为主，不包含音乐、游戏音效等，可以降低为96000或48000。
    OH_AudioEncInfo audioEncInfo = {
        .audioBitrate = 48000,
        .audioCodecformat = OH_AAC_LC
    };

    // 获取屏幕信息
    uint64_t displayId = 0;
    NativeDisplayManager_ErrorCode ret = OH_NativeDisplayManager_GetDefaultDisplayId(&displayId);

    NativeDisplayManager_DisplayInfo* displayInfo = nullptr;
    ret = OH_NativeDisplayManager_CreateDisplayById(displayId, &displayInfo);
    if (ret != DISPLAY_MANAGER_OK || !displayInfo) {
        return;
    }
    int32_t screenWidth = displayInfo->width;
    int32_t screenHeight = displayInfo->height;
    OH_VideoCaptureInfo videoCapInfo = {
        .videoFrameWidth = screenWidth,
        .videoFrameHeight = screenHeight,
        .videoSource = OH_VIDEO_SOURCE_SURFACE_RGBA
    };

    OH_VideoEncInfo videoEncInfo = {
        .videoCodec = OH_H264,
        .videoBitrate = 2000000,
        .videoFrameRate = 30
    };

    OH_AudioInfo audioInfo = {
        .micCapInfo = micCapInfo,
        .innerCapInfo = innerCapInfo,
        .audioEncInfo = audioEncInfo
    };

    OH_VideoInfo videoInfo = {
        .videoCapInfo = videoCapInfo,
        .videoEncInfo = videoEncInfo
    };

    config = {
        .captureMode = OH_CAPTURE_HOME_SCREEN,
        .dataType = OH_CAPTURE_FILE, // 录屏数据类型，文件。
        .audioInfo = audioInfo,
        .videoInfo = videoInfo
    };
    // [End screenCapture_config]
}

void SetPCSpecifiedScreenConfigBuffer(OH_AVScreenCaptureConfig &config)
{
    // [Start screenCapture_PCSpecifiedScreenConfigBuffer]
    // 根据PC/2in1设备分辨率在config中配置录屏的宽度、高度。
    config.videoInfo.videoCapInfo.videoFrameWidth = PC_VIDEO_WIDTH;
    config.videoInfo.videoCapInfo.videoFrameHeight = PC_VIDEO_HEIGHT;

    // 设置录屏模式为OH_CAPTURE_SPECIFIED_SCREEN，传入屏幕Id。
    config.captureMode = OH_CAPTURE_SPECIFIED_SCREEN;
    config.videoInfo.videoCapInfo.displayId = 0;
    // [End screenCapture_PCSpecifiedScreenConfigBuffer]
}

void SetPCHomeScreenConfigBuffer(OH_AVScreenCaptureConfig &config)
{
    // [Start screenCapture_PCHomeScreenConfigBuffer]
    // 根据PC/2in1设备分辨率在config中配置录屏的宽度、高度。
    config.videoInfo.videoCapInfo.videoFrameWidth = PC_VIDEO_WIDTH;
    config.videoInfo.videoCapInfo.videoFrameHeight = PC_VIDEO_HEIGHT;

    // 设置录屏模式为OH_CAPTURE_HOME_SCREEN，传入屏幕Id。
    config.captureMode = OH_CAPTURE_HOME_SCREEN;
    // [End screenCapture_PCHomeScreenConfigBuffer]
}

void SetPCSpecifiedWindowScreenConfigBuffer(OH_AVScreenCaptureConfig &config)
{
    // [Start SetPCSpecifiedWindowScreenConfigBuffer]
    // 根据PC/2in1设备分辨率在config中配置录屏的宽度、高度。
    config.videoInfo.videoCapInfo.videoFrameWidth = PC_VIDEO_WIDTH;
    config.videoInfo.videoCapInfo.videoFrameHeight = PC_VIDEO_HEIGHT;

    // 设置录屏模式为OH_CAPTURE_SPECIFIED_WINDOW，传入屏幕Id。
    config.captureMode = OH_CAPTURE_SPECIFIED_WINDOW;
    config.videoInfo.videoCapInfo.displayId = 0;

    // (可选)若有期望录制的窗口，可传入单个窗口Id。
    g_missionIds = {61}; // 表示弹出的Picker默认选中61号窗口。
    config.videoInfo.videoCapInfo.missionIDs = g_missionIds.data();
    config.videoInfo.videoCapInfo.missionIDsLen = static_cast<int32_t>(g_missionIds.size());

    // 在配置参数结束后执行"g_missionIds.clear()"。
    // [End SetPCSpecifiedWindowScreenConfigBuffer]
}

void SetPCSpecifiedWindowScreenConfigBuffer2(OH_AVScreenCaptureConfig &config)
{
    // [Start SetPCSpecifiedWindowScreenConfigBuffer2]
    // 根据PC/2in1设备分辨率在config中配置录屏的宽度、高度。
    config.videoInfo.videoCapInfo.videoFrameWidth = PC_VIDEO_WIDTH;
    config.videoInfo.videoCapInfo.videoFrameHeight = PC_VIDEO_HEIGHT;

    // 设置录屏模式为OH_CAPTURE_SPECIFIED_WINDOW，传入屏幕Id。
    config.captureMode = OH_CAPTURE_SPECIFIED_WINDOW;
    config.videoInfo.videoCapInfo.displayId = 0;

    // 传入多个窗口Id。
    g_missionIds2 = {60, 61}; // 表示期望同时录制60、61号窗口。
    config.videoInfo.videoCapInfo.missionIDs = g_missionIds2.data();
    config.videoInfo.videoCapInfo.missionIDsLen = static_cast<int32_t>(g_missionIds2.size());

    // 在配置参数结束后执行"g_missionIds2.clear()"。
    // [End SetPCSpecifiedWindowScreenConfigBuffer2]
}

void SetStrategyForKeepCaptureDuringCall(OH_AVScreenCapture *capture)
{
    // [Start screenCapture_buffer_strategy_keepCaptureDuringCall]
    OH_AVScreenCapture_CaptureStrategy* strategy = OH_AVScreenCapture_CreateCaptureStrategy();
    OH_AVScreenCapture_StrategyForKeepCaptureDuringCall(strategy, true);
    OH_AVScreenCapture_SetCaptureStrategy(capture, strategy);
    OH_AVScreenCapture_ReleaseCaptureStrategy(strategy);
    // [End screenCapture_buffer_strategy_keepCaptureDuringCall]
}

void SetStrategyBFramesEncoding(OH_AVScreenCapture *capture)
{
    // [Start screenCapture_buffer_strategy_BFramesEncoding]
    OH_AVScreenCapture_CaptureStrategy* strategy = OH_AVScreenCapture_CreateCaptureStrategy();
    OH_AVScreenCapture_StrategyForBFramesEncoding(strategy, true);
    OH_AVScreenCapture_SetCaptureStrategy(capture, strategy);
    OH_AVScreenCapture_ReleaseCaptureStrategy(strategy);
    // [End screenCapture_buffer_strategy_BFramesEncoding]
}

void SetStrategyForPickerPopUp(OH_AVScreenCapture *capture)
{
    // [Start screenCapture_buffer_strategy_pickerPopUp]
    // 创建CaptureStrategy对象。
    OH_AVScreenCapture_CaptureStrategy* strategy = OH_AVScreenCapture_CreateCaptureStrategy();

    // 设置是否弹出屏幕捕获Picker。
    // 设置为true，代表录屏启动后统一弹出Picker。
    OH_AVScreenCapture_StrategyForPickerPopUp(strategy, true);

    // 设置CaptureStrategy到AVScreenCapture实例。
    OH_AVScreenCapture_SetCaptureStrategy(capture, strategy);

    // 释放CaptureStrategy对象。
    OH_AVScreenCapture_ReleaseCaptureStrategy(strategy);
    // [End screenCapture_buffer_strategy_pickerPopUp]
}

void SetStrategyForCanvasFollowRotation(OH_AVScreenCapture *capture)
{
    // [Start screenCapture_buffer_strategy_canvasFollowRotation]
    OH_AVScreenCapture_CaptureStrategy* strategy = OH_AVScreenCapture_CreateCaptureStrategy();
    // 设为true，表示跟随屏幕旋转，并在横竖屏旋转后，自动调换虚拟屏尺寸，确保输出画面及时跟随旋转。
    OH_AVScreenCapture_StrategyForCanvasFollowRotation(strategy, true);
    OH_AVScreenCapture_SetCaptureStrategy(capture, strategy);
    OH_AVScreenCapture_ReleaseCaptureStrategy(strategy);
    // [End screenCapture_buffer_strategy_canvasFollowRotation]
}

void SetStrategyForPrivacyMaskMode(OH_AVScreenCapture *capture)
{
    // [Start screenCapture_buffer_strategy_privacyMaskMode]
    // value值设为0，表示全屏屏蔽模式。value值设为1，表示窗口屏蔽模式。默认为全屏屏蔽模式。开发者可根据实际需求选择合适取值。
    int value = PRIVACY_MASK_MODE_FULL_SCREEN;
    OH_AVScreenCapture_CaptureStrategy* strategy = OH_AVScreenCapture_CreateCaptureStrategy();
    OH_AVScreenCapture_StrategyForPrivacyMaskMode(strategy, value);
    OH_AVScreenCapture_SetCaptureStrategy(capture, strategy);
    OH_AVScreenCapture_ReleaseCaptureStrategy(strategy);
    // [End screenCapture_buffer_strategy_privacyMaskMode]
}

void SkipPrivacyMode(OH_AVScreenCapture *capture)
{
    // [Start screenCapture_buffer_skipPrivacyMode]
    std::vector<int> windowIdsSkipPrivacy = {};
    OH_AVScreenCapture_SkipPrivacyMode(capture, windowIdsSkipPrivacy.empty() ? nullptr : &windowIdsSkipPrivacy[0],
        static_cast<int32_t>(windowIdsSkipPrivacy.size()));
    // [End screenCapture_buffer_skipPrivacyMode]
}

void SetCaptureArea(OH_AVScreenCapture *capture)
{
    // [Start screenCapture_buffer_setCaptureArea]
    OH_Rect* region = new OH_Rect;
    region->x = 0;
    region->y = 0;
    region->width = CAPTURE_REGION_SIZE;
    region->height = CAPTURE_REGION_SIZE;
    uint64_t regionDisplayId = 0; // 传入矩形区域所在的屏幕Id。
    OH_AVScreenCapture_SetCaptureArea(capture, regionDisplayId, region);
    delete region;
    region = nullptr;
    // [End screenCapture_buffer_setCaptureArea]
}

void ExcludeContent(OH_AVScreenCapture *capture)
{
    // [Start screenCapture_buffer_excludeContent]
    OH_AVScreenCapture_ContentFilter *contentFilter = OH_AVScreenCapture_CreateContentFilter();
    // 添加过滤通知音。
    OH_AVScreenCapture_ContentFilter_AddAudioContent(contentFilter, OH_SCREEN_CAPTURE_NOTIFICATION_AUDIO);
    // 排除指定窗口id。
    std::vector<int> windowIdsExclude = {};
    OH_AVScreenCapture_ContentFilter_AddWindowContent(contentFilter, windowIdsExclude.empty() ?
        nullptr : &windowIdsExclude[0], static_cast<int32_t>(windowIdsExclude.size()));

    OH_AVScreenCapture_ExcludeContent(capture, contentFilter);
    OH_AVScreenCapture_ReleaseContentFilter(contentFilter);
    contentFilter = nullptr;
    // [End screenCapture_buffer_excludeContent]
}

void SetSpecifiedWindowIdForWindowCapture(OH_AVScreenCaptureConfig &config)
{
    // [Start screenCapture_withWindow_forID]
    // 如果期望录制单个窗口，需传入单个窗口ID；如果期望同时录制多个窗口，需传入期望录制的窗口ID列表。
    g_missionIds = {g_windowId}; // 指定录制的窗口ID。
    config.videoInfo.videoCapInfo.missionIDs = g_missionIds.data();
    config.videoInfo.videoCapInfo.missionIDsLen = static_cast<int32_t>(g_missionIds.size());
    config.captureMode = OH_CAPTURE_SPECIFIED_WINDOW; // 设置录屏模式为录制指定窗口。

    // 设置为false，代表录屏启动后不弹出系统Picker，弹出隐私提示弹窗。
    OH_AVScreenCapture_CaptureStrategy* strategy = OH_AVScreenCapture_CreateCaptureStrategy();
    OH_AVScreenCapture_StrategyForPickerPopUp(strategy, false);
    OH_AVScreenCapture_SetCaptureStrategy(capture, strategy);
    // [End screenCapture_withWindow_forID]
}

// [Start screenCapture_config_buffer_callback]
// 设置回调。
// 错误事件发生回调函数OnError()。
void OnError(OH_AVScreenCapture *capture, int32_t errorCode, void *userData)
{
    (void)capture;
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OnError errorCode is %{public}d", errorCode);
    (void)userData;
}

// 状态变更事件处理函数OnStateChange()。
void OnStateChange(struct OH_AVScreenCapture *capture, OH_AVScreenCaptureStateCode stateCode, void *userData)
{
    if (stateCode == OH_SCREEN_CAPTURE_STATE_STARTED) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OnStateChange started");
        // 处理状态变更
        // 可选 配置录屏旋转
        int32_t ret = OH_AVScreenCapture_SetCanvasRotation(capture, true);
        // 可选 修改Canvas分辨率
        ret = OH_AVScreenCapture_ResizeCanvas(g_avCapture, CANVAS_RESIZE_WIDTH, CANVAS_RESIZE_HEIGHT);
        // 可选 设置是否显示光标
        ret = OH_AVScreenCapture_ShowCursor(g_avCapture, true);
        // 可选 设置视频最大帧率
        ret = OH_AVScreenCapture_SetMaxVideoFrameRate(g_avCapture, CAPTURE_VIDEO_FRAME_RATE);
    }
    if (stateCode == OH_SCREEN_CAPTURE_STATE_INTERRUPTED_BY_OTHER) {
        // 处理状态变更
    }
    (void)userData;
}

// [Start screenCapture_config_buffer_OnBufferAvailable]
// 获取并处理音视频原始码流数据回调函数OnBufferAvailable()。
void HandleVideoBuffer(OH_AVBuffer *buffer)
{
    OH_NativeBuffer *nativebuffer = OH_AVBuffer_GetNativeBuffer(buffer);
    if (nativebuffer == nullptr) {
        return;
    }
    int bufferLen = OH_AVBuffer_GetCapacity(buffer);
    OH_AVCodecBufferAttr info;
    int32_t ret = OH_AVBuffer_GetBufferAttr(buffer, &info);
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture size %{public}d", info.size);
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture bufferLen %{public}d", bufferLen);

    OH_NativeBuffer_Config config;
    OH_NativeBuffer_GetConfig(nativebuffer, &config);
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture height %{public}d width %{public}d",
        config.height, config.width);
    uint8_t *buf = OH_AVBuffer_GetAddr(buffer);
    if (buf == nullptr) {
        return;
    }
    size_t written = fwrite(buf, 1, bufferLen, g_vFile);
    if (written != bufferLen) {
        OH_LOG_ERROR(LOG_APP, "fwrite failed");
    }
    OH_NativeBuffer_Unreference(nativebuffer);
    buffer = nullptr;
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OnBufferAvailable inner audio");
}

void HandleAudioBuffer(OH_AVBuffer *buffer, FILE *file, const char *logMsg)
{
    int bufferLen = OH_AVBuffer_GetCapacity(buffer);
    uint8_t *buf = OH_AVBuffer_GetAddr(buffer);
    if (buf == nullptr) {
        return;
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OnBufferAvailable inner audio");
    size_t written = fwrite(buf, 1, bufferLen, g_innerFile);
    if (written != bufferLen) {
        OH_LOG_ERROR(LOG_APP, "fwrite failed");
    }
}

void OnBufferAvailable(OH_AVScreenCapture *capture, OH_AVBuffer *buffer, OH_AVScreenCaptureBufferType bufferType,
                       int64_t timestamp, void *userData)
{
    if (!g_isRunning) {
        return;
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OnBufferAvailable bufferType is %{public}d",
        bufferType);
    if (bufferType == OH_SCREEN_CAPTURE_BUFFERTYPE_VIDEO) {
        // 处理视频buffer
        HandleVideoBuffer(buffer);
    } else if (bufferType == OH_SCREEN_CAPTURE_BUFFERTYPE_AUDIO_INNER) {
        // 处理内录buffer
        HandleAudioBuffer(buffer, g_innerFile, "ScreenCapture OnBufferAvailable inner audio");
    } else if (bufferType == OH_SCREEN_CAPTURE_BUFFERTYPE_AUDIO_MIC) {
        // 处理麦克风buffer
        HandleAudioBuffer(buffer, g_micFile, "ScreenCapture OnBufferAvailable mic audio");
    }
    return;
}
// [End screenCapture_config_buffer_OnBufferAvailable]
// 设置获取录屏屏幕Id的回调函数OnDisplaySelected()。
void OnDisplaySelected(struct OH_AVScreenCapture *capture, uint64_t displayId, void *userData)
{
    (void)capture;
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OnError errorCode is %{public}uld", displayId);
    (void)userData;
}

void SetCallback(struct OH_AVScreenCapture *capture)
{
    OH_AVScreenCapture_SetErrorCallback(capture, OnError, nullptr);
    OH_AVScreenCapture_SetStateCallback(capture, OnStateChange, nullptr);
    OH_AVScreenCapture_SetDataCallback(capture, OnBufferAvailable, nullptr);
    OH_AVScreenCapture_SetDisplayCallback(capture, OnDisplaySelected, nullptr);
}
// [End screenCapture_config_buffer_callback]

// 开始录屏原始码流
static napi_value StartScreenCapture_01(napi_env env, napi_callback_info info)
{
// [Start screenCapture_create_buffer]
    g_avCapture = OH_AVScreenCapture_Create();
// [End screenCapture_create_buffer]
    if (g_avCapture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "create screen capture failed");
    }
    OH_AVScreenCaptureConfig config_;
    SetConfig01(config_);
    OpenFile("Demo");
    SetCallback(g_avCapture);
    // 可选，排除指定窗口/指定音频类型 start
    ExcludeContent(g_avCapture);
    // 可选，排除指定窗口/指定音频类型 end
    // 可选，设置是否捕获光标
    // [Start screenCapture_buffer_showCursor]
    OH_AVScreenCapture_ShowCursor(capture, false);
    // [End screenCapture_buffer_showCursor]
    // 可选，设置最大帧率
    // [Start screenCapture_buffer_setMaxVideoFrameRate]
    OH_AVScreenCapture_SetMaxVideoFrameRate(capture, CAPTURE_VIDEO_FRAME_RATE);
    // [End screenCapture_buffer_setMaxVideoFrameRate]
    // 可选，设置屏幕分辨率
    // [Start screenCapture_buffer_resizeCanvas]
    OH_AVScreenCapture_ResizeCanvas(capture, CANVAS_RESIZE_WIDTH, CANVAS_RESIZE_HEIGHT);
    // [End screenCapture_buffer_resizeCanvas]
    OH_AVSCREEN_CAPTURE_ErrCode result = AV_SCREEN_CAPTURE_ERR_OPERATE_NOT_PERMIT;
    result = OH_AVScreenCapture_Init(g_avCapture, config);
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init failed %{public}d", result);
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init %{public}d", result);
    g_missionIds.clear();
    g_missionIds2.clear();
    // [Start screenCapture_startScreenCapture]
    result = OH_AVScreenCapture_StartScreenCapture(g_avCapture);
    // [End screenCapture_startScreenCapture]
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started failed %{public}d", result);
        OH_AVScreenCapture_Release(g_avCapture);
        g_avCapture = nullptr;
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started %{public}d", result);

    g_isRunning = true;

    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 开始录屏存文件
static napi_value StartScreenCapture_02(napi_env env, napi_callback_info info)
{
    // [Start screenCapture_create_for_file]
    g_avCapture = OH_AVScreenCapture_Create();
    // [End screenCapture_create_for_file]
    if (g_avCapture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "create screen capture failed");
    }
    OH_AVScreenCaptureConfig config_;

    OH_RecorderInfo recorderInfo;
    // 获取沙箱路径
    char *fileDirPath;
    int32_t bufferSize = 1000;
    int32_t writeLength = 0;
    AbilityRuntime_ErrorCode result = OH_AbilityRuntime_ApplicationContextGetFilesDir(fileDirPath, bufferSize, &writeLength);
    if (!fileDirPath) {
        napi_value errCode;
        napi_create_double(env, result, &errCode);
        return errCode;
    }
    const std::string filePath = fileDirPath;
    g_fileOutputFd = open((filePath + "saving_file.mp4").c_str(), O_RDWR | O_CREAT, FILE_PERMISSION_FULL_ACCESS);
    std::string fileUrl = "fd://" + std::to_string(g_fileOutputFd);
    recorderInfo.url = const_cast<char *>(fileUrl.c_str());
    recorderInfo.fileFormat = OH_ContainerFormatType::CFT_MPEG_4;
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture fileUrl %{public}s", fileUrl.c_str());

    SetConfig02(config_);
    config_.captureMode = OH_CAPTURE_HOME_SCREEN;
    config_.dataType = OH_CAPTURE_FILE;
    config_.recorderInfo = recorderInfo;
    bool isMicrophone = true;
    OH_AVScreenCapture_SetMicrophoneEnabled(g_avCapture, isMicrophone);
    OH_AVScreenCapture_SetStateCallback(g_avCapture, OnStateChange, nullptr);
    OH_AVScreenCapture_SetDisplayCallback(g_avCapture, OnDisplaySelected, nullptr);
    OH_AVSCREEN_CAPTURE_ErrCode result = OH_AVScreenCapture_Init(g_avCapture, config_);
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init failed %{public}d", result);
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init %{public}d", result);
    // [Start screenCapture_startScreenRecording_for_file]
    result = OH_AVScreenCapture_StartScreenRecording(g_avCapture);
    // [End screenCapture_startScreenRecording_for_file]
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started failed %{public}d", result);
        OH_AVScreenCapture_Release(g_avCapture);
        g_avCapture = nullptr;
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started %{public}d", result);

    m_scSaveFileIsRunning = true;
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 开始录屏原始码流SurfaceMode
void ThreadVideoRunMethod()
{
    while (m_scSurfaceIsRunning) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ThreadVideoRunMethod m_scSurfaceIsRunning %{public}d",
            m_scSurfaceIsRunning);
        if (!isStarted_.load()) {
            return;
        }
        std::unique_lock<std::mutex> lock(g_encContext->outputMutex_);
        bool condRet = g_encContext->outputCond_.wait_for(
            lock, 2s, [&]() { return !isStarted_.load() || !g_encContext->outputBufferInfoQueue_.empty(); });
        if (!isStarted_.load()) {
            return;
        }
        if (g_encContext->outputBufferInfoQueue_.empty()) {
            continue;
        }
        CodecBufferInfo bufferInfo = g_encContext->outputBufferInfoQueue_.front();
        g_encContext->outputBufferInfoQueue_.pop();    
             if (bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS) {
                lock.unlock();
                 break;
             }
        lock.unlock();
        if (bufferInfo.buffer != nullptr) {
            if (g_lastFrameTimestampPts == 0) {
                g_lastFrameTimestampPts = bufferInfo.attr.pts;
                bufferInfo.attr.pts = 0;
            } else {
                g_lastFrameEncodePts += (bufferInfo.attr.pts - g_lastFrameTimestampPts) / MICROSECOND_PER_MILLISECOND;
                g_lastFrameTimestampPts = bufferInfo.attr.pts;
                bufferInfo.attr.pts = g_lastFrameEncodePts;
            }
            g_muxer->WriteSample(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer), bufferInfo.attr);
        }
        OH_VideoEncoder_FreeOutputBuffer(g_videoEnc, bufferInfo.bufferIndex);
    }
}

int SetFormat()
{
    OH_AVFormat *format = OH_AVFormat_Create();
    // 配置视频帧速率
    double frameRate = 30.0;
    // 配置视频YUV值范围标志
    bool rangeFlag = false;
    // 配置视频原色
    int32_t primary = static_cast<int32_t>(OH_ColorPrimary::COLOR_PRIMARY_BT709);
    // 配置传输特性
    int32_t transfer = static_cast<int32_t>(OH_TransferCharacteristic::TRANSFER_CHARACTERISTIC_BT709);
    // 配置最大矩阵系数
    int32_t matrix = static_cast<int32_t>(OH_MatrixCoefficient::MATRIX_COEFFICIENT_IDENTITY);
    // 配置编码Profile
    int32_t profile = static_cast<int32_t>(OH_AVCProfile::AVC_PROFILE_BASELINE);
    // 配置编码比特率模式
    int32_t rateMode = static_cast<int32_t>(OH_VideoEncodeBitrateMode::CBR);
    // 配置关键帧的间隔，单位为毫秒
    int32_t iFrameInterval = 23000;
    // 配置所需的编码质量。只有在恒定质量模式下配置的编码器才支持此配置
    int32_t quality = 0;
    // 配置比特率
    int64_t bitRate = 2000000;
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_WIDTH, DEFAULT_WIDTH);
    sampleInfo_.videoWidth = DEFAULT_WIDTH;
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_HEIGHT, DEFAULT_HEIGHT);
    sampleInfo_.videoHeight = DEFAULT_HEIGHT;
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_PIXEL_FORMAT, DEFAULT_PIXELFORMAT);
    OH_AVFormat_SetDoubleValue(format, OH_MD_KEY_FRAME_RATE, frameRate);
    sampleInfo_.frameRate = frameRate;
    sampleInfo_.videoCodecMime = sampleInfo_.codecMime.data();
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_RANGE_FLAG, rangeFlag);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_COLOR_PRIMARIES, primary);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_TRANSFER_CHARACTERISTICS, transfer);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_MATRIX_COEFFICIENTS, matrix);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_I_FRAME_INTERVAL, iFrameInterval);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_PROFILE, profile);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_VIDEO_ENCODE_BITRATE_MODE, rateMode);
    OH_AVFormat_SetLongValue(format, OH_MD_KEY_BITRATE, bitRate);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_QUALITY, quality);
    int result = OH_VideoEncoder_Configure(g_videoEnc, format);
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== OH_VideoEncoder_Configure ret=%{public}d", result);
    OH_AVFormat_Destroy(format);
    return result;
}

int GetInputSurface()
{
    // 获取需要输入的Surface，以进行编码
    OH_AVCapability *capability = OH_AVCodec_GetCapability(OH_AVCODEC_MIMETYPE_VIDEO_AVC, true);
    const char *name = OH_AVCapability_GetName(capability);
    g_videoEnc = OH_VideoEncoder_CreateByName(name);
    g_muxer = std::make_unique<Muxer>();
    const std::string filePath = "/data/storage/el2/base/files/";
    g_surfaceOutputFd = open((filePath + "surface.mp4").c_str(), O_RDWR | O_CREAT, FILE_PERMISSION_FULL_ACCESS);
    g_muxer->Create(g_surfaceOutputFd);
    g_encContext = new CodecUserData;
    g_encContext->sampleInfo = &sampleInfo_;
    // 配置异步回调，调用 OH_VideoEncoder_SetCallback 接口
    OH_VideoEncoder_RegisterCallback(g_videoEnc,
                                     {SampleCallback::OnError, SampleCallback::OnStreamChanged,
                                     SampleCallback::OnNeedInputBuffer, SampleCallback::OnNewOutputBuffer},
                                     g_encContext);
    (void)SetFormat();
    // 从视频编码器获取输入Surface
    OHNativeWindow *nativeWindow;
    int result = OH_VideoEncoder_GetSurface(g_videoEnc, &nativeWindow);
    if (result != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started OH_VideoEncoder_GetSurface ret=%{public}d",
            result);
        return result;
    }
    result = OH_VideoEncoder_Prepare(g_videoEnc);
    g_muxer->Config(sampleInfo_);
    g_muxer->Start();
    // 启动编码器
    result = OH_VideoEncoder_Start(g_videoEnc);
    isStarted_.store(true);
    m_scSurfaceIsRunning = true;
    g_lastFrameTimestampPts = 0;
    g_lastFrameEncodePts = 0;
    inputVideoThread_ = std::make_unique<std::thread>(ThreadVideoRunMethod);
    // 指定surface开始录屏
    result = OH_AVScreenCapture_StartScreenCaptureWithSurface(g_avCapture, nativeWindow);
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started failed %{public}d", result);
        OH_AVScreenCapture_Release(g_avCapture);
        g_avCapture = nullptr;
        return result;
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started %{public}d", result);
    return result;
}

static napi_value StartScreenCapture_03(napi_env env, napi_callback_info info)
{
    isStarted_.store(false);
    inputVideoThread_ = nullptr;
    g_encContext = nullptr;
    g_avCapture = OH_AVScreenCapture_Create();
    if (g_avCapture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "create screen capture failed");
    }
    OH_AVScreenCaptureConfig config_;
    SetConfig02(config_);
    bool isMicrophone = false;
    OH_AVScreenCapture_SetMicrophoneEnabled(g_avCapture, isMicrophone);
    OH_AVScreenCapture_SetErrorCallback(g_avCapture, OnError, nullptr);
    OH_AVScreenCapture_SetStateCallback(g_avCapture, OnStateChange, nullptr);
    OH_AVScreenCapture_SetDataCallback(g_avCapture, OnBufferAvailable, nullptr);
    OH_AVScreenCapture_SetDisplayCallback(g_avCapture, OnDisplaySelected, nullptr);
    int result = OH_AVScreenCapture_Init(g_avCapture, config_);
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init failed %{public}d", result);
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init %{public}d", result);
    (void)GetInputSurface();
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

static napi_value setWindowIdForWindow(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_typedarray_type type_napi;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_int32(env, args[0], &g_windowId);

    OH_LOG_Print(LOG_APP, LOG_INFO, 0x0, "setWindowIdForWindow", "get windowId %{public}d", g_windowId);

    return nullptr;
}

// 开始窗口级录屏
static napi_value StartScreenCapture_04(napi_env env, napi_callback_info info)
{
// [Start screenCapture_create]
    g_avCapture = OH_AVScreenCapture_Create();
// [End screenCapture_create]
    if (g_avCapture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "create screen capture failed");
    }
    OH_AVScreenCaptureConfig config_;

    OH_RecorderInfo recorderInfo;
    // 获取沙箱路径
    char *fileDirPath;
    int32_t bufferSize = 1000;
    int32_t writeLength = 0;
    AbilityRuntime_ErrorCode result = OH_AbilityRuntime_ApplicationContextGetFilesDir(fileDirPath, bufferSize, &writeLength);
    if (!fileDirPath) {
        napi_value errCode;
        napi_create_double(env, result, &errCode);
        return errCode;
    }
    const std::string filePath = fileDirPath;
    g_windowOutputFd = open((filePath + "saving_window_file.mp4").c_str(), O_RDWR | O_CREAT,
        FILE_PERMISSION_FULL_ACCESS);
    std::string fileUrl = "fd://" + std::to_string(g_windowOutputFd);
    recorderInfo.url = const_cast<char *>(fileUrl.c_str());
    recorderInfo.fileFormat = OH_ContainerFormatType::CFT_MPEG_4;
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture fileUrl %{public}s", fileUrl.c_str());

    SetConfig02(config_);
    
    // 设置录屏模式为OH_CAPTURE_SPECIFIED_WINDOW
    config_.captureMode = OH_CAPTURE_SPECIFIED_WINDOW;
    config_.dataType = OH_CAPTURE_FILE;
    config_.recorderInfo = recorderInfo;

    // [Start screenCapture_withWindow_forPicker]
    // 通过弹出屏幕捕获Picker列表方式，选择已打开的应用窗口进行窗口级录屏。
    OH_AVScreenCapture_CaptureStrategy *strategy = OH_AVScreenCapture_CreateCaptureStrategy();
    OH_AVScreenCapture_StrategyForPickerPopUp(strategy, true);
    OH_AVScreenCapture_SetCaptureStrategy(g_avCapture, strategy);
    // [End screenCapture_withWindow_forPicker]

    // 可选，传入期望录制的窗口ID进行录屏。
    SetSpecifiedWindowIdForWindowCapture(config_);
    g_missionIds.clear();

    bool isMicrophone = true;
    OH_AVScreenCapture_SetMicrophoneEnabled(g_avCapture, isMicrophone);
    OH_AVScreenCapture_SetStateCallback(g_avCapture, OnStateChange, nullptr);
    OH_AVScreenCapture_SetDisplayCallback(g_avCapture, OnDisplaySelected, nullptr);
    OH_AVSCREEN_CAPTURE_ErrCode result = OH_AVScreenCapture_Init(g_avCapture, config_);
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init failed %{public}d", result);
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init %{public}d", result);
    // [Start screenCapture_startScreenRecording]
    result = OH_AVScreenCapture_StartScreenRecording(g_avCapture);
    // [End screenCapture_startScreenRecording]
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started failed %{public}d", result);
    // [Start screenCapture_releaseScreenRecording]
        OH_AVScreenCapture_Release(g_avCapture);
        g_avCapture = nullptr;
    // [End screenCapture_releaseScreenRecording]
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started %{public}d", result);

    m_scSaveFileIsRunning = true;
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

void SetConfig05(OH_AVScreenCaptureConfig &config)
{
    OH_AudioCaptureInfo micCapInfo = {.audioSampleRate = 48000, .audioChannels = 2, .audioSource = OH_MIC};
    OH_AudioCaptureInfo innerCapInfo = {.audioSampleRate = 48000, .audioChannels = 2, .audioSource = OH_ALL_PLAYBACK};
    OH_AudioEncInfo audioEncInfo = {.audioBitrate = 128000, .audioCodecformat = OH_AAC_LC};

    OH_AudioInfo audioInfo = {
        .micCapInfo = micCapInfo,
        .innerCapInfo = innerCapInfo,
        .audioEncInfo = audioEncInfo
    };
    // 获取屏幕信息
    uint64_t displayId = 0;
    NativeDisplayManager_ErrorCode ret = OH_NativeDisplayManager_GetDefaultDisplayId(&displayId);

    NativeDisplayManager_DisplayInfo* displayInfo = nullptr;
    ret = OH_NativeDisplayManager_CreateDisplayById(displayId, &displayInfo);
    if (ret != DISPLAY_MANAGER_OK || !displayInfo) {
        napi_value res;
        napi_create_int32(env, ret, &res);
        return res;
    }
    int32_t screenWidth = displayInfo->width;
    int32_t screenHeight = displayInfo->height;
    OH_VideoCaptureInfo videoCapInfo = {.videoFrameWidth = screenWidth, .videoFrameHeight = screenHeight,
                                        .videoSource = OH_VIDEO_SOURCE_SURFACE_RGBA};
    OH_VideoEncInfo videoEncInfo = {.videoCodec = OH_H264, .videoBitrate = 2000000, .videoFrameRate = 30};

    OH_VideoInfo videoInfo = {
        .videoCapInfo = videoCapInfo,
        .videoEncInfo = videoEncInfo
    };
    config = {.captureMode = OH_CAPTURE_HOME_SCREEN, // 录屏模式设置。
              .dataType = OH_ORIGINAL_STREAM,
              .audioInfo = audioInfo,
              .videoInfo = videoInfo};
}

// 开始矩形区域录制
static napi_value StartScreenCapture_05(napi_env env, napi_callback_info info)
{
    // [Start screenCapture_startScreenCapture_rectangular]
    g_avCapture = OH_AVScreenCapture_Create();
    if (g_avCapture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "create screen capture failed");
    }
    OpenFile("Demo");
    SetCallback(g_avCapture);
    // 初始化录屏，传入配置信息OH_AVScreenRecorderConfig。
    OH_AVScreenCaptureConfig config;
    SetConfig05(config);
    OH_AVSCREEN_CAPTURE_ErrCode result = OH_AVScreenCapture_Init(g_avCapture, config);
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init failed %{public}d",
            result);
    }
    // 1. 可选，可以根据需要设置区域坐标和大小，设置想要捕获的区域，如下方创建了一个从（0, 0）为起点的长100，宽100的矩形区域。
    OH_Rect* region = new OH_Rect;
    region->x = 0;
    region->y = 0;
    region->width = CAPTURE_REGION_SIZE;
    region->height = CAPTURE_REGION_SIZE;
    // 2.传入矩形区域所在的屏幕Id。
    uint64_t regionDisplayId = 0;
    OH_AVScreenCapture_SetCaptureArea(capture, regionDisplayId, region);
    // 开始录屏。
    result = OH_AVScreenCapture_StartScreenCapture(g_avCapture);
    // [End screenCapture_startScreenCapture_rectangular]
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started failed %{public}d", result);
        OH_AVScreenCapture_Release(g_avCapture);
        g_avCapture = nullptr;
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Started %{public}d", result);

    g_isRunning = true;
    delete region;
    region = nullptr;

    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

static void StopSurfaceCapture()
{
    if (!m_scSurfaceIsRunning) {
        return;
    }
    (void)OH_VideoEncoder_NotifyEndOfStream(g_videoEnc);
    (void)OH_VideoEncoder_Stop(g_videoEnc);
    (void)OH_VideoEncoder_Destroy(g_videoEnc);
    g_videoEnc = nullptr;
    g_muxer->Stop();
    g_muxer.reset();
    m_scSurfaceIsRunning = false;
    isStarted_.store(false);
    if (inputVideoThread_ && inputVideoThread_->joinable()) {
        inputVideoThread_->join();
    }
    if (g_surfaceOutputFd != -1) {
        close(g_surfaceOutputFd);
        g_surfaceOutputFd = -1;
    }
}

static napi_value StopScreenCapture(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture Stop");
    OH_AVSCREEN_CAPTURE_ErrCode result = AV_SCREEN_CAPTURE_ERR_OPERATE_NOT_PERMIT;
    napi_value res;
    StopSurfaceCapture();
    if (g_avCapture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "capture_ is null.");
    }
    if (m_scSaveFileIsRunning) {
        // [Start screenCapture_stopScreenRecording]
        result = OH_AVScreenCapture_StopScreenRecording(g_avCapture);
        // [End screenCapture_stopScreenRecording]
        if (result != AV_SCREEN_CAPTURE_ERR_BASE) {
            OH_LOG_ERROR(LOG_APP, "StopScreenCapture OH_AVScreenCapture_StopScreenRecording Result: %{public}d",
                result);
        }
        // [Start screenCapture_releaseScreenRecording_for_file]
        result = OH_AVScreenCapture_Release(g_avCapture);
        // [End screenCapture_releaseScreenRecording_for_file]
        if (result != AV_SCREEN_CAPTURE_ERR_BASE) {
            OH_LOG_ERROR(LOG_APP, "StopScreenCapture OH_AVScreenCapture_Release: %{public}d", result);
        }
        OH_LOG_INFO(LOG_APP, "OH_AVScreenCapture_Release success");
        g_avCapture = nullptr;
        m_scSaveFileIsRunning = false;
        if (g_fileOutputFd != -1) {
            close(g_fileOutputFd);
            g_fileOutputFd = -1;
        }
        if (g_windowOutputFd != -1) {
            close(g_windowOutputFd);
            g_windowOutputFd = -1;
        }
    } else {
        // [Start screenCapture_stopScreenCapture]
        result = OH_AVScreenCapture_StopScreenCapture(g_avCapture);
        // [End screenCapture_stopScreenCapture]
        if (result != AV_SCREEN_CAPTURE_ERR_BASE) {
            OH_LOG_ERROR(LOG_APP, "StopScreenCapture OH_AVScreenCapture_StopScreenCapture Result: %{public}d", result);
        }
        // [Start screenCapture_releaseScreenCapture]
        result = OH_AVScreenCapture_Release(g_avCapture);
        if (result != AV_SCREEN_CAPTURE_ERR_BASE) {
            OH_LOG_ERROR(LOG_APP, "StopScreenCapture OH_AVScreenCapture_Release: %{public}d", result);
        }
        OH_LOG_INFO(LOG_APP, "OH_AVScreenCapture_Release success");
        g_avCapture = nullptr;
        // [End screenCapture_releaseScreenCapture]
        CloseFile();
        g_isRunning = false;
    }
    napi_create_int32(env, result, &res);
    return res;
}

// 调用老接口，仅提供代码实现，不建议使用
void MockOnAudioBufferAvailable(OH_AVScreenCapture *screenCapture, bool isReady, OH_AudioCaptureSourceType type)
{
    if (isReady == true) {
        OH_AudioBuffer *audioBuffer = (OH_AudioBuffer *)malloc(sizeof(OH_AudioBuffer));
        if (audioBuffer == nullptr) {
            OH_LOG_INFO(LOG_APP, "audio buffer is nullptr");
            return;
        }
        if (OH_AVScreenCapture_AcquireAudioBuffer(screenCapture, &audioBuffer, type) == AV_SCREEN_CAPTURE_ERR_OK) {
            if ((g_micFile != nullptr) && (audioBuffer->buf != nullptr) && (type == OH_MIC)) {
                fwrite(audioBuffer->buf, 1, audioBuffer->size, g_micFile);
                free(audioBuffer->buf);
                audioBuffer->buf = nullptr;
            } else if ((g_innerFile != nullptr) && (audioBuffer->buf != nullptr) && (type == OH_ALL_PLAYBACK)) {
                fwrite(audioBuffer->buf, 1, audioBuffer->size, g_innerFile);
                free(audioBuffer->buf);
                audioBuffer->buf = nullptr;
            }
            free(audioBuffer);
            audioBuffer = nullptr;
        }
        // do something
        OH_AVScreenCapture_ReleaseAudioBuffer(screenCapture, type);
    } else {
        OH_LOG_INFO(LOG_APP, "AcquireAudioBuffer failed");
    }
}

// 调用老接口，仅提供代码实现，不建议使用
void MockOnVideoBufferAvailable(OH_AVScreenCapture *screenCapture, bool isReady) 
{
    if (isReady == true) {
        int32_t fence = 0;
        int64_t timestamp = 0;
        int32_t size = 4;
        OH_Rect damage;
        OH_NativeBuffer_Config config;
        OH_NativeBuffer *nativeBuffer =
            OH_AVScreenCapture_AcquireVideoBuffer(screenCapture, &fence, &timestamp, &damage);
        if (nativeBuffer != nullptr) {
            OH_NativeBuffer_GetConfig(nativeBuffer, &config);
            int32_t length = config.height * config.width * size;
            OH_NativeBuffer_Unreference(nativeBuffer);
        } else {
            OH_LOG_INFO(LOG_APP, "AcquireVideoBuffer failed");
        }
        // do something
        OH_AVScreenCapture_ReleaseVideoBuffer(screenCapture);
    }
}

// 调用老接口，仅提供代码实现，不建议使用
void MockOnError(OH_AVScreenCapture *screenCapture, int32_t errorCode) 
{
    // 错误处理
}

// 调用老接口，仅提供代码实现，不建议使用
void SetScreenCaptureCallback()
{
    struct OH_AVScreenCaptureCallback callback;
    callback.onAudioBufferAvailable = MockOnAudioBufferAvailable;
    callback.onVideoBufferAvailable = MockOnVideoBufferAvailable;
    callback.onError = MockOnError;
    OH_AVScreenCapture_SetCallback(g_avCapture, callback);
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"startScreenCapture", nullptr, StartScreenCapture_01, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopScreenCapture", nullptr, StopScreenCapture, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startCaptureAsFile", nullptr, StartScreenCapture_02, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startScreenCaptureWithSurface", nullptr, StartScreenCapture_03, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"startScreenCaptureWithWindow", nullptr, StartScreenCapture_04, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"setWindowId", nullptr, setWindowIdForWindow, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterScreencaptureModule(void) { napi_module_register(&demoModule); }
