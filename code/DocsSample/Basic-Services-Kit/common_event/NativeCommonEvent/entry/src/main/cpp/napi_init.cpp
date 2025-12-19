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

#include "common_event_publish.h"
#include "common_event_subscribe.h"
#include "common_event_unsubscribe.h"
#include "napi/native_api.h"
#include <BasicServicesKit/oh_commonevent.h>
#include <vector>
#include <string>

constexpr const char *TEST_EVENT = "usual.event.TEST";
constexpr const char *TEST_EVENT_WITH_INFO = "usual.event.TEST_WITH_INFO";
constexpr const char *SCREEN_ON_EVENT = "usual.event.SCREEN_ON";
constexpr int32_t EVENT_COUNT = 2;
constexpr const char *TEST_PERMISSION = "permission.TEST";
constexpr const char *BUNDLE_NAME = "com.samples.commoneventpublish";
constexpr int32_t NAPI_MODULE_FLAGS = 0;

constexpr const char *TEST = "TEST";

CommonEvent_SubscribeInfo *g_subscribeInfo = nullptr;
CommonEvent_Subscriber *g_subscriber = nullptr;
bool g_isSubscribed = false;
std::vector<std::string> g_publishedEvents;

napi_value NAPI_CreateSubscribeInfo(napi_env env, napi_callback_info info)
{
    napi_value result;
    // 创建订阅者信息
    const char *events[] = {"usual.event.TEST", "usual.event.SCREEN_ON"};
    int32_t eventsNum = 2;
    const char *permission = "permission.TEST";
    const char *bundleName = "com.samples.commoneventpublish";

    g_subscribeInfo = ::CreateSubscribeInfo(events, eventsNum, permission, bundleName);

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: CreateSubscribeInfo success");
    return result;
}

napi_value NAPI_DestroySubscribeInfo(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    if (g_subscribeInfo != nullptr) {
        ::DestroySubscribeInfo(g_subscribeInfo);
        g_subscribeInfo = nullptr;
    }

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: DestroySubscribeInfo success");
    return result;
}

napi_value NAPI_CreateSubscriber(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    if (g_subscribeInfo != nullptr) {
        g_subscriber = ::CreateSubscriber(g_subscribeInfo);
    }

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: CreateSubscriber success");
    return result;
}

napi_value NAPI_DestroySubscriber(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    if (g_subscriber != nullptr) {
        ::DestroySubscriber(g_subscriber);
        g_subscriber = nullptr;
    }

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: DestroySubscriber success");
    return result;
}

