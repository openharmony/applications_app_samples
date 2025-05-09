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
#include "decode_heif_image.h"
#include "download_heif_image.h"
#include "napi/native_api.h"
#include <multimedia/image_framework/image_mdk_common.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <multimedia/image_framework/image_pixel_map_napi.h>
#include <cstring>

// 网络下载
static MemoryStruct DownloadHeifImageFromUrl(const std::string& imageUrl)
{
    DownloadHEIFImage downloadHEIFImage;
    MemoryStruct chunk = downloadHEIFImage.get(imageUrl);
    if (chunk.size == -1) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "HEIF download failed");
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Downloaded %{public}zu bytes", chunk.size);
    }
    return chunk;
}

// 图片解码
static DecodeResult* DecodeHeifImageData(MemoryStruct& chunk)
{
    DecodeHEIFImage decodeHEIFImage;
    DecodeResult* decodeResult = decodeHEIFImage.decode_heif_image(chunk);
    
    if (!decodeResult) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "HEIF decoding failed");
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Decoded image %{public}dx%{public}d",
            decodeResult->heifImageWidth, decodeResult->heifImageHeight);
    }
    return decodeResult;
}

// 创建PixelMap
static napi_value CreatePixelMap(napi_env env, const DecodeResult* decodeResult)
{
    const size_t bpp = 4; // 4 BGRA
    const size_t totalSize = decodeResult->heifImageWidth * decodeResult->heifImageHeight * bpp;
    struct OhosPixelMapCreateOps createOps = {
        .width = (uint32_t)decodeResult->heifImageWidth,
        .height = (uint32_t)decodeResult->heifImageHeight,
        .pixelFormat = 4,  // 4 BGRA
        .alphaType = 0
    };
    napi_value pixel_map = nullptr;
    int32_t res = OH_PixelMap_CreatePixelMap(env, createOps, (void*)decodeResult->data, totalSize, &pixel_map);
    if (res != IMAGE_RESULT_SUCCESS || pixel_map == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "PixelMap creation failed");
        return nullptr;
    }
    return pixel_map;
}

// 构造返回对象
static napi_value CreateResultObject(napi_env env, napi_value pixel_map, const DecodeResult* decodeResult)
{
    const char* keys[] = {"data", "width", "height"};
    napi_value values[3]; // 3,返回三个数据
    values[0] = pixel_map;
    napi_create_int32(env, decodeResult->heifImageWidth, &values[1]);
    napi_create_int32(env, decodeResult->heifImageHeight, &values[2]); // 2，第二个参数

    napi_value result;
    napi_create_object_with_named_properties(env, &result, 3, keys, (const napi_value*)values); // 3,返回三个数据
    return result;
}

// 资源释放
static void ReleaseResources(MemoryStruct& chunk, DecodeResult* decodeResult)
{
    if (chunk.memory) {
        free(chunk.memory);
        chunk.memory = nullptr;
        chunk.size = 0;
    }
    
    if (decodeResult && decodeResult->data) {
        delete[] decodeResult->data;
    }
}

// 参数解析
static bool ParseArguments(napi_env env, napi_callback_info info, std::string& imageUrl)
{
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    char filenameBuffer[512]; // 512
    size_t filenameSize;
    napi_status status = napi_get_value_string_utf8(env, argv[0], filenameBuffer,
        sizeof(filenameBuffer), &filenameSize);
    if (status != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to parse URL argument");
        return false;
    }

    imageUrl.assign(filenameBuffer, filenameSize);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Parsed image URL: %{public}s", imageUrl.c_str());
    return true;
}

/**
 * 通过libheif软解码HEIF网络图片
 * @param env
 * @param info
 * @return 解码后的HEIF图片数据
 */
static napi_value DecodeHeifImageFromInternet(napi_env env, napi_callback_info info)
{
    std::string imageUrl;
    if (!ParseArguments(env, info, imageUrl)) {
        return nullptr;
    }

    MemoryStruct chunk = DownloadHeifImageFromUrl(imageUrl);
    if (chunk.size == -1) {
        return nullptr;
    }

    DecodeResult* decodeResult = DecodeHeifImageData(chunk);
    if (!decodeResult) {
        ReleaseResources(chunk, nullptr);
        return nullptr;
    }

    napi_value pixel_map = CreatePixelMap(env, decodeResult);
    if (!pixel_map) {
        ReleaseResources(chunk, decodeResult);
        return nullptr;
    }

    napi_value result = CreateResultObject(env, pixel_map, decodeResult);
    ReleaseResources(chunk, decodeResult);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {{"decodeHeifImageFromInternet", nullptr, DecodeHeifImageFromInternet, nullptr,
                                        nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}

EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "decodeheifimage",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterDecodeHEIFImageModule(void) { napi_module_register(&demoModule); }
