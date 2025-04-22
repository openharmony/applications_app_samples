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

#include <vector>
#include <iostream>
#include "AudioFile.h"
#include "samplerate.h"

std::vector<std::vector<float>> transpose_mel(const std::vector<std::vector<float>>& mels);
std::vector<float> resample_audio(
    const std::vector<float>& input_data,
    int input_sample_rate,
    int output_sample_rate,
    int channels,
    int converter
);
void processMelSpectrogram(std::vector<std::vector<float>>& mels);


