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

#include "napi/native_api.h"
#include <hilog/log.h>
#include <rawfile/raw_file_manager.h>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <mindspore/types.h>
#include <mindspore/model.h>
#include <mindspore/context.h>
#include <mindspore/status.h>
#include <mindspore/tensor.h>
#include <sstream>
#include <librosa/librosa.h>
#include <vector>
#include <numeric>
#include <algorithm>
#include "utils.h"
#include "AudioFile.h"
#include "base64.h"

#define LOGI(...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
#define LOGD(...) ((void)OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
#define LOGW(...) ((void)OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
#define LOGE(...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))

const float NEG_INF = -std::numeric_limits<float>::infinity();
const int WHISPER_SOT           = 50258;
const int WHISPER_TRANSCRIBE    = 50359;
const int WHISPER_TRANSLATE     = 50358;
const int WHISPER_NO_TIMESTAMPS = 50363;
const int WHISPER_EOT           = 50257;
const int WHISPER_BLANK         = 220;
const int WHISPER_NO_SPEECH     = 50362;
const int WHISPER_N_TEXT_CTX    = 448;
const int WHISPER_N_TEXT_STATE = 384; // for tiny
constexpr int  WHISPER_SAMPLE_RATE = 16000;
constexpr int K_NUM_PRINT_OF_OUT_DATA = 20;

using BinBuffer = std::pair<void *, size_t>;

int FillInputTensor(OH_AI_TensorHandle input, const BinBuffer &bin)
{
    if (OH_AI_TensorGetDataSize(input) != bin.second) {
        return OH_AI_STATUS_LITE_INPUT_PARAM_INVALID;
    }
    char *data = (char *)OH_AI_TensorGetMutableData(input);
    memcpy(data, (const char *)bin.first, OH_AI_TensorGetDataSize(input));
    return OH_AI_STATUS_SUCCESS;
}

BinBuffer ReadTokens(NativeResourceManager *nativeResourceManager, const std::string &modelName){
    auto rawFile = OH_ResourceManager_OpenRawFile(nativeResourceManager, modelName.c_str());
    if (rawFile == nullptr) {
        LOGE("MS_LITE_ERR: Open model file failed");
    }
    long fileSize = OH_ResourceManager_GetRawFileSize(rawFile);
    if (fileSize <= 0) {
        LOGE("MS_LITE_ERR: FileSize not correct");
    }
    void *buffer = malloc(fileSize);
    if (buffer == nullptr) {
        LOGE("MS_LITE_ERR: OH_ResourceManager_ReadRawFile failed");
    }
    int ret = OH_ResourceManager_ReadRawFile(rawFile, buffer, fileSize);
    if (ret == 0) {
        LOGE("MS_LITE_LOG: OH_ResourceManager_ReadRawFile failed");
        OH_ResourceManager_CloseRawFile(rawFile);
    }
    OH_ResourceManager_CloseRawFile(rawFile);
    BinBuffer res(buffer, fileSize);
    return res;
}

BinBuffer ReadBinFile(NativeResourceManager *nativeResourceManager, const std::string &modelName)
{
    auto rawFile = OH_ResourceManager_OpenRawFile(nativeResourceManager, modelName.c_str());
    if (rawFile == nullptr) {
        LOGE("MS_LITE_ERR: Open model file failed");
        return BinBuffer(nullptr, 0);
    }
    long fileSize = OH_ResourceManager_GetRawFileSize(rawFile);
    if (fileSize <= 0) {
        LOGE("MS_LITE_ERR: FileSize not correct");
        return BinBuffer(nullptr, 0);
    }
    void *buffer = malloc(fileSize);
    if (buffer == nullptr) {
        LOGE("MS_LITE_ERR: OH_ResourceManager_ReadRawFile failed");
        return BinBuffer(nullptr, 0);
    }
    int ret = OH_ResourceManager_ReadRawFile(rawFile, buffer, fileSize);
    if (ret == 0) {
        LOGE("MS_LITE_LOG: OH_ResourceManager_ReadRawFile failed");
        OH_ResourceManager_CloseRawFile(rawFile);
        return BinBuffer(nullptr, 0);
    }
    OH_ResourceManager_CloseRawFile(rawFile);
    return BinBuffer(buffer, fileSize);
}

