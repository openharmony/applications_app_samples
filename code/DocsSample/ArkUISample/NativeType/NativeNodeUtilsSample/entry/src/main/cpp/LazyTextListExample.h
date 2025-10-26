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
// [Start Grouped_List_Interface]
// LazyTextListExample.h
// 懒加载列表示例代码。
#ifndef MYAPPLICATION_LAZYTEXTLISTEXAMPLE_H
#define MYAPPLICATION_LAZYTEXTLISTEXAMPLE_H
#include "ArkUIBaseNode.h"
#include "ArkUIListNode.h"
#include "ArkUIListItemGroupNode.h"
const int HEADER_HEIGHT = 50;
const int HEADER_FONTSIZE = 16;
const int NUM = 3;
namespace NativeModule {
std::shared_ptr<ArkUIBaseNode> CreateLazyTextListExample()
{
// 创建组件并挂载
    // 1: 创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1);
    list->SetPercentHeight(1);
    // 设置吸顶
    list->SetSticky(ARKUI_STICKY_STYLE_BOTH);
    // 2: 创建ListItemGroup并挂载到List上。
    for (int32_t i = 0; i < NUM; i++) {
        auto header = std::make_shared<ArkUITextNode>();
        header->SetTextContent("header");
        header->SetFontSize(HEADER_FONTSIZE);
        header->SetPercentWidth(1);
        header->SetHeight(HEADER_HEIGHT);
        header->SetBackgroundColor(0xFFDCDCDC);
        header->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
        auto listItemGroup = std::make_shared<ArkUIListItemGroupNode>();
        listItemGroup->SetHeader(header);
        auto adapter = std::make_shared<ArkUIListItemAdapter>();
        listItemGroup->SetLazyAdapter(adapter);
        list->AddChild(listItemGroup);
    }
    return list;
}
} // namespace NativeModule
#endif // MYAPPLICATION_LAZYTEXTLISTEXAMPLE_H
// [End Grouped_List_Interface]