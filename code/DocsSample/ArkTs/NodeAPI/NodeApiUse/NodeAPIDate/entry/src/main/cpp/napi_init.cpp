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
#include "napi/native_api.h"

// napi_create_date
static napi_value CreateDate(napi_env env, napi_callback_info info)
{
    // 获取传入的Unix Time Stamp时间
    double value = 1501924876711;
    // 调用napi_create_date接口将double值转换成表示日期时间，并创建成一个ArkTS对象放入returnValue中
    napi_value returnValue = nullptr;
    napi_create_date(env, value, &returnValue);
    return returnValue;
}

// napi_get_date_value
static napi_value GetDateValue(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 获取传入的Unix Time Stamp时间
    double value = 0;
    napi_status status = napi_get_date_value(env, args[0], &value);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "napi_get_date_value fail");
        return nullptr;
    }

    // 将获取到的Unix Time Stamp时间打印
    OH_LOG_INFO(LOG_APP, "Node-API gets unix time stamp is:%{public}lf.", value);

    // 把转换后的Unix Time Stamp时间创建成ArkTS double数值，并放入returnValue中
    napi_value returnValue = nullptr;
    napi_create_double(env, value, &returnValue);
    return returnValue;
}

// napi_is_date
static napi_value IsDate(napi_env env, napi_callback_info info)
{
    // 接受一个入参
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 调用napi_is_date接口判断给定入参是否为Date数据
    bool result = false;
    napi_status status = napi_is_date(env, args[0], &result);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Node-API napi_is_date fail");
        return nullptr;
    }
    // 将结果转成napi_value类型返回
    napi_value returnValue = nullptr;
    napi_get_boolean(env, result, &returnValue);

    return returnValue;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"createDate", nullptr, CreateDate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getDateValue", nullptr, GetDateValue, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"isDate", nullptr, IsDate, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
