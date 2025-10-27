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
// [Start Cpp_NormalTextListExample]
#ifndef MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H
#define MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H

#include "ArkUIBaseNode.h"
#include "ArkUIListItemNode.h"
#include "ArkUIListNode.h"
#include "ArkUITextNode.h"
#include <hilog/log.h>

namespace NativeModule {

std::shared_ptr<ArkUIBaseNode> CreateTextListExample()
{
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1);
    list->SetPercentHeight(1);
    list->SetScrollBarState(true);
    const int itemCount = 30;
    const int fontSizes = 16;
    const int screenWidth = 300;
    const int defaultHeight = 100;
    for (int32_t i = 0; i < itemCount; ++i) {
        auto listItem = std::make_shared<ArkUIListItemNode>();
        auto textNode = std::make_shared<ArkUITextNode>();
        textNode->SetTextContent(std::to_string(i));
        textNode->SetFontSize(fontSizes);
        textNode->SetFontColor(0xFFff00ff);
        textNode->SetPercentWidth(1);
        textNode->SetWidth(screenWidth);
        textNode->SetHeight(defaultHeight);
        textNode->SetBackgroundColor(0xFFfffacd);
        textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
        listItem->InsertChild(textNode, i);
        list->AddChild(listItem);
    }
    return list;
}
}

#endif
// [End Cpp_NormalTextListExample]