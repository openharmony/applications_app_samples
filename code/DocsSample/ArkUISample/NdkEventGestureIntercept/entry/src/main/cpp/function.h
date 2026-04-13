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
#include <arkui/native_gesture.h>
#include <arkui/native_interface.h>
#include <arkui/native_key_event.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <hilog/log.h>

#define DEFAULT_BG_LENGTH 233
#define DEFAULT_BG_BORDER_WIDTH 2
#define NODE_ID 2
#define BUTTON_ID 14
#define DEFAULT_BUTTON_HEIGHT 0.25
#define DEFAULT_BUTTON_WIDTH 0.5

namespace NativeXComponentSample {
bool GestureRecognizerModule(ArkUI_GestureRecognizerHandleArray &array, int32_t &uniqueId, int32_t size,
                             ArkUI_GestureCollectInterceptInfo *info)
{
    for (auto i = 0; i < size; i++) {
        OH_ArkUI_GetGestureBindNodeUniqueId(array[i], &uniqueId);
        if (OH_ArkUI_GestureRecognizer_IsHostBelongsTo(array[i], uniqueId)) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkEventGestureIntercept]",
                         "NdkEventGestureIntercept_SampleLog, gestureRecognizer isHostBelongsTo");
        }
        if (uniqueId == BUTTON_ID) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkEventGestureIntercept]",
                         "NdkEventGestureIntercept_SampleLog, gestureRecognizer is from Button2");
            OH_ArkUI_GestureCollectInterceptInfo_SetGestureCollectIntervention(
                info, OH_ArkUI_GestureCollectIntervention::OH_ARKUI_GESTURE_COLLECT_INTERVENTION_DISCARD_SELF);
            return false;
        }
    }
    return true;
}
void TouchRecognizerModule(ArkUI_TouchRecognizerHandleArray &arrayTouch, int32_t size)
{
    for (auto i = 0; i < size; i++) {
        if (OH_ArkUI_TouchRecognizer_IsHostBelongsTo(arrayTouch[i], NODE_ID)) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkEventGestureIntercept]",
                         "NdkEventGestureIntercept_SampleLog, touchRecognizer isHostBelongsTo");
        } else {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkEventGestureIntercept]",
                         "NdkEventGestureIntercept_SampleLog, touchRecognizer not isHostBelongsTo");
        }
    }
}
void ThirdModule()
{
    // 判断是否支持创建手势
    auto gestureApi = reinterpret_cast<ArkUI_NativeGestureAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_GESTURE, "ArkUI_NativeGestureAPI_1"));
    if (gestureApi->createGroupGesture) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkEventGestureIntercept]",
                     "NdkEventGestureIntercept_SampleLog, createGroupGesture api exist");
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkEventGestureIntercept]",
                     "NdkEventGestureIntercept_SampleLog, createGroupGesture api not exist");
    }

    // 创建tap手势
    auto tapGesture = gestureApi->createTapGesture(1, true);
    // 给tap手势绑定回调
    auto onActionCallBackTapRow = [](ArkUI_GestureEvent *event, void *extraParam) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkEventGestureIntercept]",
                     "NdkEventGestureIntercept_SampleLog, Row2 tap");
    };
    auto tapGestureButton = gestureApi->createTapGesture(1, true);
    // 给tap手势绑定回调
    auto onActionCallBackTapButton = [](ArkUI_GestureEvent *event, void *extraParam) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkEventGestureIntercept]",
                     "NdkEventGestureIntercept_SampleLog, Button2 tap");
    };
    gestureApi->setGestureEventTarget(
        tapGesture, GESTURE_EVENT_ACTION_ACCEPT | GESTURE_EVENT_ACTION_UPDATE | GESTURE_EVENT_ACTION_CANCEL, row2,
        onActionCallBackTapRow);
    gestureApi->addGestureToNode(row2, tapGesture, PARALLEL, NORMAL_GESTURE_MASK);
    gestureApi->setGestureEventTarget(
        tapGestureButton, GESTURE_EVENT_ACTION_ACCEPT | GESTURE_EVENT_ACTION_UPDATE | GESTURE_EVENT_ACTION_CANCEL, row2,
        onActionCallBackTapButton);
    gestureApi->addGestureToNode(button2, tapGestureButton, PARALLEL, NORMAL_GESTURE_MASK);
}