napi_value NAPI_GetSubscribeInfoState(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_boolean(env, (g_subscribeInfo != nullptr), &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: GetSubscribeInfoState success");
    return result;
}

napi_value NAPI_GetSubscriberState(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_boolean(env, (g_subscriber != nullptr), &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: GetSubscriberState success");
    return result;
}

napi_value NAPI_GetSubscribeState(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_boolean(env, g_isSubscribed, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: GetSubscribeState success");
    return result;
}

napi_value NAPI_GetPublishedEvents(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_create_array(env, &result);

    uint32_t index = 0;
    for (const auto &event : g_publishedEvents) {
        napi_value eventString;
        napi_create_string_utf8(env, event.c_str(), NAPI_AUTO_LENGTH, &eventString);
        napi_set_element(env, result, index, eventString);
        index++;
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: GetPublishedEvents success");
    return result;
}

napi_value NAPI_Subscribe(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    if (g_subscriber != nullptr) {
        ::Subscribe(g_subscriber);
        g_isSubscribed = true;
    }

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: Subscribe success");
    return result;
}

napi_value NAPI_Unsubscribe(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    if (g_subscriber != nullptr) {
        ::Unsubscribe(g_subscriber);
        g_isSubscribed = false;
    }

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: Unsubscribe success");
    return result;
}

napi_value NAPI_Publish(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    ::Publish(TEST_EVENT);
    g_publishedEvents.push_back(TEST_EVENT);

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: Publish success");
    return result;
}

napi_value NAPI_PublishWithInfo(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    CommonEvent_PublishInfo *publishInfo = OH_CommonEvent_CreatePublishInfo(true);
    if (publishInfo == nullptr) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    CommonEvent_Parameters *param = ::CreateParameters();
    if (param == nullptr) {
        OH_CommonEvent_DestroyPublishInfo(publishInfo);
        napi_get_boolean(env, false, &result);
        return result;
    }
    ::PublishWithInfo(TEST_EVENT_WITH_INFO, publishInfo);
    OH_CommonEvent_DestroyPublishInfo(publishInfo);
    g_publishedEvents.push_back(TEST_EVENT_WITH_INFO);
    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: PublishWithInfo success");

    return result;
}

napi_value NAPI_AbortCommonEvent(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    if (g_subscriber != nullptr) {
        ::AbortCommonEvent(g_subscriber);
    }

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: AbortCommonEvent success");
    return result;
}

napi_value NAPI_ClearAbortCommonEvent(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    if (g_subscriber != nullptr) {
        ::ClearAbortCommonEvent(g_subscriber);
    }

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: ClearAbortCommonEvent success");
    return result;
}

napi_value NAPI_ClearAllStates(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_status status;

    size_t argc = 0;
    napi_value argv[0];
    status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    if (status != napi_ok) {
        napi_get_boolean(env, false, &result);
        return result;
    }

    if (g_subscribeInfo != nullptr) {
        ::DestroySubscribeInfo(g_subscribeInfo);
        g_subscribeInfo = nullptr;
    }

    if (g_subscriber != nullptr) {
        ::DestroySubscriber(g_subscriber);
        g_subscriber = nullptr;
    }

    g_isSubscribed = false;

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: ClearAllStates success");
    return result;
}

napi_value NAPI_SetPublishInfo(napi_env env, napi_callback_info info)
{
    napi_value result;

    const char *bundleName = "com.samples.commoneventpublish";
    const char *permissions[] = {};
    int32_t num = 0;
    const int32_t code = 0;
    const char *data = nullptr;

    ::SetPublishInfo(bundleName, permissions, num, code, data);

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: SetPublishInfo success");

    return result;
}

napi_value NAPI_DestroyPublishInfo(napi_env env, napi_callback_info info)
{
    napi_value result;
    int32_t ret = -1;

    // 创建publishInfo，设置是否为有序公共事件，取值为true，表示有序公共事件；取值为false，表示无序公共事件
    CommonEvent_PublishInfo *publishInfo = OH_CommonEvent_CreatePublishInfo(true);
    // 设置公共事件附加信息
    CommonEvent_Parameters *param = CreateParameters();
    ret = OH_CommonEvent_SetPublishInfoParameters(publishInfo, param);

    ::DestroyPublishInfo(param, publishInfo);

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: DestroyPublishInfo success");

    return result;
}

napi_value NAPI_GetParameters(napi_env env, napi_callback_info info)
{
    napi_value result;

    const CommonEvent_RcvData *data;
    ::GetParameters(data);
    const CommonEvent_Parameters *parameters = OH_CommonEvent_GetParametersFromRcvData(data);
    ::GetCommonEventBoolParam(parameters);
    ::GetCommonEventLongParam(parameters);
    ::GetCommonEventDoubleParam(parameters);
    ::GetCommonEventCharParam(parameters);
    ::GetCommonEventIntArrayParam(parameters);
    ::GetCommonEventLongArrayParam(parameters);
    ::GetCommonEventDoubleArrayParam(parameters);
    ::GetCommonEventCharArrayParam(parameters);
    ::GetCommonEventBoolArrayParam(parameters);

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: GetParameters success");

    return result;
}

napi_value NAPI_SetToSubscriber(napi_env env, napi_callback_info info)
{
    napi_value result;

    const char *events[] = {"usual.event.TEST", "usual.event.SCREEN_ON"};
    int32_t eventsNum = 2;
    const int32_t code = 0;
    const char *data = nullptr;
    // 创建publishInfo，设置是否为有序公共事件，取值为true，表示有序公共事件；取值为false，表示无序公共事件
    CommonEvent_SubscribeInfo *publishInfo = OH_CommonEvent_CreateSubscribeInfo(events, eventsNum);
    CommonEvent_Subscriber *subscriber = ::CreateSubscriber(publishInfo);

    ::SetToSubscriber(subscriber, code, data);

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: SetToSubscriber success");

    return result;
}

napi_value NAPI_GetFromSubscriber(napi_env env, napi_callback_info info)
{
    napi_value result;

    const char *events[] = {"usual.event.TEST", "usual.event.SCREEN_ON"};
    int32_t eventsNum = 2;
    // 创建publishInfo，设置是否为有序公共事件，取值为true，表示有序公共事件；取值为false，表示无序公共事件
    CommonEvent_SubscribeInfo *publishInfo = OH_CommonEvent_CreateSubscribeInfo(events, eventsNum);
    CommonEvent_Subscriber *subscriber = ::CreateSubscriber(publishInfo);

    ::GetFromSubscriber(subscriber);

    napi_get_boolean(env, true, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, TEST, "NAPI: SetToSubscriber success");

    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"createSubscribeInfo", nullptr, NAPI_CreateSubscribeInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"destroySubscribeInfo", nullptr, NAPI_DestroySubscribeInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createSubscriber", nullptr, NAPI_CreateSubscriber, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"destroySubscriber", nullptr, NAPI_DestroySubscriber, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"subscribe", nullptr, NAPI_Subscribe, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"unsubscribe", nullptr, NAPI_Unsubscribe, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"publish", nullptr, NAPI_Publish, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"publishWithInfo", nullptr, NAPI_PublishWithInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"abortCommonEvent", nullptr, NAPI_AbortCommonEvent, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"clearAbortCommonEvent", nullptr, NAPI_ClearAbortCommonEvent, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"getSubscribeInfoState", nullptr, NAPI_GetSubscribeInfoState, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"getSubscriberState", nullptr, NAPI_GetSubscriberState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSubscribeState", nullptr, NAPI_GetSubscribeState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getPublishedEvents", nullptr, NAPI_GetPublishedEvents, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"clearAllStates", nullptr, NAPI_ClearAllStates, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPublishInfo", nullptr, NAPI_SetPublishInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"destroyPublishInfo", nullptr, NAPI_DestroyPublishInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getParameters", nullptr, NAPI_GetParameters, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setToSubscriber", nullptr, NAPI_SetToSubscriber, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getFromSubscriber", nullptr, NAPI_GetFromSubscriber, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = NAPI_MODULE_VERSION,
    .nm_flags = NAPI_MODULE_FLAGS,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }