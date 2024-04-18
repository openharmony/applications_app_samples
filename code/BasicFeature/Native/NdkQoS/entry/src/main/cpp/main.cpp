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
#include "qos/qos.h"
#include <thread>
#include <hilog/log.h>
#include <chrono>
#include <unistd.h>
#include <sys/resource.h>
#include <sched.h>

const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
constexpr int DEPTH = 34;
constexpr int TASKS = 3;
constexpr long long ONE = 1;
constexpr long long TWO = 2;
constexpr int BOUND = 20000;

static bool g_addLoad = false;
static double g_durationTime = 0;

static int g_mask = 2;
static int *g_affinity = &g_mask;

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
    int ret = OH_QoS_SetThreadQoS(level); // 设置当前线程的QoS等级为level
    if (!ret) {                           // ret等于0说明设置成功
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "set qos level success.");
        //  查询当前的qos等级
        QoS_Level queryLevel = QoS_Level::QOS_DEFAULT;
        ret = OH_QoS_GetThreadQoS(&queryLevel);
        if (!ret) { // ret等于0说明查询成功
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "the qos level of current thread : %{public}d",
                         queryLevel);
        } else { // 否则说明查询失败
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "get qos level failed.");
            return;
        }
    } else { // ret不等于0说明设置失败
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "get level qos failed!");
        return;
    }

    cpu_set_t mask;
    CPU_SET(*g_affinity, &mask);
    if (sched_setaffinity(0, sizeof(mask), &mask) != 0) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "bind qos thread failed");
        return;
    }

    auto startTime = std::chrono::system_clock::now();
    long long res = DoFib(DEPTH); // 执行计算任务
    auto endTime = std::chrono::system_clock::now();
    g_durationTime = std::chrono::duration<double, std::milli>(endTime - startTime).count();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "calculate res is: %{public}llu", res);

    // reset
    ret = OH_QoS_ResetThreadQoS();
    if (!ret) { // ret等于0说明重置成功
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "reset qos level success.");
    } else { // 否则说明重置失败
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "reset qos level failed!");
        return;
    }

    // 在重置QoS后，再次查询，此时查询会失败
    QoS_Level queryLevelTwo;
    ret = OH_QoS_GetThreadQoS(&queryLevelTwo);
    if (!ret) { // 异常路径
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "the qos level after: %{public}d", queryLevelTwo);
        return;
    } else { // 正常路径
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "querry qos level failed after reset.");
        return;
    }
}

void AddLoads(int n)
{
    if (!n) { // 检查n是否为负数，如果是则退出
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "invalid input.");
        return;
    }
    
    int ret = OH_QoS_SetThreadQoS(QoS_Level::QOS_BACKGROUND); // 设置负载线程的QoS等级
    if (ret) { // ret不等于0说明设置失败
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "set load thread QoS level failed.");
        return;
    }

    cpu_set_t mask;
    CPU_SET(*g_affinity, &mask);
    if (sched_setaffinity(0, sizeof(mask), &mask) != 0) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "bind load thread failed");
        return;
    }

    for (int i = 0; i < BOUND; i++) {
        for (int j = 0; j < BOUND; j++) {
            int x = (i + j) - n;
            printf("%d", x);
        }
    }
}

static napi_value highQoSCalculate(napi_env env, napi_callback_info info)
{
    g_durationTime = 0;

    if (!g_addLoad) {
        std::vector<std::thread> loadThreads;
        for (int i = 0; i < TASKS; i++) {
            loadThreads.emplace_back(std::thread(AddLoads, TASKS));
            loadThreads[i].detach();
        }

        g_addLoad = true;
    }

    QoS_Level level = QoS_Level::QOS_USER_INTERACTIVE;
    std::thread task(SetQoS, level);
    task.join();

    napi_value res;
    napi_create_double(env, g_durationTime, &res);
    return res;
}

static napi_value lowQoSCalculate(napi_env env, napi_callback_info info)
{
    g_durationTime = 0;

    if (!g_addLoad) {
        std::vector<std::thread> loadThreads;
        for (int i = 0; i < TASKS; i++) {
            loadThreads.emplace_back(std::thread(AddLoads, TASKS));
            loadThreads[i].detach();
        }

        g_addLoad = true;
    }

    QoS_Level level = QoS_Level::QOS_BACKGROUND;
    std::thread task(SetQoS, level);
    task.join();

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
