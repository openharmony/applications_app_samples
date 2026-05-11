/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start hdrColorSpace_import]
#include <cstring>
#include <string>
#include <hilog/log.h>
#include <multimedia/image_framework/image/image_common.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include <multimedia/image_framework/image/picture_native.h>
#include <multimedia/image_framework/image/image_packer_native.h>
#include "napi/native_api.h"
#include <imageKits.h>
// [End hdrColorSpace_import]

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "IMAGE_SAMPLE"

// [Start create_hdrColorSpaceClass]
static ImageHdrColorSpaceNative *g_hdrColorSpace = new ImageHdrColorSpaceNative();
// [End create_hdrColorSpaceClass]

// [Start define_maxStringLength]
const int MAX_STRING_LENGTH = 1024;
// [End define_maxStringLength]

static napi_value ReturnHdrErrorCode(napi_env env, Image_ErrorCode errCode, const std::string &funcName)
{
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "%{public}s failed, errCode: %{public}d.", funcName.c_str(), errCode);
    }
    return GetJsResult(env, errCode);
}

static void ReleasePixelMap(OH_PixelmapNative **pixelMap)
{
    if (pixelMap != nullptr && *pixelMap != nullptr) {
        OH_PixelmapNative_Release(*pixelMap);
        *pixelMap = nullptr;
    }
}

// [Start hdrColorSpace_createImageSource]
napi_value CreateHdrImageSource(napi_env env, napi_callback_info info)
{
    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok ||
        argCount < 1 || argValue[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreateHdrImageSource napi_get_cb_info failed!");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    if (g_hdrColorSpace->source != nullptr) {
        ReleaseHdrColorSpaceSource(env, info);
    }

    char filePath[MAX_STRING_LENGTH];
    size_t pathSize = MAX_STRING_LENGTH;
    napi_get_value_string_utf8(env, argValue[0], filePath, MAX_STRING_LENGTH, &pathSize);

    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromUri(filePath, pathSize, &g_hdrColorSpace->source);
    return ReturnHdrErrorCode(env, errCode, "OH_ImageSourceNative_CreateFromUri");
}
// [End hdrColorSpace_createImageSource]

