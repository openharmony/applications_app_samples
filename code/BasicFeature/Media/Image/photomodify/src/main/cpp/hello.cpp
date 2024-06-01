/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

#include <cstdio>
#include <climits>
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

static std::shared_ptr<OH_ImagePackerNative> CreatePacker()
{
    OH_ImagePackerNative *packer = nullptr;
    if (OH_ImagePackerNative_Create(&packer) != IMAGE_SUCCESS) {
        return nullptr;
    }
    std::shared_ptr<OH_ImagePackerNative> ptr(packer, OH_ImagePackerNative_Release);
    return ptr;
}

static std::shared_ptr<OH_PackingOptions> CreatePackingOpts(const char* mimeTypeStr)
{
    OH_PackingOptions *opts = nullptr;
    if (OH_PackingOptions_Create(&opts) != IMAGE_SUCCESS) {
        return nullptr;
    }

    Image_MimeType mimeType;
    mimeType.size = strlen(mimeTypeStr);
    mimeType.data = (char*)mimeTypeStr;
    if (OH_PackingOptions_SetMimeType(opts, &mimeType) != IMAGE_SUCCESS) {
        OH_PackingOptions_Release(opts);
        return nullptr;
    }

    if (OH_PackingOptions_SetQuality(opts, QUALITY) != IMAGE_SUCCESS) {
        OH_PackingOptions_Release(opts);
        return nullptr;
    }

    std::shared_ptr<OH_PackingOptions> ptr(opts, OH_PackingOptions_Release);
    return ptr;
}

static std::shared_ptr<OH_PixelmapNative> CreatePixelMap(OH_ImageSourceNative* imgSource)
{
    OH_DecodingOptions *decOpts = nullptr;
    if (OH_DecodingOptions_Create(&decOpts) != IMAGE_SUCCESS) {
        return nullptr;
    }

    OH_PixelmapNative *pixelMap = nullptr;
    if (OH_ImageSourceNative_CreatePixelmap(imgSource, decOpts, &pixelMap) != IMAGE_SUCCESS) {
        OH_DecodingOptions_Release(decOpts);
        return nullptr;
    }

    OH_DecodingOptions_Release(decOpts);
    std::shared_ptr<OH_PixelmapNative> ptr(pixelMap, OH_PixelmapNative_Release);
    return ptr;
}

static bool WriteFile(const char* outPath, uint8_t* outBuffer, size_t outBufferSize)
{
    FILE* file = fopen(outPath, "w");
    if (file == nullptr) {
        return false;
    }

    if (fwrite(outBuffer, sizeof(uint8_t), outBufferSize, file) <= 0) {
        return false;
    }
    
    if (fclose(file) != 0) {
        return false;
    }
    return true;
}

// PixelMap转为data
static napi_value packToDataPixelMap(napi_env env, napi_callback_info info)
{
    napi_value retSucess = nullptr;
    napi_create_int32(env, 0, &retSucess);
    napi_value retFailed = nullptr;
    napi_create_int32(env, -1, &retFailed);
    size_t argCount = NUM_2;
    napi_value argValue[NUM_2] = {0};
    size_t dataSize;
    void* inBuffer;
    char outPath[PATH_MAX];
    size_t outPathLen = 0;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_2) {
        return retFailed;
    }
    napi_get_arraybuffer_info(env, argValue[NUM_0], &inBuffer, &dataSize);
    napi_get_value_string_utf8(env, argValue[NUM_1], outPath, PATH_MAX, &outPathLen);
    auto ptrPacker = CreatePacker();
    if (!ptrPacker) {
        return retFailed;
    }
    auto ptrOpts = CreatePackingOpts(MIMETYPE_JPEG_STRING);
    if (!ptrOpts) {
        return retFailed;
    }
    OH_ImageSourceNative *imgSource = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromData(
        (uint8_t*)inBuffer, dataSize, &imgSource);
    if (errCode != IMAGE_SUCCESS) {
        return retFailed;
    }
    std::shared_ptr<OH_ImageSourceNative> ptrImgSource(imgSource, OH_ImageSourceNative_Release);
    auto ptrPixelMap = CreatePixelMap(ptrImgSource.get());
    if (!ptrPixelMap) {
        return retFailed;
    }
    uint8_t* outBuffer = new uint8_t[DEFAULT_BUFFER_SIZE];
    size_t outBufferSize = 0;
    errCode = OH_ImagePackerNative_PackToDataFromPixelmap(
        ptrPacker.get(), ptrOpts.get(), ptrPixelMap.get(), outBuffer, &outBufferSize);
    if (errCode != IMAGE_SUCCESS) {
        delete [] outBuffer;
        return retFailed;
    }
    if (!WriteFile(outPath, outBuffer, outBufferSize)) {
        delete [] outBuffer;
        return retFailed;
    }
    delete [] outBuffer;
    return retSucess;
}

