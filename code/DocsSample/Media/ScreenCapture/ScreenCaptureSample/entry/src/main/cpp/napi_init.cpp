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

g_micFile = nullptr;
g_vFile = nullptr;
g_innerFile = nullptr;

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
    vFile_ = fopen(filePath.c_str(), "wb");
    if (vFile_ == nullptr) {
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
    if (vFile_ != nullptr) {
        fclose(vFile_);
        vFile_ = nullptr;
    }
}

// [Start screenCapture_config]
void SetConfig(OH_AVScreenCaptureConfig &config)
{
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

    OH_AudioEncInfo audioEncInfo = {
        .audioBitrate = 48000,
        .audioCodecformat = OH_AAC_LC
    };

    OH_VideoCaptureInfo videoCapInfo = {
        .videoFrameWidth = 720,
        .videoFrameHeight = 1280,
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
        .dataType = OH_ORIGINAL_STREAM, // 录屏数据类型，原始码流或文件
        .audioInfo = audioInfo,
        .videoInfo = videoInfo
    };
}
// [End screenCapture_config]

void OnError(OH_AVScreenCapture *capture, int32_t errorCode, void *userData)
{
    (void)capture;
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OnError errorCode is %{public}d", errorCode);
    (void)userData;
}

void OnStateChange(struct OH_AVScreenCapture *capture, OH_AVScreenCaptureStateCode stateCode, void *userData)
{
    if (stateCode == OH_SCREEN_CAPTURE_STATE_STARTED) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OnStateChange started");
        // 处理状态变更
        // 可选 配置录屏旋转
        int32_t ret = OH_AVScreenCapture_SetCanvasRotation(capture, true);
        // 可选 修改Canvas分辨率
        ret = OH_AVScreenCapture_ResizeCanvas(g_avCapture, 768, 1280);
        // 可选 设置是否显示光标
        ret = OH_AVScreenCapture_ShowCursor(g_avCapture, true);
        // 可选 设置视频最大帧率
        ret = OH_AVScreenCapture_SetMaxVideoFrameRate(g_avCapture, 30);
    }
    if (stateCode == OH_SCREEN_CAPTURE_STATE_INTERRUPTED_BY_OTHER) {
        // 处理状态变更
    }
    (void)userData;
}

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

void OnDisplaySelected(struct OH_AVScreenCapture *capture, uint64_t displayId, void *userData)
{
    (void)capture;
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OnError errorCode is %{public}uld", displayId);
    (void)userData;
}

