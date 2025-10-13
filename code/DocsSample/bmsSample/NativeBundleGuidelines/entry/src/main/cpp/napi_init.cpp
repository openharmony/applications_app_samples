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

// [Start native-bundle-guidelines_002]
//napi依赖头文件
#include "napi/native_api.h"
//NDK接口依赖头文件
#include "bundle/native_interface_bundle.h"
//free()函数依赖的基础库
#include <cstdlib>
// [End native-bundle-guidelines_002]

static napi_value Add(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    return sum;

}

// [Start native-bundle-guidelines_003]
static napi_value GetCurrentApplicationInfo(napi_env env, napi_callback_info info)
{
    // 调用Native接口获取应用信息
    OH_NativeBundle_ApplicationInfo nativeApplicationInfo = OH_NativeBundle_GetCurrentApplicationInfo();
    napi_value result = nullptr;
    napi_create_object(env, &result);
    // Native接口获取的应用包名转为js对象里的bundleName属性
    napi_value bundleName;
    napi_create_string_utf8(env, nativeApplicationInfo.bundleName, NAPI_AUTO_LENGTH, &bundleName);
    napi_set_named_property(env, result, "bundleName", bundleName);
    // Native接口获取的指纹信息转为js对象里的fingerprint属性
    napi_value fingerprint;
    napi_create_string_utf8(env, nativeApplicationInfo.fingerprint, NAPI_AUTO_LENGTH, &fingerprint);
    napi_set_named_property(env, result, "fingerprint", fingerprint);

    // 最后为了防止内存泄漏，手动释放
    free(nativeApplicationInfo.bundleName);
    free(nativeApplicationInfo.fingerprint);
    return result;
}

static napi_value GetAppId(napi_env env, napi_callback_info info)
{
    // 调用Native接口获取应用appId
    char* appId = OH_NativeBundle_GetAppId();
    // Native接口转成nAppId返回
    napi_value nAppId;
    napi_create_string_utf8(env, appId, NAPI_AUTO_LENGTH, &nAppId);
    // 最后为了防止内存泄漏，手动释放
    free(appId);
    return nAppId;
}

static napi_value GetAppIdentifier(napi_env env, napi_callback_info info)
{
    // 调用Native接口获取应用appIdentifier
    char* appIdentifier = OH_NativeBundle_GetAppIdentifier();
    // Native接口转成nAppIdentifier返回
    napi_value nAppIdentifier;
    napi_create_string_utf8(env, appIdentifier, NAPI_AUTO_LENGTH, &nAppIdentifier);
    // 最后为了防止内存泄漏，手动释放
    free(appIdentifier);
    return nAppIdentifier;
}

static napi_value GetMainElementName(napi_env env, napi_callback_info info)
{
    // 调用Native接口获取应用入口的信息
    OH_NativeBundle_ElementName elementName = OH_NativeBundle_GetMainElementName();
    napi_value result = nullptr;
    napi_create_object(env, &result);
    // Native接口获取的应用包名转为js对象里的bundleName属性
    napi_value bundleName;
    napi_create_string_utf8(env, elementName.bundleName, NAPI_AUTO_LENGTH, &bundleName);
    napi_set_named_property(env, result, "bundleName", bundleName);
    // Native接口获取的模块名称转为js对象里的moduleName属性
    napi_value moduleName;
    napi_create_string_utf8(env, elementName.moduleName, NAPI_AUTO_LENGTH, &moduleName);
    napi_set_named_property(env, result, "moduleName", moduleName);
    // Native接口获取的ability名称转为js对象里的abilityName属性
    napi_value abilityName;
    napi_create_string_utf8(env, elementName.abilityName, NAPI_AUTO_LENGTH, &abilityName);
    napi_set_named_property(env, result, "abilityName", abilityName);
    // 最后为了防止内存泄漏，手动释放
    free(elementName.bundleName);
    free(elementName.moduleName);
    free(elementName.abilityName);
    return result;
}

static napi_value GetCompatibleDeviceType(napi_env env, napi_callback_info info)
{
    // 调用Native接口获取应用deviceType
    char* deviceType = OH_NativeBundle_GetCompatibleDeviceType();
    // Native接口转成nDeviceType返回
    napi_value nDeviceType;
    napi_create_string_utf8(env, deviceType, NAPI_AUTO_LENGTH, &nDeviceType);
    // 最后为了防止内存泄漏，手动释放
    free(deviceType);
    return nDeviceType;
}

