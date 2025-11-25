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

#include <window_manager/oh_display_manager.h>
#include "adaptation_util.h"
#include "common/log_common.h"

AdaptationUtil* AdaptationUtil::instance_ = nullptr;

AdaptationUtil* AdaptationUtil::GetInstance()
{
    if (instance_ == nullptr) {
        instance_ = new AdaptationUtil();
    }
    return instance_;
}

float AdaptationUtil::GetWidth(float width)
{
    return width * screenWidth_ / standardWidth_;
}

float AdaptationUtil::GetHeight(float height)
{
    return height * screenHeight_ / standardHeight_;
}

AdaptationUtil::AdaptationUtil()
{
    NativeDisplayManager_ErrorCode errorCode = OH_NativeDisplayManager_GetDefaultDisplayWidth(&screenWidth_);
    if (errorCode != NativeDisplayManager_ErrorCode::DISPLAY_MANAGER_OK) {
        SAMPLE_LOGE("GetDefaultDisplayWidth failed");
    }
    errorCode = OH_NativeDisplayManager_GetDefaultDisplayHeight(&screenHeight_);
    if (errorCode != NativeDisplayManager_ErrorCode::DISPLAY_MANAGER_OK) {
        SAMPLE_LOGE("GetDefaultDisplayHeight failed");
    }
}