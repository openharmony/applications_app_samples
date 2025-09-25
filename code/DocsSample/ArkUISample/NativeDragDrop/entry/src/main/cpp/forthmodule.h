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

#ifndef DRAGANDDROP_FORTHMODULE_H
#define DRAGANDDROP_FORTHMODULE_H

#include "common.h"
#include "container.h"
#include <arkui/drag_and_drop.h>
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <database/udmf/udmf_meta.h>
#include <hilog/log.h>
#include <sys/socket.h>
namespace NativeXComponentSample {

ArkUI_NodeHandle button4_1 = nullptr;
ArkUI_NodeHandle button4_2 = nullptr;

void SetTextDataLoadParams(ArkUI_DragEvent* dragEvent)
{
    // 异步传输拖拽数据
    OH_UdmfDataLoadParams *dataLoadParams = OH_UdmfDataLoadParams_Create();
    OH_UdmfDataLoadInfo *info = OH_UdmfDataLoadInfo_Create();
    OH_UdmfDataLoadInfo_SetType(info, "general.image");
    OH_UdmfDataLoadInfo_SetRecordCount(info, 1);
    OH_UdmfDataLoadParams_SetDataLoadInfo(dataLoadParams, info);
    OH_Udmf_DataLoadHandler dataLoadHandler = [](OH_UdmfDataLoadInfo *acceptableInfo) {
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
        OH_UdmfData *data4 = OH_UdmfData_Create();
        int returnValue;
        for (int i = 0; i < 1; i++) {
            returnValue = OH_UdmfData_AddRecord(data4, record);
        }
        return data4;
    };
    OH_UdmfDataLoadParams_SetLoadHandler(dataLoadParams, dataLoadHandler);
    ArkUI_ErrorCode errorCode1 = OH_ArkUI_DragEvent_SetDataLoadParams(dragEvent, dataLoadParams);
}

void StartDataLoadingForth(ArkUI_DragEvent* dragEvent)
{
    // 异步流程
    int returnValue;

    OH_Udmf_DataProgressListener dataProgressListener = [](OH_Udmf_ProgressInfo *progressInfo,
        OH_UdmfData *data) {
        int32_t progress = OH_UdmfProgressInfo_GetProgress(progressInfo);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "OH_ArkUI_DragEvent_StartDataLoading progressInfo = %{public}d", progress);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "dataProgressListener callback");
        bool resultUdmf = OH_UdmfData_HasType(data, UDMF_META_PLAIN_TEXT);
        if (resultUdmf) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
                "NODE_ON_DROP has UDMF_META_IMAGE");
            unsigned int recordsCount = 0;
            OH_UdmfRecord **records = OH_UdmfData_GetRecords(data, &recordsCount);
            // 获取records中的元素
            int returnStatus;
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "recordsCount= %{public}d",
                recordsCount);
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
            OH_ArkUI_NotifyDragResult(g_requestIdentify, ARKUI_DRAG_RESULT_SUCCESSFUL);
            OH_ArkUI_NotifyDragEndPendingDone(g_requestIdentify);
        }
    };
    OH_UdmfGetDataParams *params = OH_UdmfGetDataParams_Create();
    OH_UdmfGetDataParams_SetFileConflictOptions(params, Udmf_FileConflictOptions::UDMF_OVERWRITE);
    OH_UdmfGetDataParams_SetProgressIndicator(params, Udmf_ProgressIndicator::UDMF_DEFAULT);
    OH_UdmfGetDataParams_SetDataProgressListener(params, dataProgressListener);
    OH_ArkUI_DragEvent_StartDataLoading(dragEvent, params, key, UDMF_KEY_BUFFER_LEN);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "OH_ArkUI_DragEvent_StartDataLoading key = %{public}s", key);
    OH_UdmfGetDataParams_Destroy(params);
}

