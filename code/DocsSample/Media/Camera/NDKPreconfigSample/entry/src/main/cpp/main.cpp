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

#include <cstddef>
#include <cstdint>
#include <js_native_api.h>
#include "camera_manager.h"

#define LOG_TAG "DEMO:"
#define LOG_DOMAIN 0x3200

using namespace OHOS_CAMERA_SAMPLE;
static NDKCamera* g_ndkCamera = nullptr;
const int32_t ARGS_TWO = 2;
const int32_t ARGS_THREE = 3;
const int32_t ARGS_FOUR = 4;
const int32_t ARGS_FIVE = 5;
const int32_t ARGS_SIX = 6;
const int32_t ARGS_SEVEN = 7;
const int32_t ARGS_EIGHT = 8;
const int32_t ARGS_NINE = 9;
struct CaptureSetting {
    int32_t quality;
    int32_t rotation;
    int32_t location;
    bool mirror;
    int32_t latitude;
    int32_t longitude;
    int32_t altitude;
};

struct CameraBuildConfig {
    char *str;
    uint32_t focusMode;
    uint32_t cameraDeviceIndex;
    uint32_t sceneMode;
    uint32_t preconfigMode;
    uint32_t preconfigType;
    uint32_t preconfigRatio;
    uint32_t photoOutputType;
    char *videoId;
    char *photoId;
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

static napi_value SetRequestOption(napi_env env, napi_callback_info info)
{
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    int32_t requestOption;
    napi_get_value_int32(env, args[0], &requestOption);

    OH_LOG_ERROR(LOG_APP, "SetRequestOptinon : %{public}d", requestOption);

    g_ndkCamera->SetRequestOption(requestOption);
    napi_create_int32(env, argc, &result);
    return result;
}

static void SetCameraConfig(CameraBuildConfig config, NDKCamera::CameraBuildingConfig *cameraConfig)
{
    cameraConfig->str = config.str;
    cameraConfig->focusMode = config.focusMode;
    cameraConfig->cameraDeviceIndex = config.cameraDeviceIndex;
    cameraConfig->sceneMode = config.sceneMode;
    cameraConfig->preconfigMode = config.preconfigMode;
    cameraConfig->preconfigType = config.preconfigType;
    cameraConfig->preconfigRatio = config.preconfigRatio;
    cameraConfig->photoOutputType = config.photoOutputType;
    cameraConfig->videoId = config.videoId;
    cameraConfig->photoId = config.photoId;
}

static napi_value InitCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "InitCamera Start");
    size_t requireArgc = 10;
    size_t argc = 10;
    napi_value args[10] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    CameraBuildConfig configInner;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    configInner.str = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], configInner.str, typeLen + 1, &typeLen);

    napi_get_value_uint32(env, args[1], &configInner.focusMode);

    napi_get_value_uint32(env, args[ARGS_TWO], &configInner.cameraDeviceIndex);

    napi_get_value_uint32(env, args[ARGS_THREE], &configInner.sceneMode);

    napi_get_value_uint32(env, args[ARGS_FOUR], &configInner.preconfigMode);

    napi_get_value_uint32(env, args[ARGS_FIVE], &configInner.preconfigType);

    napi_get_value_uint32(env, args[ARGS_SIX], &configInner.preconfigRatio);

    napi_get_value_uint32(env, args[ARGS_SEVEN], &configInner.photoOutputType);

    napi_get_value_string_utf8(env, args[ARGS_EIGHT], nullptr, 0, &typeLen);
    configInner.videoId = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[ARGS_EIGHT], configInner.videoId, typeLen + 1, &typeLen);

    napi_get_value_string_utf8(env, args[ARGS_NINE], nullptr, 0, &typeLen);
    configInner.photoId = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[ARGS_NINE], configInner.photoId, typeLen + 1, &typeLen);

    NDKCamera::CameraBuildingConfig cameraConfig;

    SetCameraConfig(configInner, &cameraConfig);

    if (g_ndkCamera) {
        delete g_ndkCamera;
        g_ndkCamera = nullptr;
    }
    g_ndkCamera = new NDKCamera(cameraConfig);
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

