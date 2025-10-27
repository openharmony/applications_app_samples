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

// [Start EventSub_napi_Header]
#include "napi/native_api.h"
#include "json/json.h"
#include "hilog/log.h"
#include "hiappevent/hiappevent.h"
#include "hiappevent/hiappevent_event.h"

#undef LOG_TAG
#define LOG_TAG "testTag"
// [End EventSub_napi_Header]

// [Start Hicollie_Set_Timer_h]
#include <unistd.h>
#include "hicollie/hicollie.h"
// [End Hicollie_Set_Timer_h]

// 定义一变量，用来缓存创建的观察者的指针。
// [Start EventSub_onReceive_ptr]
static HiAppEvent_Watcher *eventWatcherR;
// [End EventSub_onReceive_ptr]
// [Start EventSub_onTrigger_ptr]
static HiAppEvent_Watcher *eventWatcherT;
// [End EventSub_onTrigger_ptr]

// [Start App_Hicollie_Watcher_R_ptr]
// 定义一变量，用来缓存创建的观察者的指针。
static HiAppEvent_Watcher *appHicollieWatcherR;
// [End App_Hicollie_Watcher_R_ptr]
// [Start App_Hicollie_Watcher_T_ptr]
// 定义一变量，用来缓存创建的观察者的指针。
static HiAppEvent_Watcher *appHicollieWatcherT;
// [End App_Hicollie_Watcher_T_ptr]

// [Start CrashEvent_OnReceive]
static void OnReceiveCrashEvent(const struct HiAppEvent_AppEventGroup *appEventGroups, int i, int j)
{
    if (strcmp(appEventGroups[i].appEventInfos[j].domain, DOMAIN_OS) == 0 &&
        strcmp(appEventGroups[i].appEventInfos[j].name, EVENT_APP_CRASH) == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        Json::FastWriter writer;
        if (reader.parse(appEventGroups[i].appEventInfos[j].params, params)) {
            auto time = params["time"].asInt64();
            auto crashType = params["crash_type"].asString();
            auto foreground = params["foreground"].asBool();
            auto bundleVersion = params["bundle_version"].asString();
            auto bundleName = params["bundle_name"].asString();
            auto pid = params["pid"].asInt();
            auto uid = params["uid"].asInt();
            auto uuid = params["uuid"].asString();
            auto exception = writer.write(params["exception"]);
            auto hilogSize = params["hilog"].size();
            auto externalLog = writer.write(params["external_log"]);
            auto logOverLimit = params["log_over_limit"].asBool();
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.crash_type=%{public}s",
                        crashType.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.foreground=%{public}d", foreground);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                        bundleVersion.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s",
                        bundleName.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uuid=%{public}s", uuid.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.exception=%{public}s",
                        exception.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.hilog.size=%{public}d", hilogSize);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                        externalLog.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}d",
                        logOverLimit);
        }
    }
}
// [End CrashEvent_OnReceive]
// [Start FreezeEvent_OnReceive_Output]
// OnReceiveFreezeEvent超出50行限制，将日志输出单独抽出
static void FreezeEventOutput(Json::Value params, Json::FastWriter writer)
{
    auto time = params["time"].asInt64();
    auto foreground = params["foreground"].asBool();
    auto bundleVersion = params["bundle_version"].asString();
    auto bundleName = params["bundle_name"].asString();
    auto processName = params["process_name"].asString();
    auto pid = params["pid"].asInt();
    auto uid = params["uid"].asInt();
    auto uuid = params["uuid"].asString();
    auto exception = writer.write(params["exception"]);
    auto hilogSize = params["hilog"].size();
    auto handleSize = params["event_handler"].size();
    auto handleSize3s = params["event_handler_size_3s"].asString();
    auto handleSize6s = params["event_handler_size_6s"].asString();
    auto peerBindSize = params["peer_binder"].size();
    auto threadSize = params["threads"].size();
    auto memory = writer.write(params["memory"]);
    auto externalLog = writer.write(params["external_log"]);
    auto logOverLimit = params["log_over_limit"].asBool();
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.foreground=%{public}d", foreground);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                bundleVersion.c_str());
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s",
                bundleName.c_str());
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.process_name=%{public}s",
                processName.c_str());
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uuid=%{public}s", uuid.c_str());
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.exception=%{public}s",
                exception.c_str());
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.hilog.size=%{public}d", hilogSize);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.event_handler.size=%{public}d",
                handleSize);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.event_handler_3s.size=%{public}s",
                handleSize3s.c_str());
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.event_handler_6s.size=%{public}s",
                handleSize6s.c_str());
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.peer_binder.size=%{public}d",
                peerBindSize);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.threads.size=%{public}d", threadSize);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.memory=%{public}s", memory.c_str());
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                externalLog.c_str());
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}d",
                logOverLimit);
}
// [End FreezeEvent_OnReceive_Output]
// [Start FreezeEvent_OnReceive]
static void OnReceiveFreezeEvent(const struct HiAppEvent_AppEventGroup *appEventGroups, int i, int j)
{
    if (strcmp(appEventGroups[i].appEventInfos[j].domain, DOMAIN_OS) == 0 &&
        strcmp(appEventGroups[i].appEventInfos[j].name, EVENT_APP_FREEZE) == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        Json::FastWriter writer;
        if (reader.parse(appEventGroups[i].appEventInfos[j].params, params)) {
            FreezeEventOutput(params, writer);
        }
    }
}
// [End FreezeEvent_OnReceive]
// [Start PssLeakEvent_OnReceive]
//定义一变量，用来缓存创建的观察者的指针。
static HiAppEvent_Watcher *resouceLeakWatcherR;

static void HandleLeakEventInfo(const struct HiAppEvent_AppEventInfo &appEventInfos)
{
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.domain=%{public}s", appEventInfos.domain);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.name=%{public}s", appEventInfos.name);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.eventType=%{public}d", appEventInfos.type);
    if (strcmp(appEventInfos.domain, DOMAIN_OS) == 0 &&
        strcmp(appEventInfos.name, EVENT_RESOURCE_OVERLIMIT) == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        Json::FastWriter writer;
        if (reader.parse(appEventInfos.params, params)) {
            auto time = params["time"].asInt64();
            auto pid = params["pid"].asInt();
            auto uid = params["uid"].asInt();
            auto resourceType = params["resourceType"].asString();
            auto bundleName = params["bundle_name"].asString();
            auto bundleVersion = params["bundle_version"].asString();
            auto memory = writer.write(params["memory"]);
            auto externalLog = writer.write(params["external_log"]);
            std::string logOverLimit = params["log_over_limit"].asBool() ? "true":"false";
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.resource_type=%{public}s",
                resourceType.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s",
                bundleName.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                bundleVersion.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.memory=%{public}s",
                memory.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                externalLog.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}s",
                logOverLimit.c_str());
        }
    }
}

