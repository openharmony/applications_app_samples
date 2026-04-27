/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 
#include "napi/native_api.h"
#include "hilog/log.h"
#include <multimedia/player_framework/native_avscreen_capture.h>
#include <multimedia/player_framework/native_avscreen_capture_base.h>
#include <condition_variable>
#include <mutex>
#include "string"
#include <vector>
#include <uv.h>

#define LOG_TAG "ScreenCapture:"
#define LOG_DOMAIN 0x3200
napi_threadsafe_function g_threadSafeFunction = nullptr;
enum RecordingState {
    IDLE = 0,
    RECORDING,
    STOPPED,
    ERROR
};

struct AsyncData {
    napi_env env;
    napi_ref callbackRef;
    std::atomic<bool> running{false};
    uv_async_t async;
    std::mutex mutex;
};

RecordingState g_state = IDLE;
struct OH_AVScreenCapture *g_capture = nullptr;
std::condition_variable g_listenCv;
std::mutex g_listenMutex;
bool g_listenFlag = false;
constexpr int MAX_RECORD_WIDTH = 3840;
constexpr int MAX_RECORD_HEIGHT = 2160;

void OnStateChange(struct OH_AVScreenCapture *capture, OH_AVScreenCaptureStateCode stateCode, void *userData)
{
    (void)capture;
    OH_LOG_INFO(LOG_APP, "OnStateChange listen code:%d", stateCode);
    if (stateCode == OH_SCREEN_CAPTURE_STATE_STARTED) {
        g_state = RECORDING;
    }
    if (stateCode == OH_SCREEN_CAPTURE_STATE_STOPPED_BY_CALL ||
        stateCode == OH_SCREEN_CAPTURE_STATE_STOPPED_BY_USER_SWITCHES) {
        g_state = STOPPED;
    }
    if (stateCode == OH_SCREEN_CAPTURE_STATE_INTERRUPTED_BY_OTHER ||
        stateCode == OH_SCREEN_CAPTURE_STATE_MIC_UNAVAILABLE) {
        g_state = ERROR;
    }
    if (stateCode == OH_SCREEN_CAPTURE_STATE_CANCELED) {
        g_state = IDLE;
    }
    (void)userData;

    g_listenFlag = true;
    g_listenCv.notify_one();
}

OH_VideoCaptureInfo videoCapInfo = {
    .videoFrameWidth = 1920,
    .videoFrameHeight = 1080,
    .videoSource = OH_VIDEO_SOURCE_SURFACE_RGBA
};

static napi_status GetRecordingPath(
    napi_env env,
    napi_callback_info info,
    std::string &fileUrl,
    napi_value &result)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok) {
        napi_create_int32(env, status, &result);
        return status;
    }

    size_t strSize = 0;
    status = napi_get_value_string_utf8(env, args[0], nullptr, 0, &strSize);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_get_value_string_utf8 error.");
        napi_create_int32(env, status, &result);
        return status;
    }

    std::vector<char> buffer(strSize + 1, '\0');
    status = napi_get_value_string_utf8(env, args[0], buffer.data(), buffer.size(), &strSize);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_get_value_string_utf8 error.");
        napi_create_int32(env, status, &result);
        return status;
    }
    fileUrl.assign(buffer.data(), strSize);

    return napi_ok;
}

static OH_AVScreenCaptureConfig BuildScreenCaptureConfig(const std::string &fileUrl)
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
        .audioCodecformat = OH_AudioCodecFormat::OH_AAC_LC
    };
    OH_VideoEncInfo videoEncInfo = {
        .videoCodec = OH_VideoCodecFormat::OH_H264,
        .videoBitrate = 2000000,
        .videoFrameRate = 30
    };
    OH_RecorderInfo recorderInfo = {
        .url = const_cast<char *>(fileUrl.c_str()),
        .fileFormat = OH_ContainerFormatType::CFT_MPEG_4
    };
    return {
        .captureMode = OH_CAPTURE_HOME_SCREEN,
        .dataType = OH_CAPTURE_FILE,
        .audioInfo = {
            .micCapInfo = micCapInfo,
            .innerCapInfo = innerCapInfo,
            .audioEncInfo = audioEncInfo
        },
        .videoInfo = {
            .videoCapInfo = videoCapInfo,
            .videoEncInfo = videoEncInfo
        },
        .recorderInfo = recorderInfo
    };
}

static napi_status StartCaptureRecording(napi_env env, const OH_AVScreenCaptureConfig &config, napi_value &result)
{
    int32_t retInit = OH_AVScreenCapture_Init(g_capture, config);
    if (retInit != 0) {
        OH_LOG_ERROR(LOG_APP, "OH_AVScreenCapture_Init error.");
        napi_create_int32(env, retInit, &result);
        return napi_generic_failure;
    }

    int32_t retStart = OH_AVScreenCapture_StartScreenRecording(g_capture);
    if (retStart != 0) {
        OH_LOG_ERROR(LOG_APP, "OH_AVScreenCapture_StartScreenRecording error.");
        napi_create_int32(env, retStart, &result);
        return napi_generic_failure;
    }

    return napi_ok;
}

static napi_value StartRecording(napi_env env, napi_callback_info info)
{
    napi_value result;
    std::string fileUrl;
    napi_status status = GetRecordingPath(env, info, fileUrl, result);
    if (status != napi_ok) {
        return result;
    }

    OH_LOG_INFO(LOG_APP, "StartRecording fileUrl:%s", fileUrl.c_str());
    OH_AVScreenCaptureConfig config = BuildScreenCaptureConfig(fileUrl);
    if (StartCaptureRecording(env, config, result) != napi_ok) {
        return result;
    }

    OH_LOG_INFO(LOG_APP, "StartRecording end.");
    napi_create_int32(env, 0, &result);
    return result;
}

