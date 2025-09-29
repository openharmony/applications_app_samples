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
#include "manager.h"
#include <arkui/native_interface.h>
#include <arkui/styled_string.h>
#include <hilog/log.h>
#include <native_drawing/drawing_color.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_declaration.h>
#include <sstream>

#define LOG_TAG "manager"
#define LOG_ERROR(...) OH_LOG_Print(LOG_APP, LOG_ERROR, 0xD001400, LOG_TAG, __VA_ARGS__)

namespace NativeNode::Manager {
constexpr int32_t MAX_LINES = 10;                // 最大行数
constexpr int32_t FONT_SIZE = 28;                // 字体大小
constexpr int32_t LAYOUT_MAX_WIDTH = 400;        // 排版最大宽度
constexpr int32_t CONTAINER_WIDTH = 300;         // 容器宽度
constexpr int32_t TEXT_HEIGHT = 100;             // 文本组件高度
constexpr float BORDER_WIDTH = 1.0f;             // 边框宽度
constexpr int32_t PLACEHOLDER_WIDTH = 100;       // 占位符宽度
constexpr int32_t PLACEHOLDER_HEIGHT = 100;      // 占位符高度
constexpr uint32_t TEXT_COLOR_GRAY = 0xFF707070; // 第一段文本颜色（灰色）
constexpr uint32_t TEXT_COLOR_BLUE = 0xFF2787D9; // 第二段文本颜色（蓝色）

// 创建Column容器
static ArkUI_NodeHandle CreateColumnContainer(ArkUI_NativeNodeAPI_1 *nodeApi)
{
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = CONTAINER_WIDTH}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    return column;
}

// 创建带样式的Text组件
static ArkUI_NodeHandle CreateStyledText(ArkUI_NativeNodeAPI_1 *nodeApi)
{
    ArkUI_NodeHandle text = nodeApi->createNode(ARKUI_NODE_TEXT);

    // 设置文本宽度
    ArkUI_NumberValue textWidth[] = {{.f32 = CONTAINER_WIDTH}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidth, .size = 1};
    nodeApi->setAttribute(text, NODE_WIDTH, &textWidthItem);

    // 设置文本高度
    ArkUI_NumberValue textHeight[] = {{.f32 = TEXT_HEIGHT}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeight, .size = 1};
    nodeApi->setAttribute(text, NODE_HEIGHT, &textHeightItem);

    // 设置边框宽度
    ArkUI_NumberValue borderWidth[] = {{.f32 = BORDER_WIDTH}};
    ArkUI_AttributeItem borderWidthItem = {.value = borderWidth, .size = 1};
    nodeApi->setAttribute(text, NODE_BORDER_WIDTH, &borderWidthItem);

    return text;
}

void NodeManager::CreateNativeNode()
{
    if (!xComponent_) {
        return;
    }

    // 获取NodeAPI接口
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }

    // 创建容器与文本组件
    ArkUI_NodeHandle column = CreateColumnContainer(nodeApi);
    ArkUI_NodeHandle text = CreateStyledText(nodeApi);

    // 创建字体集合与段落样式
    OH_Drawing_FontCollection *fontCollection = OH_Drawing_CreateFontCollection();
    OH_Drawing_TypographyStyle *typographyStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_SetTypographyTextAlign(typographyStyle, OH_Drawing_TextAlign::TEXT_ALIGN_CENTER);
    OH_Drawing_SetTypographyTextMaxLines(typographyStyle, MAX_LINES);

    // 创建StyledString并设置文本内容
    ArkUI_StyledString *styledString = OH_ArkUI_StyledString_Create(typographyStyle, fontCollection);

    // 第一段文本（灰色"Hello"）
    OH_Drawing_TextStyle *textStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleFontSize(textStyle, FONT_SIZE);
    OH_Drawing_SetTextStyleColor(textStyle, TEXT_COLOR_GRAY);
    OH_ArkUI_StyledString_PushTextStyle(styledString, textStyle);
    OH_ArkUI_StyledString_AddText(styledString, "Hello");
    OH_ArkUI_StyledString_PopTextStyle(styledString);
    OH_Drawing_DestroyTextStyle(textStyle);

    // 添加占位符
    OH_Drawing_PlaceholderSpan placeHolder{.width = PLACEHOLDER_WIDTH, .height = PLACEHOLDER_HEIGHT};
    OH_ArkUI_StyledString_AddPlaceholder(styledString, &placeHolder);

    // 第二段文本（蓝色"World!"）
    OH_Drawing_TextStyle *worldTextStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleFontSize(worldTextStyle, FONT_SIZE);
    OH_Drawing_SetTextStyleColor(worldTextStyle, TEXT_COLOR_BLUE);
    OH_ArkUI_StyledString_PushTextStyle(styledString, worldTextStyle);
    OH_ArkUI_StyledString_AddText(styledString, "World!");
    OH_ArkUI_StyledString_PopTextStyle(styledString);
    OH_Drawing_DestroyTextStyle(worldTextStyle);

    // 排版与设置属性
    OH_Drawing_Typography *typography = OH_ArkUI_StyledString_CreateTypography(styledString);
    OH_Drawing_TypographyLayout(typography, LAYOUT_MAX_WIDTH);
    ArkUI_AttributeItem styledStringItem = {.object = styledString};
    nodeApi->setAttribute(text, NODE_TEXT_CONTENT_WITH_STYLED_STRING, &styledStringItem);

    // 组装与释放资源
    nodeApi->addChild(column, text);
    OH_ArkUI_StyledString_Destroy(styledString);
    OH_Drawing_DestroyTypographyStyle(typographyStyle);
    OH_Drawing_DestroyFontCollection(fontCollection);
    OH_NativeXComponent_AttachNativeRootNode(xComponent_, column);
}

// 单例与XComponent设置
NodeManager &NodeManager::GetInstance()
{
    static NodeManager instance;
    return instance;
}

void NodeManager::SetXComponent(OH_NativeXComponent *xComponent)
{
    xComponent_ = xComponent;
}
} // namespace NativeNode::Manager