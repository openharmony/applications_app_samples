/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#include "napi/native_api.h"
// [Start header_file]
#include <ohaudio/native_audio_device_enhance_manager.h>
#include <ohaudio/native_audio_routing_manager.h>
#include <ohaudio/native_audio_device_base.h>
#include <ohaudio/native_audiocapturer.h>
#include <ohaudio/native_audiorenderer.h>
#include <ohaudio/native_audiostreambuilder.h>
// [End header_file]
#include <sstream>
#include <cstring>

#define SAMPLE_RATE_48K 48000
#define CHANNEL_COUNT_STEREO 2

static OH_AudioDeviceEnhanceManager *GetEnhanceManager(std::string &errorMsg)
{
    OH_AudioDeviceEnhanceManager *manager = nullptr;
    OH_AudioCommon_Result result = OH_AudioManager_GetAudioDeviceEnhanceManager(&manager);
    if (result != AUDIOCOMMON_RESULT_SUCCESS || manager == nullptr) {
        errorMsg = "获取AudioDeviceEnhanceManager失败";
        return nullptr;
    }
    bool isSupported = false;
    OH_AudioDeviceEnhanceManager_IsEnhancedRoutingSupported(manager, &isSupported);
    if (!isSupported) {
        errorMsg = "Enhanced routing不支持，该功能不会生效";
        return nullptr;
    }
    return manager;
}

struct DeviceSearchResult {
    OH_AudioRoutingManager *routingManager;
    OH_AudioDeviceDescriptorArray *deviceArray;
    OH_AudioDeviceDescriptor *targetDescriptor;
};

static DeviceSearchResult FindDescriptorById(int32_t deviceId, OH_AudioDevice_Usage usage)
{
    DeviceSearchResult search = {nullptr, nullptr, nullptr};
    OH_AudioManager_GetAudioRoutingManager(&search.routingManager);
    OH_AudioRoutingManager_GetAvailableDevices(search.routingManager, usage, &search.deviceArray);
    if (search.deviceArray == nullptr) {
        return search;
    }
    for (uint32_t i = 0; i < search.deviceArray->size; i++) {
        uint32_t id = 0;
        OH_AudioDeviceDescriptor_GetDeviceId(search.deviceArray->descriptors[i], &id);
        if (id == static_cast<uint32_t>(deviceId)) {
            search.targetDescriptor = search.deviceArray->descriptors[i];
            break;
        }
    }
    return search;
}

static void ReleaseDeviceSearch(DeviceSearchResult &search)
{
    if (search.routingManager != nullptr && search.deviceArray != nullptr) {
        OH_AudioRoutingManager_ReleaseDevices(search.routingManager, search.deviceArray);
    }
}

static OH_AudioRenderer *CreateAudioRenderer()
{
    OH_AudioStreamBuilder *builder = nullptr;
    if (OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_RENDERER) != AUDIOSTREAM_SUCCESS) {
        return nullptr;
    }
    OH_AudioStreamBuilder_SetSamplingRate(builder, SAMPLE_RATE_48K);
    OH_AudioStreamBuilder_SetChannelCount(builder, CHANNEL_COUNT_STEREO);
    OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetRendererInfo(builder, AUDIOSTREAM_USAGE_VOICE_COMMUNICATION);
    OH_AudioRenderer *renderer = nullptr;
    OH_AudioStreamBuilder_GenerateRenderer(builder, &renderer);
    OH_AudioStreamBuilder_Destroy(builder);
    return renderer;
}

static OH_AudioCapturer *CreateAudioCapturer()
{
    OH_AudioStreamBuilder *builder = nullptr;
    if (OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_CAPTURER) != AUDIOSTREAM_SUCCESS) {
        return nullptr;
    }
    OH_AudioStreamBuilder_SetSamplingRate(builder, SAMPLE_RATE_48K);
    OH_AudioStreamBuilder_SetChannelCount(builder, CHANNEL_COUNT_STEREO);
    OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetCapturerInfo(builder, AUDIOSTREAM_SOURCE_TYPE_VOICE_COMMUNICATION);
    OH_AudioCapturer *capturer = nullptr;
    OH_AudioStreamBuilder_GenerateCapturer(builder, &capturer);
    OH_AudioStreamBuilder_Destroy(builder);
    return capturer;
}

