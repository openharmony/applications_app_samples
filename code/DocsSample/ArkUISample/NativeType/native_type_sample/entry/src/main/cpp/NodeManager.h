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
#ifndef CAPI_MANAGER_H
#define CAPI_MANAGER_H

#include <functional>
#include <arkui/native_node.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <unordered_map>
#include <string>


using EventCallback = std::function<void(ArkUI_NodeEvent*)>;

class NodeManager {
public:
    ~NodeManager() = default;
    static NodeManager& GetInstance();
    void SetContentHandle(ArkUI_NodeContentHandle contentHandle);
    void CreateProgress();
    void CreateTextPickerWithCustomContent(int32_t type);
    void SetProgressType(int32_t type);
    void SetProgressLinearStyleOption(bool scanEffect, bool smoothEffect, int32_t strokeWidth, int32_t strokeRadius);
    std::string GetProgressLinearStyleOptionAndDestroy();
    std::string GetImageAnimatorFrameInfo();
    void CreateDatePicker(int32_t modeType);
    void CreateCalendarPicker(int32_t modeType);
    void CreateImageSize(int32_t objectFit, int32_t imageSize);
    void SetImageProperties(int32_t imageRepeat, int32_t imageInterpolation, int32_t imageRenderMode);
    void SetUpColumnAndText(ArkUI_NativeNodeAPI_1 *nodeApi, ArkUI_NodeHandle &column, ArkUI_NodeHandle &text);
    void AddTextPicker(int32_t type, ArkUI_NativeNodeAPI_1 *nodeApi, ArkUI_NodeHandle &column);
    void SetUpTextCrossLanguage(bool isCross);
    void CreateImageAnimatorFromString(int32_t width, int32_t height, int32_t top, int32_t left, int32_t duration);
    ArkUI_DrawableDescriptor* CreateDescriptor();
    void CreateImageAnimatorFromDrawableDescriptor(int32_t width,
        int32_t height, int32_t top, int32_t left, int32_t duration);
    void ClearNodes();
private:
    NodeManager() = default;
    ArkUI_NodeContentHandle contentHandle_;
    //nodes_ 用来存储的是需要用到的node组件
    std::unordered_map<std::string, ArkUI_NodeHandle> nodes_;
    std::unordered_map<int32_t, EventCallback> callbackMap_;
};


#endif //CAPI_MANAGER_H
