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

#ifndef IMAGE_EDIT_H
#define IMAGE_EDIT_H

#include "napi/native_api.h"
#include <multimedia/image_effect/image_effect.h>

class ImageEdit {
public:
    ~ImageEdit();
    
    static napi_value PixelMapFilterStart(napi_env env, napi_callback_info info);
    
    static napi_value NativeBufferFilterStart(napi_env env, napi_callback_info info);
    
    static napi_value URIFilterStart(napi_env env, napi_callback_info info);
    
    static napi_value SurfaceFilterStart(napi_env env, napi_callback_info info);
    
    static napi_value SurfaceFilterStop(napi_env env, napi_callback_info info);
    
    static napi_value LookupFilterInfo(napi_env env, napi_callback_info info);
    
    static napi_value LookupFilters(napi_env env, napi_callback_info info);
    
    static napi_value RegisterCustomBrightness();
    
    static napi_value RegisterCustomCrop();
    
    static napi_value getSurfaceId(napi_env env, napi_callback_info info);
    
private:
    static OH_ImageEffect *imageEffect_;
};

#endif //IMAGE_EDIT_H