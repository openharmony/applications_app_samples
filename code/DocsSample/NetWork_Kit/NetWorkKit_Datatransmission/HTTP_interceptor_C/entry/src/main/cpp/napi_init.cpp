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
#include <cstdlib>
#include <string>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200 // 全局domain宏，标识业务领域
#define LOG_TAG "HttpInterceptorDemo"  // 全局tag宏，标识模块日志tag

// 全局只读响应拦截器实例
static OH_Http_Interceptor g_readOnlyResponseInterceptor = {
    .groupId = 1,
    .stage = OH_STAGE_RESPONSE,
    .type = OH_TYPE_READ_ONLY,
    .enabled = 1,
    .handler = nullptr,
};

// 可修改请求拦截器实例（用于修改Network Kit的请求数据包）
static OH_Http_Interceptor g_modifyRequestInterceptor = {
    .groupId = 2,
    .stage = OH_STAGE_REQUEST,
    .type = OH_TYPE_MODIFY_NETWORK_KIT,
    .enabled = 1,
    .handler = nullptr,
};

// 可修改响应拦截器实例（用于修改Network Kit的响应数据包）
static OH_Http_Interceptor g_modifyResponseInterceptor = {
    .groupId = 3,
    .stage = OH_STAGE_RESPONSE,
    .type = OH_TYPE_MODIFY_NETWORK_KIT,
    .enabled = 1,
    .handler = nullptr,
};

// 内存分配和字符串拷贝辅助函数
char *MallocCString(const std::string &origin)
{
    if (origin.empty()) {
        return nullptr;
    }

    auto len = origin.length() + 1;
    char *res = static_cast<char *>(malloc(sizeof(char) * len));
    if (res == nullptr) {
        return nullptr;
    }
    return std::char_traits<char>::copy(res, origin.c_str(), len);
}

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

// 只读响应拦截器处理函数
OH_Interceptor_Result ReadOnlyResponseInterceptorHandler(
    OH_Http_Interceptor_Request *request,
    OH_Http_Interceptor_Response *response,
    int32_t *isModified)
{
    (void)request;
    (void)isModified;
    
    if (response != nullptr) {
        OH_LOG_INFO(LOG_APP, "---ReadOnly Response Interceptor Handler---");
        PrintResponseInfo(response);
    }
    return OH_CONTINUE;
}

// 修改请求方法
static void ModifyRequestMethod(OH_Http_Interceptor_Request *request)
{
    if (request->method.buffer != nullptr) {
        // 释放原有内存，必须使用free释放由malloc分配的内存
        free((void *)request->method.buffer);
        
        // 重新申请内存并设置新值，必须使用malloc分配内存
        const std::string newMethodStr = "GET";
        char *newMethodBuffer = MallocCString(newMethodStr);
        if (newMethodBuffer != nullptr) {
            request->method.buffer = newMethodBuffer;
            request->method.length = newMethodStr.length();
            OH_LOG_INFO(LOG_APP, "Modified Method: %{public}s", request->method.buffer);
        }
    }
}

// 修改第一个header节点
static void ModifyFirstHeaderNode(OH_Http_Interceptor_Headers **headers, const char *headerData)
{
    size_t headerLen = strlen(headerData) + 1;
    
    if (*headers != nullptr) {
        // 修改第一个header节点
        if ((*headers)->data != nullptr) {
            // 释放原有内存，必须使用free释放由malloc分配的内存
            free((void *)(*headers)->data);
        }
        // 必须使用malloc分配内存
        const std::string headerDataStr = headerData;
        char *headerBuffer = MallocCString(headerDataStr);
        if (headerBuffer != nullptr) {
            (*headers)->data = headerBuffer;
            OH_LOG_INFO(LOG_APP, "Modified first header: %{public}s", headerData);
        }
    } else {
        // 若没有header节点，创建新的第一个节点
        // 创建新的header节点，必须使用malloc分配内存
        OH_Http_Interceptor_Headers *newHeader =
            (OH_Http_Interceptor_Headers *)malloc(sizeof(OH_Http_Interceptor_Headers));
        if (newHeader != nullptr) {
            // 必须使用malloc分配内存
            const std::string headerDataStr = headerData;
            char *headerBuffer = MallocCString(headerDataStr);
            if (headerBuffer != nullptr) {
                newHeader->data = headerBuffer;
                newHeader->next = nullptr;
                *headers = newHeader;
                OH_LOG_INFO(LOG_APP, "Created first header: %{public}s", headerData);
            } else {
                // 内存分配失败，释放header节点，必须使用free释放由malloc分配的内存
                free((void *)newHeader);
            }
        }
    }
}