static void OnReceiveLeakEvent(const char *domain, const struct HiAppEvent_AppEventGroup *appEventGroups,
    uint32_t groupLen)
{
    for (int i = 0; i < groupLen; ++i) {
        for (int j = 0; j < appEventGroups[i].infoLen; ++j) {
            HandleLeakEventInfo(appEventGroups[i].appEventInfos[j]);
        }
    }
}

static napi_value RegisterLeakReceiveWatcher(napi_env env, napi_callback_info info)
{
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    resouceLeakWatcherR = OH_HiAppEvent_CreateWatcher("onLeakReceiveWatcher");
    // 设置订阅的事件为EVENT_RESOURCE_OVERLIMIT。
    const char *names[] = {EVENT_RESOURCE_OVERLIMIT};
    // 开发者订阅感兴趣的事件，此处订阅了系统事件。
    OH_HiAppEvent_SetAppEventFilter(resouceLeakWatcherR, DOMAIN_OS, 0, names, 1);
    // 开发者设置已实现的回调函数，观察者接收到事件后回立即触发OnReceive回调。
    OH_HiAppEvent_SetWatcherOnReceive(resouceLeakWatcherR, OnReceiveLeakEvent);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(resouceLeakWatcherR);
    return {};
}
// [End PssLeakEvent_OnReceive]
// [Start AppKillEvent_OnReceive]
// 定义一变量，用来缓存创建的观察者的指针。
static HiAppEvent_Watcher *appKillWatcherR;

static void HandleAppKillEventInfo(const struct HiAppEvent_AppEventInfo &appEventInfos)
{
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.domain=%{public}s", appEventInfos.domain);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.name=%{public}s", appEventInfos.name);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.eventType=%{public}d", appEventInfos.type);
    if (strcmp(appEventInfos.domain, DOMAIN_OS) == 0 &&
        strcmp(appEventInfos.name, EVENT_APP_KILLED) == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        Json::FastWriter writer;
        if (reader.parse(appEventInfos.params, params)) {
            auto time = params["time"].asInt64();
            auto reason = params["reason"].asString();
            auto foreground = params["foreground"].asString();
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.reason=%{public}s", reason.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.foreground=%{public}s", foreground.c_str());
        }
    }
}

static void OnReceiveAppKillEvent(const char *domain, const struct HiAppEvent_AppEventGroup *appEventGroups,
    uint32_t groupLen)
{
    for (int i = 0; i < groupLen; ++i) {
        for (int j = 0; j < appEventGroups[i].infoLen; ++j) {
            HandleAppKillEventInfo(appEventGroups[i].appEventInfos[j]);
        }
    }
}

static napi_value RegisterAppKillReceiveWatcher(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent RegisterWatcher");
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    appKillWatcherR = OH_HiAppEvent_CreateWatcher("onAppKillReceiverWatcher");
    // 设置订阅的事件为EVENT_APP_KILLED。
    const char *names[] = {EVENT_APP_KILLED};
    // 开发者订阅感兴趣的事件，此处订阅了系统事件。
    OH_HiAppEvent_SetAppEventFilter(appKillWatcherR, DOMAIN_OS, 0, names, 1);
    // 开发者设置已实现的回调函数，观察者接收到事件后回立即触发OnReceive回调。
    OH_HiAppEvent_SetWatcherOnReceive(appKillWatcherR, OnReceiveAppKillEvent);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(appKillWatcherR);
    return {};
}
// [End AppKillEvent_OnReceive]
// [Start AsanEvent_OnReceive]
//定义一变量，用来缓存创建的观察者的指针。
static HiAppEvent_Watcher *sanitizerWatcherR;

static void HandleSanitizerEventInfo(const struct HiAppEvent_AppEventInfo &appEventInfos)
{
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.domain=%{public}s", appEventInfos.domain);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.name=%{public}s", appEventInfos.name);
    OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.eventType=%{public}d", appEventInfos.type);
    if (strcmp(appEventInfos.domain, DOMAIN_OS) == 0 &&
        strcmp(appEventInfos.name, EVENT_ADDRESS_SANITIZER) == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        Json::FastWriter writer;
        if (reader.parse(appEventInfos.params, params)) {
            auto time = params["time"].asInt64();
            auto bundleVersion = params["bundle_version"].asString();
            auto bundleName = params["bundle_name"].asString();
            auto pid = params["pid"].asInt();
            auto uid = params["uid"].asInt();
            auto type = params["type"].asString();
            std::string logOverLimit = params["log_over_limit"].asBool() ? "true" : "false";
            auto externalLog = writer.write(params["external_log"]);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                bundleVersion.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s",
                bundleName.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.type=%{public}s",
                type.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                externalLog.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}s",
                logOverLimit.c_str());
        }
    }
}

static void OnReceiveSanitizerEvent(const char *domain, const struct HiAppEvent_AppEventGroup *appEventGroups,
    uint32_t groupLen)
{
    for (int i = 0; i < groupLen; ++i) {
        for (int j = 0; j < appEventGroups[i].infoLen; ++j) {
            HandleSanitizerEventInfo(appEventGroups[i].appEventInfos[j]);
        }
    }
}

