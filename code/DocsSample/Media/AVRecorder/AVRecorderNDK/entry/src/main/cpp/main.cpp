/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <iostream>
#include "main.h"
#include "napi/native_api.h"
#include "camera_manager.h"

#define LOG_DOMAIN 0x3200
#define LOG_TAG "MY_NDKDEMO"
#include <inttypes.h>

using namespace std;
using namespace OHOS_CAMERA_SAMPLE;
static NDKCamera* ndkCamera_ = nullptr;

// 设置视频分辨率
int videoFrameWidth = 1280;
int videoFrameHeight = 720;

// 配置参数，可选三种录制模式
// Type 1: 音视频录制
void SetConfig(OH_AVRecorder_Config &config)
{
    config.audioSourceType = AVRECORDER_MIC;
    config.videoSourceType = AVRECORDER_SURFACE_YUV;

    // 配置音频参数 比特率 96000
    config.profile.audioBitrate = 96000;
    // 配置音频参数 声道数 2
    config.profile.audioChannels = 2;
    // 配置音频参数 编码格式 aac
    config.profile.audioCodec = AVRECORDER_AUDIO_AAC;
    // 配置音频参数 采样率 48000
    config.profile.audioSampleRate = 48000;

    // 配置视频参数 比特率 2000000
    config.profile.videoBitrate = 2000000;
    // 配置视频参数 宽度
    config.profile.videoFrameWidth = videoFrameWidth;
    // 配置视频参数 高度
    config.profile.videoFrameHeight = videoFrameHeight;
    // 配置视频参数 帧率 30
    config.profile.videoFrameRate = 30;
    // 配置视频参数 编码格式 AVC
    config.profile.videoCodec = AVRECORDER_VIDEO_AVC;
    // 配置视频参数 是否为HDR
    config.profile.isHdr = false;
    // 配置视频参数 是否支持分层编码
    config.profile.enableTemporalScale = false;
    // 配置视频参数 封装格式
    config.profile.fileFormat = AVRECORDER_CFT_MPEG_4;
    // 配置视频参数 由系统创建媒体文件
    config.fileGenerationMode = AVRECORDER_AUTO_CREATE_CAMERA_SCENE;

    // 初始长度为3的空间，存放视频旋转角度
    config.metadata.videoOrientation = (char*)malloc(3);
    if (config.metadata.videoOrientation != nullptr) {
        strncpy(config.metadata.videoOrientation, "90", 2);
        config.metadata.videoOrientation[2] = '\0';
    }
    OH_LOG_INFO(LOG_APP, "==NDKDemo== videoOrientation: %{public}s", config.metadata.videoOrientation);

    config.metadata.location.latitude = 31.791863;
    config.metadata.location.longitude = 64.574687;
}

// Type 2: 只录音频
void SetConfigAudio(OH_AVRecorder_Config &config)
{
    config.audioSourceType = AVRECORDER_MIC;

    // 配置音频参数 比特率 32000
    config.profile.audioBitrate = 32000; 
    // 配置音频参数 声道数 2
    config.profile.audioChannels = 2;
    // 配置音频参数 编码格式 aac
    config.profile.audioCodec = AVRECORDER_AUDIO_AAC;
    // 配置音频参数 采样率 8000
    config.profile.audioSampleRate = 8000;

    // 配置音频参数 封装格式 mp3
    config.profile.fileFormat = AVRECORDER_CFT_MP3;
    // 配置音频参数 应用自行创建
    config.fileGenerationMode = AVRECORDER_APP_CREATE;
    // 配置纬度 31.791863
    config.metadata.location.latitude = 31.791863;
    // 配置经度 64.574687
    config.metadata.location.longitude = 64.574687;
}

// Type 3: 只录视频
void SetConfigVideo(OH_AVRecorder_Config &config)
{
    config.videoSourceType = AVRECORDER_SURFACE_YUV;

    // 配置视频参数 比特率 2000000
    config.profile.videoBitrate = 2000000;
    // 配置视频参数 宽度
    config.profile.videoFrameWidth = videoFrameWidth;
    // 配置视频参数 高度
    config.profile.videoFrameHeight = videoFrameHeight;
    // 配置视频参数 帧率 30
    config.profile.videoFrameRate = 30;
    // 配置视频参数 编码格式 AVC
    config.profile.videoCodec = AVRECORDER_VIDEO_AVC;
    // 配置视频参数 是否为HDR
    config.profile.isHdr = false;
    // 配置视频参数 是否支持分层编码
    config.profile.enableTemporalScale = false;
    // 配置视频参数 封装格式
    config.profile.fileFormat = AVRECORDER_CFT_MPEG_4;
    // 配置视频参数 由系统创建媒体文件
    config.fileGenerationMode = AVRECORDER_APP_CREATE;

    // 初始长度为3的空间，存放视频旋转角度
    config.metadata.videoOrientation = (char*)malloc(3);
    if (config.metadata.videoOrientation != nullptr) {
        strncpy(config.metadata.videoOrientation, "90", 2);
        config.metadata.videoOrientation[2] = '\0';
    }
    OH_LOG_INFO(LOG_APP, "==NDKDemo== videoOrientation: %{public}s", config.metadata.videoOrientation);

    config.metadata.location.latitude = 31.791863;
    config.metadata.location.longitude = 64.574687;
}