static napi_value ChangeRequestDiscardCameraPhoto(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "ReleaseCamera Start");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char* surfaceId = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    g_ndkCamera->ChangeRequestDiscardCameraPhoto();

    OH_LOG_ERROR(LOG_APP, "ReleaseCamera End");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value ChangeRequestSaveCameraPhoto(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "ReleaseCamera Start");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char* surfaceId = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    g_ndkCamera->ChangeRequestSaveCameraPhoto();

    OH_LOG_ERROR(LOG_APP, "ReleaseCamera End");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_ref callbackRef = nullptr;
static napi_env g_env;

static napi_value RequestImage(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "RequestImageCb start uri");
    napi_value result;
    napi_get_undefined(env, &result);

    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr);

    g_env = env;
    napi_create_reference(env, argValue[0], 1, &callbackRef);
    if (callbackRef) {
        OH_LOG_ERROR(LOG_APP, "RequestImageCb callbackRef is full");
    } else {
        OH_LOG_ERROR(LOG_APP, "RequestImageCb callbackRef is null");
    }
    return result;
}

static void RequestImageCb(char *buffer)
{
    OH_LOG_ERROR(LOG_APP, "uri = %{public}s", buffer);
    napi_value resource = nullptr;
    napi_async_work work;
    napi_create_string_utf8(g_env, "RequestImageCb", NAPI_AUTO_LENGTH, &resource);
    napi_create_async_work(
        g_env,
        nullptr,
        resource,
        [](napi_env env, void* buffer) {
        },
        [](napi_env env, napi_status status, void* buffer) {
            napi_value result = nullptr;
            napi_value retVal;
            napi_value callback = nullptr;
            napi_create_string_utf8(env, (const char *)buffer, NAPI_AUTO_LENGTH, &result);
            napi_get_reference_value(g_env, callbackRef, &callback);
            if (callback) {
                OH_LOG_ERROR(LOG_APP, "RequestImageCb callback is full");
            } else {
                OH_LOG_ERROR(LOG_APP, "RequestImageCb callback is null");
            }
            napi_call_function(g_env, nullptr, callback, 1, &result, &retVal);
        },
        reinterpret_cast<void*>(buffer), &work);
    napi_queue_async_work(g_env, work);
}

static napi_ref callbackRef2 = nullptr;
static napi_env g_env2;

static napi_value RequestImageQuality(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "RequestImageQuality");
    napi_value result;
    napi_get_undefined(env, &result);

    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr);

    g_env2 = env;
    napi_create_reference(env, argValue[0], 1, &callbackRef2);
    if (callbackRef2) {
        OH_LOG_ERROR(LOG_APP, "RequestImageCb callbackRef is full");
    } else {
        OH_LOG_ERROR(LOG_APP, "RequestImageCb callbackRef is null");
    }
    return result;
}

