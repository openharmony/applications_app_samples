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
#include "image.h"
#include "common/log_common.h"
#include <bits/alltypes.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sstream>
#include <fstream>

#define MIMETYPE_JPEG_STRING "image/jpeg"
#define MIMETYPE_PNG_STRING "image/png"
#define MIMETYPE_WEBP_STRING "image/webp"
#define AUTO 0
#define SDR 1
#define SIZE 10
const char *TAG = "[SamplePictureCpp]";
static napi_value GetRowStride(napi_env env, napi_callback_info info);
static napi_value GetAuxInfoType(napi_env env, napi_callback_info info);
static napi_value GetAuxInfoSize(napi_env env, napi_callback_info info);
static napi_value GetPixelFormat(napi_env env, napi_callback_info info);
Image_ErrorCode MyPackToFileFromImageSource(uint32_t fd);
Image_ErrorCode ReleaseImageSource(OH_ImageSourceNative* &source);
static ImagePictureNative *g_thisPicture  = new ImagePictureNative();

constexpr int32_t NUM_0 = 0;
constexpr int32_t NUM_1 = 1;
constexpr int32_t NUM_2 = 2;
constexpr int32_t NUM_3 = 3;
constexpr int32_t NUM_4 = 4;

constexpr uint32_t QUALITY = 100;
constexpr uint64_t DEFAULT_BUFFER_SIZE = 25 * 1024 * 1024;
constexpr size_t MAX_BUFFER_SIZE = 10000 * 10000;

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
    napi_value retSuccess = nullptr;
    napi_create_int32(env, 0, &retSuccess);
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
    return retSuccess;
}

// PixelMap转为file
static napi_value packPixelMapToFile(napi_env env, napi_callback_info info)
{
    napi_value retSuccess = nullptr;
    napi_create_int32(env, 0, &retSuccess);
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
    return retSuccess;
}

// ImageSource转为file
static napi_value packToFileImageSource(napi_env env, napi_callback_info info)
{
    napi_value retSuccess = nullptr;
    napi_create_int32(env, 0, &retSuccess);
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

    errCode = OH_ImagePackerNative_PackToFileFromImageSource(
        ptrPacker.get(), ptrOpts.get(), imgSource, outFD);
    if (errCode != IMAGE_SUCCESS) {
        return retFailed;
    }
    return retSuccess;
}

// ImageSource转为data
static napi_value packToDataImageSource(napi_env env, napi_callback_info info)
{
    napi_value retSuccess = nullptr;
    napi_create_int32(env, 0, &retSuccess);
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

    uint8_t* outBuffer = new uint8_t[DEFAULT_BUFFER_SIZE];
    size_t outBufferSize = 0;
    errCode = OH_ImagePackerNative_PackToDataFromImageSource(
        ptrPacker.get(), ptrOpts.get(), imgSource, outBuffer, &outBufferSize);
    if (errCode != IMAGE_SUCCESS) {
        delete [] outBuffer;
        return retFailed;
    }
    if (!WriteFile(outPath, outBuffer, outBufferSize)) {
        delete [] outBuffer;
        return retFailed;
    }
    delete [] outBuffer;
    return retSuccess;
}

// 处理napi返回值
napi_value getJsResult(napi_env env, Image_ErrorCode errorCode)
{
    napi_value retSuccess = nullptr;
    napi_create_int32(env, 0, &retSuccess);
    napi_value retFailed = nullptr;
    napi_create_int32(env, -1, &retFailed);
    if (errorCode == IMAGE_SUCCESS) {
        return retSuccess;
    } else {
        return retFailed;
    }
}

// 释放ImageSource
Image_ErrorCode ReleaseImageSource(OH_ImageSourceNative*& source)
{
    if (source != nullptr) {
        g_thisPicture->errorCode = OH_ImageSourceNative_Release(source);
        source = nullptr;
        return g_thisPicture->errorCode;
    }
    return IMAGE_SUCCESS;
}

