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

#include <cstdlib>
#include <string>
#include "hilog/log.h"
#include "napi/native_api.h"

// napi_get_prototype
static napi_value GetPrototype(napi_env env, napi_callback_info info)
{
    // 获取并解析传参
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value result = nullptr;
    // 获取此对象的原型对象，将结果返回到napi_value类型的变量result中
    napi_get_prototype(env, args[0], &result);
    return result;
}
// napi_create_object
napi_value NewObject(napi_env env, napi_callback_info info)
{
    napi_value object = nullptr;
    // 创建一个空对象
    napi_create_object(env, &object);
    // 设置对象的属性
    napi_value name = nullptr;
    // 设置属性名为"name"
    napi_create_string_utf8(env, "name", NAPI_AUTO_LENGTH, &name);
    napi_value value = nullptr;
    // 设置属性值为"Hello from Node-API!"
    napi_create_string_utf8(env, "Hello from Node-API!", NAPI_AUTO_LENGTH, &value);
    // 将属性设置到对象上
    napi_set_property(env, object, name, value);
    return object;
}
// napi_object_freeze
static napi_value ObjectFreeze(napi_env env, napi_callback_info info)
{
    // 接受一个ArkTS侧传入的object
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // 调用接口napi_object_freeze将传入的object冻结
    napi_value objFreeze = argv[0];
    napi_status status = napi_object_freeze(env, objFreeze);
    if (status == napi_ok) {
        OH_LOG_INFO(LOG_APP, "Node-API napi_object_freeze success");
    }
    // 将冻结后的object传回ArkTS侧
    return objFreeze;
}
// napi_object_seal
static napi_value ObjectSeal(napi_env env, napi_callback_info info)
{
    // 接受一个ArkTS侧传入的object
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 调用接口napi_object_seal将传入的object封闭，使其无法添加新的属性
    napi_value objSeal = argv[0];
    napi_status status = napi_object_seal(env, objSeal);
    if (status == napi_ok) {
        OH_LOG_INFO(LOG_APP, "Node-API napi_object_seal success");
    }
    // 将封闭后的object传回ArkTS侧
    return objSeal;
}
// napi_typeof
static napi_value NapiTypeof(napi_env env, napi_callback_info info)
{
    // 接受一个入参
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 调用napi_typeof判断传入ArkTS参数类型
    napi_valuetype valueType;
    napi_status status = napi_typeof(env, args[0], &valueType);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_typeof fail");
        return nullptr;
    }
    // 将结果转成napi_value类型返回。
    napi_value returnValue = nullptr;
    switch (valueType) {
        case napi_undefined:
            napi_create_string_utf8(env, "Input type is napi_undefined", NAPI_AUTO_LENGTH, &returnValue);
            break;
        case napi_null:
            napi_create_string_utf8(env, "Input type is napi_null", NAPI_AUTO_LENGTH, &returnValue);
            break;
        case napi_boolean:
            napi_create_string_utf8(env, "Input type is napi_boolean", NAPI_AUTO_LENGTH, &returnValue);
            break;
        case napi_number:
            napi_create_string_utf8(env, "Input type is napi_number", NAPI_AUTO_LENGTH, &returnValue);
            break;
        case napi_string:
            napi_create_string_utf8(env, "Input type is napi_string", NAPI_AUTO_LENGTH, &returnValue);
            break;
        case napi_object:
            napi_create_string_utf8(env, "Input type is napi_object", NAPI_AUTO_LENGTH, &returnValue);
            break;
        case napi_function:
            napi_create_string_utf8(env, "Input type is napi_function", NAPI_AUTO_LENGTH, &returnValue);
            break;
        case napi_bigint:
            napi_create_string_utf8(env, "Input type is napi_bigint", NAPI_AUTO_LENGTH, &returnValue);
            break;
        default:
            napi_create_string_utf8(env, "unknown", NAPI_AUTO_LENGTH, &returnValue);
    }
    return returnValue;
}
// napi_instanceof
static napi_value NapiInstanceof(napi_env env, napi_callback_info info)
{
    // 接受两个入参
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 调用napi_instanceof接口判断给定object是否为给定constructor的实例
    bool result = true;
    napi_status status = napi_instanceof(env, args[0], args[1], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_instanceof fail");
        return nullptr;
    }
    // 将结果转成napi_value类型返回
    napi_value returnValue = nullptr;
    napi_get_boolean(env, result, &returnValue);

    return returnValue;
}

