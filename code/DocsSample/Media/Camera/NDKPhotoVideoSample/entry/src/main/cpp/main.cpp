/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <cstdint>
#include <js_native_api.h>
#include "camera_manager.h"

#define LOG_TAG "DEMO:"
#define LOG_DOMAIN 0x3200

using namespace OHOS_CAMERA_SAMPLE;
static NDKCamera* g_ndkCamera = nullptr;
const int32_t ARGS_TWO = 2;
const int32_t ARGS_THREE = 3;
static napi_ref bufferCbRef_ = nullptr;
static napi_env env_;
static bool g_isControlCenter = false;
static bool g_isHdr = false;
static bool g_isMacro = false;
static bool g_isVideo = false;
size_t g_size = 0;

struct CameraBuildConfig {
    char *str;
    uint32_t focusMode;
    uint32_t cameraDeviceIndex;
    bool isVideo;
    bool isHdr;
    char *videoId;
};

static napi_value SetZoomRatio(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t zoomRatio;
    napi_get_value_int32(env, args[0], &zoomRatio);

    OH_LOG_ERROR(LOG_APP, "SetZoomRatio : %{public}d", zoomRatio);

    g_ndkCamera->setZoomRatioFn(zoomRatio);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value SetIsVideo(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    bool isVideo;
    napi_get_value_bool(env, args[0], &isVideo);

    g_isVideo = isVideo;
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value SetFrameRate(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    uint32_t minFps;
    napi_get_value_uint32(env, args[0], &minFps);

    uint32_t maxFps;
    napi_get_value_uint32(env, args[1], &maxFps);

    g_ndkCamera->PreviewOutputSetFrameRate(minFps, maxFps);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value SetWhiteBalance(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t whiteBalance;
    napi_get_value_int32(env, args[0], &whiteBalance);

    OH_LOG_ERROR(LOG_APP, "SetWhiteBalance : %{public}d", whiteBalance);

    g_ndkCamera->SetWhiteBalance(whiteBalance);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value EnableHdrVideo(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    bool isHdrVideo;
    napi_get_value_bool(env, args[0], &isHdrVideo);

    OH_LOG_ERROR(LOG_APP, "EnableHdrVideo : %{public}d", isHdrVideo);

    g_isHdr = isHdrVideo;
    g_ndkCamera->EnableHdrVideo(isHdrVideo);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value EnableMacro(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    bool isMacro;
    napi_get_value_bool(env, args[0], &isMacro);

    OH_LOG_ERROR(LOG_APP, "EnableMacro : %{public}d", isMacro);

    g_isMacro = isMacro;
    g_ndkCamera->EnableMacro(isMacro);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value EnableControlCenter(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    bool isControlCenter;
    napi_get_value_bool(env, args[0], &isControlCenter);

    OH_LOG_ERROR(LOG_APP, "EnableControlCenter : %{public}d", isControlCenter);

    g_isControlCenter = isControlCenter;
    g_ndkCamera->SetIsControl(isControlCenter);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value HasFlash(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "HasFlash");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t flashMode;
    napi_get_value_int32(env, args[0], &flashMode);

    OH_LOG_ERROR(LOG_APP, "HasFlash flashMode : %{public}d", flashMode);

    g_ndkCamera->HasFlashFn(flashMode);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsVideoStabilizationModeSupported(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "IsVideoStabilizationModeSupportedFn");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t videoMode;
    napi_get_value_int32(env, args[0], &videoMode);

    OH_LOG_ERROR(LOG_APP, "IsVideoStabilizationModeSupportedFn videoMode : %{public}d", videoMode);

    g_ndkCamera->IsVideoStabilizationModeSupportedFn(videoMode);
    napi_create_int32(env, argc, &result);
    return result;
}

static void SetCameraConfig(CameraBuildConfig config, NDKCamera::CameraBuildingConfig *cameraConfig)
{
    cameraConfig->str = config.str;
    cameraConfig->focusMode = config.focusMode;
    cameraConfig->cameraDeviceIndex = config.cameraDeviceIndex;
    cameraConfig->isVideo = config.isVideo;
    cameraConfig->isHdr = config.isHdr;
    cameraConfig->videoId = config.videoId;
}

static napi_value InitCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "InitCamera Start");
    size_t requireArgc = 3;
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    CameraBuildConfig configInner;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    configInner.str = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], configInner.str, typeLen + 1, &typeLen);

    napi_get_value_string_utf8(env, args[1], nullptr, 0, &typeLen);
    configInner.videoId = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[1], configInner.videoId, typeLen + 1, &typeLen);

    napi_get_value_uint32(env, args[ARGS_TWO], &configInner.focusMode);

    napi_get_value_uint32(env, args[ARGS_THREE], &configInner.cameraDeviceIndex);
    configInner.isVideo = g_isVideo;
    configInner.isHdr = g_isHdr;

    NDKCamera::CameraBuildingConfig cameraConfig;
    SetCameraConfig(configInner, &cameraConfig);

    if (g_ndkCamera) {
        delete g_ndkCamera;
        g_ndkCamera = nullptr;
    }
    g_ndkCamera = new NDKCamera(cameraConfig);
    if (g_isHdr) {
        g_ndkCamera->EnableHdrVideo(g_isHdr);
    }

    if (g_isMacro) {
        g_ndkCamera->EnableMacro(g_isMacro);
    }

    if (g_isControlCenter) {
        g_ndkCamera->EnableControlCenter(g_isControlCenter);
    }

    OH_LOG_ERROR(LOG_APP, "InitCamera End");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value ReleaseCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "ReleaseCamera Start");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char* surfaceId = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    g_ndkCamera->ReleaseCamera();
    if (g_ndkCamera) {
        OH_LOG_ERROR(LOG_APP, "g_ndkCamera is not null");
        delete g_ndkCamera;
        g_ndkCamera = nullptr;
    }
    OH_LOG_ERROR(LOG_APP, "ReleaseCamera End");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value ReleaseSession(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "ReleaseCamera Start");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char* surfaceId = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    g_ndkCamera->ReleaseSession();

    OH_LOG_ERROR(LOG_APP, "ReleaseCamera End");
    napi_create_int32(env, argc, &result);
    return result;
}
static napi_value StartPhotoOrVideo(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "StartPhotoOrVideo Start");
    Camera_ErrorCode ret = CAMERA_OK;
    size_t requireArgc = 3;
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    size_t videoIdLen = 0;
    size_t photoIdLen = 0;
    char* modeFlag = nullptr;
    char* videoId = nullptr;
    char* photoId = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    modeFlag = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], modeFlag, typeLen + 1, &typeLen);

    napi_get_value_string_utf8(env, args[1], nullptr, 0, &videoIdLen);
    videoId = new char[videoIdLen + 1];
    napi_get_value_string_utf8(env, args[1], videoId, videoIdLen + 1, &videoIdLen);

    napi_get_value_string_utf8(env, args[ARGS_TWO], nullptr, 0, &photoIdLen);
    photoId = new char[photoIdLen + 1];
    napi_get_value_string_utf8(env, args[ARGS_TWO], photoId, photoIdLen + 1, &photoIdLen);

    if (!strcmp(modeFlag, "photo")) {
        ret = g_ndkCamera->StartPhotoWithOutSurfaceId();
    } else if (!strcmp(modeFlag, "video")) {
        ret = g_ndkCamera->StartVideo(videoId, photoId);
        OH_LOG_ERROR(LOG_APP, "StartPhotoOrVideo %{public}s, %{public}s", videoId, photoId);
    }
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value VideoOutputStart(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "VideoOutputStart Start");
    napi_value result;
    Camera_ErrorCode ret = g_ndkCamera->VideoOutputStart();
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value IsExposureModeSupported(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "IsExposureModeSupported exposureMode start.");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t exposureMode;
    napi_get_value_int32(env, args[0], &exposureMode);

    OH_LOG_ERROR(LOG_APP, "IsExposureModeSupported exposureMode : %{public}d", exposureMode);

    g_ndkCamera->IsExposureModeSupportedFn(exposureMode);
    OH_LOG_INFO(LOG_APP, "IsExposureModeSupported exposureMode end.");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsMeteringPoint(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);
    int x;
    napi_get_value_int32(env, args[0], &x);

    napi_valuetype valuetype1;
    napi_typeof(env, args[0], &valuetype0);
    int y;
    napi_get_value_int32(env, args[1], &y);
    g_ndkCamera->IsMeteringPoint(x, y);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsExposureBiasRange(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "IsExposureBiasRange start.");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int exposureBiasValue;
    napi_get_value_int32(env, args[0], &exposureBiasValue);
    g_ndkCamera->IsExposureBiasRange(exposureBiasValue);
    OH_LOG_INFO(LOG_APP, "IsExposureBiasRange end.");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsFocusModeSupported(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "IsFocusModeSupported start.");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t focusMode;
    napi_get_value_int32(env, args[0], &focusMode);

    OH_LOG_ERROR(LOG_APP, "IsFocusModeSupportedFn videoMode : %{public}d", focusMode);

    g_ndkCamera->IsFocusModeSupported(focusMode);
    OH_LOG_INFO(LOG_APP, "IsFocusModeSupported end.");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value IsFocusPoint(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);
    double x;
    napi_get_value_double(env, args[0], &x);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);
    double y;
    napi_get_value_double(env, args[1], &y);

    float focusPointX = static_cast<float>(x);
    float focusPointY = static_cast<float>(y);
    g_ndkCamera->IsFocusPoint(focusPointX, focusPointY);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value GetVideoFrameWidth(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "GetVideoFrameWidth Start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value result = nullptr;
    napi_create_int32(env, g_ndkCamera->GetVideoFrameWidth(), &result);

    OH_LOG_ERROR(LOG_APP, "GetVideoFrameWidth End");
    return result;
}

