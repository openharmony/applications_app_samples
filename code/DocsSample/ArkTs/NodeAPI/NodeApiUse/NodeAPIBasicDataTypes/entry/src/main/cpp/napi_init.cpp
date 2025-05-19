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

// [Start napi_get_value_uint32]
// napi_get_value_uint32
static napi_value GetValueUint32(napi_env env, napi_callback_info info)
{
    // 获取传入的数字类型参数
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    // 解析传入的参数
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    uint32_t number = 0;
    // 获取传入参数的值中的无符号32位整数
    napi_status status = napi_get_value_uint32(env, argv[0], &number);
    // 如果传递的参数不是数字,将会返回napi_number_expected，设置函数返回nullptr
    if (status == napi_number_expected) {
        return nullptr;
    }
    napi_value result = nullptr;
    // 创建传入参数无符号32位整数，并传出
    napi_create_uint32(env, number, &result);
    return result;
}
// [End napi_get_value_uint32]

// [Start napi_get_value_int32]
// napi_get_value_int32
static napi_value GetValueInt32(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    int32_t result32 = 0;
    // 解析传递的参数
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将前端传过来的参数转为Node-API模块的int32类型
    napi_status status = napi_get_value_int32(env, args[0], &result32);
    // 如果传递的参数不是数字napi_get_value_int32接口将会返回napi_number_expected，设置函数返回nullptr
    if (status == napi_number_expected) {
        return nullptr;
    }
    // 调用napi_create_int32接口将int32类型的数据转为napi_value返回
    napi_value napiResult32 = nullptr;
    napi_create_int32(env, result32, &napiResult32);
    return napiResult32;
}
// [End napi_get_value_int32]

// [Start napi_get_value_int64]
// napi_get_value_int64
static napi_value GetValueInt64(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    int64_t result64 = 0;
    // 解析传递的值
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将前端传过来的参数转为Node-API模块的int64类型
    napi_status status = napi_get_value_int64(env, args[0], &result64);
    // 如果传递的参数不是数字, 返回napi_number_expected.
    if (status == napi_number_expected) {
        return nullptr;
    }
    // 调用napi_create_int64接口将int64类型的数据转为napi_value返回前端
    napi_value napiResult64 = nullptr;
    napi_create_int64(env, result64, &napiResult64);
    return napiResult64;
}
// [End napi_get_value_int64]

// [Start napi_get_value_double]
// napi_get_value_double
static napi_value GetDouble(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    double value = 0;
    napi_status status = napi_get_value_double(env, args[0], &value);
    // 传入非数字接口返回napi_number_expected
    if (status == napi_number_expected) {
        return nullptr;
    }
    napi_value result = nullptr;
    napi_create_double(env, value, &result);
    return result;
}
// [End napi_get_value_double]

// [Start napi_create_int32]
// napi_create_int32
static napi_value CreateInt32(napi_env env, napi_callback_info info)
{
    // int32_t是有符号的32位整数类型，表示带有符号的整数，它的范围是从-2^31到2^31 - 1，也就是-2147483648到2147483647
    // 要表示的整数值
    int32_t value = -26;
    // 创建ArkTS中的int32数字
    napi_value result = nullptr;
    napi_status status = napi_create_int32(env, value, &result);
    if (status != napi_ok) {
        // 处理错误
        napi_throw_error(env, nullptr, "Failed to create int32 value");
    }
    return result;
}
// [End napi_create_int32]

// [Start napi_create_uint32]
// napi_create_uint32
static napi_value CreateUInt32(napi_env env, napi_callback_info info)
{
    // 如果使用
    // uint32_t类型来定义-26，会发生溢出，溢出时会对结果进行模运算，将负数的二进制补码转换为相应的正数。-26输出4294967270
    // uint32_t是无符号的32位整数类型，只能表示非负整数。它的范围是从0到2 ^32 - 1，即0到4294967295
    // 要表示的整数值
    uint32_t value = 26;
    // 创建ArkTS中的uint32数字
    napi_value result = nullptr;
    napi_status status = napi_create_uint32(env, value, &result);
    if (status != napi_ok) {
        // 处理错误
        napi_throw_error(env, nullptr, "Failed to create uint32 value");
    }
    return result;
}
// [End napi_create_uint32]

// [Start napi_create_int64]
// napi_create_int64
static napi_value CreateInt64(napi_env env, napi_callback_info info)
{
    // int64是有符号的64位整数类型，可以表示范围从-2^63到2^63 - 1的整数，即 -9223372036854775808到9223372036854775807
    // 要表示的整数值
    int64_t value = 2147483648;
    // 创建ArkTS中的int64数字
    napi_value result = nullptr;
    napi_status status = napi_create_int64(env, value, &result);
    if (status != napi_ok) {
        // 处理错误
        napi_throw_error(env, nullptr, "Failed to create int64 value");
    }
    return result;
}
// [End napi_create_int64]

// [Start napi_create_double]
// napi_create_double
static napi_value CreateDouble(napi_env env, napi_callback_info info)
{
    double value = 1.234;
    // 创建ArkTS中的double数字
    napi_value result = nullptr;
    napi_status status = napi_create_double(env, value, &result);
    if (status != napi_ok) {
        // 处理错误
        napi_throw_error(env, nullptr, "Failed to create double value");
    }
    return result;
}
// [End napi_create_double]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getValueUint32", nullptr, GetValueUint32, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getValueInt32", nullptr, GetValueInt32, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getValueInt64", nullptr, GetValueInt64, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getDouble", nullptr, GetDouble, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createInt32", nullptr, CreateInt32, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createUInt32", nullptr, CreateUInt32, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createInt64", nullptr, CreateInt64, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createDouble", nullptr, CreateDouble, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
