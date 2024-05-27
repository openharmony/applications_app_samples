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

#include <limits.h>
#include <stdio.h>
#include <memory>
#include <string>
#include "rawfile/raw_file.h"
#include "napi/native_api.h"
#include "multimedia/image_framework/image/image_packer_native.h"

#define MIMETYPE_JPEG_STRING "image/jpeg"
#define MIMETYPE_PNG_STRING "image/png"
#define MIMETYPE_WEBP_STRING "image/webp"

constexpr int32_t NUM_0 = 0;
constexpr int32_t NUM_1 = 1;
constexpr int32_t NUM_2 = 2;
constexpr int32_t NUM_3 = 3;
constexpr int32_t NUM_4 = 4;

constexpr uint32_t QUALITY = 100;
constexpr uint64_t DEFAULT_BUFFER_SIZE = 25 * 1024 * 1024;

// PixelMap转为data
static napi_value packToDataPixelMap(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    size_t argCount = NUM_2;
    napi_value argValue[NUM_2] = {0};

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_2) {
        return result;
    }

    size_t dataSize;
    void* inBuffer;
    napi_get_arraybuffer_info(env, argValue[NUM_0], &inBuffer, &dataSize);

    char outPath[PATH_MAX];
    size_t outPathLen = 0;
    napi_get_value_string_utf8(env, argValue[NUM_1], outPath, PATH_MAX, &outPathLen);

    OH_ImagePackerNative *packer = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&packer);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_ImagePackerNative> ptrPacker(packer, OH_ImagePackerNative_Release);

    OH_PackingOptions *opts = nullptr;
    errCode = OH_PackingOptions_Create(&opts);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_PackingOptions> ptrOpts(opts, OH_PackingOptions_Release);

    Image_MimeType mimeType;
    mimeType.size = strlen(MIMETYPE_JPEG_STRING);
    mimeType.data = new char[mimeType.size + 1];
    memcpy(mimeType.data, MIMETYPE_JPEG_STRING, mimeType.size);
    mimeType.data[mimeType.size] = '\0';
    errCode = OH_PackingOptions_SetMimeType(opts, &mimeType);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    errCode = OH_PackingOptions_SetQuality(opts, QUALITY);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    OH_ImageSourceNative *imgSource = nullptr;
    errCode = OH_ImageSourceNative_CreateFromData((uint8_t*)inBuffer, dataSize, &imgSource);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_ImageSourceNative> ptrImgSource(imgSource, OH_ImageSourceNative_Release);

    OH_DecodingOptions *decOpts = nullptr;
    errCode = OH_DecodingOptions_Create(&decOpts);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_DecodingOptions> ptrDecOpts(decOpts, OH_DecodingOptions_Release);

    OH_PixelmapNative *pixelMap = nullptr;
    errCode = OH_ImageSourceNative_CreatePixelmap(imgSource, decOpts, &pixelMap);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_PixelmapNative> ptrPixelMap(pixelMap, OH_PixelmapNative_Release);

    uint8_t* outBuffer = new uint8_t[DEFAULT_BUFFER_SIZE];
    size_t outBufferSize = 0;

    errCode = OH_ImagePackerNative_PackToDataFromPixelmap(
        packer, opts, pixelMap, outBuffer, &outBufferSize);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        delete [] outBuffer;
        return result;
    }

    FILE* file = fopen(outPath, "w");
    if (file == nullptr) {
        napi_create_int32(env, errCode, &result);
        delete [] outBuffer;
        return result;
    }

    fwrite(outBuffer, sizeof(uint8_t), outBufferSize, file);
    fclose(file);

    napi_create_int32(env, errCode, &result);
    delete [] outBuffer;
    return result;
}

