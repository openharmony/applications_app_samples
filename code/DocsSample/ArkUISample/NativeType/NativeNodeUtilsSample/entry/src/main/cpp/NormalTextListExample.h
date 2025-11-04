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
// [Start normalTextListExample_start]
// NormalTextListExample.h
// 自定义接入入口函数

#ifndef MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H
#define MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H

#include "ArkUIBaseNode.h"
#include "ArkUIListItemNode.h"
#include "ArkUIListNode.h"
#include "ArkUITextNode.h"
// [StartExclude normalTextListExample_start]
#include "common/common.h"
// [EndExclude normalTextListExample_start]
#include <hilog/log.h>

namespace NativeModule {

std::shared_ptr<ArkUIBaseNode> CreateTextListExample()
{
    // 创建组件并挂载
    // 1：使用智能指针创建List组件。
    auto list = std::make_shared<ArkUIListNode>();
    list->SetPercentWidth(1);
    list->SetPercentHeight(1);
    // 2：创建ListItem子组件并挂载到List上。
    for (int32_t i = 0; i < 1; ++i) {
        auto listItem = std::make_shared<ArkUIListItemNode>();
        auto textNode = std::make_shared<ArkUITextNode>();
        textNode->SetTextContent(std::to_string(i));
        textNode->SetFontSize(SIZE_16);
        textNode->SetPercentWidth(1);
        textNode->SetHeight(SIZE_100);
        textNode->SetBackgroundColor(COLOR_BACKGROUND);
        textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
        // 在当前节点注册布局回调
        textNode->SetLayoutCallBack(i);
        // 在当前节点注册绘制送显回调
        textNode->SetDrawCallBack(i);
        listItem->AddChild(textNode);
        list->AddChild(listItem);
    }
    return list;
}
} // namespace NativeModule

#endif // MYAPPLICATION_NORMALTEXTLISTEXAMPLE_H
// [End normalTextListExample_start]