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

#ifndef DRAGANDDROP_FIRSTMODULE_H
#define DRAGANDDROP_FIRSTMODULE_H

#include "common.h"
#include "container.h"
#include <arkui/drag_and_drop.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <database/udmf/udmf_meta.h>
#include <hilog/log.h>

namespace NativeXComponentSample {

ArkUI_NodeHandle dragText1 = nullptr;
ArkUI_NodeHandle dropText1 = nullptr;
ArkUI_NodeHandle dropText2 = nullptr;
ArkUI_NodeHandle displayIdText1 = nullptr;
ArkUI_NodeHandle bundleNameText1 = nullptr;
ArkUI_NodeHandle isRemoteText1 = nullptr;
ArkUI_NodeHandle previewTouchPointText1 = nullptr;
ArkUI_NodeHandle touchPointToWindowText1 = nullptr;
ArkUI_NodeHandle touchPointToDisplayText1 = nullptr;
ArkUI_NodeHandle touchPointToGlobalDisplayText1 = nullptr;
ArkUI_NodeHandle velocityText1 = nullptr;
ArkUI_NodeHandle modifierKeyStateText1 = nullptr;
ArkUI_NodeHandle dropArea1 = nullptr;
ArkUI_NodeHandle dropArea2 = nullptr;

void PrintDragStartInfos(ArkUI_DragEvent* dragEvent)
{
    int32_t displayId;
    OH_ArkUI_DragEvent_GetDisplayId(dragEvent, &displayId);
    g_ss.str("");
    g_ss << "displayId: " << displayId;
    SetText(displayIdText1, g_ss.str().c_str());
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "NODE_ON_DRAG_START displayId = %{public}d",
        displayId);
    char bundleName[50] = {};
    OH_ArkUI_DragEvent_GetDragSource(dragEvent, bundleName, MAX_LENGTH);
    g_ss.str("");
    g_ss << "bundleName: " << bundleName;
    SetText(bundleNameText1, g_ss.str().c_str());
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "NODE_ON_DRAG_START bundleName = %{public}s",
        bundleName);
    bool isRemote = false;
    OH_ArkUI_DragEvent_IsRemote(dragEvent, &isRemote);
    g_ss.str("");
    if (isRemote == false) {
        g_ss << "isRemote: false";
    } else if (isRemote == true) {
        g_ss << "isRemote: true";
    }
    SetText(isRemoteText1, g_ss.str().c_str());
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "OH_ArkUI_DragEvent_IsRemote returnValue = %{public}d", isRemote);
    uint64_t modifierKeys = ARKUI_MODIFIER_KEY_CTRL;
    int32_t modifierKeyState = OH_ArkUI_DragEvent_GetModifierKeyStates(dragEvent, &modifierKeys);
    g_ss.str("");
    if (modifierKeyState == 0) {
        g_ss << "modifierKeyState: false";
    } else if (modifierKeyState == 1) {
        g_ss << "modifierKeyState: true";
    }
    SetText(modifierKeyStateText1, g_ss.str().c_str());
}

void SetData(ArkUI_DragEvent* dragEvent)
{
    int returnValue;
    OH_UdmfRecord *record = OH_UdmfRecord_Create();
    OH_UdsFileUri *imageValue = OH_UdsFileUri_Create();
    returnValue = OH_UdsFileUri_SetFileUri(imageValue, "/resources/seagull.png");
    returnValue = OH_UdmfRecord_AddFileUri(record, imageValue);
    OH_UdmfData *data = OH_UdmfData_Create();
    returnValue = OH_UdmfData_AddRecord(data, record);
    returnValue = OH_ArkUI_DragEvent_SetData(dragEvent, data);
}

