/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

#include "napi/native_api.h"
#include "libimage/source.cpp"
#include "libimage/pixelmap.cpp"
#include "libimage/packer.cpp"
EXTERN_C_START

static napi_value PixelmapTestJs(napi_env env, napi_callback_info info)
{
    Image_ErrorCode ec = PixelmapTest();
    if (ec == IMAGE_SUCCESS) {
        OH_LOG_INFO(LOG_APP, "ImagePixelmapNativeCTest PixelmapTestJs successful.");
    }
    return getJsResult(env, ec);
}

static napi_value PackToFileFromImageSourceTestJs(napi_env env, napi_callback_info info)
{
    napi_value argv[1] = {0};
    size_t argc = 1;
    if (napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "PackToFileFromImageSourceTestJs napi_get_cb_info failed.");
        return nullptr;
    }
    int fd;
    napi_get_value_int32(env, argv[0], &fd);
    Image_ErrorCode ec = packToFileFromImageSourceTest(fd);
    if (ec == IMAGE_SUCCESS) {
        OH_LOG_INFO(LOG_APP, "ImagePackerNativeCTest PackToFileFromImageSourceTestJs successful.");
    }
    return getJsResult(env, ec);
}

static napi_value PackToFileFromPixelmapTestJs(napi_env env, napi_callback_info info)
{
    napi_value argv[1] = {0};
    size_t argc = 1;
    if (napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "PackToFileFromImageSourceTestJs napi_get_cb_info failed.");
        return nullptr;
    }
    int fd;
    napi_get_value_int32(env, argv[0], &fd);
    uint8_t data[96];
    size_t dataSize = 96;
    for (int i = 0; i < dataSize; i++) {
        data[i] = i + 1;
    }
    Image_ErrorCode ec = packToFileFromPixelmapTest(data, dataSize, fd);
    if (ec == IMAGE_SUCCESS) {
        OH_LOG_INFO(LOG_APP, "ImagePackerNativeCTest PackToFileFromPixelmapTestJs successful.");
    }
    return getJsResult(env, ec);
}

static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"sourceTest", nullptr, sourceTest, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pixelmapTestJs", nullptr, PixelmapTestJs, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"packToFileFromImageSourceTestJs", nullptr, PackToFileFromImageSourceTestJs, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"packToFileFromPixelmapTestJs", nullptr, PackToFileFromPixelmapTestJs, nullptr, nullptr, nullptr, napi_default,
         nullptr}};
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
