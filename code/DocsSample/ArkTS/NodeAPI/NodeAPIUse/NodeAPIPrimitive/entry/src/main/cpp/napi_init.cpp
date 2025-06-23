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

// [Start napi_coerce_to_bool]
// napi_coerce_to_bool
static napi_value CoerceToBool(napi_env env, napi_callback_info info)
{
    // 获取并解析传进的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将传入的值转换为布尔值
    napi_value result = nullptr;
    napi_coerce_to_bool(env, args[0], &result);
    // 返回强转之后的ArkTS boolean值
    return result;
}
// [End napi_coerce_to_bool]

// [Start napi_coerce_to_number]
// napi_coerce_to_number
static napi_value CoerceToNumber(napi_env env, napi_callback_info info)
{
    // 获取并解析传进的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将传入的值转换为number值
    napi_value result = nullptr;
    napi_coerce_to_number(env, args[0], &result);
    return result;
}
// [End napi_coerce_to_number]

// [Start napi_coerce_to_object]
// napi_coerce_to_object
static napi_value CoerceToObject(napi_env env, napi_callback_info info)
{
    // 获取并解析传进的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value obj = nullptr;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将传入的值转换为Object值
    napi_coerce_to_object(env, args[0], &obj);
    return obj;
}
// [End napi_coerce_to_object]

// [Start napi_coerce_to_string]
// napi_coerce_to_string
static napi_value CoerceToString(napi_env env, napi_callback_info info)
{
    // 获取并解析传进的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将传入的值转换为string
    napi_value str = nullptr;
    napi_coerce_to_string(env, args[0], &str);
    return str;
}
// [End napi_coerce_to_string]

// [Start napi_get_boolean]
// napi_get_boolean
static napi_value GetBoolean(napi_env env, napi_callback_info info)
{
    // 传入两个参数并解析
    size_t argc = 2;
    napi_value argv[2];
    napi_valuetype data;
    napi_valuetype value;
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 判断两个参数类型值
    napi_typeof(env, argv[0], &data);
    napi_typeof(env, argv[1], &value);

    napi_value returnValue = nullptr;
    // 判断两个类型值是否相等,获取结果的布尔值
    napi_get_boolean(env, data == value, &returnValue);
    // 返回结果
    return returnValue;
}
// [End napi_get_boolean]

// [Start napi_get_value_bool]
// napi_get_value_bool
static napi_value GetValueBool(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    bool boolC = false;
    napi_status status = napi_get_value_bool(env, args[0], &boolC);
    if (status == napi_boolean_expected) {
        // 如果napi_get_value_bool成功会返回napi_ok，如果传入一个非布尔值则会返回napi_boolean_expected
        return nullptr;
    }
    napi_value boolNapi = nullptr;
    napi_get_boolean(env, boolC, &boolNapi);
    return boolNapi;
}
// [End napi_get_value_bool]

// [Start napi_get_global]
// napi_get_global
static napi_value GetGlobal(napi_env env, napi_callback_info info)
{
    napi_value global = nullptr;
    // 获取global对象
    napi_get_global(env, &global);
    return global;
}
// [End napi_get_global]

// [Start napi_get_null]
// napi_get_null
static napi_value GetNull(napi_env env, napi_callback_info info)
{
    napi_value nullValue = nullptr;
    napi_get_null(env, &nullValue);
    return nullValue;
}
// [End napi_get_null]

// [Start napi_get_undefined]
// napi_get_undefined
static napi_value GetUndefined(napi_env env, napi_callback_info info)
{
    // 获取并解析传进的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value value = nullptr;
    napi_get_undefined(env, &value);
    // 判断传入参数的类型与undefined值的类型是否一致
    bool isEqual = false;
    napi_strict_equals(env, args[0], value, &isEqual);
    // 参数与undefined值相等
    napi_value result = nullptr;
    // 返回判断类型之后的结果，相等返回为true，不等则为false
    napi_get_boolean(env, isEqual, &result);
    return result;
}
// [End napi_get_undefined]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"coerceToBool", nullptr, CoerceToBool, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"coerceToNumber", nullptr, CoerceToNumber, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"coerceToObject", nullptr, CoerceToObject, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"coerceToString", nullptr, CoerceToString, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getBoolean", nullptr, GetBoolean, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getValueBool", nullptr, GetValueBool, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getGlobal", nullptr, GetGlobal, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getNull", nullptr, GetNull, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getUndefined", nullptr, GetUndefined, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
