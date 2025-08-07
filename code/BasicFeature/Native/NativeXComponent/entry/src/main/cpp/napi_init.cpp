/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#include "manager/plugin_manager.h"

namespace NativeXComponentSample {

// 在napi_init.cpp文件中，Init方法注册接口函数，从而将封装的C++方法传递出来，供ArkTS侧调用
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // 向ArkTS侧暴露接口
    napi_property_descriptor desc[] = {
        {"bindNode", nullptr, PluginManager::BindNode, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"unbindNode", nullptr, PluginManager::UnbindNode, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setFrameRate", nullptr, PluginManager::SetFrameRate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setNeedSoftKeyboard", nullptr, PluginManager::SetNeedSoftKeyboard, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"initialize", nullptr, PluginManager::Initialize, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"finalize", nullptr, PluginManager::Finalize, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"drawStar", nullptr, PluginManager::DrawStar, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

// 编写接口的描述信息，根据实际需要可以修改对应参数
static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    // 入口函数
    .nm_register_func = Init, // 指定加载对应模块时的回调函数
    // 模块名称
    .nm_modname =
        "nativerender", // 指定模块名称，对于XComponent相关开发，这个名称必须和ArkTS侧XComponent中libraryname的值保持一致
    .nm_priv = ((void *)0),
    .reserved = {0},
};
} // namespace NativeXComponentSample

// __attribute__((constructor))修饰的方法由系统自动调用，使用Node-API接口napi_module_register()传入模块描述信息进行模块注册
extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&NativeXComponentSample::demoModule);
}