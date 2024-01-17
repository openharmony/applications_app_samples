/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
#include "hilog/log.h"
#include "js_native_api.h"
#include "uv.h"
#include <thread>

napi_threadsafe_function tsfn; // 线程安全函数
static int g_cValue;             // 保存value最新的值,作为参数传给js回调函数
int g_threadNum = 3;            // 线程数

struct CallbackContext {
    napi_env env = nullptr;
    napi_ref callbackRef = nullptr;
    int retData = 0;
};

void WorkCallback(uv_work_t *workReq)
{
    // 另外一个子线程,一些耗时操作可以在此进行. 此处不能调用js函数.
    CallbackContext *context = (CallbackContext *)workReq->data;
    if (context != nullptr) {
        OH_LOG_INFO(LOG_APP, "UvWorkTest CallBack1 childThread_2 [%{public}d]", context->retData);
        context->retData++;
        OH_LOG_INFO(LOG_APP, "UvWorkTest CallBack2 childThread_2 [%{public}d]", context->retData);
    } else {
        OH_LOG_INFO(LOG_APP, "UvWorkTest CallBack3 childThread_2 context is null.");
    }
}

void AfterWorkCallback(uv_work_t *workReq, int status)
{
    CallbackContext *context = (CallbackContext *)workReq->data;
    // 主线程执行，可以在此调用js函数
    OH_LOG_INFO(LOG_APP, "UvWorkTest CallBack mainThread [%{public}d]", context->retData);
    napi_handle_scope scope = nullptr;
    napi_open_handle_scope(context->env, &scope);
    if (scope == nullptr) {
        if (context != nullptr) {
            napi_delete_reference(context->env, context->callbackRef);
            delete context;
            context = nullptr;
        }
        if (workReq != nullptr) {
            delete workReq;
            workReq = nullptr;
        }
        return;
    }
    napi_value callback = nullptr;
    napi_get_reference_value(context->env, context->callbackRef, &callback);
    napi_value retArg;
    OH_LOG_INFO(LOG_APP, "UvWorkTest CallBack begin [%{public}d]", g_cValue);
    napi_create_int32(context->env, g_cValue, &retArg);
    napi_value ret;
    napi_call_function(context->env, nullptr, callback, 1, &retArg, &ret);
    // 保存js回调结果
    napi_get_value_int32(context->env, ret, &g_cValue);
    OH_LOG_INFO(LOG_APP, "UvWorkTest CallBack end [%{public}d]", g_cValue);

    napi_close_handle_scope(context->env, scope);
    if (context != nullptr) {
        napi_delete_reference(context->env, context->callbackRef);
        delete context;
        OH_LOG_INFO(LOG_APP, "UvWorkTest delete context");
        context = nullptr;
    }
    if (workReq != nullptr) {
        delete workReq;
        OH_LOG_INFO(LOG_APP, "UvWorkTest delete work");
        workReq = nullptr;
    }
}

void CallbackUvWorkTest(CallbackContext *context)
{
    if (context == nullptr) {
        OH_LOG_ERROR(LOG_APP, "UvWorkTest context is nullptr");
        return;
    }
    uv_loop_s *loop = nullptr;
    napi_get_uv_event_loop(context->env, &loop);
    // 创建工作数据结构,自定义数据结构添加在data中
    uv_work_t *workReq = new uv_work_t;
    if (workReq == nullptr) {
        if (context != nullptr) {
            napi_delete_reference(context->env, context->callbackRef);
            delete context;
            OH_LOG_INFO(LOG_APP, "UvWorkTest delete context");
            context = nullptr;
        }
        OH_LOG_ERROR(LOG_APP, "UvWorkTest new uv_work_t fail!");
        return;
    }
    workReq->data = (void *)context;
    // 此打印位于子线程
    OH_LOG_INFO(LOG_APP, "UvWorkTest childThread_1 [%{public}d]", g_cValue);
    // 添加工作任务到libuv的队列中
    uv_queue_work(loop, workReq, WorkCallback, AfterWorkCallback);
}

// 使用uv_work callback 实现跨线程调用js函数
static napi_value UvWorkTest(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = {0};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    napi_valuetype valueType = napi_undefined;
    napi_typeof(env, argv[0], &valueType);
    if (valueType != napi_function) {
        OH_LOG_ERROR(LOG_APP, "UvWorkTest param is not function");
        return nullptr;
    }

    OH_LOG_INFO(LOG_APP, "UvWorkTest current value:[%{public}d]", g_cValue);
    for (int i = 0; i < g_threadNum; i++) {
        auto asyncContext = new CallbackContext();
        if (asyncContext == nullptr) {
            OH_LOG_ERROR(LOG_APP, "UvWorkTest new asyncContext fail!");
            return nullptr;
        }
        asyncContext->env = env;
        asyncContext->retData = i;
        OH_LOG_INFO(LOG_APP, "UvWorkTest thread begin index:[%{public}d], value:[%{public}d]", i, g_cValue);
        napi_create_reference(env, argv[0], 1, &asyncContext->callbackRef);
        // using callback function on other thread
        std::thread testThread(CallbackUvWorkTest, asyncContext);
        testThread.detach();
        OH_LOG_INFO(LOG_APP, "UvWorkTest thread end index:[%{public}d], value:[%{public}d]", i, g_cValue);
    }
    return nullptr;
}

