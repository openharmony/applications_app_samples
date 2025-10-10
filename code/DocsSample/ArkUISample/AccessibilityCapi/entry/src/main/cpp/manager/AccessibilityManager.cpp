/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <arkui/native_interface_accessibility.h>
#include <string>
#include "common/common.h"
#include "fakenode/fake_node.h"
#include "AccessibilityManager.h"

const char *DEFAULT_ID = "XComponentIdSingle";

const char *LOG_PRINT_TEXT = "AccessibilityManager";
namespace NativeXComponentSample {

const int32_t NUMBER_ZERO = 0;
const int32_t NUMBER_FIRST = 100;
const int32_t NUMBER_SECOND = 500;
const int32_t NUMBER_THIRD = 800;

void FillEvent(ArkUI_AccessibilityEventInfo *eventInfo, ArkUI_AccessibilityElementInfo *elementInfo,
               ArkUI_AccessibilityEventType eventType, std::string announcedText)
{
    if (eventInfo == nullptr) {
        return;
    }
    if (elementInfo == nullptr) {
        return;
    }
    OH_ArkUI_AccessibilityEventSetEventType(eventInfo, eventType);

    OH_ArkUI_AccessibilityEventSetElementInfo(eventInfo, elementInfo);
    
    if (eventType == ARKUI_ACCESSIBILITY_NATIVE_EVENT_TYPE_ANNOUNCE_FOR_ACCESSIBILITY && announcedText.size() > 0) {
        OH_ArkUI_AccessibilityEventSetTextAnnouncedForAccessibility(eventInfo, announcedText.data());
    }
}


ArkUI_AccessibilityProvider *g_provider = nullptr;

void AccessibilityManager::SendAccessibilityAsyncEvent(ArkUI_AccessibilityElementInfo *elementInfo,
                                                       ArkUI_AccessibilityEventType eventType,
                                                       std::string announcedText)
{
    auto eventInfo = OH_ArkUI_CreateAccessibilityEventInfo();
    // 1.填写event内容
    FillEvent(eventInfo, elementInfo, eventType, announcedText);
    // 2.callback
    auto callback = [](int32_t errorCode) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT, "result: %{public}d", errorCode);
    };
    // 3. 调用接口发送事件给OH侧
    OH_ArkUI_SendAccessibilityAsyncEvent(g_provider, eventInfo, callback);
}

AccessibilityManager::AccessibilityManager()
{
//    多实例场景
    accessibilityProviderCallbacksWithInstance_.findAccessibilityNodeInfosById = FindAccessibilityNodeInfosById;
    accessibilityProviderCallbacksWithInstance_.findAccessibilityNodeInfosByText = FindAccessibilityNodeInfosByText;
    accessibilityProviderCallbacksWithInstance_.findFocusedAccessibilityNode = FindFocusedAccessibilityNode;
    accessibilityProviderCallbacksWithInstance_.findNextFocusAccessibilityNode = FindNextFocusAccessibilityNode;
    accessibilityProviderCallbacksWithInstance_.executeAccessibilityAction = ExecuteAccessibilityAction;
    accessibilityProviderCallbacksWithInstance_.clearFocusedFocusAccessibilityNode = ClearFocusedFocusAccessibilityNode;
    accessibilityProviderCallbacksWithInstance_.getAccessibilityNodeCursorPosition = GetAccessibilityNodeCursorPosition;
//    单实例场景
    accessibilityProviderCallbacks_.findAccessibilityNodeInfosById = FindAccessibilityNodeInfosById;
    accessibilityProviderCallbacks_.findAccessibilityNodeInfosByText = FindAccessibilityNodeInfosByText;
    accessibilityProviderCallbacks_.findFocusedAccessibilityNode = FindFocusedAccessibilityNode;
    accessibilityProviderCallbacks_.findNextFocusAccessibilityNode = FindNextFocusAccessibilityNode;
    accessibilityProviderCallbacks_.executeAccessibilityAction = ExecuteAccessibilityAction;
    accessibilityProviderCallbacks_.clearFocusedFocusAccessibilityNode = ClearFocusedFocusAccessibilityNode;
    accessibilityProviderCallbacks_.getAccessibilityNodeCursorPosition = GetAccessibilityNodeCursorPosition;
}