// 解码创造多图对象
static napi_value CreatePictureByImageSource(napi_env env, napi_callback_info info)
{
    napi_value retFailed = nullptr;
    napi_create_int32(env, -1, &retFailed);
    size_t argCount = NUM_1;
    napi_value argValue[NUM_1] = {0};
    char filePath[PATH_MAX];
    size_t filePathSize = NUM_0;

    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_1) {
        return retFailed;
    }
    napi_get_value_string_utf8(env, argValue[NUM_0], filePath, PATH_MAX, &filePathSize);

    ReleaseImageSource(g_thisPicture->source);
    g_thisPicture->errorCode = OH_ImageSourceNative_CreateFromUri(filePath, filePathSize, &g_thisPicture->source);
    if (g_thisPicture->errorCode != NUM_0) {
        H_LOGE("%{public}s CreatePictureByImageSource OH_ImageSourceNative_CreateFromUri failed !", TAG);
        return getJsResult(env, g_thisPicture->errorCode);
    }
    
    g_thisPicture->errorCode =
        OH_ImageSourceNative_CreatePicture(g_thisPicture->source, g_thisPicture->options, &g_thisPicture->picture);
    return getJsResult(env, g_thisPicture->errorCode);
}

// 创造解码参数对象
static napi_value CreateDecodingOptions(napi_env env, napi_callback_info info)
{
    g_thisPicture->errorCode = OH_DecodingOptionsForPicture_Create(&g_thisPicture->options);
    return getJsResult(env, g_thisPicture->errorCode);
}

// 配置解码参数
static napi_value SetDesiredAuxiliaryPictures(napi_env env, napi_callback_info info)
{
    size_t argc = NUM_1;
    napi_value args[NUM_1] = {nullptr};
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok || argc < 1 || args[0] == nullptr) {
        H_LOGE("%{public}s napi_get_cb_info failed !", TAG);
        return getJsResult(env, IMAGE_BAD_PARAMETER);
    }
    
    uint32_t length = NUM_0;
    napi_get_array_length(env, args[0], &length);
    if (length <= NUM_0) {
        H_LOGE("%{public}s napi_get_array_length failed !", TAG);
        return getJsResult(env, IMAGE_UNKNOWN_ERROR);
    }
    Image_AuxiliaryPictureType typeList[length];
    for (int index = 0; index < length; index++) {
        napi_value element;
        uint32_t ulType = NUM_0;
        napi_get_element(env, args[NUM_0], index, &element);
        napi_get_value_uint32(env, element, &ulType);
        typeList[index] = static_cast<Image_AuxiliaryPictureType>(ulType);
    }
    
    g_thisPicture->errorCode =
        OH_DecodingOptionsForPicture_SetDesiredAuxiliaryPictures(g_thisPicture->options, typeList, length);
    return getJsResult(env, g_thisPicture->errorCode);
}

// 获取解码参数
static napi_value GetDesiredAuxiliaryPictures(napi_env env, napi_callback_info info)
{
    napi_value retSuccess = nullptr;
    napi_create_int32(env, NUM_0, &retSuccess);
    Image_AuxiliaryPictureType *desiredAuxiliaryPictures = nullptr;
    size_t length = NUM_0;
    g_thisPicture->errorCode = OH_DecodingOptionsForPicture_GetDesiredAuxiliaryPictures(
        g_thisPicture->options, &desiredAuxiliaryPictures, &length);
    if (g_thisPicture->errorCode != IMAGE_SUCCESS || desiredAuxiliaryPictures == nullptr || length <= 0) {
        H_LOGE("%{public}s OH_DecodingOptionsForPicture_GetDesiredAuxiliaryPictures failed, errCode: %{public}d.", TAG,
               g_thisPicture->errorCode);
        return getJsResult(env, g_thisPicture->errorCode);
    }
    return retSuccess;
}

// 释放解码参数
static napi_value ReleaseDecodingOptions(napi_env env, napi_callback_info info)
{
    g_thisPicture->errorCode = OH_DecodingOptionsForPicture_Release(g_thisPicture->options);
    g_thisPicture->options = nullptr;
    return getJsResult(env, g_thisPicture->errorCode);
}
  
// 配置编码参数
void SetPackOptions(OH_PackingOptions *packerOptions, Image_MimeType format, uint32_t quality,
                    bool needsPackProperties, int32_t desiredDynamicRange)
{
    OH_PackingOptions_SetMimeType(packerOptions, &format);
    OH_PackingOptions_SetQuality(packerOptions, quality);
    OH_PackingOptions_SetNeedsPackProperties(packerOptions, needsPackProperties);
    OH_PackingOptions_SetDesiredDynamicRange(packerOptions, desiredDynamicRange);
}
 
