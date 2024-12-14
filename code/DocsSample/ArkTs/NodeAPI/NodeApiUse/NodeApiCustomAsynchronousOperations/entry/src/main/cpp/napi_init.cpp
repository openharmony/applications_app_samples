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

static constexpr int INT_ARG_3 = 3; // 入参索引

static napi_value AsynchronousWork(napi_env env, napi_callback_info info)
{
    // 接受四个参数
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    // 从回调信息中获取参数
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 提取参数中的资源、接收器对象和函数
    napi_value resource = args[0];
    napi_value recv = args[1];
    napi_value func = args[2];
    napi_value argv[1] = {nullptr};
    argv[0] = args[INT_ARG_3];
    // 获取函数的类型
    napi_valuetype funcType;
    napi_typeof(env, func, &funcType);
    // 创建一个资源名称为"test"的字符串
    napi_value resourceName = nullptr;
    napi_create_string_utf8(env, "test", NAPI_AUTO_LENGTH, &resourceName);
    // 初始化异步上下文
    napi_async_context context;
    napi_status status = napi_async_init(env, resource, resourceName, &context);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_async_init fail");
        return nullptr;
    }
    // 打开回调作用域
    napi_callback_scope scope = nullptr;
    napi_open_callback_scope(env, resource, context, &scope);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_open_callback_scope fail");
        return nullptr;
    }
    // 调用回调函数
    napi_value result = nullptr;
    if (funcType == napi_function) {
        napi_make_callback(env, context, recv, func, 1, argv, &result);
    } else {
        napi_throw_error(env, nullptr, "Unexpected argument type");
        return nullptr;
    }
    // 关闭回调作用域
    napi_close_callback_scope(env, scope);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_close_callback_scope fail");
        return nullptr;
    }
    // 销毁异步上下文
    napi_async_destroy(env, context);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"asynchronousWork", nullptr, AsynchronousWork, nullptr, nullptr, nullptr, napi_default, nullptr},
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
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
