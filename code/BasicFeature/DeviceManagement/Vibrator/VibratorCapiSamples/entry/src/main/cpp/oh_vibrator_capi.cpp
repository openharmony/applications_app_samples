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
 
// [Start vibrator_capi_development_dependency_import_example]
#include <sensors/vibrator.h>
#include "napi/native_api.h"
#include "hilog/log.h"
#include <thread>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <rawfile/raw_file_manager.h>
// [End vibrator_capi_development_dependency_import_example]

// [Start vibrator_capi_define_variables_example]
const int VIBRATOR_LOG_DOMAIN = 0xD002701;
const char *TAG = "[NativeVibratorTest]";
constexpr int32_t TIME_WAIT_FOR_OP = 2;
// [End vibrator_capi_define_variables_example]

// [Start vibrator_capi_vibrate_in_duration_example]
static napi_value PlayVibrationInDuration(napi_env env, napi_callback_info info)
{
    Vibrator_Attribute vibrateAttribute;
    vibrateAttribute.usage = VIBRATOR_USAGE_ALARM;
    // 控制马达在指定时间内持续振动。
    int32_t ret = OH_Vibrator_PlayVibration(2000, vibrateAttribute);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, VIBRATOR_LOG_DOMAIN, TAG, "vibration fail");
        return nullptr;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, VIBRATOR_LOG_DOMAIN, TAG, "vibration successful");
    std::this_thread::sleep_for(std::chrono::milliseconds(TIME_WAIT_FOR_OP));
    // 停止马达振动。
    ret = OH_Vibrator_Cancel();
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, VIBRATOR_LOG_DOMAIN, TAG, "cancel vibration fail");
        return nullptr;
    }
    return nullptr;
}
// [End vibrator_capi_vibrate_in_duration_example]

// [Start vibrator_capi_vibrate_in_custom_example]
static napi_value PlayVibrationCustom(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = { nullptr };
    // 获取参数信息
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // argv[0]即为函数第一个参数Js资源对象，OH_ResourceManager_InitNativeResourceManager转为Native对象
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    if (mNativeResMgr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, VIBRATOR_LOG_DOMAIN, TAG, "Get native resourceMagr failed");
        return nullptr;
    }
    // 获取rawfile指针对象
    std::string fileName = "coin_drop.json";
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(mNativeResMgr, fileName.c_str());
    if (rawFile == nullptr) {
        OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
        OH_LOG_Print(LOG_APP, LOG_ERROR, VIBRATOR_LOG_DOMAIN, TAG, "Get native rawFile failed");
        return nullptr;
    }
    // 获取rawfile的描述符RawFileDescriptor {fd, offset, length}
    RawFileDescriptor descriptor;
    OH_ResourceManager_GetRawFileDescriptor(rawFile, descriptor);
    Vibrator_FileDescription fileDescription = {
        .fd = descriptor.fd,
        .offset = descriptor.start,
        .length = descriptor.length
    };
    Vibrator_Attribute vibrateAttribute = {
        .usage = VIBRATOR_USAGE_RING
    };
    // 播放自定义振动序列。
    int32_t ret = OH_Vibrator_PlayVibrationCustom(fileDescription, vibrateAttribute);
    bool isSuccess = ((ret == 0) || (ret == UNSUPPORTED));
    if (!isSuccess) {
        OH_LOG_Print(LOG_APP, LOG_INFO, VIBRATOR_LOG_DOMAIN, TAG, "Vibratecustom fail");
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, VIBRATOR_LOG_DOMAIN, TAG, "Vibratecustom successful");
    }
    std::this_thread::sleep_for(std::chrono::milliseconds(TIME_WAIT_FOR_OP));
    // 停止马达振动。
    OH_Vibrator_Cancel();
    // 关闭打开的指针对象
    OH_ResourceManager_CloseRawFile(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return nullptr;
}
// [End vibrator_capi_vibrate_in_custom_example]

// [Start vibrator_capi_init_example]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"playVibrationInDuration", nullptr, PlayVibrationInDuration, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"playVibrationCustom", nullptr, PlayVibrationCustom, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END
// [End vibrator_capi_init_example]

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