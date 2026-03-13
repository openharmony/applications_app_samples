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
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <hilog/log.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_declaration.h>
#include <cstdlib>
#include <cstring>

#define CUSTOM_LOG_TAG "manager"
#define LOG_ERROR(...) OH_LOG_Print(LOG_APP, LOG_ERROR, 0xD001400, CUSTOM_LOG_TAG, __VA_ARGS__)
#define LOG_INFO(...) OH_LOG_Print(LOG_APP, LOG_INFO, 0xD001400, CUSTOM_LOG_TAG, __VA_ARGS__)

namespace ConstIde {
const uint32_t NUMBER_0 = 0;
const uint32_t NUMBER_1 = 1;
const uint32_t NUMBER_2 = 2;
const uint32_t MARGIN_NUMBER_30 = 30;
constexpr const char *K_LOG_DOMAIN = "Manager";
} // namespace ConstIde

Manager Manager::manager_;
ArkUI_NativeNodeAPI_1 *Manager::nodeAPI_ = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
    OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
template <class MakeNodeFn>
static napi_value CreateNativeNode(napi_env env, napi_callback_info info, const char *who, MakeNodeFn makeNodeFn)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s BEGIN", who);

    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s env or info is null",
                     who);
        return nullptr;
    }
    
    size_t argc = ConstIde::NUMBER_1;
    napi_value args[ConstIde::NUMBER_1] = {nullptr};
    napi_status st = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (st != napi_ok || argc < ConstIde::NUMBER_1) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s napi_get_cb_info failed",
                     who);
        return nullptr;
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[ConstIde::NUMBER_0], &nodeContentHandle);
    if (nodeContentHandle == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN,
                     "%{public}s nodeContentHandle is null", who);
        return nullptr;
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s after GetNodeContent", who);

    // 可选：保留对 nodeAPI_ 的健壮性检查（与你现有代码一致）
    if (Manager::nodeAPI_ == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s nodeAPI_ is null", who);
        return nullptr;
    }

    // 构建具体节点 & 挂载
    ArkUI_NodeHandle page = makeNodeFn();
    if (page == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s makeNodeFn return null",
                     who);
        return nullptr;
    }

    OH_ArkUI_NodeContent_AddNode(nodeContentHandle, page);
    return nullptr;
}

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

napi_value Manager::CreateStyledStringNativeNode(napi_env__* env, napi_callback_info__* info)
{
    return CreateNativeNode(env, info, "CreateStyledStringNativeNode",
                            []() -> ArkUI_NodeHandle { return CreateNativeStyledStringNode(); });
}
    
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

static void SerializeAndDeserializeStyledString()
{
    uint8_t data_bytes[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
    size_t dataSize = sizeof(data_bytes) / sizeof(data_bytes[0]);
    auto desc = OH_ArkUI_StyledString_Descriptor_Create();
    if (desc == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "styledString", "Create Descriptor failed");
        return;
    }
    auto status = OH_ArkUI_UnmarshallStyledStringDescriptor(data_bytes, dataSize, desc);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "styledString", "Unmarshall status: %{public}d", status);
    const char* html = OH_ArkUI_ConvertToHtml(desc);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "styledString", "html: [%{public}s]", html);
    size_t resultSize = dataSize + 2;
    uint8_t *buf1 = (uint8_t *)malloc(10 * sizeof(uint8_t));
    if (buf1 == nullptr) {
        OH_ArkUI_StyledString_Descriptor_Destroy(desc);
        return;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "styledString", "resultSize: %{public}zu", resultSize);
    uint8_t *buf2 = (uint8_t *)malloc(resultSize * sizeof(uint8_t));
    if (buf2 != nullptr) {
        if (resultSize >= dataSize) {
            for (size_t i = 0; i < dataSize; i++) {
                buf2[i] = data_bytes[i];
            }
        } else {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "styledString",
                         "Buf too small: %{public}zu < %{public}zu", resultSize, dataSize);
            free(buf2);
            free(buf1);
            OH_ArkUI_StyledString_Descriptor_Destroy(desc);
            return;
        }
        bool equal = true;
        for (size_t i = 0; i < dataSize && equal; i++) equal = (data_bytes[i] == buf2[i]);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "styledString",
            "Before: %{public}zu, After: %{public}zu, Equal: %{public}d", dataSize, resultSize, equal);
        free(buf2);
    }
    free(buf1);
    OH_ArkUI_StyledString_Descriptor_Destroy(desc);
}

ArkUI_NodeHandle Manager::CreateNativeStyledStringNode()
{
    // 获取NodeAPI接口
    ArkUI_NativeNodeAPI_1 *nodeApi = Manager::nodeAPI_;

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

    SerializeAndDeserializeStyledString();

    // 组装与释放资源
    nodeApi->addChild(column, text);
    OH_Drawing_DestroyTypographyStyle(typographyStyle);
    OH_Drawing_DestroyFontCollection(fontCollection);
    return column;
}