void GetDragMoveInfos(ArkUI_DragEvent* dragEvent)
{
    float previewTouchPointX = OH_ArkUI_DragEvent_GetPreviewTouchPointX(dragEvent);
    float previewTouchPointY = OH_ArkUI_DragEvent_GetPreviewTouchPointY(dragEvent);
    g_ss.str("");
    g_ss << "previewTouchPointX/Y: " << previewTouchPointX << "/" << previewTouchPointY;
    SetText(previewTouchPointText1, g_ss.str().c_str());
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "NODE_ON_MOVE GetPreviewTouchPointX pos = %{public}f; ",
        "GetPreviewTouchPointY pos = %{public}f",
        previewTouchPointX, previewTouchPointY);
    float touchPointXToWindow = OH_ArkUI_DragEvent_GetTouchPointXToWindow(dragEvent);
    float touchPointYToWindow = OH_ArkUI_DragEvent_GetTouchPointYToWindow(dragEvent);
    g_ss.str("");
    g_ss << "touchPointX/YToWindow: " << touchPointXToWindow << "/" << touchPointYToWindow;
    SetText(touchPointToWindowText1, g_ss.str().c_str());
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "NODE_ON_MOVE GetTouchPointXToWindow pos = %{public}f; GetTouchPointYToWindow pos = %{public}f",
        touchPointXToWindow, touchPointYToWindow);
    float touchPointXToDisplay = OH_ArkUI_DragEvent_GetTouchPointXToDisplay(dragEvent);
    float touchPointYToDisplay = OH_ArkUI_DragEvent_GetTouchPointYToDisplay(dragEvent);
    g_ss.str("");
    g_ss << "touchPointX/YToDisplay: " << touchPointXToDisplay << "/" << touchPointYToDisplay;
    SetText(touchPointToDisplayText1, g_ss.str().c_str());
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "NODE_ON_MOVE GetTouchPointXToDisplay pos = %{public}f; GetTouchPointYToDisplay pos = %{public}f",
        touchPointXToDisplay, touchPointYToDisplay);
    float touchPointXToGlobalDisplay = OH_ArkUI_DragEvent_GetTouchPointXToGlobalDisplay(dragEvent);
    float touchPointYToGlobalDisplay = OH_ArkUI_DragEvent_GetTouchPointYToGlobalDisplay(dragEvent);
    g_ss.str("");
    g_ss << "touchPointX/YToGlobalDisplay: " << touchPointXToDisplay << "/" << touchPointYToDisplay;
    SetText(touchPointToGlobalDisplayText1, g_ss.str().c_str());
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "NODE_ON_MOVE GetTouchPointXToGlobalDisplay pos = %{public}f; ",
        "GetTouchPointYToGlobalDisplay pos = %{public}f",
        touchPointXToGlobalDisplay, touchPointYToGlobalDisplay);
    float velocityX = OH_ArkUI_DragEvent_GetVelocityX(dragEvent);
    float velocityY = OH_ArkUI_DragEvent_GetVelocityY(dragEvent);
    float velocity = OH_ArkUI_DragEvent_GetVelocity(dragEvent);
    g_ss.str("");
    g_ss << "velocityX: " << velocityX << "  velocityY: " << velocityY << "  velocity: " << velocity;
    SetText(velocityText1, g_ss.str().c_str());
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "NODE_ON_MOVE GetVelocityX vx = %{public}f; ",
        "GetVelocityY vy = %{public}f; ",
        "GetVelocity v = %{public}f",
        velocityX, velocityY, velocity);
}

void GetDragData(ArkUI_DragEvent* dragEvent)
{
    // 获取UDMF data
    int returnValue;
    // 创建OH_UdmfData对象
    OH_UdmfData *data = OH_UdmfData_Create();
    returnValue = OH_ArkUI_DragEvent_GetUdmfData(dragEvent, data);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
        "OH_ArkUI_DragEvent_GetUdmfData returnValue = %{public}d", returnValue);
    // 判断OH_UdmfData是否有对应的类型
    bool resultUdmf = OH_UdmfData_HasType(data, UDMF_META_GENERAL_FILE);
    if (resultUdmf) {
        // 获取OH_UdmfData的记录
        unsigned int recordsCount = 0;
        OH_UdmfRecord **records = OH_UdmfData_GetRecords(data, &recordsCount);
        // 获取records中的元素
        int returnStatus;
        for (int i = 0; i < recordsCount; i++) {
            // 从OH_UdmfRecord中获取文件类型数据
            OH_UdsFileUri *imageValue = OH_UdsFileUri_Create();
            returnStatus = OH_UdmfRecord_GetFileUri(records[i], imageValue);
            const char *fileUri = OH_UdsFileUri_GetFileUri(imageValue);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
                "dragTest OH_UdmfRecord_GetPlainText "
                "returnStatus= %{public}d "
                "fileUri= %{public}s",
                returnStatus, fileUri);
            // 使用结束后销毁指针
            OH_UdsFileUri_Destroy(imageValue);
        }
        if (recordsCount != 0) {
            OH_ArkUI_DragEvent_SetDragResult(dragEvent, ARKUI_DRAG_RESULT_SUCCESSFUL);
            ArkUI_DropOperation option;
            OH_ArkUI_DragEvent_GetDropOperation(dragEvent, &option);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
                "OH_ArkUI_DragEvent_GetDropOperation returnValue = %{public}d", option);
        }
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "OH_UdmfData_HasType not contain UDMF_META_GENERAL_FILE");
    }
    int32_t count;
    OH_ArkUI_DragEvent_GetDataTypeCount(dragEvent, &count);
    if (count <= 0 || count >= MAX_LENGTH) {
        return;
    }
    char **eventTypeArray = new char *[count];
    for (int i = 0; i < count; i++) {
        eventTypeArray[i] = new char[MAX_LENGTH];
    }
    OH_ArkUI_DragEvent_GetDataTypes(dragEvent, eventTypeArray, count, MAX_LENGTH);
    for (int i = 0; i < count; i++) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "OH_ArkUI_DragEvent_GetDataTypes returnValue = %{public}s", eventTypeArray[i]);
    }
}