static napi_value RegisterSanitizerReceiveWatcher(napi_env env, napi_callback_info info)
{
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    sanitizerWatcherR = OH_HiAppEvent_CreateWatcher("onSanitizerReceiveWatcher");
    // 设置订阅的事件为EVENT_ADDRESS_SANITIZER。
    const char *names[] = {EVENT_ADDRESS_SANITIZER};
    // 开发者订阅感兴趣的事件，此处订阅了系统事件。
    OH_HiAppEvent_SetAppEventFilter(sanitizerWatcherR, DOMAIN_OS, 0, names, 1);
    // 开发者设置已实现的回调函数，观察者接收到事件后回立即触发OnReceive回调。
    OH_HiAppEvent_SetWatcherOnReceive(sanitizerWatcherR, OnReceiveSanitizerEvent);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(sanitizerWatcherR);
    return {};
}
// [End AsanEvent_OnReceive]
// [Start TimeOutEvent_OnReceive]
static void OnReceiveTimeOutEvent(const struct HiAppEvent_AppEventGroup *appEventGroups, int i, int j)
{
    if (strcmp(appEventGroups[i].appEventInfos[j].domain, DOMAIN_OS) == 0 &&
        strcmp(appEventGroups[i].appEventInfos[j].name, EVENT_MAIN_THREAD_JANK) == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        Json::FastWriter writer;
        if (reader.parse(appEventGroups[i].appEventInfos[j].params, params)) {
            auto time = params["time"].asInt64();
            auto pid = params["pid"].asInt();
            auto uid = params["uid"].asInt();
            auto bundleName = params["bundle_name"].asString();
            auto bundleVersion = params["bundle_version"].asString();
            auto beginTime = params["begin_time"].asInt64();
            auto endTime = params["end_time"].asInt64();
            auto externalLog = writer.write(params["external_log"]);
            auto logOverLimit = params["logOverLimit"].asBool();
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s",
                        bundleName.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                        bundleVersion.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.begin_time=%{public}lld", beginTime);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.end_time=%{public}lld", endTime);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                        externalLog.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}d",
                        logOverLimit);
        }
    }
}
// [End TimeOutEvent_OnReceive]
// [Start AppEvent_Crash_C++_Add_Watcher]
// 定义变量，用来缓存创建的观察者的指针。
static HiAppEvent_Watcher *eventWatcherR1;

static void OnReceive1(const char *domain, const struct HiAppEvent_AppEventGroup *appEventGroups, uint32_t groupLen)
{
    OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent success to read events with onReceive callback form C API \n");
    for (int i = 0; i < groupLen; ++i) {
        for (int j = 0; j < appEventGroups[i].infoLen; ++j) {
            OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.domain=%{public}s",
                appEventGroups[i].appEventInfos[j].domain);
            OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.name=%{public}s",
                appEventGroups[i].appEventInfos[j].name);
            OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.eventType=%{public}d",
                appEventGroups[i].appEventInfos[j].type);
            if (strcmp(appEventGroups[i].appEventInfos[j].domain, DOMAIN_OS) != 0 ||
                strcmp(appEventGroups[i].appEventInfos[j].name, EVENT_APP_CRASH) != 0) {
                continue;
            }
            Json::Value params;
            Json::Reader reader(Json::Features::strictMode());
            Json::FastWriter writer;
            if (reader.parse(appEventGroups[i].appEventInfos[j].params, params)) {
                // 开发者可以获取到崩溃事件发生的时间戳
                OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.params.time=%{public}lld",
                    params["time"].asInt64());
                // 开发者可以获取到崩溃应用的包名
                OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.params.bundle_name=%{public}s",
                    params["bundle_name"].asString().c_str());
                auto external_log = writer.write(params["external_log"]);
                // 开发者可以获取到崩溃事件发生时的故障日志文件
                OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.params.external_log=%{public}s",
                    external_log.c_str());
            }
        }
    }
}
static napi_value RegisterWatcherCrash(napi_env env, napi_callback_info info)
{
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    eventWatcherR1 = OH_HiAppEvent_CreateWatcher("AppCrashWatcher1");
    // 设置订阅的事件名称为EVENT_APP_CRASH，即崩溃事件。
    const char *names[] = {EVENT_APP_CRASH};
    // 开发者订阅感兴趣的事件，此处订阅了系统事件。
    OH_HiAppEvent_SetAppEventFilter(eventWatcherR1, DOMAIN_OS, 0, names, 1);
    // 开发者设置已实现的回调函数，观察者接收到事件后回立即触发OnReceive1回调。
    OH_HiAppEvent_SetWatcherOnReceive(eventWatcherR1, OnReceive1);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(eventWatcherR1);
    return {};
}
// [End AppEvent_Crash_C++_Add_Watcher]
// [Start AppEvent_Click_C++_Add_Watcher]
// 定义变量，用来缓存创建的观察者的指针。
static HiAppEvent_Watcher *eventWatcherT1;
// 开发者可以自行实现获取已监听到事件的回调函数，其中events指针指向内容仅在该函数内有效。
static void OnTake1(const char *const *events, uint32_t eventLen)
{
    Json::Reader reader(Json::Features::strictMode());
    OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent success to read events with onTrigger callback form C API \n");
    for (int i = 0; i < eventLen; ++i) {
        OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo=%{public}s", events[i]);
        Json::Value eventInfo;
        if (reader.parse(events[i], eventInfo)) {
            auto domain = eventInfo["domain_"].asString();
            auto name = eventInfo["name_"].asString();
            auto type = eventInfo["type_"].asInt();
            OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.domain=%{public}s", domain.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.name=%{public}s", name.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.eventType=%{public}d", type);
            if (domain == "button" && name == "click") {
                auto clickTime = eventInfo["clickTime"].asInt64();
                OH_LOG_INFO(LogType::LOG_APP, "AppEvents HiAppEvent eventInfo.params.clickTime=%{public}lld",
                    clickTime);
            }
        }
    }
}

// 开发者可以自行实现订阅回调函数，以便对获取到的事件打点数据进行自定义处理。
static void OnTrigger1(int row, int size)
{
    // 接收回调后，获取指定数量的已接收事件。
    OH_HiAppEvent_TakeWatcherData(eventWatcherT1, row, OnTake1);
}

static napi_value RegisterWatcherClick(napi_env env, napi_callback_info info)
{
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    eventWatcherT1 = OH_HiAppEvent_CreateWatcher("ButtonClickWatcher1");
    // 设置订阅的事件名称为click。
    const char *names[] = {"click"};
    // 开发者订阅感兴趣的应用事件，此处订阅了button相关事件。
    OH_HiAppEvent_SetAppEventFilter(eventWatcherT1, "button", 0, names, 1);
    // 开发者设置已实现的回调函数，需OH_HiAppEvent_SetTriggerCondition设置的条件满足方可触发。
    OH_HiAppEvent_SetWatcherOnTrigger(eventWatcherT1, OnTrigger1);
    // 开发者可以设置订阅触发回调的条件，此处是设置新增事件打点数量为1个时，触发onTrigger回调。
    OH_HiAppEvent_SetTriggerCondition(eventWatcherT1, 1, 0, 0);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(eventWatcherT1);
    return {};
}
// [End AppEvent_Click_C++_Add_Watcher]

