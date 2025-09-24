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

#ifndef MYAPPLICATION_ALIGNRULEOPTIONEXAMPLE_REFACTORED_H
#define MYAPPLICATION_ALIGNRULEOPTIONEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRelativeContainerNode.h"
#include "nodes/ArkUITextNode.h"

namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUIBaseNode> CreateAlignRuleOptionExample()
{
    // 创建相对布局容器并设置ID
    auto relativeContainer = std::make_shared<ArkUIRelativeContainerNode>();
    relativeContainer->SetId(IDs::FATHER.c_str());
    int id = 1;
    // 创建第一个子列容器（黄色）
    auto child1 = std::make_shared<ArkUIColumnNode>();
    child1->SetId(Utils::GenerateId(IDs::CHILD_PREFIX, id++).c_str());
    child1->SetWidth(Sizes::EXTRA_LARGE);
    child1->SetHeight(Sizes::EXTRA_LARGE);
    child1->SetBackgroundColor(Colors::YELLOW);

    // 创建第二个子列容器（紫色）
    auto child2 = std::make_shared<ArkUIColumnNode>();
    child2->SetId(Utils::GenerateId(IDs::CHILD_PREFIX, id++).c_str());
    child2->SetWidth(Sizes::EXTRA_LARGE);
    child2->SetHeight(Sizes::EXTRA_LARGE);
    child2->SetBackgroundColor(Colors::PURPLE);

    // 创建第三个子列容器（青色）
    auto child3 = std::make_shared<ArkUIColumnNode>();
    child3->SetId(Utils::GenerateId(IDs::CHILD_PREFIX, id++).c_str());
    child3->SetWidth(Sizes::EXTRA_LARGE);
    child3->SetHeight(Sizes::EXTRA_LARGE);
    child3->SetBackgroundColor(Colors::CYAN);

    // 应用对齐规则
    auto rules = relativeContainer->alignRuleOptionExample(child1, child2, child3);

    // 将子节点添加到相对布局容器中
    relativeContainer->AddChild(child1);
    relativeContainer->AddChild(child2);
    relativeContainer->AddChild(child3);

    // 创建显示对齐规则信息的文本节点
    auto rulesText = std::make_shared<ArkUITextNode>();
    rulesText->SetTextContent(rules);
    relativeContainer->AddChild(rulesText);

    return relativeContainer;
}

} // namespace NativeModule

#endif