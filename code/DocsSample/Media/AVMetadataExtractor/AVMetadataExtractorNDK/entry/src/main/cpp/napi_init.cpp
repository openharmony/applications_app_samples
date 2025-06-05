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
#include "napi/native_api.h"

#include <multimedia/image_framework/image/pixelmap_native.h>
#include <multimedia/player_framework/avmetadata_extractor.h>
#include <multimedia/player_framework/avmetadata_extractor_base.h>
#include <multimedia/player_framework/native_averrors.h>
#include <multimedia/player_framework/native_avformat.h>
#include <string>

#include <hilog/log.h>

#define LOG_PRINT_DOMAIN 0xFF00
#define APP_LOG_DOMAIN 0x0001
constexpr const char *APP_LOG_TAG = "AVMetadataExtractor";
const int ARG_NUM = 3;
const int FIRST_PARAM = 0;
const int SECOND_PARAM = 1;
const int THIRD_PARAM = 2;
const int STRING_VALUE = 0;
const int INT_VALUE = 1;
#define H_LOGI(...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, APP_LOG_TAG, __VA_ARGS__))

// 辅助函数：检查参数数量和类型。
bool CheckArgs(napi_env env, napi_callback_info info, size_t expectedArgc)
{
    size_t argc;
    napi_value thisArg;
    void* data;
    napi_get_cb_info(env, info, &argc, nullptr, &thisArg, &data);
    if (argc < expectedArgc) {
        napi_throw_error(env, "EINVAL", "Insufficient arguments");
        return false;
    }
    napi_value argv[expectedArgc];
    napi_get_cb_info(env, info, &argc, argv, &thisArg, &data);
    for (size_t i = 0; i < expectedArgc; ++i) {
        napi_valuetype type;
        napi_typeof(env, argv[i], &type);
        if (type != napi_number) {
            napi_throw_type_error(env, "EINVAL", "All arguments must be numbers");
            return false;
        }
    }
    return true;
}

// 辅助函数：获取 int32 类型值并进行错误处理。
bool GetInt32Value(napi_env env, napi_value value, int32_t* result)
{
    napi_status status = napi_get_value_int32(env, value, result);
    if (status != napi_ok) {
        napi_throw_error(env, "EINVAL", "Failed to get int32 value");
        return false;
    }
    return true;
}

// 辅助函数：获取 int64 类型值并进行错误处理。
bool GetInt64Value(napi_env env, napi_value value, int64_t* result)
{
    napi_status status = napi_get_value_int64(env, value, result);
    if (status != napi_ok) {
        napi_throw_error(env, "EINVAL", "Failed to get int64 value");
        return false;
    }
    return true;
}

// 辅助函数：将 string 类型值转为napi对象并进行错误处理。
bool SetPropertyString(napi_env env, napi_value &obj, const std::string &key, const std::string &value)
{
    napi_value keyNapi = nullptr;
    napi_status status = napi_create_string_utf8(env, key.c_str(), NAPI_AUTO_LENGTH, &keyNapi);
    if (status != napi_ok) {
        return false;
    }
    napi_value valueNapi = nullptr;
    status = napi_create_string_utf8(env, value.c_str(), NAPI_AUTO_LENGTH, &valueNapi);
    if (status != napi_ok) {
        return false;
    }
    status = napi_set_property(env, obj, keyNapi, valueNapi);
    if (status != napi_ok) {
        return false;
    }
    return true;
}

// 辅助函数：将 double 类型值转为napi对象并进行错误处理。
bool SetPropertyDouble(napi_env env, napi_value &obj, const std::string &key, double value)
{
    napi_value keyNapi = nullptr;
    napi_status status = napi_create_string_utf8(env, key.c_str(), NAPI_AUTO_LENGTH, &keyNapi);
    if (status != napi_ok) {
        return false;
    }
    napi_value valueNapi = nullptr;
    status = napi_create_double(env, value, &valueNapi);
    if (status != napi_ok) {
        return false;
    }
    status = napi_set_property(env, obj, keyNapi, valueNapi);
    if (status != napi_ok) {
        return false;
    }
    return true;
}