// [Start EventSub_OnReceive_All]
static void OnReceive(const char *domain, const struct HiAppEvent_AppEventGroup *appEventGroups, uint32_t groupLen)
{
    for (int i = 0; i < groupLen; ++i) {
        for (int j = 0; j < appEventGroups[i].infoLen; ++j) {
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnReceive");
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.domain=%{public}s",
                        appEventGroups[i].appEventInfos[j].domain);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.name=%{public}s",
                        appEventGroups[i].appEventInfos[j].name);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.eventType=%{public}d",
                        appEventGroups[i].appEventInfos[j].type);

            // 处理崩溃事件
            OnReceiveCrashEvent(appEventGroups, i, j);
            // 处理卡死事件
            OnReceiveFreezeEvent(appEventGroups, i, j);
            // 处理主线程卡顿事件
            OnReceiveTimeOutEvent(appEventGroups, i, j);
        }
    }
}
// [End EventSub_OnReceive_All]

// [Start CrashEvent_OnTrigger]
static void OnTriggerCrashEvent(std::string domain, std::string name, Json::Value eventInfo, Json::FastWriter writer)
{
    if (domain == DOMAIN_OS && name == EVENT_APP_CRASH) {
        auto time = eventInfo["time"].asInt64();
        auto crashType = eventInfo["crash_type"].asString();
        auto foreground = eventInfo["foreground"].asBool();
        auto bundleVersion = eventInfo["bundle_version"].asString();
        auto bundleName = eventInfo["bundle_name"].asString();
        auto pid = eventInfo["pid"].asInt();
        auto uid = eventInfo["uid"].asInt();
        auto uuid = eventInfo["uuid"].asString();
        auto exception = writer.write(eventInfo["exception"]);
        auto hilogSize = eventInfo["hilog"].size();
        auto externalLog = writer.write(eventInfo["external_log"]);
        auto logOverLimit = eventInfo["log_over_limit"].asBool();
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.crash_type=%{public}s", crashType.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.foreground=%{public}d", foreground);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                    bundleVersion.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s", bundleName.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uuid=%{public}s", uuid.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.exception=%{public}s", exception.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.hilog.size=%{public}d", hilogSize);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                    externalLog.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}d", logOverLimit);
    }
}
// [End CrashEvent_OnTrigger]
// [Start FreezeEvent_OnTrigger]
static void OnTriggerFreezeEvent(std::string domain, std::string name, Json::Value eventInfo, Json::FastWriter writer)
{
    if (domain == DOMAIN_OS && name == EVENT_APP_FREEZE) {
        auto time = eventInfo["time"].asInt64();
        auto foreground = eventInfo["foreground"].asBool();
        auto bundleVersion = eventInfo["bundle_version"].asString();
        auto bundleName = eventInfo["bundle_name"].asString();
        auto processName = eventInfo["process_name"].asString();
        auto pid = eventInfo["pid"].asInt();
        auto uid = eventInfo["uid"].asInt();
        auto uuid = eventInfo["uuid"].asString();
        auto exception = writer.write(eventInfo["exception"]);
        auto hilogSize = eventInfo["hilog"].size();
        auto handleSize = eventInfo["event_handler"].size();
        auto handleSize3s = eventInfo["event_handler_size_3s"].asString();
        auto handleSize6s = eventInfo["event_handler_size_6s"].asString();
        auto peerBindSize = eventInfo["peer_binder"].size();
        auto threadSize = eventInfo["threads"].size();
        auto memory = writer.write(eventInfo["memory"]);
        auto externalLog = writer.write(eventInfo["external_log"]);
        auto logOverLimit = eventInfo["log_over_limit"].asBool();
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.foreground=%{public}d", foreground);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                    bundleVersion.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s", bundleName.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.process_name=%{public}s",
                    processName.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uuid=%{public}s", uuid.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.exception=%{public}s", exception.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.hilog.size=%{public}d", hilogSize);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.event_handler.size=%{public}d", handleSize);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.event_handler_3s.size=%{public}s",
                    handleSize3s.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.event_handler_6s.size=%{public}s",
                    handleSize6s.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.peer_binder.size=%{public}d", peerBindSize);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.threads.size=%{public}d", threadSize);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.memory=%{public}s", memory.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                    externalLog.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}d", logOverLimit);
    }
}
// [End FreezeEvent_OnTrigger]
// [Start PssLeakEvent_OnTrigger]
//定义一变量，用来缓存创建的观察者的指针。
static HiAppEvent_Watcher *resouceLeakWatcherT;

// 开发者可以自行实现获取已监听到事件的回调函数，其中events指针指向内容仅在该函数内有效。
static void OnTakeLeakEvent(const char *const *events, uint32_t eventLen)
{
    Json::Reader reader(Json::Features::strictMode());
    Json::FastWriter writer;
    for (int i = 0; i < eventLen; ++i) {
        Json::Value eventInfo;
        if (reader.parse(events[i], eventInfo)) {
            auto domain =  eventInfo["domain_"].asString();
            auto name = eventInfo["name_"].asString();
            auto type = eventInfo["type_"].asInt();
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.domain=%{public}s", domain.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.name=%{public}s", name.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.eventType=%{public}d", type);
            if (domain ==  DOMAIN_OS && name == EVENT_RESOURCE_OVERLIMIT) {
                auto time = eventInfo["time"].asInt64();
                auto pid = eventInfo["pid"].asInt();
                auto uid = eventInfo["uid"].asInt();
                auto resourceType = eventInfo["resourceType"].asString();
                auto bundleName = eventInfo["bundle_name"].asString();
                auto bundleVersion = eventInfo["bundle_version"].asString();
                auto memory = writer.write(eventInfo["memory"]);
                auto externalLog = writer.write(eventInfo["external_log"]);
                std::string logOverLimit = eventInfo["log_over_limit"].asBool() ? "true":"false";
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.resource_type=%{public}s",
                    resourceType.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s",
                    bundleName.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                    bundleVersion.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.memory=%{public}s",
                    memory.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                    externalLog.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}s",
                    logOverLimit.c_str());
            }
        }
    }
}

// 开发者可以自行实现订阅回调函数，以便对获取到的事件打点数据进行自定义处理。
static void OnTriggerLeakEvent(int row, int size)
{
    // 接收回调后，获取指定数量的已接收事件。
    OH_HiAppEvent_TakeWatcherData(resouceLeakWatcherT, row, OnTakeLeakEvent);
}

