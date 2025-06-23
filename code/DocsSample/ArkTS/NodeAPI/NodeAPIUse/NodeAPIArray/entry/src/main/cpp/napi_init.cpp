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

// [Start napi_create_array]
static constexpr int INT_NUMBER_5 = 5; // 入参索引
static constexpr int INT_ARGS_2 = 2; // 入参索引

// 使用Node-API接口进行array相关开发 napi_create_array
static napi_value CreateArray(napi_env env, napi_callback_info info)
{
    // 创建一个空数组
    napi_value jsArray = nullptr;
    napi_create_array(env, &jsArray);
    // 将创建好的数组进行赋值
    for (int i = 0; i < INT_NUMBER_5; i++) {
        napi_value element;
        napi_create_int32(env, i, &element);
        napi_set_element(env, jsArray, i, element);
    }
    // 返回已创建好的数组
    return jsArray;
}
// [End napi_create_array]

// [Start napi_create_array_with_length]
// 使用Node-API接口进行array相关开发 napi_create_array_with_length
static napi_value CreateArrayWithLength(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_value jsArray = nullptr;
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // 获取传递的数组长度
    int32_t length = 0;
    napi_get_value_int32(env, argv[0], &length);
    // 使用napi_create_array_with_length创建指定长度的数组
    napi_create_array_with_length(env, length, &jsArray);
    // 返回数组
    return jsArray;
}
// [End napi_create_array_with_length]

// [Start napi_get_array_length]
// 使用Node-API接口进行array相关开发 napi_get_array_length
static napi_value GetArrayLength(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value result;
    uint32_t length;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 检查参数是否为数组
    bool isArray;
    napi_is_array(env, args[0], &isArray);
    if (!isArray) {
        napi_throw_type_error(env, nullptr, "Argument must be an array");
        return nullptr;
    }
    napi_get_array_length(env, args[0], &length);
    // 创建返回值
    napi_create_uint32(env, length, &result);
    return result;
}
// [End napi_get_array_length]

// [Start napi_is_array]
// 使用Node-API接口进行array相关开发 napi_is_array
static napi_value IsArray(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 调用napi_is_array接口判断给定入参是否为array数组
    bool result;
    napi_status status = napi_is_array(env, args[0], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_is_array fail");
        return nullptr;
    }
    // 将结果转成napi_value类型返回
    napi_value returnValue;
    napi_get_boolean(env, result, &returnValue);

    return returnValue;
}
// [End napi_is_array]

// [Start napi_set_element]
// 使用Node-API接口进行array相关开发 napi_set_element
static napi_value NapiSetElement(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 检查第一个参数是否为数组
    bool isArr = false;
    napi_is_array(env, args[0], &isArr);
    if (!isArr) {
        napi_throw_type_error(env, nullptr, "Argument should be an object of type array");
        return nullptr;
    }
    // 获取要设置的元素索引
    double index = 0;
    napi_get_value_double(env, args[1], &index);
    // 将传入的值设置到数组指定索引位置
    napi_set_element(env, args[0], static_cast<uint32_t>(index), args[INT_ARGS_2]);

    return nullptr;
}
// [End napi_set_element]

// [Start napi_get_element]
// 使用Node-API接口进行array相关开发 napi_get_element
static napi_value NapiGetElement(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取请求元素的索引值
    uint32_t index;
    napi_get_value_uint32(env, args[1], &index);
    // 获取请求索引位置的元素值并存储在result中
    napi_value result;
    napi_get_element(env, args[0], index, &result);

    return result;
}
// [End napi_get_element]

// [Start napi_has_element]
// 使用Node-API接口进行array相关开发 napi_has_element
static napi_value NapiHasElement(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取要判断的元素的索引
    uint32_t index;
    napi_get_value_uint32(env, args[1], &index);
    // 判断指定索引位置的元素是否存在
    bool hasElement = true;
    napi_has_element(env, args[0], index, &hasElement);
    // 将bool结果转换为napi_value并返回
    napi_value result;
    napi_get_boolean(env, hasElement, &result);
    return result;
}
// [End napi_has_element]

// [Start napi_delete_element]
// 使用Node-API接口进行array相关开发 napi_delete_element
static napi_value NapiDeleteElement(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取要删除的元素的索引
    uint32_t index;
    napi_get_value_uint32(env, args[1], &index);
    // 尝试删除请求索引位置的元素
    bool deleted = true;
    napi_delete_element(env, args[0], index, &deleted);
    // 将bool结果转换为napi_value并返回
    napi_value result;
    napi_get_boolean(env, deleted, &result);
    return result;
}
// [End napi_delete_element]

