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
#include <multimedia/player_framework/avimage_generator.h>
#include <multimedia/player_framework/avimage_generator_base.h>
#include <multimedia/player_framework/native_averrors.h>
#include "multimedia/player_framework/avmetadata_extractor.h"
#include "multimedia/player_framework/avmetadata_extractor_base.h"

#include <hilog/log.h>

#define LOG_PRINT_DOMAIN 0xFF00
#define APP_LOG_DOMAIN 0x0001
constexpr const char *APP_LOG_TAG = "AVImageGenerator";
const int FETCH_FRAME_ARG_NUM = 5;
const int GET_DURATION_ARG_NUM = 3;
const int FIRST_PARAM = 0;
const int SECOND_PARAM = 1;
const int THIRD_PARAM = 2;
const int FOUTRH_PARAM = 3;
const int FIFTH_PARAM = 4;
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

// FetchFrameByTime的输入参数
struct FetchFrameParams {
    int64_t timeUs = 0;
    int64_t offset = 0;
    int32_t fileDescribe = -1;
    int32_t fileSize = 0;
    int32_t options = OH_AVIMAGE_GENERATOR_QUERY_CLOSEST;
};

// 辅助函数：获取FetchFrameByTime的输入参数
bool GetFetchFrameByTimeParams(napi_env env, napi_callback_info info, FetchFrameParams &fetchFrameParams)
{
    if (!CheckArgs(env, info, FETCH_FRAME_ARG_NUM)) {
        return false;
    }
    size_t argc = FETCH_FRAME_ARG_NUM;
    napi_value argv[FETCH_FRAME_ARG_NUM];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (!GetInt32Value(env, argv[FIRST_PARAM], &fetchFrameParams.fileDescribe)) {
        return false;
    }
    if (!GetInt32Value(env, argv[SECOND_PARAM], &fetchFrameParams.fileSize)) {
        return false;
    }
    if (!GetInt64Value(env, argv[THIRD_PARAM], &fetchFrameParams.timeUs)) {
        return false;
    }
    if (!GetInt32Value(env, argv[FOUTRH_PARAM], &fetchFrameParams.options)) {
        return false;
    }
    if (!GetInt64Value(env, argv[FIFTH_PARAM], &fetchFrameParams.offset)) {
        return false;
    }
    if (fetchFrameParams.options < OH_AVIMAGE_GENERATOR_QUERY_NEXT_SYNC ||
        fetchFrameParams.options > OH_AVIMAGE_GENERATOR_QUERY_CLOSEST) {
        napi_throw_range_error(env, "EINVAL", "Invalid options value");
        return false;
    }
    return true;
}

/**
 * 需要在index.d.ts文件内描述映射的OhAvImageGeneratorFetchFrameByTime方法。
 * export const OhAvImageGeneratorFetchFrameByTime: (fdsrc : number, size : number, timeus : number,
 * options : number, offset : number) => image.PixelMap;
 * 需要传入媒体文件描述符fdsrc、媒体文件大小size、指定的时间timeus（单位us）、
 * 指定时间点与视频帧的对应关系options、媒体源在文件描述符中的偏移量offset。
 * 返回PixelMap对象。
 */
