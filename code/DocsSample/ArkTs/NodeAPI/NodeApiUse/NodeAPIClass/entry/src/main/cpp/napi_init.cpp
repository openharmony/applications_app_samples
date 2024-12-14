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

#include <hilog/log.h>
#include <string>
#include "napi/native_api.h"

static constexpr int INT_ARG_18 = 18; // 入参索引

// napi_new_instance
static napi_value NewInstance(napi_env env, napi_callback_info info)
{
    // 传入并解析参数，第一个参数为传入的构造函数，第二个参数为需要传入构造函数的参数
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 调用napi_new_instance接口，实例化一个对象，将这个对象返回
    napi_value result = nullptr;
    napi_new_instance(env, args[0], 1, &args[1], &result);
    return result;
}

struct Object {
    std::string name;
    int32_t age;
};

static void DerefItem(napi_env env, void *data, void *hint)
{
    // 可选的原生回调，用于在ArkTS对象被垃圾回收时释放原生实例
    OH_LOG_INFO(LOG_APP, "Node-API DerefItem");
    (void)hint;
}

// napi_wrap
static napi_value Wrap(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "Node-API wrap");
    // 初始化Node-API模块的object
    struct Object *obj = new struct Object();
    obj->name = "lilei";
    obj->age = INT_ARG_18;
    size_t argc = 1;
    napi_value toWrap;
    // 调用napi_wrap将Node-API模块的object绑定到ArkTS object上
    napi_get_cb_info(env, info, &argc, &toWrap, NULL, NULL);
    napi_wrap(env, toWrap, reinterpret_cast<void *>(obj), DerefItem, NULL, NULL);

    return toWrap;
}

// napi_remove_wrap
static napi_value RemoveWrap(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "Node-API removeWrap");
    size_t argc = 1;
    napi_value wrapped = nullptr;
    void *data = nullptr;
    // 调用napi_remove_wrap从一个被包装的对象中解除包装
    napi_get_cb_info(env, info, &argc, &wrapped, nullptr, nullptr);
    napi_remove_wrap(env, wrapped, &data);

    return nullptr;
}

// napi_unwrap
static napi_value UnWrap(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "Node-API unWrap");
    size_t argc = 1;
    napi_value wrapped = nullptr;
    napi_get_cb_info(env, info, &argc, &wrapped, nullptr, nullptr);
    // 调用napi_unwrap取出绑定在ArkTS object中的数据并打印
    struct Object *data;
    napi_unwrap(env, wrapped, reinterpret_cast<void **>(&data));
    OH_LOG_INFO(LOG_APP, "Node-API name: %{public}s", data->name.c_str());
    OH_LOG_INFO(LOG_APP, "Node-API age: %{public}d", data->age);
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"newInstance", nullptr, NewInstance, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"wrap", nullptr, Wrap, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"removeWrap", nullptr, RemoveWrap, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"unWrap", nullptr, UnWrap, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