void DestroyModelBuffer(void **buffer)
{
    if (buffer == nullptr) {
        return;
    }
    free(*buffer);
    *buffer = nullptr;
}

OH_AI_ModelHandle CreateMSLiteModel(BinBuffer &bin)
{
    // Set executing context for model.
    auto context = OH_AI_ContextCreate();
    if (context == nullptr) {
        DestroyModelBuffer(&bin.first);
        LOGE("MS_LITE_ERR: Create MSLite context failed.\n");
        return nullptr;
    }
    auto cpu_device_info = OH_AI_DeviceInfoCreate(OH_AI_DEVICETYPE_CPU);
    OH_AI_DeviceInfoSetEnableFP16(cpu_device_info, false);
    OH_AI_ContextAddDeviceInfo(context, cpu_device_info);

    // Create model
    auto model = OH_AI_ModelCreate();
    if (model == nullptr) {
        DestroyModelBuffer(&bin.first);
        LOGE("MS_LITE_ERR: Allocate MSLite Model failed.\n");
        return nullptr;
    }

    // Build model object
    auto build_ret = OH_AI_ModelBuild(model, bin.first, bin.second, OH_AI_MODELTYPE_MINDIR, context);
    DestroyModelBuffer(&bin.first);
    if (build_ret != OH_AI_STATUS_SUCCESS) {
        OH_AI_ModelDestroy(&model);
        LOGE("MS_LITE_ERR: Build MSLite model failed.\n");
        return nullptr;
    }
    LOGI("MS_LITE_LOG: Build MSLite model success.\n");
    return model;
}

template <class T>
void PrintBinAs(const BinBuffer &bin, const std::string& name = "Vector", const size_t n_visible = 10) {
    size_t n_elem = bin.second / sizeof(T);
    std::stringstream ss;
    const T *data = reinterpret_cast<T *>(bin.first);
    for (size_t i = 0; i < bin.second / sizeof(T) && i < n_visible; i++) {
        ss << data[i] << " ";
    }
    LOGD("MS_LITE_LOG: bin name: %{public}s, n_elem: %{public}zu, data: [%{public}s]", name.c_str(), n_elem, ss.str().c_str());
}

void save_to_binary_file(const std::vector<float>& data, const std::string& filename) {
    // 打开文件，以二进制格式写入
    std::ofstream outFile(filename, std::ios::binary);
    
    if (!outFile) {
        throw std::runtime_error("无法打开文件进行写入!");
    }

    // 写入数据到文件
    outFile.write(reinterpret_cast<const char*>(data.data()), data.size() * sizeof(float));

    // 关闭文件
    outFile.close();
    std::cout << "数据已成功保存为二进制文件: " << filename << std::endl;
}

