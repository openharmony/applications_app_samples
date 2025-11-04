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
// [Start arkui_mixed_refresh_template_cpp]

// 混合模式交互类。

#include "ArkUIMixedRefreshTemplate.h"

namespace NativeModule {
namespace {
napi_env g_env;
napi_ref g_createRefresh;
napi_ref g_updateRefresh;
} // namespace

napi_value ArkUIMixedRefresh::RegisterCreateAndUpdateRefresh(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    g_env = env;
    napi_ref refer;
    // 创建引用之后保存，防止释放。
    napi_create_reference(env, args[0], 1, &refer);

    g_createRefresh = refer;
    return nullptr;
}

} // namespace NativeModule
// [End arkui_mixed_refresh_template_cpp]