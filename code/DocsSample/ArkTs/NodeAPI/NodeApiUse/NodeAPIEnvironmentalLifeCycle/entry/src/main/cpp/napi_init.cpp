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

// [Start napi_set_instance_data]
#include <cstdlib>
#include "napi/native_api.h"

// 定义一个结构来存储实例数据
struct InstanceData {
    int32_t value;
};

// 对象被释放时的回调函数，用于清理实例数据
void FinalizeCallback(napi_env env, void *finalizeData, void *finalizeHint)
{
    if (finalizeData) {
        InstanceData *data = reinterpret_cast<InstanceData *>(finalizeData);
        // 释放内存，清除指针指向地址
        delete (data);
        *(InstanceData **)finalizeData = nullptr;
    }
}

// napi_set_instance_data
static napi_value SetInstanceData(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    int32_t instanceDataValue;
    napi_get_value_int32(env, argv[0], &instanceDataValue);
    InstanceData *instanceData = new InstanceData;
    instanceData->value = instanceDataValue;
    // 调用napi_set_instance_data将实例数据关联到Node-API环境，并指定FinalizeCallback函数
    napi_status status = napi_set_instance_data(env, instanceData, FinalizeCallback, nullptr);
    bool success = true;
    napi_value result;
    if (status == napi_ok) {
        napi_get_boolean(env, success, &result);
    }
    return result;
}
// [End napi_set_instance_data]

// [Start napi_get_instance_data]
// napi_get_instance_data
static napi_value GetInstanceData(napi_env env, napi_callback_info info)
{
    InstanceData *resData = nullptr;
    // napi_get_instance_data获取之前想关联的数据项
    napi_get_instance_data(env, (void **)&resData);
    napi_value result;
    napi_create_int32(env, resData->value, &result);
    return result;
}
// [End napi_get_instance_data]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"setInstanceData", nullptr, SetInstanceData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getInstanceData", nullptr, GetInstanceData, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
