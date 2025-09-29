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

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <arkui/native_animate.h>
#include <arkui/native_gesture.h>
#include <arkui/native_key_event.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <cstdint>
#include <cstdio>
#include <sstream>
#include <string>
#include <hilog/log.h>
#include <arkui/drag_and_drop.h>

#include "manager.h"
#include "PublicEvent.h"

const int32_t TARGET_ID_2 = 2;
const int32_t TARGET_ID_3 = 3;
const int32_t TARGET_ID_4 = 4;
const int32_t TARGET_ID_5 = 5;
const int32_t TARGET_ID_6 = 6;

static bool g_isEnable = true;
OH_PixelmapNative *pixelMap = nullptr;
static int g_num = 0;
static int g_num1 = 0;
static ArkUI_NodeHandle image;
static ArkUI_AttributeItem NODE_IMAGE_SRC_Item;
static auto options_test = OH_ArkUI_CreateSnapshotOptions();
static ArkUI_NodeHandle image2;
static int g_a[] = {1, 1, -1, 4, 10, 100};
char *g_b[] = {"src/main/resources/base/media/background.png",
               "src/main/resources/base/media/foreground.png",
               "src/main/resources/base/media/startIcon.png"};
static int g_arrayLength = sizeof(g_a) / sizeof(g_a[0]);
static int g_arrayLength1 = sizeof(g_b) / sizeof(g_b[0]);

void SetScrollAttribute(ArkUI_NodeHandle &scroll)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue scrollWidthValue[] = {500};
    ArkUI_AttributeItem scrollWidthItem = {scrollWidthValue, 1};
    Manager::nodeAPI_->setAttribute(scroll, NODE_WIDTH, &scrollWidthItem);
    ArkUI_NumberValue scrollHeightValue[] = {750};
    ArkUI_AttributeItem scrollHeightItem = {scrollHeightValue, 1};
    Manager::nodeAPI_->setAttribute(scroll, NODE_HEIGHT, &scrollHeightItem);
    ArkUI_AttributeItem scrollNodeIdItem = {.string = "testScroll"};
    Manager::nodeAPI_->setAttribute(scroll, NODE_ID, &scrollNodeIdItem);
}

// 打印HitTestMode相关信息
void PrintHitTestModeInfo(int32_t hitTestMode)
{
    switch (hitTestMode) {
        case ARKUI_HIT_TEST_MODE_DEFAULT:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode",
                         "Mode: DEFAULT - Default hit test behavior");
            break;
        case ARKUI_HIT_TEST_MODE_TRANSPARENT:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "Mode: TRANSPARENT - Events pass through");
            break;
        case ARKUI_HIT_TEST_MODE_BLOCK:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "Mode: BLOCK - Block hit test behavior");
            break;
        case ARKUI_HIT_TEST_MODE_NONE:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "Mode: NONE - No hit test");
            break;
        case ARKUI_HIT_TEST_MODE_BLOCK_HIERARCHY:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode",
                         "Mode: BLOCK_HIERARCHY - Block hierarchy hit test behavior");
            break;
        case ARKUI_HIT_TEST_MODE_BLOCK_DESCENDANTS:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode",
                         "Mode: BLOCK_DESCENDANTS - Block descendants hit test behavior");
            break;
        default:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "Mode: Unknown (%{public}d)", hitTestMode);
            break;
    }
}

// 创建使用HitTestMode的组件
ArkUI_NodeHandle CreateComponentWithHitTestMode(int32_t hitTestMode)
{
    ArkUI_NodeHandle textNode1 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem contentItem;
    switch (hitTestMode) {
        case ARKUI_HIT_TEST_MODE_DEFAULT:
            contentItem = {.string = "ARKUI_HIT_TEST_MODE_DEFAULT"};
            break;
        case ARKUI_HIT_TEST_MODE_TRANSPARENT:
            contentItem = {.string = "ARKUI_HIT_TEST_MODE_TRANSPARENT"};
            break;
        case ARKUI_HIT_TEST_MODE_BLOCK:
            contentItem = {.string = "ARKUI_HIT_TEST_MODE_BLOCK"};
            break;
        case ARKUI_HIT_TEST_MODE_NONE:
            contentItem = {.string = "ARKUI_HIT_TEST_MODE_NONE"};
            break;
        case ARKUI_HIT_TEST_MODE_BLOCK_HIERARCHY:
            contentItem = {.string = "ARKUI_HIT_TEST_MODE_BLOCK_HIERARCHY"};
            break;
        case ARKUI_HIT_TEST_MODE_BLOCK_DESCENDANTS:
            contentItem = {.string = "ARKUI_HIT_TEST_MODE_BLOCK_DESCENDANTS"};
            break;
        default:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "Mode: Unknown (%{public}d)", hitTestMode);
            break;
    }
    Manager::nodeAPI_->setAttribute(textNode1, NODE_TEXT_CONTENT, &contentItem);
    ArkUI_NumberValue widthValue[] = {300};
    ArkUI_AttributeItem widthItem = {widthValue, 1};
    Manager::nodeAPI_->setAttribute(textNode1, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue heightValue[] = {100};
    ArkUI_AttributeItem heightItem = {heightValue, 1};
    Manager::nodeAPI_->setAttribute(textNode1, NODE_HEIGHT, &heightItem);
    ArkUI_NumberValue bgColorValue[] = {{.u32 = 0xFFFFC107}};
    ArkUI_AttributeItem bgColorItem = {bgColorValue, 1};
    Manager::nodeAPI_->setAttribute(textNode1, NODE_BACKGROUND_COLOR, &bgColorItem);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "Setting HitTestMode to: %{public}d", hitTestMode);
    PrintHitTestModeInfo(hitTestMode);
    ArkUI_NumberValue hitTestValue[] = {{.i32 = hitTestMode}};
    ArkUI_AttributeItem hitTestItem = {hitTestValue, 1};
    int32_t result = Manager::nodeAPI_->setAttribute(textNode1, NODE_HIT_TEST_BEHAVIOR, &hitTestItem);
    if (result != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "HitTestMode",
                     "Failed to set HitTestMode, error code: %{public}d", result);
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "Successfully set HitTestMode");
    }
    return textNode1;
}

