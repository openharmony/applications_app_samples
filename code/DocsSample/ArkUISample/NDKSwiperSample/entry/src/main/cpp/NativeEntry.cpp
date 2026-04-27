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

#include "NativeEntry.h"
#include <arkui/native_interface.h>
#include <hilog/log.h>

namespace NativeModule {
const int ITEM_SIZE = 5;
const float SWIPER_WIDTH_PERCENT = 0.8f;  // 宽度
const float SWIPER_HEIGHT_PERCENT = 0.3f; // 高度
const float TEXT_FONT_SIZE = 30.0f;       // 字体大小
const float PREV_AND_NEXT_MARGIN = 20.0f;
const float ITEM_SPACE = 5.0f;
const uint32_t TEXT_BG_COLOR = 0xFF3D9DB4;            // 蓝色
const uint32_t INDICATOR_COLOR_SELECTED = 0xFFA10A21; // 红色

const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

napi_value NativeEntry::CreateSwiperNode(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取NodeContent
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    NativeEntry::GetInstance()->SetContentHandle(contentHandle);
    // [Start swiper_create]
    ArkUI_NativeNodeAPI_1 *nodeApi = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeApi);
    ArkUI_NodeHandle swiper = nodeApi->createNode(ARKUI_NODE_SWIPER);
    AddChild(swiper, nodeApi);
    // [End swiper_create]
    UpdateSwiperAttribute(swiper, nodeApi);
    UpdateIndicatorAttribute(swiper, nodeApi);
    AddEventReceiver(swiper, nodeApi);

    NativeEntry::GetInstance()->SetRootNode(swiper);
    return nullptr;
}

void NativeEntry::UpdateSwiperAttribute(ArkUI_NodeHandle swiper, ArkUI_NativeNodeAPI_1 *nodeApi)
{
    // [Start swiper_attribute]
    // 设置常用属性
    ArkUI_NumberValue value[] = {0};
    ArkUI_AttributeItem item = {.value = value, .size = 1};
    value[0].f32 = SWIPER_HEIGHT_PERCENT;
    nodeApi->setAttribute(swiper, NODE_HEIGHT_PERCENT, &item);
    value[0].f32 = SWIPER_WIDTH_PERCENT;
    nodeApi->setAttribute(swiper, NODE_WIDTH_PERCENT, &item);

    value[0].f32 = PREV_AND_NEXT_MARGIN;
    nodeApi->setAttribute(swiper, NODE_SWIPER_PREV_MARGIN, &item);
    nodeApi->setAttribute(swiper, NODE_SWIPER_NEXT_MARGIN, &item);
    value[0].f32 = ITEM_SPACE;
    nodeApi->setAttribute(swiper, NODE_SWIPER_ITEM_SPACE, &item);
    value[0].i32 = 1;
    nodeApi->setAttribute(swiper, NODE_SWIPER_AUTO_PLAY, &item);
    // [End swiper_attribute]
}

void NativeEntry::UpdateIndicatorAttribute(ArkUI_NodeHandle swiper, ArkUI_NativeNodeAPI_1 *nodeApi)
{
    // [Start indicator_attribute]
    // 设置导航导航指示器属性
    ArkUI_SwiperIndicator *swiperIndicatorStyle = OH_ArkUI_SwiperIndicator_Create(ARKUI_SWIPER_INDICATOR_TYPE_DOT);
    OH_ArkUI_SwiperIndicator_SetEndPosition(swiperIndicatorStyle, 0);
    OH_ArkUI_SwiperIndicator_SetSelectedColor(swiperIndicatorStyle, INDICATOR_COLOR_SELECTED);

    ArkUI_NumberValue value[] = {0};
    ArkUI_AttributeItem item = {.value = value, .size = 1, .object = swiperIndicatorStyle};
    value[0].i32 = ARKUI_SWIPER_INDICATOR_TYPE_DOT;
    nodeApi->setAttribute(swiper, NODE_SWIPER_INDICATOR, &item);

    OH_ArkUI_SwiperIndicator_Dispose(swiperIndicatorStyle);
    // [End indicator_attribute]
}

void NativeEntry::AddEventReceiver(ArkUI_NodeHandle swiper, ArkUI_NativeNodeAPI_1 *nodeApi)
{
    // [Start swiper_event]
    // 注册翻页事件监听
    nodeApi->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_CHANGE, 0, nullptr);
    nodeApi->registerNodeEvent(swiper, NODE_SWIPER_EVENT_ON_ANIMATION_START, 1, nullptr);
    nodeApi->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        ArkUI_NodeEventType eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        if (eventType == NODE_SWIPER_EVENT_ON_CHANGE) {
            auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            if (componentEvent) {
                auto index = componentEvent->data[0].i32;
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NDKSwiper",
                             "NODE_SWIPER_EVENT_ON_CHANGE index = %{public}d", index);
            }
        }
        if (eventType == NODE_SWIPER_EVENT_ON_ANIMATION_START) {
            auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            if (componentEvent) {
                auto currentIndex = componentEvent->data[0].i32;
                auto targetIndex = componentEvent->data[1].i32;
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NDKSwiper",
                             "NODE_SWIPER_EVENT_ON_ANIMATION_START currentIndex = %{public}d, targetIndex = %{public}d",
                             currentIndex, targetIndex);
            }
        }
    });
    // [End swiper_event]
}

void NativeEntry::AddChild(ArkUI_NodeHandle swiper, ArkUI_NativeNodeAPI_1 *nodeApi)
{
    // 设置swiper子节点为5个文本
    const char *arr[ITEM_SIZE] = {"0", "1", "2", "3", "4"};
    for (int i = 0; i < ITEM_SIZE; i++) {
        ArkUI_NodeHandle textNode = nodeApi->createNode(ARKUI_NODE_TEXT);
        ArkUI_AttributeItem content = {.string = arr[i]};
        nodeApi->setAttribute(textNode, NODE_TEXT_CONTENT, &content);

        ArkUI_NumberValue value[] = {0};
        ArkUI_AttributeItem item = {.value = value, .size = 1};
        value[0].u32 = TEXT_BG_COLOR;
        nodeApi->setAttribute(textNode, NODE_BACKGROUND_COLOR, &item);
        value[0].i32 = ARKUI_TEXT_ALIGNMENT_CENTER;
        nodeApi->setAttribute(textNode, NODE_TEXT_ALIGN, &item);
        value[0].f32 = TEXT_FONT_SIZE;
        nodeApi->setAttribute(textNode, NODE_FONT_SIZE, &item);
        nodeApi->addChild(swiper, textNode);
    }
}

} // namespace NativeModule