int RunMSLiteModel(OH_AI_ModelHandle model, std::vector<BinBuffer> inputBins)
{
    // Set input data for model.
    auto inputs = OH_AI_ModelGetInputs(model);
    for(int i = 0; i < inputBins.size(); i++)
    {
        auto ret = FillInputTensor(inputs.handle_list[i], inputBins[i]);
        if (ret != OH_AI_STATUS_SUCCESS) {
            LOGE("MS_LITE_ERR: set input %{public}d error.\n", i);
            return OH_AI_STATUS_LITE_ERROR;
        }
    }

    // Get model output.
    auto outputs = OH_AI_ModelGetOutputs(model);

    // Predict model.
    auto predict_ret = OH_AI_ModelPredict(model, inputs, &outputs, nullptr, nullptr);
    if (predict_ret != OH_AI_STATUS_SUCCESS) {
        OH_AI_ModelDestroy(&model);
        LOGE("MS_LITE_ERR: MSLite Predict error.\n");
        return OH_AI_STATUS_LITE_ERROR;
    }
    LOGD("MS_LITE_LOG: Run MSLite model Predict success.\n");

    // Print output tensor data.
    LOGD("MS_LITE_LOG: Get model outputs:\n");
    for (size_t i = 0; i < outputs.handle_num; i++) {
        auto tensor = outputs.handle_list[i];
        LOGD("MS_LITE_LOG: - Tensor %{public}d name is: %{public}s.\n", static_cast<int>(i),
             OH_AI_TensorGetName(tensor));
        LOGD("MS_LITE_LOG: - Tensor %{public}d size is: %{public}d.\n", static_cast<int>(i),
             (int)OH_AI_TensorGetDataSize(tensor));
        LOGD("MS_LITE_LOG: - Tensor data is:\n");
        auto out_data = reinterpret_cast<const float *>(OH_AI_TensorGetData(tensor));
        std::stringstream outStr;
        for (int i = 0; (i < OH_AI_TensorGetElementNum(tensor)) && (i <= K_NUM_PRINT_OF_OUT_DATA); i++) {
            outStr << out_data[i] << " ";
        }
        LOGD("MS_LITE_LOG: %{public}s", outStr.str().c_str());
    }
    return OH_AI_STATUS_SUCCESS;
}

std::vector<float> convertIntVectorToFloat(const std::vector<int>& vec) {
    std::vector<float> floatVec(vec.size());

    float* floatPtr = reinterpret_cast<float*>(const_cast<int*>(vec.data()));

    for (size_t i = 0; i < vec.size(); ++i) {
        floatVec[i] = *(floatPtr + i);
    }

    return floatVec;
}

BinBuffer GetMSOutput(OH_AI_TensorHandle output) {
    float *outputData = reinterpret_cast<float *>(OH_AI_TensorGetMutableData(output));
    size_t size = OH_AI_TensorGetDataSize(output);
    return {outputData, size};
}

std::vector<float> getVecOutput(OH_AI_TensorHandle output){
    float *outputData = reinterpret_cast<float *>(OH_AI_TensorGetMutableData(output));
    size_t len = OH_AI_TensorGetElementNum(output);
    std::vector<float> res(outputData, outputData + len);
    return res;
}

void supress_tokens(BinBuffer& logits, bool is_initial) {
    auto logits_data = static_cast<float *>(logits.first);
    if (is_initial) {
        // 假设这两个值在 logits 中的索引位置
        logits_data[WHISPER_EOT] = NEG_INF;
        logits_data[WHISPER_BLANK] = NEG_INF;
    }

    // 其他令牌的抑制
    logits_data[WHISPER_NO_TIMESTAMPS] = NEG_INF;
    logits_data[WHISPER_SOT] = NEG_INF;
    logits_data[WHISPER_NO_SPEECH] = NEG_INF;
    logits_data[WHISPER_TRANSLATE] = NEG_INF;
}

template <class T>
void CompareVectorHelper(const T *data_a, const T *data_b, const std::string &label, size_t n, float rtol = 1e-3, float atol = 5e-3) {
    LOGD("MS_LITE_LOG: ==== 精度校验 ====");
    LOGD("MS_LITE_LOG: 比较 %{public}s", label.c_str());

    bool all_close = true;
    float max_diff = 0.0f;

    for (size_t i = 0; i < n; i++) {
        const float diff = std::abs(data_a[i] - data_b[i]);
        max_diff = std::max(max_diff, diff);

        // 精度容差校验
        if (diff > (atol + rtol * std::abs(data_b[i]))) {
            all_close = false;
        }
    }

    LOGD("MS_LITE_LOG: 最大差值: %{public}.6f", max_diff);
    LOGD("MS_LITE_LOG: all_close = %{public}d", all_close);

    if (!all_close) {
        LOGD("MS_LITE_LOG: --- 数据不匹配详情 ---");
        
        // 仅输出前5个差异元素
        constexpr int MAX_SHOW = 30;
        int show_count = 0;
        for (size_t i = 0; i < n && show_count < MAX_SHOW; ++i) {
            float diff = data_a[i] - data_b[i];
            if (std::abs(diff) > (atol + rtol * std::abs(data_b[i]))  && data_a[i] != 0.0f ) {
                LOGD("MS_LITE_LOG: 索引[%{public}zu]: %{public}.6f vs %{public}.6f (Δ=%{public}.6f)",
                     i, data_a[i], data_b[i], diff);
                ++show_count;
            }
        }
        LOGD("MS_LITE_LOG: === 数据不匹配，校验结束 ===");
    }
    return;
}

