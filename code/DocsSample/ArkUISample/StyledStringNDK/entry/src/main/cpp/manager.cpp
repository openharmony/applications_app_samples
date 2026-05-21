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
// [Start obtain_create_text_all]
#include "manager.h"
#include <arkui/native_interface.h>
#include <arkui/styled_string.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
// [StartExclude obtain_create_text_all]
#include <hilog/log.h>
// [EndExclude obtain_create_text_all]
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

constexpr int32_t NUM_10 = 10;
constexpr int32_t NUM_48 = 48;
constexpr int32_t NUM_400 = 400;

// [StartExclude obtain_create_text_all]
napi_value Manager::CreateStyledStringNativeNode(napi_env__* env, napi_callback_info__* info)
{
    return CreateNativeNode(env, info, "CreateStyledStringNativeNode",
                            []() -> ArkUI_NodeHandle { return CreateNativeStyledStringNode(); });
}

// [EndExclude obtain_create_text_all]
ArkUI_NodeHandle Manager::CreateNativeStyledStringNode()
{
    // [Start obtain_create_text]
    ArkUI_NativeNodeAPI_1 *nodeApi = Manager::nodeAPI_;

    // [StartExclude obtain_create_text]
    // 创建一个Column容器组件
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = 300}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    ArkUI_NumberValue marginTop[] = {{.f32 = 100}};
    ArkUI_AttributeItem marginItem = {.value = marginTop, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    nodeApi->setAttribute(column, NODE_MARGIN, &marginItem);
    // [EndExclude obtain_create_text]
    // 创建Text组件
    ArkUI_NodeHandle text = nodeApi->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth[] = {{.f32 = 300}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidth, .size = 1};
    nodeApi->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = 100}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeight, .size = 1};
    nodeApi->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    // [End obtain_create_text]
    ArkUI_NumberValue borderWidth[] = {{.f32 = 1}};
    ArkUI_AttributeItem borderWidthItem = {.value = borderWidth, .size = 1};
    nodeApi->setAttribute(text, NODE_BORDER_WIDTH, &borderWidthItem);
    
    // OH_Drawing_开头的API是字体引擎提供的，typographyStyle表示段落样式。
    // [Start obtain_create_text_typographyStyle]
    OH_Drawing_TypographyStyle *typographyStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_SetTypographyTextAlign(typographyStyle, OH_Drawing_TextAlign::TEXT_ALIGN_CENTER);
    OH_Drawing_SetTypographyTextMaxLines(typographyStyle, NUM_10);
    // [End obtain_create_text_typographyStyle]
    // 创建 ArkUI_StyledString。
    // [Start obtain_create_text_styledString]
    ArkUI_StyledString *styledString = OH_ArkUI_StyledString_Create(typographyStyle, OH_Drawing_CreateFontCollection());
    // 创建文本样式，设置字体和颜色。
    // [Start obtain_create_text_placeholder]
    OH_Drawing_TextStyle *textStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleFontSize(textStyle, NUM_48);
    OH_Drawing_SetTextStyleColor(textStyle, OH_Drawing_ColorSetArgb(0xFF, 0x70, 0x70, 0x70));
    // 文本样式的设置顺序push -> add -> pop.
    OH_ArkUI_StyledString_PushTextStyle(styledString, textStyle);
    OH_ArkUI_StyledString_AddText(styledString, "Hello");
    OH_ArkUI_StyledString_PopTextStyle(styledString);
    // [StartExclude obtain_create_text_styledString]
    // 添加占位，此区域内不会绘制文字，可以在此位置挂载Image组件实现图文混排。
    OH_Drawing_PlaceholderSpan placeHolder{.width = 100, .height = 100};
    OH_ArkUI_StyledString_AddPlaceholder(styledString, &placeHolder);
    // [EndExclude obtain_create_text_styledString]
    // 设置不同样式的文字
    OH_Drawing_TextStyle *worldTextStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleFontSize(worldTextStyle, NUM_48);
    OH_Drawing_SetTextStyleColor(worldTextStyle, OH_Drawing_ColorSetArgb(0xFF, 0x27, 0x87, 0xD9));
    OH_ArkUI_StyledString_PushTextStyle(styledString, worldTextStyle);
    OH_ArkUI_StyledString_AddText(styledString, "World!");
    OH_ArkUI_StyledString_PopTextStyle(styledString);
    // [End obtain_create_text_placeholder]
    // [End obtain_create_text_styledString]
    // 依赖StyledString对象创建字体引擎的Typography，此时它已经包含了设置的文本及其样式。
    // [Start obtain_create_text_typography]
    OH_Drawing_Typography *typography = OH_ArkUI_StyledString_CreateTypography(styledString);
    // 字体引擎布局方法，需传入一个宽度，此宽度需与Text组件宽度匹配。
    // 布局宽度 = Text组件宽度 - (左padding + 右padding)
    OH_Drawing_TypographyLayout(typography, NUM_400);
    // [End obtain_create_text_typography]
    // [Start obtain_create_text_attributeItem]
    ArkUI_AttributeItem styledStringItem = {.object = styledString};
    // 布局完成后，通过NODE_TEXT_CONTENT_WITH_STYLED_STRING设置给Text组件。
    nodeApi->setAttribute(text, NODE_TEXT_CONTENT_WITH_STYLED_STRING, &styledStringItem);
    // [End obtain_create_text_attributeItem]

    // 资源释放，应用侧可以自由决定何时释放。
    OH_ArkUI_StyledString_Destroy(styledString);
    // Text作为Column子组件
    nodeApi->addChild(column, text);
    return column;
}
// [End obtain_create_text_all]
