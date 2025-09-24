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

#ifndef MYAPPLICATION_LAYOUTCONSTRAINTEXAMPLE_REFACTORED_H
#define MYAPPLICATION_LAYOUTCONSTRAINTEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUITextNode.h"

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUIBaseNode> CreateLayoutConstraintExample()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    // 创建子列容器并设置固定尺寸
    auto child = std::make_shared<ArkUIColumnNode>();
    child->SetWidth(Sizes::EXTRA_LARGE);
    child->SetHeight(Sizes::EXTRA_LARGE);

    // 创建布局约束示例
    auto values = column->layoutConstraintExample(child);
    auto constraint = values.first; // 约束信息
    auto size = values.second;      // 尺寸信息

    auto sizeText = std::make_shared<ArkUITextNode>();
    sizeText->SetTextContent("Width : " + std::to_string(size.width) + " Height : " + std::to_string(size.height));

    auto constraintText = std::make_shared<ArkUITextNode>();
    constraintText->SetTextContent(constraint);

    column->AddChild(sizeText);
    column->AddChild(constraintText);

    child->SetBackgroundColor(Colors::LIGHT_BLUE);
    return column;
}

} // namespace NativeModule

#endif