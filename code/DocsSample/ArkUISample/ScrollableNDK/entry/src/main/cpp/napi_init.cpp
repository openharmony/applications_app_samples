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

#include "components/grid/examples/ScrollableGrid.h"
#include "components/list/examples/AlphabetIndexedList.h"
#include "components/refresh/examples/RefreshList.h"
#include "components/scroll/examples/ScrollableInfiniteScroll.h"
#include "components/waterflow/examples/WaterFlowInfiniteScrollingEarly.h"
#include "napi/native_api.h"

namespace ScrollableNDK {
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        // —— WaterFlow 示例 —— //
        {"WaterFlowInfiniteScrollingEarly", nullptr, Examples::WaterFlowInfiniteScrollingEarlyImpl::NAPI, nullptr,
         nullptr, nullptr, napi_default, nullptr},

        // —— Grid 示例 —— //
        {"ScrollableGrid", nullptr, Examples::ScrollableGridImpl::NAPI, nullptr, nullptr, nullptr, napi_default,
         nullptr},

        // —— List 示例 —— //
        {"AlphabetIndexedList", nullptr, Examples::AlphabetIndexedListImpl::NAPI, nullptr, nullptr, nullptr,
         napi_default, nullptr},

        // —— Refresh 示例 —— //
        {"RefreshList", nullptr, Examples::RefreshListImpl::NAPI, nullptr, nullptr, nullptr, napi_default, nullptr},

        // —— Refresh 示例 —— //
        {"ScrollableInfiniteScroll", nullptr, Examples::ScrollableInfiniteScrollImpl::NAPI, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module entryModule = {.nm_version = 1,
                                  .nm_flags = 0,
                                  .nm_filename = nullptr,
                                  .nm_register_func = Init,
                                  .nm_modname = "entry",
                                  .nm_priv = ((void *)0),
                                  .reserved = {0}};

extern "C" __attribute__((constructor)) void RegisterModule(void) { napi_module_register(&entryModule); }
} // namespace ScrollableNDK
