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

// [Start the_node_api_layer_code_for_the_data_channel_between_the_application_side_and_the_frontend_page]
#include "napi/native_api.h"
#include <bits/alltypes.h>
#include <memory>
#include <string>
#include <sys/types.h>
#include <iostream>
#include <map>
#include "hilog/log.h"
#include "web/arkweb_interface.h"
#include <thread>

constexpr unsigned int LOG_PRINT_DOMAIN = 0xFF00;
ArkWeb_ControllerAPI *controller = nullptr;

ArkWeb_WebMessagePortAPI *webMessagePort = nullptr;
ArkWeb_WebMessageAPI *webMessage = nullptr;
size_t g_webMessagePortSize = 0;
ArkWeb_WebMessagePortPtr *g_web_message_port_arr = nullptr;

static void WebMessagePortCallback(
    const char *webTag, const ArkWeb_WebMessagePortPtr port, const ArkWeb_WebMessagePtr message, void *userData)
{
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit WebMesagePortCallback webTag:%{public}s,messageType:%{public}d",
        webTag, webMessage->getType(message));
    size_t len = 0;
    void *back = webMessage->getData(message, &len);
    if (webMessage->getType(message) == ArkWeb_WebMessageType::ARKWEB_STRING) {
        OH_LOG_Print(
            LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
            "Native Development Kit WebMesagePortCallback message:%{public}s,messageSize:%{public}d", back, len);
    } else if (webMessage->getType(message) == ArkWeb_WebMessageType::ARKWEB_BUFFER) {
        OH_LOG_Print(
            LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
            "Native Development Kit WebMesagePortCallback messageSize:%{public}d", len);
    }
}

static napi_value NativeWebInit(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit NativeWebInit start");
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit NativeWebInit webTag:%{public}s", webTagValue);

    controller = reinterpret_cast<ArkWeb_ControllerAPI *>(OH_ArkWeb_GetNativeAPI(ARKWEB_NATIVE_CONTROLLER));
    if (controller)
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "get ArkWeb_ControllerAPI success");

    webMessagePort =
        reinterpret_cast<ArkWeb_WebMessagePortAPI *>(OH_ArkWeb_GetNativeAPI(ARKWEB_NATIVE_WEB_MESSAGE_PORT));
    if (webMessagePort)
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "get ArkWeb_WebMessagePortAPI success");

    webMessage = reinterpret_cast<ArkWeb_WebMessageAPI *>(OH_ArkWeb_GetNativeAPI(ARKWEB_NATIVE_WEB_MESSAGE));
    if (webMessage)
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "get ArkWeb_WebMessageAPI success");

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit NativeWebInit end");

    return nullptr;
}

static napi_value createWebMessagePorts(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 初始化端口
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit createWebMessagePorts begin");
    g_web_message_port_arr = controller->createWebMessagePorts(webTagValue, &g_webMessagePortSize);
    // 把其中一个端口发送给HTML
    ArkWeb_ErrorCode code =
        controller->postWebMessage(webTagValue, "init_web_messageport", g_web_message_port_arr, 1, "*");
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit postWebMessage ArkWeb_ErrorCode:%{public}d", code);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit createWebMessagePorts end, web message port size:%{public}d", g_webMessagePortSize);
    return nullptr;
}

static napi_value postMessage(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 发送消息
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit postMessage begin");

    if (g_web_message_port_arr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "webMessagePort is nullptr");
        return nullptr;
    }
    ArkWeb_WebMessagePtr message = webMessage->createWebMessage();
    webMessage->setType(message, ArkWeb_WebMessageType::ARKWEB_STRING);
    std::string str = "send string from native";
    webMessage->setData(message, (void *)str.c_str(), str.length() + 1);
    ArkWeb_ErrorCode code = webMessagePort->postMessage(g_web_message_port_arr[1], webTagValue, message);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit postMessage ArkWeb_ErrorCode:%{public}d", code);
    webMessage->destroyWebMessage(&message);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit postMessage end, web message port size:%{public}d", g_webMessagePortSize);
    return nullptr;
}


// 在线程中发消息
void sendMessage(const char *webTag, const ArkWeb_WebMessagePtr message)
{
    // 发送1000次
    for (int i = 0; i < 1000; i++) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "sendMessage in thread %{public}d", i);
        if (g_web_message_port_arr && webTag && message) {
                webMessagePort->postMessage(g_web_message_port_arr[1], webTag, message);
        }
    }
}
static napi_value postMessageThread(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 构造消息
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit postMessage begin");

    if (g_web_message_port_arr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "webMessagePort is nullptr");
        return nullptr;
    }
    ArkWeb_WebMessagePtr message = webMessage->createWebMessage();
    webMessage->setType(message, ArkWeb_WebMessageType::ARKWEB_STRING);
    std::string str = "thread message";
    webMessage->setData(message, (void *)str.c_str(), str.length() + 1);
    const int numThreads = 5;
    std::thread threads[numThreads];

    // 创建线程
    for (int i = 0; i < numThreads; ++i) {
        threads[i] = std::thread(sendMessage, webTagValue, message);
    }

    // 等待所有线程完成
    for (int i = 0; i < numThreads; ++i) {
        threads[i].detach();
    }
    return nullptr;
}

