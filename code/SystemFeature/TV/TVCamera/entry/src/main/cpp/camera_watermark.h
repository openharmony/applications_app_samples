/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef CAMERA_WATERMARK_H
#define CAMERA_WATERMARK_H

#include "hilog/log.h"
#include <iostream>
#include <string>
#include <vector>

// 返回结果
enum class CameraWatermarkErrorCode {
    CAMERA_WATERMARK_OK = 0,
    CAMERA_WATERMARK_ERROR = -1
};

class CameraWatermark {
public:
    CameraWatermark();
    ~CameraWatermark();

    // 设置照片图片水印。
    CameraWatermarkErrorCode WatermarkPhotoPic(const std::string& inputPhotoPicPath);
    // 设置照片文字水印。
    CameraWatermarkErrorCode WatermarkPhotoFont(const std::string& inputPhotoFontStr);
    // 设置视频图片水印。
    CameraWatermarkErrorCode WatermarkVedioPic(const std::string& inputVedioPicPath);
    // 设置视频文字水印。
    CameraWatermarkErrorCode WatermarkVedioFont(const std::string& inputVedioFontStr);

private:
    std::string photoPicPath;
    std::string photoFontStr;
    std::string vedioPicPath;
    std::string vedioFontStr;
};

#endif // CAMERA_WATERMARK_H
