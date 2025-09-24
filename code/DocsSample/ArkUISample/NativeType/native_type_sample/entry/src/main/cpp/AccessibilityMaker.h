/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#ifndef NATIVE_TYPE_SAMPLE_ACCESSIBILITYMAKER_H
#define NATIVE_TYPE_SAMPLE_ACCESSIBILITYMAKER_H

#include <functional>
#include <arkui/native_node.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <unordered_map>
#include "manager.h"

class AccessibilityMaker {
public:
    AccessibilityMaker(){};
    ~AccessibilityMaker();

    static ArkUI_NodeHandle CreateNativeNode();
    static ArkUI_NodeHandle BuildTextNode(ArkUI_NativeNodeAPI_1* nodeApi, const char* content);
    static ArkUI_NodeHandle BuildTextNodeWithoutAccessibilityFocus(ArkUI_NativeNodeAPI_1* nodeApi, const char* content);

    static void CreateAccessibilityState();
    static void SetAccessibilityDisabled(bool isDisabled);
    static bool IsAccessibilityDisabled();
    static void SetAccessibilitySelected(bool isSelected);
    static bool IsAccessibilitySelected();
    static void SetAccessibilityCheckedState(int32_t checkedState);
    static int32_t GetAccessibilityCheckedState();
    static void DisposeAccessibilityState();
    static ArkUI_NodeHandle BuildColumnNode(ArkUI_NativeNodeAPI_1* nodeApi);
    static void CreateAccessibilityValue();
    static void DisposeAccessibilityValue();
    static void SetAccessibilityValueMin(int32_t min);
    static int32_t GetAccessibilityValueMin();
    static void SetAccessibilityValueMax(int32_t max);
    static int32_t GetAccessibilityValueMax();
    static void SetAccessibilityValueCurrent(int32_t current);
    static int32_t GetAccessibilityValueCurrent();
    static void SetAccessibilityValueText(const char* text);
    static const char* GetAccessibilityValueText();
    static void SetAccessibilityRangeMin(int32_t rangeMin);
    static int32_t GetAccessibilityRangeMin();
    static void SetAccessibilityRangeMax(int32_t rangeMax);
    static int32_t GetAccessibilityRangeMax();
    static void SetAccessibilityRangeCurrent(int32_t rangeCurrent);
    static int32_t GetAccessibilityRangeCurrent();
    static void SetNodeId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const char* id);
    static const char* GetNodeId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static void SetAccessibilityGroup(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, bool isGroup);
    static bool GetAccessibilityGroup(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static void SetAccessibilityMode(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node,
        ArkUI_AccessibilityMode mode);
    static ArkUI_AccessibilityMode GetAccessibilityMode(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static void SetAccessibilityText(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const char* text);
    static const char* GetAccessibilityText(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static void SetAccessibilityDescription(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node,
        const char* description);
    static const char* GetAccessibilityDescription(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static int GetAccessibilityId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static void SetAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static uint32_t GetAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static void SetAccessibilityRole(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const uint32_t role);
    static uint32_t GetAccessibilityRole(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static void GetUniqueId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static void CreateAccessibilityCheckedSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilitySelectedSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilityValueSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilityNodeIdSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilityGroupSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilityModeSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilityTextSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilityDescriptionSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilityIdSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilityActionsSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateAccessibilityRoleSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void CreateUniqueIdSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent);
    static void OnErrorCallback(int32_t code, const char* name, const char* message);
    static void OnTerminatedCallback(int32_t code, AbilityBase_Want* want);
};

#endif // NATIVE_TYPE_SAMPLE_ACCESSIBILITYMAKER_H
