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
// [Start SetCallBack]
// LazyTextListExample
// 懒加载列表示例代码。

#ifndef MYAPPLICATION_LAZYTEXTLISTEXAMPLE1_H
#define MYAPPLICATION_LAZYTEXTLISTEXAMPLE1_H

#include "ArkUIBaseNode.h"
#include "ArkUIListNode.h"
#include "ArkUITextNode.h"

#include <algorithm>
#include <memory>
#include <string>
#include <vector>

namespace NativeModule {
// [StartExclude Grouped_List_Interface]
using StringAdapter = ArkUIListItemAdapterT<std::string>;
using AdapterWeakHolder = std::shared_ptr<std::weak_ptr<StringAdapter>>;

std::vector<std::string> BuildSampleData()
{
    std::vector<std::string> data;
    data.reserve(1000); // 每个分组预分配1000条数据空间。
    for (int32_t i = 0; i < 1000; i++) { // 1000：1000条数据空间
        data.emplace_back(std::to_string(i));
    }
    return data;
}

void RegisterDeleteClick(const std::shared_ptr<ArkUINode> &target, const AdapterWeakHolder &adapterWeakHolder,
    const std::string &item)
{
    // 为删除区域注册点击事件：通过弱引用获取适配器，避免回调长期持有强引用。
    target->RegisterOnClick([adapterWeakHolder, item](ArkUI_NodeEvent *event) {
        (void)event;
        auto adapter = adapterWeakHolder->lock();
        if (!adapter) {
            return;
        }
        // 基于当前数据查找当前 item，确保复用场景下删除的是最新绑定项。
        const auto &currentData = adapter->GetData();
        auto it = std::find(currentData.begin(), currentData.end(), item);
        if (it != currentData.end()) {
            // RemoveItem 需要索引，这里把迭代器位置转换为 size_t。
            auto removeIndex = static_cast<size_t>(std::distance(currentData.begin(), it));
            adapter->RemoveItem(removeIndex);
        }
    });
}

std::shared_ptr<ArkUIListItemNode> BuildListItemNode(const std::string &item,
    const AdapterWeakHolder &adapterWeakHolder)
{
    // 构建一个 ListItem：主文本区域 + 右滑删除操作区。
    auto listItem = std::make_shared<ArkUIListItemNode>();

    // 主内容文本，展示当前数据项。
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent(item);
    // [StartExclude SetCallBack]
    textNode->SetFontSize(16); // 16：字体大小
    textNode->SetPercentWidth(1); // 1：宽度
    textNode->SetHeight(100); // 100：高度
    textNode->SetBackgroundColor(0xFFfffacd);
    textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
    // [EndExclude SetCallBack]
    listItem->AddChild(textNode);

    // 右滑动作区文本，点击后触发删除当前 item。
    auto swipeNode = std::make_shared<ArkUITextNode>();
    swipeNode->SetTextContent("del");
    // [StartExclude SetCallBack]
    swipeNode->SetFontSize(16); // 16：字体大小
    swipeNode->SetFontColor(0xFFFFFFFF);
    swipeNode->SetWidth(100); // 100：宽度
    swipeNode->SetHeight(100); // 100：高度
    swipeNode->SetBackgroundColor(0xFFFF0000);
    swipeNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
    // [EndExclude SetCallBack]
    RegisterDeleteClick(swipeNode, adapterWeakHolder, item);
    listItem->SetSwiperAction(swipeNode);
    return listItem;
}

void ReuseListItemNode(const std::shared_ptr<ArkUIListItemNode> &listItem, const std::string &item,
    const AdapterWeakHolder &adapterWeakHolder)
{
    auto &children = listItem->GetChildren();
    if (children.empty()) {
        return;
    }
    auto textNode = std::dynamic_pointer_cast<ArkUITextNode>(children.front());
    if (textNode) {
        textNode->SetTextContent(item);
        textNode->SetBackgroundColor(0xFFfffacd);
    }
    auto swipeContent = listItem->GetSwipeContent();
    if (swipeContent) {
        RegisterDeleteClick(swipeContent, adapterWeakHolder, item);
    }
}
// [StartExclude SetCallBack]
// [EndExclude Grouped_List_Interface]
std::shared_ptr<ArkUIBaseNode> CreateLazyTextListExample1()
{
    // 创建组件并挂载。
    // 1：创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1); // 1：宽度
    list->SetPercentHeight(1); // 1：高度
    auto data = BuildSampleData();

    auto adapterWeakHolder = std::make_shared<std::weak_ptr<StringAdapter>>();
    // 2：创建ListItem及其子组件的回调。
    auto createChildCallback = [adapterWeakHolder](const std::string &item,
                                                   int32_t index) -> std::shared_ptr<ArkUIListItemNode> {
        (void)index;
        return BuildListItemNode(item, adapterWeakHolder);
    };
    // 3：复用ListItem的回调。
    auto reuseListItemCallback = [adapterWeakHolder](const std::shared_ptr<ArkUIListItemNode> &listItem,
                                                     const std::string &item, int32_t index) {
        (void)index;
        ReuseListItemNode(listItem, item, adapterWeakHolder);
    };

    auto adapter = std::make_shared<StringAdapter>(data, createChildCallback, reuseListItemCallback);
    *adapterWeakHolder = adapter;
    // 4：创建ListItem懒加载组件并挂载到List中。
    list->SetLazyAdapter(adapter);
    return list;
}
// [EndExclude SetCallBack]

} // namespace NativeModule

#endif // MYAPPLICATION_LAZYTEXTLISTEXAMPLE1_H
// [End Grouped_List_Interface]
// [End SetCallBack]