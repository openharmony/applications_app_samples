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
#include <hilog/log.h>


EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Init", "Init begins");
    if ((env == nullptr) || (exports == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Init", "env or exports is null");
        return nullptr;
    }

    napi_property_descriptor desc[] = {
        {"createNativeSwiperNode", nullptr, Manager::CreateNativeSwiperNode, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"createNativeTextNode", nullptr, Manager::CreateNativeTextNode, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"createNativeAccessibilityNode", nullptr, Manager::CreateNativeAccessibilityNode, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"createNativeEmbeddedComponentNode", nullptr, Manager::CreateNativeEmbeddedComponentNode, nullptr, nullptr,
            nullptr, napi_default, nullptr},
        // 参考Swiper新增其他createNative方法和Maker类
    };

    if (napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Init", "napi_define_properties failed");
        return nullptr;
    }
    return exports;
}
EXTERN_C_END
static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }