/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start HttpInterceptor_build_project]
#include "napi/native_api.h"
#include "network/netstack/http_interceptor.h"
#include "network/netstack/http_interceptor_type.h"
#include "hilog/log.h"

#include <cstring>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200 // 全局domain宏，标识业务领域
#define LOG_TAG "HttpInterceptorDemo"  // 全局tag宏，标识模块日志tag

// 全局拦截器实例
static OH_Http_Interceptor g_responseInterceptor = {
    .groupId = 1,
    .stage = OH_STAGE_RESPONSE,
    .type = OH_TYPE_READ_ONLY,
    .enabled = 1,
    .handler = nullptr,
};

// 日志打印辅助函数
void LogHeader(OH_Http_Interceptor_Headers *headers)
{
    OH_LOG_INFO(LOG_APP, "---------------------header begin---------------------");
    while (headers != nullptr) {
        if (headers->data != nullptr) {
            OH_LOG_INFO(LOG_APP, "%{public}s", headers->data);
        }
        headers = headers->next;
    }
    OH_LOG_INFO(LOG_APP, "---------------------header end---------------------");
}

// 打印响应信息
void PrintResponseInfo(OH_Http_Interceptor_Response *response)
{
    OH_LOG_INFO(LOG_APP, "-----PrintResponseInfo Begin-----");
    if (response != nullptr) {
        OH_LOG_INFO(LOG_APP, "responseCode = %{public}d", response->responseCode);
        if (response->body.buffer != nullptr) {
            OH_LOG_INFO(LOG_APP, "body = %{public}s", response->body.buffer);
        }
        if (response->headers != nullptr) {
            LogHeader(response->headers);
        }

        OH_LOG_INFO(LOG_APP, "dns: %{public}lf", response->performanceTiming.dnsTiming);
        OH_LOG_INFO(LOG_APP, "tcp: %{public}lf", response->performanceTiming.tcpTiming);
        OH_LOG_INFO(LOG_APP, "tls: %{public}lf", response->performanceTiming.tlsTiming);
        OH_LOG_INFO(LOG_APP, "snd: %{public}lf", response->performanceTiming.firstSendTiming);
        OH_LOG_INFO(LOG_APP, "rcv: %{public}lf", response->performanceTiming.firstReceiveTiming);
        OH_LOG_INFO(LOG_APP, "tot: %{public}lf", response->performanceTiming.totalFinishTiming);
        OH_LOG_INFO(LOG_APP, "rdr: %{public}lf", response->performanceTiming.redirectTiming);
        OH_LOG_INFO(LOG_APP, "-----PrintResponseInfo End-----");
    }
}

// 响应拦截器处理函数
OH_Interceptor_Result ResponseInterceptorHandler(
    OH_Http_Interceptor_Request *request,
    OH_Http_Interceptor_Response *response,
    int32_t *isModified)
{
    (void)request;
    (void)isModified;
    
    if (response != nullptr) {
        OH_LOG_INFO(LOG_APP, "---Response Interceptor Handler---");
        PrintResponseInfo(response);
    }
    return OH_CONTINUE;
}

// 添加只读响应拦截器
static napi_value AddResponseInterceptor(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 设置拦截器处理函数
    g_responseInterceptor.handler = ResponseInterceptorHandler;
    
    // 添加拦截器
    int ret = OH_Http_AddReadOnlyInterceptor(&g_responseInterceptor);
    
    OH_LOG_INFO(LOG_APP, "AddResponseInterceptor ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 移除拦截器
static napi_value RemoveInterceptor(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 移除拦截器
    int ret = OH_Http_RemoveInterceptor(&g_responseInterceptor);
    
    OH_LOG_INFO(LOG_APP, "RemoveInterceptor ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 启用指定组的所有拦截器
static napi_value StartInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 启用组ID为1的所有拦截器
    int ret = OH_Http_StartAllInterceptors(1);
    
    OH_LOG_INFO(LOG_APP, "StartInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 停用指定组的所有拦截器
static napi_value StopInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 停用组ID为1的所有拦截器
    int ret = OH_Http_StopAllInterceptors(1);
    
    OH_LOG_INFO(LOG_APP, "StopInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 删除指定组的所有拦截器
static napi_value RemoveAllInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 删除组ID为1的所有拦截器
    int ret = OH_Http_RemoveAllInterceptors(1);
    
    OH_LOG_INFO(LOG_APP, "RemoveAllInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}
// [End HttpInterceptor_build_project]

// [Start HttpInterceptor_extern_c]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"AddResponseInterceptor", nullptr, AddResponseInterceptor, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"RemoveInterceptor", nullptr, RemoveInterceptor, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"StartInterceptors", nullptr, StartInterceptors, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"StopInterceptors", nullptr, StopInterceptors, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"RemoveAllInterceptors", nullptr, RemoveAllInterceptors, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END
// [End HttpInterceptor_extern_c]

// [Start HttpInterceptor_napi_module]
static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
// [End HttpInterceptor_napi_module]