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

#include <chrono>
#include <thread>
#include <unistd.h>
#include <sched.h>
#include <sys/resource.h>
#include <hilog/log.h>
#include "napi/native_api.h"
#include "qos/qos.h"

const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
constexpr int DEPTH = 34;
constexpr int TASKS = 6;   // 负载线程个数
constexpr long long ONE = 1;
constexpr long long TWO = 2;
constexpr int BOUND = 20000;

constexpr int MASK = 2;
constexpr int CPUS = 4;

static bool g_addLoad = false;    // 负载线程是否加载
static double g_durationTime = 0; // 计算任务耗时时间

// 执行 斐波那契数列 计算
long long DoFib(double n)
{
    if (n == ONE) {
        return ONE;
    }

    if (n == TWO) {
        return TWO;
    }
    return DoFib(n - ONE) + DoFib(n - TWO);
}

void SetQoS(QoS_Level level)
{
    // 设置当前线程的QoS等级为level
    int ret = OH_QoS_SetThreadQoS(level);
    if (!ret) {                           // ret等于0说明设置成功
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "set qos level success.");
        //  查询当前的qos等级
        QoS_Level queryLevel = QoS_Level::QOS_DEFAULT;
        ret = OH_QoS_GetThreadQoS(&queryLevel);
        if (!ret) { // ret等于0说明查询成功
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "the qos level of current thread : %{public}d",
                         queryLevel);
        } else { // 否则说明查询失败
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "QoS", "get qos level failed.");
            return;
        }
    } else { // ret不等于0说明设置失败
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "QoS", "get level qos failed!");
        return;
    }
    
    // 绑定到特定cpu
    cpu_set_t mask;
    CPU_SET(MASK, &mask);
    if (sched_setaffinity(0, sizeof(mask), &mask) != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "QoS", "bind work thread failed");
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "bind work thread success.");
    }
    
    // 执行斐波那契数列计算任务
    auto startTime = std::chrono::system_clock::now();
    long long res = DoFib(DEPTH); // 执行斐波那契数列计算任务
    auto endTime = std::chrono::system_clock::now();
    g_durationTime = std::chrono::duration<double, std::milli>(endTime - startTime).count();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "calculate res is: %{public}llu", res);

    // 重置线程QoS等级
    ret = OH_QoS_ResetThreadQoS();
    if (!ret) { // ret等于0说明重置成功
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "reset qos level success.");
    } else { // 否则说明重置失败
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "QoS", "reset qos level failed!");
        return;
    }

    // 在重置QoS后，再次查询，此时查询会失败
    QoS_Level queryLevelTwo;
    ret = OH_QoS_GetThreadQoS(&queryLevelTwo);
    if (!ret) { // 正常路径
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "the qos level after: %{public}d", queryLevelTwo);
        return;
    } else { // 异常路径
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "QoS", "query qos level failed after reset.");
        return;
    }
}

// 负载任务
void AddLoads(int n)
{
    int ret = OH_QoS_SetThreadQoS(QoS_Level::QOS_BACKGROUND); // 设置负载线程的QoS等级
    if (ret) {                                                // ret不等于0说明设置失败
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "QoS", "set load thread QoS level failed.");
        return;
    }
    
    // 绑定到特定cpu
    cpu_set_t mask;
    CPU_SET(n, &mask);
    if (sched_setaffinity(0, sizeof(mask), &mask) != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "QoS", "bind load thread failed");
        return;
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "bind load threads success.");
    }
    
    // 执行负载计算
    for (int i = 0; i < BOUND; i++) {
        for (int j = 0; j < BOUND; j++) {
            int x = (i + j) - n;
            printf("%d", x);
        }
    }
    // 重新初始化负载线程
    g_addLoad = false;
}

static napi_value highQoSCalculate(napi_env env, napi_callback_info info)
{
    g_durationTime = 0;
    // 没有加载系统负载的情况下，开启TASKS个线程模拟系统负载
    if (!g_addLoad) {
        std::vector<std::thread> loadThreads;
        for (int i = 0; i < TASKS; i++) {
            // 开启线程执行负载任务
            loadThreads.emplace_back(std::thread(AddLoads, i % CPUS));
            loadThreads[i].detach();
        }
        g_addLoad = true;
    }
    // 开启 QOS_USER_INTERACTIVE 高 QoS 线程进行计算
    QoS_Level level = QoS_Level::QOS_USER_INTERACTIVE;
    std::thread task(SetQoS, level);
    task.join();
    
    // 返回计算耗时
    napi_value res;
    napi_create_double(env, g_durationTime, &res);
    return res;
}

static napi_value lowQoSCalculate(napi_env env, napi_callback_info info)
{
    g_durationTime = 0;
    // 没有加载系统负载的情况下，开启TASKS个线程模拟系统负载
    if (!g_addLoad) {
        std::vector<std::thread> loadThreads;
        for (int i = 0; i < TASKS; i++) {
            // 开启线程执行负载任务
            loadThreads.emplace_back(std::thread(AddLoads, i % CPUS));
            loadThreads[i].detach();
        }
        g_addLoad = true;
    }

    // 开启 QOS_BACKGROUND 低 QoS 线程进行计算
    QoS_Level level = QoS_Level::QOS_BACKGROUND;
    std::thread task(SetQoS, level);
    task.join();

    // 返回计算耗时
    napi_value res;
    napi_create_double(env, g_durationTime, &res);
    return res;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"useHighQos", nullptr, highQoSCalculate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"useLowQos", nullptr, lowQoSCalculate, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
