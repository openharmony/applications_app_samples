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

#ifndef CAPI_0922_PIXELROUNDEXAMPLE_REFACTORED_H
#define CAPI_0922_PIXELROUNDEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIButtonNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRelativeContainerNode.h"
#include "nodes/ArkUITextNode.h"

namespace NativeModule {

using namespace LayoutConstants;

// 常量定义
namespace PixelRoundConstants {
constexpr float DIVISION_FACTOR = 3.25f;
constexpr float INCREMENT = 0.1f;
constexpr float SPECIFIC_HEIGHT = 300.6f;
constexpr int BUTTON_WIDTH = 200;
} // namespace PixelRoundConstants

// 像素舍入管理类 - 封装所有状态和UI组件
class PixelRoundManager {
public:
    // 状态变量
    float width;
    bool isPixelRound;
    std::string currentState;
    
    // UI组件
    std::shared_ptr<ArkUITextNode> titleText;
    std::shared_ptr<ArkUITextNode> currentStateText;
    std::shared_ptr<ArkUIButtonNode> buttonPixelRound;
    std::shared_ptr<ArkUIRowNode> pixelRoundRow;
    std::shared_ptr<ArkUIRowNode> pixelRoundFather;
    
    PixelRoundManager() : width(Sizes::GIANT), isPixelRound(true), currentState("current is pixelRound") {}
    
    // 更新宽度
    void UpdateWidth()
    {
        width += PixelRoundConstants::INCREMENT;
        pixelRoundFather->SetWidth(width / PixelRoundConstants::DIVISION_FACTOR);
        titleText->SetTextContent("current width " + std::to_string(width) + "\n");
    }
    
    // 设置像素舍入策略
    void SetPixelRoundPolicy(bool enablePixelRound)
    {
        if (enablePixelRound) {
            pixelRoundRow->SetPixelRoundExample(
                ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL,
                ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL);
            pixelRoundFather->SetPixelRoundExample(
                ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL,
                ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL);
        } else {
            pixelRoundRow->SetPixelRoundExample(
                ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND,
                ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND);
            pixelRoundFather->SetPixelRoundExample(
                ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND,
                ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND);
        }
    }
    