static napi_value RegisterLeakTriggerWatcher(napi_env env, napi_callback_info info)
{
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    resouceLeakWatcherT = OH_HiAppEvent_CreateWatcher("onLeakTriggerWatcher");
    // 设置订阅的事件为EVENT_RESOURCE_OVERLIMIT。
    const char *names[] = {EVENT_RESOURCE_OVERLIMIT};
    // 开发者订阅感兴趣的事件，此处订阅了系统事件。
    OH_HiAppEvent_SetAppEventFilter(resouceLeakWatcherT, DOMAIN_OS, 0, names, 1);
    // 开发者设置已实现的回调函数，需OH_HiAppEvent_SetTriggerCondition设置的条件满足方可触发。
    OH_HiAppEvent_SetWatcherOnTrigger(resouceLeakWatcherT, OnTriggerLeakEvent);
    // 开发者可以设置订阅触发回调的条件，此处是设置新增事件打点数量为2个时，触发onTrigger回调。
    OH_HiAppEvent_SetTriggerCondition(resouceLeakWatcherT, 1, 0, 0);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(resouceLeakWatcherT);
    return {};
}
// [End PssLeakEvent_OnTrigger]
// [Start AsanEvent_OnTrigger]
//定义一变量，用来缓存创建的观察者的指针。
static HiAppEvent_Watcher *sanitizerTriggerWatcher;

// 开发者可以自行实现获取已监听到事件的回调函数，其中events指针指向内容仅在该函数内有效。
static void OnTakeSanitizerEvent(const char *const *events, uint32_t eventLen)
{
    Json::Reader reader(Json::Features::strictMode());
    Json::FastWriter writer;
    for (int i = 0; i < eventLen; ++i) {
        Json::Value eventInfo;
        if (reader.parse(events[i], eventInfo)) {
            auto domain =  eventInfo["domain_"].asString();
            auto name = eventInfo["name_"].asString();
            auto type = eventInfo["type_"].asInt();
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.domain=%{public}s", domain.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.name=%{public}s", name.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.eventType=%{public}d", type);
            if (domain ==  DOMAIN_OS && name == EVENT_ADDRESS_SANITIZER) {
                auto time = eventInfo["time"].asInt64();
                auto bundleVersion = eventInfo["bundle_version"].asString();
                auto bundleName = eventInfo["bundle_name"].asString();
                auto pid = eventInfo["pid"].asInt();
                auto uid = eventInfo["uid"].asInt();
                auto asanType = eventInfo["type"].asString();
                auto externalLog = writer.write(eventInfo["external_log"]);
                std::string logOverLimit = eventInfo["log_over_limit"].asBool() ? "true" : "false";
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                    bundleVersion.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s",
                    bundleName.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.crash_type=%{public}s",
                    asanType.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                    externalLog.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}s",
                    logOverLimit.c_str());
            }
        }
    }
}

// 开发者可以自行实现订阅回调函数，以便对获取到的事件打点数据进行自定义处理。
static void OnTriggerSanitizerEvent(int row, int size)
{
    // 接收回调后，获取指定数量的已接收事件。
    OH_HiAppEvent_TakeWatcherData(sanitizerTriggerWatcher, row, OnTakeSanitizerEvent);
}

static napi_value RegisterSanitizerTriggerWatcher(napi_env env, napi_callback_info info)
{
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    sanitizerTriggerWatcher = OH_HiAppEvent_CreateWatcher("sanitizerTriggerWatcher");
    // 设置订阅的事件为EVENT_ADDRESS_SANITIZER。
    const char *names[] = {EVENT_ADDRESS_SANITIZER};
    // 开发者订阅感兴趣的事件，此处订阅了系统事件。
    OH_HiAppEvent_SetAppEventFilter(sanitizerTriggerWatcher, DOMAIN_OS, 0, names, 1);
    // 开发者设置已实现的回调函数，需OH_HiAppEvent_SetTriggerCondition设置的条件满足方可触发。
    OH_HiAppEvent_SetWatcherOnTrigger(sanitizerTriggerWatcher, OnTriggerSanitizerEvent);
    // 开发者可以设置订阅触发回调的条件，此处是设置新增事件打点数量为1个时，触发onTrigger回调。
    OH_HiAppEvent_SetTriggerCondition(sanitizerTriggerWatcher, 1, 0, 0);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(sanitizerTriggerWatcher);
    return {};
}
// [End AsanEvent_OnTrigger]
// [Start EventSub_OnTake_All]
// 开发者可以自行实现获取已监听到事件的回调函数，其中events指针指向内容仅在该函数内有效。
static void OnTake(const char *const *events, uint32_t eventLen)
{
    Json::Reader reader(Json::Features::strictMode());
    Json::FastWriter writer;
    for (int i = 0; i < eventLen; ++i) {
        Json::Value eventInfo;
        if (reader.parse(events[i], eventInfo)) {
            auto domain = eventInfo["domain_"].asString();
            auto name = eventInfo["name_"].asString();
            auto type = eventInfo["type_"].asInt();
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.WatcherType=OnTrigger");
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.domain=%{public}s", domain.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.name=%{public}s", name.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.eventType=%{public}d", type);

            // 处理崩溃事件
            OnTriggerCrashEvent(domain, name, eventInfo, writer);
            // 处理卡死事件
            OnTriggerFreezeEvent(domain, name, eventInfo, writer);
        }
    }
}
// [End EventSub_OnTake_All]
// [Start EventSub_OnTrigger]
// 开发者可以自行实现订阅回调函数，以便对获取到的事件打点数据进行自定义处理。
static void OnTrigger(int row, int size)
{
    // 接收回调后，获取指定数量的已接收事件。
    OH_HiAppEvent_TakeWatcherData(eventWatcherT, row, OnTake);
}
// [End EventSub_OnTrigger]
// [Start EventSub_RegisterWatcher_All]
static napi_value RegisterWatcher(napi_env env, napi_callback_info info)
{
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    eventWatcherT = OH_HiAppEvent_CreateWatcher("onTriggerWatcher");
    eventWatcherR = OH_HiAppEvent_CreateWatcher("onReceiverWatcher");
    // 设置订阅的事件名称为click, EVENT_APP_CRASH。
    const char *names[] = {"click", EVENT_APP_CRASH, EVENT_APP_FREEZE, EVENT_MAIN_THREAD_JANK};
    int namesSize = sizeof(names) / sizeof(names[0]);
    // 开发者订阅感兴趣的应用事件
    OH_HiAppEvent_SetAppEventFilter(eventWatcherT, "button", 0, names, namesSize);
    OH_HiAppEvent_SetAppEventFilter(eventWatcherT, DOMAIN_OS, 0, names, namesSize);
    // 开发者设置已实现的回调函数，需OH_HiAppEvent_SetTriggerCondition设置的条件满足方可触发。
    OH_HiAppEvent_SetWatcherOnTrigger(eventWatcherT, OnTrigger);
    // 开发者可以设置订阅触发回调的条件，此处是设置新增事件打点数量为1个时，触发onTrigger回调。
    OH_HiAppEvent_SetTriggerCondition(eventWatcherT, 1, 0, 0);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(eventWatcherT);
    // 开发者订阅感兴趣的应用事件
    OH_HiAppEvent_SetAppEventFilter(eventWatcherR, "button", 0, names, namesSize);
    OH_HiAppEvent_SetAppEventFilter(eventWatcherR, DOMAIN_OS, 0, names, namesSize);
    // 开发者设置已实现的回调函数，观察者接收到事件后回立即触发OnReceive回调。
    OH_HiAppEvent_SetWatcherOnReceive(eventWatcherR, OnReceive);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(eventWatcherR);
    return {};
}
// [End EventSub_RegisterWatcher_All]