void SecondModule()
{
    nodeAPI->registerNodeEvent(row2, NODE_ON_GESTURE_COLLECT_INTERCEPT, 1, &row2);
    nodeAPI->addNodeEventReceiver(row2, [](ArkUI_NodeEvent *event) {
        if (OH_ArkUI_NodeEvent_GetEventType(event) == NODE_ON_GESTURE_COLLECT_INTERCEPT) {
            ArkUI_GestureCollectInterceptInfo *info = nullptr;
            ArkUI_GestureRecognizerHandleArray array;
            ArkUI_TouchRecognizerHandleArray arrayTouch;
            int32_t size;
            info = OH_ArkUI_NodeEvent_GetGestureCollectInterceptInfo(event);
            OH_ArkUI_GestureCollectInterceptInfo_GetTouchRecognizers(info, &arrayTouch, &size);
            OH_ArkUI_GestureCollectInterceptInfo_GetResponseRecognizers(info, &array, &size);
            int32_t uniqueId = 0;
            if (!GestureRecognizerModule(array, uniqueId, size, info)) {
                return;
            }
            TouchRecognizerModule(arrayTouch, size);
            OH_ArkUI_GestureCollectInterceptInfo_SetGestureCollectIntervention(
                info, OH_ArkUI_GestureCollectIntervention::OH_ARKUI_GESTURE_COLLECT_INTERVENTION_CONTINUE);
        } else if (OH_ArkUI_NodeEvent_GetEventType(event) == NODE_TOUCH_EVENT) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkEventGestureIntercept]",
                         "NdkEventGestureIntercept_SampleLog, row2 NODE_TOUCH_EVENT NodeEvent");
        }
    });
}
void FirstModule(ArkUI_NodeHandle &root)
{
    row1 = nodeAPI->createNode(ARKUI_NODE_ROW);
    SetId(row1, "bgRow");
    nodeAPI->addChild(root, row1);

    row2 = nodeAPI->createNode(ARKUI_NODE_ROW);
    SetId(row2, "fgRow");
    nodeAPI->addChild(root, row2);
    nodeAPI->registerNodeEvent(row1, NODE_TOUCH_EVENT, 0, &row1);
    nodeAPI->registerNodeEvent(row2, NODE_TOUCH_EVENT, 0, &row2);

    SetWidthPercent(row1, 1);
    SetHeightPercent(row1, 1);
    SetBackgroundColor(row1);

    SetWidthPercent(row2, 1);
    SetHeightPercent(row2, 1);
    SetBackgroundColor(row2);

    button1 = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    button2 = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    nodeAPI->addChild(row2, button1);
    nodeAPI->addChild(row2, button2);
    nodeAPI->registerNodeEvent(button1, NODE_TOUCH_EVENT, 0, &button1);
    nodeAPI->registerNodeEvent(button2, NODE_TOUCH_EVENT, 0, &button2);

    SetWidthPercent(button1, DEFAULT_BUTTON_WIDTH);
    SetHeightPercent(button1, DEFAULT_BUTTON_HEIGHT);
    SetWidthPercent(button2, DEFAULT_BUTTON_WIDTH);
    SetHeightPercent(button2, DEFAULT_BUTTON_HEIGHT);
    SetId(button1, "Button1");
    SetId(button2, "Button2");
    SecondModule();
    ThirdModule();
}

} // namespace NativeXComponentSample

#endif // NDKINPUTEVENT_FUNCTION_H