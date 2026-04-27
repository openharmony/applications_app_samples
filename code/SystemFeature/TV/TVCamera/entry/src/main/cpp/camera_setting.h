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

#ifndef CAMERA_SETTING_H
#define CAMERA_SETTING_H

#include "hilog/log.h"
#include <iostream>
#include <string>
#include <vector>

// 设置的返回结果
enum class CameraSettingErrorCode {
    CAMERA_SETTING_OK = 0,
    CAMERA_SETTING_ERROR = -1
};

class CameraSetting {
public:
    CameraSetting();
    ~CameraSetting();

    // 获取当前照片分辨率配置。
    static std::string GetDesiredPhotoResolution();
    // 获取当前视频分辨率配置。
    static std::string GetDesiredVideoResolution();

    // 设置照片分辨率。
    CameraSettingErrorCode ResolutionPhoto(const std::string& photoResolution);
    // 设置视频分辨率。
    CameraSettingErrorCode ResolutionVideo(const std::string& videoResolution);

private:
    std::string resolutionPhoto;
    std::string resolutionVideo;
    static std::string desiredPhotoResolution;
    static std::string desiredVideoResolution;
};

#endif // CAMERA_SETTING_H
