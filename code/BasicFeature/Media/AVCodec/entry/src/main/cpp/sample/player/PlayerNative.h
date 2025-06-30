/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef VIDEO_CODEC_SAMPLE_PLAYER_NATIVE_H
#define VIDEO_CODEC_SAMPLE_PLAYER_NATIVE_H

#include "Player.h"
#include "av_codec_sample_log.h"
#include "dfx/error/av_codec_sample_error.h"
#include "napi/native_api.h"
#include "plugin_manager.h"
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <memory>
#include <uv.h>

class PlayerNative {
public:
    static napi_value Play(napi_env env, napi_callback_info info);
    static napi_value SetPlaybackSpeed(napi_env env, napi_callback_info info);
};
#endif // VIDEO_CODEC_SAMPLE_PLAYER_NATIVE_H