void RegisterNodeEventFirstReceiver1(ArkUI_NodeHandle &dragNode)
{
    if (!nodeAPI) {
        return;
    }

    nodeAPI->addNodeEventReceiver(dragNode, [](ArkUI_NodeEvent *event) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "RegisterNodeEventFirstReceiver called");
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        auto preDragStatus = OH_ArkUI_NodeEvent_GetPreDragStatus(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "eventType = %{public}d, preDragStatus = %{public}d", eventType, preDragStatus);
        auto *dragEvent = OH_ArkUI_NodeEvent_GetDragEvent(event);
        switch (eventType) {
            case NODE_ON_PRE_DRAG: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_PRE_DRAG EventReceiver");
                break;
            }
            case NODE_ON_DRAG_START: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_DRAG_START EventReceiver");
                PrintDragStartInfos(dragEvent);
                SetData(dragEvent);
                // 预览图尺寸
                float previewRectWidth = OH_ArkUI_DragEvent_GetPreviewRectWidth(dragEvent);
                float previewRectHeight = OH_ArkUI_DragEvent_GetPreviewRectHeight(dragEvent);
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
                    "NODE_ON_DRAG_START previewRectWidth = %{public}f; previewRectHeight = %{public}f",
                    previewRectWidth, previewRectHeight);
                break;
            }
            case NODE_ON_DRAG_END: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_DRAG_END EventReceiver");
                ArkUI_DragResult result;
                OH_ArkUI_DragEvent_GetDragResult(dragEvent, &result);
                if (result == ARKUI_DRAG_RESULT_SUCCESSFUL) {
                    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "Drag Successful!");
                    nodeAPI->resetAttribute(dragText1, NODE_TEXT_CONTENT);
                    SetText(dropText1, "drag me", TEXT_FONT_SIZE_20);
                    SetText(dropText2, "drag me", TEXT_FONT_SIZE_20);
                } else if (result == ARKUI_DRAG_RESULT_FAILED) {
                    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "Drag Failed!");
                }
                break;
            }
            default: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "UNKOWN EventReceiver");
                break;
            }
        }
    });
}

void RegisterNodeEventFirstReceiver2(ArkUI_NodeHandle node)
{
    if (!nodeAPI) {
        return;
    }

    nodeAPI->addNodeEventReceiver(node, [](ArkUI_NodeEvent *event) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "RegisterNodeEventFirstReceiver called");
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        auto preDragStatus = OH_ArkUI_NodeEvent_GetPreDragStatus(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest",
            "eventType = %{public}d, preDragStatus = %{public}d", eventType, preDragStatus);

        auto *dragEvent = OH_ArkUI_NodeEvent_GetDragEvent(event);
        switch (eventType) {
            case NODE_ON_DROP: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_DROP EventReceiver");
                GetDragData(dragEvent);
                break;
            }
            case NODE_ON_DRAG_ENTER: {
                OH_ArkUI_DragEvent_SetSuggestedDropOperation(dragEvent, ARKUI_DROP_OPERATION_COPY);
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_DRAG_ENTER EventReceiver");
                break;
            }
            case NODE_ON_DRAG_MOVE: {
                OH_ArkUI_DragEvent_SetSuggestedDropOperation(dragEvent, ARKUI_DROP_OPERATION_COPY);
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_DRAG_MOVE EventReceiver");
                GetDragMoveInfos(dragEvent);
                break;
            }
            case NODE_ON_DRAG_LEAVE: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "NODE_ON_DRAG_LEAVE EventReceiver");
                break;
            }
            default: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "dragTest", "UNKOWN EventReceiver");
                break;
            }
        }
    });
}

void DisplayInfo(ArkUI_NodeHandle &column1)
{
    displayIdText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(displayIdText1, "display: ");
    nodeAPI->addChild(column1, displayIdText1);
    
    bundleNameText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(bundleNameText1, "bundleName: ");
    nodeAPI->addChild(column1, bundleNameText1);
    
    isRemoteText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(isRemoteText1, "isRemote: ");
    nodeAPI->addChild(column1, isRemoteText1);
    
    modifierKeyStateText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(modifierKeyStateText1, "modifierKeyState: ");
    nodeAPI->addChild(column1, modifierKeyStateText1);
    
    previewTouchPointText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(previewTouchPointText1, "previewTouchPointX/Y: ");
    nodeAPI->addChild(column1, previewTouchPointText1);
    
    touchPointToWindowText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(touchPointToWindowText1, "previewTouchPointX/Y: ");
    nodeAPI->addChild(column1, touchPointToWindowText1);
    
    touchPointToDisplayText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(touchPointToDisplayText1, "touchPointX/YToDisplay: ");
    nodeAPI->addChild(column1, touchPointToDisplayText1);
    
    touchPointToGlobalDisplayText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(touchPointToGlobalDisplayText1, "touchPointX/YToGlobalDisplay: ");
    nodeAPI->addChild(column1, touchPointToGlobalDisplayText1);
    
    velocityText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(velocityText1, "velocityX:  velocityY:  velocity: ");
    nodeAPI->addChild(column1, velocityText1);
    
    auto blank = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetHeight(blank, BLANK_5);
    nodeAPI->addChild(column1, blank);
}

void SetPreviewOption(ArkUI_NodeHandle &node)
{
    auto *previewOptionsText = OH_ArkUI_CreateDragPreviewOption();
    OH_ArkUI_DragPreviewOption_SetScaleMode(previewOptionsText, ARKUI_DRAG_PREVIEW_SCALE_DISABLED);
    OH_ArkUI_DragPreviewOption_SetNumberBadgeEnabled(previewOptionsText, true);
    OH_ArkUI_DragPreviewOption_SetBadgeNumber(previewOptionsText, -1);
    OH_ArkUI_DragPreviewOption_SetDefaultShadowEnabled(previewOptionsText, true);
    OH_ArkUI_DragPreviewOption_SetDefaultRadiusEnabled(previewOptionsText, true);
    int returnValue = OH_ArkUI_DragPreviewOption_SetDefaultAnimationBeforeLiftingEnabled(previewOptionsText, true);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager",
        "dragTest DragPreviewOption_SetDefaultAnimationBeforeLiftingEnabled returnValue = %{public}d",
        returnValue);
    OH_ArkUI_SetNodeDragPreviewOption(node, previewOptionsText);
    OH_ArkUI_DragPreviewOption_Dispose(previewOptionsText);
}

void DragAreaFirst(ArkUI_NodeHandle &column1)
{
    auto dragRow1 = nodeAPI->createNode(ARKUI_NODE_ROW);
    SetRowAlignItem(dragRow1, ARKUI_VERTICAL_ALIGNMENT_TOP);
    nodeAPI->addChild(column1, dragRow1);
    
    // 拖拽区域
    auto dragColumn = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    auto dragTitle = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(dragTitle, "请长按拖拽文字", TEXT_FONT_SIZE_15, SIZE_140, SIZE_20);
    auto dragArea = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetCommonAttribute(dragArea, SIZE_140, SIZE_50, DEFAULT_BG_COLOR, BLANK_5);
    SetBorderWidth(dragArea, BORDER_WIDTH_1);
    SetColumnJustifyContent(dragArea, ARKUI_FLEX_ALIGNMENT_CENTER);
    nodeAPI->addChild(dragColumn, dragTitle);
    nodeAPI->addChild(dragColumn, dragArea);
    nodeAPI->addChild(dragRow1, dragColumn);
    
    dragText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(dragText1, "drag me", TEXT_FONT_SIZE_20);
    nodeAPI->registerNodeEvent(dragText1, NODE_ON_PRE_DRAG, 1, nullptr);
    nodeAPI->registerNodeEvent(dragText1, NODE_ON_DRAG_START, 1, nullptr);
    nodeAPI->registerNodeEvent(dragText1, NODE_ON_DRAG_END, 1, nullptr);
    OH_ArkUI_SetNodeDraggable(dragText1, true);
    SetPreviewOption(dragText1);
    nodeAPI->addChild(dragArea, dragText1);
    
    // 不可拖拽落入区域
    auto unDropColumn = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    auto unDropTitle = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(unDropTitle, "不可拖拽落入区域", TEXT_FONT_SIZE_15, SIZE_140, SIZE_20);
    auto unDropArea = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetCommonAttribute(unDropArea, SIZE_140, SIZE_50, DEFAULT_BG_COLOR, BLANK_5);
    SetBorderWidth(unDropArea, BORDER_WIDTH_1);
    SetColumnJustifyContent(unDropArea, ARKUI_FLEX_ALIGNMENT_CENTER);
    OH_ArkUI_DisallowNodeAnyDropDataTypes(unDropArea);
    OH_ArkUI_EnableDropDisallowedBadge(context, true);
    auto unDropText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(unDropText1, "", TEXT_FONT_SIZE_20);
    nodeAPI->addChild(unDropArea, unDropText1);
    nodeAPI->registerNodeEvent(unDropArea, NODE_ON_DROP, 1, nullptr);
    nodeAPI->addChild(unDropColumn, unDropTitle);
    nodeAPI->addChild(unDropColumn, unDropArea);
    nodeAPI->addChild(dragRow1, unDropColumn);
}

