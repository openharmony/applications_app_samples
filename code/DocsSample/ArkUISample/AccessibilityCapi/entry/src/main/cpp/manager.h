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

namespace NativeNode::Manager {
using EventCallback = std::function<void(ArkUI_NodeEvent*)>;

class NodeManager {
public:
    ~NodeManager();
    void BuildAccessibilitySection(NodeManager* self, ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle text);
    ArkUI_NodeHandle BuildEmbeddedComponentSection(NodeManager* self, ArkUI_NativeNodeAPI_1* nodeApi);
    void BuildTextSection(NodeManager* self, ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle text);
    static NodeManager& GetInstance();
    void SetXComponent(OH_NativeXComponent* xComponent);
    void CreateNativeNode();

    void CreateAccessibilityState();
    void SetAccessibilityDisabled(bool isDisabled);
    bool IsAccessibilityDisabled();
    void SetAccessibilitySelected(bool isSelected);
    bool IsAccessibilitySelected();
    void SetAccessibilityCheckedState(int32_t checkedState);
    int32_t GetAccessibilityCheckedState();
    void DisposeAccessibilityState();

    void CreateAccessibilityValue();
    void DisposeAccessibilityValue();
    void SetAccessibilityValueMin(int32_t min);
    int32_t GetAccessibilityValueMin();
    void SetAccessibilityValueMax(int32_t max);
    int32_t GetAccessibilityValueMax();
    void SetAccessibilityValueCurrent(int32_t current);
    int32_t GetAccessibilityValueCurrent();
    void SetAccessibilityValueText(const char* text);
    const char* GetAccessibilityValueText();
    void SetAccessibilityRangeMin(int32_t rangeMin);
    int32_t GetAccessibilityRangeMin();
    void SetAccessibilityRangeMax(int32_t rangeMax);
    int32_t GetAccessibilityRangeMax();
    void SetAccessibilityRangeCurrent(int32_t rangeCurrent);
    int32_t GetAccessibilityRangeCurrent();

    void CreateEmbeddedComponentOption();
    void DisposeEmbeddedComponentOption();
    void SetEmbeddedComponentOnError();
    void SetEmbeddedComponentOnTerminated();

    void SetNodeId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const char* id);
    const char* GetNodeId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    void SetAccessibilityGroup(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, bool isGroup);
    bool GetAccessibilityGroup(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    void SetAccessibilityMode(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, ArkUI_AccessibilityMode mode);
    ArkUI_AccessibilityMode GetAccessibilityMode(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    void SetAccessibilityText(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const char* text);
    const char* GetAccessibilityText(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    void SetAccessibilityDescription(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const char* description);
    const char* GetAccessibilityDescription(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    int GetAccessibilityId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    void SetAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    uint32_t GetAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    void SetAccessibilityRole(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const uint32_t role);
    uint32_t GetAccessibilityRole(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    void GetUniqueId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    void SetEmbeddedComponentWant(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    void SetOnAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);

private:
    NodeManager() = default;
    OH_NativeXComponent* xComponent_;
    std::unordered_map<int32_t, EventCallback> callbackMap_;
    ArkUI_AccessibilityState* accessibilityState_ = nullptr;
    ArkUI_AccessibilityValue* accessibilityValue_ = nullptr;
    ArkUI_EmbeddedComponentOption* embeddedComponentOption_ = nullptr;

    static void OnErrorCallback(int32_t code, const char* name, const char* message);
    static void OnTerminatedCallback(int32_t code, AbilityBase_Want* want);
};
}

#endif //CAPI_MANAGER_H
