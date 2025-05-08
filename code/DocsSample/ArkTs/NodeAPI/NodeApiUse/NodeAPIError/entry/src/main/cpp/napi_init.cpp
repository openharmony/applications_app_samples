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

#include "hilog/log.h"
#include "napi/native_api.h"

// [Start napi_get_last_error_info]
// napi_get_last_error_info
static napi_value GetLastErrorInfo(napi_env env, napi_callback_info info)
{
    // 获取输入参数（这里以字符串message作为参数传入）
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将传入的字符串参数以napi_get_value_int32取出，主动制造错误
    int32_t value = 0;
    napi_status status = napi_get_value_int32(env, args[0], &value);
    // 接口使用错误，故返回值不为napi_ok
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "napi_get_value_int32 return status, status is not equal to napi_ok.");
    }
    // 调用接口napi_get_last_error_info获取最后一次错误信息
    const napi_extended_error_info *errorInfo;
    napi_get_last_error_info(env, &errorInfo);
    // 取出错误码与接口调用错误后其返回值作比较
    if (errorInfo->error_code == status) {
        OH_LOG_INFO(LOG_APP, "napi_get_last_error_info return errorInfo, error_code equal to status.");
    }
    // 取出错误消息作为返回值带出去打印
    napi_value result = nullptr;
    napi_create_string_utf8(env, errorInfo->error_message, NAPI_AUTO_LENGTH, &result);
    return result;
}
// [End napi_get_last_error_info]

// [Start napi_create_type_error]
// napi_create_type_error
static napi_value CreatTypeError(napi_env env, napi_callback_info info)
{
    // 构造errorCode和errorMessage
    napi_value errorCode = nullptr;
    napi_create_string_utf8(env, "napi_create_error errorCode", NAPI_AUTO_LENGTH, &errorCode);
    napi_value errorMessage = nullptr;
    napi_create_string_utf8(env, "napi_create_error errorMessage", NAPI_AUTO_LENGTH, &errorMessage);
    // 调用napi_create_type_error创建一个typeError错误对象
    napi_value error = nullptr;
    napi_create_type_error(env, errorCode, errorMessage, &error);
    return error;
}
// [End napi_create_type_error]

// [Start napi_create_range_error]
// napi_create_range_error
static napi_value CreatRangeError(napi_env env, napi_callback_info info)
{
    // 构造errorCode和errorMessage
    napi_value errorCode = nullptr;
    napi_create_string_utf8(env, "napi_create_error errorCode", NAPI_AUTO_LENGTH, &errorCode);
    napi_value errorMessage = nullptr;
    napi_create_string_utf8(env, "napi_create_error errorMessage", NAPI_AUTO_LENGTH, &errorMessage);
    // 调用napi_create_range_error创建一个typeError错误对象
    napi_value error = nullptr;
    napi_create_range_error(env, errorCode, errorMessage, &error);
    return error;
}
// [End napi_create_range_error]

// [Start napi_create_error]
// napi_create_error and napi_throw
static napi_value NapiThrow(napi_env env, napi_callback_info info)
{
    // 代码中发生某些错误后，可执行以下操作抛出异常
    // 在Node-API环境中创建一个字符串，并将其存储在errorCode变量中
    napi_value errorCode = nullptr;
    napi_create_string_utf8(env, "throw errorCode", NAPI_AUTO_LENGTH, &errorCode);
    // 在Node-API环境中创建一个字符串，并将其存储在errorMessage变量中
    napi_value errorMessage = nullptr;
    napi_create_string_utf8(env, "throw errorMessage", NAPI_AUTO_LENGTH, &errorMessage);
    // 创建一个ArkTS对象error
    napi_value error = nullptr;
    napi_create_error(env, errorCode, errorMessage, &error);
    // 通过napi_throw接口将对象抛出
    napi_throw(env, error);
    return nullptr;
}
// [End napi_create_error]

// [Start napi_throw_error]
// napi_throw_error
// 这里直接抛出一个带有errorMessage的错误
static napi_value NapiThrowErrorMessage(napi_env env, napi_callback_info info)
{
    napi_throw_error(env, nullptr, "napi_throw_error throwing an error");
    return nullptr;
}

// 传入两个参数，在第二个参数，也就是除数为0的时候抛出一个错误
static napi_value NapiThrowError(napi_env env, napi_callback_info info)
{
    // ArkTS侧传入两个参数
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 将其转换为double类型的值作为被除数和除数
    double dividend;
    double divisor;
    napi_get_value_double(env, argv[0], &dividend);
    napi_get_value_double(env, argv[1], &divisor);
    // 在这里判断除数如果为0则直接抛出一个错误，errorCode为：DIVIDE_BY_ZERO，errorMessage为：Cannot divide by zero
    if (divisor == 0) {
        napi_throw_error(env, "DIVIDE_BY_ZERO", "Cannot divide by zero");
    }
    return nullptr;
}
// [End napi_throw_error]

// [Start napi_throw_type_error]
// napi_throw_type_error
// 这里直接抛出一个带有errorMessage的TypeError
static napi_value ThrowTypeErrorMessage(napi_env env, napi_callback_info info)
{
    napi_throw_type_error(env, nullptr, "napi_throw_type_error throwing an error");
    return nullptr;
}

// 传入一个类型不匹配的参数，判断类型不匹配之后抛出typeError
static napi_value ThrowTypeError(napi_env env, napi_callback_info info)
{
    // ArkTS侧传入一个参数
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 将传入参数转换为napi_valuetype类型的值
    napi_valuetype valueType;
    napi_typeof(env, argv[0], &valueType);
    // 如果传入参数不为napi_number类型的值则抛出TypeError
    if (valueType != napi_number) {
        // 这里抛出一个既带有errorCode也带有errorMessage的TypeError
        napi_throw_type_error(env, "napi_throw_type_error", "Argument must be a number");
    }
    return nullptr;
}
// [End napi_throw_type_error]

