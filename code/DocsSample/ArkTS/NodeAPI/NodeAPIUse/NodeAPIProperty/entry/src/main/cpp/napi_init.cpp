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

#include <string>
#include "napi/native_api.h"

static constexpr int INT_ARG_2 = 2; // 入参索引

// [Start napi_get_property_names]
// napi_get_property_names
static napi_value GetPropertyNames(napi_env env, napi_callback_info info)
{
    // 解析ArkTS的传参
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 以字符串数组的形式获取对象的可枚举属性的名称，以result传出
    napi_value result;
    napi_status status = napi_get_property_names(env, args[0], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_get_property_names fail");
        return nullptr;
    }
    return result;
}
// [End napi_get_property_names]

// [Start napi_set_property]
// napi_set_property
static napi_value SetProperty(napi_env env, napi_callback_info info)
{
    // 接收ArkTS侧传入的三个参数：第一个参数为想要设置的object，第二个参数为属性，第三个参数为属性对应的值
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_get_cb_info fail");
    }
    // 通过调用napi_set_property接口将属性与值设置入object，如果失败，直接抛出错误
    status = napi_set_property(env, args[0], args[1], args[INT_ARG_2]);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_set_property fail");
        return nullptr;
    }
    // 返回设置成功的object对象
    return args[0];
}
// [End napi_set_property]

// [Start napi_get_property]
// napi_get_property
static napi_value GetProperty(napi_env env, napi_callback_info info)
{
    // 接收两个ArkTS传来的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 传入的第一个参数为要检测的object，第二个对象为要检测的属性，通过调用napi_get_property接口获取对应的值
    napi_value result;
    napi_status status = napi_get_property(env, args[0], args[1], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_get_property fail");
        return nullptr;
    }
    return result;
}
// [End napi_get_property]

// [Start napi_has_property]
// napi_has_property
static napi_value HasProperty(napi_env env, napi_callback_info info)
{
    // 从ArkTS侧传入两个参数：第一个参数为要检验的对象，第二个参数为要检测是否存在对象的属性
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 将参数传入napi_has_property方法中，若接口调用成功则将结果转化为napi_value类型抛出，否则抛出错误
    bool result;
    napi_status status = napi_has_property(env, args[0], args[1], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_has_property fail");
        return nullptr;
    }

    // 若传入属性存在传入对象中，则输出true将结果转化为napi_value类型抛出
    napi_value returnResult;
    napi_get_boolean(env, result, &returnResult);
    return returnResult;
}
// [End napi_has_property]

// [Start napi_delete_property]
// napi_delete_property
// 从传入的Object对象中删除指定属性，返回是否删除成功的bool结果值
static napi_value DeleteProperty(napi_env env, napi_callback_info info)
{
    // 接收两个ArkTS传来的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valueType;
    napi_typeof(env, args[0], &valueType);
    if (valueType != napi_object) {
        napi_throw_error(env, nullptr, "Expects an object as argument.");
        return nullptr;
    }
    // 删除指定属性，结果存储在result中
    bool result = false;
    napi_status status = napi_delete_property(env, args[0], args[1], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_delete_property failed");
        return nullptr;
    }
    // 将bool结果转换为napi_value并返回
    napi_value ret;
    napi_get_boolean(env, result, &ret);
    return ret;
}
// [End napi_delete_property]

// [Start napi_has_own_property]
// napi_has_own_property
static napi_value NapiHasOwnProperty(napi_env env, napi_callback_info info)
{
    // 接收两个ArkTS传来的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 检查第一个参数是否为对象
    napi_valuetype valueTypeObj;
    napi_typeof(env, args[0], &valueTypeObj);
    if (valueTypeObj != napi_object) {
        napi_throw_error(env, nullptr, "First argument must be an object.");
        return nullptr;
    }
    // 检查第二个参数是否为string
    napi_valuetype valuetypeStr;
    napi_typeof(env, args[1], &valuetypeStr);
    if (valuetypeStr != napi_string) {
        napi_throw_error(env, nullptr, "Second argument must be a string.");
        return nullptr;
    }
    // 检查对象是否具有指定属性，结果存储在hasProperty中
    bool hasProperty;
    napi_status status = napi_has_own_property(env, args[0], args[1], &hasProperty);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_has_own_property failed");
        return nullptr;
    }
    // 将bool结果转换为napi_value并返回
    napi_value result;
    napi_get_boolean(env, hasProperty, &result);
    return result;
}
// [End napi_has_own_property]

// [Start napi_set_named_property]
// napi_set_named_property
static napi_value NapiSetNamedProperty(napi_env env, napi_callback_info info)
{
    // 接收一个ArkTS传来的参数
    size_t argc = 1;
    napi_value str;
    const int32_t strLength = 32;
    char strKey[strLength] = "";
    napi_get_cb_info(env, info, &argc, &str, nullptr, nullptr);
    // 获取传入参数字符串并存储在strKey中
    size_t keyLength;
    napi_get_value_string_utf8(env, str, strKey, strLength, &keyLength);
    // 创建一个新对象
    napi_value newObj;
    napi_create_object(env, &newObj);
    // 设置整数值1234为属性值
    int32_t value = 1234;
    napi_value numValue;
    napi_create_int32(env, value, &numValue);
    // 将整数值与指定属性名关联
    napi_status status = napi_set_named_property(env, newObj, strKey, numValue);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_set_named_property failed");
        return nullptr;
    }
    // 返回设置了命名属性的对象newObj
    return newObj;
}
// [End napi_set_named_property]

