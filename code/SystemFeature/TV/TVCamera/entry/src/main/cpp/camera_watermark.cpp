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

#include "camera_watermark.h"
#ifdef LOG_TAG
#undef LOG_TAG
#define LOG_TAG "camera-watermark:"
#endif

CameraWatermark::CameraWatermark()
{
}

CameraWatermark::~CameraWatermark()
{
}

CameraWatermarkErrorCode CameraWatermark::WatermarkPhotoPic(const std::string& inputPhotoPicPath)
{
    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkPhotoPic Start");
    photoPicPath = inputPhotoPicPath;
    return CameraWatermarkErrorCode::CAMERA_WATERMARK_OK;
}

CameraWatermarkErrorCode CameraWatermark::WatermarkPhotoFont(const std::string& inputPhotoFontStr)
{
    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkPhotoFont Start");
    photoFontStr = inputPhotoFontStr;
    return CameraWatermarkErrorCode::CAMERA_WATERMARK_OK;
}

CameraWatermarkErrorCode CameraWatermark::WatermarkVedioPic(const std::string& inputVedioPicPath)
{
    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkVedioPic Start");
    vedioPicPath = inputVedioPicPath;
    return CameraWatermarkErrorCode::CAMERA_WATERMARK_OK;
}

CameraWatermarkErrorCode CameraWatermark::WatermarkVedioFont(const std::string& inputVedioFontStr)
{
    OH_LOG_INFO(LOG_APP, "CameraWatermark WatermarkVedioFont Start");
    vedioFontStr = inputVedioFontStr;
    return CameraWatermarkErrorCode::CAMERA_WATERMARK_OK;
}
