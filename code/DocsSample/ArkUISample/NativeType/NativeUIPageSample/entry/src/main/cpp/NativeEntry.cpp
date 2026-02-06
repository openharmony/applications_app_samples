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
// [Start Cpp_NativeEntry]
#include "NativeEntry.h"
#include "ArkUICustomContainerNode.h"
#include "ArkUICustomNode.h"
#include <hilog/log.h>

namespace NativeModule {
// 定义常量
const int SIZE_150 = 150;

napi_value CreateNativeRoot(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取NodeContent。
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    NativeEntry::GetInstance()->SetContentHandle(contentHandle);

    // 创建自定义容器和自定义绘制组件。
    auto node = std::make_shared<ArkUICustomContainerNode>();
    node->SetBackgroundColor(0xFFD5D5D5); // 浅灰色。
    auto customNode = std::make_shared<ArkUICustomNode>();
    customNode->SetBackgroundColor(0xFF707070); // 深灰色。
    customNode->SetWidth(SIZE_150);
    customNode->SetHeight(SIZE_150);
    node->AddChild(customNode);

    // 保持Native侧对象到管理类中，维护生命周期。
    NativeEntry::GetInstance()->SetRootNode(node);
    return nullptr;
}

napi_value DestroyNativeRoot(napi_env env, napi_callback_info info)
{
    // 从管理类中释放Native侧对象。
    NativeEntry::GetInstance()->DisposeRootNode();
    return nullptr;
}

} // namespace NativeModule
// [End Cpp_NativeEntry]
