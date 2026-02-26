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

#include "manager.h"
#include <napi/native_api.h>

static napi_value createNativeNode(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value argv[2] = { nullptr };
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // 第一个参数是NodeContent对象
    napi_valuetype valueType0 = napi_undefined;
    napi_typeof(env, argv[0], &valueType0);
    if (valueType0 != napi_object) {
        return nullptr;
    }

    // 第二个参数是px2vp转换比例
    napi_valuetype valueType1 = napi_undefined;
    napi_typeof(env, argv[1], &valueType1);
    if (valueType1 != napi_number) {
        return nullptr;
    }
    double px2vp;
    napi_get_value_double(env, argv[1], &px2vp);

    NativeXComponentSample::NodeManager::GetInstance().CreateNativeNode(env, argv[0], px2vp);
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "createNativeNode", nullptr, createNativeNode, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
