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

#include "pixelmap_helper.h"
#include "common_utils.h"
#include <multimedia/image_framework/image/image_source_native.h>
#include <multimedia/image_framework/image/image_packer_native.h>
#include <fcntl.h>
#include <unistd.h>

constexpr int EXPECTED_ONE_HUNDRED = 100;

std::shared_ptr<OH_DecodingOptions> CreateDecodingOptions()
{
    OH_DecodingOptions *options = nullptr;
    Image_ErrorCode errorCode = OH_DecodingOptions_Create(&options);
    CHECK_AND_RETURN_RET_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "OH_DecodingOptions_Create fail! errorCode=%{public}d", errorCode);
    
    std::shared_ptr<OH_DecodingOptions> optionsPtr(options, [](OH_DecodingOptions *options) {
        OH_DecodingOptions_Release(options);
    });

    return optionsPtr;
}

std::shared_ptr<OH_PixelmapNative> PixelMapHelper::Decode(std::string &pathName)
{
    int fd = open(pathName.c_str(), O_RDWR);
    CHECK_AND_RETURN_RET_LOG(fd != -1, nullptr, "Open path fail! pathName=%{public}s", pathName.c_str());

    std::shared_ptr<int> fdPtr(&fd, [](int *fd) { close(*fd); });
    OH_ImageSourceNative *imageSource = nullptr;
    Image_ErrorCode errorCode = OH_ImageSourceNative_CreateFromFd(*fdPtr.get(), &imageSource);
    CHECK_AND_RETURN_RET_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "OH_ImageSourceNative_CreateFromFd fail! errorCode=%{public}d", errorCode);

    std::shared_ptr<OH_ImageSourceNative> imageSourcePtr(imageSource, [](OH_ImageSourceNative *imageSource) {
        OH_ImageSourceNative_Release(imageSource);
    });

    std::shared_ptr<OH_DecodingOptions> optionsPtr = CreateDecodingOptions();
    CHECK_AND_RETURN_RET_LOG(optionsPtr != nullptr, nullptr, "CreateDecodingOptions fail!");

    OH_PixelmapNative *pixelmap = nullptr;
    errorCode = OH_ImageSourceNative_CreatePixelmap(imageSourcePtr.get(), optionsPtr.get(), &pixelmap);
    CHECK_AND_RETURN_RET_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "OH_ImageSourceNative_CreatePixelmap fail! errorCode=%{public}d", errorCode);

    std::shared_ptr<OH_PixelmapNative> pixelmapPtr(pixelmap, [](OH_PixelmapNative *pixelmap) {
        OH_PixelmapNative_Release(pixelmap);
    });

    return pixelmapPtr;
}

std::shared_ptr<OH_PackingOptions> CreatePackingOptions()
{
    OH_PackingOptions *options = nullptr;
    Image_ErrorCode errorCode = OH_PackingOptions_Create(&options);
    CHECK_AND_RETURN_RET_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, nullptr,
        "OH_PackingOptions_Create fail! errorCode=%{public}d", errorCode);

    std::shared_ptr<OH_PackingOptions> optionsPtr(options, [](OH_PackingOptions *options) {
        OH_PackingOptions_Release(options);
    });

    OH_PackingOptions_SetQuality(optionsPtr.get(), EXPECTED_ONE_HUNDRED);
    Image_MimeType format = { .data = const_cast<char *>(MIME_TYPE_JPEG), .size = strlen(MIME_TYPE_JPEG) };
    OH_PackingOptions_SetMimeType(optionsPtr.get(), &format);
    return optionsPtr;
}

bool PixelMapHelper::Encode(OH_PixelmapNative *pixelmap, std::string &path)
{
    OH_ImagePackerNative *imagePacker = nullptr;
    Image_ErrorCode errorCode = OH_ImagePackerNative_Create(&imagePacker);
    CHECK_AND_RETURN_RET_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, false,
        "OH_ImagePackerNative_Create fail! errorCode=%{public}d", errorCode);

    std::shared_ptr<OH_ImagePackerNative> imagePackerPtr(imagePacker, [](OH_ImagePackerNative *imagePacker) {
        OH_ImagePackerNative_Release(imagePacker);
    });

    std::shared_ptr<OH_PackingOptions> optionsPtr = CreatePackingOptions();
    CHECK_AND_RETURN_RET_LOG(optionsPtr != nullptr, false, "CreatePackingOptions fail!");

    int fd = open(path.c_str(), O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
    CHECK_AND_RETURN_RET_LOG(fd != -1, false, "Open path fail! path=%{public}s", path.c_str());
    errorCode = OH_ImagePackerNative_PackToFileFromPixelmap(imagePackerPtr.get(), optionsPtr.get(), pixelmap, fd);
    close(fd);
    CHECK_AND_RETURN_RET_LOG(errorCode == Image_ErrorCode::IMAGE_SUCCESS, false,
        "OH_ImagePackerNative_PackToFileFromPixelmap fail! errorCode=%{public}d", errorCode);

    return true;
}