// 创建重叠组件以演示HitTestMode效果
ArkUI_NodeHandle CreateHitTestModeDemo()
{
    ArkUI_NodeHandle container = Manager::nodeAPI_->createNode(ARKUI_NODE_STACK);
    // 设置容器尺寸
    ArkUI_NumberValue containerWidthValue[] = {400};
    ArkUI_AttributeItem containerWidthItem = {containerWidthValue, 1};
    Manager::nodeAPI_->setAttribute(container, NODE_WIDTH, &containerWidthItem);
    ArkUI_NumberValue containerHeightValue[] = {500};
    ArkUI_AttributeItem containerHeightItem = {containerHeightValue, 1};
    Manager::nodeAPI_->setAttribute(container, NODE_HEIGHT, &containerHeightItem);
    // 创建背景组件 - DEFAULT模式
    ArkUI_NodeHandle backgroundComponent = CreateComponentWithHitTestMode(ARKUI_HIT_TEST_MODE_DEFAULT);
    ArkUI_AttributeItem bgContentItem = {.string = "Background: DEFAULT Mode"};
    Manager::nodeAPI_->setAttribute(backgroundComponent, NODE_TEXT_CONTENT, &bgContentItem);
    ArkUI_NumberValue bgBgColorValue[] = {{.u32 = 0xFF2196F3}};
    ArkUI_AttributeItem bgBgColorItem = {bgBgColorValue, 1};
    Manager::nodeAPI_->setAttribute(backgroundComponent, NODE_BACKGROUND_COLOR, &bgBgColorItem);
    Manager::nodeAPI_->addChild(container, backgroundComponent);
    // 创建中间组件 - TRANSPARENT模式
    ArkUI_NodeHandle transparentComponent = CreateComponentWithHitTestMode(ARKUI_HIT_TEST_MODE_TRANSPARENT);
    ArkUI_AttributeItem transContentItem = {.string = "Middle: TRANSPARENT Mode"};
    Manager::nodeAPI_->setAttribute(transparentComponent, NODE_TEXT_CONTENT, &transContentItem);
    ArkUI_NumberValue transBgColorValue[] = {{.u32 = 0xFF4CAF50}};
    ArkUI_AttributeItem transBgColorItem = {transBgColorValue, 1};
    Manager::nodeAPI_->setAttribute(transparentComponent, NODE_BACKGROUND_COLOR, &transBgColorItem);
    // 调整位置使其与背景组件重叠
    ArkUI_NumberValue transPositionValue[] = {{.f32 = 50.0f}, {.f32 = 50.0f}};
    ArkUI_AttributeItem transPositionItem = {transPositionValue, 2};
    Manager::nodeAPI_->setAttribute(transparentComponent, NODE_POSITION, &transPositionItem);
    Manager::nodeAPI_->addChild(container, transparentComponent);
    // 创建前景组件 - DEFAULT模式
    ArkUI_NodeHandle foregroundComponent = CreateComponentWithHitTestMode(ARKUI_HIT_TEST_MODE_DEFAULT);
    ArkUI_AttributeItem fgContentItem = {.string = "Foreground: DEFAULT Mode"};
    Manager::nodeAPI_->setAttribute(foregroundComponent, NODE_TEXT_CONTENT, &fgContentItem);
    ArkUI_NumberValue fgBgColorValue[] = {{.u32 = 0xFFF44336}};
    ArkUI_AttributeItem fgBgColorItem = {fgBgColorValue, 1};
    Manager::nodeAPI_->setAttribute(foregroundComponent, NODE_BACKGROUND_COLOR, &fgBgColorItem);
    // 调整位置使其与其它组件重叠
    ArkUI_NumberValue fgPositionValue[] = {{.f32 = 100.0f}, {.f32 = 100.0f}};
    ArkUI_AttributeItem fgPositionItem = {fgPositionValue, 2};
    Manager::nodeAPI_->setAttribute(foregroundComponent, NODE_POSITION, &fgPositionItem);
    Manager::nodeAPI_->addChild(container, foregroundComponent);
    return container;
}