void AccessibilityManager::Initialize(const std::string &id, OH_NativeXComponent *nativeXComponent)
{
    int32_t ret = OH_NativeXComponent_GetNativeAccessibilityProvider(nativeXComponent, &provider);
    if (provider == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT, "get provider is null");
        return;
    }
    // 2.注册回调函数
    ret = OH_ArkUI_AccessibilityProviderRegisterCallbackWithInstance(id.c_str(), provider,
        &accessibilityProviderCallbacksWithInstance_);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                     "InterfaceDesignTest OH_ArkUI_AccessibilityProviderRegisterCallback failed");
        return;
    }
    g_provider = provider;
}

int32_t AccessibilityManager::FindAccessibilityNodeInfosById(const char* instanceId, int64_t elementId,
    ArkUI_AccessibilitySearchMode mode, int32_t requestId, ArkUI_AccessibilityElementInfoList *elementList)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                 "FindAccessibilityNodeInfosById start,instanceId %{public}s elementId: %{public}ld, "
                 "requestId: %{public}d, mode: %{public}d", instanceId,
                 elementId, requestId, static_cast<int32_t>(mode));
    if (elementList == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                     "FindAccessibilityNodeInfosById elementList is null");
        return OH_NATIVEXCOMPONENT_RESULT_FAILED;
    }
    int ret = 0;
    const int parentOfRoot = -2100000;
    if (elementId == -1) {
        elementId = 0;
    }
    
    if (mode == ARKUI_ACCESSIBILITY_NATIVE_SEARCH_MODE_PREFETCH_RECURSIVE_CHILDREN) {
        // arkUi框架设计的特殊值，根节点必须设置parentId为这个值

        // fill some fake nodes
        auto rootNode = OH_ArkUI_AddAndGetAccessibilityElementInfo(elementList);
        if (!rootNode) {
            return OH_NATIVEXCOMPONENT_RESULT_FAILED;
        }
        OH_ArkUI_AccessibilityElementInfoSetElementId(rootNode, 0);
        OH_ArkUI_AccessibilityElementInfoSetParentId(rootNode, parentOfRoot);
        FakeWidget::Instance().fillAccessibilityElement(rootNode);

        ArkUI_AccessibleRect rect;
        rect.leftTopX = NUMBER_ZERO;
        rect.leftTopY = NUMBER_ZERO;
        rect.rightBottomX = NUMBER_THIRD;
        rect.rightBottomY = NUMBER_THIRD;
        ret = OH_ArkUI_AccessibilityElementInfoSetScreenRect(rootNode, &rect);
        OH_ArkUI_AccessibilityElementInfoSetAccessibilityLevel(rootNode, "no");
        auto objects = FakeWidget::Instance().GetAllObjects(instanceId);
        int64_t childNodes[1024];
        for (int i = 0; i < objects.size(); i++) {
            int elementId = i + 1;

            childNodes[i] = elementId;
        }
        for (int i = 0; i < objects.size(); i++) {
            int elementId = i + 1;
            childNodes[i] = elementId;
            auto child = OH_ArkUI_AddAndGetAccessibilityElementInfo(elementList);
            OH_ArkUI_AccessibilityElementInfoSetElementId(child, elementId);
            OH_ArkUI_AccessibilityElementInfoSetParentId(child, 0);
            OH_ArkUI_AccessibilityElementInfoSetAccessibilityLevel(child, "yes");
            objects[i]->fillAccessibilityElement(child);

            ArkUI_AccessibleRect rect;
            rect.leftTopX = i * NUMBER_FIRST;
            rect.leftTopY = NUMBER_FIRST;
            rect.rightBottomX = i * NUMBER_FIRST + NUMBER_FIRST;
            rect.rightBottomY = NUMBER_SECOND;
            OH_ArkUI_AccessibilityElementInfoSetScreenRect(child, &rect);
            if (objects[i]->ObjectType() == "FakeSlider") {
                auto rangeInfo = objects[i]->GetRangeInfo();
                OH_ArkUI_AccessibilityElementInfoSetRangeInfo(child, &rangeInfo);
            }
            if (objects[i]->ObjectType() == "FakeList") {
                auto gridInfo = objects[i]->GetGridInfo();
                OH_ArkUI_AccessibilityElementInfoSetGridInfo(child, &gridInfo);
            }
            if (objects[i]->ObjectType() == "FakeSwiper") {
                auto gridItemInfo = objects[i]->GetGridItemInfo();
                OH_ArkUI_AccessibilityElementInfoSetGridItemInfo(child, &gridItemInfo);
            }
        }

        ret = OH_ArkUI_AccessibilityElementInfoSetChildNodeIds(rootNode, objects.size(), childNodes);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                     "FindAccessibilityNodeInfosById child count: %{public}ld %{public}d",
                     objects.size(), ret);
    } else if (mode == ARKUI_ACCESSIBILITY_NATIVE_SEARCH_MODE_PREFETCH_CURRENT) {
        auto &widget = FakeWidget::Instance();
        AccessibleObject *obj = nullptr;
        if (elementId == 0) {
            obj = &widget;
        } else {
            obj = widget.GetChild(elementId);
        }
        if (!obj) {
            return OH_NATIVEXCOMPONENT_RESULT_FAILED;
        }
        auto node = OH_ArkUI_AddAndGetAccessibilityElementInfo(elementList);
        OH_ArkUI_AccessibilityElementInfoSetElementId(node, elementId);
        OH_ArkUI_AccessibilityElementInfoSetParentId(node, elementId == 0 ? parentOfRoot : 0);
        OH_ArkUI_AccessibilityElementInfoSetAccessibilityLevel(node, elementId == 0 ?  "no" : "yes");
        obj->fillAccessibilityElement(node);
        ArkUI_AccessibleRect rect;
        if (elementId == 0) {
            rect.leftTopX = NUMBER_ZERO;
            rect.leftTopY = NUMBER_ZERO;
            rect.rightBottomX = NUMBER_THIRD;
            rect.rightBottomY = NUMBER_THIRD;
        } else {
            int i = elementId - 1;
            rect.leftTopX = i * NUMBER_FIRST;
            rect.leftTopY = NUMBER_FIRST;
            rect.rightBottomX = i * NUMBER_FIRST + NUMBER_FIRST;
            rect.rightBottomY = NUMBER_SECOND;
        }

        OH_ArkUI_AccessibilityElementInfoSetScreenRect(node, &rect);
        if (elementId == 0) {
            auto objects = FakeWidget::Instance().GetAllObjects(instanceId);
            int64_t childNodes[1024];

            for (int i = 0; i < objects.size(); i++) {
                int elementId = i + 1;

                childNodes[i] = elementId;
                auto child = OH_ArkUI_AddAndGetAccessibilityElementInfo(elementList);
                OH_ArkUI_AccessibilityElementInfoSetElementId(child, elementId);
                OH_ArkUI_AccessibilityElementInfoSetParentId(child, 0);

                objects[i]->fillAccessibilityElement(child);

                ArkUI_AccessibleRect rect;
                rect.leftTopX = i * NUMBER_FIRST;
                rect.leftTopY = NUMBER_ZERO;
                rect.rightBottomX = i * NUMBER_FIRST + NUMBER_FIRST;
                rect.rightBottomY = NUMBER_SECOND;
                OH_ArkUI_AccessibilityElementInfoSetScreenRect(child, &rect);
            }
            ret = OH_ArkUI_AccessibilityElementInfoSetChildNodeIds(node, objects.size(), childNodes);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                         "FindAccessibilityNodeInfosById child2 count: %{public}ld", objects.size());
        }
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT, "FindAccessibilityNodeInfosById end");
    return OH_NATIVEXCOMPONENT_RESULT_SUCCESS;
}

