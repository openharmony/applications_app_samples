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

#ifndef CAPI0805_2_GUIDELINEOPTIONEXAMPLE_REFACTORED_H
#define CAPI0805_2_GUIDELINEOPTIONEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRelativeContainerNode.h"
#include "nodes/ArkUITextNode.h"
#include "nodes/ArkUIRowNode.h"

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUIBaseNode> CreateGuidelineOptionExample()
{
    auto column = std::make_shared<ArkUIColumnNode>();

    // 创建相对布局容器并设置ID
    auto relativeContainer = std::make_shared<ArkUIRelativeContainerNode>();
    relativeContainer->SetId("relativeContainer");

    // 创建Row节点并设置属性
    auto row = std::make_shared<ArkUIRowNode>();
    row->SetHeight(Sizes::EXTRA_LARGE);
    row->SetWidth(Sizes::EXTRA_LARGE);
    row->SetBackgroundColor(Colors::GREEN);
    row->SetId(Utils::GenerateId(IDs::ROW_PREFIX, 1).c_str());

    // 应用引导线选项
    auto value = relativeContainer->guidelineOptionExample(row);

    // 创建显示引导线信息的文本节点
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent(value);
    column->AddChild(text);

    // 将Row节点添加到相对布局容器中
    relativeContainer->AddChild(row);

    // 设置相对布局容器的属性
    relativeContainer->SetWidth(Sizes::GIANT);
    relativeContainer->SetHeight(Sizes::GIANT);
    relativeContainer->SetMargin(0, 0, 0, Sizes::MEDIUM);
    relativeContainer->SetBorderWidth(Sizes::BORDER_WIDTH);
    relativeContainer->SetBorderColor(Colors::BLUE);
    column->AddChild(relativeContainer);

    return column;
}

} // namespace NativeModule

#endif // CAPI0805_2_GUIDELINEOPTIONEXAMPLE_REFACTORED_H
