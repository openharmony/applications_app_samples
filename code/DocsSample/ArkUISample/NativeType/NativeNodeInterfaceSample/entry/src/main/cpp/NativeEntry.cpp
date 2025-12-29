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
// NativeEntry.cpp
#include <arkui/native_animate.h>
#include <arkui/native_node_napi.h>
#include <hilog/log.h>
#include <js_native_api.h>
#include "ArkUIColumnNode.h"
#include "NativeEntry.h"
#include <map>
#include <thread>

namespace NativeModule {

napi_value CreateNodeExample(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr, nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取ArkTs侧组件挂载点。
    ArkUI_NodeContentHandle contentHandle;
    int32_t result = OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        return nullptr;
    }

    // 创建Native侧组件树根节点。
    auto columnNode = std::make_shared<ArkUIColumnNode>();
    // 将Native侧组件树根节点挂载到UI主树上。
    result = OH_ArkUI_NodeContent_AddNode(contentHandle, columnNode->GetHandle());
    if (result != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "OH_ArkUI_NodeContent_AddNode Failed %{public}d", result);
        return nullptr;
    }
    
    // 调用全局接口初始化CAPI
    auto api = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Native", "Interface init success");
    return nullptr;
}

} // namespace NativeModule