int32_t AccessibilityManager::FindAccessibilityNodeInfosByText(const char* instanceId, int64_t elementId,
    const char *text, int32_t requestId, ArkUI_AccessibilityElementInfoList *elementList)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                 "FindAccessibilityNodeInfosByText start,instanceId %{public}s elementId: %{public}ld, "
                 "requestId: %{public}d, text: %{public}s.", instanceId,
                 elementId, requestId, text);
    return OH_NATIVEXCOMPONENT_RESULT_SUCCESS;
}

int32_t AccessibilityManager::FindFocusedAccessibilityNode(const char* instanceId, int64_t elementId,
    ArkUI_AccessibilityFocusType focusType, int32_t requestId, ArkUI_AccessibilityElementInfo *elementInfo)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                 "FindFocusedAccessibilityNode start instanceId %{public}s, "
                 "elementId: %{public}ld, requestId: %{public}d, focusType: %{public}d",
                 instanceId, elementId, requestId, static_cast<int32_t>(focusType));
    return OH_NATIVEXCOMPONENT_RESULT_SUCCESS;
}

int32_t AccessibilityManager::FindNextFocusAccessibilityNode(const char* instanceId, int64_t elementId,
    ArkUI_AccessibilityFocusMoveDirection direction, int32_t requestId,
    ArkUI_AccessibilityElementInfo *elementInfo)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                 "FindNextFocusAccessibilityNode instanceId %{public}s "
                 "elementId: %{public}ld, requestId: %{public}d, direction: %{public}d",
                 instanceId, elementId, requestId, static_cast<int32_t>(direction));
    auto objects = FakeWidget::Instance().GetAllObjects(instanceId);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT, "objects.size() %{public}d", objects.size());
    // object.size 不包含 root节点
    if ((elementId < 0) || (elementId > objects.size())) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT, "elementId invalid");
        return OH_NATIVEXCOMPONENT_RESULT_FAILED;
    }
    int64_t nextElementId = -1;
    if (direction == ARKUI_ACCESSIBILITY_NATIVE_DIRECTION_FORWARD) {
        nextElementId = elementId + 1;
    } else {
        nextElementId = elementId - 1;
    }
    
    // 屏幕朗读约束 如果是根节点 然后backward的话需要回到最后一个节点
    if ((nextElementId == -1) && (direction == ARKUI_ACCESSIBILITY_NATIVE_DIRECTION_BACKWARD)) {
        nextElementId = objects.size();
    }
    
    if (nextElementId >  objects.size()) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT, "nextElementId invalid");
        return OH_NATIVEXCOMPONENT_RESULT_FAILED;
    }
    
    if (nextElementId <=  0) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT, "nextElementId less than zero");
        return OH_NATIVEXCOMPONENT_RESULT_FAILED;
    }
    OH_ArkUI_AccessibilityElementInfoSetElementId(elementInfo, nextElementId);
    OH_ArkUI_AccessibilityElementInfoSetParentId(elementInfo, 0);
    // id 比object索引大1
    objects[nextElementId - 1]->fillAccessibilityElement(elementInfo);
    ArkUI_AccessibleRect rect;
    rect.leftTopX = nextElementId * NUMBER_FIRST;
    rect.leftTopY = NUMBER_ZERO;
    rect.rightBottomX = nextElementId * NUMBER_FIRST + NUMBER_FIRST;
    rect.rightBottomY = NUMBER_SECOND;
    OH_ArkUI_AccessibilityElementInfoSetScreenRect(elementInfo, &rect);
    auto eventInfo = OH_ArkUI_CreateAccessibilityEventInfo();
    OH_ArkUI_AccessibilityEventSetRequestFocusId(eventInfo, requestId);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT, "%{public}ld", nextElementId);
    return OH_NATIVEXCOMPONENT_RESULT_SUCCESS;
}