static void RequestImageQualityCb(char *quality)
{
    OH_LOG_ERROR(LOG_APP, "quality = %{public}s", quality);
    napi_value resource = nullptr;
    napi_async_work work;
    napi_create_string_utf8(g_env2, "RequestImageQualityCb", NAPI_AUTO_LENGTH, &resource);
    napi_create_async_work(
        g_env2,
        nullptr,
        resource,
        [](napi_env env, void* quality) {
        },
        [](napi_env env, napi_status status, void* quality) {
            napi_value result = nullptr;
            napi_value retVal;
            napi_value callback = nullptr;
            napi_create_string_utf8(env, (const char *)quality, NAPI_AUTO_LENGTH, &result);
            napi_get_reference_value(g_env, callbackRef2, &callback);
            if (callback) {
                OH_LOG_ERROR(LOG_APP, "RequestImageCb callback is full");
            } else {
                OH_LOG_ERROR(LOG_APP, "RequestImageCb callback is null");
            }
            napi_call_function(g_env2, nullptr, callback, 1, &result, &retVal);
        },
        reinterpret_cast<void*>(quality), &work);
    napi_queue_async_work(g_env2, work);
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
        ret = g_ndkCamera->StartPhoto(photoId);
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

static napi_value GetCaptureParam(napi_env env, napi_value captureConfigValue, CaptureSetting *config)
{
    napi_value value = nullptr;
    napi_get_named_property(env, captureConfigValue, "quality", &value);
    napi_get_value_int32(env, value, &config->quality);

    napi_get_named_property(env, captureConfigValue, "rotation", &value);
    napi_get_value_int32(env, value, &config->rotation);

    napi_get_named_property(env, captureConfigValue, "mirror", &value);
    napi_get_value_bool(env, value, &config->mirror);

    napi_get_named_property(env, captureConfigValue, "latitude", &value);
    napi_get_value_int32(env, value, &config->latitude);

    napi_get_named_property(env, captureConfigValue, "longitude", &value);
    napi_get_value_int32(env, value, &config->longitude);

    napi_get_named_property(env, captureConfigValue, "altitude", &value);
    napi_get_value_int32(env, value, &config->altitude);

    OH_LOG_INFO(LOG_APP, "get quality %{public}d, rotation %{public}d, mirror %{public}d, latitude "
        "%{public}d, longitude %{public}d, altitude %{public}d", config->quality, config->rotation,
        config->mirror, config->latitude, config->longitude, config->altitude);
    return 0;
}
static void SetConfig(CaptureSetting settings, Camera_PhotoCaptureSetting* photoSetting, Camera_Location* location)
{
    if (photoSetting == nullptr || location == nullptr) {
        OH_LOG_INFO(LOG_APP, "photoSetting is null");
    }
    photoSetting->quality = static_cast<Camera_QualityLevel>(settings.quality);
    photoSetting->rotation = static_cast<Camera_ImageRotation>(settings.rotation);
    photoSetting->mirror = settings.mirror;
    location->altitude = settings.altitude;
    location->latitude = settings.latitude;
    location->longitude = settings.longitude;
    photoSetting->location = location;
}

static napi_value TakePictureWithSettings(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "TakePictureWithSettings Start");
    size_t requireArgc = 1;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    Camera_PhotoCaptureSetting photoSetting;
    CaptureSetting settingInner;
    Camera_Location* location = new Camera_Location;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    GetCaptureParam(env, args[0], &settingInner);
    SetConfig(settingInner, &photoSetting, location);

    napi_value result;
    Camera_ErrorCode ret = g_ndkCamera->TakePictureWithPhotoSettings(photoSetting);
    OH_LOG_ERROR(LOG_APP, "TakePictureWithSettings result is %{public}d", ret);
    napi_create_int32(env, ret, &result);
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
        { "setRequestOption", nullptr, SetRequestOption, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isExposureModeSupported", nullptr, IsExposureModeSupported,
            nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isMeteringPoint", nullptr, IsMeteringPoint, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isExposureBiasRange", nullptr, IsExposureBiasRange, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isFocusModeSupported", nullptr, IsFocusModeSupported, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isFocusPoint", nullptr, IsFocusPoint, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoFrameWidth", nullptr, GetVideoFrameWidth, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoFrameHeight", nullptr, GetVideoFrameHeight, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getVideoFrameRate", nullptr, GetVideoFrameRate, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "videoOutputStopAndRelease", nullptr, VideoOutputStopAndRelease,
            nullptr, nullptr, nullptr, napi_default, nullptr },
        { "takePicture", nullptr, TakePicture, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "takePictureWithSettings", nullptr, TakePictureWithSettings, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        { "releaseSession", nullptr, ReleaseSession, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "requestImage", nullptr, RequestImage, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "changeRequestDiscardCameraPhoto", nullptr, ChangeRequestDiscardCameraPhoto, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        { "changeRequestSaveCameraPhoto", nullptr, ChangeRequestSaveCameraPhoto, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        { "requestImageQuality", nullptr, RequestImageQuality, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "releaseCamera", nullptr, ReleaseCamera, nullptr, nullptr, nullptr, napi_default, nullptr },

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