// 辅助函数：将 int 类型值转为napi对象并进行错误处理。
bool SetPropertyInt(napi_env env, napi_value &obj, const std::string &key, int value)
{
    napi_value keyNapi = nullptr;
    napi_status status = napi_create_string_utf8(env, key.c_str(), NAPI_AUTO_LENGTH, &keyNapi);
    if (status != napi_ok) {
        return false;
    }
    napi_value valueNapi = nullptr;
    status = napi_create_int32(env, value, &valueNapi);
    if (status != napi_ok) {
        return false;
    }
    status = napi_set_property(env, obj, keyNapi, valueNapi);
    if (status != napi_ok) {
        return false;
    }
    return true;
}

// 辅助函数：获取FetchAlbumCover、FetchMetadata的输入参数
bool GetInputParams(napi_env env, napi_callback_info info, int64_t &offset, int32_t &fileDescribe,
    int64_t &fileSize)
{
    if (!CheckArgs(env, info, ARG_NUM)) {
        return false;
    }
    size_t argc = ARG_NUM;
    napi_value argv[ARG_NUM];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (!GetInt32Value(env, argv[FIRST_PARAM], &fileDescribe)) {
        return false;
    }
    if (!GetInt64Value(env, argv[SECOND_PARAM], &fileSize)) {
        return false;
    }
    if (!GetInt64Value(env, argv[THIRD_PARAM], &offset)) {
        return false;
    }
    return true;
}

/**
 * 获取专辑封面。
 * 需要在index.d.ts文件内描述映射的OhAVMetadataExtractorFetchAlbumCover方法。
 * export const OhAVMetadataExtractorFetchAlbumCover: (fdsrc : number, size : number,
 * offset : number) => image.PixelMap;
 * 需要传入媒体文件描述符fdsrc、媒体文件大小size、媒体源在文件描述符中的偏移量offset。
 * 返回PixelMap对象。
 */
static napi_value OhAVMetadataExtractorFetchAlbumCover(napi_env env, napi_callback_info info)
{
    int64_t offset = 0;
    int32_t fileDescribe = -1;
    int64_t fileSize = 0;
    if (!GetInputParams(env, info, offset, fileDescribe, fileSize)) {
        return nullptr;
    }
    // 创建OH_AVMetadataExtractor实例。
    OH_AVMetadataExtractor* mainExtractor = OH_AVMetadataExtractor_Create();
    // 处理异常。
    if (!mainExtractor) {
        napi_throw_error(env, "EFAILED", "Create metadata extractor failed");
        return nullptr;
    }
    // 设置视频资源的文件描述符。
    OH_AVErrCode avErrCode = OH_AVMetadataExtractor_SetFDSource(mainExtractor, fileDescribe, offset, fileSize);
    // 处理异常。
    if (avErrCode != AV_ERR_OK) {
        OH_AVMetadataExtractor_Release(mainExtractor);
        napi_throw_error(env, "EFAILED", "SetFDSource for metadata extractor failed");
        return nullptr;
    }
    // 获取专辑封面。
    OH_PixelmapNative* pixelMap = nullptr;
    avErrCode = OH_AVMetadataExtractor_FetchAlbumCover(mainExtractor, &pixelMap);
    // 处理异常。
    if (avErrCode != AV_ERR_OK || !pixelMap) {
        OH_AVMetadataExtractor_Release(mainExtractor);
        napi_throw_error(env, "EFAILED", "Fetch album cover failed");
        return nullptr;
    }
    // 将nativePixelMap对象转换为PixelMapnapi对象。
    napi_value pixelmapNapi = nullptr;
    Image_ErrorCode errCode = OH_PixelmapNative_ConvertPixelmapNativeToNapi(env, pixelMap, &pixelmapNapi);
    // 释放OH_PixelmapNative资源。
    OH_PixelmapNative_Release(pixelMap);
    // 释放OH_AVMetadataExtractor资源。
    OH_AVMetadataExtractor_Release(mainExtractor);
    // 处理异常。
    if (errCode != IMAGE_SUCCESS) {
        napi_throw_error(env, "EFAILED", "Convert PixelMap failed");
        return nullptr;
    }
    return pixelmapNapi;
}

// 辅助函数：从OH_AVFormat对象中解析出string类型的元数据值，再保存到JS所需的AVMetadata中。
void GetStringMetaData(struct OH_AVFormat *avMetadata, napi_env env, napi_value &JsMetadata, const char* &key)
{
    const char* out = nullptr;
    bool ret = false;
    ret = OH_AVFormat_GetStringValue(avMetadata, key, &out);
    std::string result = std::string(key) + " : %{public}s";
    H_LOGI(result.c_str(), out);
    if (ret && out) {
        SetPropertyString(env, JsMetadata, key, out);
    }
}