// PixelMap转为file
static napi_value packPixelMapToFile(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    size_t argCount = NUM_2;
    napi_value argValue[NUM_2] = {0};

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_2) {
        return result;
    }

    char inPath[PATH_MAX];
    size_t inPathLen = 0;
    napi_get_value_string_utf8(env, argValue[NUM_0], inPath, PATH_MAX, &inPathLen);

    int32_t outFD;
    napi_get_value_int32(env, argValue[NUM_1], &outFD);
    if (outFD < 0) {
        napi_create_int32(env, outFD, &result);
        return result;
    }

    OH_ImagePackerNative *packer = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&packer);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_ImagePackerNative> ptrPacker(packer, OH_ImagePackerNative_Release);

    OH_PackingOptions *opts = nullptr;
    errCode = OH_PackingOptions_Create(&opts);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_PackingOptions> ptrOpts(opts, OH_PackingOptions_Release);

    Image_MimeType mimeType;
    mimeType.size = strlen(MIMETYPE_PNG_STRING);
    mimeType.data = new char[mimeType.size + 1];
    memcpy(mimeType.data, MIMETYPE_PNG_STRING, mimeType.size);
    mimeType.data[mimeType.size] = '\0';
    errCode = OH_PackingOptions_SetMimeType(opts, &mimeType);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    errCode = OH_PackingOptions_SetQuality(opts, QUALITY);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    OH_ImageSourceNative *imgSource = nullptr;
    errCode = OH_ImageSourceNative_CreateFromUri(inPath, inPathLen, &imgSource);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_ImageSourceNative> ptrImgSource(imgSource, OH_ImageSourceNative_Release);

    OH_DecodingOptions *decOpts = nullptr;
    errCode = OH_DecodingOptions_Create(&decOpts);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_DecodingOptions> ptrDecOpts(decOpts, OH_DecodingOptions_Release);

    OH_PixelmapNative *pixelMap = nullptr;
    errCode = OH_ImageSourceNative_CreatePixelmap(imgSource, decOpts, &pixelMap);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_PixelmapNative> ptrPixelMap(pixelMap, OH_PixelmapNative_Release);

    errCode = OH_ImagePackerNative_PackToFileFromPixelmap(packer, opts, pixelMap, outFD);
    napi_create_int32(env, errCode, &result);
    return result;
}

// ImageSource转为file
static napi_value packToFileImageSource(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    size_t argCount = NUM_2;
    napi_value argValue[NUM_2] = {0};

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_2) {
        return result;
    }

    int32_t inFD;
    napi_get_value_int32(env, argValue[NUM_0], &inFD);
    if (inFD < 0) {
        napi_create_int32(env, inFD, &result);
        return result;
    }

    int32_t outFD;
    napi_get_value_int32(env, argValue[NUM_1], &outFD);
    if (outFD < 0) {
        napi_create_int32(env, outFD, &result);
        return result;
    }

    OH_ImagePackerNative *packer = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&packer);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_ImagePackerNative> ptrPacker(packer, OH_ImagePackerNative_Release);

    OH_PackingOptions *opts = nullptr;
    errCode = OH_PackingOptions_Create(&opts);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_PackingOptions> ptrOpts(opts, OH_PackingOptions_Release);

    Image_MimeType mimeType;
    mimeType.size = strlen(MIMETYPE_JPEG_STRING);
    mimeType.data = new char[mimeType.size + 1];
    memcpy(mimeType.data, MIMETYPE_JPEG_STRING, mimeType.size);
    mimeType.data[mimeType.size] = '\0';
    errCode = OH_PackingOptions_SetMimeType(opts, &mimeType);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    errCode = OH_PackingOptions_SetQuality(opts, QUALITY);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    OH_ImageSourceNative *imgSource = nullptr;
    errCode = OH_ImageSourceNative_CreateFromFd(inFD, &imgSource);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_ImageSourceNative> ptrImgSource(imgSource, OH_ImageSourceNative_Release);

    OH_DecodingOptions *decOpts = nullptr;
    errCode = OH_DecodingOptions_Create(&decOpts);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_DecodingOptions> ptrDecOpts(decOpts, OH_DecodingOptions_Release);

    OH_PixelmapNative *pixelMap = nullptr;
    errCode = OH_ImageSourceNative_CreatePixelmap(imgSource, decOpts, &pixelMap);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_PixelmapNative> ptrPixelMap(pixelMap, OH_PixelmapNative_Release);

    errCode = OH_ImagePackerNative_PackToFileFromPixelmap(packer, opts, pixelMap, outFD);
    napi_create_int32(env, errCode, &result);
    return result;
}