static napi_value IsDebugMode(napi_env env, napi_callback_info info)
{
    bool isDebug = false;
    // 调用Native接口获取应用DebugMode的信息
    bool isSuccess = OH_NativeBundle_IsDebugMode(&isDebug);
    // 调用Native接口失败抛出异常
    if (isSuccess == false) {
        napi_throw_error(env, nullptr, "call failed");
        return nullptr;
    }
    // Native接口转成debug返回
    napi_value debug;
    napi_get_boolean(env, isDebug, &debug);
    return debug;
}

static napi_value GetModuleMetadata(napi_env env, napi_callback_info info)
{
    size_t moduleCount = 0;
    // 调用Native接口获取应用元数据的信息
    OH_NativeBundle_ModuleMetadata* modules = OH_NativeBundle_GetModuleMetadata(&moduleCount);
    if (modules == nullptr || moduleCount == 0) {
        napi_throw_error(env, nullptr, "no metadata found");
        return nullptr;
    }

    napi_value result;
    napi_create_array(env, &result);

    for (size_t i = 0; i < moduleCount; i++) {
        napi_value moduleObj;
        napi_create_object(env, &moduleObj);

        // Native接口获取的模块名转为js对象里的moduleName属性
        napi_value moduleName;
        napi_create_string_utf8(env, modules[i].moduleName, NAPI_AUTO_LENGTH, &moduleName);
        napi_set_named_property(env, moduleObj, "moduleName", moduleName);

        napi_value metadataArray;
        napi_create_array(env, &metadataArray);

        for (size_t j = 0; j < modules[i].metadataArraySize; j++) {
            napi_value metadataObj;
            napi_create_object(env, &metadataObj);

            napi_value name;
            napi_value value;
            napi_value resource;

            napi_create_string_utf8(env, modules[i].metadataArray[j].name, NAPI_AUTO_LENGTH, &name);
            napi_create_string_utf8(env, modules[i].metadataArray[j].value, NAPI_AUTO_LENGTH, &value);
            napi_create_string_utf8(env, modules[i].metadataArray[j].resource, NAPI_AUTO_LENGTH, &resource);

            // Native接口获取的元数据名称转为js对象里的name属性
            napi_set_named_property(env, metadataObj, "name", name);
            // Native接口获取的元数据值名称转为js对象里的value属性
            napi_set_named_property(env, metadataObj, "value", value);
            // Native接口获取的元数据资源转为js对象里的resource属性
            napi_set_named_property(env, metadataObj, "resource", resource);

            napi_set_element(env, metadataArray, j, metadataObj);
        }

        napi_set_named_property(env, moduleObj, "metadata", metadataArray);
        napi_set_element(env, result, i, moduleObj);
    }

    // 最后为了防止内存泄漏，手动释放
    for (size_t i = 0; i < moduleCount; i++) {
        free(modules[i].moduleName);
        for (size_t j = 0; j < modules[i].metadataArraySize; j++) {
            free(modules[i].metadataArray[j].name);
            free(modules[i].metadataArray[j].value);
            free(modules[i].metadataArray[j].resource);
        }
        free(modules[i].metadataArray);
    }
    free(modules);
    return result;
}
// [End native-bundle-guidelines_003]

// [Start native-bundle-guidelines_004]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getCurrentApplicationInfo", nullptr, GetCurrentApplicationInfo, nullptr, nullptr, nullptr, napi_default, nullptr},   // 新增方法 getCurrentApplicationInfo
        { "getAppId", nullptr, GetAppId, nullptr, nullptr, nullptr, napi_default, nullptr},                                     // 新增方法 getAppId
        { "getAppIdentifier", nullptr, GetAppIdentifier, nullptr, nullptr, nullptr, napi_default, nullptr},                     // 新增方法 getAppIdentifier
        { "getMainElementName", nullptr, GetMainElementName, nullptr, nullptr, nullptr, napi_default, nullptr},                 // 新增方法 getMainElementName
        { "getCompatibleDeviceType", nullptr, GetCompatibleDeviceType, nullptr, nullptr, nullptr, napi_default, nullptr},       // 新增方法 getCompatibleDeviceType
        { "isDebugMode", nullptr, IsDebugMode, nullptr, nullptr, nullptr, napi_default, nullptr},                               // 新增方法 isDebugMode
        { "getModuleMetadata", nullptr, GetModuleMetadata, nullptr, nullptr, nullptr, napi_default, nullptr}                    // 新增方法 getModuleMetadata
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END
// [End native-bundle-guidelines_004]

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