static napi_value OhAvImageGeneratorFetchFrameByTime(napi_env env, napi_callback_info info)
{
    FetchFrameParams fetchFrameParams;
    if (!GetFetchFrameByTimeParams(env, info, fetchFrameParams)) {
        return nullptr;
    }
    int64_t timeUs = fetchFrameParams.timeUs;
    int64_t offset = fetchFrameParams.offset;
    int32_t fileDescribe = fetchFrameParams.fileDescribe;
    int32_t fileSize = fetchFrameParams.fileSize;
    int32_t options = fetchFrameParams.options;
    // 创建OH_AVImageGenerator实例。
    OH_AVImageGenerator* generator = OH_AVImageGenerator_Create();
    // 异常处理。
    if (!generator) {
        napi_throw_error(env, "EFAILED", "Create generator failed");
        return nullptr;
    }
    // 设置视频资源的文件描述符。
    OH_AVErrCode avErrCode = OH_AVImageGenerator_SetFDSource(generator, fileDescribe, offset, fileSize);
    // 异常处理。
    if (avErrCode != AV_ERR_OK) {
        OH_AVImageGenerator_Release(generator);
        napi_throw_error(env, "EFAILED", "SetFDSource failed");
        return nullptr;
    }
    // 取指定时间的视频帧。
    OH_PixelmapNative* pixelMap = nullptr;
    avErrCode = OH_AVImageGenerator_FetchFrameByTime(generator, timeUs,
        (OH_AVImageGenerator_QueryOptions)options, &pixelMap);
    // 异常处理。
    if (avErrCode != AV_ERR_OK || !pixelMap) {
        OH_AVImageGenerator_Release(generator);
        napi_throw_error(env, "EFAILED", "FetchFrameByTime failed");
        return nullptr;
    }
    // 将nativePixelMap对象转换为PixelMapnapi对象。
    napi_value pixelmapNapi = nullptr;
    Image_ErrorCode errCode = OH_PixelmapNative_ConvertPixelmapNativeToNapi(env, pixelMap, &pixelmapNapi);
    // 释放OH_PixelmapNative资源。
    OH_PixelmapNative_Release(pixelMap);
    // 释放OH_AVImageGenerator资源。
    OH_AVImageGenerator_Release(generator);
    // 异常处理。
    if (errCode != IMAGE_SUCCESS) {
        napi_throw_error(env, "EFAILED", "Convert PixelMap failed");
        return nullptr;
    }
    return pixelmapNapi;
}

// 辅助函数：获取GetDuration的输入参数
bool GetGetDurationParams(napi_env env, napi_callback_info info, int64_t &offset, int32_t &fileDescribe,
    int64_t &fileSize)
{
    if (!CheckArgs(env, info, GET_DURATION_ARG_NUM)) {
        return false;
    }
    size_t argc = GET_DURATION_ARG_NUM;
    napi_value argv[GET_DURATION_ARG_NUM];
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

static napi_value OhAVMetadataExtractorGetDuration(napi_env env, napi_callback_info info)
{
    int64_t offset = 0;
    int32_t fileDescribe = -1;
    int64_t fileSize = 0;
    if (!GetGetDurationParams(env, info, offset, fileDescribe, fileSize)) {
        return nullptr;
    }
    OH_AVMetadataExtractor* mainExtractor = OH_AVMetadataExtractor_Create();
    if (!mainExtractor) {
        napi_throw_error(env, "EFAILED", "Create metadata extractor failed");
        return nullptr;
    }
    OH_AVErrCode avErrCode = OH_AVMetadataExtractor_SetFDSource(mainExtractor, fileDescribe, offset, fileSize);
    if (avErrCode != AV_ERR_OK) {
        OH_AVMetadataExtractor_Release(mainExtractor);
        napi_throw_error(env, "EFAILED", "SetFDSource for metadata extractor failed");
        return nullptr;
    }
    OH_AVFormat* avMetadata = OH_AVFormat_Create();
    avErrCode = OH_AVMetadataExtractor_FetchMetadata(mainExtractor, avMetadata);
    if (avErrCode != AV_ERR_OK) {
        OH_AVFormat_Destroy(avMetadata);
        OH_AVMetadataExtractor_Release(mainExtractor);
        napi_throw_error(env, "EFAILED", "Fetch metadata failed");
        return nullptr;
    }
    int64_t out;
    if (!OH_AVFormat_GetLongValue(avMetadata, OH_AVMETADATA_EXTRACTOR_DURATION, &out)) {
        OH_AVFormat_Destroy(avMetadata);
        OH_AVMetadataExtractor_Release(mainExtractor);
        napi_throw_error(env, "EFAILED", "Get duration failed");
        return nullptr;
    }
    napi_value duration;
    napi_create_int64(env, out, &duration);
    OH_AVFormat_Destroy(avMetadata);
    OH_AVMetadataExtractor_Release(mainExtractor);
    return duration;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "OhAvImageGeneratorFetchFrameByTime", nullptr, OhAvImageGeneratorFetchFrameByTime, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        { "OhAVMetadataExtractorGetDuration", nullptr, OhAVMetadataExtractorGetDuration, nullptr, nullptr, nullptr,
            napi_default, nullptr },
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