static napi_value GetVideoFrameHeight(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "GetVideoFrameHeight Start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value result = nullptr;
    napi_create_int32(env, g_ndkCamera->GetVideoFrameHeight(), &result);

    OH_LOG_ERROR(LOG_APP, "GetVideoFrameHeight End");
    return result;
}

static napi_value GetVideoFrameRate(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "GetVideoFrameRate Start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value result = nullptr;
    napi_create_int32(env, g_ndkCamera->GetVideoFrameRate(), &result);

    OH_LOG_ERROR(LOG_APP, "GetVideoFrameRate End");
    return result;
}

static napi_value GetVideoRotation(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "GetVideoRotation start");
    napi_value result;
    napi_get_undefined(env, &result);
    napi_value js_value; // 保存传递的 JavaScript 值
    size_t argc = 1;
    napi_get_cb_info(env, info, &argc, &js_value, nullptr, nullptr);

    int32_t deviceDegree = 0;
    napi_status status = napi_get_value_int32(env, js_value, &deviceDegree);
    OH_LOG_ERROR(LOG_APP, "GetVideoRotation deviceDegree:%{public}d", deviceDegree);

    int32_t videoRotation = 0; // 用于保存视频旋转角度
    if (g_ndkCamera) {
        OH_LOG_ERROR(LOG_APP, "g_ndkCamera is not null");
        // 调用 g_ndkCamera 获取视频旋转角度
        videoRotation = g_ndkCamera->GetVideoRotation(deviceDegree);
    }
    // 创建一个返回的 napi_value，将 videoRotation 转换为 JavaScript 中的整数
    napi_create_int32(env, videoRotation, &result);
    return result;
}