// [Start napi_create_typed_array]
// 使用Node-API接口进行array相关开发 napi_create_typedarray
static napi_value CreateTypedArray(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int32_t typeNum = 0;
    napi_get_value_int32(env, args[0], &typeNum);
    napi_typedarray_type arrayType;
    // 用于存储每个元素的大小
    size_t elementSize = 0;
    // 根据传递的类型值选择创建对应的类型数组
    arrayType = static_cast<napi_typedarray_type>(typeNum);
    switch (typeNum) {
        case napi_int8_array:
        case napi_uint8_array:
        case napi_uint8_clamped_array:
            elementSize = sizeof(int8_t);
            break;
        case napi_int16_array:
        case napi_uint16_array:
            elementSize = sizeof(int16_t);
            break;
        case napi_int32_array:
        case napi_uint32_array:
            elementSize = sizeof(int32_t);
            break;
        case napi_float32_array:
            elementSize = sizeof(float);
            break;
        case napi_float64_array:
            elementSize = sizeof(double);
            break;
        case napi_bigint64_array:
        case napi_biguint64_array:
            elementSize = sizeof(int64_t);
            break;
        default:
            // 默认创建napi_int8_array类型
            arrayType = napi_int8_array;
            elementSize = sizeof(int8_t);
            break;
    }
    size_t length = 3;
    napi_value arrayBuffer = nullptr;
    napi_value typedArray = nullptr;
    void *data;
    // 创建一个ArrayBuffer
    napi_create_arraybuffer(env, length * elementSize, (void **)&data, &arrayBuffer);
    // 根据给定类型创建TypedArray
    napi_create_typedarray(env, arrayType, length, arrayBuffer, 0, &typedArray);
    return typedArray;
}
// [End napi_create_typed_array]

// [Start napi_is_typed_array]
// 使用Node-API接口进行array相关开发 napi_is_typedarray
static napi_value IsTypedarray(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 调用napi_is_typedarray接口判断给定入参类型是否为TypedArray。
    bool result = false;
    napi_status status = napi_is_typedarray(env, args[0], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_is_typedarray fail");
        return nullptr;
    }
    // 将结果转成napi_value类型返回。
    napi_value returnValue = nullptr;
    napi_get_boolean(env, result, &returnValue);

    return returnValue;
}
// [End napi_is_typed_array]

// [Start napi_get_typed_array_info]
// 使用Node-API接口进行array相关开发 napi_get_typedarray_info
static napi_value GetTypedarrayInfo(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数，第一个参数为需要获得的信息的TypedArray类型数据，第二个参数为需要获得的信息类型的枚举值
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将第二个参数转为int32类型便于比较
    int32_t infoTypeParam;
    napi_get_value_int32(env, args[1], &infoTypeParam);
    // 定义枚举类型与ArkTS侧枚举类型InfoType顺序含义一致
    enum InfoType { INFO_TYPE = 1, INFO_LENGTH, INFO_ARRAY_BUFFER, INFO_BYTE_OFFSET };
    void *data;
    napi_typedarray_type type;
    size_t byteOffset;
    size_t length;
    napi_value arraybuffer;
    // 调用接口napi_get_typedarray_info获得TypedArray类型数据的信息
    napi_get_typedarray_info(env, args[0], &type, &length, &data, &arraybuffer, &byteOffset);
    napi_value result;
    // 根据属性名，返回TypedArray对应的属性值
    switch (infoTypeParam) {
        case INFO_TYPE:
            // 如果传入的参数是int8类型的TypedArray数据，它的类型（type）为napi_int8_array
            napi_value int8_type;
            napi_get_boolean(env, type == napi_int8_array, &int8_type);
            result = int8_type;
            break;
        case INFO_LENGTH:
            // TypedArray中的元素数
            napi_value napiLength;
            napi_create_int32(env, length, &napiLength);
            result = napiLength;
            break;
        case INFO_BYTE_OFFSET:
            // TypedArray数组的第一个元素所在的基础原生数组中的字节偏移量
            napi_value napiByteOffset;
            napi_create_int32(env, byteOffset, &napiByteOffset);
            result = napiByteOffset;
            break;
        case INFO_ARRAY_BUFFER:
            // TypedArray下的ArrayBuffer
            result = arraybuffer;
            break;
        default:
            break;
    }
    return result;
}
// [End napi_get_typed_array_info]