// 安全函数回调
static void ThreadSafeCallJs(napi_env env, napi_value js_cb, void *context, void *data)
{
    CallbackContext *argContent = (CallbackContext *)data;
    if (argContent != nullptr) {
        OH_LOG_INFO(LOG_APP, "ThreadSafeTest CallJs start, retData:[%{public}d]", argContent->retData);
        napi_get_reference_value(env, argContent->callbackRef, &js_cb);
    } else {
        OH_LOG_INFO(LOG_APP, "ThreadSafeTest CallJs argContent is null");
        return;
    }

    napi_valuetype valueType = napi_undefined;
    napi_typeof(env, js_cb, &valueType);
    if (valueType != napi_valuetype::napi_function) {
        OH_LOG_ERROR(LOG_APP, "ThreadSafeTest callback param is not function");
        if (argContent != nullptr) {
            napi_delete_reference(env, argContent->callbackRef);
            delete argContent;
            argContent = nullptr;
            OH_LOG_INFO(LOG_APP, "ThreadSafeTest delete argContent");
        }
        return;
    }
    // 将当前value值作为参数调用js函数
    napi_value argv;
    napi_create_int32(env, g_cValue, &argv);
    napi_value result = nullptr;
    napi_call_function(env, nullptr, js_cb, 1, &argv, &result);
    // g_cValue保存调用js后的返回结果
    napi_get_value_int32(env, result, &g_cValue);
    OH_LOG_INFO(LOG_APP, "ThreadSafeTest CallJs end, [%{public}d]", g_cValue);
    if (argContent != nullptr) {
        napi_delete_reference(env, argContent->callbackRef);
        delete argContent;
        argContent = nullptr;
        OH_LOG_INFO(LOG_APP, "ThreadSafeTest delete argContent end");
    }
}

// 使用安全函数跨线程调用js函数
static napi_value ThreadSafeTest(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value js_cb;
    napi_value workName;
    // 获取ArkTS 参数
    napi_get_cb_info(env, info, &argc, &js_cb, nullptr, nullptr);
    // 判断参数类型
    napi_valuetype valueType = napi_undefined;
    napi_typeof(env, js_cb, &valueType);
    if (valueType != napi_valuetype::napi_function) {
        OH_LOG_ERROR(LOG_APP, "ThreadSafeTest callback param is not function");
        return nullptr;
    }
    OH_LOG_INFO(LOG_APP, "ThreadSafeTest current value: [%{public}d]", g_cValue);

    // 使用安全线程跨线程调用js 函数
    napi_create_string_utf8(env, "workItem", NAPI_AUTO_LENGTH, &workName);
    // 创建线程安全函数
    napi_create_threadsafe_function(env, js_cb, NULL, workName, 0, 1, NULL, NULL, NULL, ThreadSafeCallJs, &tsfn);
    // 在子线程中调用线程安全函数
    for (int i = 0; i < g_threadNum; i++) {
        // 创建回调参数
        auto asyncContext = new CallbackContext();
        asyncContext->env = env;
        asyncContext->retData = i;
        napi_create_reference(env, js_cb, 1, &asyncContext->callbackRef);
        std::thread t([asyncContext]() {
            // 处理业务逻辑
            OH_LOG_INFO(LOG_APP, "ThreadSafeTest ChildTread start, index:[%{public}d], value: [%{public}d]",
                        asyncContext->retData, g_cValue);
            asyncContext->retData++;
            // 请求线程安全函数
            napi_acquire_threadsafe_function(tsfn);
            // 调用线程安全函数
            napi_call_threadsafe_function(tsfn, asyncContext, napi_tsfn_nonblocking);
            OH_LOG_INFO(LOG_APP, "ThreadSafeTest ChildTread end, index:[%{public}d], value: [%{public}d]",
                        asyncContext->retData, g_cValue);

            /* 以下直接在子线程中调用js函数,会崩溃
            napi_value result = nullptr;
            napi_value argv;
            napi_create_int32(env,g_cValue, &argv);
            napi_call_function(env, nullptr, js_cb, 1, &argv, &result);
          */
        });
        t.join();
    }
    // 释放安全线程
    napi_status status = napi_release_threadsafe_function(tsfn, napi_tsfn_release);
    if (status == napi_status::napi_ok) {
        OH_LOG_INFO(LOG_APP, "ThreadSafeTest napi_tsfn_release success.");
    } else {
        OH_LOG_INFO(LOG_APP, "ThreadSafeTest napi_tsfn_release fail !");
    }
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // 第一个参数"add"为ArkTS侧对应方法的名称。
    napi_property_descriptor desc[] = {
        {"UvWorkTest", nullptr, UvWorkTest, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"ThreadSafeTest", nullptr, ThreadSafeTest, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

// 准备模块加载相关信息，将上述Init函数与本模块名等信息记录下来。
static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterModule(void) { napi_module_register(&demoModule); }
