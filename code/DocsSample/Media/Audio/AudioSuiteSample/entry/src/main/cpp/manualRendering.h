/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. 2026-2026. ALL rights reserved.
 */

#ifndef MANUAL_RENDERING_H
#define MANUAL_RENDERING_H

#include "pcmFileUtils.h"

void BaseEditorEffect(AudioDataInfo *audioInfo, const char *newFilePath);
void AudioSourceSeparation(AudioDataInfo *audioInfo, const char *vocalsFilePath, const char *accompanimentFilePath);
void MixingAndCascading(AudioDataInfo *audioInfoForField, AudioDataInfo *audioInfoForMix, const char *mixFilePath);

#endif