// 辅助函数：从OH_AVFormat对象中解析出string类型的元数据值，再保存到JS所需的AVMetadata中。
void GetStringValueFromAVFormat(struct OH_AVFormat *avMetadata, napi_env env, napi_value &JsMetadata)
{
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_ALBUM);
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_ALBUM_ARTIST);
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_ARTIST);
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_AUTHOR);
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_DATE_TIME);
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_DATE_TIME_FORMAT);
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_COMPOSER);
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_GENRE);
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_MIME_TYPE);
    GetStringMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_TITLE);
}

// 辅助函数：从OH_AVFormat对象中解析出int类型的元数据值，再保存到JS所需的AVMetadata中。
void GetIntMetaData(struct OH_AVFormat *avMetadata, napi_env env, napi_value &JsMetadata, const char* &key)
{
    const char* out = nullptr;
    bool ret = false;
    int32_t value = 0;
    ret = OH_AVFormat_GetIntValue(avMetadata, key, &value);
    std::string result = std::string(key) + " : %{public}d";
    H_LOGI(result.c_str(), value);
    if (ret) {
        out = std::to_string(value).c_str();
        SetPropertyString(env, JsMetadata, key, out);
    }
}

// 辅助函数：从OH_AVFormat对象中解析出int类型的元数据值，再保存到JS所需的AVMetadata中。
void GetIntValueFromAVFormat(struct OH_AVFormat *avMetadata, napi_env env, napi_value &JsMetadata)
{
    GetIntMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_HAS_AUDIO);
    GetIntMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_HAS_VIDEO);
    GetIntMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_TRACK_COUNT);
    GetIntMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_SAMPLE_RATE);
    GetIntMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_VIDEO_HEIGHT);
    GetIntMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_VIDEO_WIDTH);
    GetIntMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_VIDEO_ORIENTATION);
    GetIntMetaData(avMetadata, env, JsMetadata, OH_AVMETADATA_EXTRACTOR_HAS_AUDIO);

    bool ret = false;
    int32_t hdrType;
    ret = OH_AVFormat_GetIntValue(avMetadata, OH_AVMETADATA_EXTRACTOR_VIDEO_IS_HDR_VIVID, &hdrType);
    H_LOGI("OH_AVMETADATA_EXTRACTOR_VIDEO_IS_HDR_VIVID : %{public}d ret %{public}d", hdrType, ret);
    if (ret) {
        bool hh = SetPropertyInt(env, JsMetadata, OH_AVMETADATA_EXTRACTOR_VIDEO_IS_HDR_VIVID, hdrType);
        H_LOGI("OH_AVMETADATA_EXTRACTOR_VIDEO_IS_HDR_VIVID : %{public}d hh %{public}d", hdrType, hh);
    }
}

// 辅助函数：从OH_AVFormat对象中解析出float、long类型的元数据值，再保存到JS所需的AVMetadata中。
void GetOtherValueFromAVFormat(struct OH_AVFormat *avMetadata, napi_env env, napi_value &JsMetadata)
{
    const char* out = nullptr;
    bool ret = false;

    int64_t duration = 0;
    ret = OH_AVFormat_GetLongValue(avMetadata, OH_AVMETADATA_EXTRACTOR_DURATION, &duration);
    H_LOGI("OH_AVMETADATA_EXTRACTOR_DURATION : %{public}lld", duration);
    if (ret) {
        out = std::to_string(duration).c_str();
        SetPropertyString(env, JsMetadata, OH_AVMETADATA_EXTRACTOR_DURATION, out);
    }

    napi_value location = nullptr;
    napi_create_object(env, &location);
    float latitude;
    bool retLatitude = OH_AVFormat_GetFloatValue(avMetadata, OH_AVMETADATA_EXTRACTOR_LOCATION_LATITUDE, &latitude);
    H_LOGI("OH_AVMETADATA_EXTRACTOR_LOCATION_LATITUDE : %{public}f", latitude);
    if (retLatitude) {
        SetPropertyDouble(env, location, OH_AVMETADATA_EXTRACTOR_LOCATION_LATITUDE, latitude);
    }

    float longitude;
    bool retLongitude = OH_AVFormat_GetFloatValue(avMetadata, OH_AVMETADATA_EXTRACTOR_LOCATION_LONGITUDE, &longitude);
    H_LOGI("OH_AVMETADATA_EXTRACTOR_LOCATION_LONGITUDE : %{public}f", longitude);
    if (retLongitude) {
        SetPropertyDouble(env, location, OH_AVMETADATA_EXTRACTOR_LOCATION_LONGITUDE, longitude);
    }

    if (retLatitude || retLongitude) {
        napi_value keyNapi = nullptr;
        std::string key = "location";
        napi_create_string_utf8(env, key.c_str(), NAPI_AUTO_LENGTH, &keyNapi);
        napi_set_property(env, JsMetadata, keyNapi, location);
    }
}