// 开始录屏原始码流
static napi_value StartScreenCapture_01(napi_env env, napi_callback_info info)
{
    g_avCapture = OH_AVScreenCapture_Create();
    if (g_avCapture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "create screen capture failed");
    }
    OH_AVScreenCaptureConfig config_;
    SetConfig(config_);
    OpenFile("Demo");
    bool isMicrophone = true;
    OH_AVScreenCapture_SetMicrophoneEnabled(g_avCapture, isMicrophone);
    OH_AVScreenCapture_SetErrorCallback(g_avCapture, OnError, nullptr);
    OH_AVScreenCapture_SetStateCallback(g_avCapture, OnStateChange, nullptr);
    OH_AVScreenCapture_SetDataCallback(g_avCapture, OnBufferAvailable, nullptr);
    OH_AVScreenCapture_SetDisplayCallback(g_avCapture, OnDisplaySelected, nullptr);
    // 可选，排除指定窗口/指定音频类型 start
    struct OH_AVScreenCapture_ContentFilter *contentFilter = OH_AVScreenCapture_CreateContentFilter();
    OH_AVScreenCapture_ContentFilter_AddAudioContent(contentFilter, OH_SCREEN_CAPTURE_NOTIFICATION_AUDIO);
    vector<int> windowIdsExclude = { -111 };
    OH_AVScreenCapture_ContentFilter_AddWindowContent(contentFilter,
        &windowIdsExclude[0], static_cast<int32_t>(windowIdsExclude.size()));
    OH_AVScreenCapture_ExcludeContent(g_avCapture, contentFilter);
    OH_AVScreenCapture_SkipPrivacyMode(g_avCapture,
        &windowIdsExclude[0], static_cast<int32_t>(windowIdsExclude.size()));
    OH_AVScreenCapture_ReleaseContentFilter(contentFilter);
    contentFilter = nullptr;
    // 可选，排除指定窗口/指定音频类型 end
    int result = OH_AVScreenCapture_Init(g_avCapture, config_);
    if (result != AV_SCREEN_CAPTURE_ERR_OK) {
        OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init failed %{public}d", result);
    }
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture OH_AVScreenCapture_Init %{public}d", result);

    result = OH_AVScreenCapture_StartScreenCapture(g_avCapture);
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
    g_avCapture = OH_AVScreenCapture_Create();
    if (g_avCapture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "create screen capture failed");
    }
    OH_AVScreenCaptureConfig config_;

    OH_RecorderInfo recorderInfo;
    const std::string filePath = "/data/storage/el2/base/files/";
    g_fileOutputFd = open((filePath + "saving_file.mp4").c_str(), O_RDWR | O_CREAT, FILE_PERMISSION_FULL_ACCESS);
    std::string fileUrl = "fd://" + std::to_string(g_fileOutputFd);
    recorderInfo.url = const_cast<char *>(fileUrl.c_str());
    recorderInfo.fileFormat = OH_ContainerFormatType::CFT_MPEG_4;
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture fileUrl %{public}s", fileUrl.c_str());

    SetConfig(config_);
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

    result = OH_AVScreenCapture_StartScreenRecording(g_avCapture);
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
    SetConfig(config_);
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
    const std::string filePath = "/data/storage/el2/base/files/";
    g_windowOutputFd = open((filePath + "saving_window_file.mp4").c_str(), O_RDWR | O_CREAT,
        FILE_PERMISSION_FULL_ACCESS);
    std::string fileUrl = "fd://" + std::to_string(g_windowOutputFd);
    recorderInfo.url = const_cast<char *>(fileUrl.c_str());
    recorderInfo.fileFormat = OH_ContainerFormatType::CFT_MPEG_4;
    OH_LOG_INFO(LOG_APP, "==ScreenCaptureSample== ScreenCapture fileUrl %{public}s", fileUrl.c_str());

    SetConfig(config_);
    
    // 设置录屏模式为OH_CAPTURE_SPECIFIED_WINDOW
    config_.captureMode = OH_CAPTURE_SPECIFIED_WINDOW;
    config_.dataType = OH_CAPTURE_FILE;
    config_.recorderInfo = recorderInfo;

    // [Start screenCapture_createCaptureStrategy]
    // 通过弹出屏幕捕获Picker列表方式，选择已打开的应用窗口进行窗口级录屏。
    OH_AVScreenCapture_CaptureStrategy *strategy = OH_AVScreenCapture_CreateCaptureStrategy();
    OH_AVScreenCapture_StrategyForPickerPopUp(strategy, true);
    OH_AVScreenCapture_SetCaptureStrategy(g_avCapture, strategy);
    // [End screenCapture_createCaptureStrategy]

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
        result = OH_AVScreenCapture_Release(g_avCapture);
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
        result = OH_AVScreenCapture_StopScreenCapture(g_avCapture);
        if (result != AV_SCREEN_CAPTURE_ERR_BASE) {
            OH_LOG_ERROR(LOG_APP, "StopScreenCapture OH_AVScreenCapture_StopScreenCapture Result: %{public}d", result);
        }
        result = OH_AVScreenCapture_Release(g_avCapture);
        if (result != AV_SCREEN_CAPTURE_ERR_BASE) {
            OH_LOG_ERROR(LOG_APP, "StopScreenCapture OH_AVScreenCapture_Release: %{public}d", result);
        }
        OH_LOG_INFO(LOG_APP, "OH_AVScreenCapture_Release success");
        g_avCapture = nullptr;
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
                int32_t ret = fwrite(audioBuffer->buf, 1, audioBuffer->size, g_micFile);
                free(audioBuffer->buf);
                audioBuffer->buf = nullptr;
            } else if ((g_innerFile != nullptr) && (audioBuffer->buf != nullptr) && (type == OH_ALL_PLAYBACK)) {
                int32_t ret = fwrite(audioBuffer->buf, 1, audioBuffer->size, g_innerFile);
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