// [Start napi_get_named_property]
// napi_get_named_property
static napi_value NapiGetNamedProperty(napi_env env, napi_callback_info info)
{
    // 接收两个ArkTS传来的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    const int32_t strLength = 32;
    char strKey[strLength] = "";
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取要获取的属性名
    size_t keyLength;
    napi_get_value_string_utf8(env, args[1], strKey, strLength, &keyLength);
    // 获取指定属性的值并存储在result中
    napi_value result;
    napi_status status = napi_get_named_property(env, args[0], strKey, &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_get_named_property failed");
        return nullptr;
    }
    // 返回result
    return result;
}
// [End napi_get_named_property]

// [Start napi_has_named_property]
// napi_has_named_property
static napi_value NapiHasNamedProperty(napi_env env, napi_callback_info info)
{
    // 接收两个ArkTS传来的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    const int32_t strLength = 32;
    char strKey[strLength] = "";
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取要检查的属性名
    size_t keyLength;
    napi_get_value_string_utf8(env, args[1], strKey, strLength, &keyLength);
    // 检查对象是否具有指定命名的属性，并将结果存储在hasProperty中
    bool hasProperty = false;
    napi_status status = napi_has_named_property(env, args[0], strKey, &hasProperty);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_has_named_property failed");
        return nullptr;
    }
    // 将bool结果转换为napi_value并返回
    napi_value result;
    napi_get_boolean(env, hasProperty, &result);
    return result;
}
// [End napi_has_named_property]

// [Start napi_define_properties]
// napi_define_properties
static napi_value DefineMethodPropertiesExample(napi_env env, napi_callback_info info)
{
    // 创建一个int32类型的属性值
    int32_t propValue = 26;
    napi_value returnValue = nullptr;
    napi_create_int32(env, propValue, &returnValue);
    return returnValue;
}

// Getter回调函数
static napi_value GetterCallback(napi_env env, napi_callback_info info)
{
    napi_value result;
    const char *str = u8"World!";
    size_t length = strlen(str);
    // 创建属性的值
    napi_create_string_utf8(env, str, length, &result);
    return result;
}

// Setter回调函数
static napi_value SetterCallback(napi_env env, napi_callback_info info)
{
    // 获取传递给setter的参数
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_value result;
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    size_t length = 0;
    napi_get_value_string_utf8(env, argv[0], nullptr, 0, &length);
    char* buf = new char[length + 1];
    std::memset(buf, 0, length + 1);
    napi_get_value_string_utf8(env, argv[0], buf, length + 1, &length);
    napi_create_string_utf8(env, buf, length, &result);
    delete[] buf;
    return result;
}

static napi_value DefineMethodProperties(napi_env env, napi_callback_info info)
{
    napi_value obj;
    napi_create_object(env, &obj);
    // 在obj对象上定义了一个函数defineMethodPropertiesExample，在函数defineMethodPropertiesExample中定义了一个变量并返回，在调用obj的这个对象时可以调用这个函数
    napi_property_descriptor descriptor[] = {{"defineMethodPropertiesExample", nullptr, DefineMethodPropertiesExample,
                                              nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, obj, sizeof(descriptor) / sizeof(descriptor[0]), descriptor);
    return obj;
}

static napi_value DefineStringProperties(napi_env env, napi_callback_info info)
{
    napi_value obj;
    napi_create_object(env, &obj);
    // 创建一个string类型的属性值
    napi_value string_value;
    napi_create_string_utf8(env, "Hello!", NAPI_AUTO_LENGTH, &string_value);
    napi_property_descriptor descriptor[] = {
        {"defineStringPropertiesExample", nullptr, nullptr, nullptr, nullptr, string_value, napi_default, nullptr}};
    napi_define_properties(env, obj, sizeof(descriptor) / sizeof(descriptor[0]), descriptor);
    return obj;
}

static napi_value CreateStringWithGetterSetter(napi_env env, napi_callback_info info)
{
    napi_value obj;
    napi_create_object(env, &obj);
    // 定义getter函数
    napi_value getterFn;
    napi_create_function(env, nullptr, 0, GetterCallback, nullptr, &getterFn);
    napi_set_named_property(env, obj, "getterCallback", getterFn);
    // 定义setter函数
    napi_value setterFn;
    napi_create_function(env, nullptr, 0, SetterCallback, nullptr, &setterFn);
    napi_set_named_property(env, obj, "setterCallback", setterFn);
    // 定义带有getter和setter的属性
    napi_property_descriptor desc = {"defineGetterSetter", nullptr, GetterCallback, SetterCallback, nullptr, obj,
                                     napi_enumerable,      nullptr};
    napi_define_properties(env, obj, 1, &desc);
    return obj;
}
// [End napi_define_properties]

// [Start napi_get_all_property_names]
// napi_get_all_property_names
static napi_value GetAllPropertyNames(napi_env env, napi_callback_info info)
{
    // 传入一个参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取给定对象的所有属性名称
    napi_value result;
    napi_status status = napi_get_all_property_names(env, args[0], napi_key_own_only, napi_key_writable,
                                                     napi_key_numbers_to_strings, &result);
    // 如果获取属性名失败，抛出一个错误
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_get_all_property_names fail");
        return nullptr;
    }

    return result;
}
// [End napi_get_all_property_names]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getPropertyNames", nullptr, GetPropertyNames, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setProperty", nullptr, SetProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getProperty", nullptr, GetProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"hasProperty", nullptr, HasProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"deleteProperty", nullptr, DeleteProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiHasOwnProperty", nullptr, NapiHasOwnProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiSetNamedProperty", nullptr, NapiSetNamedProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiGetNamedProperty", nullptr, NapiGetNamedProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiHasNamedProperty", nullptr, NapiHasNamedProperty, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"defineMethodProperties", nullptr, DefineMethodProperties, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"defineStringProperties", nullptr, DefineStringProperties, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createStringWithGetterSetter", nullptr, CreateStringWithGetterSetter, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"getAllPropertyNames", nullptr, GetAllPropertyNames, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