void CompareFloatVector(const BinBuffer &a, const BinBuffer &b, const std::string &label, float rtol = 1e-3, float atol = 5e-3) {
    // 检查数据尺寸
    assert(a.second == b.second);
    const float *data_a = (const float *)a.first;
    const float *data_b = (const float *)b.first;
    CompareVectorHelper<float>(data_a, data_b, label, b.second / sizeof(float), rtol, atol);
}

void CompareFloatVector(const std::vector<float> &fp_a, const BinBuffer &b, const std::string &label, float rtol = 1e-3, float atol = 5e-3) {
    // 检查数据尺寸
    assert(fp_a.size() * sizeof(float) == b.second);

    const float *data_a = (const float *)fp_a.data();
    const float *data_b = (const float *)b.first;

    CompareVectorHelper<float>(data_a, data_b, label, b.second / sizeof(float), rtol, atol);
}

void CompareIntVector(const BinBuffer &a, const BinBuffer &b, const std::string &label, float rtol = 1e-3, float atol = 5e-3) {
    // 检查数据尺寸
    assert(a.second == b.second);

    const int *data_a = (const int *)a.first;
    const int *data_b = (const int *)b.first;

    CompareVectorHelper<int>(data_a, data_b, label, b.second / sizeof(float), rtol, atol);
}

std::vector<int> loop_predict(const OH_AI_ModelHandle model, const BinBuffer &n_layer_cross_k, const BinBuffer &n_layer_cross_v,
            const BinBuffer &logits_init, BinBuffer &out_n_layer_self_k_cache,
            BinBuffer &out_n_layer_self_v_cache, const BinBuffer &data_embedding, const int loop, const int offset_init) {
    // logits
    BinBuffer logits{nullptr, 51865 * sizeof(float)};
    logits.first = malloc(logits.second);
    if (!logits.first) {
        LOGE("MS_LITE_LOG: Fail to malloc!\n");
    }
    void* logits_init_src = static_cast<char*>(logits_init.first) +  51865 * 3 * sizeof(float);
    memcpy(logits.first, logits_init_src, logits.second);
    supress_tokens(logits, true); 

    std::vector<int> output_token;
    float* logits_data = static_cast<float*>(logits.first);
    int max_token_id = 0;
    float max_token = logits_data[0];
    for (int i=0; i< logits.second / sizeof(float); i++) {
        if (logits_data[i] > max_token) {
            max_token_id = i;
            max_token = logits_data[i];
        }
    }

    int offset = offset_init;
    BinBuffer slice{nullptr, 0};
    slice.second = WHISPER_N_TEXT_STATE * sizeof(float);
    slice.first = malloc(slice.second);
    if (!slice.first) {
        LOGE("MS_LITE_LOG: Fail to malloc!\n");
    }

    auto out_n_layer_self_k_cache_new = out_n_layer_self_k_cache;
    auto out_n_layer_self_v_cache_new = out_n_layer_self_v_cache;

    for (size_t i = 0; i < loop; i++) {
        if (max_token_id == WHISPER_EOT) {
            break;
        }
        output_token.push_back(max_token_id);
        std::vector<float> mask(WHISPER_N_TEXT_CTX, 0.0f);
        for (size_t i = 0; i < WHISPER_N_TEXT_CTX - offset - 1; ++i) {
            mask[i] = NEG_INF;
        }
        BinBuffer tokens{&max_token_id, sizeof(int)};

        void* data_embedding_src = static_cast<char*>(data_embedding.first) + offset * WHISPER_N_TEXT_STATE * sizeof(float);
        memcpy(slice.first, data_embedding_src, slice.second);
        // out_n_layer_self_k_cache
        // out_n_layer_self_v_cache
        // n_layer_cross_k
        // n_layer_cross_v
        // slice
        // token
        BinBuffer mask_bin(mask.data(),mask.size()*sizeof(float));
        int ret = RunMSLiteModel(model, {tokens, out_n_layer_self_k_cache_new,
                                out_n_layer_self_v_cache_new, n_layer_cross_k,
                                n_layer_cross_v, slice, mask_bin});
        
        auto outputs = OH_AI_ModelGetOutputs(model);
        logits = GetMSOutput(outputs.handle_list[0]);
        out_n_layer_self_k_cache_new = GetMSOutput(outputs.handle_list[1]);
        out_n_layer_self_v_cache_new = GetMSOutput(outputs.handle_list[2]);
        offset++;
        supress_tokens(logits, false);
        logits_data = static_cast<float*>(logits.first);
        max_token = logits_data[0];

        for (int j=0; j< logits.second / sizeof(float); j++) {
            if (logits_data[j] > max_token) {
                max_token_id = j;
                max_token = logits_data[j];
            }
        }
        LOGI("MS_LITE_LOG: run decoder loop %{public}d ok!\n token = %{public}d", i, max_token_id);
    }

    return output_token;
}

