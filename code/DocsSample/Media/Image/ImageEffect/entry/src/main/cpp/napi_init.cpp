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
#include "image_edit.h"

EXTERN_C_START
void RegisterCustomBrightness() { ImageEdit::RegisterCustomBrightness(); }
void RegisterCustomCrop() { ImageEdit::RegisterCustomCrop(); }

static napi_value Init(napi_env env, napi_value exports)
{
    RegisterCustomBrightness();
    RegisterCustomCrop();

    napi_property_descriptor desc[] = {
        {"PixelMapFilterStart", nullptr, ImageEdit::PixelMapFilterStart, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"NativeBufferFilterStart", nullptr, ImageEdit::NativeBufferFilterStart, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"URIFilterStart", nullptr, ImageEdit::URIFilterStart, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"SurfaceFilterStart", nullptr, ImageEdit::SurfaceFilterStart, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"SurfaceFilterStop", nullptr, ImageEdit::SurfaceFilterStop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"lookupFilterInfo", nullptr, ImageEdit::LookupFilterInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"lookupFilters", nullptr, ImageEdit::LookupFilters, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSurfaceId", nullptr, ImageEdit::getSurfaceId, nullptr, nullptr, nullptr, napi_default, nullptr},
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