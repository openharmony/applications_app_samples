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

#include "napi/native_api.h"

// napi_get_cb_info
// 获取ArkTS侧入参的的参数信息
static napi_value GetCbArgs(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    return args[0];
}

// 获取ArkTS侧入参的参数个数
static napi_value GetCbArgQuantity(napi_env env, napi_callback_info info)
{
    size_t argc = 0;
    napi_value result = nullptr;
    napi_get_cb_info(env, info, &argc, nullptr, nullptr, nullptr);
    napi_create_int32(env, argc, &result);
    return result;
}

// 获取ArkTS侧this参数
static napi_value GetCbContext(napi_env env, napi_callback_info info)
{
    napi_value thisArg = nullptr;
    napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr);
    return thisArg;
}

// napi_call_function
static napi_value CallFunction(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    // 获取ArkTS侧入参
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 获取全局对象，这里用global是因为napi_call_function的第二个参数是JS函数的this入参。
    napi_value global = nullptr;
    napi_get_global(env, &global);
    // 调用ArkTS方法
    napi_value result = nullptr;
    // 调用napi_call_function时传入的argv的长度必须大于等于argc声明的数量，且被初始化成nullptr
    napi_call_function(env, global, argv[0], argc, argv, &result);
    return result;
}

static napi_value ObjCallFunction(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传递的两个参数
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    // 获取ArkTS侧入参
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 调用ArkTS方法
    napi_value result = nullptr;
    // 调用napi_call_function时传入的argv的长度必须大于等于argc声明的数量，且被初始化成nullptr
    napi_call_function(env, argv[0], argv[1], argc, argv, &result);
    return result;
}

// napi_create_function
static napi_value CalculateArea(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传递的两个参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    double width = 0;
    napi_get_value_double(env, args[0], &width);
    double height = 0;
    napi_get_value_double(env, args[1], &height);
    napi_value area = nullptr;
    napi_create_double(env, width * height, &area);
    return area;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getCbArgs", nullptr, GetCbArgs, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getCbArgQuantity", nullptr, GetCbArgQuantity, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getCbContext", nullptr, GetCbContext, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"callFunction", nullptr, CallFunction, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"objCallFunction", nullptr, ObjCallFunction, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_value fn = nullptr;
    napi_create_function(env, nullptr, 0, CalculateArea, nullptr, &fn);
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    napi_set_named_property(env, exports, "calculateArea", fn);
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
