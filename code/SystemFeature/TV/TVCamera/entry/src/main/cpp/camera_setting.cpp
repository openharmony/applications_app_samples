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

#include "camera_setting.h"
#ifdef LOG_TAG
#undef LOG_TAG
#define LOG_TAG "camera-setting:"
#endif
// 初始化静态成员
std::string CameraSetting::desiredPhotoResolution = "640*480"; // 默认使用第一个profile
std::string CameraSetting::desiredVideoResolution = "640*480"; // 默认使用第一个profile

CameraSetting::CameraSetting()
{
}

CameraSetting::~CameraSetting()
{
}
// 获取相机profile
std::string CameraSetting::GetDesiredPhotoResolution() { return desiredPhotoResolution; }
// 获取视频profile
std::string CameraSetting::GetDesiredVideoResolution() { return desiredVideoResolution; }

CameraSettingErrorCode CameraSetting::ResolutionPhoto(const std::string& photoResolution)
{
    OH_LOG_INFO(LOG_APP, "CameraSetting ResolutionPhoto Start");
    desiredPhotoResolution = photoResolution;
    return CameraSettingErrorCode::CAMERA_SETTING_OK;
}

CameraSettingErrorCode CameraSetting::ResolutionVideo(const std::string& videoResolution)
{
    OH_LOG_INFO(LOG_APP, "CameraSetting resolutionVideo Start");
    desiredVideoResolution = videoResolution;
    OH_LOG_ERROR(LOG_APP, "multi_camera: Desired resolution: %{public}s ", desiredVideoResolution.c_str());
    return CameraSettingErrorCode::CAMERA_SETTING_OK;
}
