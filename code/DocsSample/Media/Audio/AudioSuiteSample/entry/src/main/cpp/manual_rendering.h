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

#ifndef MANUAL_RENDERING_H
#define MANUAL_RENDERING_H

#include "pcm_file_utils.h"
#include <cstdint>

const int AUDIO_EQ_BAND_NUM = 10;

enum AudioEffectType { AUDIO_EFFECT_TYPE_EQUALIZER = 0, AUDIO_EFFECT_TYPE_VOICE_BEAUTIFIER = 1 };

enum EqualizerPresetType {
    EQ_PRESET_CUSTOM = -1,
    EQ_PRESET_DEFAULT = 0,
    EQ_PRESET_BALLADS = 1,
    EQ_PRESET_CHINESE_STYLE = 2,
    EQ_PRESET_CLASSICAL = 3,
    EQ_PRESET_DANCE_MUSIC = 4,
    EQ_PRESET_JAZZ = 5,
    EQ_PRESET_POP = 6,
    EQ_PRESET_RB = 7,
    EQ_PRESET_ROCK = 8
};

struct EffectParams {
    int effectType;
    int eqPresetIndex;
    int32_t eqGains[AUDIO_EQ_BAND_NUM];
    int voiceBeautifierType;
};

void BaseEditorEffect(AudioDataInfo *audioInfo, const char *newFilePath, int effectType, const EffectParams &params);
void AudioSourceSeparation(AudioDataInfo *audioInfo, const char *vocalsFilePath, const char *accompanimentFilePath);
void MixingAndCascading(AudioDataInfo *audioInfoForField, AudioDataInfo *audioInfoForMix, const char *mixFilePath);

#endif