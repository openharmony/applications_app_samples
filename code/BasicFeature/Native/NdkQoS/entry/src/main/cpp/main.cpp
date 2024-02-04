#include "napi/native_api.h"
#include "qos/qos.h"
#include <thread>
#include <hilog/log.h>
#include <chrono>

const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
constexpr int DEPTH = 34;
constexpr int TASKS = 10;
constexpr int ONE = 1;
constexpr int TWO = 2;

static bool AddedLoad = false;
static double durationMillSecondTime;

double fib(double n) {
    if (n == ONE) {
        return ONE;
    }

    if (n == TWO) {
        return TWO;
    }

    return fib(n - ONE) + fib(n -TWO);
}

void setQoS(QoS_Level level) {
    int ret = OH_QoS_SetThreadQoS(level); // 设置当前线程的QoS等级为level

    if (!ret) { // ret等于0说明设置成功
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "set qos level success.");
        //  查询当前的qos等级
        QoS_Level querryLevel = QoS_Level::QOS_DEFAULT;
        ret = OH_QoS_GetThreadQoS(&querryLevel);
        if (!ret) { // ret等于0说明查询成功
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "the qos level of current thread : %{public}d",
                         querryLevel);
        } else { // 否则说明查询失败
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "get qos level failed.");
        }

    } else { // ret不等于0说明设置失败
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "get level qos failed!");
        return;
    }

    auto startTime = std::chrono::system_clock::now();
    double res = fib(DEPTH); // do calculation task
    auto endTime = std::chrono::system_clock::now();
    durationMillSecondTime = std::chrono::duration<double, std::milli>(endTime - startTime).count(); 
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "calculate res is: %{public}f", res);

    // reset
    ret = OH_QoS_ResetThreadQoS();
    if (!ret) { // ret等于0说明重置成功
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "reset qos level success.");
    } else { // 否则说明重置失败
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "reset qos level failed!");
        return;
    }

    // 在重置QoS后，再次查询，此时查询会失败
    QoS_Level querryLevelTwo;
    ret = OH_QoS_GetThreadQoS(&querryLevelTwo);
    if (!ret) { // 异常路径
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "the qos level after: %{public}d", querryLevelTwo);
    } else { // 正常路径
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "QoS", "querry qos level failed after reset.");
        return;
    }
}


void addLoads(int n) {
    while (true) {
        n = (n + 1) % TASKS;
        n *= n;
        printf("%d\n", n);
    }
}

static napi_value highQoSCalculate(napi_env env, napi_callback_info info)
{
    durationMillSecondTime = 0;
    
    if (!AddedLoad) {
        std::vector<std::thread> loadThreads;
        for (int i = 0; i < TASKS; i++) {
            loadThreads.emplace_back(std::thread(addLoads, 5));
            loadThreads[i].detach();
        }

        AddedLoad = true;
    }

    QoS_Level level = QoS_Level::QOS_USER_INTERACTIVE;
    std::thread task(setQoS, level);
    task.join();

    napi_value res;
    napi_create_double(env, durationMillSecondTime, &res);
    return res;
}

static napi_value lowQoSCalculate(napi_env env, napi_callback_info info) {
    durationMillSecondTime = 0;
    
    if (!AddedLoad) {
        std::vector<std::thread> loadThreads;
        for (int i = 0; i < 20; i++) {
            loadThreads.emplace_back(std::thread(addLoads, 5));
            loadThreads[i].detach();
        }

        AddedLoad = true;
    }

    QoS_Level level = QoS_Level::QOS_BACKGROUND;
    std::thread task(setQoS, level);
    task.join();

    napi_value res;
    napi_create_double(env, durationMillSecondTime, &res);
    return res;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"useHighQos", nullptr, highQoSCalculate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"useLowQos", nullptr, lowQoSCalculate, nullptr, nullptr, nullptr, napi_default, nullptr}
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