void RegisterNodeEventForthReceiver1()
{
    if (!nodeAPI) {
        return;
    }

    nodeAPI->addNodeEventReceiver(button4_1, [](ArkUI_NodeEvent *event) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "RegisterNodeEventForthReceiver called");
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        auto preDragStatus = OH_ArkUI_NodeEvent_GetPreDragStatus(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "eventType = %{public}d, preDragStatus = %{public}d", eventType, preDragStatus);

        auto *dragEvent = OH_ArkUI_NodeEvent_GetDragEvent(event);
        switch (eventType) {
            case NODE_ON_TOUCH_INTERCEPT: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_TOUCH_INTERCEPT EventReceiver");
                // 创建DragAction
                auto context = OH_ArkUI_GetContextByNode(button4_1);
                action = OH_ArkUI_CreateDragActionWithContext(context);
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
                    "OH_ArkUI_CreateDragActionWithNode returnValue = %{public}p", action);
                std::vector<OH_PixelmapNative *> pixelVector;
                // 设置pixelMap
                SetPixelMap(pixelVector);
                // 设置DragPreviewOption
                SetDragPreviewOption();
                PrintDragActionInfos();
                SetTextDataLoadParams(dragEvent);
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

void RegisterNodeEventForthReceiver2()
{
    if (!nodeAPI) {
        return;
    }

    nodeAPI->addNodeEventReceiver(button4_2, [](ArkUI_NodeEvent *event) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "RegisterNodeEventForthReceiver called");
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        auto preDragStatus = OH_ArkUI_NodeEvent_GetPreDragStatus(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "eventType = %{public}d, preDragStatus = %{public}d", eventType, preDragStatus);

        auto *dragEvent = OH_ArkUI_NodeEvent_GetDragEvent(event);
        switch (eventType) {
            case NODE_ON_DROP: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_DROP EventReceiver");
                StartDataLoadingForth(dragEvent);
                break;
            }
            default: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "UNKOWN EventReceiver");
                break;
            }
        }
    });
}

void ForthModule(ArkUI_NodeHandle &root)
{
    auto column4 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetColumnJustifyContent(column4, ARKUI_FLEX_ALIGNMENT_START);
    SetColumnAlignItem(column4, ARKUI_HORIZONTAL_ALIGNMENT_START);
    SetPadding(column4, BLANK_10);
    SetBorderWidth(column4, BORDER_WIDTH_1);
    SetBorderStyle(column4, ARKUI_BORDER_STYLE_DASHED, DEFAULT_RADIUS);

    auto title4 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(title4, "主动发起拖拽示例（异步加载）：", TEXT_FONT_SIZE_15, SIZE_240, SIZE_20);
    nodeAPI->addChild(column4, title4);

    auto row4 = nodeAPI->createNode(ARKUI_NODE_ROW);
    SetRowAlignItem(row4, ARKUI_VERTICAL_ALIGNMENT_TOP);
    nodeAPI->addChild(column4, row4);

    button4_1 = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    SetCommonAttribute(button4_1, SIZE_70, SIZE_50, 0xFFFF0000, BLANK_20);
    SetButtonLabel(button4_1, "拖起");
    nodeAPI->registerNodeEvent(button4_1, NODE_ON_TOUCH_INTERCEPT, 1, nullptr);
    nodeAPI->addChild(row4, button4_1);

    button4_2 = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    SetCommonAttribute(button4_2, SIZE_140, SIZE_50, 0xFFFF0000, BLANK_20);
    SetButtonLabel(button4_2, "拖拽至此处");
    nodeAPI->registerNodeEvent(button4_2, NODE_ON_DROP, 1, nullptr);
    nodeAPI->addChild(row4, button4_2);

    nodeAPI->addChild(root, column4);

    RegisterNodeEventForthReceiver1();
    RegisterNodeEventForthReceiver2();
}

} // namespace NativeXComponentSample

#endif // DRAGANDDROP_FORTHMODULE_H