int32_t AccessibilityManager::ExecuteAccessibilityAction(const char* instanceId, int64_t elementId,
    ArkUI_Accessibility_ActionType action, ArkUI_AccessibilityActionArguments *actionArguments, int32_t requestId)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                 "ExecuteAccessibilityAction instanceId %{public}s elementId: %{public}ld, "
                 "action: %{public}d, requestId: %{public}d",
                 instanceId, elementId, action, requestId);
    auto object = FakeWidget::Instance().GetChild(elementId);
    if (!object) {
        return 0;
    }
    auto announcedText = object->GetAnnouncedForAccessibility();
    auto element = OH_ArkUI_CreateAccessibilityElementInfo();
    OH_ArkUI_AccessibilityElementInfoSetElementId(element, elementId);
    const char *actionKey = "some_key";
    char *actionValue = nullptr;
    OH_ArkUI_FindAccessibilityActionArgumentByKey(actionArguments, actionKey, &actionValue);
    switch (action) {
        case ARKUI_ACCESSIBILITY_NATIVE_ACTION_TYPE_CLICK:
            if (object) {
                object->OnClick();
                object->fillAccessibilityElement(element);
            }
            AccessibilityManager::SendAccessibilityAsyncEvent(element,
                ARKUI_ACCESSIBILITY_NATIVE_EVENT_TYPE_CLICKED, announcedText);
            break;
        case ARKUI_ACCESSIBILITY_NATIVE_ACTION_TYPE_GAIN_ACCESSIBILITY_FOCUS:
            if (object) {
                object->SetFocus(true);

                object->fillAccessibilityElement(element);
            }

            AccessibilityManager::SendAccessibilityAsyncEvent(element,
                ARKUI_ACCESSIBILITY_NATIVE_EVENT_TYPE_ACCESSIBILITY_FOCUSED,
                announcedText);
            break;
        case ARKUI_ACCESSIBILITY_NATIVE_ACTION_TYPE_CLEAR_ACCESSIBILITY_FOCUS:
            if (object) {
                object->SetFocus(false);
                object->fillAccessibilityElement(element);
            }
            AccessibilityManager::SendAccessibilityAsyncEvent(
                element, ARKUI_ACCESSIBILITY_NATIVE_EVENT_TYPE_ACCESSIBILITY_FOCUS_CLEARED,
                announcedText);
            break;
        default:
            // Optionally handle unknown actions or do nothing
            break;
    }
    OH_ArkUI_DestoryAccessibilityElementInfo(element);
    return OH_NATIVEXCOMPONENT_RESULT_SUCCESS;
}

