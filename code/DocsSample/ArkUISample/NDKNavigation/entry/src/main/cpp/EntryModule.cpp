/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#include "EntryModule.h"
#include "arkui/native_node_napi.h"
#include "hilog/log.h"
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

namespace NativeModule {
constexpr int NUM_250 = 250;
constexpr int NUM_300 = 300;
constexpr int NUM_100 = 100;
constexpr int NUM_50 = 50;
constexpr int NUM_10 =  10;
constexpr int NUM_9 = 9;
constexpr int NUM_8 = 8;
void NativeEntry::SetWidth(ArkUI_NodeHandle node, float width)
{
    ArkUI_NumberValue width_value[] = {{.f32 = width}};
    ArkUI_AttributeItem width_item = {width_value, sizeof(width_value) / sizeof(ArkUI_NumberValue)};
    arkUINativeNode_->setAttribute(node, NODE_WIDTH, &width_item);
}

void NativeEntry::SetHeight(ArkUI_NodeHandle handle, float height)
{
    ArkUI_NumberValue height_value[] = {{.f32 = height}};
    ArkUI_AttributeItem height_item = {height_value, sizeof(height_value) / sizeof(ArkUI_NumberValue)};
    arkUINativeNode_->setAttribute(handle, NODE_HEIGHT, &height_item);
}

void NativeEntry::SetColor(ArkUI_NodeHandle handle, uint32_t color)
{
    ArkUI_NumberValue color_value[] = {{.u32 = color}};
    ArkUI_AttributeItem color_item = {color_value, sizeof(color_value) / sizeof(ArkUI_NumberValue)};
    arkUINativeNode_->setAttribute(handle, NODE_BACKGROUND_COLOR, &color_item);
}

ArkUI_NodeHandle NativeEntry::AddButton(ArkUI_NodeHandle node, const std::string& content)
{
    ArkUI_NodeHandle button = arkUINativeNode_->createNode(ARKUI_NODE_BUTTON);
    arkUINativeNode_->addChild(node, button);
    SetWidth(button, NUM_250);
    SetHeight(button, NUM_50);
    ArkUI_AttributeItem item = {.string = content.c_str()};
    arkUINativeNode_->setAttribute(button, NODE_BUTTON_LABEL, &item);
    arkUINativeNode_->registerNodeEvent(button, NODE_ON_CLICK, NUM_10, nullptr);
    return button;
}

void NativeModule::NativeEntry::InitNavDestinationState(ArkUI_NodeHandle handle)
{
    ArkUI_AttributeItem idItem = {.string = "navDestinationState"};
    arkUINativeNode_->setAttribute(handle, NODE_ID, &idItem);
    arkUINativeNode_->addNodeEventReceiver(handle, [](ArkUI_NodeEvent *event) {
        if (OH_ArkUI_NodeEvent_GetTargetId(event) != NUM_10) {
            return;
        }
        ArkUI_NodeHandle targetNode = nullptr;
        OH_ArkUI_NodeUtils_GetAttachedNodeHandleById("navDestinationState", &targetNode);
        auto entry = NativeEntry::GetInstance();
        entry->ReportError(targetNode, "event clicked");
        ArkUI_NavDestinationState state;
        OH_ArkUI_GetNavDestinationState(targetNode, &state);
        if (state == NUM_8) {
            entry->SetColor(targetNode, 0x80808080);
        } else if (state == NUM_9) {
            entry->SetColor(targetNode, 0xFF000000);
        }
    });
}

void NativeEntry::ReportError(ArkUI_NodeHandle handle, const std::string &info)
{
    char navigationId[NUM_50];
    int32_t bufferLen = 0;
    OH_ArkUI_GetNavigationId(handle, navigationId, NUM_50, &bufferLen);
    
    char name[NUM_50];
    int32_t nameLen = OH_ArkUI_GetNavDestinationName(handle, name, NUM_50, &nameLen);
    
    int32_t index = -1;
    OH_ArkUI_GetNavDestinationIndex(handle, &index);
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "NAPI",
                 "navigation id: %{public}s, name: %{public}s, index: %{public}d, error: %{public}s",
                 navigationId, name, index, info.c_str());
}

void NativeModule::NativeEntry::InitPageIndex(ArkUI_NodeHandle handle)
{
    ArkUI_AttributeItem idItem = {.string = "pageIndex"};
    arkUINativeNode_->setAttribute(handle, NODE_ID, &idItem);
    arkUINativeNode_->addNodeEventReceiver(handle, [](ArkUI_NodeEvent *event) {
        if (OH_ArkUI_NodeEvent_GetTargetId(event) != NUM_10) {
            return;
        }
        ArkUI_NodeHandle targetNode = nullptr;
        OH_ArkUI_NodeUtils_GetAttachedNodeHandleById("pageIndex", &targetNode);
        auto entry = NativeEntry::GetInstance();
        entry->ReportError(targetNode, "event clicked");
        int32_t index = -1;
        OH_ArkUI_GetRouterPageIndex(targetNode, &index);
        std::string content = "pageIndex: " + std::to_string(index);
        ArkUI_AttributeItem contentItem = {.string = content.c_str()};
        NativeEntry::GetInstance()->GetNativeNodeApi()->setAttribute(targetNode, NODE_BUTTON_LABEL, &contentItem);
    });
}

void NativeModule::NativeEntry::InitPageName(ArkUI_NodeHandle handle)
{
    ArkUI_AttributeItem idItem = {.string = "pageName"};
    arkUINativeNode_->setAttribute(handle, NODE_ID, &idItem);
    arkUINativeNode_->addNodeEventReceiver(handle, [](ArkUI_NodeEvent *event) {
        if (OH_ArkUI_NodeEvent_GetTargetId(event) != NUM_10) {
            return;
        }
        ArkUI_NodeHandle targetNode = nullptr;
        OH_ArkUI_NodeUtils_GetAttachedNodeHandleById("pageName", &targetNode);
        auto entry = NativeEntry::GetInstance();
        entry->ReportError(targetNode, "event clicked");
        char name[NUM_50];
        int32_t len;
        OH_ArkUI_GetRouterPageName(targetNode, name, NUM_50, &len);
        std::string content = "pageName: " + std::string(name);
        ArkUI_AttributeItem contentItem = {.string = content.c_str()};
        NativeEntry::GetInstance()->GetNativeNodeApi()->setAttribute(targetNode, NODE_BUTTON_LABEL, &contentItem);
    });
}
}