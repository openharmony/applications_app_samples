/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// [Start xcomponent_init]
#include <hilog/log.h>

#include "common/common.h"
#include "manager/plugin_manager.h"

namespace NativeXComponentSample {
// 在napi_init.cpp文件中，Init方法注册接口函数，从而将封装的C++方法传递出来，供ArkTS侧调用
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // [StartExclude xcomponent_init]
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Init", "Init begins");
    if ((env == nullptr) || (exports == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Init", "env or exports is null");
        return nullptr;
    }
    // [EndExclude xcomponent_init]
    // 向ArkTS侧暴露接口SetSurfaceId(),ChangeSurface(),DestroySurface(),
    // DrawPattern(),ChangeColor(),GetXComponentStatus()
    napi_property_descriptor desc[] = {
        {"ChangeColor", nullptr, PluginManager::ChangeColor,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"SetSurfaceId", nullptr, PluginManager::SetSurfaceId,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"ChangeSurface", nullptr, PluginManager::ChangeSurface,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"GetXComponentStatus", nullptr, PluginManager::GetXComponentStatus,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"DrawPattern", nullptr, PluginManager::DrawPattern,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"DestroySurface", nullptr, PluginManager::DestroySurface,
            nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    if (napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Init", "napi_define_properties failed");
        return nullptr;
    }
    return exports;
}
EXTERN_C_END
// 编写接口的描述信息，根据实际需要可以修改对应参数
static napi_module nativerenderModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    // 入口函数
    .nm_register_func = Init,
    // 模块名称
    .nm_modname = "nativerender",
    .nm_priv = ((void*)0),
    .reserved = { 0 } };
} // namespace NativeXComponentSample
// __attribute__((constructor))修饰的方法由系统自动调用，使用Node-API接口napi_module_register()传入模块描述信息进行模块注册
extern "C" __attribute__((constructor)) void RegisterModule(void)
{
    napi_module_register(&NativeXComponentSample::nativerenderModule);
}
// [End xcomponent_init]