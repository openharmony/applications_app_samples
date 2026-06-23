/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

#ifndef LPP_SAMPLE_PLAYER_NATIVE_H
#define LPP_SAMPLE_PLAYER_NATIVE_H

#include <js_native_api.h>
#include <js_native_api_types.h>
#include <memory>
#include <uv.h>
#include "napi/native_api.h"
#include "Player.h"
#include "dfx/error/av_codec_sample_error.h"
#include "av_codec_sample_log.h"
#include "plugin_manager.h"

class PlayerNative {
public:
    static napi_value Play(napi_env env, napi_callback_info info);
    static napi_value Stop(napi_env env, napi_callback_info info);
    static napi_value Release(napi_env env, napi_callback_info info);
    static napi_value Reset(napi_env env, napi_callback_info info);
    static napi_value Pause(napi_env env, napi_callback_info info);
    static napi_value Resume(napi_env env, napi_callback_info info);
    static napi_value Speed(napi_env env, napi_callback_info info);
    static napi_value SetSurface(napi_env env, napi_callback_info info);
    static napi_value Seek(napi_env env, napi_callback_info info);
    static napi_value SetVolume(napi_env env, napi_callback_info info);
    static napi_value Prepare(napi_env env, napi_callback_info info);
    static napi_value StartDecoder(napi_env env, napi_callback_info info);
    static napi_value RenderFirstFrame(napi_env env, napi_callback_info info);
    static napi_value StartRender(napi_env env, napi_callback_info info);
    static napi_value StartAudio(napi_env env, napi_callback_info info);
    static napi_value GetDurationTime(napi_env env, napi_callback_info info);
    static napi_value GetProgressTime(napi_env env, napi_callback_info info);
};
#endif // LPP_SAMPLE_PLAYER_NATIVE_H