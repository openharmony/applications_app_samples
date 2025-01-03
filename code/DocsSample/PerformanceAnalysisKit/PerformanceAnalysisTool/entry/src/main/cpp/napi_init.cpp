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
#include "hitrace/trace.h"
#include "hilog/log.h"
#include "hidebug/hidebug.h"
#include "hicollie/hicollie.h"
#include <thread>
#include <string>
#include <unistd.h>
#include <atomic>

#undef LOG_TAG
#define LOG_TAG "testTag"

static OH_HiCollie_BeginFunc beginFunc_;                                     // 定义回调函数对象
static OH_HiCollie_EndFunc endFunc_;                                         // 定义回调函数对象
HiCollie_DetectionParam param{.sampleStackTriggerTime = 150, .reserved = 0}; // 定义结构体
int64_t g_lastWatchTime = 0;                                                   // 记录上次卡死检测时间
const int64_t CHECK_INTERNAL_TIME = 3000;                                    // 设置卡死检测间隔
std::shared_ptr<std::atomic<bool>> isReport = std::make_shared<std::atomic<bool>>(false); // 设置上报卡死事件标志位
int g_count = 0;                                                                            // 记录第一次初始化
bool g_needReport = false; // 根据实际场景，设置是否上报标志

// 定义回调函数
void InitBeginFunc(const char *eventName)
{
    std::string str(eventName);
    OH_LOG_INFO(LogType::LOG_APP, "InitBeginFunc eventName: %{public}s", str.c_str());
}
void InitEndFunc(const char *eventName)
{
    std::string str(eventName);
    OH_LOG_INFO(LogType::LOG_APP, "OH_HiCollie_EndFunc eventName: %{public}s", str.c_str());
}
// 定义子线程回调函数
void TestJankDetection()
{
    beginFunc_ = InitBeginFunc; // 初始化回调函数
    endFunc_ = InitEndFunc;
    int initResult = OH_HiCollie_Init_JankDetection(&beginFunc_, &endFunc_, param); // 初始化线程卡顿监控函数
    OH_LOG_INFO(LogType::LOG_APP, "OH_HiCollie_Init_JankDetection: %{public}d", initResult); // 成功结果：0
    int countOuter = 0;
    const int loopLimit = 2;          //循环次数限制
    const int sleepTime = 350 * 1000; //睡眠时间350ms，模拟任务线程处理事件卡顿场景
    while (countOuter < loopLimit) {
        beginFunc_("TestBegin"); // 设置处理开始回调函数，监控线程任务执行开始时长
        usleep(sleepTime);
        endFunc_("TestEnd");     // 设置处理结束回调函数，监控线程任务执行结束时长
        countOuter++;
    }
}

static napi_value TestHiCollieJankNdk(napi_env env, napi_callback_info info)
{
    std::thread threadObj(TestJankDetection); // 创建子线程
    threadObj.join();                         // 执行回调函数
    return 0;
}

int64_t GetCurrentTime()
{
    return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch())
        .count();
}

bool ReportEvent()
{
    if ((GetCurrentTime() - g_lastWatchTime) > CHECK_INTERNAL_TIME) {
        return true;
    }
    return false;
}

void TestTask()
{
    if (g_needReport && ReportEvent()) {
        bool temp = isReport->load();
        int reportResult = OH_HiCollie_Report(&temp);
        OH_LOG_INFO(LogType::LOG_APP, "OH_HiCollie_Report: %{public}d", reportResult); // 成功结果：0
        OH_LOG_INFO(LogType::LOG_APP, "OH_HiCollie_Report isReport: %{public}d", temp);
        g_needReport = false;
    }
    int64_t now = GetCurrentTime();
    int64_t halfCheckInterval = CHECK_INTERNAL_TIME / 2;
    if ((now - g_lastWatchTime) >= (halfCheckInterval)) {
        g_lastWatchTime = now;
    }
}

// 定义子线程回调函数
void TestStuckDetection()
{
    int initResult = -1;
    if (g_count == 0) {
        initResult = OH_HiCollie_Init_StuckDetection(TestTask); // 初始化线程卡死监控函数
        OH_LOG_INFO(LogType::LOG_APP, "OH_HiCollie_Init_StuckDetection: %{public}d", initResult); // 成功结果：0
        g_count++;
    }
}
static napi_value TestHiCollieStuckNdk(napi_env env, napi_callback_info info)
{
    std::thread threadObj(TestStuckDetection); // 创建子线程
    threadObj.join();                          // 执行回调函数
    return 0;
}

static napi_value TestHiTraceMeterNDK(napi_env env, napi_callback_info info)
{
    // 测试标记数
    int testNum = 123;
    // 需要开启异步时间片跟踪的地方
    OH_HiTrace_StartAsyncTrace("hitraceTest", testNum);
    // 需要结束异步时间片跟踪的地方（此处为示例，开启点和结束点按实际需求放在需要的地方）
    OH_HiTrace_FinishAsyncTrace("hitraceTest", testNum);
    return 0;
}

static napi_value TestHiTraceChainNDK(napi_env env, napi_callback_info info)
{
    // 需要开启分布式跟踪的地方
    OH_HiTrace_BeginChain("hitraceTest", HITRACE_FLAG_DEFAULT);
    // 需要结束分布式跟踪的地方（此处为示例，开启点和结束点按实际需求放在需要的地方）
    OH_HiTrace_EndChain();
    return 0;
}

static napi_value TestHidebugNdk(napi_env env, napi_callback_info info)
{
    double cpuUsage = OH_HiDebug_GetSystemCpuUsage();
    OH_LOG_INFO(LogType::LOG_APP, "GetSystemCpuUsage: %{public}f", cpuUsage);
    return 0;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "testHidebugNdk", nullptr, TestHidebugNdk, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "testHiTraceMeterNDK", nullptr, TestHiTraceMeterNDK, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "testHiTraceChainNDK", nullptr, TestHiTraceChainNDK, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "testHiCollieJankNdk", nullptr, TestHiCollieJankNdk, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "testHiCollieStuckNdk", nullptr, TestHiCollieStuckNdk, nullptr, nullptr, nullptr, napi_default, nullptr }
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
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}