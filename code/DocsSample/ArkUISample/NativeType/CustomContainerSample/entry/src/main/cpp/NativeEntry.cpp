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
// [Start entrance]
#include "NativeEntry.h"

#include "ArkUICustomContainerNode.h"
#include "ArkUITextNode.h"
#include "UITimer.h"

#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <js_native_api.h>

namespace NativeModule {
    namespace {
        napi_env g_env;
    } // namespace

    napi_value CreateNativeRoot(napi_env env, napi_callback_info info)
    {
        size_t argc = 1;
        napi_value args[1] = {nullptr};

        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

        ArkUI_NodeContentHandle contentHandle;
        OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
        NativeEntry::GetInstance()->SetContentHandle(contentHandle);

        // 创建自定义容器和文本组件。
        auto node = std::make_shared<ArkUICustomContainerNode>();
        node->SetBackgroundColor(0xFFE0FFFF);
        auto textNode = std::make_shared<ArkUITextNode>();
        textNode->SetTextContent("CustomContainer Example");
        const int32_t fontSize = 16;
        textNode->SetFontSize(fontSize);
        textNode->SetBackgroundColor(0xFFfffacd);
        textNode->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
        node->AddChild(textNode);
        CreateNativeTimer(env, textNode.get(), 1, [](void *userData, int32_t count) {
            auto textNode = reinterpret_cast<ArkUITextNode *>(userData);
            textNode->SetFontColor(0xFF00FF7F);
        });

        // 保持Native侧对象到管理类中，维护生命周期。
        NativeEntry::GetInstance()->SetRootNode(node);
        g_env = env;
        return nullptr;
    }

    napi_value DestroyNativeRoot(napi_env env, napi_callback_info info)
    {
        // 从管理类中释放Native侧对象。
        NativeEntry::GetInstance()->DisposeRootNode();
        return nullptr;
    }

} // namespace NativeModule
// [End entrance]