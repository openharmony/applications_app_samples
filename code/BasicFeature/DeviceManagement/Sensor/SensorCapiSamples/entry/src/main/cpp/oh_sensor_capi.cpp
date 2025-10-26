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
 
// [Start sensor_capi_development_dependency_import_example]
#include "sensors/oh_sensor.h"
#include "napi/native_api.h"
#include "hilog/log.h"
#include <thread>
// [End sensor_capi_development_dependency_import_example]

// [Start sensor_capi_define_variables_example]
const int SENSOR_LOG_DOMAIN = 0xD002700;
const char *TAG = "[Sensor]";
constexpr Sensor_Type SENSOR_ID { SENSOR_TYPE_ACCELEROMETER };
constexpr uint32_t SENSOR_NAME_LENGTH_MAX = 64;
constexpr int64_t SENSOR_SAMPLE_PERIOD = 200000000;
constexpr int32_t SLEEP_TIME_MS = 1000;
constexpr int64_t INVALID_VALUE = -1;
constexpr float INVALID_RESOLUTION = -1.0F;
Sensor_Subscriber *g_user = nullptr;
// [End sensor_capi_define_variables_example]

// [Start sensor_capi_define_callback_example]
// 定义回调函数
void SensorDataCallbackImpl(Sensor_Event *event)
{
    if (event == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "event is null");
        return;
    }
    int64_t timestamp = INVALID_VALUE;
    // 获取传感器数据的时间戳。
    int32_t ret = OH_SensorEvent_GetTimestamp(event, &timestamp);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get timestamp is failed");
        return;
    }
    Sensor_Type sensorType;
    // 获取传感器类型。
    ret = OH_SensorEvent_GetType(event, &sensorType);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor type is failed");
        return;
    }
    Sensor_Accuracy accuracy = SENSOR_ACCURACY_UNRELIABLE;
    // 获取传感器数据的精度。
    ret = OH_SensorEvent_GetAccuracy(event, &accuracy);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor accuracy is failed");
        return;
    }
    float *data = nullptr;
    uint32_t length = 0;
    // 获取传感器数据。
    ret = OH_SensorEvent_GetData(event, &data, &length);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor data is failed");
        return;
    }
    if (data == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "sensor data is null");
        return;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, SENSOR_LOG_DOMAIN, TAG,
        "sensorType:%{public}d, dataLen:%{public}d, accuracy:%{public}d", sensorType, length, accuracy);
    for (uint32_t i = 0; i < length; ++i) {
        OH_LOG_Print(LOG_APP, LOG_INFO, SENSOR_LOG_DOMAIN, TAG, "data[%{public}d]:%{public}f", i, data[i]);
    }
}
// [End sensor_capi_define_callback_example]

// [Start sensor_capi_get_sensors_info_example]
static int32_t GetSensorInfo(Sensor_Info *sensorInfoTemp)
{
    char sensorName[SENSOR_NAME_LENGTH_MAX] = {};
    uint32_t length = SENSOR_NAME_LENGTH_MAX;
    // 获取传感器名称。
    int32_t ret = OH_SensorInfo_GetName(sensorInfoTemp, sensorName, &length);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor name is failed");
        return ret;
    }
    char vendorName[SENSOR_NAME_LENGTH_MAX] = {};
    length = SENSOR_NAME_LENGTH_MAX;
    // 获取传感器的厂商名称。
    ret = OH_SensorInfo_GetVendorName(sensorInfoTemp, vendorName, &length);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor vender name is failed");
        return ret;
    }
    Sensor_Type sensorType;
    // 获取传感器类型。
    ret = OH_SensorInfo_GetType(sensorInfoTemp, &sensorType);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor type is failed");
        return ret;
    }
    float resolution = INVALID_RESOLUTION;
    // 获取传感器分辨率。
    ret = OH_SensorInfo_GetResolution(sensorInfoTemp, &resolution);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor resolution is failed");
        return ret;
    }
    int64_t minSamplePeriod = INVALID_VALUE;
    // 获取传感器的最小数据上报间隔。
    ret = OH_SensorInfo_GetMinSamplingInterval(sensorInfoTemp, &minSamplePeriod);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor min sampling interval is failed");
        return ret;
    }
    int64_t maxSamplePeriod = INVALID_VALUE;
    // 获取传感器的最大数据上报间隔时间。
    ret = OH_SensorInfo_GetMaxSamplingInterval(sensorInfoTemp, &maxSamplePeriod);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor max sampling interval is failed");
    }
    return ret;
}

