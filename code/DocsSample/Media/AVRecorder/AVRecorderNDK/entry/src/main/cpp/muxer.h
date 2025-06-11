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

#ifndef MUXER_H
#define MUXER_H

#define LOG_DOMAIN 0x3200
#define LOG_TAG "MY_NDKDEMO"
#include <bits/alltypes.h>
#include "sample_info.h"
#include "multimedia/player_framework/native_avmuxer.h"

class Muxer {
public:
    Muxer() = default;
    ~Muxer();

    int32_t Create(int32_t fd);
    int32_t Config(SampleInfo &sampleInfo);
    int32_t Start();
    int32_t WriteSample(OH_AVBuffer *buffer, OH_AVCodecBufferAttr &attr);
    int32_t WriteAudioData(OH_AVBuffer *buffer, OH_AVCodecBufferAttr &attr);

    int32_t Stop();
    int32_t Release();

private:
    OH_AVMuxer *muxer_ = nullptr;
    int32_t videoTrackId_ = -1;
    int32_t audioTrackId_ = -1;
    int32_t coverTrackId_ = -1;
};

#endif // MUXER_H