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

#include "manager.h"

#include "components/grid/Grid.h"
#include "components/list/List.h"
#include "components/refresh/Refresh.h"
#include "components/scroll/Scroll.h"
#include "components/waterflow/WaterFlow.h"

#include "napi/native_api.h"
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <hilog/log.h>

namespace ConstIde {
const uint32_t NUMBER_0 = 0;
const uint32_t NUMBER_1 = 1;
const uint32_t NUMBER_2 = 2;
const uint32_t MARGIN_NUMBER_30 = 30;
constexpr const char *K_LOG_DOMAIN = "Manager";
} // namespace ConstIde

Manager Manager::manager_;
ArkUI_NativeNodeAPI_1 *Manager::nodeAPI_ = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
    OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));

template <class MakeNodeFn>
static napi_value CreateNativeNode(napi_env env, napi_callback_info info, const char *who, MakeNodeFn makeNodeFn)
{
    // 统一返回 undefined 的帮助函数
    auto napi_undefined = [](napi_env e) -> napi_value {
        napi_value r{};
        (void)napi_get_undefined(e, &r);
        return r;
    };

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s BEGIN", who);

    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s env or info is null",
                     who);
        return napi_undefined(env);
    }

    size_t argc = ConstIde::NUMBER_1;
    napi_value args[ConstIde::NUMBER_1] = {nullptr};
    napi_status st = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (st != napi_ok || argc < ConstIde::NUMBER_1) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s napi_get_cb_info failed",
                     who);
        return napi_undefined(env);
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[ConstIde::NUMBER_0], &nodeContentHandle);
    if (nodeContentHandle == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN,
                     "%{public}s nodeContentHandle is null", who);
        return napi_undefined(env);
    }

    if (Manager::nodeAPI_ == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s nodeAPI_ is null", who);
        return napi_undefined(env);
    }

    // 构建具体节点 & 挂载
    ArkUI_NodeHandle page = makeNodeFn();
    if (page == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s makeNodeFn return null",
                     who);
        return napi_undefined(env);
    }

    OH_ArkUI_NodeContent_AddNode(nodeContentHandle, page);
    return napi_undefined(env);
}

napi_value Manager::CreateWaterFlowInfiniteScrollingEarly(napi_env env, napi_callback_info info)
{
    return CreateNativeNode(env, info, "CreateWaterFlowInfiniteScrollingEarly",
                            []() -> ArkUI_NodeHandle { return WaterFlow::CreateWaterFlowInfiniteScrollingEarly(); });
}

napi_value Manager::CreateScrollableGrid(napi_env env, napi_callback_info info)
{
    return CreateNativeNode(env, info, "CreateScrollableGrid",
                            []() -> ArkUI_NodeHandle { return Grid::CreateScrollableGrid(); });
}

napi_value Manager::CreateAlphabetIndexedList(napi_env env, napi_callback_info info)
{
    return CreateNativeNode(env, info, "CreateAlphabetIndexedList",
                            []() -> ArkUI_NodeHandle { return List::CreateAlphabetIndexedList(); });
}

napi_value Manager::CreateRefreshList(napi_env env, napi_callback_info info)
{
    return CreateNativeNode(env, info, "CreateRefreshList",
                            []() -> ArkUI_NodeHandle { return Refresh::CreateRefreshList(); });
}

napi_value Manager::CreateScrollableInfiniteScroll(napi_env env, napi_callback_info info)
{
    return CreateNativeNode(env, info, "CreateScrollableInfiniteScroll",
                            []() -> ArkUI_NodeHandle { return Scroll::CreateScrollableInfiniteScroll(); });
}