// PixelMap转为file
static napi_value packPixelMapToFile(napi_env env, napi_callback_info info)
{
    napi_value retSucess = nullptr;
    napi_create_int32(env, 0, &retSucess);
    napi_value retFailed = nullptr;
    napi_create_int32(env, -1, &retFailed);

    size_t argCount = NUM_2;
    napi_value argValue[NUM_2] = {0};
    char inPath[PATH_MAX];
    size_t inPathLen = 0;
    int32_t outFD;

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_2) {
        return retFailed;
    }
    napi_get_value_string_utf8(env, argValue[NUM_0], inPath, PATH_MAX, &inPathLen);
    napi_get_value_int32(env, argValue[NUM_1], &outFD);

    auto ptrPacker = CreatePacker();
    if (!ptrPacker) {
        return retFailed;
    }

    auto ptrOpts = CreatePackingOpts(MIMETYPE_PNG_STRING);
    if (!ptrOpts) {
        return retFailed;
    }

    OH_ImageSourceNative *imgSource = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromUri(inPath, inPathLen, &imgSource);
    if (errCode != IMAGE_SUCCESS) {
        return retFailed;
    }
    std::shared_ptr<OH_ImageSourceNative> ptrImgSource(imgSource, OH_ImageSourceNative_Release);

    auto ptrPixelMap = CreatePixelMap(ptrImgSource.get());
    if (!ptrPixelMap) {
        return retFailed;
    }

    errCode = OH_ImagePackerNative_PackToFileFromPixelmap(
        ptrPacker.get(), ptrOpts.get(), ptrPixelMap.get(), outFD);
    if (errCode != IMAGE_SUCCESS) {
        return retFailed;
    }
    return retSucess;
}

// ImageSource转为file
static napi_value packToFileImageSource(napi_env env, napi_callback_info info)
{
    napi_value retSucess = nullptr;
    napi_create_int32(env, 0, &retSucess);
    napi_value retFailed = nullptr;
    napi_create_int32(env, -1, &retFailed);

    size_t argCount = NUM_2;
    napi_value argValue[NUM_2] = {0};
    int32_t inFD;
    int32_t outFD;

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_2) {
        return retFailed;
    }
    napi_get_value_int32(env, argValue[NUM_0], &inFD);
    napi_get_value_int32(env, argValue[NUM_1], &outFD);

    auto ptrPacker = CreatePacker();
    if (!ptrPacker) {
        return retFailed;
    }

    auto ptrOpts = CreatePackingOpts(MIMETYPE_JPEG_STRING);
    if (!ptrOpts) {
        return retFailed;
    }

    OH_ImageSourceNative *imgSource = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromFd(inFD, &imgSource);
    if (errCode != IMAGE_SUCCESS) {
        return retFailed;
    }
    std::shared_ptr<OH_ImageSourceNative> ptrImgSource(imgSource, OH_ImageSourceNative_Release);

    auto ptrPixelMap = CreatePixelMap(ptrImgSource.get());
    if (!ptrPixelMap) {
        return retFailed;
    }

    errCode = OH_ImagePackerNative_PackToFileFromPixelmap(
        ptrPacker.get(), ptrOpts.get(), ptrPixelMap.get(), outFD);
    if (errCode != IMAGE_SUCCESS) {
        return retFailed;
    }
    return retSucess;
}

// ImageSource转为data
static napi_value packToDataImageSource(napi_env env, napi_callback_info info)
{
    napi_value retSucess = nullptr;
    napi_create_int32(env, 0, &retSucess);
    napi_value retFailed = nullptr;
    napi_create_int32(env, -1, &retFailed);
    size_t argCount = NUM_4;
    napi_value argValue[NUM_4] = {0};
    RawFileDescriptor rawSrc;
    int64_t tmp;
    char outPath[PATH_MAX];
    size_t outPathLen = 0;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_4) {
        return retFailed;
    }
    napi_get_value_int32(env, argValue[NUM_0], &rawSrc.fd);
    napi_get_value_int64(env, argValue[NUM_1], &tmp);
    rawSrc.start = static_cast<long>(tmp);
    napi_get_value_int64(env, argValue[NUM_2], &tmp);
    rawSrc.length = static_cast<long>(tmp);
    napi_get_value_string_utf8(env, argValue[NUM_3], outPath, PATH_MAX, &outPathLen);
    auto ptrPacker = CreatePacker();
    auto ptrOpts = CreatePackingOpts(MIMETYPE_WEBP_STRING);
    if (!ptrPacker || !ptrOpts) {
        return retFailed;
    }
    OH_ImageSourceNative *imgSource = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromRawFile(&rawSrc, &imgSource);
    if (errCode != IMAGE_SUCCESS) {
        return retFailed;
    }
    std::shared_ptr<OH_ImageSourceNative> ptrImgSource(imgSource, OH_ImageSourceNative_Release);
    auto ptrPixelMap = CreatePixelMap(ptrImgSource.get());
    if (!ptrPixelMap) {
        return retFailed;
    }
    uint8_t* outBuffer = new uint8_t[DEFAULT_BUFFER_SIZE];
    size_t outBufferSize = 0;
    errCode = OH_ImagePackerNative_PackToDataFromPixelmap(
        ptrPacker.get(), ptrOpts.get(), ptrPixelMap.get(), outBuffer, &outBufferSize);
    if (errCode != IMAGE_SUCCESS) {
        delete [] outBuffer;
        return retFailed;
    }
    if (!WriteFile(outPath, outBuffer, outBufferSize)) {
        delete [] outBuffer;
        return retFailed;
    }
    delete [] outBuffer;
    return retSucess;
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