void PrintVisibilityInfo(int32_t visibility)
{
    switch (visibility) {
        case ARKUI_VISIBILITY_VISIBLE:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Visibility",
                         "Visibility: VISIBLE - Component is visible");
            break;
        case ARKUI_VISIBILITY_HIDDEN:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Visibility",
                         "Visibility: HIDDEN - Component is hidden but occupies space");
            break;
        case ARKUI_VISIBILITY_NONE:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Visibility",
                         "Visibility: NONE - Component is invisible and doesn't occupy space");
            break;
        default:
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Visibility",
                         "Visibility: Unknown (%{public}d)", visibility);
            break;
    }
}

// 创建带有Visibility属性的组件
ArkUI_NodeHandle CreateComponentWithVisibility(const char *name, int32_t visibility, uint32_t bgColor)
{
    ArkUI_NodeHandle textNode = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    std::stringstream statusStr;
    statusStr << name << ":" ;
    switch (visibility) {
        case ARKUI_VISIBILITY_VISIBLE:
            statusStr << "VISIBLE";
            break;
        case ARKUI_VISIBILITY_HIDDEN:
            statusStr << "HIDDEN";
            break;
        case ARKUI_VISIBILITY_NONE:
            statusStr << "NONE";
            break;
        default:
            statusStr << "Unknown";
            break;
    }
    std::string textContent = statusStr.str();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Visibility",
                 "Setting text content to: %{public}s", textContent.c_str());
    ArkUI_AttributeItem contentItem = {.string = textContent.c_str()};
    Manager::nodeAPI_->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
    ArkUI_NumberValue widthValue[] = {250};
    ArkUI_AttributeItem widthItem = {widthValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue heightValue[] = {80};
    ArkUI_AttributeItem heightItem = {heightValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_HEIGHT, &heightItem);
    ArkUI_NumberValue marginValue[] = {20};
    ArkUI_AttributeItem marginItem = {marginValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_MARGIN, &marginItem);
    ArkUI_NumberValue bgColorValue[] = {{.u32 = bgColor}};
    ArkUI_AttributeItem bgColorItem = {bgColorValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_BACKGROUND_COLOR, &bgColorItem);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Visibility",
                 "Setting Visibility for '%{public}s' to: %{public}d", name, visibility);
    PrintVisibilityInfo(visibility);
    ArkUI_NumberValue visibilityValue[] = {{.i32 = visibility}};
    ArkUI_AttributeItem visibilityItem = {visibilityValue, 1};
    int32_t result = Manager::nodeAPI_->setAttribute(textNode, NODE_VISIBILITY, &visibilityItem);
    if (result != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Visibility",
                     "Failed to set Visibility for '%{public}s', error code: %{public}d", name, result);
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Visibility", "Successfully set Visibility for '%{public}s'",
                     name);
    }
    return textNode;
}

// 创建Visibility演示场景
ArkUI_NodeHandle CreateVisibilityDemo()
{
    auto container = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue containerWidthValue[] = {400};
    ArkUI_AttributeItem containerWidthItem = {containerWidthValue, 1};
    Manager::nodeAPI_->setAttribute(container, NODE_WIDTH, &containerWidthItem);
    ArkUI_NumberValue containerHeightValue[] = {600};
    ArkUI_AttributeItem containerHeightItem = {containerHeightValue, 1};
    Manager::nodeAPI_->setAttribute(container, NODE_HEIGHT, &containerHeightItem);
    ArkUI_NodeHandle title = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem titleContentItem = {.string = "ArkUI Visibility Demo"};
    Manager::nodeAPI_->setAttribute(title, NODE_TEXT_CONTENT, &titleContentItem);
    ArkUI_NumberValue titleWidthValue[] = {400};
    ArkUI_AttributeItem titleWidthItem = {titleWidthValue, 1};
    Manager::nodeAPI_->setAttribute(title, NODE_WIDTH, &titleWidthItem);
    ArkUI_NumberValue titleHeightValue[] = {60};
    ArkUI_AttributeItem titleHeightItem = {titleHeightValue, 1};
    Manager::nodeAPI_->setAttribute(title, NODE_HEIGHT, &titleHeightItem);
    ArkUI_NumberValue titleBgColorValue[] = {{.u32 = 0xFF9C27B0}};
    ArkUI_AttributeItem titleBgColorItem = {titleBgColorValue, 1};
    Manager::nodeAPI_->setAttribute(title, NODE_BACKGROUND_COLOR, &titleBgColorItem);
    Manager::nodeAPI_->addChild(container, title);
    ArkUI_NodeHandle instruction = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem instructionContentItem = {.string = "Different Visibility modes demonstration:"};
    Manager::nodeAPI_->setAttribute(instruction, NODE_TEXT_CONTENT, &instructionContentItem);
    ArkUI_NumberValue instructionWidthValue[] = {400};
    ArkUI_AttributeItem instructionWidthItem = {instructionWidthValue, 1};
    Manager::nodeAPI_->setAttribute(instruction, NODE_WIDTH, &instructionWidthItem);
    ArkUI_NumberValue instructionHeightValue[] = {40};
    ArkUI_AttributeItem instructionHeightItem = {instructionHeightValue, 1};
    Manager::nodeAPI_->setAttribute(instruction, NODE_HEIGHT, &instructionHeightItem);
    Manager::nodeAPI_->addChild(container, instruction);
    ArkUI_NodeHandle hiddenComponent =
        CreateComponentWithVisibility("Hidden Component", ARKUI_VISIBILITY_HIDDEN, 0xFFFF9800);
    if (hiddenComponent) {
        Manager::nodeAPI_->addChild(container, hiddenComponent);
    }
    ArkUI_NodeHandle visibleComponent =
        CreateComponentWithVisibility("Visible Component", ARKUI_VISIBILITY_VISIBLE, 0xFF4CAF50);
    if (visibleComponent) {
        Manager::nodeAPI_->addChild(container, visibleComponent);
    }
    ArkUI_NodeHandle noneComponent = CreateComponentWithVisibility("None Component", ARKUI_VISIBILITY_NONE, 0xFFF44336);
    if (noneComponent) {
        Manager::nodeAPI_->addChild(container, noneComponent);
    }
    return container;
}