// [Start napi_throw_range_error]
// napi_throw_range_error
// 这里直接抛出一个带有errorMessage的RangeError
static napi_value ThrowRangeErrorMessage(napi_env env, napi_callback_info info)
{
    napi_throw_range_error(env, nullptr, "napi_throw_range_error one");
    return nullptr;
}

// 传入不匹配的参数个数，判断不匹配之后抛出rangeError
static napi_value ThrowRangeError(napi_env env, napi_callback_info info)
{
    // ArkTS侧传入两个参数
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 如果传入参数个数不为2
    if (argc != 2) {
        // 这里抛出一个RangeError
        napi_throw_range_error(env, "napi_throw_range_error", "Expected two numbers as arguments");
        return nullptr;
    }
    // 下面将传入的两值相加并传出去
    double numOne = 0;
    double numTwo = 0;
    napi_get_value_double(env, argv[0], &numOne);
    napi_get_value_double(env, argv[1], &numTwo);
    double result = numOne + numTwo;
    napi_value resultValue;
    napi_create_double(env, result, &resultValue);
    return resultValue;
}
// [End napi_throw_range_error]

// [Start napi_is_error]
// napi_is_error
static napi_value NapiIsError(napi_env env, napi_callback_info info)
{
    // 接收一个入参
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 调用接口napi_is_error判断入参是否为一个error对象
    bool result = false;
    // 如果napi_value为一个error对象，则设置result为true的布尔值，否则设置为false
    napi_is_error(env, args[0], &result);
    // 取出result通过napi_get_boolean接口将取出的bool值转换为napi_value类型的值返回出去
    napi_value returnValue = nullptr;
    napi_get_boolean(env, result, &returnValue);
    return returnValue;
}
// [End napi_is_error]

// [Start napi_get_and_clear_last_exception]
// napi_get_and_clear_last_exception
static napi_value GetAndClearLastException(napi_env env, napi_callback_info info)
{
    // 抛出异常，创造异常情况
    napi_throw_error(env, "napi_create_error errorCode", "napi_create_error errorMessage");
    // 调用napi_get_and_clear_last_exception接口获取并清除最后一个未处理的异常。即使存在挂起的ArkTS异常，也可以调用此API
    napi_value result = nullptr;
    napi_status status = napi_get_and_clear_last_exception(env, &result);
    if (status != napi_ok) {
        return nullptr;
    }
    return result;
}
// [End napi_get_and_clear_last_exception]

// [Start napi_is_exception_pending]
// napi_is_exception_pending
static napi_value IsExceptionPending(napi_env env, napi_callback_info info)
{
    napi_status status;
    bool isExceptionPending = false;
    // 在执行一些可能引发异常的操作后
    napi_throw_error(env, "napi_create_error errorCode", "napi_create_error errorMessage");
    // 检查当前环境中是否有异常挂起
    status = napi_is_exception_pending(env, &isExceptionPending);
    if (status != napi_ok) {
        return nullptr;
    }
    if (isExceptionPending) {
        // 处理异常挂起的情况
        napi_value result = nullptr;
        status = napi_get_and_clear_last_exception(env, &result);
        if (status != napi_ok) {
            return nullptr;
        }
        // 将处理的异常返回出去
        return result;
    }
    return nullptr;
}
// [End napi_is_exception_pending]

// [Start napi_fatal_error]
// napi_fatal_error
static napi_value FatalError(napi_env env, napi_callback_info info)
{
    // 请注意，使用napi_fatal_error函数会导致应用进程直接终止，因此应该谨慎使用，仅在遇到无法恢复的严重错误时才应该调用该函数
    // 模拟一个致命错误条件
    bool errorCondition = true;
    if (errorCondition) {
        // 创建一个致命错误信息
        napi_fatal_error("napi_fatal_error test", NAPI_AUTO_LENGTH, "napi_create_error errorMessage", NAPI_AUTO_LENGTH);
    }
    return nullptr;
}
// [End napi_fatal_error]

// [Start napi_fatal_exception]
// napi_fatal_exception
static napi_value FatalException(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok) {
        return nullptr;
    }
    // 请注意，使用napi_fatal_exception函数会导致应用进程直接终止，因此应该谨慎使用，仅在主线程遇到无法恢复的严重错误时才应该调用该函数
    // 模拟一个致命错误条件
    status = napi_fatal_exception(env, args[0]);
    if (status != napi_ok) {
        return nullptr;
    }
    return nullptr;
}
// [End napi_fatal_exception]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getLastErrorInfo", nullptr, GetLastErrorInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"creatTypeError", nullptr, CreatTypeError, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"creatRangeError", nullptr, CreatRangeError, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiThrow", nullptr, NapiThrow, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiThrowErrorMessage", nullptr, NapiThrowErrorMessage, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiThrowError", nullptr, NapiThrowError, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"throwTypeErrorMessage", nullptr, ThrowTypeErrorMessage, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"throwTypeError", nullptr, ThrowTypeError, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"throwRangeErrorMessage", nullptr, ThrowRangeErrorMessage, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"throwRangeError", nullptr, ThrowRangeError, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiIsError", nullptr, NapiIsError, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getAndClearLastException", nullptr, GetAndClearLastException, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"isExceptionPending", nullptr, IsExceptionPending, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"fatalError", nullptr, FatalError, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"fatalException", nullptr, FatalException, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
