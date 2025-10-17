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

// [Start napi_image_classification_headers]
#include <iostream>
#include <sstream>
#include <cstdlib>
#include <hilog/log.h>
#include <rawfile/raw_file_manager.h>
#include <mindspore/types.h>
#include <mindspore/model.h>
#include <mindspore/context.h>
#include <mindspore/status.h>
#include <mindspore/tensor.h>
#include "napi/native_api.h"
// [End napi_image_classification_headers]

// [Start napi_image_classification_log]
#define LOGI(...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
#define LOGD(...) ((void)OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
#define LOGW(...) ((void)OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
#define LOGE(...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "[MSLiteNapi]", __VA_ARGS__))
// [End napi_image_classification_log]

// [Start napi_image_classification_print_num]
constexpr int K_NUM_PRINT_OF_OUT_DATA = 20;
// [End napi_image_classification_print_num]

// [Start napi_image_classification_FillInputTensor]
// 设置模型输入数据
int FillInputTensor(OH_AI_TensorHandle input, std::vector<float> input_data)
{
    if (OH_AI_TensorGetDataType(input) == OH_AI_DATATYPE_NUMBERTYPE_FLOAT32) {
        float *data = (float *)OH_AI_TensorGetMutableData(input);
        for (size_t i = 0; i < OH_AI_TensorGetElementNum(input); i++) {
            data[i] = input_data[i];
        }
        return OH_AI_STATUS_SUCCESS;
    } else {
        return OH_AI_STATUS_LITE_ERROR;
    }
}
// [End napi_image_classification_FillInputTensor]

// [Start napi_image_classification_ReadModelFile]
void *ReadModelFile(NativeResourceManager *nativeResourceManager, const std::string &modelName, size_t *modelSize)
{
    auto rawFile = OH_ResourceManager_OpenRawFile(nativeResourceManager, modelName.c_str());
    if (rawFile == nullptr) {
        LOGE("MS_LITE_ERR: Open model file failed");
        OH_ResourceManager_CloseRawFile(rawFile);
        return nullptr;
    }
    long fileSize = OH_ResourceManager_GetRawFileSize(rawFile);
    if (fileSize <= 0) {
        LOGE("MS_LITE_ERR: FileSize not correct");
    }
    void *modelBuffer = malloc(fileSize);
    if (modelBuffer == nullptr) {
        LOGE("MS_LITE_ERR: malloc failed");
    }
    int ret = OH_ResourceManager_ReadRawFile(rawFile, modelBuffer, fileSize);
    if (ret == 0) {
        LOGE("MS_LITE_ERR: OH_ResourceManager_ReadRawFile failed");
        OH_ResourceManager_CloseRawFile(rawFile);
        return nullptr;
    }
    OH_ResourceManager_CloseRawFile(rawFile);
    *modelSize = fileSize;
    return modelBuffer;
}
// [End napi_image_classification_ReadModelFile]

// [Start napi_image_classification_context]
void DestroyModelBuffer(void **buffer)
{
    if (buffer == nullptr) {
        return;
    }
    free(*buffer);
    *buffer = nullptr;
}

OH_AI_ContextHandle CreateMSLiteContext(void *modelBuffer)
{
    // Set executing context for model.
    auto context = OH_AI_ContextCreate();
    if (context == nullptr) {
        DestroyModelBuffer(&modelBuffer);
        LOGE("MS_LITE_ERR: Create MSLite context failed.\n");
        return nullptr;
    }
    // 本样例模型，不支持配置OH_AI_DeviceInfoCreate(OH_AI_DEVICETYPE_NNRT)
    auto cpu_device_info = OH_AI_DeviceInfoCreate(OH_AI_DEVICETYPE_CPU);

    OH_AI_DeviceInfoSetEnableFP16(cpu_device_info, true);
    OH_AI_ContextAddDeviceInfo(context, cpu_device_info);
    
    LOGI("MS_LITE_LOG: Build MSLite context success.\n");
    return context;
}

OH_AI_ModelHandle CreateMSLiteModel(void *modelBuffer, size_t modelSize, OH_AI_ContextHandle context)
{
    // Create model
    auto model = OH_AI_ModelCreate();
    if (model == nullptr) {
        DestroyModelBuffer(&modelBuffer);
        LOGE("MS_LITE_ERR: Allocate MSLite Model failed.\n");
        return nullptr;
    }

    // Build model object
    auto build_ret = OH_AI_ModelBuild(model, modelBuffer, modelSize, OH_AI_MODELTYPE_MINDIR, context);
    DestroyModelBuffer(&modelBuffer);
    if (build_ret != OH_AI_STATUS_SUCCESS) {
        OH_AI_ModelDestroy(&model);
        LOGE("MS_LITE_ERR: Build MSLite model failed.\n");
        return nullptr;
    }
    LOGI("MS_LITE_LOG: Build MSLite model success.\n");
    return model;
}
// [End napi_image_classification_context]

