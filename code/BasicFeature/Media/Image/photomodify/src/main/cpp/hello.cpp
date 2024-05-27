/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

#include <bits/alltypes.h>
#include <linux/kd.h>
#include <malloc.h>
#include <string>

#include <string>
#include "napi/native_api.h"
#include "hilog/log.h"
#include "multimedia/image_framework/image/image_common.h"
#include "multimedia/image_framework/image/image_source_native.h"
#include "rawfile/raw_file.h"
#include "multimedia/image_framework/image/image_packer_native.h"
#include "hilog/log.h"
#include <cassert>
#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "MY_TAG"
#define PARAM_TWO 2
#define PARAM_THREE 3
#define PARAM_FOUR 4

static napi_value CreateDecodingOptions(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_value thisVar = nullptr;

    napi_get_undefined(env, &result);

    OH_DecodingOptions *options;
    Image_ErrorCode errCode = OH_DecodingOptions_Create(&options);
    if (IMAGE_SUCCESS != errCode) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(options), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }
    return result;
}

static napi_value CreateFromUri(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 1) {
        return result;
    }

    const size_t maxUrlLen = 512;
    char url[maxUrlLen];
    size_t urlSize = 0;
    napi_get_value_string_utf8(env, argValue[0], url, maxUrlLen, &urlSize);

    OH_ImageSourceNative *res = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromUri(url, urlSize, &res);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }
    return result;
}

static napi_value CreateFromFd(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;

    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 1) {
        return result;
    }
    int32_t fd;
    napi_get_value_int32(env, argValue[0], &fd);
    if (fd < 0) {
        napi_create_int32(env, -1, &result);
        return result;
    }

    OH_ImageSourceNative *res = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromFd(fd, &res);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }

    return result;
}

static napi_value CreateFromData(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;

    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 1) {
        return result;
    }

    void *data = nullptr;
    size_t dataSize = 0;

    napi_status status = napi_get_buffer_info(env, argValue[0], &data, &dataSize);
    if (status != napi_ok) {
        return result;
    }

    OH_ImageSourceNative *res = nullptr;
    Image_ErrorCode error = OH_ImageSourceNative_CreateFromData(reinterpret_cast<uint8_t *>(data), dataSize, &res);
    if (error != IMAGE_SUCCESS) {
        napi_throw_error(env, nullptr, "Failed to OH_ImageSourceNative_CreateFromData create external object");
        return result;
    }

    status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to OH_ImageSourceNative_CreateFromData create external object");
        return result;
    }

    return result;
}

static napi_value CreateFromRawFile(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_value thisVar = nullptr;
    napi_value argValue[3] = {0};
    size_t argCount = 3;
    napi_status status;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < PARAM_THREE) {
        return result;
    }

    RawFileDescriptor rawDesc;
    napi_get_value_int32(env, argValue[0], &rawDesc.fd);
    if (rawDesc.fd < 0) {
        napi_create_int32(env, -1, &result);
        return result;
    }
    int64_t tmp;
    napi_get_value_int64(env, argValue[1], &tmp);
    rawDesc.start = static_cast<long>(tmp);
    napi_get_value_int64(env, argValue[PARAM_TWO], &tmp);
    rawDesc.length = static_cast<long>(tmp);

    OH_ImageSourceNative *res = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromRawFile(&rawDesc, &res);
    if (errCode != IMAGE_SUCCESS) {
        napi_throw_error(env, nullptr, "Failed to OH_ImageSourceNative_CreateFromRawFile create external object");
        napi_create_int32(env, errCode, &result);
        return result;
    }
    status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }
    return result;
}

static napi_value CreatePixelMap(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_value thisVar = nullptr;
    napi_value argValue[2] = {0};
    size_t argCount = 2;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < PARAM_TWO) {
        return result;
    }

    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImageSourceNative *imageSource = reinterpret_cast<OH_ImageSourceNative *>(ptr);

    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_DecodingOptions *decodeOpts = reinterpret_cast<OH_DecodingOptions *>(ptr);

    OH_PixelmapNative *resPixMap = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreatePixelmap(imageSource, decodeOpts, &resPixMap);
    if (IMAGE_SUCCESS != errCode) {
        napi_throw_error(env, nullptr, "Failed to OH_ImageSourceNative_CreatePixelmap create external object");
        napi_create_int32(env, errCode, &result);
        return result;
    }

    status = napi_create_external(env, reinterpret_cast<void *>(resPixMap), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return result;
    }
    return result;
}

