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

#include "utils.h"
#include <fstream>
#include <algorithm>

std::vector<std::vector<float>> TransposeMel(const std::vector<std::vector<float>>& mels) {
    if (mels.empty()) return {};
    
    size_t rows = mels.size();
    size_t cols = mels[0].size();
    
    std::vector<std::vector<float>> result(cols, std::vector<float>(rows));
    
    for (size_t i = 0; i < rows; ++i) {
        for (size_t j = 0; j < cols; ++j) {
            result[j][i] = mels[i][j];
        }
    }
    return result;
}

std::vector<float> ResampleAudio(
    const std::vector<float>& input_data,
    int input_sample_rate,
    int output_sample_rate,
    int channel,
    int converter
) {
    if (input_data.empty() || input_sample_rate <= 0 || output_sample_rate <= 0) {
        throw std::invalid_argument("Invalid input parameters");
    }

    double ratio = static_cast<double>(output_sample_rate) / input_sample_rate;
    
    size_t output_size = static_cast<size_t>(input_data.size() * ratio + 0.5);
    std::vector<float> output_data(output_size);

    SRC_DATA src_data;
    src_data.data_in = input_data.data();
    src_data.input_frames = input_data.size();
    src_data.data_out = output_data.data();
    src_data.output_frames = output_size;
    src_data.src_ratio = ratio;
    src_data.end_of_input = 1;

    int error = src_simple(&src_data, converter, 1);
    if (error) {
        std::cout << "error src_simple filed " << std::endl;
    }
    
    return output_data;
}

void ProcessMelSpectrogram(std::vector<std::vector<float>>& mels) {
    // log_spec = np.log10(np.maximum(mel, 1e-10))
    for (auto& row : mels) {
        for (auto& val : row) {
            val = std::log10(std::max(val, 1e-10f));
        }
    }
    // log_spec = np.maximum(log_spec, log_spec.max() - 8.0)    
    float max_val = -std::numeric_limits<float>::infinity();
    for (const auto& row : mels) {
        for (const auto& val : row) {
            if (val > max_val){
                max_val = val;
            }
        }
    }
    std::vector<std::vector<float>>& log_spec = mels;
    const float threshold = max_val - 8.0f;
    for (auto& row : mels) {
        for (auto& val : row) {
            val = (std::max(val, threshold) + 4.0f) /4.0f;
        }
    }

    size_t target = 3000;
    int current_cols = mels[0].size();
    if (current_cols > target) {
        for (auto& row : mels) {
            row.resize(target);
        }
        for (auto& row : mels) {
            int start_zero = std::max(0, static_cast<int>(row.size()) - 50);
            std::fill(row.begin() + start_zero, row.end(), 0.0f);
        }
    } else if (current_cols < target) {
        int padding = target - current_cols;
        for (auto& row : mels) {
            row.insert(row.end(), padding, 0.0f);
        }
    }
}
