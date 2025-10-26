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
// [Start custom-components]
// ArkUICustomContainerNode.h
// 自定义容器组件示例

#ifndef MYAPPLICATION_ARKUICUSTOMCONTAINERNODE_H
#define MYAPPLICATION_ARKUICUSTOMCONTAINERNODE_H

#include "ArkUINode.h"

namespace NativeModule {

    class ArkUICustomContainerNode : public ArkUINode {
    public:
        // 使用自定义组件类型ARKUI_NODE_CUSTOM创建组件。
        ArkUICustomContainerNode()
            : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_CUSTOM))
        {
            // 注册自定义事件监听器。
            nativeModule_->addNodeCustomEventReceiver(handle_, OnStaticCustomEvent);
            // 声明自定义事件并传递自身作为自定义数据。
            nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_MEASURE, 0, this);
            nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_LAYOUT, 0, this);
        }

        ~ArkUICustomContainerNode() override
        {
            // 反注册自定义事件监听器。
            nativeModule_->removeNodeCustomEventReceiver(handle_, OnStaticCustomEvent);
            // 取消声明自定义事件。
            nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_MEASURE);
            nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_LAYOUT);
        }

        void SetPadding(int32_t padding)
        {
            padding_ = padding;
            // 自定义属性事件更新需要主动调用标记脏区接口。
            nativeModule_->markDirty(handle_, NODE_NEED_MEASURE);
        }

    private:
        static void OnStaticCustomEvent(ArkUI_NodeCustomEvent *event)
        {
            // 获取组件实例对象，调用相关实例方法。
            auto customNode = reinterpret_cast<ArkUICustomContainerNode *>(OH_ArkUI_NodeCustomEvent_GetUserData(event));
            auto type = OH_ArkUI_NodeCustomEvent_GetEventType(event);
            switch (type) {
                case ARKUI_NODE_CUSTOM_EVENT_ON_MEASURE:
                    customNode->OnMeasure(event);
                    break;
                case ARKUI_NODE_CUSTOM_EVENT_ON_LAYOUT:
                    customNode->OnLayout(event);
                    break;
                default:
                    break;
            }
        }

        // 自定义测算逻辑。
        void OnMeasure(ArkUI_NodeCustomEvent *event)
        {
            auto layoutConstrain = OH_ArkUI_NodeCustomEvent_GetLayoutConstraintInMeasure(event);
            // 创建子节点布局限制，复用父组件布局中的百分比参考值。
            auto childLayoutConstrain = OH_ArkUI_LayoutConstraint_Copy(layoutConstrain);
            int32_t maxConstrain = 1000;
            OH_ArkUI_LayoutConstraint_SetMaxHeight(childLayoutConstrain, maxConstrain);
            OH_ArkUI_LayoutConstraint_SetMaxWidth(childLayoutConstrain, maxConstrain);
            OH_ArkUI_LayoutConstraint_SetMinHeight(childLayoutConstrain, 0);
            OH_ArkUI_LayoutConstraint_SetMinWidth(childLayoutConstrain, 0);

            // 测算子节点获取子节点最大值。
            auto totalSize = nativeModule_->getTotalChildCount(handle_);
            int32_t maxWidth = 0;
            int32_t maxHeight = 0;
            for (uint32_t i = 0; i < totalSize; i++) {
                auto child = nativeModule_->getChildAt(handle_, i);
                // 调用测算接口测算Native组件。
                nativeModule_->measureNode(child, childLayoutConstrain);
                auto size = nativeModule_->getMeasuredSize(child);
                if (size.width > maxWidth) {
                    maxWidth = size.width;
                }
                if (size.height > maxHeight) {
                    maxHeight = size.height;
                }
            }
            // 自定义测算为所有子节点大小加固定边距。该自定义节点最终的尺寸以此处设置的值为准。
            const int paddingMultiplier = 2;
            nativeModule_->setMeasuredSize(handle_, maxWidth + paddingMultiplier * padding_, maxHeight
                + paddingMultiplier * padding_);
        }

        void OnLayout(ArkUI_NodeCustomEvent *event)
        {
            // 获取父组件期望位置并设置。
            auto position = OH_ArkUI_NodeCustomEvent_GetPositionInLayout(event);
            nativeModule_->setLayoutPosition(handle_, position.x, position.y);

            // 设置子组件居中对齐。
            auto totalSize = nativeModule_->getTotalChildCount(handle_);
            auto selfSize = nativeModule_->getMeasuredSize(handle_);
            for (uint32_t i = 0; i < totalSize; i++) {
                auto child = nativeModule_->getChildAt(handle_, i);
                // 获取子组件大小。
                auto childSize = nativeModule_->getMeasuredSize(child);
                // 布局子组件位置。
                int32_t horizontalMargin = (selfSize.width - childSize.width) / 2;
                int32_t verticalMargin = (selfSize.height - childSize.height) / 2;
                nativeModule_->layoutNode(child, horizontalMargin, verticalMargin);
            }
        }

        int32_t padding_ = 100;
    };

} // namespace NativeModule

#endif // MYAPPLICATION_ARKUICUSTOMCONTAINERNODE_H
       // [End custom-components]