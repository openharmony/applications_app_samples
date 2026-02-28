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
static NDKCamera *g_ndkCamera = nullptr;
static bool g_isSinglePhoto = false;
const int32_t ARGS_TWO = 2;
const int32_t IMAGE_QUALITY = 98;
const int32_t MIME_TYPE_SIZE = 256;

struct CameraBuildConfig {
    char *str;
    uint32_t focusMode;
    uint32_t cameraDeviceIndex;
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

static void SetCameraConfig(CameraBuildConfig config, NDKCamera::CameraBuildingConfig *cameraConfig)
{
    cameraConfig->str = config.str;
    cameraConfig->focusMode = config.focusMode;
    cameraConfig->cameraDeviceIndex = config.cameraDeviceIndex;
}

static napi_value InitCamera(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "InitCamera Start");
    size_t requireArgc = 3;
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_value result;
    CameraBuildConfig configInner;
    size_t typeLen = 0;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_string_utf8(env, args[0], nullptr, 0, &typeLen);
    configInner.str = new char[typeLen + 1];
    napi_get_value_string_utf8(env, args[0], configInner.str, typeLen + 1, &typeLen);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    napi_get_value_uint32(env, args[1], &configInner.focusMode);

    napi_get_value_uint32(env, args[ARGS_TWO], &configInner.cameraDeviceIndex);

    NDKCamera::CameraBuildingConfig cameraConfig;

    SetCameraConfig(configInner, &cameraConfig);
    if (g_ndkCamera) {
        delete g_ndkCamera;
        g_ndkCamera = nullptr;
    }
    g_ndkCamera = new NDKCamera(cameraConfig);
    g_ndkCamera->SetPhotoOutputCallback(g_isSinglePhoto);
    
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

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    g_ndkCamera->ReleaseSession();

    OH_LOG_ERROR(LOG_APP, "ReleaseCamera End");
    napi_create_int32(env, argc, &result);
    return result;
}

static napi_value StartPhoto(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "StartPhotoOrVideo Start");

    size_t argc = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t degree;
    napi_get_value_int32(env, args[0], &degree);

    Camera_ErrorCode ret = CAMERA_OK;

    ret = g_ndkCamera->TakePicture(degree);

    napi_value result;
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

static napi_value SetPhotoOutputCallback(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "SetPhotoOutputCallback start.");
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    bool isSinglePhoto;
    napi_get_value_bool(env, args[0], &isSinglePhoto);
    g_isSinglePhoto = isSinglePhoto;

    g_ndkCamera->SetPhotoOutputCallback(isSinglePhoto);
    OH_LOG_INFO(LOG_APP, "SetPhotoOutputCallback end.");
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

void SetPackOptions(OH_PackingOptions * options, Image_String format, unsigned int quality, bool isNeedPack)
{
    OH_PackingOptions_SetMimeType(options, &format);
    OH_PackingOptions_SetQuality(options, quality);
    OH_PackingOptions_SetNeedsPackProperties(options, isNeedPack);
}

static napi_value GetPixelMap(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result = nullptr;

    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok || argc < 1 || args[0] == nullptr) {
        napi_throw_type_error(env, nullptr, "Argument must be a string.");
        return result;
    }
    // 获取编码文件路径。
    uint32_t fd = 0;
    napi_get_value_uint32(env, args[0], &fd);
    // 获取图片类型。
    char imageMimeType[MIME_TYPE_SIZE];
    size_t imageMimeLen;
    if (napi_get_value_string_utf8(env, args[1], imageMimeType, sizeof(imageMimeType), &imageMimeLen) != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to get string value.");
        return result;
    }
    // 将pixelMap编码到文件中。
    OH_ImagePackerNative *imagePackerObj = nullptr;
    Image_ErrorCode error = OH_ImagePackerNative_Create(&imagePackerObj);
    if (error != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImagePackerNative_Create failed, errCode: %{public}d.", error);
        return result;
    }
    OH_PackingOptions *packerOptions = nullptr;
    OH_PackingOptions_Create(&packerOptions);
    Image_MimeType format;
    format.size = std::strlen(imageMimeType);
    format.data = const_cast<char *>(imageMimeType);
    uint32_t quality = IMAGE_QUALITY;
    bool isNeedsPackProperties = true;
    SetPackOptions(packerOptions, format, quality, isNeedsPackProperties);
    OH_PixelmapNative* resPixMap = g_ndkCamera->GetPixelMap();
    if (resPixMap == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ImagePackerNativeCTest failed, pixel is null");
    }
    Image_ErrorCode err = OH_ImagePackerNative_PackToFileFromPixelmap(imagePackerObj, packerOptions, resPixMap, fd);
    if (err != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ImagePackerNativeCTest PackToFileFromPixelmap failed, errCode: %{public}d.", err);
        return result;
    }
    // 释放资源。
    OH_PackingOptions_Release(packerOptions);
    free(imagePackerObj);
    OH_PixelmapNative_Release(resPixMap);
    return result;
}

static napi_value IsSingle(napi_env env, napi_callback_info info)
{
    OH_LOG_ERROR(LOG_APP, "IsSingle Start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value result = nullptr;
    napi_create_int32(env, g_isSinglePhoto, &result);

    OH_LOG_ERROR(LOG_APP, "IsSingle End");
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"initCamera", nullptr, InitCamera, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startPhoto", nullptr, StartPhoto, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setZoomRatio", nullptr, SetZoomRatio, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"hasFlash", nullptr, HasFlash, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isExposureModeSupported", nullptr, IsExposureModeSupported, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isMeteringPoint", nullptr, IsMeteringPoint, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isExposureBiasRange", nullptr, IsExposureBiasRange, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isFocusPoint", nullptr, IsFocusPoint, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseSession", nullptr, ReleaseSession, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseCamera", nullptr, ReleaseCamera, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPhotoOutputCallback", nullptr, SetPhotoOutputCallback, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getPixelMap", nullptr, GetPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr },
        {"isSingle", nullptr, IsSingle, nullptr, nullptr, nullptr, napi_default, nullptr },
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
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}