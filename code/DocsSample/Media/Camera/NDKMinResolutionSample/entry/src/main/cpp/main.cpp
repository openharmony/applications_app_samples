/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
static NDKCamera* g_ndkCamera = nullptr;
const int32_t ARGS_TWO = 2;
const int32_t ARGS_THREE = 3;
const int32_t ARGS_FOUR = 4;
const int32_t ARGS_FIVE = 5;
static napi_ref bufferCbRef_ = nullptr;
static napi_env env_;
size_t g_size = 0;
struct CaptureSetting {
    int32_t quality;
    int32_t rotation;
    int32_t location;
    bool mirror;
    int32_t latitude;
    int32_t longitude;
    int32_t altitude;
};

struct DesiredRes {
    uint32_t previewW = 1920, previewH = 1080;
    uint32_t photoW = 1920, photoH = 1080;
    uint32_t videoW = 1920, videoH = 1080;
};
static DesiredRes g_desired;

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

static napi_value InitCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "InitCamera Start");
    size_t requireArgc = 3;
    size_t argc = 6;
    napi_value args[6] = {nullptr};
    napi_value result;
    size_t typeLen = 0;
    char* surfaceId = nullptr;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    surfaceId = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], surfaceId, typeLen + 1, &typeLen);
    
    char* videoId = nullptr;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &typeLen);
    videoId = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[1], videoId, typeLen + 1, &typeLen);
    
    char* photoId = nullptr;
    napi_get_value_string_utf8(env, args[ARGS_TWO], nullptr, 0, &typeLen);
    photoId = new char[typeLen + ARGS_TWO];
    napi_get_value_string_utf8(env, args[ARGS_TWO], photoId, typeLen + 1, &typeLen);

    int32_t sceneMode;
    napi_get_value_int32(env, args[ARGS_THREE], &sceneMode);
    
    int32_t focusMode;
    napi_get_value_int32(env, args[ARGS_FOUR], &focusMode);

    uint32_t cameraDeviceIndex;
    napi_get_value_uint32(env, args[ARGS_FIVE], &cameraDeviceIndex);

    OH_LOG_ERROR(LOG_APP, "InitCamera focusMode : %{public}d", focusMode);
    OH_LOG_ERROR(LOG_APP, "InitCamera surfaceId : %{public}s", surfaceId);
    OH_LOG_ERROR(LOG_APP, "InitCamera cameraDeviceIndex : %{public}d", cameraDeviceIndex);

    if (g_ndkCamera) {
        OH_LOG_ERROR(LOG_APP, "g_ndkCamera is not null");
        delete g_ndkCamera;
        g_ndkCamera = nullptr;
    }
    g_ndkCamera = new NDKCamera(surfaceId, focusMode, cameraDeviceIndex, g_desired.previewW, g_desired.previewH,
                               videoId, photoId, static_cast<Camera_SceneMode>(sceneMode));
    if (g_desired.previewW && g_desired.previewH) {
        g_ndkCamera->SetPreviewResolution(g_desired.previewW, g_desired.previewH);
        OH_LOG_INFO(LOG_APP, "SetPreviewResolution %{public}u*%{public}u", g_desired.previewW, g_desired.previewH);
    }
    if (g_desired.photoW && g_desired.photoH) {
        g_ndkCamera->SetPhotoResolution(g_desired.photoW, g_desired.photoH);
        OH_LOG_INFO(LOG_APP, "SetPhotoResolution %{public}u*%{public}u", g_desired.photoW, g_desired.photoH);
    }
    if (g_desired.videoW && g_desired.videoH) {
        g_ndkCamera->SetVideoResolution(g_desired.videoW, g_desired.videoH);
        OH_LOG_INFO(LOG_APP, "SetVideoResolution %{public}u*%{public}u", g_desired.videoW, g_desired.videoH);
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
    napi_create_int32(env, g_desired.videoW, &result);
    
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
    napi_create_int32(env, g_desired.videoH, &result);
    
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

//add resolutions
static napi_value MakeSizeArray(napi_env env, const std::vector<Camera_Size>& sizes)
{
    napi_value arr;
    napi_create_array_with_length(env, sizes.size(), &arr);
    for (size_t i = 0; i < sizes.size(); ++i) {
        napi_value obj;
        napi_create_object(env, &obj);
        napi_value w;
        napi_value h;
        napi_create_int32(env, sizes[i].width, &w);
        napi_create_int32(env, sizes[i].height, &h);
        napi_set_named_property(env, obj, "width", w);
        napi_set_named_property(env, obj, "height", h);
        napi_set_element(env, arr, i, obj);
    }
    return arr;
}

static napi_value GetSupportedPreviewResolutions(napi_env env, napi_callback_info info)
{
    std::vector<Camera_Size> sizes;
    Camera_ErrorCode ret = g_ndkCamera->GetSupportedPreviewSizes(sizes);
    if (ret != CAMERA_OK) {
        napi_value r;
        napi_get_undefined(env, &r);
        return r;
    }
    return MakeSizeArray(env, sizes);
}

static napi_value GetSupportedPhotoResolutions(napi_env env, napi_callback_info info)
{
    std::vector<Camera_Size> sizes;
    Camera_ErrorCode ret = g_ndkCamera->GetSupportedPhotoSizes(sizes);
    if (ret != CAMERA_OK) {
        napi_value r;
        napi_get_undefined(env, &r);
        return r;
    }
    return MakeSizeArray(env, sizes);
}

static napi_value GetSupportedVideoResolutions(napi_env env, napi_callback_info info)
{
    std::vector<Camera_Size> sizes;
    Camera_ErrorCode ret = g_ndkCamera->GetSupportedVideoSizes(sizes);
    if (ret != CAMERA_OK) {
        napi_value r;
        napi_get_undefined(env, &r);
        return r;
    }
    return MakeSizeArray(env, sizes);
}

static napi_value SetPreviewResolution(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2]{};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARGS_TWO) {
        napi_value r;
        napi_get_undefined(env, &r);
        return r;
    }

    uint32_t w = 0;
    uint32_t h = 0;
    napi_get_value_uint32(env, args[0], &w);
    napi_get_value_uint32(env, args[1], &h);
    g_desired.previewW = w;
    g_desired.previewH = h;
    Camera_ErrorCode ret = g_ndkCamera->SetPreviewResolution(w, h);

    napi_value res;
    napi_create_int32(env, ret, &res);
    return res;
}