// [Start EventSub_RemoveWatcher_All]
// [Start AppEvent_C++_RemoveWatcher]
// [Start APP_Hicollie_RemoveWatcher]
// [Start AsanEvent_RemoveWatcher]
// [Start PssLeakEvent_RemoveWatcher]
// [Start AppKillEvent_RemoveWatcher]
static napi_value RemoveWatcher(napi_env env, napi_callback_info info)
{
    // 使观察者停止监听事件
    // [StartExclude AppKillEvent_RemoveWatcher]
    // [StartExclude PssLeakEvent_RemoveWatcher]
    // [StartExclude AsanEvent_RemoveWatcher]
    // [StartExclude APP_Hicollie_RemoveWatcher]
    // [StartExclude AppEvent_C++_RemoveWatcher]
    OH_HiAppEvent_RemoveWatcher(eventWatcherT);
    OH_HiAppEvent_RemoveWatcher(eventWatcherR);
    // [EndExclude AppEvent_C++_RemoveWatcher]
    OH_HiAppEvent_RemoveWatcher(eventWatcherT1);
    OH_HiAppEvent_RemoveWatcher(eventWatcherR1);
    // [EndExclude APP_Hicollie_RemoveWatcher]
    // [StartExclude AppEvent_C++_RemoveWatcher]
    OH_HiAppEvent_RemoveWatcher(appHicollieWatcherR);
    OH_HiAppEvent_RemoveWatcher(appHicollieWatcherT);
    // [EndExclude AsanEvent_RemoveWatcher]
    // [StartExclude APP_Hicollie_RemoveWatcher]
    OH_HiAppEvent_RemoveWatcher(sanitizerWatcherR);
    // [StartExclude AsanEvent_RemoveWatcher]
    // [EndExclude PssLeakEvent_RemoveWatcher]
    OH_HiAppEvent_RemoveWatcher(resouceLeakWatcherR);
    // [EndExclude AppKillEvent_RemoveWatcher]
    // [StartExclude PssLeakEvent_RemoveWatcher]
    OH_HiAppEvent_RemoveWatcher(appKillWatcherR);
    // [EndExclude AppEvent_C++_RemoveWatcher]
    // [EndExclude AsanEvent_RemoveWatcher]
    // [EndExclude PssLeakEvent_RemoveWatcher]
    // [EndExclude APP_Hicollie_RemoveWatcher]
    return {};
}
// [End AppKillEvent_RemoveWatcher]
// [End PssLeakEvent_RemoveWatcher]
// [End AsanEvent_RemoveWatcher]
// [End APP_Hicollie_RemoveWatcher]
// [End AppEvent_C++_RemoveWatcher]
// [End EventSub_RemoveWatcher_All]

// [Start EventSub_DestroyWatcher_All]
// [Start AppEvent_C++_DestroyWatcher]
// [Start APP_Hicollie_DestroyWatcher]
// [Start AsanEvent_DestroyWatcher]
// [Start PssLeakEvent_DestroyWatcher]
// [Start AppKillEvent_DestroyWatcher]
static napi_value DestroyWatcher(napi_env env, napi_callback_info info)
{
    // 销毁创建的观察者，并置eventWatcher为nullptr。
    // [StartExclude AppKillEvent_DestroyWatcher]
    // [StartExclude PssLeakEvent_DestroyWatcher]
    // [StartExclude AsanEvent_DestroyWatcher]
    // [StartExclude APP_Hicollie_DestroyWatcher]
    // [StartExclude AppEvent_C++_DestroyWatcher]
    OH_HiAppEvent_DestroyWatcher(eventWatcherT);
    OH_HiAppEvent_DestroyWatcher(eventWatcherR);
    eventWatcherT = nullptr;
    eventWatcherR = nullptr;
    // [EndExclude AppEvent_C++_DestroyWatcher]
    OH_HiAppEvent_DestroyWatcher(eventWatcherT1);
    OH_HiAppEvent_DestroyWatcher(eventWatcherR1);
    eventWatcherT1 = nullptr;
    eventWatcherR1 = nullptr;
    // [EndExclude APP_Hicollie_DestroyWatcher]
    // [StartExclude AppEvent_C++_DestroyWatcher]
    OH_HiAppEvent_DestroyWatcher(appHicollieWatcherR);
    OH_HiAppEvent_DestroyWatcher(appHicollieWatcherT);
    appHicollieWatcherR = nullptr;
    appHicollieWatcherT = nullptr;
    // [EndExclude AsanEvent_DestroyWatcher]
    // [StartExclude APP_Hicollie_DestroyWatcher]
    OH_HiAppEvent_DestroyWatcher(sanitizerWatcherR);
    sanitizerWatcherR = nullptr;
    // [EndExclude PssLeakEvent_DestroyWatcher]
    // [StartExclude AsanEvent_DestroyWatcher]
    OH_HiAppEvent_DestroyWatcher(resouceLeakWatcherR);
    resouceLeakWatcherR = nullptr;
    // [EndExclude AppKillEvent_DestroyWatcher]
    // [StartExclude PssLeakEvent_DestroyWatcher]
    OH_HiAppEvent_DestroyWatcher(appKillWatcherR);
    appKillWatcherR = nullptr;
    // [EndExclude APP_Hicollie_DestroyWatcher]
    // [EndExclude AppEvent_C++_DestroyWatcher]
    // [EndExclude AsanEvent_DestroyWatcher]
    // [EndExclude PssLeakEvent_DestroyWatcher]
    return {};
}
// [End AppKillEvent_DestroyWatcher]
// [End PssLeakEvent_DestroyWatcher]
// [End AsanEvent_DestroyWatcher]
// [End APP_Hicollie_DestroyWatcher]
// [End AppEvent_C++_DestroyWatcher]
// [End EventSub_DestroyWatcher_All]