std::vector<std::string> processDataLines(const BinBuffer token_txt) {
    void* data_ptr = token_txt.first;
    size_t data_size = token_txt.second;
    std::vector<std::string> tokens;
  
    const char* char_data = static_cast<const char*>(data_ptr);
    std::stringstream ss(std::string(char_data, char_data + data_size));
    std::string line;
    while (std::getline(ss, line)) {
        size_t space_pos = line.find(' ');
        tokens.push_back(line.substr(0, space_pos));
    }
    return tokens;
}

static napi_value RunDemo(napi_env env, napi_callback_info info)
{
    // run demo
    napi_value error_ret;
    napi_create_int32(env, -1, &error_ret);
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    auto resourcesManager = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);

    // preprocess
    AudioFile<float> audioFile;
    std::string filePath = "zh.wav";
    auto audioBin = ReadBinFile(resourcesManager, filePath);
    if (audioBin.first == nullptr) {
        LOGI("MS_LITE_LOG: Fail to read  %{public}s!", filePath.c_str());
    }
    size_t dataSize = audioBin.second;
    uint8_t *dataBuffer = (uint8_t *)audioBin.first;
    bool ok = audioFile.loadFromMemory(std::vector<uint8_t>(dataBuffer, dataBuffer + dataSize));
    if(!ok ){
        LOGI("MS_LITE_LOG: Fail to read  %{public}s!", filePath.c_str());
    }
    std::vector<float> data(audioFile.samples[0]);
    resample_audio(data, audioFile.getSampleRate(), WHISPER_SAMPLE_RATE, 1, SRC_SINC_BEST_QUALITY);
    std::vector<float> audio(data);

    int padding = 480000;
    int sr = 16000;
    int n_fft = 480;
    int n_hop = 160;
    int n_mel = 80;
    int fmin = 0; // Minimum frequency, default value is 0.0 Hz
    int fmax = sr / 2.0; // Maximum frequency, default value is half of the sampling rate (sr / 2.0), i.e., the Nyquist frequency.
    audio.insert(audio.end(),padding,0.0f);
    std::vector<std::vector<float>> mels_T = librosa::Feature::melspectrogram(audio, sr, n_fft, n_hop, "hann", true, "reflect", 2.f, n_mel, fmin, fmax);
    std::cout << "mels:   "<<std::endl;

    std::vector<std::vector<float>> mels = transpose_mel(mels_T);
    processMelSpectrogram(mels);

    std::vector<float> inputMels(mels.size() * mels[0].size(), 0);
    for (int i = 0; i < mels.size(); i++) {
        std::copy(mels[i].begin(), mels[i].end(), inputMels.begin() + i * mels[0].size());
    }

    BinBuffer inputMelsBin(inputMels.data(), inputMels.size() * sizeof(float) );

    // --- encoder ---
    auto encoderBin = ReadBinFile(resourcesManager, "tiny-encoder.ms");
    if (encoderBin.first == nullptr) {
        return error_ret;
    }

    auto encoder = CreateMSLiteModel(encoderBin);

    int ret = RunMSLiteModel(encoder, {inputMelsBin});
    if (ret != OH_AI_STATUS_SUCCESS) {
        OH_AI_ModelDestroy(&encoder);
        return error_ret;
    }
    LOGI("run encoder ok!\n");

    auto outputs = OH_AI_ModelGetOutputs(encoder);
    auto n_layer_cross_k = GetMSOutput(outputs.handle_list[0]);
    auto n_layer_cross_v = GetMSOutput(outputs.handle_list[1]);

    // --- decoder_main ---
    std::vector<int> SOT_SEQUENCE = {
        WHISPER_SOT,
        WHISPER_SOT + 1 + 1, // wait to modify
        WHISPER_TRANSCRIBE,
        WHISPER_NO_TIMESTAMPS
    };
    BinBuffer sotSequence(SOT_SEQUENCE.data(), SOT_SEQUENCE.size() * sizeof(int));

    const std::string decoder_main_path = "tiny-decoder-main.ms";
    auto decoderMainBin = ReadBinFile(resourcesManager, decoder_main_path);
    if (decoderMainBin.first == nullptr) {
        return error_ret;
    }
    auto decoder_main = CreateMSLiteModel(decoderMainBin);
    int ret2 = RunMSLiteModel(decoder_main, {sotSequence,n_layer_cross_k, n_layer_cross_v});

    if (ret2 != OH_AI_STATUS_SUCCESS) {
        OH_AI_ModelDestroy(&decoder_main);
        return error_ret;
    }
    LOGI("run decoder_main ok!\n");

    auto decoderMainOut = OH_AI_ModelGetOutputs(decoder_main);
    auto logitsBin= GetMSOutput(decoderMainOut.handle_list[0]);
    auto out_n_layer_self_k_cache_Bin = GetMSOutput(decoderMainOut.handle_list[1]);
    auto out_n_layer_self_v_cache_Bin = GetMSOutput(decoderMainOut.handle_list[2]);

    // --- decoder_loop ---
    const std::string modelName3 = "tiny-decoder-loop.ms";
    auto modelBuffer3 = ReadBinFile(resourcesManager, modelName3);
    auto decoder_loop = CreateMSLiteModel(modelBuffer3);

    const std::string dataName_embedding = "tiny-positional_embedding.bin"; // read input data
    auto data_embedding = ReadBinFile(resourcesManager, dataName_embedding);
    if (data_embedding.first == nullptr) {
        return error_ret;
    }

    int loop_times = WHISPER_N_TEXT_CTX - SOT_SEQUENCE.size();
    int offset_init = SOT_SEQUENCE.size();
    auto output_tokens = loop_predict(decoder_loop, n_layer_cross_k, 
    n_layer_cross_v, logitsBin, out_n_layer_self_k_cache_Bin, 
    out_n_layer_self_v_cache_Bin, data_embedding, loop_times, offset_init);

    std::vector<std::string> token_tables = processDataLines(ReadTokens(resourcesManager, "tiny-tokens.txt"));
    std::string result;
    for (const auto i : output_tokens) {
        char str[1024];
        base64_decode((const uint8*)token_tables[i].c_str(), (uint32)token_tables[i].size(), str);
        result += str;
        
    }
    LOGI("MS_LITE_LOG: result is -> %{public}s", result.c_str());

    OH_AI_ModelDestroy(&encoder);
    OH_AI_ModelDestroy(&decoder_main);
    OH_AI_ModelDestroy(&decoder_loop);

    napi_value out_data;
    napi_create_string_utf8(env, result.c_str(), result.length(), &out_data);
    return out_data;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {{"runDemo", nullptr, RunDemo, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