// @Styles normalStyles(): void
void ApplyNormalStyles(ArkUI_NodeHandle node)
{
    if (!node) {
        return;
    }
    // .backgroundColor("#0A59F7")
    ArkUI_NumberValue bgColorValue[] = {{.u32 = 0xFF0A59F7}};
    ArkUI_AttributeItem bgColorItem = {bgColorValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BACKGROUND_COLOR, &bgColorItem);

    // .borderRadius(10)
    ArkUI_NumberValue borderRadiusValue[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem borderRadiusItem = {borderRadiusValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BORDER_RADIUS, &borderRadiusItem);

    // .borderStyle(BorderStyle.Solid)
    ArkUI_NumberValue borderStyleValue[] = {{.i32 = ARKUI_BORDER_STYLE_SOLID}};
    ArkUI_AttributeItem borderStyleItem = {borderStyleValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BORDER_STYLE, &borderStyleItem);

    // .borderWidth(2)
    ArkUI_NumberValue borderWidthValue[] = {{.f32 = 2.0f}};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BORDER_WIDTH, &borderWidthItem);

    // .borderColor("#33000000")
    ArkUI_NumberValue borderColorValue[] = {{.u32 = 0x33000000}};
    ArkUI_AttributeItem borderColorItem = {borderColorValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BORDER_COLOR, &borderColorItem);

    // .width(100)
    ArkUI_NumberValue widthValue[] = {{.f32 = 300.0f}};
    ArkUI_AttributeItem widthItem = {widthValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH, &widthItem);

    // .height(25)
    ArkUI_NumberValue heightValue[] = {{.f32 = 100.0f}};
    ArkUI_AttributeItem heightItem = {heightValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &heightItem);

    // .opacity(1)
    ArkUI_NumberValue opacityValue[] = {{.f32 = 1.0f}};
    ArkUI_AttributeItem opacityItem = {opacityValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_OPACITY, &opacityItem);
}

// 创建Text("normal")组件并应用normalStyles
ArkUI_NodeHandle CreateNormalTextComponent()
{
    // 创建文本组件
    static ArkUI_NodeHandle textNode = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    if (!textNode) {
        return nullptr;
    }

    // .fontSize(14)
    ArkUI_NumberValue fontSizeValue[] = {{.f32 = 14.0f}};
    ArkUI_AttributeItem fontSizeItem = {fontSizeValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_FONT_SIZE, &fontSizeItem);

    // .fontColor(Color.White)
    ArkUI_NumberValue fontColorValue[] = {{.u32 = 0xFFFFFFFF}};
    ArkUI_AttributeItem fontColorItem = {fontColorValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_FONT_COLOR, &fontColorItem);

    // .opacity(0.5)
    ArkUI_NumberValue opacityValue[] = {{.f32 = 0.5f}};
    ArkUI_AttributeItem opacityItem = {opacityValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_OPACITY, &opacityItem);

    // .stateStyles({ normal: this.normalStyles })
    ApplyNormalStyles(textNode);

    // .margin({ bottom: 20 })
    ArkUI_NumberValue marginBottomValue[] = {{.f32 = 20.0f}};
    ArkUI_AttributeItem marginBottomItem = {marginBottomValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_MARGIN, &marginBottomItem);

    // .textAlign(TextAlign.Center)
    ArkUI_NumberValue textAlignValue[] = {{.i32 = ARKUI_TEXT_ALIGNMENT_CENTER}};
    ArkUI_AttributeItem textAlignItem = {textAlignValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_TEXT_ALIGN, &textAlignItem);

    // 设置文本内容
    ArkUI_AttributeItem contentItem = {.string = "normal"};
    Manager::nodeAPI_->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);

    return textNode;
}