// 在线程中注册回调
void SetHandler(const char *webTag)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "setMessageEventHandler in thread");
    webMessagePort->setMessageEventHandler(g_web_message_port_arr[1], webTag, WebMessagePortCallback, NULL);
}

static napi_value setMessageEventHandlerThread(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 注册回调
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit SetMessageEventHandler begin");
    if (g_web_message_port_arr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "webMessagePort is nullptr");
        return nullptr;
    }
    std::thread thread(SetHandler, webTagValue);
    thread.detach();
    webMessagePort->setMessageEventHandler(g_web_message_port_arr[1], webTagValue, WebMessagePortCallback, NULL);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit SetMessageEventHandler end, web message port size:%{public}d", g_webMessagePortSize);
    return nullptr;
}
static napi_value postNoneMessage(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN,
        "ArkWeb", "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 发送消息
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit 发消息开始");

    if (g_web_message_port_arr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "webMessagePort is nullptr");
        return nullptr;
    }
    ArkWeb_WebMessagePtr message = webMessage->createWebMessage();
    webMessage->setType(message, ArkWeb_WebMessageType::ARKWEB_NONE);
    std::string str = "send string from native";
    webMessage->setData(message, (void *)str.c_str(), str.length() + 1);
    webMessagePort->postMessage(g_web_message_port_arr[1], webTagValue, message);
    webMessage->destroyWebMessage(&message);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit postMessage end, web message port size:%{public}d", g_webMessagePortSize);
    return nullptr;
}

static napi_value postBufferMessage(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 发送消息
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit postMessage begin");

    if (g_web_message_port_arr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "webMessagePort is nullptr");
        return nullptr;
    }
    ArkWeb_WebMessagePtr message1 = webMessage->createWebMessage();
    webMessage->setType(message1, ArkWeb_WebMessageType::ARKWEB_BUFFER);
    std::string str1 = "send buffer from native";
    webMessage->setData(message1, (void *)str1.c_str(), str1.length());
    webMessagePort->postMessage(g_web_message_port_arr[1], webTagValue, message1);
    webMessage->destroyWebMessage(&message1);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit postMessage end, web message port size:%{public}d", g_webMessagePortSize);
    return nullptr;
}

static napi_value setMessageEventHandler(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 注册回调
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit SetMessageEventHandler begin");
    if (g_web_message_port_arr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "webMessagePort is nullptr");
        return nullptr;
    }
    webMessagePort->setMessageEventHandler(g_web_message_port_arr[1], webTagValue, WebMessagePortCallback, NULL);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit SetMessageEventHandler end, web message port size:%{public}d", g_webMessagePortSize);
    return nullptr;
}

static napi_value closeMessagePort(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 关闭端口，先调用close，再调用destroyWebMessagePorts
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit SetMessageEventHandler begin");
    if (g_web_message_port_arr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "webMessagePort is nullptr");
        return nullptr;
    }
    webMessagePort->close(g_web_message_port_arr[0], webTagValue);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit SetMessageEventHandler end, web message port size:%{public}d", g_webMessagePortSize);
    controller->refresh(webTagValue);
    return nullptr;
}

static napi_value destroyMessagePort(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 释放内存，先调用close，再调用destroyWebMessagePorts
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit SetMessageEventHandler begin");
    if (g_web_message_port_arr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ArkWeb", "webMessagePort is nullptr");
        return nullptr;
    }
    controller->destroyWebMessagePorts(&g_web_message_port_arr, g_webMessagePortSize);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit SetMessageEventHandler end, web message port size:%{public}d", g_webMessagePortSize);
    return nullptr;
}

static napi_value destroyNullMessagePort(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取第一个参数webTag
    size_t webTagSize = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &webTagSize);
    char *webTagValue = new (std::nothrow) char[webTagSize + 1];
    size_t webTagLength = 0;
    napi_get_value_string_utf8(env, args[0], webTagValue, webTagSize + 1, &webTagLength);
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit Refresh webTag:%{public}s", webTagValue);

    // 释放内存，先调用close，再调用destroyWebMessagePorts
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "Native Development Kit SetMessageEventHandler begin");

    controller->destroyWebMessagePorts(&g_web_message_port_arr, g_webMessagePortSize);

    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "Native Development Kit SetMessageEventHandler end, web message port size:%{public}d", g_webMessagePortSize);
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"nativeWebInit", nullptr, NativeWebInit, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createWebMessagePorts", nullptr, createWebMessagePorts, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"postMessage", nullptr, postMessage, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"postNoneMessage", nullptr, postNoneMessage, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"postBufferMessage", nullptr, postBufferMessage, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setMessageEventHandler", nullptr, setMessageEventHandler, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"closeMessagePort", nullptr, closeMessagePort, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"destroyMessagePort", nullptr, destroyMessagePort, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"postMessageThread", nullptr, postMessageThread, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setMessageEventHandlerThread", nullptr, setMessageEventHandlerThread, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"destroyNullMessagePort", nullptr, destroyNullMessagePort, nullptr, nullptr, nullptr, napi_default, nullptr},
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
// [End the_node_api_layer_code_for_the_data_channel_between_the_application_side_and_the_frontend_page]