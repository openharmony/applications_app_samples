/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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

#ifndef REALTIME_RENDERING_H
#define REALTIME_RENDERING_H
#include "pcm_file_utils.h"
#include <ohaudiosuite/native_audio_suite_engine.h>
// 全局引擎变量（定义在 realTimeRendering.cpp）。
extern OH_AudioSuiteEngine *audioSuiteEngine;
void EqualizerEffect(AudioDataInfo *audioInfo);
void DestroyEqualizerEffect();
#endif