// 创建Text(this.isEnable == true ? "effective" : "disabled")组件并应用disabledStyles
ArkUI_NodeHandle CreateEnableDisableTextComponent()
{
    // 创建文本组件
    static ArkUI_NodeHandle textNode = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue bgColorValue[] = {{.u32 = 0xFF0A59F7}};
    ArkUI_AttributeItem bgColorItem = {bgColorValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_BACKGROUND_COLOR, &bgColorItem);
    ArkUI_NumberValue borderRadiusValue[] = {{.f32 = 20.0f}};
    ArkUI_AttributeItem borderRadiusItem = {borderRadiusValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_BORDER_RADIUS, &borderRadiusItem);
    ArkUI_NumberValue borderStyleValue[] = {{.i32 = ARKUI_BORDER_STYLE_SOLID}};
    ArkUI_AttributeItem borderStyleItem = {borderStyleValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_BORDER_STYLE, &borderStyleItem);
    ArkUI_NumberValue borderWidthValue[] = {{.f32 = 2.0f}};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_BORDER_WIDTH, &borderWidthItem);
    ArkUI_NumberValue borderColorValue[] = {{.u32 = 0xFF808080}};
    ArkUI_AttributeItem borderColorItem = {borderColorValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_BORDER_COLOR, &borderColorItem);
    ArkUI_NumberValue widthValue[] = {{.f32 = 300.0f}};
    ArkUI_AttributeItem widthItem = {widthValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue heightValue[] = {{.f32 = 100.0f}};
    ArkUI_AttributeItem heightItem = {heightValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_HEIGHT, &heightItem);
    ArkUI_NumberValue opacityValue[] = {{.f32 = 1.0f}};
    ArkUI_AttributeItem opacityItem = {opacityValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_OPACITY, &opacityItem);
    ArkUI_NumberValue fontSizeValue[] = {{.f32 = 14.0f}};
    ArkUI_AttributeItem fontSizeItem = {fontSizeValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_FONT_SIZE, &fontSizeItem);
    ArkUI_NumberValue fontColorValue[] = {{.u32 = 0xFFFFFFFF}};
    ArkUI_AttributeItem fontColorItem = {fontColorValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_FONT_COLOR, &fontColorItem);
    ArkUI_NumberValue enabledValue[] = {{.i32 = g_isEnable ? 1 : 0}};
    ArkUI_AttributeItem enabledItem = {enabledValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_ENABLED, &enabledItem);
    ArkUI_NumberValue textAlignValue[] = {{.i32 = ARKUI_TEXT_ALIGNMENT_CENTER}};
    ArkUI_AttributeItem textAlignItem = {textAlignValue, 1};
    Manager::nodeAPI_->setAttribute(textNode, NODE_TEXT_ALIGN, &textAlignItem);
    const char *textContent = g_isEnable ? "effective" : "disabled";
    ArkUI_AttributeItem contentItem = {.string = textContent};
    Manager::nodeAPI_->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
    return textNode;
}

void ApplyDisabledStyles(ArkUI_NodeHandle node)
{
    // .backgroundColor("#E5E5E5")
    ArkUI_NumberValue bgColorValue[] = {{.u32 = 0xFFE5E5E5}};
    ArkUI_AttributeItem bgColorItem = {bgColorValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BACKGROUND_COLOR, &bgColorItem);

    // .borderRadius(10)
    ArkUI_NumberValue borderRadiusValue[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem borderRadiusItem = {borderRadiusValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BORDER_RADIUS, &borderRadiusItem);

    // .borderStyle(BorderStyle.Solid)
    ArkUI_NumberValue borderStyleValue[] = {{.i32 = ARKUI_BORDER_STYLE_SOLID}};
    ArkUI_AttributeItem borderStyleItem = {borderStyleValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BORDER_STYLE, &borderStyleItem);

    // .borderWidth(2)
    ArkUI_NumberValue borderWidthValue[] = {{.f32 = 2.0f}};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BORDER_WIDTH, &borderWidthItem);

    // .borderColor("#2a4c1919")
    ArkUI_NumberValue borderColorValue[] = {{.u32 = 0xFF2a4c19}};
    ArkUI_AttributeItem borderColorItem = {borderColorValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_BORDER_COLOR, &borderColorItem);

    // .width(90)
    ArkUI_NumberValue widthValue[] = {{.f32 = 300.0f}};
    ArkUI_AttributeItem widthItem = {widthValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH, &widthItem);

    // .height(25)
    ArkUI_NumberValue heightValue[] = {{.f32 = 100.0f}};
    ArkUI_AttributeItem heightItem = {heightValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &heightItem);

    // .opacity(1)
    ArkUI_NumberValue opacityValue[] = {{.f32 = 1.0f}};
    ArkUI_AttributeItem opacityItem = {opacityValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_OPACITY, &opacityItem);
}

// UI状态变化处理函数
void StatesChangeHandler(int32_t currentStates, void *userData)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "UIStates", "UI state changed to: %{public}d", currentStates);
    // 根据当前状态调整UI样式
    if (currentStates == ArkUI_UIState::UI_STATE_NORMAL) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "UIStates", "Button is in NORMAL state");
    } else {
        if (currentStates & ArkUI_UIState::UI_STATE_PRESSED) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo UIStates", "Button is PRESSED");
        }
        if (currentStates & ArkUI_UIState::UI_STATE_FOCUSED) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo UIStates", "Button is FOCUSED");
        }
        if (currentStates & ArkUI_UIState::UI_STATE_DISABLED) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo UIStates", "Button is DISABLED");
        }
        if (currentStates & ArkUI_UIState::UI_STATE_SELECTED) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo UIStates", "Button is SELECTED");
        }
    }
}

