/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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


#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include "InquireUniqueId.h"
#include "ShowSubcomponentInfo.h"

// [Start ndknodequeryoperate3_start]
// NativeEntry.cpp
#include <arkui/native_node_napi.h>
#include <hilog/log.h>
#include <js_native_api.h>
#include "NativeEntry.h"
#include "MoveToExample.h"
#include "GetNodeByIdExample.h"


namespace NativeModule {
// [StartExclude ndknodequeryoperate3_start]
constexpr const char *K_LOG_DOMAIN = "NativeEntry";

template <class MakeNodeFn>
// [EndExclude ndknodequeryoperate3_start]
static napi_value CreateNativeRoot(napi_env env, napi_callback_info info, const char *who, MakeNodeFn makeNodeFn)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取NodeContent
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (contentHandle == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, K_LOG_DOMAIN,
                     "%{public}s nodeContentHandle is null", who);
        return nullptr;
    }
    NativeEntry::GetInstance()->SetContentHandle(contentHandle);

    // 创建节点
    auto node = makeNodeFn();

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
// [StartExclude ndknodequeryoperate3_start]
Manager Manager::manager_;
napi_value Manager::CreateInquireUniqueIdNode(napi_env env, napi_callback_info info)
{
    return CreateNativeRoot(env, info, "CreateInquireUniqueIdNode",
                            []() -> std::shared_ptr<ArkUIBaseNode> { return InquireUniqueId::GetNodeUniqueId(); });
}

napi_value Manager::CreateMoveToNode(napi_env env, napi_callback_info info)
{
    return CreateNativeRoot(env, info, "CreateMoveToNode",
                            []() -> std::shared_ptr<ArkUIBaseNode> { return CreateMoveToExample(); });
}

napi_value Manager::CreateUserIdNode(napi_env env, napi_callback_info info)
{
    return CreateNativeRoot(env, info, "CreateUserIdNode",
                            []() -> std::shared_ptr<ArkUIBaseNode> { return CreateGetNodeByIdExample(); });
}

napi_value Manager::ShowSubcomponentInfo(napi_env env, napi_callback_info info)
{
    return CreateNativeRoot(env, info, "CreateFetchAndLoadNode",
                            []() -> std::shared_ptr<ArkUIBaseNode> { return ::NativeModule::ShowSubcomponentInfo(); });
}
// [EndExclude ndknodequeryoperate3_start]
} // namespace NativeModule
// [End ndknodequeryoperate3_start]