static napi_value StopRecording(napi_env env, napi_callback_info info)
{
    (void)info;
    napi_value result;
    int32_t retStop = OH_AVScreenCapture_StopScreenRecording(g_capture);
    if (retStop != 0) {
        OH_LOG_ERROR(LOG_APP, "OH_AVScreenCapture_StopScreenRecording error.");
        napi_create_int32(env, retStop, &result);
        return result;
    }

    int32_t retRelease = OH_AVScreenCapture_Release(g_capture);
    if (retRelease != 0) {
        OH_LOG_ERROR(LOG_APP, "OH_AVScreenCapture_Release error.");
        napi_create_int32(env, retRelease, &result);
        return result;
    }

    napi_create_int32(env, 0, &result);
    return result;
}

static napi_value GetRecorderState(napi_env env, napi_callback_info info)
{
    (void)info;
    napi_value result;
    napi_create_int32(env, g_state, &result);
    return result;
}

static void OnAsyncCallback(uv_async_t* handle)
{
    AsyncData* asyncData = static_cast<AsyncData*>(handle->data);
    if (!asyncData) {
        OH_LOG_ERROR(LOG_APP, "asyncData nullptr.");
        return;
    }

    std::lock_guard<std::mutex> lock(asyncData->mutex);
    if (!asyncData->running) {
        OH_LOG_INFO(LOG_APP, "asyncData->running stop.");
        return;
    }

    napi_env env = asyncData->env;
    napi_handle_scope scope;
    if (napi_open_handle_scope(env, &scope) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_open_handle_scope error.");
        return;
    }

    napi_value jsCallback;
    if (napi_get_reference_value(env, asyncData->callbackRef, &jsCallback) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_get_reference_value error.");
        napi_close_handle_scope(env, scope);
        return;
    }

    napi_value argv;
    napi_create_int32(env, g_state, &argv);

    napi_value global;
    napi_get_global(env, &global);

    napi_value result;
    napi_call_function(env, global, jsCallback, 1, &argv, &result);

    napi_close_handle_scope(env, scope);
}

static void ExecuteWork(napi_env env, void* data)
{
    (void)env;
    g_capture = OH_AVScreenCapture_Create();
    OH_AVScreenCapture_SetStateCallback(g_capture, OnStateChange, nullptr);

    AsyncData* asyncData = static_cast<AsyncData*>(data);
    while (asyncData->running) {
        std::unique_lock<std::mutex> lock(g_listenMutex);
        g_listenCv.wait(lock, [] { return g_listenFlag; });
        g_listenFlag = false;

        if (!asyncData->running) {
            OH_LOG_INFO(LOG_APP, "asyncData->running stop.");
            break;
        }
        uv_async_send(&asyncData->async);
    }
}

static void CompleteWork(napi_env env, napi_status status, void* data)
{
    (void)env;
    (void)status;
    AsyncData* asyncData = static_cast<AsyncData*>(data);
    if (!asyncData) {
        OH_LOG_ERROR(LOG_APP, "asyncData nullptr.");
        return;
    }

    std::lock_guard<std::mutex> lock(asyncData->mutex);
    asyncData->running = false;
    uv_close((uv_handle_t*)&asyncData->async, [](uv_handle_t* handle) {
        AsyncData* data = static_cast<AsyncData*>(handle->data);
        napi_delete_reference(data->env, data->callbackRef);
        delete data;
    });
}

static napi_value OnStateChange(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype;
    napi_typeof(env, args[0], &valuetype);
    if (valuetype != napi_function) {
        napi_throw_error(env, nullptr, "Expected a function");
        return nullptr;
    }

    uv_loop_t* loop;
    napi_get_uv_event_loop(env, &loop);

    AsyncData* asyncData = new AsyncData();
    asyncData->env = env;
    asyncData->running = true;
    napi_create_reference(env, args[0], 1, &asyncData->callbackRef);
    uv_async_init(loop, &asyncData->async, OnAsyncCallback);
    asyncData->async.data = asyncData;

    napi_value resourceName;
    napi_create_string_utf8(env, "OnStateChange", NAPI_AUTO_LENGTH, &resourceName);

    napi_async_work asyncWork;
    napi_create_async_work(env, nullptr, resourceName, ExecuteWork, CompleteWork, asyncData, &asyncWork);
    napi_queue_async_work(env, asyncWork);

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

static napi_value Add(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    return sum;
}

static napi_value SetRecordResolution(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);
    (void)valuetype0;
    int width;
    napi_get_value_int32(env, args[0], &width);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);
    (void)valuetype1;
    int height;
    napi_get_value_int32(env, args[1], &height);
    //=========================
    OH_LOG_ERROR(LOG_APP, "set param w:%{public}d; h:%{public}d", width, height);
    //=========================
    if (width <= 0 || width > MAX_RECORD_WIDTH || height <= 0 || height > MAX_RECORD_HEIGHT) {
        napi_get_undefined(env, &result);
        return result;
    }
    videoCapInfo.videoFrameWidth = width;
    videoCapInfo.videoFrameHeight = height;
    napi_get_undefined(env, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startRecording", nullptr, StartRecording, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopRecording", nullptr, StopRecording, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRecorderState", nullptr, GetRecorderState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setRecordResolution", nullptr, SetRecordResolution, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"onStateChange", nullptr, OnStateChange, nullptr, nullptr, nullptr, napi_default, nullptr}
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

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