void TargetIdTwo()
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot", "C-api test demo create gs button1");
    auto options = OH_ArkUI_CreateSnapshotOptions();
    auto scale = 0.5;
    OH_ArkUI_SnapshotOptions_SetScale(options, scale);
    auto createPixelMapRet = OH_ArkUI_GetNodeSnapshot(image, options, &pixelMap);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                 "C-api test demo create pixelmap result is %{public}d", createPixelMapRet);
    uint32_t byteCnt = 0;
    OH_PixelmapNative_GetByteCount(pixelMap, &byteCnt);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot", "C-api test demo byteCnt is %{public}u",
                 byteCnt);
    if (!pixelMap) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot", "C-api test demo pixelMap is nullptr");
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                     "C-api test demo pixelMap is not nullptr");
    }
    auto drawable = OH_ArkUI_DrawableDescriptor_CreateFromPixelMap(pixelMap);
    if (!drawable) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot", "C-api test demo drawable is nullptr");
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                     "C-api test demo drawable is not nullptr");
    }
    ArkUI_AttributeItem NODE_IMAGE2_SRC_Item = {.object = drawable};
    auto rel = Manager::nodeAPI_->setAttribute(image2, NODE_IMAGE_SRC, &NODE_IMAGE2_SRC_Item);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                 "C-api test demo pixelMap setAttribute result is %{public}d", rel);
    OH_PixelmapNative_Release(pixelMap);
}

void TargetIdThree()
{
    // 动态切换scale
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot", "C-api test demo create gs button2");
    g_num++;
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                 "C-api test demo g_num is %{public}d g_a[g_num] is %{public}d", g_num, g_a[g_num]);
    auto options = OH_ArkUI_CreateSnapshotOptions();
    auto result = OH_ArkUI_SnapshotOptions_SetScale(options, g_a[g_num]);
    if (result != ARKUI_ERROR_CODE_COMPONENT_SNAPSHOT_TIMEOUT && result != ARKUI_ERROR_CODE_BUFFER_SIZE_NOT_ENOUGH) {
        auto createPixelMapRet = OH_ArkUI_GetNodeSnapshot(image, options, &pixelMap);
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                     "C-api test demo create pixelmap result is %{public}d", createPixelMapRet);
        uint32_t byteCnt = 0;
        OH_PixelmapNative_GetByteCount(pixelMap, &byteCnt);
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot", "C-api test demo byteCnt is %{public}u",
                     byteCnt);

        if (!pixelMap) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                         "C-api test demo pixelMap is nullptr");
        } else {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                         "C-api test demo pixelMap is not nullptr");
        }
        auto drawable = OH_ArkUI_DrawableDescriptor_CreateFromPixelMap(pixelMap);
        if (!drawable) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                         "C-api test demo drawable is nullptr");
        } else {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                         "C-api test demo drawable is not nullptr");
        }
        ArkUI_AttributeItem NODE_IMAGE2_SRC_Item = {.object = drawable};
        auto rel = Manager::nodeAPI_->setAttribute(image2, NODE_IMAGE_SRC, &NODE_IMAGE2_SRC_Item);
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                     "C-api test demo pixelMap setAttribute result is %{public}d", rel);

        OH_PixelmapNative_Release(pixelMap);
        if (g_num >= g_arrayLength - 1) {
            g_num = 0;
        }
    }
}

void TargetIdFour()
{
    // 动态切换图片类型
    g_num1++;
    NODE_IMAGE_SRC_Item = {.string = g_b[g_num1]};
    Manager::nodeAPI_->setAttribute(image, NODE_IMAGE_SRC, &NODE_IMAGE_SRC_Item);
    if (g_num1 >= g_arrayLength1 - 1) {
        g_num1 = 0;
    }
}

void TargetIdFive()
{
    if (!options_test) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                     "C-api test demo options_test is nullptr");
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ComponentSnapshot",
                     "C-api test demo options_test is not nullptr");
    }
    OH_ArkUI_DestroySnapshotOptions(options_test);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot", "C-api test Snapshot is destroied");
}

