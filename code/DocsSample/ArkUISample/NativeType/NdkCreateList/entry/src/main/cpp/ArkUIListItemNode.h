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
// [Start Provide_wrapper_class_list_items]
// ArkUIListItemNode.h
// 提供列表项的封装类。
#ifndef MYAPPLICATION_ARKUILISTITEMNODE_H
#define MYAPPLICATION_ARKUILISTITEMNODE_H
#include "ArkUINode.h"
namespace NativeModule {
class ArkUIListItemNode : public ArkUINode {
public:
    ArkUIListItemNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_LIST_ITEM)) {}
    ~ArkUIListItemNode() override
    {
        // 销毁ListItemSwipeActionOption实例
        if (swipeAction_) {
            OH_ArkUI_ListItemSwipeActionOption_Dispose(swipeAction_);
        }
        // 销毁ListItemSwipeActionItem实例
        if (swipeItem_) {
            OH_ArkUI_ListItemSwipeActionItem_Dispose(swipeItem_);
        }
    }
    void SetSwiperAction(std::shared_ptr<ArkUINode> node)
    {
        swipeContent_ = node;
        // 创建ListItemSwipeActionItem接口设置的配置项
        swipeItem_ = OH_ArkUI_ListItemSwipeActionItem_Create();
        // 设置ListItemSwipeActionItem的布局内容
        OH_ArkUI_ListItemSwipeActionItem_SetContent(swipeItem_, node->GetHandle());
        // 创建ListItemSwipeActionOption接口设置的配置项
        swipeAction_ = OH_ArkUI_ListItemSwipeActionOption_Create();
        // 设置ListItemSwipeActionItem的右侧（垂直布局）或下方（横向布局）布局内容
        OH_ArkUI_ListItemSwipeActionOption_SetEnd(swipeAction_, swipeItem_);
        ArkUI_AttributeItem Item = {.object = swipeAction_};
        nativeModule_->setAttribute(handle_, NODE_LIST_ITEM_SWIPE_ACTION, &Item);
    }
    std::shared_ptr<ArkUINode> GetSwipeContent() const { return swipeContent_; }

private:
    ArkUI_ListItemSwipeActionOption *swipeAction_ = nullptr;
    ArkUI_ListItemSwipeActionItem *swipeItem_ = nullptr;
    std::shared_ptr<ArkUINode> swipeContent_ = nullptr;
};
} // namespace NativeModule
#endif // MYAPPLICATION_ARKUILISTITEMNODE_H
// [End Provide_wrapper_class_list_items]