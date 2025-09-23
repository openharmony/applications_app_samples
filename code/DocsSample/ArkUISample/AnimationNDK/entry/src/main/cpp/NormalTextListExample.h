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

#ifndef MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H
#define MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H

#include "ArkUIBaseNode.h"
#include "ArkUIListItemNode.h"
#include "ArkUIListNode.h"
#include "ArkUITextNode.h"
#include <hilog/log.h>

namespace NativeModule {
constexpr int32_t LISTNUM_0 = 0;
constexpr int32_t LISTNUM_1 = 1;
constexpr int32_t NUM_16 = 16;
constexpr int32_t LISTNUM_30 = 30;
constexpr int32_t LISTNUM_100 = 100;
constexpr int32_t LISTNUM_300 = 300;

std::shared_ptr<ArkUIBaseNode> CreateTextListExample()
{
    // 创建组件并挂载
    // 1：使用智能指针创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(LISTNUM_1);
    list->SetPercentHeight(LISTNUM_1);
    list->SetScrollBarState(true);
    // 2：创建ListItem子组件并挂载到List上。
    for (int32_t i = LISTNUM_0; i < LISTNUM_30; ++i) {
        auto listItem = std::make_shared<ArkUIListItemNode>();
        auto textNode = std::make_shared<ArkUITextNode>();
        textNode->SetTextContent(std::to_string(i));
        textNode->SetFontSize(NUM_16);
        textNode->SetFontColor(0xFFff00ff);
        textNode->SetPercentWidth(LISTNUM_1);
        textNode->SetWidth(LISTNUM_300);
        textNode->SetHeight(LISTNUM_100);
        textNode->SetBackgroundColor(0xFFfffacd);
        textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
        listItem->InsertChild(textNode, i);
        list->AddChild(listItem);
    }
    return list;
}
} // namespace NativeModule

#endif // MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H