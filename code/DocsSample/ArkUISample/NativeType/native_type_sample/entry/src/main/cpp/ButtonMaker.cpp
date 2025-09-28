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

#include "ButtonMaker.h"
#include "baseUtils.h"

constexpr int32_t DEFAULT_BUTTON_WIDTH = 200;
constexpr int32_t DEFAULT_BUTTON_HEIGHT = 60;
constexpr int32_t CIRCLE_BUTTON_SIZE = 200;

// 按钮类型对应的文本
const char *GetButtonText(ArkUI_ButtonType type)
{
    switch (type) {
        case ARKUI_BUTTON_TYPE_NORMAL:
            return "普通按钮";
        case ARKUI_BUTTON_TYPE_CAPSULE:
            return "胶囊型按钮";
        case ARKUI_BUTTON_TYPE_CIRCLE:
            return "圆形按钮";
        case ARKUI_BUTTON_ROUNDED_RECTANGLE:
            return "圆角矩形按钮";
        default:
            return "按钮";
    }
}

// 设置按钮的基础属性（宽度、高度）
void SetButtonBaseAttributes(ArkUI_NodeHandle node, int32_t width, int32_t height)
{
    // 设置宽度和高度
    ArkUI_NumberValue widthValue[] = {{.f32 = static_cast<float>(width)}};
    ArkUI_NumberValue heightValue[] = {{.f32 = static_cast<float>(height)}};
    ArkUI_AttributeItem widthItem = {widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    ArkUI_AttributeItem heightItem = {heightValue, sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH, &widthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &heightItem);
}

// 设置按钮的基础属性（类型）
void SetButtonTypeAttributes(ArkUI_NodeHandle handleType, int32_t type, ArkUI_NodeAttributeType AttributeType)
{
    // 设置按钮类型
    ArkUI_NumberValue typeValue[] = {{.i32 = type}};
    ArkUI_AttributeItem typeItem = {typeValue, sizeof(typeValue) / sizeof(typeValue[0])};
    Manager::nodeAPI_->setAttribute(handleType, AttributeType, &typeItem);
}

// 创建按钮文本节点
ArkUI_NodeHandle CreateButtonText(const char *text)
{
    if (!text) {
        return nullptr;
    }

    ArkUI_NodeHandle textNode = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    if (!textNode) {
        return nullptr;
    }

    ArkUI_AttributeItem textItem = {.string = text};
    Manager::nodeAPI_->setAttribute(textNode, NODE_TEXT_CONTENT, &textItem);
    return textNode;
}

void SetButtonPropertiesWithCustomContent(ArkUI_ButtonType buttonType, ArkUI_NodeHandle column, ArkUI_NodeHandle button)
{
    switch (buttonType) {
        case ARKUI_BUTTON_TYPE_NORMAL:
        case ARKUI_BUTTON_TYPE_CAPSULE:
        case ARKUI_BUTTON_ROUNDED_RECTANGLE:
            SetButtonBaseAttributes(button, DEFAULT_BUTTON_WIDTH, DEFAULT_BUTTON_HEIGHT);
            break;
        case ARKUI_BUTTON_TYPE_CIRCLE:
            SetButtonBaseAttributes(button, CIRCLE_BUTTON_SIZE, CIRCLE_BUTTON_SIZE);
            break;
        default:
            Manager::nodeAPI_->disposeNode(button);
            Manager::nodeAPI_->disposeNode(column);
            return;
    }
}

ArkUI_NodeHandle ButtonMaker::SetButtonProperties(uint32_t type)
{
    ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NodeHandle button = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_ButtonType buttonType = static_cast<ArkUI_ButtonType>(type);
    const char *buttonText = GetButtonText(buttonType);
    SetButtonPropertiesWithCustomContent(buttonType, column, button);
    SetButtonTypeAttributes(button, type, NODE_BUTTON_TYPE);
    // 6. 添加文本子节点
    auto textNode = CreateButtonText(buttonText);
    Manager::nodeAPI_->addChild(button, textNode);
    // 7. 组装节点树并挂载
    Manager::nodeAPI_->addChild(column, button);
    return column;
}