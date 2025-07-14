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

#include "CppObjA.h"
#include "CppObjB.h"
#include "napi/native_api.h"

// [Start napi_wrap]
struct ObjectPair {
    CppObjA* objA;
    CppObjB* objB;
    bool objADestroyedA = false;
    bool objADestroyedB = false;
};

// jsObjA 的 finalize 回调
void FinalizeA(napi_env env, void* data, void* hint)
{
    ObjectPair* pair = static_cast<ObjectPair*>(data);
    pair->objADestroyedA = true;
    if (pair->objADestroyedA && pair->objADestroyedB) {
        delete pair->objA; // 确保先销毁 A
        delete pair->objB; // 再销毁 B
        delete pair;       // 释放包装结构
    }
}

// jsObjB 的 finalize 回调
void FinalizeB(napi_env env, void* data, void* hint)
{
    ObjectPair* pair = static_cast<ObjectPair*>(data);
    pair->objADestroyedB = true;
    if (pair->objADestroyedA && pair->objADestroyedB) {
        delete pair->objA; // 确保先销毁 A
        delete pair->objB; // 再销毁 B
        delete pair;       // 释放包装结构
    }
}
// [End napi_wrap]

static napi_value Test(napi_env env, napi_callback_info info)
{
    CppObjA* objA = new CppObjA("ObjectA");
    CppObjB* objB = new CppObjB("ObjectB");
    ObjectPair* pair = new ObjectPair{objA, objB, false, false};
    
 // 创建 JS 对象 A
    napi_value jsObjA;
    napi_create_object(env, &jsObjA);
    napi_wrap(env, jsObjA, objA, FinalizeA, pair, nullptr);
    
    // 创建 JS 对象 B
    napi_value jsObjB;
    napi_create_object(env, &jsObjB);
    napi_wrap(env, jsObjB, objB, FinalizeB, pair, nullptr);

    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "test", nullptr, Test, nullptr, nullptr, nullptr, napi_default, nullptr }
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