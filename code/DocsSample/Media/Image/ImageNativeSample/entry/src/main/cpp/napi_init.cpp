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
#include "napi/native_api.h"
#include "loadReceiver.h"
#include <imageKits.h>
#include <multimedia/image_framework/image/image_common.h>
#include <multimedia/image_framework/image/image_packer_native.h>
#include <multimedia/image_framework/image/image_source_native.h>
// [Start get_returnValue]
// 处理napi返回值。
napi_value GetJsResult(napi_env env, int result)
{
    napi_value resultNapi = nullptr;
    napi_create_int32(env, result, &resultNapi);
    return resultNapi;
}
// [End get_returnValue]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "createImageSource", nullptr, CreateImageSource, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getImageInfo", nullptr, GetImageInfo, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getImageProperty", nullptr, GetImageProperty, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "modifyImageProperty", nullptr, ModifyImageProperty, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "createPixelMap", nullptr, CreatePixelMap, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getFrameCount", nullptr, GetFrameCount, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "createPixelmapList", nullptr, CreatePixelmapList, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getDelayTimeList", nullptr, GetDelayTimeList, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "releaseImageSource", nullptr, ReleaseImageSource, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setDesiredAuxiliaryPictures", nullptr, SetDesiredAuxiliaryPictures,
          nullptr, nullptr, nullptr, napi_default, nullptr },
        { "createPictureByImageSource", nullptr, CreatePictureByImageSource,
          nullptr, nullptr, nullptr, napi_default, nullptr },
        { "releasePictureSource", nullptr, ReleasePictureSource, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "testStrideWithAllocatorType", nullptr, TestStrideWithAllocatorType,
          nullptr, nullptr, nullptr, napi_default, nullptr },
        { "packToFileFromImageSourceTestJs", nullptr, PackToFileFromImageSourceTestJs,
          nullptr, nullptr, nullptr, napi_default, nullptr },
        { "packToFileFromPixelmapTestJs", nullptr, PackToFileFromPixelmapTestJs,
          nullptr, nullptr, nullptr, napi_default, nullptr },
        { "packToDataFromPicture", nullptr, PackToDataFromPicture,
          nullptr, nullptr, nullptr, napi_default, nullptr },
        { "packToFileFromPicture", nullptr, PackToFileFromPicture,
          nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    InitReceiverDemo(env, exports);
    return exports;
}
EXTERN_C_END

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