static napi_value CreateNapiString(napi_env env, const std::string &msg)
{
    napi_value retVal;
    napi_create_string_utf8(env, msg.c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

static napi_value ParseInt32Arg(napi_env env, napi_callback_info info, int32_t &outValue)
{
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_get_value_int32(env, args[0], &outValue);
    return nullptr;
}

// [Start isEnhancedRoutingSupported]
napi_value IsEnhancedRoutingSupported(napi_env env, napi_callback_info info)
{
    // [EndExclude isEnhancedRoutingSupported]
    OH_AudioDeviceEnhanceManager *enhanceManager = nullptr;
    OH_AudioCommon_Result result = OH_AudioManager_GetAudioDeviceEnhanceManager(&enhanceManager);
    bool isSupported = false;
    result = OH_AudioDeviceEnhanceManager_IsEnhancedRoutingSupported(enhanceManager, &isSupported);
    // [StartExclude isEnhancedRoutingSupported]

    std::stringstream ss;
    if (enhanceManager == nullptr) {
        ss << "获取AudioDeviceEnhanceManager失败\n错误码: " << result;
    } else {
        ss << "查询增强路由支持完成\nisEnhancedRoutingSupported: " << (isSupported ? "true" : "false");
    }
    return CreateNapiString(env, ss.str());
}
// [End isEnhancedRoutingSupported]

// [Start select_OutputDevice]
napi_value SelectOutputDevice(napi_env env, napi_callback_info info)
{
    // [StartExclude select_OutputDevice]
    int32_t deviceId = 0;
    ParseInt32Arg(env, info, deviceId);
    std::string errorMsg;
    OH_AudioDeviceEnhanceManager *enhanceManager = GetEnhanceManager(errorMsg);
    if (enhanceManager == nullptr) {
        return CreateNapiString(env, errorMsg);
    }
    // [EndExclude select_OutputDevice]

    DeviceSearchResult search = FindDescriptorById(deviceId, AUDIO_DEVICE_USAGE_MEDIA_OUTPUT);
    OH_AudioCommon_Result result = OH_AudioDeviceEnhanceManager_SelectOutputDevice(
        enhanceManager, search.targetDescriptor);
    ReleaseDeviceSearch(search);

    // [StartExclude select_OutputDevice]
    std::stringstream ss;
    if (search.targetDescriptor == nullptr) {
        ss << "未找到匹配的输出设备\n设备ID: " << deviceId;
    } else if (result == AUDIOCOMMON_RESULT_SUCCESS) {
        ss << "为应用选择输出设备成功\n设备ID: " << deviceId;
    } else {
        ss << "为应用选择输出设备失败\n错误码: " << result;
    }
    return CreateNapiString(env, ss.str());
}
// [End select_OutputDevice]

// [Start select_InputDevice]
napi_value SelectInputDevice(napi_env env, napi_callback_info info)
{
    // [StartExclude select_InputDevice]
    int32_t deviceId = 0;
    ParseInt32Arg(env, info, deviceId);
    std::string errorMsg;
    OH_AudioDeviceEnhanceManager *enhanceManager = GetEnhanceManager(errorMsg);
    if (enhanceManager == nullptr) {
        return CreateNapiString(env, errorMsg);
    }
    // [EndExclude select_InputDevice]

    DeviceSearchResult search = FindDescriptorById(deviceId, AUDIO_DEVICE_USAGE_MEDIA_INPUT);
    OH_AudioCommon_Result result = OH_AudioDeviceEnhanceManager_SelectInputDevice(
        enhanceManager, search.targetDescriptor);
    ReleaseDeviceSearch(search);

    // [StartExclude select_InputDevice]
    std::stringstream ss;
    if (search.targetDescriptor == nullptr) {
        ss << "未找到匹配的输入设备\n设备ID: " << deviceId;
    } else if (result == AUDIOCOMMON_RESULT_SUCCESS) {
        ss << "为应用选择输入设备成功\n设备ID: " << deviceId;
    } else {
        ss << "为应用选择输入设备失败\n错误码: " << result;
    }
    return CreateNapiString(env, ss.str());
}
// [End select_InputDevice]

// [Start select_OutputDeviceForAudioRenderer]
napi_value SelectOutputDeviceForAudioRenderer(napi_env env, napi_callback_info info)
{
    // [StartExclude select_OutputDeviceForAudioRenderer]
    int32_t deviceId = 0;
    ParseInt32Arg(env, info, deviceId);
    std::string errorMsg;
    OH_AudioDeviceEnhanceManager *enhanceManager = GetEnhanceManager(errorMsg);
    if (enhanceManager == nullptr) {
        return CreateNapiString(env, errorMsg);
    }
    OH_AudioRenderer *renderer = CreateAudioRenderer();
    if (renderer == nullptr) {
        return CreateNapiString(env, "构造AudioRenderer失败");
    }
    // [EndExclude select_OutputDeviceForAudioRenderer]

    DeviceSearchResult search = FindDescriptorById(deviceId, AUDIO_DEVICE_USAGE_MEDIA_OUTPUT);
    OH_AudioCommon_Result result = OH_AudioDeviceEnhanceManager_SelectOutputDeviceForAudioRenderer(
        enhanceManager, renderer, search.targetDescriptor);
    ReleaseDeviceSearch(search);

    // [StartExclude select_OutputDeviceForAudioRenderer]
    OH_AudioRenderer_Release(renderer);
    std::stringstream ss;
    if (search.targetDescriptor == nullptr) {
        ss << "未找到匹配的输出设备\n设备ID: " << deviceId;
    } else if (result == AUDIOCOMMON_RESULT_SUCCESS) {
        ss << "为Renderer选择输出设备成功\n设备ID: " << deviceId;
    } else {
        ss << "为Renderer选择输出设备失败\n错误码: " << result;
    }
    return CreateNapiString(env, ss.str());
}
// [End select_OutputDeviceForAudioRenderer]

// [Start select_InputDeviceForAudioCapturer]
napi_value SelectInputDeviceForAudioCapturer(napi_env env, napi_callback_info info)
{
    // [StartExclude select_InputDeviceForAudioCapturer]
    int32_t deviceId = 0;
    ParseInt32Arg(env, info, deviceId);
    std::string errorMsg;
    OH_AudioDeviceEnhanceManager *enhanceManager = GetEnhanceManager(errorMsg);
    if (enhanceManager == nullptr) {
        return CreateNapiString(env, errorMsg);
    }
    OH_AudioCapturer *capturer = CreateAudioCapturer();
    if (capturer == nullptr) {
        return CreateNapiString(env, "构造AudioCapturer失败");
    }
    // [EndExclude select_InputDeviceForAudioCapturer]

    DeviceSearchResult search = FindDescriptorById(deviceId, AUDIO_DEVICE_USAGE_MEDIA_INPUT);
    OH_AudioCommon_Result result = OH_AudioDeviceEnhanceManager_SelectInputDeviceForAudioCapturer(
        enhanceManager, capturer, search.targetDescriptor);
    ReleaseDeviceSearch(search);

    // [StartExclude select_InputDeviceForAudioCapturer]
    OH_AudioCapturer_Release(capturer);
    std::stringstream ss;
    if (search.targetDescriptor == nullptr) {
        ss << "未找到匹配的输入设备\n设备ID: " << deviceId;
    } else if (result == AUDIOCOMMON_RESULT_SUCCESS) {
        ss << "为Capturer选择输入设备成功\n设备ID: " << deviceId;
    } else {
        ss << "为Capturer选择输入设备失败\n错误码: " << result;
    }
    return CreateNapiString(env, ss.str());
}
// [End select_InputDeviceForAudioCapturer]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"IsEnhancedRoutingSupported", nullptr, IsEnhancedRoutingSupported, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"SelectOutputDevice", nullptr, SelectOutputDevice, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"SelectInputDevice", nullptr, SelectInputDevice, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"SelectOutputDeviceForAudioRenderer", nullptr, SelectOutputDeviceForAudioRenderer, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"SelectInputDeviceForAudioCapturer", nullptr, SelectInputDeviceForAudioCapturer, nullptr, nullptr, nullptr,
         napi_default, nullptr},
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