// 把多图对象编码成data
static napi_value PackToDataPicture(napi_env env, napi_callback_info info)
{
    napi_value retFailed = nullptr;
    napi_create_int32(env, -1, &retFailed);
    size_t argc = NUM_1;
    napi_value args[NUM_1] = {nullptr};
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok) {
        H_LOGE("%{public}s napi_get_cb_info failed !", TAG);
        return getJsResult(env, g_thisPicture->errorCode);
    }

    char outPath[PATH_MAX];
    size_t outPathLen = NUM_0;
    napi_get_value_string_utf8(env, args[NUM_0], outPath, PATH_MAX, &outPathLen);
    size_t outDataSize = MAX_BUFFER_SIZE;
    uint8_t *outData = new uint8_t[MAX_BUFFER_SIZE];

    if (g_thisPicture->packerOptions == nullptr) {
        g_thisPicture->errorCode = OH_PackingOptions_Create(&g_thisPicture->packerOptions);
    }
    if (g_thisPicture->imagePacker == nullptr) {
        g_thisPicture->errorCode = OH_ImagePackerNative_Create(&g_thisPicture->imagePacker);
    }
    
    Image_MimeType format;
    format.size = SIZE;
    format.data = const_cast<char *>(MIMETYPE_JPEG_STRING);
    uint32_t quality = QUALITY;
    bool needsPackProperties = true;
    int32_t desiredDynamicRange = SDR;
    SetPackOptions(g_thisPicture ->packerOptions,
        format, quality, needsPackProperties, desiredDynamicRange);
    g_thisPicture->errorCode = OH_ImagePackerNative_PackToDataFromPicture(
        g_thisPicture->imagePacker, g_thisPicture->packerOptions, g_thisPicture->picture, outData, &outDataSize);
    if (g_thisPicture->errorCode != IMAGE_SUCCESS) {
        H_LOGE("%{public}s OH_ImagePackerNative_PackToDataFromPicture failed, errCode: %{public}d.", TAG,
               g_thisPicture->errorCode);
        delete[] outData;
        return getJsResult(env, g_thisPicture->errorCode);
    } else {
        if (!WriteFile(outPath, outData, outDataSize)) {
        delete [] outData;
        return retFailed;
        }
    }
    return getJsResult(env, g_thisPicture->errorCode);
}

static napi_value PackToFilePicture(napi_env env, napi_callback_info info)
{
    size_t argc = NUM_1;
    napi_value args[NUM_1] = {nullptr};
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok) {
        H_LOGE("%{public}s napi_get_cb_info failed !", TAG);
        return getJsResult(env, g_thisPicture->errorCode);
    }
    uint32_t fd = NUM_0;
    napi_get_value_uint32(env, args[NUM_0], &fd);

    if (g_thisPicture->packerOptions == nullptr) {
        g_thisPicture->errorCode = OH_PackingOptions_Create(&g_thisPicture->packerOptions);
    }
    if (g_thisPicture->imagePacker == nullptr) {
        g_thisPicture->errorCode = OH_ImagePackerNative_Create(&g_thisPicture->imagePacker);
    }

    Image_MimeType format;
    format.size = SIZE;
    format.data = const_cast<char *>(MIMETYPE_JPEG_STRING);
    uint32_t quality = QUALITY;
    bool needsPackProperties = true;
    int32_t desiredDynamicRange = SDR;
    SetPackOptions(g_thisPicture->packerOptions,
        format, quality, needsPackProperties, desiredDynamicRange);

    g_thisPicture->errorCode = OH_ImagePackerNative_PackToFileFromPicture(
        g_thisPicture->imagePacker, g_thisPicture->packerOptions, g_thisPicture->picture, fd);
    
    if (g_thisPicture->errorCode != IMAGE_SUCCESS) {
        H_LOGE("%{public}s OH_ImagePackerNative_PackToFileFromPicture failed, errCode: %{public}d.", TAG,
               g_thisPicture->errorCode);
        return getJsResult(env, g_thisPicture->errorCode);
    }
    return getJsResult(env, g_thisPicture->errorCode);
}

EXTERN_C_START static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"packToDataPixelMap", nullptr, packToDataPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"packPixelMapToFile", nullptr, packPixelMapToFile, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"packToFileImageSource", nullptr, packToFileImageSource, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"packToDataImageSource", nullptr, packToDataImageSource, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createPictureByImageSource", nullptr, CreatePictureByImageSource, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"createDecodingOptions", nullptr, CreateDecodingOptions, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getDesiredAuxiliaryPictures", nullptr, GetDesiredAuxiliaryPictures, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"setDesiredAuxiliaryPictures", nullptr, SetDesiredAuxiliaryPictures, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"releaseDecodingOptions", nullptr, ReleaseDecodingOptions, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"packToDataPicture", nullptr, PackToDataPicture, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"packToFilePicture", nullptr, PackToFilePicture, nullptr, nullptr, nullptr, napi_default, nullptr},
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