void DropAreaFirst1(ArkUI_NodeHandle &dragRow2)
{
    // 拖拽落入区域1
    auto dropColumn1 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    auto dropTitle1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(dropTitle1, "拖拽落入区域", TEXT_FONT_SIZE_15);
    
    dropArea1 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetCommonAttribute(dropArea1, SIZE_140, SIZE_200, DEFAULT_BG_COLOR, BLANK_5);
    SetBorderWidth(dropArea1, BORDER_WIDTH_1);
    SetColumnJustifyContent(dropArea1, ARKUI_FLEX_ALIGNMENT_SPACE_AROUND);
    SetColumnAlignItem(dropArea1, ARKUI_HORIZONTAL_ALIGNMENT_CENTER);
    OH_ArkUI_AllowNodeAllDropDataTypes(dropArea1);
    // 仅对当前组件生效
    OH_ArkUI_SetDragEventStrictReportWithNode(dropArea1, true);
    dropText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(dropText1, "", TEXT_FONT_SIZE_20);
    nodeAPI->addChild(dropArea1, dropTitle1);
    nodeAPI->addChild(dropArea1, dropText1);
    nodeAPI->registerNodeEvent(dropArea1, NODE_ON_DROP, 1, nullptr);
    nodeAPI->registerNodeEvent(dropArea1, NODE_ON_DRAG_MOVE, 1, nullptr);
    nodeAPI->registerNodeEvent(dropArea1, NODE_ON_DRAG_ENTER, 1, nullptr);
    nodeAPI->registerNodeEvent(dropArea1, NODE_ON_DRAG_LEAVE, 1, nullptr);
    nodeAPI->addChild(dropColumn1, dropArea1);
    
    auto unDropArea1 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetCommonAttribute(unDropArea1, SIZE_120, SIZE_70, DEFAULT_BG_COLOR, BLANK_5);
    SetBorderWidth(unDropArea1, BORDER_WIDTH_1);
    SetColumnJustifyContent(unDropArea1, ARKUI_FLEX_ALIGNMENT_CENTER);
    SetColumnAlignItem(unDropArea1, ARKUI_HORIZONTAL_ALIGNMENT_CENTER);
    OH_ArkUI_DisallowNodeAnyDropDataTypes(unDropArea1);
    nodeAPI->registerNodeEvent(unDropArea1, NODE_ON_DROP, 1, nullptr);
    auto unDropText1 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(unDropText1, "其他子组件", TEXT_FONT_SIZE_15);
    nodeAPI->addChild(unDropArea1, unDropText1);
    nodeAPI->addChild(dropArea1, unDropArea1);
    
    nodeAPI->addChild(dragRow2, dropColumn1);
}

