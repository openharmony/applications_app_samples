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

#ifndef CAPI0805_2_ITEMALIGNMENTEXAMPLE_REFACTORED_H
#define CAPI0805_2_ITEMALIGNMENTEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUITextNode.h"
#include <vector>

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUIBaseNode> itemAligmentExample()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto flex = std::make_shared<ArkUIFlexNode>();
    std::vector<std::shared_ptr<ArkUITextNode>> text(Counts::TEXT_NODES_MAX);

    // 创建10个文本节点并添加到Flex容器中
    for (int i = 0; i < Counts::TEXT_NODES_MAX; i++) {
        text[i] = std::make_shared<ArkUITextNode>();
        text[i]->SetTextContent(std::to_string(i));
        text[i]->SetPercentWidth(Percentages::TWENTY_PERCENT);
        text[i]->SetHeight(Sizes::MEDIUM);
        text[i]->SetBackgroundColor(Utils::GetCyclicColor(Colors::ITEM_COLORS, i));
        flex->AddChild(text[i]);
    }

    // 设置Flex容器属性
    flex->SetHeight(Sizes::HEIGHT_LARGE);
    flex->SetPercentWidth(Percentages::NINETY_PERCENT);
    flex->SetPadding(Sizes::PADDING_MEDIUM);
    flex->SetBackgroundColor(Colors::LIGHT_BLUE);

    // 设置Flex布局样式
    // 参数：方向、换行、主轴对齐、交叉轴对齐、内容对齐
    flex->SetFlexStyle(ARKUI_FLEX_DIRECTION_ROW, ARKUI_FLEX_WRAP_WRAP, ARKUI_FLEX_ALIGNMENT_START,
                       ARKUI_ITEM_ALIGNMENT_CENTER, ARKUI_FLEX_ALIGNMENT_SPACE_BETWEEN);
    column->AddChild(flex);
    return column;
}

} // namespace NativeModule
#endif // CAPI0805_2_ITEMALIGNMENTEXAMPLE_REFACTORED_H