// 修改body内容
static void ModifyBodyContent(Http_Buffer *body, const char *newBodyContent)
{
    // 释放原有body内存，必须使用free释放由malloc分配的内存
    if (body->buffer != nullptr) {
        free((void *)body->buffer);
    }
    
    // 重新申请内存并设置新的body内容，必须使用malloc分配内存
    const std::string bodyContentStr = newBodyContent;
    char *bodyBuffer = MallocCString(bodyContentStr);
    if (bodyBuffer != nullptr) {
        body->buffer = bodyBuffer;
        body->length = bodyContentStr.length();
        OH_LOG_INFO(LOG_APP, "Modified Body: %{public}s", body->buffer);
    }
}

// 可修改请求拦截器处理函数（修改Network Kit的请求数据包）
OH_Interceptor_Result ModifyRequestInterceptorHandler(
    OH_Http_Interceptor_Request *request,
    OH_Http_Interceptor_Response *response,
    int32_t *isModified)
{
    (void)response;
    
    if (request != nullptr) {
        OH_LOG_INFO(LOG_APP, "---Modify Interceptor Handler---");
        OH_LOG_INFO(LOG_APP, "Original URL: %{public}s", request->url.buffer);
        OH_LOG_INFO(LOG_APP, "Original Method: %{public}s", request->method.buffer);
        
        // 修改请求方法
        ModifyRequestMethod(request);
        
        // 修改第一个请求头
        const char *requestHeaderData = "X-Custom-Header: CustomValue";
        ModifyFirstHeaderNode(&request->headers, requestHeaderData);
        
        // 修改请求体
        const char *requestBodyData = "{\"key\": \"value\"}";
        ModifyBodyContent(&request->body, requestBodyData);
        
        // 标记为已修改
        *isModified = 1;
        OH_LOG_INFO(LOG_APP, "Request modified: %{public}d", *isModified);
    }
    
    // 返回OH_CONTINUE表示继续处理请求
    // 返回OH_ABORT表示中止请求，请求将不会发送到服务器
    return OH_CONTINUE;
}

// 可修改响应拦截器处理函数（修改Network Kit的响应数据包）
OH_Interceptor_Result ModifyResponseInterceptorHandler(
    OH_Http_Interceptor_Request *request,
    OH_Http_Interceptor_Response *response,
    int32_t *isModified)
{
    (void)request;
    
    if (response != nullptr) {
        OH_LOG_INFO(LOG_APP, "---Modify Response Interceptor Handler---");
        OH_LOG_INFO(LOG_APP, "Original Response Code: %{public}d", response->responseCode);
        if (response->body.buffer != nullptr) {
            OH_LOG_INFO(LOG_APP, "Original Response Body: %{public}s", response->body.buffer);
        }
        
        // 修改响应体
        const char *responseBodyData = "{\"modified\": true, \"message\": \"Response modified by interceptor\"}";
        ModifyBodyContent(&response->body, responseBodyData);
        
        // 修改第一个响应头
        const char *responseHeaderData = "X-Intercepted: true";
        ModifyFirstHeaderNode(&response->headers, responseHeaderData);
        
        // 标记为已修改
        *isModified = 1;
        OH_LOG_INFO(LOG_APP, "Response modified: %{public}d", *isModified);
    }
    
    // 返回OH_CONTINUE表示继续处理响应
    // 返回OH_ABORT表示终止当前拦截器链的执行
    return OH_CONTINUE;
}

