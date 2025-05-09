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

// 定义一变量，用来缓存创建的观察者的指针。
// [Start EventSub_onReceive_ptr]
static HiAppEvent_Watcher *eventWatcherR;
// [End EventSub_onReceive_ptr]
// [Start EventSub_onTrigger_ptr]
static HiAppEvent_Watcher *eventWatcherT;
// [End EventSub_onTrigger_ptr]
// [Start AppEvent_OnReceive]
static void OnReceiveDottingEvent(const struct HiAppEvent_AppEventGroup *appEventGroups, int i, int j)
{
    if (strcmp(appEventGroups[i].appEventInfos[j].domain, "button") == 0 &&
        strcmp(appEventGroups[i].appEventInfos[j].name, "click") == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        if (reader.parse(appEventGroups[i].appEventInfos[j].params, params)) {
            auto time = params["click_time"].asInt64();
            OH_LOG_INFO(LogType::LOG_APP, "readEvent C++ Success");
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.click_time=%{public}lld", time);
        }
    }
}
// [End AppEvent_OnReceive]
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
static void OnReceivePssLeakEvent(const struct HiAppEvent_AppEventGroup *appEventGroups, int i, int j)
{
    if (strcmp(appEventGroups[i].appEventInfos[j].domain, DOMAIN_OS) == 0 &&
        strcmp(appEventGroups[i].appEventInfos[j].name, EVENT_RESOURCE_OVERLIMIT) == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        Json::FastWriter writer;
        if (reader.parse(appEventGroups[i].appEventInfos[j].params, params)) {
            auto time = params["time"].asInt64();
            auto pid = params["pid"].asInt();
            auto uid = params["uid"].asInt();
            auto resourceType = params["resourceType"].asString();
            auto bundleName = params["bundle_name"].asString();
            auto bundleVersion = params["bundle_version"].asString();
            auto memory = writer.write(params["memory"]);
            auto externalLog = writer.write(params["external_log"]);
            std::string logOverLimit = params["log_over_limit"].asBool() ? "true" : "false";
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.resource_type=%{public}s",
                        resourceType.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s",
                        bundleName.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                        bundleVersion.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.memory=%{public}s", memory.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                        externalLog.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}d",
                        logOverLimit.c_str());
        }
    }
}
// [End PssLeakEvent_OnReceive]
// [Start AsanEvent_OnReceive]
static void OnReceiveAsanEvent(const struct HiAppEvent_AppEventGroup *appEventGroups, int i, int j)
{
    if (strcmp(appEventGroups[i].appEventInfos[j].domain, DOMAIN_OS) == 0 &&
        strcmp(appEventGroups[i].appEventInfos[j].name, EVENT_ADDRESS_SANITIZER) == 0) {
        Json::Value params;
        Json::Reader reader(Json::Features::strictMode());
        Json::FastWriter writer;
        if (reader.parse(appEventGroups[i].appEventInfos[j].params, params)) {
            auto time = params["time"].asInt64();
            auto bundleVersion = params["bundle_version"].asString();
            auto bundleName = params["bundle_name"].asString();
            auto pid = params["pid"].asInt();
            auto uid = params["uid"].asInt();
            auto type = params["type"].asString();
            auto boolFlag = params["log_over_limit"].asBool();
            std::string logOverLimit = params["log_over_limit"].asBool() ? "true" : "false";
            auto externalLog = writer.write(params["external_log"]);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                        bundleVersion.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s",
                        bundleName.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.type=%{public}s", type.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                        externalLog.c_str());
            OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}s",
                        logOverLimit.c_str());
        }
    }
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
            // 处理打点事件
            OnReceiveDottingEvent(appEventGroups, i, j);
            // 处理崩溃事件
            OnReceiveCrashEvent(appEventGroups, i, j);
            // 处理卡死事件
            OnReceiveFreezeEvent(appEventGroups, i, j);
            // 处理内存泄漏事件
            OnReceivePssLeakEvent(appEventGroups, i, j);
            // 处理ASAN事件
            OnReceiveAsanEvent(appEventGroups, i, j);
            // 处理主线程卡顿事件
            OnReceiveTimeOutEvent(appEventGroups, i, j);
        }
    }
}
// [End EventSub_OnReceive_All]
// [Start AppEvent_OnTrigger]
static void OnTriggerDottingEvent(std::string domain, std::string name, Json::Value eventInfo)
{
    if (domain == "button" && name == "click") {
        auto clickTime = eventInfo["click_time"].asInt64();
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.click_time=%{public}lld", clickTime);
    }
}
// [End AppEvent_OnTrigger]
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
static void OnTriggerPssLeakEvent(std::string domain, std::string name, Json::Value eventInfo, Json::FastWriter writer)
{
    if (domain == DOMAIN_OS && name == EVENT_RESOURCE_OVERLIMIT) {
        auto time = eventInfo["time"].asInt64();
        auto pid = eventInfo["pid"].asInt();
        auto uid = eventInfo["uid"].asInt();
        auto resourceType = eventInfo["resourceType"].asString();
        auto bundleName = eventInfo["bundle_name"].asString();
        auto bundleVersion = eventInfo["bundle_version"].asString();
        auto memory = writer.write(eventInfo["memory"]);
        auto externalLog = writer.write(eventInfo["external_log"]);
        std::string logOverLimit = eventInfo["log_over_limit"].asBool() ? "true" : "false";
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.time=%{public}lld", time);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.resource_type=%{public}s",
                    resourceType.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s", bundleName.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_version=%{public}s",
                    bundleVersion.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.memory=%{public}s", memory.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                    externalLog.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}d",
                    logOverLimit.c_str());
    }
}
// [End PssLeakEvent_OnTrigger]
// [Start AsanEvent_OnTrigger]
static void OnTriggerAsanEvent(std::string domain, std::string name, Json::Value eventInfo, Json::FastWriter writer)
{
    if (domain == DOMAIN_OS && name == EVENT_ADDRESS_SANITIZER) {
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
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.bundle_name=%{public}s", bundleName.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.pid=%{public}d", pid);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.uid=%{public}d", uid);
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.crash_type=%{public}s", asanType.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.external_log=%{public}s",
                    externalLog.c_str());
        OH_LOG_INFO(LogType::LOG_APP, "HiAppEvent eventInfo.params.log_over_limit=%{public}s",
                    logOverLimit.c_str());
    }
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
            // 处理打点事件
            OnTriggerDottingEvent(domain, name, eventInfo);
            // 处理崩溃事件
            OnTriggerCrashEvent(domain, name, eventInfo, writer);
            // 处理卡死事件
            OnTriggerFreezeEvent(domain, name, eventInfo, writer);
            // 处理内存泄漏事件
            OnTriggerPssLeakEvent(domain, name, eventInfo, writer);
            // 处理ASAN事件
            OnTriggerAsanEvent(domain, name, eventInfo, writer);
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
    const char *names[] = {"click", EVENT_APP_CRASH, EVENT_APP_FREEZE, EVENT_RESOURCE_OVERLIMIT,
        EVENT_ADDRESS_SANITIZER, EVENT_MAIN_THREAD_JANK};
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
static napi_value RemoveWatcher(napi_env env, napi_callback_info info)
{
    // 使观察者停止监听事件
    OH_HiAppEvent_RemoveWatcher(eventWatcherT);
    OH_HiAppEvent_RemoveWatcher(eventWatcherR);
    return {};
}
// [End EventSub_RemoveWatcher_All]
// [Start EventSub_DestroyWatcher_All]
static napi_value DestroyWatcher(napi_env env, napi_callback_info info)
{
    // 销毁创建的观察者，并置appEventWatcher为nullptr。
    OH_HiAppEvent_DestroyWatcher(eventWatcherT);
    OH_HiAppEvent_DestroyWatcher(eventWatcherR);
    eventWatcherT = nullptr;
    eventWatcherR = nullptr;
    return {};
}
// [End EventSub_DestroyWatcher_All]
// [Start AppEvent_WriteAppEvent]
static napi_value WriteAppEvent(napi_env env, napi_callback_info info)
{
    auto params = OH_HiAppEvent_CreateParamList();
    OH_HiAppEvent_AddInt64Param(params, "click_time", time(nullptr));
    OH_HiAppEvent_Write("button", "click", EventType::BEHAVIOR, params);
    OH_HiAppEvent_DestroyParamList(params);
    OH_LOG_INFO(LogType::LOG_APP, "writeEvent C++ success");
    return {};
}
// [End AppEvent_WriteAppEvent]
// [Start AsanEvent_AddressTest]
static napi_value AddressTest(napi_env env, napi_callback_info info)
{
    // 任意实数
    int num = 1;
    int length = 10;
    // 构造数组越界写入
    int a[length];
    a[length] = num;
    return {};
}
// [End AsanEvent_AddressTest]
// [Start EventSub_Init_All]
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"registerWatcher", nullptr, RegisterWatcher, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"writeAppEvent", nullptr, WriteAppEvent, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"addressTest", nullptr, AddressTest, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
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