/**
 * 获取元数据。
 * 需要在index.d.ts文件内描述映射的OhAVMetadataExtractorFetchMetadata方法。
 * export const OhAVMetadataExtractorFetchMetadata: (fdsrc : number, size : number,
 * offset : number) =>  media.AVMetadata;
 * 需要传入媒体文件描述符fdsrc、媒体文件大小size、媒体源在文件描述符中的偏移量offset。
 * 返回AVMetadata对象。
 */
static napi_value OhAVMetadataExtractorFetchMetadata(napi_env env, napi_callback_info info)
{
    int64_t offset = 0;
    int32_t fileDescribe = -1;
    int64_t fileSize = 0;
    if (!GetInputParams(env, info, offset, fileDescribe, fileSize)) {
        return nullptr;
    }
    // 创建OH_AVMetadataExtractor实例。
    OH_AVMetadataExtractor* mainExtractor = OH_AVMetadataExtractor_Create();
    // 异常处理。
    if (!mainExtractor) {
        napi_throw_error(env, "EFAILED", "Create metadata extractor failed");
        return nullptr;
    }
    // 设置视频资源的文件描述符。
    OH_AVErrCode avErrCode = OH_AVMetadataExtractor_SetFDSource(mainExtractor, fileDescribe, offset, fileSize);
    // 异常处理。
    if (avErrCode != AV_ERR_OK) {
        OH_AVMetadataExtractor_Release(mainExtractor);
        napi_throw_error(env, "EFAILED", "SetFDSource for metadata extractor failed");
        return nullptr;
    }
    // 创建OH_AVFormat对象。
    OH_AVFormat* avMetadata = OH_AVFormat_Create();
    // 异常处理。
    if (!avMetadata) {
        OH_AVMetadataExtractor_Release(mainExtractor);
        napi_throw_error(env, "EFAILED", "Create AVFormat failed");
        return nullptr;
    }
    // 获取元数据。
    avErrCode = OH_AVMetadataExtractor_FetchMetadata(mainExtractor, avMetadata);
    // 异常处理。
    if (avErrCode != AV_ERR_OK) {
        OH_AVFormat_Destroy(avMetadata);
        OH_AVMetadataExtractor_Release(mainExtractor);
        napi_throw_error(env, "EFAILED", "Fetch metadata failed");
        return nullptr;
    }
    napi_value JsMetadata = nullptr;
    napi_status status = napi_create_object(env, &JsMetadata);
    // 异常处理。
    if (status != napi_ok) {
        OH_AVFormat_Destroy(avMetadata);
        OH_AVMetadataExtractor_Release(mainExtractor);
        napi_throw_error(env, "EFAILED", "Create JavaScript object failed");
        return nullptr;
    }
    // 从OH_AVFormat对象中解析出各个元数据值，再保存到JS所需的AVMetadata中。
    GetStringValueFromAVFormat(avMetadata, env, JsMetadata);
    GetIntValueFromAVFormat(avMetadata, env, JsMetadata);
    GetOtherValueFromAVFormat(avMetadata, env, JsMetadata);
    // 释放OH_AVFormat资源。
    OH_AVFormat_Destroy(avMetadata);
    // 释放OH_AVMetadataExtractor资源。
    OH_AVMetadataExtractor_Release(mainExtractor);
    return JsMetadata;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "OhAVMetadataExtractorFetchAlbumCover", nullptr, OhAVMetadataExtractorFetchAlbumCover, nullptr, nullptr,
            nullptr, napi_default, nullptr },
        { "OhAVMetadataExtractorFetchMetadata", nullptr, OhAVMetadataExtractorFetchMetadata, nullptr, nullptr,
            nullptr, napi_default, nullptr },
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