// [Start AppEvent_Click_C++_WriteAppEvent]
static napi_value WriteAppEvent(napi_env env, napi_callback_info info)
{
    auto params = OH_HiAppEvent_CreateParamList();
    OH_HiAppEvent_AddInt64Param(params, "clickTime", time(nullptr));
    OH_HiAppEvent_Write("button", "click", EventType::BEHAVIOR, params);
    OH_HiAppEvent_DestroyParamList(params);
    OH_LOG_INFO(LogType::LOG_APP, "writeEvent C++ success");
    return {};
}
// [End AppEvent_Click_C++_WriteAppEvent]
// [Start AsanEvent_AddressTest]
static napi_value AddressSanitizerTest(napi_env env, napi_callback_info info)
{
    constexpr int bufferSize = 42;
    int subscript = 43;
    char buffer[bufferSize];
    buffer[subscript] = subscript;
    printf("address: %p", buffer);
    return {};
}
// [End AsanEvent_AddressTest]
// [Start AppKillEvent_NativeLeak]
#include <thread>

static void NativeLeak()
{
    constexpr int leakSizePerTime = 500000;
    constexpr int sleepTimeMs = 10;
    while (true) {
        char *p = (char *)malloc(leakSizePerTime + 1);
        if (!p) {
            break;
        }
        memset(p, 'a', leakSizePerTime);
        std::this_thread::sleep_for(std::chrono::milliseconds(sleepTimeMs));
    }
}

static napi_value Leak(napi_env env, napi_callback_info info)
{
    std::thread t1(NativeLeak);
    t1.detach();
    return {};
}
// [End AppKillEvent_NativeLeak]
// [Start EventSub_Init_All]
// [Start AppEvent_C++_Init]

// [StartExclude AppEvent_C++_Init]
// [Start Hicollie_Set_Timer]
//定义回调函数
void CallBack(void*)
{
    OH_LOG_INFO(LogType::LOG_APP, "HiCollieTimerNdk CallBack");  // 回调函数中打印日志
}

static napi_value TestHiCollieTimerNdk(napi_env env, napi_callback_info info)
{
    int id;
    // 设置HiCollieTimer 参数（Timer任务名，超时时间，回调函数，回调函数参数，超时发生后行为）
    HiCollie_SetTimerParam param = {"testTimer", 1, CallBack, nullptr, HiCollie_Flag::HICOLLIE_FLAG_LOG};
    HiCollie_ErrorCode errorCode = OH_HiCollie_SetTimer(param, &id);  // 注册HiCollieTimer函数执行时长超时检测一次性任务
    if (errorCode == HICOLLIE_SUCCESS) {  // HiCollieTimer任务注册成功
        OH_LOG_INFO(LogType::LOG_APP, "HiCollieTimer taskId: %{public}d", id); // 打印任务id
        sleep(2);  // 模拟执行耗时函数，在这里简单的将线程阻塞2s
        OH_HiCollie_CancelTimer(id);  // 根据id取消已注册任务
    }
    return nullptr;
}
// [End Hicollie_Set_Timer]

// [Start App_Hicollie_OnReceive]
static void OnReceiveAppHicollie(const struct HiAppEvent_AppEventGroup *appEventGroups, int i, int j)
{
    if (strcmp(appEventGroups[i].appEventInfos[j].domain, DOMAIN_OS) == 0 &&
        strcmp(appEventGroups[i].appEventInfos[j].name, EVENT_APP_HICOLLIE) == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        Json::FastWriter writer;
        if (reader.parse(appEventGroups[i].appEventInfos[j].params, params)) {
            auto time = params["time"].asInt64();
            auto foreground = params["foreground"].asBool();
            auto bundleVersion = params["bundle_version"].asString();
            auto processName = params["process_name"].asString();
            auto pid = params["pid"].asInt();
            auto uid = params["uid"].asInt();
            auto uuid = params["uuid"].asString();
            auto exception = writer.write(params["exception"]);
            auto hilogSize = params["hilog"].size();
            auto peerBindSize =  params["peer_binder"].size();
            auto memory =  writer.write(params["memory"]);
            auto externalLog = writer.write(params["external_log"]);
            auto logOverLimit = params["log_over_limit"].asBool();
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.foreground=%{public}d", foreground);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                bundleVersion.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.process_name=%{public}s", processName.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uuid=%{public}s", uuid.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.exception=%{public}s", exception.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.hilog.size=%{public}d", hilogSize);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.peer_binder.size=%{public}d", peerBindSize);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.memory=%{public}s", memory.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s", externalLog.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}d", logOverLimit);
        }
    }
}

static void AppHicollieOnReceive(const char *domain, const struct HiAppEvent_AppEventGroup *appEventGroups,
    uint32_t groupLen)
{
    for (int i = 0; i < groupLen; ++i) {
        for (int j = 0; j < appEventGroups[i].infoLen; ++j) {
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.domain=%{public}s",
                appEventGroups[i].appEventInfos[j].domain);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.name=%{public}s",
                appEventGroups[i].appEventInfos[j].name);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.eventType=%{public}d",
                appEventGroups[i].appEventInfos[j].type);
            OnReceiveAppHicollie(appEventGroups, i, j);
        }
    }
}

static napi_value RegisterAppHicollieWatcherR(napi_env env, napi_callback_info info)
{
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    appHicollieWatcherR = OH_HiAppEvent_CreateWatcher("appHicollieWatcherR");
    // 设置订阅的事件为EVENT_APP_HICOLLIE。
    const char *names[] = {EVENT_APP_HICOLLIE};
    // 开发者订阅感兴趣的事件，此处订阅了系统事件。
    OH_HiAppEvent_SetAppEventFilter(appHicollieWatcherR, DOMAIN_OS, 0, names, 1);
    // 开发者设置已实现的回调函数，观察者接收到事件后回立即触发OnReceive回调。
    OH_HiAppEvent_SetWatcherOnReceive(appHicollieWatcherR, AppHicollieOnReceive);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(appHicollieWatcherR);
    return {};
}
// [End App_Hicollie_OnReceive]

