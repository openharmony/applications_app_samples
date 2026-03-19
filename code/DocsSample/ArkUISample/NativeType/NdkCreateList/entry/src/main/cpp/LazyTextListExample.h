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
// [Start Grouped_List]
// LazyTextListExample.h
// 懒加载列表示例代码。

#ifndef MYAPPLICATION_LAZYTEXTLISTEXAMPLE_H
#define MYAPPLICATION_LAZYTEXTLISTEXAMPLE_H

#include "ArkUIBaseNode.h"
#include "ArkUIListItemAdapter.h"
#include "ArkUIListItemGroupNode.h"
#include "ArkUIListNode.h"
#include "ArkUITextNode.h"

#include <string>
#include <vector>

namespace NativeModule {
// [StartExclude Grouped_List]
std::vector<std::string> BuildGroupData()
{
    std::vector<std::string> groupData;
    groupData.reserve(1000); // 每个分组预分配1000条数据空间。
    for (int32_t i = 0; i < 1000; i++) { // 1000：1000条数据空间
        groupData.emplace_back(std::to_string(i));
    }
    return groupData;
}

std::shared_ptr<ArkUIListItemNode> BuildListItemNode(const std::string &item, int32_t index)
{
    (void)index;
    auto listItem = std::make_shared<ArkUIListItemNode>();
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent(item);
    textNode->SetFontSize(16); // 16:字体大小
    textNode->SetPercentWidth(1); // 1：宽度
    textNode->SetHeight(100); // 100: 高度
    textNode->SetBackgroundColor(0xFFfffacd);
    textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
    listItem->AddChild(textNode);
    return listItem;
}

void ReuseListItemNode(const std::shared_ptr<ArkUIListItemNode> &listItem, const std::string &item, int32_t index)
{
    (void)index;
    auto &children = listItem->GetChildren();
    if (children.empty()) {
        return;
    }
    auto textNode = std::dynamic_pointer_cast<ArkUITextNode>(children.front());
    if (textNode) {
        textNode->SetTextContent(item);
        textNode->SetBackgroundColor(0xFFfffacd);
    }
}

// [EndExclude Grouped_List]
std::shared_ptr<ArkUIListItemGroupNode> CreateListItemGroup()
{
    auto header = std::make_shared<ArkUITextNode>();
    header->SetTextContent("header");
    header->SetFontSize(16); // 16：字体大小
    header->SetPercentWidth(1); // 1：宽度
    header->SetHeight(50); // 50：高度
    header->SetBackgroundColor(0xFFDCDCDC);
    header->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);

    auto listItemGroup = std::make_shared<ArkUIListItemGroupNode>();
    listItemGroup->SetHeader(header);

    auto groupData = BuildGroupData();
    auto createChildCallback = [](const std::string &item, int32_t index) -> std::shared_ptr<ArkUIListItemNode> {
        return BuildListItemNode(item, index);
    };
    auto reuseListItemCallback = [](const std::shared_ptr<ArkUIListItemNode> &listItem, const std::string &item,
                                    int32_t index) {
        ReuseListItemNode(listItem, item, index);
    };

    auto adapter = std::make_shared<ArkUIListItemAdapterT<std::string>>(groupData, createChildCallback,
                                                                         reuseListItemCallback);
    listItemGroup->SetLazyAdapter(adapter);
    return listItemGroup;
}

std::shared_ptr<ArkUIBaseNode> CreateLazyTextListExample()
{
    // 创建组件并挂载。
    // 1：创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1); // 1：宽度
    list->SetPercentHeight(1); // 1：高度
    list->SetSticky(ARKUI_STICKY_STYLE_BOTH);

    // 2：创建ListItemGroup并挂载到List上。
    for (int32_t i = 0; i < 3; i++) { // 3：分组数
        list->AddChild(CreateListItemGroup());
    }
    return list;
}

} // namespace NativeModule

#endif // MYAPPLICATION_LAZYTEXTLISTEXAMPLE_H
// [End Grouped_List]