// [Start napi_image_classification_RunMSLiteModel]
// 执行模型推理
int RunMSLiteModel(OH_AI_ModelHandle model, std::vector<float> input_data)
{
    // Set input data for model.
    auto inputs = OH_AI_ModelGetInputs(model);
    auto ret = FillInputTensor(inputs.handle_list[0], input_data);
    if (ret != OH_AI_STATUS_SUCCESS) {
        LOGE("MS_LITE_ERR: RunMSLiteModel set input error.\n");
        return OH_AI_STATUS_LITE_ERROR;
    }

    // Get model output.
    auto outputs = OH_AI_ModelGetOutputs(model);

    // Predict model.
    auto predict_ret = OH_AI_ModelPredict(model, inputs, &outputs, nullptr, nullptr);
    if (predict_ret != OH_AI_STATUS_SUCCESS) {
        LOGE("MS_LITE_ERR: MSLite Predict error.\n");
        return OH_AI_STATUS_LITE_ERROR;
    }
    LOGI("MS_LITE_LOG: Run MSLite model Predict success.\n");

    // Print output tensor data.
    LOGI("MS_LITE_LOG: Get model outputs:\n");
    for (size_t i = 0; i < outputs.handle_num; i++) {
        auto tensor = outputs.handle_list[i];
        LOGI("MS_LITE_LOG: - Tensor %{public}d name is: %{public}s.\n", static_cast<int>(i),
             OH_AI_TensorGetName(tensor));
        LOGI("MS_LITE_LOG: - Tensor %{public}d size is: %{public}d.\n", static_cast<int>(i),
             (int)OH_AI_TensorGetDataSize(tensor));
        LOGI("MS_LITE_LOG: - Tensor data is:\n");
        auto out_data = reinterpret_cast<const float *>(OH_AI_TensorGetData(tensor));
        std::stringstream outStr;
        for (int i = 0; (i < OH_AI_TensorGetElementNum(tensor)) && (i <= K_NUM_PRINT_OF_OUT_DATA); i++) {
            outStr << out_data[i] << " ";
        }
        LOGI("MS_LITE_LOG: %{public}s", outStr.str().c_str());
    }
    return OH_AI_STATUS_SUCCESS;
}
// [End napi_image_classification_RunMSLiteModel]

// [Start napi_image_classification_RunDemo]
static napi_value RunDemo(napi_env env, napi_callback_info info)
{
    // run demo
    napi_value error_ret;
    napi_create_int32(env, -1, &error_ret);
    // 传入数据处理
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    bool isArray = false;
    napi_is_array(env, argv[0], &isArray);
    uint32_t length = 0;
    // 获取数组的长度
    napi_get_array_length(env, argv[0], &length);
    LOGI("MS_LITE_LOG: argv array length = %{public}d", length);
    std::vector<float> input_data;
    double param = 0;
    for (int i = 0; i < length; i++) {
        napi_value value;
        napi_get_element(env, argv[0], i, &value);
        napi_get_value_double(env, value, &param);
        input_data.push_back(static_cast<float>(param));
    }
    std::stringstream outstr;
    for (int i = 0; i < K_NUM_PRINT_OF_OUT_DATA; i++) {
        outstr << input_data[i] << " ";
    }
    LOGI("MS_LITE_LOG: input_data = %{public}s", outstr.str().c_str());
    // Read model file
    const std::string modelName = "mobilenetv2.ms";
    LOGI("MS_LITE_LOG: Run model: %{public}s", modelName.c_str());
    size_t modelSize;
    auto resourcesManager = OH_ResourceManager_InitNativeResourceManager(env, argv[1]);
    auto modelBuffer = ReadModelFile(resourcesManager, modelName, &modelSize);
    if (modelBuffer == nullptr) {
        LOGE("MS_LITE_ERR: Read model failed");
        return error_ret;
    }
    LOGI("MS_LITE_LOG: Read model file success");
    
    auto context = CreateMSLiteContext(modelBuffer);
    if (context == nullptr) {
        LOGE("MS_LITE_ERR: MSLiteFwk Build context failed.\n");
        return error_ret;
    }
    auto model = CreateMSLiteModel(modelBuffer, modelSize, context);
    if (model == nullptr) {
        OH_AI_ContextDestroy(&context);
        LOGE("MS_LITE_ERR: MSLiteFwk Build model failed.\n");
        return error_ret;
    }
    int ret = RunMSLiteModel(model, input_data);
    if (ret != OH_AI_STATUS_SUCCESS) {
        OH_AI_ModelDestroy(&model);
        OH_AI_ContextDestroy(&context);
        LOGE("MS_LITE_ERR: RunMSLiteModel failed.\n");
        return error_ret;
    }
    napi_value out_data;
    napi_create_array(env, &out_data);
    auto outputs = OH_AI_ModelGetOutputs(model);
    OH_AI_TensorHandle output_0 = outputs.handle_list[0];
    float *output0Data = reinterpret_cast<float *>(OH_AI_TensorGetMutableData(output_0));
    for (size_t i = 0; i < OH_AI_TensorGetElementNum(output_0); i++) {
        napi_value element;
        napi_create_double(env, static_cast<double>(output0Data[i]), &element);
        napi_set_element(env, out_data, i, element);
    }
    OH_AI_ModelDestroy(&model);
    OH_AI_ContextDestroy(&context);
    LOGI("MS_LITE_LOG: Exit runDemo()");
    return out_data;
}
// [End napi_image_classification_RunDemo]

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