    // 切换像素舍入状态
    void TogglePixelRoundState()
    {
        isPixelRound = !isPixelRound;
        
        if (isPixelRound) {
            currentState = "current is pixelRound";
            currentStateText->SetTextContent(currentState);
            buttonPixelRound->SetTextContent("click change to no pixelRound");
        } else {
            currentState = "current is not pixelRound";
            currentStateText->SetTextContent(currentState);
            buttonPixelRound->SetTextContent("click change to pixelRound");
        }
        
        SetPixelRoundPolicy(isPixelRound);
    }
};

// 创建标题文本组件
std::shared_ptr<ArkUITextNode> CreateTitleText(float width)
{
    auto titleText = std::make_shared<ArkUITextNode>();
    titleText->SetTextContent("current width " + std::to_string(width) + "\n");
    return titleText;
}

// 创建像素舍入子组件
std::shared_ptr<ArkUIRowNode> CreatePixelRoundRow(const std::string& currentState,
                                                  std::shared_ptr<ArkUITextNode>& currentStateText)
{
    auto pixelRoundRow = std::make_shared<ArkUIRowNode>();
    currentStateText = std::make_shared<ArkUITextNode>();
    currentStateText->SetTextContent(currentState);

    pixelRoundRow->AddChild(currentStateText);
    pixelRoundRow->SetPercentWidth(Percentages::FULL_WIDTH);
    pixelRoundRow->SetPercentHeight(Percentages::FULL_WIDTH);
    pixelRoundRow->SetBackgroundColor(Colors::YELLOW);

    // 设置像素舍入示例
    pixelRoundRow->SetPixelRoundExample(ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL,
                                        ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL);

    return pixelRoundRow;
}

// 创建像素舍入父组件
std::shared_ptr<ArkUIRowNode> CreatePixelRoundFather(std::shared_ptr<ArkUIRowNode> pixelRoundRow, float width)
{
    auto pixelRoundFather = std::make_shared<ArkUIRowNode>();
    pixelRoundFather->AddChild(pixelRoundRow);
    pixelRoundFather->SetBackgroundColor(Colors::RED);

    // 像素取整时，父子组件会存在1px的差值
    pixelRoundFather->SetWidth(width / PixelRoundConstants::DIVISION_FACTOR);
    pixelRoundFather->SetHeight(PixelRoundConstants::SPECIFIC_HEIGHT / PixelRoundConstants::DIVISION_FACTOR);
    pixelRoundFather->SetPixelRoundExample(
        ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL,
        ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL);

    return pixelRoundFather;
}

// 创建宽度增加按钮
std::shared_ptr<ArkUIButtonNode> CreateWidthIncrementButton(std::shared_ptr<PixelRoundManager> manager)
{
    auto buttonText = std::make_shared<ArkUIButtonNode>();
    buttonText->SetTextContent("width +0.1");
    buttonText->SetWidth(PixelRoundConstants::BUTTON_WIDTH);
    buttonText->SetHeight(Sizes::BUTTON_HEIGHT);
    buttonText->SetBackgroundColor(Colors::BUTTON_BACKGROUND_COLOR);
    buttonText->SetMargin(Sizes::MARGIN_MEDIUM);

    // Lambda只需要捕获一个manager对象
    buttonText->SetOnClick([manager]() {
        manager->UpdateWidth();
    });

    return buttonText;
}

// 创建像素舍入切换按钮
std::shared_ptr<ArkUIButtonNode> CreatePixelRoundToggleButton(std::shared_ptr<PixelRoundManager> manager)
{
    auto buttonPixelRound = std::make_shared<ArkUIButtonNode>();
    buttonPixelRound->SetTextContent("click change to no pixelRound");
    buttonPixelRound->SetWidth(PixelRoundConstants::BUTTON_WIDTH);
    buttonPixelRound->SetHeight(Sizes::BUTTON_HEIGHT);
    buttonPixelRound->SetBackgroundColor(Colors::BUTTON_BACKGROUND_COLOR);
    buttonPixelRound->SetMargin(Sizes::MARGIN_MEDIUM);
    buttonPixelRound->SetButtonType(ARKUI_BUTTON_TYPE_CAPSULE);

    // Lambda只需要捕获一个manager对象
    buttonPixelRound->SetOnClick([manager]() {
        manager->TogglePixelRoundState();
    });

    return buttonPixelRound;
}

std::shared_ptr<ArkUIBaseNode> CreatePixelRoundExample()
{
    // 创建管理器对象，通过shared_ptr确保生命周期
    auto manager = std::make_shared<PixelRoundManager>();
    
    auto column = std::make_shared<ArkUIColumnNode>();

    // 创建各个组件
    manager->titleText = CreateTitleText(manager->width);
    manager->pixelRoundRow = CreatePixelRoundRow(manager->currentState, manager->currentStateText);
    manager->pixelRoundFather = CreatePixelRoundFather(manager->pixelRoundRow, manager->width);
    
    auto buttonText = CreateWidthIncrementButton(manager);
    manager->buttonPixelRound = CreatePixelRoundToggleButton(manager);

    // 将组件添加到主列容器中
    column->AddChild(manager->titleText);
    column->AddChild(manager->pixelRoundFather);
    column->AddChild(buttonText);
    column->AddChild(manager->buttonPixelRound);

    // 创建显示像素舍入配置信息的文本节点
    auto valueText = std::make_shared<ArkUITextNode>();
    auto value = manager->pixelRoundRow->SetPixelRoundExample(
        ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL,
        ARKUI_PIXELROUNDCALCPOLICY_NOFORCEROUND, ARKUI_PIXELROUNDCALCPOLICY_FORCECEIL);
    valueText->SetTextContent(value);
    column->AddChild(valueText);

    return column;
}

} // namespace NativeModule
#endif // CAPI_0922_PIXELROUNDEXAMPLE_REFACTORED_H