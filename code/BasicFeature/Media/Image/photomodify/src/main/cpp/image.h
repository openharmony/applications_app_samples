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
#ifndef PICTURE_H
#define PICTURE_H

#include <memory>
#include <multimedia/image_framework/image/image_native.h>
#include <multimedia/image_framework/image/picture_native.h>
#include <string>
#include <vector>
#include "napi/native_api.h"

#include "multimedia/image_framework/image/image_source_native.h"
#include "multimedia/image_framework/image/pixelmap_native.h"
#include "multimedia/image_framework/image/image_source_native.h"
#include "multimedia/image_framework/image/image_common.h"
#include "multimedia/image_framework/image/image_native.h"
#include "multimedia/image_framework/image/image_packer_native.h"
#include <bits/alltypes.h>
#include "common/log_common.h"
#include <hilog/log.h>

struct ImagePictureNative {
    Image_ErrorCode errorCode = IMAGE_SUCCESS;
    OH_DecodingOptionsForPicture *options = nullptr;
    OH_ImagePackerNative *imagePacker = nullptr;
    OH_PackingOptions *packerOptions = nullptr;
    OH_AuxiliaryPictureNative *auxiliaryPicture = nullptr;
    OH_AuxiliaryPictureNative *gainMapAuxiliaryPicture = nullptr;
    OH_PictureNative *picture = nullptr;
    OH_AuxiliaryPictureInfo *info = nullptr;
    OH_PictureMetadata *metadata = nullptr;
    OH_PictureMetadata *newMetadata = nullptr;
    OH_ImageSourceNative *source = nullptr;
    OH_PixelmapNative *resPixMap = nullptr;
};

#endif // PICTURE_H