// [Start napi_create_data_view]
// 使用Node-API接口进行array相关开发 napi_create_dataview
static napi_value CreateDataView(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_value arraybuffer = nullptr;
    napi_value result = nullptr;
    // DataView的字节长度
    size_t byteLength = 12;
    // 字节偏移量
    size_t byteOffset = 4;
    // 获取回调函数的参数信息
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将参数转换为对象类型
    napi_coerce_to_object(env, args[0], &arraybuffer);
    // 创建一个数据视图对象，并指定字节长度和字节偏移量
    napi_status status = napi_create_dataview(env, byteLength, arraybuffer, byteOffset, &result);
    if (status != napi_ok) {
        // 抛出创建DataView内容失败的错误
        napi_throw_error(env, nullptr, "Failed to create DataView");
        return nullptr;
    }
    // 获取DataView的指针和长度信息
    uint8_t *data = nullptr;
    size_t length = 0;
    napi_get_dataview_info(env, result, &length, (void **)&data, nullptr, nullptr);
    // 为DataView赋值
    for (size_t i = 0; i < length; i++) {
        data[i] = static_cast<uint8_t>(i + 1);
    }
    return result;
}
// [End napi_create_data_view]

// [Start napi_is_data_view]
// 使用Node-API接口进行array相关开发 napi_is_dataview
static napi_value IsDataView(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 调用napi_is_dataview接口判断给定入参是否为DataView数据。
    bool result;
    napi_status status = napi_is_dataview(env, args[0], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_is_dataview fail");
        return nullptr;
    }
    // 将结果转成napi_value类型返回。
    napi_value returnValue;
    napi_get_boolean(env, result, &returnValue);

    return returnValue;
}
// [End napi_is_data_view]

// [Start napi_get_data_view_info]
// 使用Node-API接口进行array相关开发 napi_get_dataview_info
static napi_value GetDataViewInfo(napi_env env, napi_callback_info info)
{
    // 获取ArkTS侧传入的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 将第二个参数转为int32类型的数字
    int32_t infoType;
    napi_get_value_int32(env, args[1], &infoType);
    size_t byteLength;
    void *data;
    napi_value arrayBuffer;
    size_t byteOffset;
    // 定义枚举类型与ArkTS侧枚举类型InfoType顺序含义一致
    enum InfoType { BYTE_LENGTH = 0, ARRAY_BUFFER, BYTE_OFFSET };
    // 获取dataview信息
    napi_get_dataview_info(env, args[0], &byteLength, &data, &arrayBuffer, &byteOffset);
    napi_value result;
    switch (infoType) {
        case BYTE_LENGTH:
            // 返回查询DataView的字节数
            napi_value napiByteLength;
            napi_create_int32(env, byteLength, &napiByteLength);
            result = napiByteLength;
            break;
        case ARRAY_BUFFER:
            // 返回查询DataView的arraybuffer
            result = arrayBuffer;
            break;
        case BYTE_OFFSET:
            // 返回查询DataView的偏移字节量
            napi_value napiByteOffset;
            napi_create_int32(env, byteOffset, &napiByteOffset);
            result = napiByteOffset;
            break;
        default:
            break;
    }
    return result;
}
// [End napi_get_data_view_info]

// [Start change_use_napi_process]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_value typedArrayTypes;
    napi_create_object(env, &typedArrayTypes);
    napi_value typeIndex;
    std::string typeKeys[] = {
        "INT8_ARRAY",   "UINT8_ARRAY",   "UINT8_CLAMPED_ARRAY", "INT16_ARRAY",    "UINT16_ARRAY",    "INT32_ARRAY",
        "UINT32_ARRAY", "FLOAT32_ARRAY", "FLOAT64_ARRAY",       "BIGINT64_ARRAY", "BIGUINT64_ARRAY",
    };
    for (int32_t i = 0; i < sizeof(typeKeys) / sizeof(typeKeys[0]); i++) {
        napi_create_int32(env, i, &typeIndex);
        napi_set_named_property(env, typedArrayTypes, typeKeys[i].c_str(), typeIndex);
    }
    napi_property_descriptor desc[] = {
        {"createArray", nullptr, CreateArray, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createArrayWithLength", nullptr, CreateArrayWithLength, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getArrayLength", nullptr, GetArrayLength, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isArray", nullptr, IsArray, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiSetElement", nullptr, NapiSetElement, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiGetElement", nullptr, NapiGetElement, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiHasElement", nullptr, NapiHasElement, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiDeleteElement", nullptr, NapiDeleteElement, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createTypedArray", nullptr, CreateTypedArray, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"TypedArrayTypes", nullptr, nullptr, nullptr, nullptr, typedArrayTypes, napi_default, nullptr},
        {"isTypedarray", nullptr, IsTypedarray, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getTypedarrayInfo", nullptr, GetTypedarrayInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createDataView", nullptr, CreateDataView, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isDataView", nullptr, IsDataView, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getDataViewInfo", nullptr, GetDataViewInfo, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END
// [End change_use_napi_process]

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
