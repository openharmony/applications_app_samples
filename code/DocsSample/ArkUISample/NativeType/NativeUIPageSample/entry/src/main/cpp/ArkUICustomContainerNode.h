/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start Cpp_ArkUICustomContainerNode_H]
// ArkUICustomContainerNode.h
// 自定义容器组件示例
#ifndef NATIVEUIPAGESAMPLE_ARKUICUSTOMCONTAINERNODE_H
#define NATIVEUIPAGESAMPLE_ARKUICUSTOMCONTAINERNODE_H

#include "ArkUINode.h"

namespace NativeModule {
    class ArkUICustomContainerNode : public ArkUINode {
    public:
        // 使用自定义组件类型ARKUI_NODE_CUSTOM创建组件。
        ArkUICustomContainerNode();

        ~ArkUICustomContainerNode() override;

        void SetPadding(int32_t padding);

    private:
        static void OnStaticCustomEvent(ArkUI_NodeCustomEvent *event);

        // 自定义测量逻辑。
        void OnMeasure(ArkUI_NodeCustomEvent *event);

        void OnLayout(ArkUI_NodeCustomEvent *event);

        int32_t padding_ = 100;
    };

} // namespace NativeModule

#endif // NATIVEUIPAGESAMPLE_ARKUICUSTOMCONTAINERNODE_H
// [End Cpp_ArkUICustomContainerNode_H]
