/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

#include <hilog/log.h>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <napi/native_api.h>
#include "NativeRender.h"
#include "NativeImageAdaptor.h"

using namespace NativeWindowSample;

static napi_value Init(napi_env env, napi_value exports)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Init", "Init begins");
    napi_property_descriptor desc[] = {
        { "getNativeRender", nullptr, NativeRender::GetNativeRender, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Init", "Init ends");
    bool ret = NativeRender::GetInstance()->Export(env, exports);
    if (!ret) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "NativeRender Init", "Init failed");
    }
    ret = NativeImageAdaptor::GetInstance()->Export(env, exports);
    if (!ret) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "NativeImageAdaptor Init", "Init failed");
    }
    
    return exports;
}

static napi_module nativerenderModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "nativerender",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterModule(void)
{
    napi_module_register(&nativerenderModule);
}