void DropAreaFirst2(ArkUI_NodeHandle &dragRow2)
{
    // 拖拽落入区域2
    auto dropColumn2 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    auto dropTitle2 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(dropTitle2, "拖拽落入区域", TEXT_FONT_SIZE_15);
    dropArea2 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetCommonAttribute(dropArea2, SIZE_140, SIZE_200, DEFAULT_BG_COLOR, BLANK_5);
    SetBorderWidth(dropArea2, BORDER_WIDTH_1);
    SetColumnJustifyContent(dropArea2, ARKUI_FLEX_ALIGNMENT_SPACE_AROUND);
    SetColumnAlignItem(dropArea2, ARKUI_HORIZONTAL_ALIGNMENT_CENTER);
    OH_ArkUI_AllowNodeAllDropDataTypes(dropArea2);
    // context上下文均生效
    OH_ArkUI_SetDragEventStrictReportWithContext(context, true);
    dropText2 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(dropText2, "", TEXT_FONT_SIZE_20);
    nodeAPI->addChild(dropArea2, dropTitle2);
    nodeAPI->addChild(dropArea2, dropText2);
    nodeAPI->registerNodeEvent(dropArea2, NODE_ON_DROP, 1, nullptr);
    nodeAPI->registerNodeEvent(dropArea2, NODE_ON_DRAG_MOVE, 1, nullptr);
    nodeAPI->registerNodeEvent(dropArea2, NODE_ON_DRAG_ENTER, 1, nullptr);
    nodeAPI->registerNodeEvent(dropArea2, NODE_ON_DRAG_LEAVE, 1, nullptr);
    nodeAPI->addChild(dropColumn2, dropArea2);
    
    auto unDropArea2 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetCommonAttribute(unDropArea2, SIZE_120, SIZE_70, DEFAULT_BG_COLOR, BLANK_5);
    SetBorderWidth(unDropArea2, BORDER_WIDTH_1);
    SetColumnJustifyContent(unDropArea2, ARKUI_FLEX_ALIGNMENT_CENTER);
    SetColumnAlignItem(unDropArea2, ARKUI_HORIZONTAL_ALIGNMENT_CENTER);
    OH_ArkUI_DisallowNodeAnyDropDataTypes(unDropArea2);
    const char* types[] = {"general.file"};
    OH_ArkUI_SetNodeAllowedDropDataTypes(unDropArea2, types, 1);
    nodeAPI->registerNodeEvent(unDropArea2, NODE_ON_DROP, 1, nullptr);
    auto unDropText2 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetText(unDropText2, "其他子组件", TEXT_FONT_SIZE_15);
    nodeAPI->addChild(unDropArea2, unDropText2);
    nodeAPI->addChild(dropArea2, unDropArea2);

    nodeAPI->addChild(dragRow2, dropColumn2);
}

void FirstModule(ArkUI_NodeHandle &root)
{
    auto column1 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetColumnJustifyContent(column1, ARKUI_FLEX_ALIGNMENT_START);
    SetColumnAlignItem(column1, ARKUI_HORIZONTAL_ALIGNMENT_START);
    SetPadding(column1, BLANK_10);
    SetBorderWidth(column1, BORDER_WIDTH_1);
    SetBorderStyle(column1, ARKUI_BORDER_STYLE_DASHED, DEFAULT_RADIUS);
    
    auto title = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(title, "通用拖拽示例：", TEXT_FONT_SIZE_15, SIZE_140, SIZE_20);
    nodeAPI->addChild(column1, title);
    
    DragAreaFirst(column1);
    
    auto dragRow2 = nodeAPI->createNode(ARKUI_NODE_ROW);
    SetRowAlignItem(dragRow2, ARKUI_VERTICAL_ALIGNMENT_TOP);
    nodeAPI->addChild(column1, dragRow2);
    
    DropAreaFirst1(dragRow2);

    DropAreaFirst2(dragRow2);
    
    DisplayInfo(column1);
    
    auto resetButton = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    SetButtonLabel(resetButton, "复位");
    nodeAPI->registerNodeEvent(resetButton, NODE_ON_CLICK_EVENT, 1, nullptr);
    nodeAPI->addNodeEventReceiver(resetButton, [](ArkUI_NodeEvent *event) {
        nodeAPI->resetAttribute(dropText1, NODE_TEXT_CONTENT);
        nodeAPI->resetAttribute(dropText2, NODE_TEXT_CONTENT);
        SetText(dragText1, "drag me", TEXT_FONT_SIZE_20);
    });
    nodeAPI->addChild(column1, resetButton);
    
    nodeAPI->addChild(root, column1);
    
    RegisterNodeEventFirstReceiver1(dragText1);
    RegisterNodeEventFirstReceiver2(dropArea1);
    RegisterNodeEventFirstReceiver2(dropArea2);
}

} // namespace NativeXComponentSample

#endif // DRAGANDDROP_FIRSTMODULE_H