static napi_value GetSensorInfos(napi_env env, napi_callback_info info)
{
    uint32_t count = 0;
    // 获取设备上所有传感器的个数。
    int32_t ret = OH_Sensor_GetInfos(nullptr, &count);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor count is failed");
        return nullptr;
    }
    // 用给定的数字创建一个实例数组。
    Sensor_Info **sensors = OH_Sensor_CreateInfos(count);
    if (sensors == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "create sensorInfo array is failed");
        return nullptr;
    }
    // 获取设备上所有传感器的信息。
    ret = OH_Sensor_GetInfos(sensors, &count);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get all sensor info is failed");
        return nullptr;
    }
    for (uint32_t i = 0; i < count; ++i) {
        Sensor_Info *sensorInfoTemp = sensors[i];
        ret = GetSensorInfo(sensorInfoTemp);
        if (ret != SENSOR_SUCCESS) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "get sensor info failed");
            return nullptr;
        }
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, SENSOR_LOG_DOMAIN, TAG, "GetSensorInfos successful");
    // 销毁实例数组并回收内存。
    ret = OH_Sensor_DestroyInfos(sensors, count);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "destroy sensor info is failed");
        return nullptr;
    }
    return nullptr;
}
// [End sensor_capi_get_sensors_info_example]

// [Start sensor_capi_subscriber_example]
static napi_value Subscriber(napi_env env, napi_callback_info info)
{
    // 创建Sensor_Subscriber实例。
    g_user = OH_Sensor_CreateSubscriber();
    // 设置回调函数来报告传感器数据。
    int32_t ret = OH_SensorSubscriber_SetCallback(g_user, SensorDataCallbackImpl);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "OH_SensorSubscriber_SetCallback failed");
        return nullptr;
    }
    // 创建Sensor_SubscriptionId实例。
    Sensor_SubscriptionId *id = OH_Sensor_CreateSubscriptionId();
    // 设置传感器类型,示例中设置的是SENSOR_TYPE_ACCELEROMETER类型，需开通ohos.permission.ACCELEROMETER权限
    // 参考传感器开发指导中 开发步骤第2点配置加速度传感器权限。
    ret = OH_SensorSubscriptionId_SetType(id, SENSOR_ID);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "OH_SensorSubscriptionId_SetType failed");
        return nullptr;
    }
    // 创建Sensor_SubscriptionAttribute实例。
    Sensor_SubscriptionAttribute *attr = OH_Sensor_CreateSubscriptionAttribute();
    // 设置传感器数据报告间隔。
    ret = OH_SensorSubscriptionAttribute_SetSamplingInterval(attr, SENSOR_SAMPLE_PERIOD);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG,
            "OH_SensorSubscriptionAttribute_SetSamplingInterval failed");
        return nullptr;
    }
    // 订阅传感器数据。
    ret = OH_Sensor_Subscribe(id, attr, g_user);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "OH_Sensor_Subscribe failed");
        return nullptr;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, SENSOR_LOG_DOMAIN, TAG, "OH_Sensor_Subscribe successful");
    std::this_thread::sleep_for(std::chrono::milliseconds(SLEEP_TIME_MS));
    // 取消订阅传感器数据。
    ret = OH_Sensor_Unsubscribe(id, g_user);
    if (ret != SENSOR_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, SENSOR_LOG_DOMAIN, TAG, "OH_Sensor_Unsubscribe failed");
        return nullptr;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, SENSOR_LOG_DOMAIN, TAG, "OH_Sensor_Unsubscribe successful");
    if (id != nullptr) {
        // 销毁Sensor_SubscriptionId实例。
        OH_Sensor_DestroySubscriptionId(id);
    }
    if (attr != nullptr) {
        // 销毁Sensor_SubscriptionAttribute实例。
        OH_Sensor_DestroySubscriptionAttribute(attr);
    }
    if (g_user != nullptr) {
        // 销毁Sensor_Subscriber实例并回收内存。
        OH_Sensor_DestroySubscriber(g_user);
        g_user = nullptr;
    }
    return nullptr;
}
// [End sensor_capi_subscriber_example]

// [Start sensor_capi_init_example]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getSensorInfos", nullptr, GetSensorInfos, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"subscriber", nullptr, Subscriber, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END
// [End sensor_capi_init_example]

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