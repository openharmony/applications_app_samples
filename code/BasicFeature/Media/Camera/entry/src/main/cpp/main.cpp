/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

#include <js_native_api.h>
#include "camera_manager.h"

#define LOG_TAG "DEMO:"
#define LOG_DOMAIN 0x3200

using namespace OHOS_CAMERA_SAMPLE;
static NDKCamera* ndkCamera_ = nullptr;
const int32_t ARGS_TWO = 2;
struct Capture_Setting {
    int32_t quality;
    int32_t rotation;
    int32_t location;
    bool mirror;
    int32_t latitude;
    int32_t longitude;
    int32_t altitude;
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

    ndkCamera_->setZoomRatioFn(zoomRatio);
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

    ndkCamera_->HasFlashFn(flashMode);
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

    ndkCamera_->IsVideoStabilizationModeSupportedFn(videoMode);
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value InitCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "InitCamera Start");
    size_t requireArgc = 3;
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char* surfaceId = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    surfaceId = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], surfaceId, typeLen + 1, &typeLen);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    int32_t focusMode;
    napi_get_value_int32(env, args[1], &focusMode);

    uint32_t cameraDeviceIndex;
    napi_get_value_uint32(env, args[ARGS_TWO], &cameraDeviceIndex);

    OH_LOG_ERROR(LOG_APP, "InitCamera focusMode : %{public}d", focusMode);
    OH_LOG_ERROR(LOG_APP, "InitCamera surfaceId : %{public}s", surfaceId);
    OH_LOG_ERROR(LOG_APP, "InitCamera cameraDeviceIndex : %{public}d", cameraDeviceIndex);

    if (ndkCamera_) {
        OH_LOG_ERROR(LOG_APP, "ndkCamera_ is not null");
        delete ndkCamera_;
        ndkCamera_ = nullptr;
    }
    ndkCamera_ = new NDKCamera(surfaceId, focusMode, cameraDeviceIndex);
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

    ndkCamera_->ReleaseCamera();
    if (ndkCamera_) {
        OH_LOG_ERROR(LOG_APP, "ndkCamera_ is not null");
        delete ndkCamera_;
        ndkCamera_ = nullptr;
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

    ndkCamera_->ReleaseSession();

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
        OH_LOG_ERROR(LOG_APP, "StartPhoto surfaceId %{public}s", photoId);
        ret = ndkCamera_->StartPhoto(photoId);
    } else if (!strcmp(modeFlag, "video")) {
        ret = ndkCamera_->StartVideo(videoId, photoId);
        OH_LOG_ERROR(LOG_APP, "StartPhotoOrVideo %{public}s, %{public}s", videoId, photoId);
    }
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value VideoOutputStart(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "VideoOutputStart Start");
    napi_value result;
    Camera_ErrorCode ret = ndkCamera_->VideoOutputStart();
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

    ndkCamera_->IsExposureModeSupportedFn(exposureMode);
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
    ndkCamera_->IsMeteringPoint(x, y);
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
    ndkCamera_->IsExposureBiasRange(exposureBiasValue);
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

    ndkCamera_->IsFocusModeSupported(focusMode);
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
    ndkCamera_->IsFocusPoint(focusPointX, focusPointY);
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
    napi_create_int32(env, ndkCamera_->GetVideoFrameWidth(), &result);

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
    napi_create_int32(env, ndkCamera_->GetVideoFrameHeight(), &result);

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
    napi_create_int32(env, ndkCamera_->GetVideoFrameRate(), &result);

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
    ndkCamera_->VideoOutputStop();
    ndkCamera_->VideoOutputRelease();

    OH_LOG_ERROR(LOG_APP, "VideoOutputStopAndRelease End");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value TakePicture(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "TakePicture Start");
    napi_value result;
    Camera_ErrorCode ret = ndkCamera_->TakePicture();
    OH_LOG_ERROR(LOG_APP, "TakePicture result is %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value GetCaptureParam(napi_env env, napi_value captureConfigValue, Capture_Setting *config)
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
static void SetConfig(Capture_Setting settings, Camera_PhotoCaptureSetting* photoSetting, Camera_Location* location)
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
    Capture_Setting setting_inner;
    Camera_Location* location = new Camera_Location;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    GetCaptureParam(env, args[0], &setting_inner);
    SetConfig(setting_inner, &photoSetting, location);

    napi_value result;
    Camera_ErrorCode ret = ndkCamera_->TakePictureWithPhotoSettings(photoSetting);
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
        { "hasFlash", nullptr, HasFlash, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isVideoStabilizationModeSupported", nullptr, IsVideoStabilizationModeSupported,
            nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isExposureModeSupported", nullptr, IsExposureModeSupported,
            nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isMeteringPoint", nullptr, IsMeteringPoint, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "isExposureBiasRange", nullptr, IsExposureBiasRange, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "IsFocusModeSupported", nullptr, IsFocusModeSupported, nullptr, nullptr, nullptr, napi_default, nullptr },
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
        { "releaseCamera", nullptr, ReleaseCamera, nullptr, nullptr, nullptr, napi_default, nullptr }
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