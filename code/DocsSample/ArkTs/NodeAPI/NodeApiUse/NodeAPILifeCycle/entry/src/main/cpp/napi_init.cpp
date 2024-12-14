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

// napi_open_handle_scope、napi_close_handle_scope
static napi_value HandleScopeTest(napi_env env, napi_callback_info info)
{
    // 通过调用napi_open_handle_scope来创建一个句柄作用域
    napi_handle_scope scope;
    napi_open_handle_scope(env, &scope);
    // 在句柄作用域内创建一个obj
    napi_value obj = nullptr;
    napi_create_object(env, &obj);
    // 在对象中添加属性
    napi_value value = nullptr;
    napi_create_string_utf8(env, "handleScope", NAPI_AUTO_LENGTH, &value);
    napi_set_named_property(env, obj, "key", value);
    // 在作用域内获取obj的属性并返回
    napi_value result = nullptr;
    napi_get_named_property(env, obj, "key", &result);
    // 关闭句柄作用域，自动释放在该作用域内创建的对象句柄
    napi_close_handle_scope(env, scope);
    // 此处的result能够得到值“handleScope”
    return result;
}

static napi_value HandleScope(napi_env env, napi_callback_info info)
{
    // 通过调用napi_open_handle_scope来创建一个句柄作用域
    napi_handle_scope scope;
    napi_open_handle_scope(env, &scope);
    // 在句柄作用域内创建一个obj
    napi_value obj = nullptr;
    napi_create_object(env, &obj);
    // 在对象中添加属性
    napi_value value = nullptr;
    napi_create_string_utf8(env, "handleScope", NAPI_AUTO_LENGTH, &value);
    napi_set_named_property(env, obj, "key", value);
    // 关闭句柄作用域，自动释放在该作用域内创建的对象句柄
    napi_close_handle_scope(env, scope);
    // 在作用域外获取obj的属性并返回，此处只能得到“undefined”
    napi_value result = nullptr;
    napi_get_named_property(env, obj, "key", &result);
    return result;
}

// napi_open_escapable_handle_scope、napi_close_escapable_handle_scope、napi_escape_handle
static napi_value EscapableHandleScopeTest(napi_env env, napi_callback_info info)
{
    // 创建一个可逃逸的句柄作用域
    napi_escapable_handle_scope scope;
    napi_open_escapable_handle_scope(env, &scope);
    // 在可逃逸的句柄作用域内创建一个obj
    napi_value obj = nullptr;
    napi_create_object(env, &obj);
    // 在对象中添加属性
    napi_value value = nullptr;
    napi_create_string_utf8(env, "Test napi_escapable_handle_scope", NAPI_AUTO_LENGTH, &value);
    napi_set_named_property(env, obj, "key", value);
    // 调用napi_escape_handle将对象逃逸到作用域之外
    napi_value escapedObj = nullptr;
    napi_escape_handle(env, scope, obj, &escapedObj);
    // 关闭可逃逸的句柄作用域，清理资源
    napi_close_escapable_handle_scope(env, scope);
    // 在获取逃逸后的obj：escapedObj的属性并返回，此处也能够得到“napi_escapable_handle_scope”
    napi_value result = nullptr;
    // 为了验证逃逸的实现，可以在此处获取obj的属性，此处会得到“undefined”
    napi_get_named_property(env, escapedObj, "key", &result);
    return result;
}

// 创建一个指向napi_ref类型的指针，用于存储创建的引用。在调用napi_create_reference函数之前，你需要分配一个napi_ref类型的变量，并将其地址传递给result位置的参数
napi_ref g_ref;

void Finalizer(napi_env env, void *data, void *hint)
{
    // 执行资源清理操作
    OH_LOG_INFO(LOG_APP, "Node-API: Use terminators to release resources.");
}

static napi_value CreateReference(napi_env env, napi_callback_info info)
{
    napi_value obj = nullptr;
    napi_create_object(env, &obj);
    napi_value value = nullptr;
    napi_create_string_utf8(env, "CreateReference", NAPI_AUTO_LENGTH, &value);
    // 将键值对添加到对象中
    napi_set_named_property(env, obj, "key", value);
    // 创建对ArkTS对象的引用
    napi_status status = napi_create_reference(env, obj, 1, &g_ref);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_create_reference fail");
        return nullptr;
    }
    // 添加终结器
    void *data = {};
    napi_add_finalizer(env, obj, data, Finalizer, nullptr, &g_ref);
    // 增加传入引用的引用计数并返回生成的引用计数
    uint32_t result = 0;
    napi_reference_ref(env, g_ref, &result);
    OH_LOG_INFO(LOG_APP, "napi_reference_ref, count = %{public}d.", result);
    uint32_t numCount = 2;
    if (result != numCount) {
        // 若传入引用的引用计数未增加，则抛出错误
        napi_throw_error(env, nullptr, "napi_reference_ref fail");
        return nullptr;
    }
    return obj;
}

static napi_value UseReference(napi_env env, napi_callback_info info)
{
    napi_value obj = nullptr;
    // 通过调用napi_get_reference_value获取引用的ArkTS对象
    napi_status status = napi_get_reference_value(env, g_ref, &obj);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_get_reference_value fail");
        return nullptr;
    }
    // 将获取到的对象返回
    return obj;
}

static napi_value DeleteReference(napi_env env, napi_callback_info info)
{
    // 减少传入引用的引用计数并返回生成的引用计数
    uint32_t result = 0;
    napi_value count = nullptr;
    napi_reference_unref(env, g_ref, &result);
    OH_LOG_INFO(LOG_APP, "napi_reference_ref, count = %{public}d.", result);
    uint32_t numCount = 1;
    if (result != numCount) {
        // 若传入引用的引用计数未减少，则抛出错误
        napi_throw_error(env, nullptr, "napi_reference_unref fail");
        return nullptr;
    }
    // 通过调用napi_delete_reference删除对ArkTS对象的引用
    napi_status status = napi_delete_reference(env, g_ref);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_delete_reference fail");
        return nullptr;
    }
    napi_value returnResult = nullptr;
    napi_create_string_utf8(env, "napi_delete_reference success", NAPI_AUTO_LENGTH, &returnResult);
    return returnResult;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"handleScopeTest", nullptr, HandleScopeTest, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"handleScope", nullptr, HandleScope, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"escapableHandleScopeTest", nullptr, EscapableHandleScopeTest, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"createReference", nullptr, CreateReference, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"useReference", nullptr, UseReference, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"deleteReference", nullptr, DeleteReference, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