// [Start App_Hicollie_Trigger]
// 开发者可以自行实现获取已监听到事件的回调函数，其中events指针指向内容仅在该函数内有效。
static void AppHicollieOnTake(const char *const *events, uint32_t eventLen)
{
    Json::Reader reader(Json::Features::strictMode());
    Json::FastWriter writer;
    for (int i = 0; i < eventLen; ++i) {
        Json::Value eventInfo;
        if (reader.parse(events[i], eventInfo)) {
            auto domain =  eventInfo["domain_"].asString();
            auto name = eventInfo["name_"].asString();
            auto type = eventInfo["type_"].asInt();
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.domain=%{public}s", domain.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.name=%{public}s", name.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.eventType=%{public}d", type);
            if (domain ==  DOMAIN_OS && name == EVENT_APP_HICOLLIE) {
                auto time = eventInfo["time"].asInt64();
                auto foreground = eventInfo["foreground"].asBool();
                auto bundleVersion = eventInfo["bundle_version"].asString();
                auto processName = eventInfo["process_name"].asString();
                auto pid = eventInfo["pid"].asInt();
                auto uid = eventInfo["uid"].asInt();
                auto uuid = eventInfo["uuid"].asString();
                auto exception = writer.write(eventInfo["exception"]);
                auto hilogSize = eventInfo["hilog"].size();
                auto peerBindSize =  eventInfo["peer_binder"].size();
                auto memory =  writer.write(eventInfo["memory"]);
                auto externalLog = writer.write(eventInfo["external_log"]);
                auto logOverLimit = eventInfo["log_over_limit"].asBool();
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.foreground=%{public}d", foreground);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                    bundleVersion.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.process_name=%{public}s",
                    processName.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uuid=%{public}s", uuid.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.exception=%{public}s", exception.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.hilog.size=%{public}d", hilogSize);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.peer_binder.size=%{public}d", peerBindSize);
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.memory=%{public}s", memory.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                    externalLog.c_str());
                OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}d", logOverLimit);
            }
        }
    }
}

// 开发者可以自行实现订阅回调函数，以便对获取到的事件打点数据进行自定义处理。
static void AppHicollieOnTrigger(int row, int size)
{
    // 接收回调后，获取指定数量的已接收事件。
    OH_HiAppEvent_TakeWatcherData(appHicollieWatcherT, row, AppHicollieOnTake);
}

static napi_value RegisterAppHicollieWatcherT(napi_env env, napi_callback_info info)
{
    // 开发者自定义观察者名称，系统根据不同的名称来识别不同的观察者。
    appHicollieWatcherT = OH_HiAppEvent_CreateWatcher("appHicollieWatcherT");
    // 设置订阅的事件为EVENT_APP_HICOLLIE。
    const char *names[] = {EVENT_APP_HICOLLIE};
    // 开发者订阅感兴趣的事件，此处订阅了系统事件。
    OH_HiAppEvent_SetAppEventFilter(appHicollieWatcherT, DOMAIN_OS, 0, names, 1);
    // 开发者设置已实现的回调函数，需OH_HiAppEvent_SetTriggerCondition设置的条件满足方可触发。
    OH_HiAppEvent_SetWatcherOnTrigger(appHicollieWatcherT, AppHicollieOnTrigger);
    // 开发者可以设置订阅触发回调的条件，此处是设置新增事件打点数量为1个时，触发onTrigger回调。
    OH_HiAppEvent_SetTriggerCondition(appHicollieWatcherT, 1, 0, 0);
    // 使观察者开始监听订阅的事件。
    OH_HiAppEvent_AddWatcher(appHicollieWatcherT);
    return {};
}
// [End App_Hicollie_Trigger]
// [EndExclude AppEvent_C++_Init]

// [Start AsanEvent_Init]
// [Start AsanEventTS_Init]
// [Start PssLeakEvent_Init]
// [Start AppKillEvent_Init]
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        // [StartExclude AppKillEvent_Init]
        // [StartExclude PssLeakEvent_Init]
        // [StartExclude AsanEvent_Init]
        // [StartExclude AsanEventTS_Init]
        // [StartExclude AppEvent_C++_Init]
        {"registerWatcher", nullptr, RegisterWatcher, nullptr, nullptr, nullptr, napi_default, nullptr},
        // [EndExclude AppEvent_C++_Init]
        { "registerWatcherCrash", nullptr, RegisterWatcherCrash, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "registerWatcherClick", nullptr, RegisterWatcherClick, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "writeAppEvent", nullptr, WriteAppEvent, nullptr, nullptr, nullptr, napi_default, nullptr },
        // [StartExclude AppEvent_C++_Init]
        // [Start test_hicollie_timer]
        // 将TestHiCollieTimerNdk注册为ArkTS接口
        { "TestHiCollieTimerNdk", nullptr, TestHiCollieTimerNdk, nullptr, nullptr, nullptr, napi_default, nullptr },
        // [End test_hicollie_timer]
        // [Start register_app_hicollie_watcherR]
        { "RegisterAppHicollieWatcherR", nullptr, RegisterAppHicollieWatcherR, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        // [End register_app_hicollie_watcherR]
        // [Start register_app_hicollie_watcherT]
        { "RegisterAppHicollieWatcherT", nullptr, RegisterAppHicollieWatcherT, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        // [End register_app_hicollie_watcherT]
        // [EndExclude AsanEvent_Init]
        { "registerSanitizerReceiveWatcher", nullptr, RegisterSanitizerReceiveWatcher, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        // [EndExclude AsanEventTS_Init]
        { "addressSanitizerTest", nullptr, AddressSanitizerTest, nullptr, nullptr, nullptr, napi_default, nullptr},
        // [EndExclude PssLeakEvent_Init]
        // [StartExclude AsanEventTS_Init]
        // [StartExclude AsanEvent_Init]
        { "registerLeakReceiveWatcher", nullptr, RegisterLeakReceiveWatcher, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        // [StartExclude PssLeakEvent_Init]
        // [EndExclude AppKillEvent_Init]
        { "registerAppKillReceiveWatcher", nullptr, RegisterAppKillReceiveWatcher, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        { "leak", nullptr, Leak, nullptr, nullptr, nullptr, napi_default, nullptr}
        // [EndExclude AsanEvent_Init]
        // [EndExclude AsanEventTS_Init]
        // [EndExclude PssLeakEvent_Init]
        // [EndExclude AppEvent_C++_Init]
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
// [End AppKillEvent_Init]
// [End PssLeakEvent_Init]
// [End AsanEventTS_Init]
// [End AsanEvent_Init]
// [End AppEvent_C++_Init]
// [End EventSub_Init_All]
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