static napi_value CreatePackingOptions(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;

    napi_get_undefined(env, &result);

    OH_PackingOptions *res = nullptr;
    Image_ErrorCode errorCode = OH_PackingOptions_Create(&res);
    if (errorCode != IMAGE_SUCCESS) {
        napi_throw_error(env, nullptr, "Failed to OH_PackingOptions_Create create external object");
        napi_create_int32(env, errorCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }
    return result;
}

static napi_value PackingOptionsSetMimeType(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_value thisVar = nullptr;
    napi_value argValue[2] = {0};
    size_t argCount = 2;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < PARAM_TWO) {
        return result;
    }

    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_PackingOptions *packingOptions = reinterpret_cast<OH_PackingOptions *>(ptr);

    const uint32_t maxMineTypeLen = 512;
    char mineType[maxMineTypeLen];
    size_t mineTypeSize = 0;

    napi_get_value_string_utf8(env, argValue[1], mineType, maxMineTypeLen, &mineTypeSize);

    Image_MimeType tmpMineType;
    tmpMineType.data = new (std::nothrow) char[512];
    memcpy(tmpMineType.data, mineType, mineTypeSize);
    tmpMineType.data[mineTypeSize] = '\0';

    tmpMineType.size = mineTypeSize;
    Image_ErrorCode errCode = OH_PackingOptions_SetMimeType(packingOptions, &tmpMineType);

    napi_create_int32(env, errCode, &result);
    return result;
}

static napi_value PackingOptionsSetQuality(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;

    napi_value argValue[2] = {0};
    size_t argCount = 2;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < PARAM_TWO) {
        return result;
    }

    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_PackingOptions *packingOptions = reinterpret_cast<OH_PackingOptions *>(ptr);

    uint32_t quality;
    status = napi_get_value_uint32(env, argValue[1], &quality);

    Image_ErrorCode errCode = OH_PackingOptions_SetQuality(packingOptions, quality);
    napi_create_int32(env, errCode, &result);
    return result;
}

static napi_value PackerCreate(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_undefined(env, &result);

    OH_ImagePackerNative *res = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&res);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_status status = napi_create_external(env, reinterpret_cast<void *>(res), nullptr, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create external object");
        return nullptr;
    }

    return result;
}

static napi_value PackToDataFromImageSource(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;

    napi_value argValue[4] = {0};
    size_t argCount = 4;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < PARAM_FOUR) {
        return result;
    }

    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImagePackerNative *packer = reinterpret_cast<OH_ImagePackerNative *>(ptr);

    ptr = nullptr;
    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_PackingOptions *opts = reinterpret_cast<OH_PackingOptions *>(ptr);

    ptr = nullptr;
    status = napi_get_value_external(env, argValue[PARAM_TWO], &ptr);
    OH_ImageSourceNative *imageSource = reinterpret_cast<OH_ImageSourceNative *>(ptr);

    uint8_t *outBuffer = nullptr;
    size_t outBufferSize = 0;

    status = napi_get_buffer_info(env, argValue[PARAM_THREE], (void **)&outBuffer, &outBufferSize);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create napi_get_buffer_info object");
        return result;
    }

    Image_ErrorCode errCode =
        OH_ImagePackerNative_PackToDataFromImageSource(packer, opts, imageSource, outBuffer, &outBufferSize);
    if (IMAGE_SUCCESS != errCode) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    napi_create_int32(env, outBufferSize, &result);

    return result;
}

static napi_value PackToDataFromPixelMap(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;

    napi_value argValue[4] = {0};
    size_t argCount = 4;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < PARAM_FOUR) {
        return result;
    }

    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImagePackerNative *packer = reinterpret_cast<OH_ImagePackerNative *>(ptr);

    ptr = nullptr;
    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_PackingOptions *opts = reinterpret_cast<OH_PackingOptions *>(ptr);

    ptr = nullptr;
    status = napi_get_value_external(env, argValue[PARAM_TWO], &ptr);
    OH_PixelmapNative *pixMap = reinterpret_cast<OH_PixelmapNative *>(ptr);

    Image_MimeType mineType;
    OH_PackingOptions_GetMimeType(opts, &mineType);
    
    uint8_t *outBuffer = nullptr;
    size_t outBufferSize = 0;

    status = napi_get_buffer_info(env, argValue[PARAM_THREE], (void **)&outBuffer, &outBufferSize);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to create napi_get_buffer_info object");
        return result;
    }

    Image_ErrorCode errCode =
        OH_ImagePackerNative_PackToDataFromPixelmap(packer, opts, pixMap, outBuffer, &outBufferSize);
    if (IMAGE_SUCCESS != errCode) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    napi_create_int32(env, outBufferSize, &result);
    return result;
}

static napi_value PackToFileFromImageSource(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;

    napi_value argValue[4] = {0};
    size_t argCount = 4;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < PARAM_FOUR ){
        return result;
    }

    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImagePackerNative *packer = reinterpret_cast<OH_ImagePackerNative *>(ptr);

    ptr = nullptr;
    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_PackingOptions *opts = reinterpret_cast<OH_PackingOptions *>(ptr);

    ptr = nullptr;
    status = napi_get_value_external(env, argValue[PARAM_TWO], &ptr);
    OH_ImageSourceNative *imageSource = reinterpret_cast<OH_ImageSourceNative *>(ptr);

    int fd;
    status = napi_get_value_int32(env, argValue[PARAM_THREE], &fd);

    Image_ErrorCode errCode = OH_ImagePackerNative_PackToFileFromImageSource(packer, opts, imageSource, fd);

    napi_create_int32(env, errCode, &result);
    return result;
}

static napi_value PackToFileFromPixelMap(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;

    napi_value argValue[4] = {0};
    size_t argCount = 4;

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < PARAM_FOUR) {
        return result;
    }

    void *ptr = nullptr;
    napi_status status = napi_get_value_external(env, argValue[0], &ptr);
    OH_ImagePackerNative *packer = reinterpret_cast<OH_ImagePackerNative *>(ptr);

    ptr = nullptr;
    status = napi_get_value_external(env, argValue[1], &ptr);
    OH_PackingOptions *opts = reinterpret_cast<OH_PackingOptions *>(ptr);

    ptr = nullptr;
    status = napi_get_value_external(env, argValue[PARAM_TWO], &ptr);
    OH_PixelmapNative *pixmap = reinterpret_cast<OH_PixelmapNative *>(ptr);

    int fd;
    status = napi_get_value_int32(env, argValue[PARAM_THREE], &fd);

    Image_ErrorCode errCode = OH_ImagePackerNative_PackToFileFromPixelmap(packer, opts, pixmap, fd);

    napi_create_int32(env, errCode, &result);
    return result;
}

EXTERN_C_START static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"CreateDecodingOptions", nullptr, CreateDecodingOptions, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateFromUri", nullptr, CreateFromUri, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateFromFd", nullptr, CreateFromFd, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateFromData", nullptr, CreateFromData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateFromRawFile", nullptr, CreateFromRawFile, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreatePixelMap", nullptr, CreatePixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},

        {"CreatePackingOptions", nullptr, CreatePackingOptions, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"PackingOptionsSetMimeType", nullptr, PackingOptionsSetMimeType, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"PackingOptionsSetQuality", nullptr, PackingOptionsSetQuality, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"PackerCreate", nullptr, PackerCreate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"PackToDataFromImageSource", nullptr, PackToDataFromImageSource, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"PackToDataFromPixelMap", nullptr, PackToDataFromPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"PackToFileFromImageSource", nullptr, PackToFileFromImageSource, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"PackToFileFromPixelMap", nullptr, PackToFileFromPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},
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

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