// 添加只读响应拦截器
static napi_value AddReadOnlyResponseInterceptor(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 设置拦截器处理函数
    g_readOnlyResponseInterceptor.handler = ReadOnlyResponseInterceptorHandler;
    
    // 添加拦截器
    int ret = OH_Http_AddReadOnlyInterceptor(&g_readOnlyResponseInterceptor);
    
    OH_LOG_INFO(LOG_APP, "AddReadOnlyResponseInterceptor ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 移除只读响应拦截器
static napi_value RemoveReadOnlyResponseInterceptor(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 移除拦截器
    int ret = OH_Http_RemoveInterceptor(&g_readOnlyResponseInterceptor);
    
    OH_LOG_INFO(LOG_APP, "RemoveReadOnlyResponseInterceptor ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 启用只读响应拦截器组
static napi_value StartReadOnlyResponseInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 启用组ID为1的所有拦截器
    int ret = OH_Http_StartAllInterceptors(1);
    
    OH_LOG_INFO(LOG_APP, "StartReadOnlyResponseInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 停用只读响应拦截器组
static napi_value StopReadOnlyResponseInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 停用组ID为1的所有拦截器
    int ret = OH_Http_StopAllInterceptors(1);
    
    OH_LOG_INFO(LOG_APP, "StopReadOnlyResponseInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 删除只读响应拦截器组
static napi_value RemoveAllReadOnlyResponseInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 删除组ID为1的所有拦截器
    int ret = OH_Http_RemoveAllInterceptors(1);
    
    OH_LOG_INFO(LOG_APP, "RemoveAllReadOnlyResponseInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 添加可修改请求拦截器（OH_TYPE_MODIFY_NETWORK_KIT类型）
static napi_value AddModifyRequestInterceptor(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 设置拦截器处理函数
    g_modifyRequestInterceptor.handler = ModifyRequestInterceptorHandler;
    
    // 添加可修改拦截器
    int ret = OH_Http_AddWritableInterceptor(&g_modifyRequestInterceptor);
    
    OH_LOG_INFO(LOG_APP, "AddModifyRequestInterceptor ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 移除可修改请求拦截器
static napi_value RemoveModifyRequestInterceptor(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 移除拦截器
    int ret = OH_Http_RemoveInterceptor(&g_modifyRequestInterceptor);
    
    OH_LOG_INFO(LOG_APP, "RemoveModifyRequestInterceptor ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 启用可修改请求拦截器组
static napi_value StartModifyRequestInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 启用组ID为2的所有拦截器
    int ret = OH_Http_StartAllInterceptors(2);
    
    OH_LOG_INFO(LOG_APP, "StartModifyRequestInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 停用可修改请求拦截器组
static napi_value StopModifyRequestInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 停用组ID为2的所有拦截器
    int ret = OH_Http_StopAllInterceptors(2);
    
    OH_LOG_INFO(LOG_APP, "StopModifyRequestInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 删除可修改请求拦截器组
static napi_value RemoveAllModifyRequestInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 删除组ID为2的所有拦截器
    int ret = OH_Http_RemoveAllInterceptors(2);
    
    OH_LOG_INFO(LOG_APP, "RemoveAllModifyRequestInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 添加可修改响应拦截器（OH_TYPE_MODIFY_NETWORK_KIT类型）
static napi_value AddModifyResponseInterceptor(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 设置拦截器处理函数
    g_modifyResponseInterceptor.handler = ModifyResponseInterceptorHandler;
    
    // 添加可修改拦截器
    int ret = OH_Http_AddWritableInterceptor(&g_modifyResponseInterceptor);
    
    OH_LOG_INFO(LOG_APP, "AddModifyResponseInterceptor ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 移除可修改响应拦截器
static napi_value RemoveModifyResponseInterceptor(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 移除拦截器
    int ret = OH_Http_RemoveInterceptor(&g_modifyResponseInterceptor);
    
    OH_LOG_INFO(LOG_APP, "RemoveModifyResponseInterceptor ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 启用可修改响应拦截器组
static napi_value StartModifyResponseInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 启用组ID为3的所有拦截器
    int ret = OH_Http_StartAllInterceptors(3);
    
    OH_LOG_INFO(LOG_APP, "StartModifyResponseInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 停用可修改响应拦截器组
static napi_value StopModifyResponseInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 停用组ID为3的所有拦截器
    int ret = OH_Http_StopAllInterceptors(3);
    
    OH_LOG_INFO(LOG_APP, "StopModifyResponseInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}

// 删除可修改响应拦截器组
static napi_value RemoveAllModifyResponseInterceptors(napi_env env, napi_callback_info info)
{
    napi_value result;
    
    // 删除组ID为3的所有拦截器
    int ret = OH_Http_RemoveAllInterceptors(3);
    
    OH_LOG_INFO(LOG_APP, "RemoveAllModifyResponseInterceptors ret: %{public}d", ret);
    napi_create_int32(env, ret, &result);
    return result;
}
// [End HttpInterceptor_build_project]

// [Start HttpInterceptor_extern_c]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"AddReadOnlyResponseInterceptor", nullptr, AddReadOnlyResponseInterceptor, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"RemoveReadOnlyResponseInterceptor", nullptr, RemoveReadOnlyResponseInterceptor, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"StartReadOnlyResponseInterceptors", nullptr, StartReadOnlyResponseInterceptors, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"StopReadOnlyResponseInterceptors", nullptr, StopReadOnlyResponseInterceptors, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"RemoveAllReadOnlyResponseInterceptors", nullptr, RemoveAllReadOnlyResponseInterceptors, nullptr, nullptr,
            nullptr, napi_default, nullptr},
        {"AddModifyRequestInterceptor", nullptr, AddModifyRequestInterceptor, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"RemoveModifyRequestInterceptor", nullptr, RemoveModifyRequestInterceptor, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"StartModifyRequestInterceptors", nullptr, StartModifyRequestInterceptors, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"StopModifyRequestInterceptors", nullptr, StopModifyRequestInterceptors, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"RemoveAllModifyRequestInterceptors", nullptr, RemoveAllModifyRequestInterceptors, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"AddModifyResponseInterceptor", nullptr, AddModifyResponseInterceptor, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"RemoveModifyResponseInterceptor", nullptr, RemoveModifyResponseInterceptor, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"StartModifyResponseInterceptors", nullptr, StartModifyResponseInterceptors, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"StopModifyResponseInterceptors", nullptr, StopModifyResponseInterceptors, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"RemoveAllModifyResponseInterceptors", nullptr, RemoveAllModifyResponseInterceptors, nullptr, nullptr,
            nullptr, napi_default, nullptr},
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