//
// Created on 2025/10/21.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".


// [Start Grouped_List_Interface]
// LazyTextListExample.h
// 懒加载列表示例代码。
#ifndef MYAPPLICATION_LAZYTEXTLISTEXAMPLE_H
#define MYAPPLICATION_LAZYTEXTLISTEXAMPLE_H
#include "ArkUIBaseNode.h"
#include "ArkUIListNode.h"
#include "ArkUIListItemGroupNode.h"
namespace NativeModule {
std::shared_ptr<ArkUIBaseNode> CreateLazyTextListExample() { 
// 创建组件并挂载
    // 1: 创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1);
    list->SetPercentHeight(1);
    // 设置吸顶
    list->SetSticky(ARKUI_STICKY_STYLE_BOTH);
    // 2: 创建ListItemGroup并挂载到List上。
    for (int32_t i = 0; i < 3; i++) {
        auto header = std::make_shared<ArkUITextNode>();
        header->SetTextContent("header");
        header->SetFontSize(16);
        header->SetPercentWidth(1);
        header->SetHeight(50);
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