// 设置状态回调
void OnStateChange(OH_AVRecorder *recorder, OH_AVRecorder_State state,
    OH_AVRecorder_StateChangeReason reason, void *userData) {
    (void)recorder;
    (void)userData;

    // 将 reason 转换为字符串表示
    const char *reasonStr = (reason == AVRECORDER_USER) ? "USER" : (reason == AVRECORDER_BACKGROUND) ? "BACKGROUND" : "UNKNOWN";

    if (state == AVRECORDER_IDLE) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== Recorder OnStateChange IDLE, reason: %{public}s", reasonStr);
        // 处理状态变更
    }
    if (state == AVRECORDER_PREPARED) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== Recorder OnStateChange PREPARED, reason: %{public}s", reasonStr);
        // 处理状态变更
    }
    if (state == AVRECORDER_STARTED) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== Recorder OnStateChange STARTED, reason: %{public}s", reasonStr);
        // 处理状态变更
    }
    if (state == AVRECORDER_PAUSED) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== Recorder OnStateChange PAUSED, reason: %{public}s", reasonStr);
        // 处理状态变更
    }
    if (state == AVRECORDER_STOPPED) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== Recorder OnStateChange STOPPED, reason: %{public}s", reasonStr);
        // 处理状态变更
    }
    if (state == AVRECORDER_RELEASED) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== Recorder OnStateChange RELEASED, reason: %{public}s", reasonStr);
        // 处理状态变更
    }
    if (state == AVRECORDER_ERROR) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== Recorder OnStateChange ERROR, reason: %{public}s", reasonStr);
        // 处理状态变更
    }
}

// 设置错误回调
void OnError(OH_AVRecorder *recorder, int32_t errorCode, const char *errorMsg, void *userData) {
    (void)recorder;
    (void)userData;
    OH_LOG_INFO(LOG_APP, "==NDKDemo== Recorder OnError errorCode: %{public}d, error message: %{public}s",
        errorCode, errorMsg);
}

// 设置生成媒体文件回调
void OnUri(OH_AVRecorder *recorder, OH_MediaAsset *asset, void *userData) {
    (void)recorder;
    (void)userData;
    OH_LOG_INFO(LOG_APP, "==NDKDemo== OnUri in!"); 
    if (asset != nullptr) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== OH_MediaAsset: %p", asset);
        auto changeRequest = OH_MediaAssetChangeRequest_Create(asset);
        OH_LOG_INFO(LOG_APP, "==NDKDemo== changeRequest: %p", changeRequest);
        if (changeRequest == nullptr) {
            OH_LOG_ERROR(LOG_APP, "==NDKDemo== changeRequest is null!");
            return;
        }
        OH_LOG_INFO(LOG_APP, "==NDKDemo== changeRequest is not null!");
        MediaLibrary_ImageFileType imageFileType = MEDIA_LIBRARY_FILE_VIDEO;
        
        uint32_t result = OH_MediaAssetChangeRequest_SaveCameraPhoto(changeRequest, imageFileType);
        OH_LOG_INFO(LOG_APP, "result of OH_MediaAssetChangeRequest_SaveCameraPhoto: %d", result);
        uint32_t resultChange = OH_MediaAccessHelper_ApplyChanges(changeRequest);
        OH_LOG_INFO(LOG_APP, "result of OH_MediaAccessHelper_ApplyChanges: %d", resultChange);
        OH_MediaAsset_Release(asset);
        OH_MediaAssetChangeRequest_Release(changeRequest);
    } else {
        OH_LOG_ERROR(LOG_APP, "Received null media asset!");
    }
    OH_LOG_INFO(LOG_APP, "==NDKDemo== OnUri out!");
}

