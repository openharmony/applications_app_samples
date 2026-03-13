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

#ifndef NDKINPUTEVENT_FUNCTION_H
#define NDKINPUTEVENT_FUNCTION_H

#include "container.h"
#include "infos.h"
#include <arkui/native_key_event.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <hilog/log.h>

#define DEFAULT_BG_LENGTH 233
#define DEFAULT_BG_BORDER_WIDTH 2

namespace NativeXComponentSample {
void FirstModule(ArkUI_NodeHandle &root)
{
    row1 = nodeAPI->createNode(ARKUI_NODE_ROW);
    SetId(row1, "bgRow");
    nodeAPI->addChild(column1, row1);

    stack1 = nodeAPI->createNode(ARKUI_NODE_STACK);
    SetId(stack1, "bgStack");
    nodeAPI->addChild(row1, stack1);

    text1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetId(stack1, "bgText");
    SetWidth(text1, DEFAULT_BG_LENGTH);
    SetHeight(text1, DEFAULT_BG_LENGTH);
    SetBorderWidth(text1, DEFAULT_BG_BORDER_WIDTH);
    SetBorderRadius(text1);
    SetFocusable(text1);
    SetFocusOnTouch(text1);
    SetDefaultFocus(text1);
    SetTextFontSize(text1);
    SetBackgroundColor(text1, 0xFF262626);
    SetText(text1, "CrownEvent\n\n");
    nodeAPI->addChild(stack1, text1);
    nodeAPI->registerNodeEvent(text1, NODE_ON_DIGITAL_CROWN, 1, &text1);

    nodeAPI->addNodeEventReceiver(text1, [](ArkUI_NodeEvent *event) {
        auto *inputEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
        auto eventType = OH_ArkUI_UIInputEvent_GetType(inputEvent);
        if (OH_ArkUI_NodeEvent_GetEventType(event) == NODE_ON_DIGITAL_CROWN) {
            g_ss.str("");
            g_ss << "CrownEvent\n\n"
                 << "timestamp: " << OH_ArkUI_DigitalCrownEvent_GetEventTime(inputEvent)
                 << ", angularVelocity: " << OH_ArkUI_DigitalCrownEvent_GetAngularVelocity(inputEvent)
                 << ", degree: " << OH_ArkUI_DigitalCrownEvent_GetDegree(inputEvent)
                 << ", action: " << OH_ArkUI_DigitalCrownEvent_GetAction(inputEvent) << std::endl;
            SetText(text1, g_ss.str().c_str());
        } else if (eventType == ARKUI_UIINPUTEVENT_TYPE_UNKNOWN) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest", "UNKNOWN UIINPUTEVENT!");
        }
    });
    nodeAPI->addChild(root, row1);
}

} // namespace NativeXComponentSample

#endif // NDKINPUTEVENT_FUNCTION_H