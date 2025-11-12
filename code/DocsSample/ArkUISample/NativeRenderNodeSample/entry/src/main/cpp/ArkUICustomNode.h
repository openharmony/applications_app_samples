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
// ArkUICustomNode.h
// 自定义绘制组件示例
#ifndef MYAPPLICATION_ARKUICUSTOMNODE_H
#define MYAPPLICATION_ARKUICUSTOMNODE_H

#include "ArkUINode.h"
#include "ArkUIRenderNode.h"

namespace NativeModule {

class ArkUICustomNode : public ArkUINode {
public:
    // 使用自定义组件类型ARKUI_NODE_CUSTOM创建组件，该Custom类型仅作为RenderNode的容器
    ArkUICustomNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_CUSTOM)) {}

    ~ArkUICustomNode() override {}

    int32_t AddRenderNode(const std::shared_ptr<ArkUIRenderNode> &child)
    {
        return OH_ArkUI_RenderNodeUtils_AddRenderNode(handle_, child->GetHandle());
    }

    int32_t RemoveRenderNode(const std::shared_ptr<ArkUIRenderNode> &child)
    {
        return OH_ArkUI_RenderNodeUtils_RemoveRenderNode(handle_, child->GetHandle());
    }

    int32_t Invalidate()
    {
        return OH_ArkUI_RenderNodeUtils_Invalidate(handle_);
    }
};

} // namespace NativeModule

#endif // MYAPPLICATION_ARKUICUSTOMNODE_H