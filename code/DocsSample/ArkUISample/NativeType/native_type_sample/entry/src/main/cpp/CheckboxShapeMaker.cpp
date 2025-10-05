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

#include "CheckboxShapeMaker.h"
#include "baseUtils.h"

namespace ConstIde {
    const uint32_t NUMBER_100 = 100;
} // namespace ConstIde

// 设置按钮的基础属性（宽度、高度）
void SetBaseAttributes(ArkUI_NodeHandle node, int32_t width, int32_t height)
{
    // 设置宽度和高度
    ArkUI_NumberValue widthValue[] = {{.f32 = static_cast<float>(width)}};
    ArkUI_NumberValue heightValue[] = {{.f32 = static_cast<float>(height)}};
    ArkUI_AttributeItem widthItem = {widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    ArkUI_AttributeItem heightItem = {heightValue, sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH, &widthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &heightItem);
}

void SetTypeAttributes(
    ArkUI_NodeHandle handleType,
    int32_t type,
    ArkUI_NodeAttributeType AttributeType)
{
    // 设置按钮类型
    ArkUI_NumberValue typeValue[] = {{.i32 = type }};
    ArkUI_AttributeItem typeItem = {typeValue, sizeof(typeValue) / sizeof(typeValue[0])};
    Manager::nodeAPI_->setAttribute(handleType, AttributeType, &typeItem);
}

ArkUI_NodeHandle CreateCheckboxText(const char* text)
{
    ArkUI_NodeHandle textNode = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);

    ArkUI_AttributeItem textItem = {.string = text};
    Manager::nodeAPI_->setAttribute(textNode, NODE_TEXT_CONTENT, &textItem);
    return textNode;
}

ArkUI_NodeHandle CheckboxShapeMaker::SetCheckboxProperties(uint32_t type)
{
    ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    if (!column) {
        return nullptr;
    }

    ArkUI_NodeHandle checkBox = Manager::nodeAPI_->createNode(ARKUI_NODE_CHECKBOX);
    if (!checkBox) {
        Manager::nodeAPI_->disposeNode(column);
        return nullptr;
    }
    SetBaseAttributes(checkBox, ConstIde::NUMBER_100, ConstIde::NUMBER_100);
    SetTypeAttributes(checkBox, type, NODE_CHECKBOX_SHAPE);

    auto textNode = CreateCheckboxText("Click");
    Manager::nodeAPI_->addChild(checkBox, textNode);
    Manager::nodeAPI_->addChild(column, checkBox);
    
    return column;
}