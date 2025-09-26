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
#ifndef DRAGANDDROP_THIRDMODULE_H
#define DRAGANDDROP_THIRDMODULE_H

#include "common.h"
#include "container.h"
#include <arkui/drag_and_drop.h>
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <database/udmf/udmf_meta.h>
#include <hilog/log.h>
namespace NativeXComponentSample {

ArkUI_NodeHandle dragButton = nullptr;
ArkUI_NodeHandle dropButton = nullptr;

void DragStatusListener(ArkUI_DragAndDropInfo *info, void *userData)
{
    auto dragStatus = OH_ArkUI_DragAndDropInfo_GetDragStatus(info);
    auto dragEvent = OH_ArkUI_DragAndDropInfo_GetDragEvent(info);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "DragStatusListener called");
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "dragStatus = %{public}d, dragEvent = %{public}s",
                 dragStatus, dragEvent);
}

void SetDragActionData()
{
    // 创建OH_UdmfRecord对象
    OH_UdmfRecord *record = OH_UdmfRecord_Create();
    // 向OH_UdmfRecord中添加纯文本类型数据
    OH_UdsPlainText *plainText = OH_UdsPlainText_Create();
    int returnStatus;
    OH_UdsPlainText_SetAbstract(plainText, "this is plainText Abstract example");
    OH_UdsPlainText_SetContent(plainText, "this is plainText Content example");
    returnStatus = OH_UdmfRecord_AddPlainText(record, plainText);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "dragTest OH_UdmfRecord_AddPlainText returnStatus = %{public}d", returnStatus);
    // 创建OH_UdmfData对象
    OH_UdmfData *data = OH_UdmfData_Create();
    // 向OH_UdmfData中添加OH_UdmfRecord
    returnStatus = OH_UdmfData_AddRecord(data, record);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "dragTest OH_UdmfData_AddRecord returnStatus = %{public}d", returnStatus);
    int returnValue = OH_ArkUI_DragAction_SetData(action, data);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "OH_ArkUI_DragAction_SetData returnValue = %{public}d", returnValue);
    // 注册拖拽状态监听回调
    OH_ArkUI_DragAction_RegisterStatusListener(action, data, &DragStatusListener);
}

void GetUdmfDataText(ArkUI_DragEvent* dragEvent)
{
    // 获取UDMF data
    int returnValue;
    // 创建OH_UdmfData对象
    OH_UdmfData *data = OH_UdmfData_Create();
    returnValue = OH_ArkUI_DragEvent_GetUdmfData(dragEvent, data);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "OH_ArkUI_DragEvent_GetUdmfData returnValue = %{public}d", returnValue);
    // 判断OH_UdmfData是否有对应的类型
    bool resultUdmf = OH_UdmfData_HasType(data, UDMF_META_PLAIN_TEXT);
    if (resultUdmf) {
        // 获取OH_UdmfData的记录
        unsigned int recordsCount = 0;
        OH_UdmfRecord **records = OH_UdmfData_GetRecords(data, &recordsCount);
        // 获取records中的元素
        int returnStatus;
        for (int i = 0; i < recordsCount; i++) {
            // 从OH_UdmfRecord中获取纯文本类型数据
            OH_UdsPlainText *plainTextValue = OH_UdsPlainText_Create();
            returnStatus = OH_UdmfRecord_GetPlainText(records[i], plainTextValue);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
                "dragTest OH_UdmfRecord_GetPlainText "
                "returnStatus= %{public}d",
                returnStatus);
            auto getAbstract = OH_UdsPlainText_GetAbstract(plainTextValue);
            auto getContent = OH_UdsPlainText_GetContent(plainTextValue);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
                "OH_UdsPlainText_GetAbstract = "
                "%{public}s, OH_UdsPlainText_GetContent = "
                "%{public}s",
                getAbstract, getContent);
            // 使用结束后销毁指针
            OH_UdsPlainText_Destroy(plainTextValue);
        }
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "OH_UdmfData_HasType not contain UDMF_META_PLAIN_TEXT");
    }
    OH_UdmfData_Destroy(data);
}