void EnableDisableText(ArkUI_NodeEventType eventType, int32_t targetId, ArkUI_NodeHandle node)
{
    auto gestureEvent = OH_ArkUI_GestureEvent_GetRawInputEvent(nullptr);
    auto resultCloned = OH_ArkUI_PointerEvent_PostClonedEvent(node, gestureEvent);
    if (resultCloned != ARKUI_ERROR_CODE_NOT_CLONED_POINTER_EVENT &&
        resultCloned != ARKUI_ERROR_CODE_POST_CLONED_COMPONENT_STATUS_ABNORMAL &&
        resultCloned != ARKUI_ERROR_CODE_POST_CLONED_NO_COMPONENT_HIT_TO_RESPOND_TO_THE_EVENT) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentCloned",
                     "C-api test demo clone event result is %{public}d", resultCloned);
    }
    bool ret = false;
    auto gestureEventResult = OH_ArkUI_GestureEventTargetInfo_IsScrollBegin(nullptr, &ret);
    if (gestureEventResult != ARKUI_ERROR_CODE_NON_SCROLLABLE_CONTAINER) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "GestureEvent",
                     "C-api test demo gesture event result is %{public}d", gestureEventResult);
    }
    bool isRepeat = true;
    auto gestureParamResult = OH_ArkUI_GetGestureParam_repeat(nullptr, &isRepeat);
    if (gestureParamResult != ARKUI_ERROR_CODE_RECOGNIZER_TYPE_NOT_SUPPORTED) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "GestureParam",
                     "C-api test demo gesture param result is %{public}d", gestureParamResult);
    }
    auto requestDragResult = OH_ArkUI_DragEvent_RequestDragEndPending(nullptr, nullptr);
    if (requestDragResult != ARKUI_ERROR_CODE_DRAG_DROP_OPERATION_NOT_ALLOWED) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "RequestDrag",
                     "C-api test demo request drag result is %{public}d", gestureParamResult);
    }
    if (g_isEnable == true) {
        g_isEnable = false;
        ApplyDisabledStyles(node);
        auto result =
            OH_ArkUI_AddSupportedUIStates(node, ArkUI_UIState::UI_STATE_DISABLED, StatesChangeHandler, true, nullptr);
        if (result != ARKUI_ERROR_CODE_POST_CLONED_NO_COMPONENT_HIT_TO_RESPOND_TO_THE_EVENT) {
            const char *textContent = g_isEnable ? "effective" : "disabled";
            ArkUI_AttributeItem contentItem = {.string = textContent};
            Manager::nodeAPI_->setAttribute(node, NODE_TEXT_CONTENT, &contentItem);
        }
    } else {
        g_isEnable = true;
        ApplyNormalStyles(node);
        auto result =
            OH_ArkUI_AddSupportedUIStates(node, ArkUI_UIState::UI_STATE_NORMAL, StatesChangeHandler, true, nullptr);
        const char *textContent = g_isEnable ? "effective" : "disabled";
        ArkUI_AttributeItem contentItem = {.string = textContent};
        Manager::nodeAPI_->setAttribute(node, NODE_TEXT_CONTENT, &contentItem);
    }
}

void AllRegisterNodeEventReceiver()
{
    Manager::nodeAPI_->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        auto targetId = OH_ArkUI_NodeEvent_GetTargetId(event);
        switch (eventType) {
            case NODE_ON_CLICK: {
                switch (targetId) {
                    case TARGET_ID_2: {
                        TargetIdTwo();
                        break;
                    }
                    case TARGET_ID_3: {
                        TargetIdThree();
                        break;
                    }
                    case TARGET_ID_4: {
                        TargetIdFour();
                        break;
                    }
                    case TARGET_ID_5: {
                        TargetIdFive();
                        break;
                    }
                    case TARGET_ID_6: {
                        auto node = OH_ArkUI_NodeEvent_GetNodeHandle(event);
                        EnableDisableText(eventType, targetId, node);
                        break;
                    }
                    default:
                        break;
                }
            }
            default:
                break;
        }
    });
}

void SnapshotOptionsDemo(ArkUI_NodeHandle &touchEvent)
{
    auto button = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_AttributeItem LABEL_Item = {.string = "截图"};
    Manager::nodeAPI_->setAttribute(button, NODE_BUTTON_LABEL, &LABEL_Item);
    Manager::nodeAPI_->addChild(touchEvent, button);
    auto button1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_AttributeItem LABEL_Item1 = {.string = "动态切换scale并截图"};
    Manager::nodeAPI_->setAttribute(button1, NODE_BUTTON_LABEL, &LABEL_Item1);
    Manager::nodeAPI_->addChild(touchEvent, button1);
    auto button2 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_AttributeItem LABEL_Item2 = {.string = "动态切换图片类型"};
    Manager::nodeAPI_->setAttribute(button2, NODE_BUTTON_LABEL, &LABEL_Item2);
    Manager::nodeAPI_->addChild(touchEvent, button2);
    auto button3 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_AttributeItem LABEL_Item3 = {.string = "销毁截图选项"};
    Manager::nodeAPI_->setAttribute(button3, NODE_BUTTON_LABEL, &LABEL_Item3);
    Manager::nodeAPI_->addChild(touchEvent, button3);
    Manager::nodeAPI_->registerNodeEvent(button, NODE_ON_CLICK, TARGET_ID_2, nullptr);
    Manager::nodeAPI_->registerNodeEvent(button1, NODE_ON_CLICK, TARGET_ID_3, nullptr);
    Manager::nodeAPI_->registerNodeEvent(button2, NODE_ON_CLICK, TARGET_ID_4, nullptr);
    Manager::nodeAPI_->registerNodeEvent(button3, NODE_ON_CLICK, TARGET_ID_5, nullptr);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ComponentSnapshot", "nodeAPI %p", Manager::nodeAPI_);
    image = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE);
    NODE_IMAGE_SRC_Item = {.string = g_b[g_num1]};
    ArkUI_NumberValue imageWidthValue[] = {150};
    ArkUI_AttributeItem imageWidthItem = {imageWidthValue, 1};
    ArkUI_NumberValue imageHeightValue[] = {150};
    ArkUI_AttributeItem imageHeightItem = {imageHeightValue, 1};
    Manager::nodeAPI_->setAttribute(image, NODE_WIDTH, &imageWidthItem);
    Manager::nodeAPI_->setAttribute(image, NODE_HEIGHT, &imageHeightItem);
    Manager::nodeAPI_->setAttribute(image, NODE_IMAGE_SRC, &NODE_IMAGE_SRC_Item);
    Manager::nodeAPI_->addChild(touchEvent, image);
    ArkUI_AttributeItem NODE_IMAGE2_SRC_Item = {.string = "/pages/common/background.png"};
    ArkUI_AttributeItem attributeItem = {};
    ArkUI_NumberValue numberValue = {};
    numberValue.i32 = static_cast<int32_t>(ArkUI_ObjectFit::ARKUI_OBJECT_FIT_NONE);
    attributeItem.value = &numberValue;
    attributeItem.size = 1;
    image2 = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE);
    auto objectFit = ArkUI_ObjectFit::ARKUI_OBJECT_FIT_NONE;
    Manager::nodeAPI_->setAttribute(image2, NODE_WIDTH, &imageWidthItem);
    Manager::nodeAPI_->setAttribute(image2, NODE_HEIGHT, &imageHeightItem);
    Manager::nodeAPI_->setAttribute(image2, NODE_IMAGE_OBJECT_FIT, &attributeItem);
    Manager::nodeAPI_->setAttribute(image2, NODE_IMAGE_SRC, &NODE_IMAGE2_SRC_Item);
    Manager::nodeAPI_->addChild(touchEvent, image2);
    AllRegisterNodeEventReceiver();
}

