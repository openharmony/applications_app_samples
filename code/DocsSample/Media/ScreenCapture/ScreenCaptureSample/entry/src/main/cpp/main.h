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

// [Start screenCapture_import]
#include "hilog/log.h"
#include "napi/native_api.h"
#include <window_manager/oh_display_info.h>
#include <window_manager/oh_display_manager.h>
#include <AbilityKit/ability_runtime/application_context.h>
#include <multimedia/player_framework/native_avscreen_capture.h>
#include <multimedia/player_framework/native_avscreen_capture_base.h>
#include <multimedia/player_framework/native_avscreen_capture_errors.h>
#include <unistd.h>
#include <fcntl.h>
#include <string>
// [End screenCapture_import]
// [Start screenCapture_import_buffer]
#include "hilog/log.h"
#include "napi/native_api.h"
#include <window_manager/oh_display_info.h>
#include <window_manager/oh_display_manager.h>
#include <multimedia/player_framework/native_avscreen_capture.h>
#include <multimedia/player_framework/native_avscreen_capture_base.h>
#include <multimedia/player_framework/native_avscreen_capture_errors.h>
#include <multimedia/player_framework/native_avbuffer.h>
#include <native_buffer/native_buffer.h>
#include <vector>
// [End screenCapture_import_buffer]

#include "multimedia/player_framework/native_avcodec_videodecoder.h"
#include "multimedia/player_framework/native_avcodec_videoencoder.h"
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

extern struct OH_AVScreenCapture *g_avCapture;
extern FILE *g_micFile;
extern FILE *g_vFile;
extern FILE *g_innerFile;
std::unique_ptr<Muxer> g_muxer;
int32_t g_surfaceOutputFd = -1;
int32_t g_fileOutputFd = -1;
int32_t g_windowOutputFd = -1;
int32_t g_windowId = -1;
std::vector<int32_t> g_missionIds;
std::vector<int32_t> g_missionIds2;

extern char filename[100];
bool g_isRunning = false;
bool m_scSaveFileIsRunning = false;
bool m_scSurfaceIsRunning = false;
OH_AVCodec *g_videoEnc;
CodecUserData *g_encContext = nullptr;
SampleInfo sampleInfo_;
std::unique_ptr<std::thread> inputVideoThread_;
std::atomic<bool> isStarted_{false};

constexpr uint32_t DEFAULT_WIDTH = 4096;
constexpr uint32_t DEFAULT_HEIGHT = 4096;
constexpr uint32_t PC_VIDEO_WIDTH = 2880;
constexpr uint32_t PC_VIDEO_HEIGHT = 1920;
constexpr uint32_t CANVAS_RESIZE_WIDTH = 768;
constexpr uint32_t CANVAS_RESIZE_HEIGHT = 1280;
// 配置视频颜色格式（必须）
constexpr OH_AVPixelFormat DEFAULT_PIXELFORMAT = AV_PIXEL_FORMAT_NV12;

// 录屏取码流surface模式
const int MICROSECOND_PER_MILLISECOND = 1000;

int64_t g_lastFrameTimestampPts = 0;
int64_t g_lastFrameEncodePts = 0;

constexpr int32_t FILE_PERMISSION_FULL_ACCESS = 0777;
constexpr int32_t PRIVACY_MASK_MODE_FULL_SCREEN = 0;
constexpr int32_t PRIVACY_MASK_MODE_WINDOW = 1;
constexpr int32_t CAPTURE_REGION_SIZE = 100;
constexpr int32_t CAPTURE_VIDEO_FRAME_RATE = 30;