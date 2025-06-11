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

#ifndef AVRECORDER_MAIN_H
#define AVRECORDER_MAIN_H

#include "napi/native_api.h"
#include "hilog/log.h"
#include "mutex"
#include "muxer.h"
#include "ohcamera/camera.h"
#include "ohcamera/camera_input.h"
#include "ohcamera/capture_session.h"
#include "ohcamera/photo_output.h"
#include "ohcamera/preview_output.h"
#include "ohcamera/video_output.h"
#include "ohcamera/camera_manager.h"
#include "native_window/external_window.h"
#include "video_encoder_sample.h"
#include <multimedia/player_framework/avrecorder.h>
#include <multimedia/player_framework/avrecorder_base.h>
#include <multimedia/player_framework/native_averrors.h>
#include <multimedia/player_framework/native_avformat.h>
#include <multimedia/player_framework/native_avcodec_base.h>
#include "multimedia/player_framework/native_avcodec_videoencoder.h"
#include "multimedia/media_library/media_asset_change_request_capi.h"
#include "multimedia/media_library/media_access_helper_capi.h"
#include "multimedia/media_library/media_asset_capi.h"

OH_AVRecorder* InitRecorder();
void StartRecording(OH_AVRecorder *recorder);

extern int videoFrameWidth;
extern int videoFrameHeight;

#endif //AVRECORDER_MAIN_H