int32_t AccessibilityManager::ClearFocusedFocusAccessibilityNode(const char* instanceId)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                 "ClearFocusedFocusAccessibilityNode, instanceId %{public}s", instanceId);
    return OH_NATIVEXCOMPONENT_RESULT_SUCCESS;
}

int32_t AccessibilityManager::GetAccessibilityNodeCursorPosition(const char* instanceId, int64_t elementId,
    int32_t requestId, int32_t *index)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                 "GetAccessibilityNodeCursorPosition, instanceId %{public}s "
                 "elementId: %{public}ld, requestId: %{public}d, index: %{public}d",
                 instanceId, elementId, requestId, index);
    return OH_NATIVEXCOMPONENT_RESULT_SUCCESS;
}

void AccessibilityManager::Initialize(OH_NativeXComponent *nativeXComponent)
{
    int32_t ret = OH_NativeXComponent_GetNativeAccessibilityProvider(nativeXComponent, &provider);
    if (provider == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT, "get provider is null");
        return;
    }
    // 2.注册回调函数
    ret = OH_ArkUI_AccessibilityProviderRegisterCallback(provider, &accessibilityProviderCallbacks_);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, LOG_PRINT_TEXT,
                     "InterfaceDesignTest OH_ArkUI_AccessibilityProviderRegisterCallback failed");
        return;
    }
    g_provider = provider;
}

int32_t AccessibilityManager::FindAccessibilityNodeInfosById(int64_t elementId, ArkUI_AccessibilitySearchMode mode,
    int32_t requestId, ArkUI_AccessibilityElementInfoList* elementList)
{
    return FindAccessibilityNodeInfosById(DEFAULT_ID, elementId, mode, requestId, elementList);
}
    
int32_t AccessibilityManager::FindAccessibilityNodeInfosByText(int64_t elementId, const char* text, int32_t requestId,
    ArkUI_AccessibilityElementInfoList* elementList)
{
    return FindAccessibilityNodeInfosByText(DEFAULT_ID, elementId, text, requestId, elementList);
}

int32_t AccessibilityManager::FindFocusedAccessibilityNode(int64_t elementId, ArkUI_AccessibilityFocusType focusType,
    int32_t requestId, ArkUI_AccessibilityElementInfo* elementInfo)
{
    return FindFocusedAccessibilityNode(DEFAULT_ID, elementId, focusType, requestId, elementInfo);
}

int32_t AccessibilityManager::FindNextFocusAccessibilityNode(int64_t elementId,
    ArkUI_AccessibilityFocusMoveDirection direction, int32_t requestId, ArkUI_AccessibilityElementInfo* elementInfo)
{
    return FindNextFocusAccessibilityNode(DEFAULT_ID, elementId, direction, requestId, elementInfo);
}

int32_t AccessibilityManager::ExecuteAccessibilityAction(int64_t elementId, ArkUI_Accessibility_ActionType action,
    ArkUI_AccessibilityActionArguments *actionArguments, int32_t requestId)
{
    return ExecuteAccessibilityAction(DEFAULT_ID, elementId, action, actionArguments, requestId);
}

int32_t AccessibilityManager::ClearFocusedFocusAccessibilityNode()
{
    return ClearFocusedFocusAccessibilityNode(DEFAULT_ID);
}

int32_t AccessibilityManager::GetAccessibilityNodeCursorPosition(int64_t elementId, int32_t requestId, int32_t* index)
{
    return GetAccessibilityNodeCursorPosition(DEFAULT_ID, elementId, requestId, index);
}
}