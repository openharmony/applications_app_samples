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
            if (swipeAction_) {
                OH_ArkUI_ListItemSwipeActionOption_Dispose(swipeAction_);
            }
            if (swipeItem_) {
                OH_ArkUI_ListItemSwipeActionItem_Dispose(swipeItem_);
            }
        }
        void SetSwiperAction(std::shared_ptr<ArkUINode> node)
        {
            swipeContent_ = node;
            swipeItem_ = OH_ArkUI_ListItemSwipeActionItem_Create();
            OH_ArkUI_ListItemSwipeActionItem_SetContent(swipeItem_, node->GetHandle());
            swipeAction_ = OH_ArkUI_ListItemSwipeActionOption_Create();
            OH_ArkUI_ListItemSwipeActionOption_SetEnd(swipeAction_, swipeItem_);
            ArkUI_AttributeItem Item = {.object = swipeAction_};
            nativeModule_->setAttribute(handle_, NODE_LIST_ITEM_SWIPE_ACTION, &Item);
        }
        std::shared_ptr<ArkUINode> GetSwipeContent() const { return swipeContent_; }
        std::list<std::shared_ptr<ArkUIBaseNode>> &GetChildren() { return children_; }

    private:
        ArkUI_ListItemSwipeActionOption *swipeAction_ = nullptr;
        ArkUI_ListItemSwipeActionItem *swipeItem_ = nullptr;
        std::shared_ptr<ArkUINode> swipeContent_ = nullptr;
        std::list<std::shared_ptr<ArkUIBaseNode>> children_;
    };
} // namespace NativeModule
#endif // MYAPPLICATION_ARKUILISTITEMNODE_H
// [End Provide_wrapper_class_list_items]