#ifndef IMAGEKITS_H
#define IMAGEKITS_H
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
#include <js_native_api_types.h>
#include <multimedia/image_framework/image/image_common.h>
#include <multimedia/image_framework/image/image_packer_native.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include <string>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x00000      // 全局domain宏，标识业务领域。
#define LOG_TAG "IMAGE_SAMPLE" // 全局tag宏，标识模块日志tag。

// decodingPixelMap
extern napi_value GetJsResult(napi_env env, int result);
extern napi_value ReturnErrorCode(napi_env env, Image_ErrorCode errCode, std::string funcName);
extern napi_value GetSupportedFormats(napi_env env, napi_callback_info info);
extern napi_value CreateImageSource(napi_env env, napi_callback_info info);
extern napi_value GetImageInfo(napi_env env, napi_callback_info info);
extern napi_value GetImageProperty(napi_env env, napi_callback_info info);
extern napi_value ModifyImageProperty(napi_env env, napi_callback_info info);
extern napi_value CreatePixelMap(napi_env env, napi_callback_info info);
extern napi_value GetFrameCount(napi_env env, napi_callback_info info);
extern napi_value CreatePixelmapList(napi_env env, napi_callback_info info);
extern napi_value GetDelayTimeList(napi_env env, napi_callback_info info);
extern napi_value ReleaseImageSource(napi_env env, napi_callback_info info);
extern void ShowPixelMap(OH_PixelmapNative *pixelmap, uint8_t *buffer, size_t pixelsBufferSize);
napi_value TestStrideWithAllocatorType(napi_env env, napi_callback_info info);
// decodingPicture
extern napi_value ReleasePictureSource(napi_env env, napi_callback_info info);
extern napi_value SetDesiredAuxiliaryPictures(napi_env env, napi_callback_info info);
extern napi_value CreatePictureByImageSource(napi_env env, napi_callback_info info);
// encodingPixelMap
extern Image_ErrorCode packToFileFromImageSourceTest(int fd);
extern Image_MimeType GetMimeTypeIfEncodable(const char *format);
extern Image_ErrorCode packToFileFromPixelmapTest(uint8_t *buffer, size_t bufferSize, int fd);
extern napi_value PackToFileFromImageSourceTestJs(napi_env env, napi_callback_info info);
extern napi_value PackToFileFromPixelmapTestJs(napi_env env, napi_callback_info info);
// encodingPicture
extern napi_value PackToDataFromPicture(napi_env env, napi_callback_info info);
extern napi_value PackToFileFromPicture(napi_env env, napi_callback_info info);
// [Start define_sourceClass]
class ImageSourceNative {
public:
    OH_ImageSource_Info *imageInfo;
    OH_ImageSourceNative *source = nullptr;
    OH_PixelmapNative *resPixMap = nullptr;
    OH_Pixelmap_ImageInfo *pixelmapImageInfo = nullptr;
    uint32_t frameCnt = 0;
    ImageSourceNative() {}
    ~ImageSourceNative() {}
};
// [End define_sourceClass]

// [Start define_pictureClass]
class ImagePictureNative {
public:
    Image_ErrorCode errorCode = IMAGE_SUCCESS;
    OH_DecodingOptionsForPicture *options = nullptr;
    OH_ImagePackerNative *imagePacker = nullptr;
    OH_PackingOptions *packerOptions = nullptr;
    OH_PictureNative *picture = nullptr;
    OH_ImageSourceNative *source = nullptr;
    ImagePictureNative() {}
    ~ImagePictureNative() {}
};
// [End define_pictureClass]

// [Start define_auxPictureClass]
class ImageAuxiliaryPictureNative {
public:
    Image_ErrorCode errorCode = IMAGE_SUCCESS;
    Image_AuxiliaryPictureType type = AUXILIARY_PICTURE_TYPE_GAINMAP;
    OH_AuxiliaryPictureNative *auxiliaryPicture = nullptr;
    size_t buffSize = 640 * 480 * 4; // 辅助图size：`长 * 宽 * 每个像素占用的字节数`。
    ImageAuxiliaryPictureNative() {}
    ~ImageAuxiliaryPictureNative() {}
};
// [End define_auxPictureClass]

#endif // IMAGEKITS_H