void AddScrollChild(ArkUI_NodeHandle &scroll)
{
    ArkUI_NumberValue borderWidthValue[] = {2};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    ArkUI_NodeHandle column1 = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    Manager::nodeAPI_->setAttribute(column1, NODE_BORDER_WIDTH, &borderWidthItem);
    ArkUI_NumberValue widthValue[] = {500};
    ArkUI_AttributeItem widthItem = {widthValue, 1};
    Manager::nodeAPI_->setAttribute(column1, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue heightValue[] = {600};
    ArkUI_AttributeItem heightItem = {heightValue, 1};
    Manager::nodeAPI_->setAttribute(column1, NODE_HEIGHT, &heightItem);
    ArkUI_NodeHandle defaultComponent = CreateComponentWithHitTestMode(ARKUI_HIT_TEST_MODE_DEFAULT);
    ArkUI_NodeHandle transparentComponent = CreateComponentWithHitTestMode(ARKUI_HIT_TEST_MODE_TRANSPARENT);
    ArkUI_NodeHandle noneComponent = CreateComponentWithHitTestMode(ARKUI_HIT_TEST_MODE_NONE);
    ArkUI_NodeHandle blockComponent = CreateComponentWithHitTestMode(ARKUI_HIT_TEST_MODE_BLOCK);
    ArkUI_NodeHandle demoContainer = CreateHitTestModeDemo();
    ArkUI_NodeHandle column2 = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    Manager::nodeAPI_->setAttribute(column2, NODE_BORDER_WIDTH, &borderWidthItem);
    ArkUI_NumberValue heightValue2[] = {800};
    ArkUI_AttributeItem heightItem2 = {heightValue2, 1};
    Manager::nodeAPI_->setAttribute(column1, NODE_HEIGHT, &heightItem2);
    ArkUI_NodeHandle demoContainer2 = CreateVisibilityDemo();
    ArkUI_NodeHandle column3 = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    Manager::nodeAPI_->setAttribute(column3, NODE_BORDER_WIDTH, &borderWidthItem);
    Manager::nodeAPI_->setAttribute(column3, NODE_HEIGHT, &heightItem);
    Manager::nodeAPI_->setAttribute(column3, NODE_WIDTH, &widthItem);
    ArkUI_NodeHandle column4 = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    Manager::nodeAPI_->setAttribute(column4, NODE_BORDER_WIDTH, &borderWidthItem);
    ArkUI_NumberValue heightValue4[] = {600};
    ArkUI_AttributeItem heightItem4 = {heightValue4, 1};
    Manager::nodeAPI_->setAttribute(column4, NODE_HEIGHT, &heightItem4);
    Manager::nodeAPI_->setAttribute(column4, NODE_WIDTH, &widthItem);
    Manager::nodeAPI_->addChild(column4, CreateNormalTextComponent());
    static auto enableDisableText = CreateEnableDisableTextComponent();
    Manager::nodeAPI_->registerNodeEvent(enableDisableText, NODE_ON_CLICK, TARGET_ID_6, nullptr);
    Manager::nodeAPI_->addChild(column4, enableDisableText);
    SnapshotOptionsDemo(column3);
    Manager::nodeAPI_->addChild(column1, defaultComponent);
    Manager::nodeAPI_->addChild(column1, transparentComponent);
    Manager::nodeAPI_->addChild(column1, noneComponent);
    Manager::nodeAPI_->addChild(column1, blockComponent);
    Manager::nodeAPI_->addChild(column1, demoContainer);
    Manager::nodeAPI_->addChild(column2, demoContainer2);
    Manager::nodeAPI_->addChild(column2, column4);
    Manager::nodeAPI_->addChild(column2, column3);
    Manager::nodeAPI_->addChild(column2, column1);
    Manager::nodeAPI_->addChild(scroll, column2);
}

ArkUI_NodeHandle PublicMaker::CreateNativeNode()
{
    if (!Manager::nodeAPI_) {
        return nullptr;
    }
    // 创建父子滚动容器
    ArkUI_NodeHandle scroll = Manager::nodeAPI_->createNode(ARKUI_NODE_SCROLL);
    // 设置属性
    SetScrollAttribute(scroll);
    AddScrollChild(scroll);
    return scroll;
}