static napi_value SetPhotoResolution(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2]{};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARGS_TWO) {
        napi_value r;
        napi_get_undefined(env, &r);
        return r;
    }

    uint32_t w = 0;
    uint32_t h = 0;
    napi_get_value_uint32(env, args[0], &w);
    napi_get_value_uint32(env, args[1], &h);
    g_desired.photoW = w;
    g_desired.photoH = h;
    Camera_ErrorCode ret = g_ndkCamera->SetPhotoResolution(w, h);

    napi_value res;
    napi_create_int32(env, ret, &res);
    return res;
}

static napi_value SetVideoResolution(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2]{};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARGS_TWO) {
        napi_value r;
        napi_get_undefined(env, &r);
        return r;
    }

    uint32_t w = 0;
    uint32_t h = 0;
    napi_get_value_uint32(env, args[0], &w);
    napi_get_value_uint32(env, args[1], &h);
    g_desired.videoW = w;
    g_desired.videoH = h;
    Camera_ErrorCode ret = g_ndkCamera->SetVideoResolution(w, h);

    napi_value res;
    napi_create_int32(env, ret, &res);
    return res;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"initCamera", nullptr, InitCamera, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startPhotoOrVideo", nullptr, StartPhotoOrVideo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"videoOutputStart", nullptr, VideoOutputStart, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setZoomRatio", nullptr, SetZoomRatio, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setFrameRate", nullptr, SetFrameRate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"hasFlash", nullptr, HasFlash, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isVideoStabilizationModeSupported", nullptr, IsVideoStabilizationModeSupported, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"isExposureModeSupported", nullptr, IsExposureModeSupported, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isMeteringPoint", nullptr, IsMeteringPoint, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isExposureBiasRange", nullptr, IsExposureBiasRange, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isFocusModeSupported", nullptr, IsFocusModeSupported, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isFocusPoint", nullptr, IsFocusPoint, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVideoFrameWidth", nullptr, GetVideoFrameWidth, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVideoFrameHeight", nullptr, GetVideoFrameHeight, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVideoFrameRate", nullptr, GetVideoFrameRate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVideoRotation", nullptr, GetVideoRotation, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"videoOutputStopAndRelease", nullptr, VideoOutputStopAndRelease, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"takePicture", nullptr, TakePicture, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"takePictureWithSettings", nullptr, TakePictureWithSettings, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseSession", nullptr, ReleaseSession, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseCamera", nullptr, ReleaseCamera, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSupportedPreviewResolutions", nullptr, GetSupportedPreviewResolutions, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"getSupportedPhotoResolutions", nullptr, GetSupportedPhotoResolutions, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"getSupportedVideoResolutions", nullptr, GetSupportedVideoResolutions, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"setPreviewResolution", nullptr, SetPreviewResolution, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPhotoResolution", nullptr, SetPhotoResolution, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setVideoResolution", nullptr, SetVideoResolution, nullptr, nullptr, nullptr, napi_default, nullptr},
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