// [Start hdrColorSpace_decodePixelMap]
napi_value DecodeHdrPixelMap(napi_env env, napi_callback_info info)
{
    if (g_hdrColorSpace->source == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ImageSource is nullptr.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    OH_DecodingOptions *opts = nullptr;
    Image_ErrorCode errCode = OH_DecodingOptions_Create(&opts);
    if (errCode != IMAGE_SUCCESS || opts == nullptr) {
        return ReturnHdrErrorCode(env, errCode, "OH_DecodingOptions_Create");
    }

    OH_DecodingOptions_SetDesiredDynamicRange(opts, IMAGE_DYNAMIC_RANGE_AUTO);
    ReleasePixelMap(&g_hdrColorSpace->pixelMap);
    errCode = OH_ImageSourceNative_CreatePixelmap(g_hdrColorSpace->source, opts, &g_hdrColorSpace->pixelMap);

    OH_DecodingOptions_Release(opts);
    opts = nullptr;
    return ReturnHdrErrorCode(env, errCode, "OH_ImageSourceNative_CreatePixelmap");
}
// [End hdrColorSpace_decodePixelMap]

// [Start hdrColorSpace_checkDynamicRange]
napi_value CheckHdrDynamicRange(napi_env env, napi_callback_info info)
{
    if (g_hdrColorSpace->pixelMap == nullptr) {
        OH_LOG_ERROR(LOG_APP, "PixelMap is nullptr.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    Image_ErrorCode errCode = OH_PixelmapImageInfo_Create(&g_hdrColorSpace->pixelMapImageInfo);
    if (errCode != IMAGE_SUCCESS || g_hdrColorSpace->pixelMapImageInfo == nullptr) {
        return ReturnHdrErrorCode(env, errCode, "OH_PixelmapImageInfo_Create");
    }

    errCode = OH_PixelmapNative_GetImageInfo(g_hdrColorSpace->pixelMap, g_hdrColorSpace->pixelMapImageInfo);
    if (errCode != IMAGE_SUCCESS) {
        OH_PixelmapImageInfo_Release(g_hdrColorSpace->pixelMapImageInfo);
        g_hdrColorSpace->pixelMapImageInfo = nullptr;
        return ReturnHdrErrorCode(env, errCode, "OH_PixelmapNative_GetImageInfo");
    }

    bool isHdr = false;
    errCode = OH_PixelmapImageInfo_GetDynamicRange(g_hdrColorSpace->pixelMapImageInfo, &isHdr);
    if (errCode == IMAGE_SUCCESS) {
        g_hdrColorSpace->isHdr = isHdr;
        OH_LOG_INFO(LOG_APP, "PixelMap dynamic range is %{public}s.", isHdr ? "HDR" : "SDR");
    }

    OH_PixelmapImageInfo_Release(g_hdrColorSpace->pixelMapImageInfo);
    g_hdrColorSpace->pixelMapImageInfo = nullptr;
    return ReturnHdrErrorCode(env, errCode, "OH_PixelmapImageInfo_GetDynamicRange");
}
// [End hdrColorSpace_checkDynamicRange]

// [Start hdrColorSpace_decodeSdrPixelMap]
napi_value DecodeSdrPixelMap(napi_env env, napi_callback_info info)
{
    if (g_hdrColorSpace->source == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ImageSource is nullptr.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    OH_DecodingOptions *opts = nullptr;
    Image_ErrorCode errCode = OH_DecodingOptions_Create(&opts);
    if (errCode != IMAGE_SUCCESS || opts == nullptr) {
        return ReturnHdrErrorCode(env, errCode, "OH_DecodingOptions_Create");
    }

    OH_DecodingOptions_SetDesiredDynamicRange(opts, IMAGE_DYNAMIC_RANGE_SDR);
    ReleasePixelMap(&g_hdrColorSpace->pixelMap);
    errCode = OH_ImageSourceNative_CreatePixelmap(g_hdrColorSpace->source, opts, &g_hdrColorSpace->pixelMap);

    OH_DecodingOptions_Release(opts);
    opts = nullptr;
    return ReturnHdrErrorCode(env, errCode, "OH_ImageSourceNative_CreatePixelmap");
}
// [End hdrColorSpace_decodeSdrPixelMap]

// [Start hdrColorSpace_decodePicture]
napi_value DecodeHdrPicture(napi_env env, napi_callback_info info)
{
    if (g_hdrColorSpace->source == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ImageSource is nullptr.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    OH_DecodingOptionsForPicture *options = nullptr;
    Image_ErrorCode errCode = OH_DecodingOptionsForPicture_Create(&options);
    if (errCode != IMAGE_SUCCESS || options == nullptr) {
        return ReturnHdrErrorCode(env, errCode, "OH_DecodingOptionsForPicture_Create");
    }

    Image_AuxiliaryPictureType desiredAuxiliaryPictures[] = { AUXILIARY_PICTURE_TYPE_GAINMAP };
    errCode = OH_DecodingOptionsForPicture_SetDesiredAuxiliaryPictures(options, desiredAuxiliaryPictures, 1);
    if (errCode != IMAGE_SUCCESS) {
        OH_DecodingOptionsForPicture_Release(options);
        options = nullptr;
        return ReturnHdrErrorCode(env, errCode, "OH_DecodingOptionsForPicture_SetDesiredAuxiliaryPictures");
    }

    if (g_hdrColorSpace->picture != nullptr) {
        OH_PictureNative_Release(g_hdrColorSpace->picture);
        g_hdrColorSpace->picture = nullptr;
    }

    errCode = OH_ImageSourceNative_CreatePicture(g_hdrColorSpace->source, options, &g_hdrColorSpace->picture);

    OH_DecodingOptionsForPicture_Release(options);
    options = nullptr;
    return ReturnHdrErrorCode(env, errCode, "OH_ImageSourceNative_CreatePicture");
}
// [End hdrColorSpace_decodePicture]

// [Start hdrColorSpace_getMainPixelmap]
napi_value GetMainPixelmapFromPicture(napi_env env, napi_callback_info info)
{
    if (g_hdrColorSpace->picture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Picture is nullptr.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    ReleasePixelMap(&g_hdrColorSpace->mainPixelMap);
    Image_ErrorCode errCode = OH_PictureNative_GetMainPixelmap(g_hdrColorSpace->picture,
        &g_hdrColorSpace->mainPixelMap);
    return ReturnHdrErrorCode(env, errCode, "OH_PictureNative_GetMainPixelmap");
}
// [End hdrColorSpace_getMainPixelmap]

// [Start hdrColorSpace_getGainmapPixelmap]
napi_value GetGainmapPixelmapFromPicture(napi_env env, napi_callback_info info)
{
    if (g_hdrColorSpace->picture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Picture is nullptr.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    ReleasePixelMap(&g_hdrColorSpace->gainmapPixelMap);
    Image_ErrorCode errCode = OH_PictureNative_GetGainmapPixelmap(g_hdrColorSpace->picture,
        &g_hdrColorSpace->gainmapPixelMap);
    return ReturnHdrErrorCode(env, errCode, "OH_PictureNative_GetGainmapPixelmap");
}
// [End hdrColorSpace_getGainmapPixelmap]

// [Start hdrColorSpace_getHdrComposedPixelmap]
napi_value GetHdrComposedPixelmapFromPicture(napi_env env, napi_callback_info info)
{
    if (g_hdrColorSpace->picture == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Picture is nullptr.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    ReleasePixelMap(&g_hdrColorSpace->hdrPixelMap);
    Image_ErrorCode errCode = OH_PictureNative_GetHdrComposedPixelmap(g_hdrColorSpace->picture,
        &g_hdrColorSpace->hdrPixelMap);
    return ReturnHdrErrorCode(env, errCode, "OH_PictureNative_GetHdrComposedPixelmap");
}
// [End hdrColorSpace_getHdrComposedPixelmap]

// [Start hdrColorSpace_packHdrPixelMap]
napi_value PackHdrPixelMap(napi_env env, napi_callback_info info)
{
    if (g_hdrColorSpace->pixelMap == nullptr) {
        OH_LOG_ERROR(LOG_APP, "PixelMap is nullptr.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok ||
        argCount < 1 || argValue[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "PackHdrPixelMap napi_get_cb_info failed!");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    int32_t fd = -1;
    napi_get_value_int32(env, argValue[0], &fd);

    OH_ImagePackerNative *packer = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&packer);
    if (errCode != IMAGE_SUCCESS || packer == nullptr) {
        return ReturnHdrErrorCode(env, errCode, "OH_ImagePackerNative_Create");
    }

    OH_PackingOptions *packingOptions = nullptr;
    errCode = OH_PackingOptions_Create(&packingOptions);
    if (errCode != IMAGE_SUCCESS || packingOptions == nullptr) {
        OH_ImagePackerNative_Release(packer);
        packer = nullptr;
        return ReturnHdrErrorCode(env, errCode, "OH_PackingOptions_Create");
    }

    char type[] = "image/jpeg";
    Image_MimeType mimeType = {type, strlen(type)};
    OH_PackingOptions_SetMimeType(packingOptions, &mimeType);
    uint32_t quality = 95;
    OH_PackingOptions_SetQuality(packingOptions, quality);
    OH_PackingOptions_SetDesiredDynamicRange(packingOptions, IMAGE_PACKER_DYNAMIC_RANGE_AUTO);

    errCode = OH_ImagePackerNative_PackToFileFromPixelmap(packer, packingOptions, g_hdrColorSpace->pixelMap, fd);

    OH_PackingOptions_Release(packingOptions);
    packingOptions = nullptr;
    OH_ImagePackerNative_Release(packer);
    packer = nullptr;
    return ReturnHdrErrorCode(env, errCode, "OH_ImagePackerNative_PackToFileFromPixelmap");
}
// [End hdrColorSpace_packHdrPixelMap]

// [Start hdrColorSpace_release]
napi_value ReleaseHdrColorSpaceSource(napi_env env, napi_callback_info info)
{
    Image_ErrorCode errCode = IMAGE_SUCCESS;

    ReleasePixelMap(&g_hdrColorSpace->hdrPixelMap);
    ReleasePixelMap(&g_hdrColorSpace->gainmapPixelMap);
    ReleasePixelMap(&g_hdrColorSpace->mainPixelMap);

    if (g_hdrColorSpace->picture != nullptr) {
        errCode = OH_PictureNative_Release(g_hdrColorSpace->picture);
        g_hdrColorSpace->picture = nullptr;
    }

    ReleasePixelMap(&g_hdrColorSpace->pixelMap);

    if (g_hdrColorSpace->source != nullptr) {
        errCode = OH_ImageSourceNative_Release(g_hdrColorSpace->source);
        g_hdrColorSpace->source = nullptr;
    }

    g_hdrColorSpace->isHdr = false;
    return ReturnHdrErrorCode(env, errCode, "ReleaseHdrColorSpaceSource");
}
// [End hdrColorSpace_release]