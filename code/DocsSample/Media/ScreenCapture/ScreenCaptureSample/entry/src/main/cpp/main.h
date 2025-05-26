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

#ifndef AVSCREENCAPTURENDKDEMO_MAIN_H
#define AVSCREENCAPTURENDKDEMO_MAIN_H
#endif // AVSCREENCAPTURENDKDEMO_MAIN_H

#include "napi/native_api.h"
#include <unistd.h>
#include <fcntl.h>
#include <multimedia/player_framework/native_avscreen_capture.h>
#include <multimedia/player_framework/native_avscreen_capture_base.h>
#include <multimedia/player_framework/native_avbuffer.h>
#include <multimedia/player_framework/native_avscreen_capture_errors.h>
#include "hilog/log.h"
#include <string>
#include "multimedia/player_framework/native_avcodec_videodecoder.h"
#include "multimedia/player_framework/native_avcodec_videoencoder.h"
#include <native_buffer/native_buffer.h>
#include "native_window/external_window.h"
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <multimedia/player_framework/native_avcapability.h>
#include <multimedia/player_framework/native_avcodec_base.h>
#include <multimedia/player_framework/native_avformat.h>
#include <multimedia/player_framework/native_avbuffer.h>
#include <iostream>
#include <stdio.h>
#include <unistd.h>
#include <atomic>
#include <fstream>
#include <thread>
#include <mutex>
#include <queue>
#include <unordered_map>
#include "sample_callback.h"
#include "muxer.h"

static struct OH_AVScreenCapture *g_avCapture = {};
static FILE *micFile_ = nullptr;
static FILE *vFile_ = nullptr;
static FILE *innerFile_ = nullptr;
std::unique_ptr<Muxer> g_muxer;

static char filename[100] = {0};
bool m_isRunning = false;
bool m_scSaveFileIsRunning = false;
bool m_scSurfaceIsRunning = false;
OH_AVCodec *g_videoEnc;
CodecUserData *g_encContext = nullptr;
SampleInfo sampleInfo_;
std::unique_ptr<std::thread> inputVideoThread_;
std::atomic<bool> isStarted_{false};

constexpr uint32_t DEFAULT_WIDTH = 4096;
// 配置视频帧高度（必须）
constexpr uint32_t DEFAULT_HEIGHT = 4096;
// 配置视频颜色格式（必须）
constexpr OH_AVPixelFormat DEFAULT_PIXELFORMAT = AV_PIXEL_FORMAT_NV12;