#define NUMBERINT_FOUR 4
// 定义一个静态常量napi_type_tag数组存储类型标签
static const napi_type_tag TagsData[NUMBERINT_FOUR] = {
    {0x9e4b2449547061b3, 0x33999f8a6516c499},
    {0x1d55a794c53a726d, 0x43633f509f9c944e},
    // 用于表示无标签或默认标签
    {0, 0},
    {0x6a971439f5b2e5d7, 0x531dc28a7e5317c0},
};
// napi_type_tag_object
static napi_value SetTypeTagToObject(napi_env env, napi_callback_info info)
{
    // 获取函数调用信息和参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取索引数字转换为napi_value
    int32_t index = 0;
    napi_get_value_int32(env, args[1], &index);
    // 给参数（对象）设置类型标签
    napi_status status = napi_type_tag_object(env, args[0], &TagsData[index]);
    if (status != napi_ok) {
        napi_throw_error(env, "Reconnect error", "napi_type_tag_object failed");
        return nullptr;
    }
    // 将bool结果转换为napi_value并返回
    napi_value result = nullptr;
    napi_get_boolean(env, true, &result);
    return result;
}
// napi_check_object_type_tag
static napi_value CheckObjectTypeTag(napi_env env, napi_callback_info info)
{
    // 获取函数调用信息和参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取索引数字转换为napi_value
    int32_t index = 0;
    napi_get_value_int32(env, args[1], &index);
    // 检查对象的类型标签
    bool checkResult = true;
    napi_check_object_type_tag(env, args[0], &TagsData[index], &checkResult);
    // 将bool结果转换为napi_value并返回
    napi_value checked = nullptr;
    napi_get_boolean(env, checkResult, &checked);

    return checked;
}

// 用于释放外部数据的回调函数
void finalizeCallback(napi_env env, void *data, void *hint)
{
    // 释放外部数据
    free(data);
}
// napi_create_external
static napi_value GetExternalType(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取参数的数据类型
    napi_valuetype valueType;
    napi_typeof(env, args[0], &valueType);
    napi_value returnValue = nullptr;
    if (valueType == napi_external) {
        // 如果数据类型是napi_external,则返回true
        napi_get_boolean(env, true, &returnValue);
    } else {
        napi_get_boolean(env, false, &returnValue);
    }
    return returnValue;
}

static napi_value CreateExternal(napi_env env, napi_callback_info info)
{
    // 设置外部数据大小为10
    const size_t dataSize = 10;
    // 分配外部数据
    void *data = malloc(dataSize);
    // 初始化外部数据
    memset(data, 0, dataSize);
    napi_value result = nullptr;
    // 返回带有外部数据的对象
    napi_status status = napi_create_external(env, data, finalizeCallback, nullptr, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, " Node-API Failed to create external data");
        return nullptr;
    }
    return result;
}
// napi_get_value_external
static int g_external = 5;
static napi_value GetValueExternal(napi_env env, napi_callback_info info)
{
    // 创建外部数据
    int *data = &g_external;
    napi_value setExternal = nullptr;
    napi_create_external(env, data, nullptr, nullptr, &setExternal);
    // 获得外部数据的值
    void *getExternal;
    napi_get_value_external(env, setExternal, &getExternal);
    // 返回获得到的外部数据
    napi_value result = nullptr;
    napi_create_int32(env, *(int *)getExternal, &result);
    return result;
}
// napi_create_symbol
static napi_value CreateSymbol(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    const char *des = "only";
    // 使用napi_create_string_utf8创建描述字符串
    napi_create_string_utf8(env, des, NAPI_AUTO_LENGTH, &result);
    napi_value returnSymbol = nullptr;
    // 创建一个symbol类型，并返回
    napi_create_symbol(env, result, &returnSymbol);
    return returnSymbol;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getPrototype", nullptr, GetPrototype, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createObject", nullptr, NewObject, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"objectFreeze", nullptr, ObjectFreeze, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"objectSeal", nullptr, ObjectSeal, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiTypeof", nullptr, NapiTypeof, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiInstanceof", nullptr, NapiInstanceof, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setTypeTagToObject", nullptr, SetTypeTagToObject, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"checkObjectTypeTag", nullptr, CheckObjectTypeTag, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createExternal", nullptr, GetExternalType, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getExternalType", nullptr, CreateExternal, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getValueExternal", nullptr, GetValueExternal, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createSymbol", nullptr, CreateSymbol, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
