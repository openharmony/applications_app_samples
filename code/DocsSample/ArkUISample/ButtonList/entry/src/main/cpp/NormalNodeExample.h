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
// [Start Cpp_NormalNodeExample]
// NormalNodeExample.h

#ifndef MYAPPLICATION_NORMALNODEEXAMPLE_H
#define MYAPPLICATION_NORMALNODEEXAMPLE_H

#include "ArkUIBaseNode.h"
#include "ArkUIListItemNode.h"
#include "ArkUIListNode.h"
#include "ArkUITextNode.h"

namespace NativeModule {

std::shared_ptr<ArkUIBaseNode> CreateExample()
{
    // 创建组件并挂载
    // 1：使用智能指针创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1);
    list->SetPercentHeight(1);
    list->SetScrollBarState(true);
    const int itemCount = 30;
    const int fontSizes = 16;
    const float screenWidth = 1;
    const float borderWidth = 2;
    const int defaultHeight = 100;
    const int defaultRadius = 8;
    const float defaultOpacity = 0.8;
    const float defaultScale = 0.8;
    const float blank = 5;
    // 2：创建ListItem子组件并挂载到List上。
    for (int32_t i = 0; i < itemCount; ++i) {
        auto listItem = std::make_shared<ArkUIListItemNode>();
        auto textNode = std::make_shared<ArkUITextNode>();
        textNode->SetTextContent(std::to_string(i));
        textNode->SetFontSize(fontSizes);
        textNode->SetFontColor(0xFF000000);
        textNode->SetPercentWidth(1);
        textNode->SetPercentWidth(screenWidth);
        textNode->SetHeight(defaultHeight);
        textNode->SetBackgroundColor(0xFFfffacd);
        textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
        textNode->SetBorderWidth(borderWidth);
        textNode->SetBorderColor(0xFF0000ff);
        textNode->SetBorderRadius(defaultRadius);
        textNode->SetMargin(blank, 0, blank, 0);
        textNode->SetPadding(0, blank, 0, blank);
        textNode->SetOpacity(defaultOpacity);
        textNode->SetScale(defaultScale, 1);
        listItem->InsertChild(textNode, i);
        list->AddChild(listItem);
    }
    return list;
}
} // namespace NativeModule

#endif // MYAPPLICATION_NORMALNODEEXAMPLE_H
// [End Cpp_NormalNodeExample]