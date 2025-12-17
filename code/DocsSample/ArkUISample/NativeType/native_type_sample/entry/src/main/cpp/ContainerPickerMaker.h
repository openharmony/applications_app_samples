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

#ifndef NATIVE_TYPE_SAMPLE_CONTAINER_PICKER_MAKER_H
#define NATIVE_TYPE_SAMPLE_CONTAINER_PICKER_MAKER_H

#include <arkui/native_node.h>
#include <cstdint>

#include "ScrollableNode.h"

class ContainerPickerMaker {
public:
    static ArkUI_NodeHandle CreateNativeNode();

    ~ContainerPickerMaker() = default;

private:
    static ArkUI_NativeNodeAPI_1 *GetNativeNodeAPI();
    static ArkUI_NodeHandle CreateFullScreenContainer(ArkUI_NativeNodeAPI_1 *api);
    static ArkUI_NodeHandle CreateContainerPicker(ArkUI_NativeNodeAPI_1 *api);
    static void SetupPickerOptions(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle picker);
    static void ConfigurePickerProperties(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle picker);
    static void SetupPickerEvents(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle picker);
    static void SetupPickerIndicator(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle picker);
    static void OnPickerEventCallback(ArkUI_NodeEvent *event);
};

#endif // NATIVE_TYPE_SAMPLE_CONTAINER_PICKER_MAKER_H