// ImageSource转为data
static napi_value packToDataImageSource(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    size_t argCount = NUM_4;
    napi_value argValue[NUM_4] = {0};

    napi_get_undefined(env, &result);

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_4) {
        return result;
    }

    RawFileDescriptor rawSrc;
    napi_get_value_int32(env, argValue[NUM_0], &rawSrc.fd);
    if (rawSrc.fd < 0) {
        napi_create_int32(env, rawSrc.fd, &result);
        return result;
    }

    int64_t tmp;
    napi_get_value_int64(env, argValue[NUM_1], &tmp);
    rawSrc.start = static_cast<long>(tmp);

    napi_get_value_int64(env, argValue[NUM_2], &tmp);
    rawSrc.length = static_cast<long>(tmp);

    char outPath[PATH_MAX];
    size_t outPathLen = 0;
    napi_get_value_string_utf8(env, argValue[NUM_3], outPath, PATH_MAX, &outPathLen);

    OH_ImagePackerNative *packer = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&packer);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_ImagePackerNative> ptrPacker(packer, OH_ImagePackerNative_Release);

    OH_PackingOptions *opts = nullptr;
    errCode = OH_PackingOptions_Create(&opts);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_PackingOptions> ptrOpts(opts, OH_PackingOptions_Release);

    Image_MimeType mimeType;
    mimeType.size = strlen(MIMETYPE_WEBP_STRING);
    mimeType.data = new char[mimeType.size + 1];
    memcpy(mimeType.data, MIMETYPE_WEBP_STRING, mimeType.size);
    mimeType.data[mimeType.size] = '\0';
    errCode = OH_PackingOptions_SetMimeType(opts, &mimeType);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    errCode = OH_PackingOptions_SetQuality(opts, QUALITY);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }

    OH_ImageSourceNative *imgSource = nullptr;
    errCode = OH_ImageSourceNative_CreateFromRawFile(&rawSrc, &imgSource);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_ImageSourceNative> ptrImgSource(imgSource, OH_ImageSourceNative_Release);

    OH_DecodingOptions *decOpts = nullptr;
    errCode = OH_DecodingOptions_Create(&decOpts);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_DecodingOptions> ptrDecOpts(decOpts, OH_DecodingOptions_Release);

    OH_PixelmapNative *pixelMap = nullptr;
    errCode = OH_ImageSourceNative_CreatePixelmap(imgSource, decOpts, &pixelMap);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        return result;
    }
    std::shared_ptr<OH_PixelmapNative> ptrPixelMap(pixelMap, OH_PixelmapNative_Release);

    uint8_t* outBuffer = new uint8_t[DEFAULT_BUFFER_SIZE];
    size_t outBufferSize = 0;

    errCode = OH_ImagePackerNative_PackToDataFromPixelmap(
        packer, opts, pixelMap, outBuffer, &outBufferSize);
    if (errCode != IMAGE_SUCCESS) {
        napi_create_int32(env, errCode, &result);
        delete [] outBuffer;
        return result;
    }

    FILE* file = fopen(outPath, "w");
    if (file == nullptr) {
        napi_create_int32(env, errCode, &result);
        delete [] outBuffer;
        return result;
    }

    fwrite(outBuffer, sizeof(uint8_t), outBufferSize, file);
    fclose(file);

    napi_create_int32(env, errCode, &result);
    delete [] outBuffer;
    return result;
}

EXTERN_C_START static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"packToDataPixelMap", nullptr, packToDataPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"packPixelMapToFile", nullptr, packPixelMapToFile, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"packToFileImageSource", nullptr, packToFileImageSource, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"packToDataImageSource", nullptr, packToDataImageSource, nullptr, nullptr, nullptr, napi_default, nullptr},
    };

    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[NUM_0]), desc);
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