static napi_value VideoOutputStopAndRelease(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "VideoOutputStopAndRelease Start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value result = nullptr;
    g_ndkCamera->VideoOutputStop();

    OH_LOG_ERROR(LOG_APP, "VideoOutputStopAndRelease End");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value TakePicture(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "TakePicture Start");
    napi_value result;
    napi_get_undefined(env, &result);
    napi_value js_value; // 保存传递的 JavaScript 值
    size_t argc = 1;
    napi_get_cb_info(env, info, &argc, &js_value, nullptr, nullptr);

    int32_t deviceDegree = 0;
    napi_status status = napi_get_value_int32(env, js_value, &deviceDegree);
    OH_LOG_ERROR(LOG_APP, "TakePicture deviceDegree:%{public}d", deviceDegree);
    Camera_ErrorCode ret = g_ndkCamera->TakePicture(deviceDegree);
    OH_LOG_ERROR(LOG_APP, "TakePicture result is %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// [Start napi_buffer_callback]
// NAPI层buffer回调方法。
static void BufferCb(void* buffer, size_t size)
{
    OH_LOG_INFO(LOG_APP, "BufferCb size:%{public}zu", size);
    g_size = size;
    napi_value asyncResource = nullptr;
    napi_value asyncResourceName = nullptr;
    napi_async_work work;

    if (size == 0 || size > SIZE_MAX) {
        OH_LOG_ERROR(LOG_APP, "BufferCb size is invalid");
        return;
    }
    void* copyBuffer = malloc(size);
    if (copyBuffer == nullptr) {
        return;
    }
    OH_LOG_INFO(LOG_APP, "BufferCb copyBuffer:%{public}p", copyBuffer);
    // 使用std::memcpy复制buffer的内容到copyBuffer。
    std::memcpy(copyBuffer, buffer, size);
    napi_create_string_utf8(env_, "BufferCb", NAPI_AUTO_LENGTH, &asyncResourceName);
    napi_status status = napi_create_async_work(
        env_, asyncResource, asyncResourceName, [](napi_env env, void* copyBuffer) {},
        [](napi_env env, napi_status status, void* copyBuffer) {
            napi_value retVal;
            napi_value callback = nullptr;
            void* data = nullptr;
            napi_value arrayBuffer = nullptr;
            size_t bufferSize = g_size;
            napi_create_arraybuffer(env, bufferSize, &data, &arrayBuffer);
            std::memcpy(data, copyBuffer, bufferSize);
            OH_LOG_INFO(LOG_APP, "BufferCb g_size: %{public}zu", g_size);
            napi_get_reference_value(env, bufferCbRef_, &callback);
            if (callback) {
                OH_LOG_INFO(LOG_APP, "BufferCb callback is full");
            } else {
                OH_LOG_ERROR(LOG_APP, "BufferCb callback is null");
            }
            // 调用ArkTS的buffer处理回调函数，将图片arrayBuffer传给页面做显示或保存。
            napi_call_function(env, nullptr, callback, 1, &arrayBuffer, &retVal);
        },
        copyBuffer, &work);
    // 错误检查：创建异步工作失败时释放内存。
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Failed to create async work");
        free(copyBuffer); // 释放分配的内存。
        return;
    }
    napi_queue_async_work_with_qos(env_, work, napi_qos_user_initiated);
}
// [End napi_buffer_callback]

// 保存ArkTS侧传入的buffer处理回调函数。
static napi_value SetBufferCb(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "SetBufferCb start");
    napi_value result;
    napi_get_undefined(env, &result);

    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr);

    env_ = env;
    napi_create_reference(env, argValue[0], 1, &bufferCbRef_);
    if (bufferCbRef_) {
        OH_LOG_INFO(LOG_APP, "SetBufferCb callbackRef is full");
    } else {
        OH_LOG_ERROR(LOG_APP, "SetBufferCb callbackRef is null");
    }
    // 注册ArkTS侧buffer回调到NAPI层。
    g_ndkCamera->RegisterBufferCb(reinterpret_cast<void *>(BufferCb));
    return result;
}


EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "initCamera", nullptr, InitCamera, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "startPhotoOrVideo", nullptr, StartPhotoOrVideo, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "videoOutputStart", nullptr, VideoOutputStart, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setZoomRatio", nullptr, SetZoomRatio, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setFrameRate", nullptr, SetFrameRate, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "enableHdrVideo", nullptr, EnableHdrVideo, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "enableMacro", nullptr, EnableMacro, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "enableControlCenter", nullptr, EnableControlCenter, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setWhiteBalance", nullptr, SetWhiteBalance, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "hasFlash", nullptr, HasFlash, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isVideoStabilizationModeSupported", nullptr, IsVideoStabilizationModeSupported,
            nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isExposureModeSupported", nullptr, IsExposureModeSupported,
            nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isMeteringPoint", nullptr, IsMeteringPoint, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isExposureBiasRange", nullptr, IsExposureBiasRange, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isFocusModeSupported", nullptr, IsFocusModeSupported, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isFocusPoint", nullptr, IsFocusPoint, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoFrameWidth", nullptr, GetVideoFrameWidth, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoFrameHeight", nullptr, GetVideoFrameHeight, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoFrameRate", nullptr, GetVideoFrameRate, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoRotation", nullptr, GetVideoRotation, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "videoOutputStopAndRelease", nullptr, VideoOutputStopAndRelease,
            nullptr, nullptr, nullptr, napi_default, nullptr },
        { "takePicture", nullptr, TakePicture, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "releaseSession", nullptr, ReleaseSession, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "releaseCamera", nullptr, ReleaseCamera, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setBufferCb", nullptr, SetBufferCb, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setIsVideo", nullptr, SetIsVideo, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version =1,
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