void RegisterNodeEventThirdReceiver1()
{
    if (!nodeAPI) {
        return;
    }

    nodeAPI->addNodeEventReceiver(dragButton, [](ArkUI_NodeEvent *event) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "RegisterNodeEventThirdReceiver called");
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        auto preDragStatus = OH_ArkUI_NodeEvent_GetPreDragStatus(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "eventType = %{public}d, preDragStatus = %{public}d", eventType, preDragStatus);

        auto *dragEvent = OH_ArkUI_NodeEvent_GetDragEvent(event);
        switch (eventType) {
            case NODE_ON_TOUCH_INTERCEPT: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_TOUCH_INTERCEPT EventReceiver");
                // 创建DragAction
                action = OH_ArkUI_CreateDragActionWithNode(dragButton);
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
                    "OH_ArkUI_CreateDragActionWithNode returnValue = %{public}p", action);
                // 设置pixelMap
                std::vector<OH_PixelmapNative *> pixelVector;
                SetPixelMap(pixelVector);
                // 设置DragPreviewOption
                SetDragPreviewOption();
                // 设置pointerId、touchPoint
                PrintDragActionInfos();
                // 设置unifiedData
                SetDragActionData();
                // startDrag
                int returnValue = OH_ArkUI_StartDrag(action);
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
                    "OH_ArkUI_StartDrag returnValue = %{public}d",
                    returnValue);
                OH_ArkUI_DragAction_Dispose(action);
                break;
            }
            default: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "UNKOWN EventReceiver");
                break;
            }
        }
    });
}

void RegisterNodeEventThirdReceiver2()
{
    if (!nodeAPI) {
        return;
    }

    nodeAPI->addNodeEventReceiver(dropButton, [](ArkUI_NodeEvent *event) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "RegisterNodeEventThirdReceiver called");
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        auto preDragStatus = OH_ArkUI_NodeEvent_GetPreDragStatus(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "eventType = %{public}d, preDragStatus = %{public}d", eventType, preDragStatus);

        auto *dragEvent = OH_ArkUI_NodeEvent_GetDragEvent(event);
        switch (eventType) {
            case NODE_ON_DROP: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_DROP EventReceiver");
                GetUdmfDataText(dragEvent);
                OH_ArkUI_DragAction_UnregisterStatusListener(action);
                break;
            }
            default: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "UNKOWN EventReceiver");
                break;
            }
        }
    });
}

void ThirdModule(ArkUI_NodeHandle &root)
{
    auto column3 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetColumnJustifyContent(column3, ARKUI_FLEX_ALIGNMENT_START);
    SetColumnAlignItem(column3, ARKUI_HORIZONTAL_ALIGNMENT_START);
    SetPadding(column3, BLANK_10);
    SetBorderWidth(column3, BORDER_WIDTH_1);
    SetBorderStyle(column3, ARKUI_BORDER_STYLE_DASHED, DEFAULT_RADIUS);

    auto title3 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(title3, "主动发起拖拽示例：", TEXT_FONT_SIZE_15, SIZE_170, SIZE_20);
    nodeAPI->addChild(column3, title3);

    auto dragRow = nodeAPI->createNode(ARKUI_NODE_ROW);
    SetRowAlignItem(dragRow, ARKUI_VERTICAL_ALIGNMENT_TOP);
    nodeAPI->addChild(column3, dragRow);

    dragButton = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    SetCommonAttribute(dragButton, SIZE_70, SIZE_50, 0xFFFF0000, BLANK_20);
    SetButtonLabel(dragButton, "拖起");
    nodeAPI->registerNodeEvent(dragButton, NODE_ON_TOUCH_INTERCEPT, 1, nullptr);
    nodeAPI->addChild(dragRow, dragButton);

    dropButton = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    SetCommonAttribute(dropButton, SIZE_140, SIZE_50, 0xFFFF0000, BLANK_20);
    SetButtonLabel(dropButton, "拖拽至此处");
    nodeAPI->registerNodeEvent(dropButton, NODE_ON_DROP, 1, nullptr);
    nodeAPI->addChild(dragRow, dropButton);

    nodeAPI->addChild(root, column3);

    RegisterNodeEventThirdReceiver1();
    RegisterNodeEventThirdReceiver2();
}

} // namespace NativeXComponentSample

#endif // DRAGANDDROP_THIRDMODULE_H