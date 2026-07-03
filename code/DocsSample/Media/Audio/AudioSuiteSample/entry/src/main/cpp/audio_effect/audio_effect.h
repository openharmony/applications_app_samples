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

#ifndef AUDIO_EFFECT_H
#define AUDIO_EFFECT_H

#include <memory>
#include <ohaudiosuite/native_audio_suite_base.h>
#include <ohaudiosuite/native_audio_suite_engine.h>
#include "../manual_rendering.h"

class AudioEffectStrategy {
public:
    virtual ~AudioEffectStrategy() = default;
    virtual OH_AudioNode_Type GetNodeType() const = 0;
    virtual void CreateAndApply(OH_AudioSuitePipeline* pipeline, OH_AudioNodeBuilder* builder,
                                 OH_AudioNode** node, const EffectParams& params) = 0;
};

class EqualizerStrategy : public AudioEffectStrategy {
public:
    OH_AudioNode_Type GetNodeType() const override {
        return OH_AudioNode_Type::EFFECT_NODE_TYPE_EQUALIZER;
    }
    
    // [Start audioSuite_GetEqualizerGains]
    // 根据预置类型或自定义参数获取均衡器增益值。
    static OH_EqualizerFrequencyBandGains GetEqualizerGains(const EffectParams& params) {
        OH_EqualizerFrequencyBandGains gains;
        switch (params.eqPresetIndex) {
            case EQ_PRESET_DEFAULT:
                gains = OH_EQUALIZER_PARAM_DEFAULT;
                break;
            case EQ_PRESET_BALLADS:
                gains = OH_EQUALIZER_PARAM_BALLADS;
                break;
            case EQ_PRESET_CHINESE_STYLE:
                gains = OH_EQUALIZER_PARAM_CHINESE_STYLE;
                break;
            case EQ_PRESET_CLASSICAL:
                gains = OH_EQUALIZER_PARAM_CLASSICAL;
                break;
            case EQ_PRESET_DANCE_MUSIC:
                gains = OH_EQUALIZER_PARAM_DANCE_MUSIC;
                break;
            case EQ_PRESET_JAZZ:
                gains = OH_EQUALIZER_PARAM_JAZZ;
                break;
            case EQ_PRESET_POP:
                gains = OH_EQUALIZER_PARAM_POP;
                break;
            case EQ_PRESET_RB:
                gains = OH_EQUALIZER_PARAM_RB;
                break;
            case EQ_PRESET_ROCK:
                gains = OH_EQUALIZER_PARAM_ROCK;
                break;
            case EQ_PRESET_CUSTOM:
            default:
                for (int i = 0; i < AUDIO_EQ_BAND_NUM; i++) {
                    gains.gains[i] = params.eqGains[i];
                }
                break;
        }
        return gains;
    }
    // [End audioSuite_GetEqualizerGains]
    
    void CreateAndApply(OH_AudioSuitePipeline* pipeline, OH_AudioNodeBuilder* builder,
                        OH_AudioNode** node, const EffectParams& params) override {
        OH_AudioSuiteNodeBuilder_SetNodeType(builder, OH_AudioNode_Type::EFFECT_NODE_TYPE_EQUALIZER);
        OH_AudioSuiteEngine_CreateNode(pipeline, builder, node);
        OH_EqualizerFrequencyBandGains gains = GetEqualizerGains(params);
        OH_AudioSuiteEngine_SetEqualizerFrequencyBandGains(*node, gains);
    }
};

class VoiceBeautifierStrategy : public AudioEffectStrategy {
public:
    OH_AudioNode_Type GetNodeType() const override {
        return OH_AudioNode_Type::EFFECT_NODE_TYPE_VOICE_BEAUTIFIER;
    }
    
    void CreateAndApply(OH_AudioSuitePipeline* pipeline, OH_AudioNodeBuilder* builder,
                        OH_AudioNode** node, const EffectParams& params) override {
        OH_AudioSuiteNodeBuilder_SetNodeType(builder, OH_AudioNode_Type::EFFECT_NODE_TYPE_VOICE_BEAUTIFIER);
        OH_AudioSuiteEngine_CreateNode(pipeline, builder, node);
        OH_AudioSuiteEngine_SetVoiceBeautifierType(*node, static_cast<OH_VoiceBeautifierType>(params.voiceBeautifierType));
    }
};

inline std::unique_ptr<AudioEffectStrategy> CreateEffectStrategy(int effectType) {
    switch (effectType) {
        case AUDIO_EFFECT_TYPE_EQUALIZER:
            return std::make_unique<EqualizerStrategy>();
        case AUDIO_EFFECT_TYPE_VOICE_BEAUTIFIER:
            return std::make_unique<VoiceBeautifierStrategy>();
        default:
            return nullptr;
    }
}

#endif