// 1.准备录制
static napi_value PrepareAVRecorder(napi_env env, napi_callback_info info)
{
    (void)info;
    OH_LOG_INFO(LOG_APP, "==NDKDemo== PrepareAVRecorder in!");
    avRecorder = OH_AVRecorder_Create();
    OH_LOG_INFO(LOG_APP, "==NDKDemo== AVRecorder Create OK! avRecorder: %{public}p", avRecorder);
    if (avRecorder == nullptr) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== AVRecorder Create failed!");
    }
    OH_AVRecorder_Config *config = new OH_AVRecorder_Config();
    
    SetConfig(*config);

    // 1.1 设置URL
    const std::string AVREORDER_ROOT = "/data/storage/el2/base/files/";
    int32_t outputFd = open((AVREORDER_ROOT + "avrecorder01.mp4").c_str(), O_RDWR | O_CREAT, 0777);    // 设置文件名
    std::string fileUrl = "fd://" + std::to_string(outputFd);
    config->url = const_cast<char *>(fileUrl.c_str());
    OH_LOG_INFO(LOG_APP, "config.url is: %s", const_cast<char *>(fileUrl.c_str()));
    std::cout<< "config.url is:" << config->url << std::endl;

    // 1.2 回调
    // 状态回调
    OH_AVRecorder_SetStateCallback(avRecorder, OnStateChange, nullptr);
    // 错误回调
    OH_AVRecorder_SetErrorCallback(avRecorder, OnError, nullptr);
    // 生成媒体文件回调
    OH_LOG_INFO(LOG_APP, "==NDKDemo== OH_AVRecorder_SetUriCallback in!");
    OH_AVErrCode ret = OH_AVRecorder_SetUriCallback(avRecorder, OnUri, nullptr);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== OH_AVRecorder_SetUriCallback out!");
    if (ret == AV_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo==  OH_AVRecorder_SetUriCallback succeed!");
    } else {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo==  Failed to set URI callback, error code: %d", ret);
    }
    
    // 1.3 prepare接口
    int result = OH_AVRecorder_Prepare(avRecorder, config);
    if (result != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== AVRecorder Prepare failed %{public}d", result);
    }
    OH_LOG_ERROR(LOG_APP, "==NDKDemo== AVRecorder enableTemporalScale：%{public}d", static_cast<int>(config->profile.enableTemporalScale));
    
    // 1.4 更新视频旋转角度 OH_AVRecorder_UpdateRotation
    int32_t rotation = 90;
    result = OH_AVRecorder_UpdateRotation(avRecorder, rotation);
    if (result != AV_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== AVRecorder UpdateRotation failed! ret=%{public}d", result);
    } else {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== OH_AVRecorder_UpdateRotation: %{public}d", rotation);
    }
    
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 获取实时配置参数
static napi_value GetAVRecorderConfig(napi_env env, napi_callback_info info)
{
    (void)info;
    
    OH_AVRecorder_Config *config = nullptr;
    
    int result = OH_AVRecorder_GetAVRecorderConfig(avRecorder, &config);
    if (result != AV_ERR_OK || config == nullptr) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== Get AVRecorder Config failed %{public}d", result);
        napi_value res;
        napi_create_int32(env, result, &res);
        return res;
    }
    
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig videoOrientation: %{public}s",
        config->metadata.videoOrientation);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig audioSourceType: %{public}d",
        config->audioSourceType);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig videoSourceType: %{public}d",
        config->videoSourceType);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig audioBitrate: %{public}d",
        config->profile.audioBitrate);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig audioChannels: %{public}d",
        config->profile.audioChannels);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig audioCodec: %{public}d",
        config->profile.audioCodec);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig audioSampleRate: %{public}d",
        config->profile.audioSampleRate);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig fileFormat: %{public}d",
        config->profile.fileFormat);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig videoBitrate: %{public}d",
        config->profile.videoBitrate);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig videoCodec: %{public}d",
        config->profile.videoCodec);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig videoFrameWidth: %{public}d",
        config->profile.videoFrameWidth);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig videoFrameHeight: %{public}d",
        config->profile.videoFrameHeight);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig videoFrameRate: %{public}d",
        config->profile.videoFrameRate);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig latitude: %{public}.6f",
        config->metadata.location.latitude);
    OH_LOG_INFO(LOG_APP, "==NDKDemo== GetAVRecorderConfig longitude: %{public}.6f",
        config->metadata.location.longitude);
    
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 获取录制支持的编码信息
static napi_value GetAvailableEncoder(napi_env env, napi_callback_info info)
{
    (void)info;
    
    OH_AVRecorder_EncoderInfo *encoderInfo = nullptr;
    int32_t lengthValue = 0;  // 定义一个实际的 int32_t 变量
    int32_t *length = &lengthValue; 

    int result = OH_AVRecorder_GetAvailableEncoder(avRecorder, &encoderInfo, length);
    if (result != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== GetAvailableEncoder failed %{public}d", result);
        napi_value res;
        napi_create_int32(env, result, &res);
        return res;
    }
    // 打印 encoderInfo 的内容
    if (encoderInfo != nullptr) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== Encoder Info in！");

        // 打印 mimeType (假设是一个枚举类型或可转为字符串的类型)
        OH_LOG_INFO(LOG_APP, " ==NDKDemo== GetAvailableEncoder MIME Type: %{public}d", encoderInfo->mimeType);

        // 打印 type
        OH_LOG_INFO(LOG_APP, " ==NDKDemo== GetAvailableEncoder Type: %{public}s", encoderInfo->type);

        // 打印 bitRate 范围
        OH_LOG_INFO(LOG_APP, " ==NDKDemo== GetAvailableEncoder BitRate Min: %{public}d, Max: %{public}d",
            encoderInfo->bitRate.min, encoderInfo->bitRate.max);

        // 打印 frameRate 范围
        OH_LOG_INFO(LOG_APP, " ==NDKDemo== GetAvailableEncoder FrameRate Min: %{public}d, Max: %{public}d",
            encoderInfo->frameRate.min, encoderInfo->frameRate.max);

        // 打印 width 范围
        OH_LOG_INFO(LOG_APP, " ==NDKDemo== GetAvailableEncoder Width Min: %{public}d, Max: %{public}d",
            encoderInfo->width.min, encoderInfo->width.max);

        // 打印 height 范围
        OH_LOG_INFO(LOG_APP, " ==NDKDemo== GetAvailableEncoder Height Min: %{public}d, Max: %{public}d",
            encoderInfo->height.min, encoderInfo->height.max);

        // 打印 channels 范围
        OH_LOG_INFO(LOG_APP, " ==NDKDemo== GetAvailableEncoder Channels Min: %{public}d, Max: %{public}d",
            encoderInfo->channels.min, encoderInfo->channels.max);

        // 打印 sampleRate 列表和长度
        OH_LOG_INFO(LOG_APP, " ==NDKDemo== GetAvailableEncoder SampleRate Length: %{public}d",
            encoderInfo->sampleRateLen);

        if (encoderInfo->sampleRate != nullptr) {
            OH_LOG_INFO(LOG_APP, "==NDKDemo==  SampleRates: ");
            for (int i = 0; i < encoderInfo->sampleRateLen; i++) {
                OH_LOG_INFO(LOG_APP, "  ==NDKDemo== GetAvailableEncoder SampleRate: %{public}d",
                    i, encoderInfo->sampleRate[i]);
            }
        }
    } else {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== EncoderInfo is null");
    }
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 2. 启动相机
static napi_value PrepareCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "==NDKDemo== AVRecorder PrepareCamera");
    (void)info;

    // 2.1 相机初始化（init）

    size_t argc = 6;
    napi_value args[6] = {nullptr};
    size_t typeLen = 0;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t focusMode;
    // 获取第一个参数值
    napi_get_value_int32(env, args[0], &focusMode);

    uint32_t cameraDeviceIndex;
    // 获取第二个参数值
    napi_get_value_uint32(env, args[1], &cameraDeviceIndex);

    uint32_t sceneMode;
    // 获取第三个参数值
    napi_get_value_uint32(env, args[2], &sceneMode);

    char* previewId = nullptr;
    // 获取第四个参数值
    napi_get_value_string_utf8(env, args[3], nullptr, 0, &typeLen);
    previewId = new char[typeLen + 1];
    // 获取第四个参数值
    napi_get_value_string_utf8(env, args[3], previewId, typeLen + 1, &typeLen);

    char* photoId = nullptr;
    // 获取第五个参数值
    napi_get_value_string_utf8(env, args[4], nullptr, 0, &typeLen);
    photoId = new char[typeLen + 1];
    // 获取第五个参数值
    napi_get_value_string_utf8(env, args[4], photoId, typeLen + 1, &typeLen);

    // 获取surfaceID
    OHNativeWindow *window = nullptr;

    int resultCode = OH_AVRecorder_GetInputSurface(avRecorder, &window);
    if (resultCode != AV_ERR_OK || window == nullptr) {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== AVRecorder GetInputSurface failed!");
        napi_value errorResult;
        napi_create_int32(env, -1, &errorResult);    // -1 表示错误
        return errorResult;
    } else {
        OH_LOG_INFO(LOG_APP, "==NDKDemo== AVRecorder GetInputSurface succeeded!");
    }
    
    uint64_t surfaceId;
    OH_NativeWindow_GetSurfaceId(window, &surfaceId);
    char videoId[30];
    OH_LOG_ERROR(LOG_APP, "InitCamera focusMode : %{public}d", focusMode);
    OH_LOG_ERROR(LOG_APP, "InitCamera cameraDeviceIndex : %{public}d", cameraDeviceIndex);
    OH_LOG_ERROR(LOG_APP, "InitCamera sceneMode : %{public}d", sceneMode);
    OH_LOG_ERROR(LOG_APP, "InitCamera previewId : %{public}s", previewId);
    OH_LOG_ERROR(LOG_APP, "InitCamera photoId : %{public}s", photoId);
    OH_LOG_ERROR(LOG_APP, "InitCamera videoId : %{public}s", videoId);

    SurfaceIds surfaceIds(previewId, photoId, videoId);
    ndkCamera_ = new NDKCamera(focusMode, cameraDeviceIndex, sceneMode, surfaceIds);
    OH_LOG_INFO(LOG_APP, "InitCamera End");

    int result = 0;
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 3. 开始录制
static napi_value StartAVRecorder(napi_env env, napi_callback_info info)
{
    (void)info;
    OH_LOG_INFO(LOG_APP, "==NDKDemo== avRecorder start: %{public}p", avRecorder);
    int result = OH_AVRecorder_Start(avRecorder);
    if (result != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== AVRecorder Start failed %{public}d", result);
    }
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 4. 暂停录制
static napi_value PauseAVRecorder(napi_env env, napi_callback_info info)
{
    (void)info;
    int result = OH_AVRecorder_Pause(avRecorder);
    if (result != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== AVRecorder Pause failed %{public}d", result);
    }
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 5. 恢复录制
static napi_value ResumeAVRecorder(napi_env env, napi_callback_info info)
{
    (void)info;
    int result = OH_AVRecorder_Resume(avRecorder);
    if (result != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== AVRecorder Resume failed %{public}d", result);
    }
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 6. 停止录制
static napi_value StopAVRecorder(napi_env env, napi_callback_info info)
{
    (void)info;
    OH_LOG_INFO(LOG_APP, "==NDKDemo== avRecorder stop: %{public}p", avRecorder);
    int result = OH_AVRecorder_Stop(avRecorder);
    if (result != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== AVRecorder Stop failed %{public}d", result);
    }
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 7. 重置录制
static napi_value ResetAVRecorder(napi_env env, napi_callback_info info)
{
    (void)info;
    // 检查 avRecorder 是否有效
    if (avRecorder == nullptr) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== avRecorder is nullptr!");
        napi_value res;
        napi_create_int32(env, AV_ERR_INVALID_VAL, &res);
        return res;
    }

    int result = OH_AVRecorder_Reset(avRecorder);
    if (result != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== AVRecorder Reset failed %{public}d", result);
    }
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

// 8. 释放录制资源
static napi_value ReleaseAVRecorder(napi_env env, napi_callback_info info)
{
    (void)info;
    // 检查 avRecorder 是否有效
    if (avRecorder == nullptr) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== avRecorder is nullptr!");
        napi_value res;
        napi_create_int32(env, AV_ERR_INVALID_VAL, &res);
        return res;
    }
    
    int result = OH_AVRecorder_Release(avRecorder);
    avRecorder = nullptr;   // 释放录制资源后，需要显式地将avRecorder指针置空
    
    if (result != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "==NDKDemo== AVRecorder Release failed %{public}d", result);
    }
    napi_value res;
    napi_create_int32(env, result, &res);
    return res;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"prepareAVRecorder", nullptr, PrepareAVRecorder, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getAVRecorderConfig", nullptr, GetAVRecorderConfig, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getAvailableEncoder", nullptr, GetAvailableEncoder, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"prepareCamera", nullptr, PrepareCamera, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startAVRecorder", nullptr, StartAVRecorder, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pauseAVRecorder", nullptr, PauseAVRecorder, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"resumeAVRecorder", nullptr, ResumeAVRecorder, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopAVRecorder", nullptr, StopAVRecorder, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"resetAVRecorder", nullptr, ResetAVRecorder, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseAVRecorder", nullptr, ReleaseAVRecorder, nullptr, nullptr, nullptr, napi_default, nullptr},
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
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}