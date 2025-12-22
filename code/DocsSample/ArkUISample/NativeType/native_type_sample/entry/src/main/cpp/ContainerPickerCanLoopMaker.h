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

#ifndef NATIVE_TYPE_SAMPLE_CONTAINER_PICKER_CAN_LOOP_MAKER_H
#define NATIVE_TYPE_SAMPLE_CONTAINER_PICKER_CAN_LOOP_MAKER_H

#include <memory>

#include <arkui/native_node.h>

#include "ArkUINodeAdapter.h"
#include "ScrollableEvent.h"
#include "ScrollableNode.h"
#include "ScrollableUtils.h"

class ContainerPickerCanLoopMaker : public BaseNode {
public:
    static ArkUI_NodeHandle CreateNativeNode();

    ContainerPickerCanLoopMaker()
        : BaseNode(NodeApiInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_PICKER)),
          nodeApi_(NodeApiInstance::GetInstance()->GetNativeNodeAPI())
    {
        if (!IsNotNull(nodeApi_) || !IsNotNull(GetHandle())) {
            return;
        }
    }

    ~ContainerPickerCanLoopMaker() override = default;

    // ========================================
    // 基础尺寸设置接口
    // ========================================
    void SetPickerSize(float width, float height) { SetSize(width, height); }

    void SetPickerSizePercent(float widthPercent, float heightPercent) { SetSizePercent(widthPercent, heightPercent); }

    void SetPickerWidthPercent(float widthPercent)
    {
        SetAttributeFloat32(nodeApi_, GetHandle(), NODE_WIDTH_PERCENT, widthPercent);
    }

    void SetPickerHeightPercent(float heightPercent)
    {
        SetAttributeFloat32(nodeApi_, GetHandle(), NODE_HEIGHT_PERCENT, heightPercent);
    }

    // ========================================
    // Picker特有属性设置接口
    // ========================================
    void SetSelectedIndex(uint32_t index)
    {
        if (!IsNotNull(nodeApi_) || !IsNotNull(GetHandle())) {
            return;
        }
        ArkUI_NumberValue selectedIndexValue = {.u32 = index};
        ArkUI_AttributeItem selectedIndexItem = {&selectedIndexValue,
                                                 sizeof(selectedIndexValue) / sizeof(ArkUI_NumberValue)};
        nodeApi_->setAttribute(GetHandle(), NODE_PICKER_OPTION_SELECTED_INDEX, &selectedIndexItem);
    }

    void SetCanLoop(bool canLoop)
    {
        if (!IsNotNull(nodeApi_) || !IsNotNull(GetHandle())) {
            return;
        }
        ArkUI_NumberValue canLoopValue = {.i32 = canLoop ? 1 : 0};
        ArkUI_AttributeItem canLoopItem = {&canLoopValue, sizeof(canLoopValue) / sizeof(ArkUI_NumberValue)};
        nodeApi_->setAttribute(GetHandle(), NODE_PICKER_CAN_LOOP, &canLoopItem);
    }

    void SetHapticFeedback(bool enabled)
    {
        if (!IsNotNull(nodeApi_) || !IsNotNull(GetHandle())) {
            return;
        }
        ArkUI_NumberValue enableHapticFeedbackValue = {.i32 = enabled ? 1 : 0};
        ArkUI_AttributeItem enableHapticFeedbackItem = {&enableHapticFeedbackValue,
                                                        sizeof(enableHapticFeedbackValue) / sizeof(ArkUI_NumberValue)};
        nodeApi_->setAttribute(GetHandle(), NODE_PICKER_ENABLE_HAPTIC_FEEDBACK, &enableHapticFeedbackItem);
    }

    void SetSelectionIndicatorBackground(uint32_t backgroundColor, float cornerRadius = 10.0f)
    {
        if (!IsNotNull(nodeApi_) || !IsNotNull(GetHandle())) {
            return;
        }
        ArkUI_PickerIndicatorStyle *indicatorStyle =
            OH_ArkUI_PickerIndicatorStyle_Create(ARKUI_PICKER_INDICATOR_BACKGROUND);
        if (indicatorStyle == nullptr) {
            return;
        }
        ArkUI_PickerIndicatorBackground background = {.backgroundColor = backgroundColor,
                                                      .topLeftRadius = cornerRadius,
                                                      .topRightRadius = cornerRadius,
                                                      .bottomLeftRadius = cornerRadius,
                                                      .bottomRightRadius = cornerRadius};
        OH_ArkUI_PickerIndicatorStyle_ConfigureBackground(indicatorStyle, &background);
        ArkUI_AttributeItem selectionIndicatorItem = {.object = indicatorStyle};
        nodeApi_->setAttribute(GetHandle(), NODE_PICKER_SELECTION_INDICATOR, &selectionIndicatorItem);
    }

    void SetSelectionIndicatorDivider(uint32_t dividerColor, float strokeWidth = 2.0f, float startMargin = 20.0f,
                                      float endMargin = 20.0f)
    {
        if (!IsNotNull(nodeApi_) || !IsNotNull(GetHandle())) {
            return;
        }
        ArkUI_PickerIndicatorStyle *indicatorStyle =
            OH_ArkUI_PickerIndicatorStyle_Create(ARKUI_PICKER_INDICATOR_DIVIDER);
        if (indicatorStyle == nullptr) {
            return;
        }
        ArkUI_PickerIndicatorDivider divider = {.strokeWidth = strokeWidth,
                                                .dividerColor = dividerColor,
                                                .startMargin = startMargin,
                                                .endMargin = endMargin};
        OH_ArkUI_PickerIndicatorStyle_ConfigureDivider(indicatorStyle, &divider);
        ArkUI_AttributeItem selectionIndicatorItem = {.object = indicatorStyle};
        nodeApi_->setAttribute(GetHandle(), NODE_PICKER_SELECTION_INDICATOR, &selectionIndicatorItem);
    }

    // ========================================
    // 公共辅助方法
    // ========================================
    ArkUI_NativeNodeAPI_1 *GetNodeAPI() const { return nodeApi_; }

protected:
    void OnNodeEvent(ArkUI_NodeEvent *event) override { BaseNode::OnNodeEvent(event); }

private:
    ArkUI_NativeNodeAPI_1 *nodeApi_ = nullptr;
};

#endif // NATIVE_TYPE_SAMPLE_CONTAINER_PICKER_CAN_LOOP_MAKER_H