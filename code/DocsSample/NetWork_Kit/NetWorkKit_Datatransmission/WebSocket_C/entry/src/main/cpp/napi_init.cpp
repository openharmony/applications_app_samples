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
#include "network/netstack/net_websocket.h"
#include "network/netstack/net_websocket_type.h"
#include "hilog/log.h"

#include <cstring>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200 // 全局domain宏，标识业务领域
#define LOG_TAG "WSDEMO"  // 全局tag宏，标识模块日志tag

// WebSocket客户端全局变量
static struct WebSocket *g_client = nullptr;

static void onOpen(struct WebSocket *wsClient, WebSocket_OpenResult openResult)
{
    (void)wsClient;
    OH_LOG_INFO(LOG_APP, "onOpen: code: %{public}u, reason: %{public}s", openResult.code, openResult.reason);
}

static void onMessage(struct WebSocket *wsClient, char *data, uint32_t length)
{
    (void)wsClient;
    char *tmp = new char[length + 1];
    for (uint32_t i = 0; i < length; i++) {
        tmp[i] = data[i];
    }
    tmp[length] = '\0';
    OH_LOG_INFO(LOG_APP, "onMessage: len: %{public}u, data: %{public}s", length, tmp);
}

static void onError(struct WebSocket *wsClient, WebSocket_ErrorResult errorResult)
{
    (void)wsClient;
    OH_LOG_INFO(LOG_APP, "onError: code: %{public}u, message: %{public}s", errorResult.errorCode,
                errorResult.errorMessage);
}

static void onClose(struct WebSocket *wsClient, WebSocket_CloseResult closeResult)
{
    (void)wsClient;
    OH_LOG_INFO(LOG_APP, "onClose: code: %{public}u, reason: %{public}s", closeResult.code, closeResult.reason);
}

static napi_value ConnectWebsocket(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t length = 0;
    napi_status status = napi_get_value_string_utf8(env, args[0], nullptr, 0, &length);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    if (g_client != nullptr) {
        OH_LOG_INFO(LOG_APP, "there is already one websocket client running.");
        napi_get_boolean(env, false, &result);
        return result;
    }
    char *buf = new char[length + 1];
    std::memset(buf, 0, length + 1);
    napi_get_value_string_utf8(env, args[0], buf, length + 1, &length);
    // 创建WebSocket Client对象指针
    g_client = OH_WebSocketClient_Constructor(onOpen, onMessage, onError, onClose);
    if (g_client == nullptr) {
        delete[] buf;
        napi_get_boolean(env, false, &result);
        return result;
    }
    // 连接buf存放的URL对应的WebSocket服务器
    int connectRet = OH_WebSocketClient_Connect(g_client, buf, {});

    delete[] buf;
    napi_get_boolean(env, connectRet == 0, &result);
    return result;
}

static napi_value SendMessage(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value result;

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t length = 0;
    napi_status status = napi_get_value_string_utf8(env, args[0], nullptr, 0, &length);
    if (status != napi_ok) {
        napi_create_int32(env, -1, &result);
        return result;
    }

    if (g_client == nullptr) {
        OH_LOG_INFO(LOG_APP, "websocket client not connected.");
        napi_create_int32(env, WebSocket_ErrCode::WEBSOCKET_CLIENT_NULL, &result);
        return result;
    }
    char *buf = new char[length + 1];
    std::memset(buf, 0, length + 1);
    napi_get_value_string_utf8(env, args[0], buf, length + 1, &length);
    // 发送buf中的消息给服务器
    int ret = OH_WebSocketClient_Send(g_client, buf, length);

    delete[] buf;
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value CloseWebsocket(napi_env env, napi_callback_info info)
{
    napi_value result;
    if (g_client == nullptr) {
        OH_LOG_INFO(LOG_APP, "websocket client not connected.");
        napi_create_int32(env, -1, &result);
        return result;
    }
    // 关闭WebSocket连接
    int ret = OH_WebSocketClient_Close(g_client, {
                                                   .code = 0,
                                                   .reason = "Actively Close",
                                               });
    // 释放WebSocket资源并置空
    OH_WebSocketClient_Destroy(g_client);
    g_client = nullptr;
    napi_create_int32(env, ret, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"Connect", nullptr, ConnectWebsocket, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Send", nullptr, SendMessage, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"Close", nullptr, CloseWebsocket, nullptr, nullptr, nullptr, napi_default, nullptr},
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