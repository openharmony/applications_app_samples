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

#include <strstream>
#include <map>
#include <multimedia/image_effect/image_effect.h>
#include <multimedia/image_effect/image_effect_filter.h>
#include <multimedia/image_effect/image_effect_errors.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <native_buffer/native_buffer.h>
#include "logging.h"
#include "image_edit.h"
#include "utils/common_utils.h"
#include "utils/pixelmap_helper.h"
#include "utils/json_utils.h"

struct FilterArrayData {
    std::string name;
    int value;
};

struct PixelmapInfo {
    uint32_t width = 0;
    uint32_t height = 0;
    int32_t format = PIXEL_FORMAT::PIXEL_FORMAT_UNKNOWN;
    uint32_t rowStride = 0;
};

static ImageEffect_FilterDelegate delegateBrightness;
static ImageEffect_FilterDelegate delegateCrop;

std::vector<std::vector<FilterArrayData>> GetFilters(napi_env env, napi_value arg);

OH_EffectFilter *AddFilter(OH_ImageEffect *imageEffect, const char *filterName);
napi_value SetFilterValue(OH_EffectFilter *filter, const char *filterName, float filterValue,
                          OH_PixelmapNative *pixelmap);
void AddFilterSingle(const char *filterName, float filterValue, OH_PixelmapNative *inputPixelmap,
                     OH_PixelmapNative *outputPixelmap);
PixelmapInfo GetPixelmapInfo(OH_PixelmapNative *pixelmap);

const double PI = 3.14159265;

// 滤镜数据范围
const float_t DATA_VALUE_MIN = -100.0;
const float_t DATA_VALUE_MAX = 100.0;

// 预期参数数量
constexpr int EXPECTED_ARGS_ZERO = 0;
constexpr int EXPECTED_ARGS_ONE = 1;
constexpr int EXPECTED_ARGS_TWO = 2;

// AREA信息索引下标
constexpr int AREA_INFO_ZERO = 0;
constexpr int AREA_INFO_ONE = 1;
constexpr int AREA_INFO_TWO = 2;
constexpr int AREA_INFO_THREE = 3;

// RBGA8888格式，一个像素点由四个字节组成
constexpr int RGB_IDX_ZERO = 0;
constexpr int RGB_IDX_THREE = 3;

// RGB颜色范围
constexpr int RBG_MIN = 0;
constexpr int RBG_MAX = 255;

OH_ImageEffect* ImageEdit::imageEffect_ = nullptr;

ImageEdit::~ImageEdit()
{
    if (imageEffect_ != nullptr) {
        OH_ImageEffect_Release(imageEffect_);
        imageEffect_ = nullptr;
    }
}

napi_value ImageEdit::PixelMapFilterStart(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_boolean(env, false, &result);

    size_t argc = EXPECTED_ARGS_TWO;
    napi_value args[EXPECTED_ARGS_TWO] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "napi_get_cb_info fail! status = %{public}d", status);

    std::string path = CommonUtils::GetStringArgument(env, args[EXPECTED_ARGS_ZERO]);
    std::vector<std::vector<FilterArrayData>> filters = GetFilters(env, args[EXPECTED_ARGS_ONE]);

    OH_ImageEffect *imageEffect = OH_ImageEffect_Create("imageEdit");
    CHECK_AND_RETURN_RET_LOG(imageEffect != nullptr, result, "OH_ImageEffect_Create fail!");
    std::shared_ptr<OH_ImageEffect> imageEffectPtr(
        imageEffect, [](OH_ImageEffect *imageEffect) { OH_ImageEffect_Release(imageEffect); });

    std::shared_ptr<OH_PixelmapNative> pixelmapNativePtr = PixelMapHelper::Decode(path);
    CHECK_AND_RETURN_RET_LOG(pixelmapNativePtr != nullptr, result, "Decode path fail! path=%{public}s", path.c_str());

    if (filters.size() == 1 && (strcmp(filters[0][0].name.c_str(), OH_EFFECT_BRIGHTNESS_FILTER) == 0 ||
                                strcmp(filters[0][0].name.c_str(), OH_EFFECT_CONTRAST_FILTER) == 0)) {
        std::shared_ptr<OH_PixelmapNative> outputpixelmapNativePtr = PixelMapHelper::Decode(path);
        CHECK_AND_RETURN_RET_LOG(outputpixelmapNativePtr != nullptr, result, "Decode path fail! path=%{public}s",
                                 path.c_str());

        AddFilterSingle(filters[0][0].name.c_str(), filters[0][0].value, pixelmapNativePtr.get(),
                        outputpixelmapNativePtr.get());

        bool encodeRes = PixelMapHelper::Encode(outputpixelmapNativePtr.get(), path);
        CHECK_AND_RETURN_RET_LOG(encodeRes, result, "Encode path fail! path=%{public}s", path.c_str());

        napi_get_boolean(env, true, &result);
        return result;
    }

    for (int i = 0; i < filters.size(); i++) {
        OH_EffectFilter *filter = AddFilter(imageEffectPtr.get(), filters[i][0].name.c_str());
        CHECK_AND_RETURN_RET_LOG(filter != nullptr, result, "OH_ImageEffect_AddFilter fail!");
        LOG_I("%{public}s  :  %{public}d", filters[i][0].name.c_str(), filters[i][0].value);
        SetFilterValue(filter, filters[i][0].name.c_str(), filters[i][0].value, pixelmapNativePtr.get());
    }

    ImageEffect_ErrorCode errorCode = OH_ImageEffect_SetInputPixelmap(imageEffectPtr.get(), pixelmapNativePtr.get());
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_SetInputPixelMap fail! errorCode = %{public}d", errorCode);

    // 设置输出的Pixelmap（可选），不调用该接口时会在输入Pixelmap上直接生效滤镜效果。
    errorCode = OH_ImageEffect_SetOutputPixelmap(imageEffectPtr.get(), pixelmapNativePtr.get());
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_SetOutputPixelmap fail!");

    errorCode = OH_ImageEffect_Start(imageEffectPtr.get());
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_Start fail! errorCode = %{public}d", errorCode);

    // (可选 序列化效果器)
    char *imageinfo = nullptr;
    errorCode = OH_ImageEffect_Save(imageEffect, &imageinfo);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result, "OH_ImageEffect_Save fail!");

    bool encodeRes = PixelMapHelper::Encode(pixelmapNativePtr.get(), path);
    CHECK_AND_RETURN_RET_LOG(encodeRes, result, "Encode path fail! path=%{public}s", path.c_str());

    napi_get_boolean(env, true, &result);
    return result;
}

napi_value ImageEdit::NativeBufferFilterStart(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_boolean(env, false, &result);

    size_t argc = EXPECTED_ARGS_ONE;
    napi_value args[EXPECTED_ARGS_ONE] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "napi_get_cb_info fail! status = %{public}d", status);

    std::vector<std::vector<FilterArrayData>> filters = GetFilters(env, args[EXPECTED_ARGS_ZERO]);

    OH_ImageEffect *imageEffect = OH_ImageEffect_Create("imageEdit");
    CHECK_AND_RETURN_RET_LOG(imageEffect != nullptr, result, "OH_ImageEffect_Create fail!");
    std::shared_ptr<OH_ImageEffect> imageEffectPtr(imageEffect, [](OH_ImageEffect *imageEffect) {
        ImageEffect_ErrorCode errorCode = OH_ImageEffect_Release(imageEffect);
        CHECK_AND_RETURN_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, "OH_ImageEffect_Release fail!");
    });

    OH_NativeBuffer_Config config{
        .width = 0x100,
        .height = 0x100,
        .format = NATIVEBUFFER_PIXEL_FMT_RGBA_8888,
        .usage = NATIVEBUFFER_USAGE_ALIGNMENT_512,
    };

    for (int i = 0; i < filters.size(); i++) {
        OH_EffectFilter *filter = AddFilter(imageEffectPtr.get(), filters[i][0].name.c_str());
        CHECK_AND_RETURN_RET_LOG(filter != nullptr, result, "OH_ImageEffect_AddFilter fail!");
        SetFilterValue(filter, filters[i][0].name.c_str(), filters[i][0].value, nullptr);
    }

    OH_NativeBuffer *inputNativeBuffer = OH_NativeBuffer_Alloc(&config);
    CHECK_AND_RETURN_RET_LOG(inputNativeBuffer != nullptr, result, "OH_NativeBuffer_Alloc Failed!");

    OH_NativeBuffer *outputNativeBuffer = inputNativeBuffer;

    // 设置输入的NativeBuffer。
    ImageEffect_ErrorCode errorCode = OH_ImageEffect_SetInputNativeBuffer(imageEffect, inputNativeBuffer);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_SetInputNativeBuffer fail!");

    // 设置输出的NativeBuffer（可选），不调用该接口时会在输入NativeBuffer上直接生效滤镜效果。
    errorCode = OH_ImageEffect_SetOutputNativeBuffer(imageEffect, outputNativeBuffer);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_SetOutputNativeBuffer fail!");
    
    errorCode = OH_ImageEffect_Start(imageEffectPtr.get());
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_Start fail! errorCode = %{public}d", errorCode);

    // (可选 序列化效果器)
    char *imageinfo = nullptr;
    errorCode = OH_ImageEffect_Save(imageEffect, &imageinfo);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result, "OH_ImageEffect_Save fail!");

    napi_get_boolean(env, true, &result);
    return result;
}

napi_value ImageEdit::URIFilterStart(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_boolean(env, false, &result);

    size_t argc = EXPECTED_ARGS_TWO;
    napi_value args[EXPECTED_ARGS_TWO] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "napi_get_cb_info fail! status = %{public}d", status);

    std::string path = CommonUtils::GetStringArgument(env, args[EXPECTED_ARGS_ZERO]);
    std::vector<std::vector<FilterArrayData>> filters = GetFilters(env, args[EXPECTED_ARGS_ONE]);

    OH_ImageEffect *imageEffect = OH_ImageEffect_Create("imageEdit");
    CHECK_AND_RETURN_RET_LOG(imageEffect != nullptr, result, "OH_ImageEffect_Create fail!");
    std::shared_ptr<OH_ImageEffect> imageEffectPtr(imageEffect, [](OH_ImageEffect *imageEffect) {
        ImageEffect_ErrorCode errorCode = OH_ImageEffect_Release(imageEffect);
        CHECK_AND_RETURN_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, "OH_ImageEffect_Release fail!");
    });

    std::shared_ptr<OH_PixelmapNative> pixelmapNativePtr = PixelMapHelper::Decode(path);
    CHECK_AND_RETURN_RET_LOG(pixelmapNativePtr != nullptr, result, "Decode path fail! path=%{public}s", path.c_str());

    for (int i = 0; i < filters.size(); i++) {
        OH_EffectFilter *filter = AddFilter(imageEffectPtr.get(), filters[i][0].name.c_str());
        CHECK_AND_RETURN_RET_LOG(filter != nullptr, result, "OH_ImageEffect_AddFilter fail!");
        SetFilterValue(filter, filters[i][0].name.c_str(), filters[i][0].value, pixelmapNativePtr.get());
    }

    // 设置输入的URI。
    ImageEffect_ErrorCode errorCode = OH_ImageEffect_SetInputUri(imageEffectPtr.get(), path.c_str());
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_SetInputPixelMap fail! errorCode = %{public}d", errorCode);

    // 设置输出的URI（可选），不调用该接口时会在输入URI上直接生效滤镜效果。
    errorCode = OH_ImageEffect_SetOutputUri(imageEffect, path.c_str());
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_SetOutputUri fail!");

    errorCode = OH_ImageEffect_Start(imageEffectPtr.get());
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_Start fail! errorCode = %{public}d", errorCode);

    // (可选 序列化效果器)
    char *imageinfo = nullptr;
    errorCode = OH_ImageEffect_Save(imageEffect, &imageinfo);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result, "OH_ImageEffect_Save fail!");

    napi_get_boolean(env, true, &result);
    return result;
}

napi_value ImageEdit::SurfaceFilterStart(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_boolean(env, false, &result);
    
    size_t argc = EXPECTED_ARGS_ONE;
    napi_value args[EXPECTED_ARGS_ONE] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "napi_get_cb_info fail! status = %{public}d", status);
    
    std::vector<std::vector<FilterArrayData>> filters = GetFilters(env, args[EXPECTED_ARGS_ZERO]);
    
    OH_ImageEffect *imageEffect = ImageEdit::imageEffect_;
    CHECK_AND_RETURN_RET_LOG(imageEffect != nullptr, result, "imageEffect is nullptr!");
    
    for (int i = 0; i < filters.size(); i++) {
        OH_EffectFilter *filter = AddFilter(imageEffect, filters[i][0].name.c_str());
        CHECK_AND_RETURN_RET_LOG(filter != nullptr, result, "OH_ImageEffect_AddFilter fail!");
        SetFilterValue(filter, filters[i][0].name.c_str(), filters[i][0].value, nullptr);
    }
    
    // 执行生效滤镜效果。
    ImageEffect_ErrorCode errorCode = OH_ImageEffect_Start(imageEffect);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_Start fail! %{public}d", errorCode);
    napi_get_boolean(env, true, &result);
    return result;
}

napi_value ImageEdit::SurfaceFilterStop(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_boolean(env, false, &result);
    
    OH_ImageEffect *imageEffect = ImageEdit::imageEffect_;
    CHECK_AND_RETURN_RET_LOG(imageEffect != nullptr, result, "imageEffect is nullptr!");
    
    // 停止生效滤镜效果。
    ImageEffect_ErrorCode errorCode = OH_ImageEffect_Stop(imageEffect);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result, "OH_ImageEffect_Stop fail!");
    
    napi_get_boolean(env, true, &result);
    return result;
}

OH_EffectFilter *AddFilter(OH_ImageEffect *imageEffect, const char *filterName)
{
    OH_EffectFilter *filter = OH_ImageEffect_AddFilter(imageEffect, filterName);
    CHECK_AND_RETURN_RET_LOG(filter != nullptr, filter, "OH_ImageEffect_AddFilter fail!");
    return filter;
}

void AddFilterSingle(const char *filterName, float filterValue, OH_PixelmapNative *inputPixelmap,
                     OH_PixelmapNative *outputPixelmap)
{
    // 创建滤镜。比如：创建对比度效果器。
    OH_EffectFilter *filter = OH_EffectFilter_Create(filterName);
    CHECK_AND_RETURN_LOG(filter != nullptr, "OH_EffectFilter_Create fail!");

    // 设置滤镜参数, 滤镜强度设置为传入参数。
    ImageEffect_Any value;
    value.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT;
    value.dataValue.floatValue = static_cast<float>(filterValue);
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_SetValue(filter, OH_EFFECT_FILTER_INTENSITY_KEY, &value);
    CHECK_AND_RETURN_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, "OH_EffectFilter_SetValue fail!");

    // 生效滤镜效果。
    errorCode = OH_EffectFilter_Render(filter, inputPixelmap, outputPixelmap);
    CHECK_AND_RETURN_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, "OH_EffectFilter_Render fail!");

    // 销毁滤镜实例。
    errorCode = OH_EffectFilter_Release(filter);
    CHECK_AND_RETURN_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, "OH_EffectFilter_Release fail!");
}

PixelmapInfo GetPixelmapInfo(OH_PixelmapNative *pixelmap)
{
    OH_Pixelmap_ImageInfo *imageInfo = nullptr;
    OH_PixelmapImageInfo_Create(&imageInfo);
    OH_PixelmapNative_GetImageInfo(pixelmap, imageInfo);
    PixelmapInfo info;
    OH_PixelmapImageInfo_GetWidth(imageInfo, &info.width);
    OH_PixelmapImageInfo_GetHeight(imageInfo, &info.height);
    OH_PixelmapImageInfo_GetPixelFormat(imageInfo, &info.format);
    OH_PixelmapImageInfo_GetRowStride(imageInfo, &info.rowStride);
    OH_PixelmapImageInfo_Release(imageInfo);

    return info;
}

napi_value SetFilterValue(OH_EffectFilter *filter, const char *filterName, float filterValue,
                          OH_PixelmapNative *pixelmap)
{
    napi_value result;
    ImageEffect_Any value;
    std::string key;

    if (strcmp(filterName, OH_EFFECT_CROP_FILTER) == 0) {
        CHECK_AND_RETURN_RET_LOG(pixelmap != nullptr, result, "pixelmap nullptr!");
        PixelmapInfo pixelMapInfo = GetPixelmapInfo(pixelmap);
        uint32_t *areaInfo = new uint32_t[4];
        CHECK_AND_RETURN_RET_LOG(areaInfo, result, "areaInfo fail!");
        areaInfo[AREA_INFO_ZERO] = pixelMapInfo.width / 100.f * (100.f - static_cast<int>(filterValue));
        areaInfo[AREA_INFO_ONE] = pixelMapInfo.height / 100.f * (100.f - static_cast<int>(filterValue));
        areaInfo[AREA_INFO_TWO] = pixelMapInfo.width;
        areaInfo[AREA_INFO_THREE] = pixelMapInfo.height;
        value.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_PTR;
        value.dataValue.ptrValue = areaInfo;
        key = OH_EFFECT_FILTER_REGION_KEY;
    } else if (strcmp(filterName, "CustomBrightness") == 0) {
        value.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT;
        value.dataValue.floatValue = filterValue;
        key = "brightness";
    } else if (strcmp(filterName, "CustomCrop") == 0) {
        value.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT;
        value.dataValue.floatValue = filterValue;
        key = "crop";
    } else {
        value.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT;
        value.dataValue.floatValue = filterValue;
        key = OH_EFFECT_FILTER_INTENSITY_KEY;
    }
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_SetValue(filter, key.c_str(), &value);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, nullptr,
                             "OH_EffectFilter_SetValue fail! errorCode = %{public}d", errorCode);
    return result;
}

std::pair<napi_status, uint32_t> GetNapiArrayLength(napi_env env, napi_value element)
{
    uint32_t length = 0;
    napi_status status = napi_get_array_length(env, element, &length);
    return std::make_pair(status, length);
}

std::string HandleStringType(napi_env env, napi_value childElement, napi_status &status)
{
    std::string name;

    size_t bufferLength = 0;
    status = napi_get_value_string_utf8(env, childElement, nullptr, 0, &bufferLength);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok && bufferLength > 0, name,
                             "GetFilters napi_get_value_string_utf8 fail! status = %{public}d", status);
    char *buffer = nullptr;
    buffer = reinterpret_cast<char *>(malloc((bufferLength + 1) * sizeof(char)));
    status = napi_get_value_string_utf8(env, childElement, buffer, bufferLength + 1, &bufferLength);
    if (status == napi_ok) {
        name = buffer;
    }
    free(buffer);
    return name;
}

int HandleNumberType(napi_env env, napi_value childElement, napi_status &status)
{
    int32_t result = 0;
    status = napi_get_value_int32(env, childElement, &result);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "GetFilters napi_get_value_int32 fail! status = %{public}d",
                             status);
    return result;
}

std::vector<std::vector<FilterArrayData>> GetFilters(napi_env env, napi_value arg)
{
    std::vector<std::vector<FilterArrayData>> data;
    napi_status status;

    bool is_array;
    status = napi_is_array(env, arg, &is_array);
    CHECK_AND_RETURN_RET_LOG(is_array == true, data, "GetFilters napi_is_array fail! status=%{public}d", status);
    
    auto array_length = GetNapiArrayLength(env, arg);
    CHECK_AND_RETURN_RET_LOG(array_length.first == napi_ok, data,
                             "GetFilters napi_get_array_length fail! status=%{public}d", array_length.first);

    for (uint32_t i = 0; i < array_length.second; i++) {
        napi_value element;
        status = napi_get_element(env, arg, i, &element);
        CHECK_AND_RETURN_RET_LOG(status == napi_ok, data, "GetFilters napi_get_element fail! status=%{public}d",
                                 status);

        auto child_length = GetNapiArrayLength(env, element);
        CHECK_AND_RETURN_RET_LOG(child_length.first == napi_ok, data,
                                 "GetFilters child napi_get_array_length fail! status=%{public}d", child_length.first);

        std::vector<FilterArrayData> row;
        FilterArrayData filterArrayData;
        for (uint32_t j = 0; j < child_length.second; j++) {
            napi_value childElement;
            status = napi_get_element(env, element, j, &childElement);

            napi_valuetype valueType;
            status = napi_typeof(env, childElement, &valueType);
            CHECK_AND_RETURN_RET_LOG(status == napi_ok, data,
                                     "GetFilters child napi_typeof fail! status=%{public}d, value=%{public}d", status,
                                     valueType);

            if (valueType == napi_string) {
                filterArrayData.name = HandleStringType(env, childElement, status);
            } else if (valueType == napi_number) {
                filterArrayData.value = HandleNumberType(env, childElement, status);
            }
        }
        row.push_back(filterArrayData);
        data.push_back(row);
    }

    return data;
}

napi_value ImageEdit::LookupFilterInfo(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_undefined(env, &result);
    size_t argc = EXPECTED_ARGS_ONE;
    napi_value args[EXPECTED_ARGS_ONE] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "napi_get_cb_info fail! status = %{public}d", status);
    std::string filterName = CommonUtils::GetStringArgument(env, args[EXPECTED_ARGS_ZERO]);

    OH_EffectFilterInfo *effectInfo = OH_EffectFilterInfo_Create();
    // 示例代码: 传入nullptr的format, 获取OH_Formats的size
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_LookupFilterInfo(filterName.c_str(), effectInfo);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_EffectFilter_LookupFilterInfo fail! errorCode = %{public}d", errorCode);

    char *name = nullptr;
    OH_EffectFilterInfo_GetFilterName(effectInfo, &name);

    uint32_t supportedBufferTypesCount = 0;
    ImageEffect_BufferType *bufferTypeArray = nullptr;
    OH_EffectFilterInfo_GetSupportedBufferTypes(effectInfo, &supportedBufferTypesCount, &bufferTypeArray);

    uint32_t supportedFormatsCount = 0;
    ImageEffect_Format *formatArray = nullptr;
    OH_EffectFilterInfo_GetSupportedFormats(effectInfo, &supportedFormatsCount, &formatArray);

    LOG_I("LookupFilterInfo: name=%{public}s, bufferTypesCount=%{public}d, formatsCount=%{public}d", name,
          supportedBufferTypesCount, supportedFormatsCount);

    std::string infoStr = CommonUtils::EffectInfoToString(effectInfo);
    LOG_I("LookupFilterInfo:%{public}s", infoStr.c_str());
    status = napi_create_string_utf8(env, infoStr.c_str(), strlen(infoStr.c_str()), &result);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "napi_create_string_utf8 fail!");

    OH_EffectFilterInfo_Release(effectInfo);
    return result;
}

// 图像信息结构体。
struct EffectBufferInfo {
    void *addr = nullptr;
    int32_t width = 0;
    int32_t height = 0;
    int32_t rowSize = 0;
    ImageEffect_Format format = ImageEffect_Format::EFFECT_PIXEL_FORMAT_UNKNOWN;
};

void ApplyCustomBrightnessAlgo(OH_EffectFilter *filter, EffectBufferInfo inputBufferInfo)
{
    ImageEffect_Any value;
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_GetValue(filter, "brightness", &value);
    CHECK_AND_RETURN_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS,
                         "OH_EffectFilter_GetValue fail! 11 %{public}d", errorCode);

    float brightnessIncrement = value.dataValue.floatValue;

    // 获取图像的宽度和高度
    int32_t width = inputBufferInfo.width;
    int32_t height = inputBufferInfo.height;
    int32_t rowSize = inputBufferInfo.rowSize;
    ImageEffect_Format format = inputBufferInfo.format;

    // 检查图片格式是否为RGBA8888
    CHECK_AND_RETURN_LOG(format == ImageEffect_Format::EFFECT_PIXEL_FORMAT_RGBA8888,
                         "Unsupported image format: %{public}d", format);
    
    // 获取图像数据指针
    uint8_t *pixelData = static_cast<uint8_t *>(inputBufferInfo.addr);
    // 遍历每个像素
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            // 计算当前像素的起始地址
            uint8_t *pixel = pixelData + y * rowSize + x * 4;
            // 增加亮度值，最小值为0，最大值为255
            for (int i = RGB_IDX_ZERO; i < RGB_IDX_THREE; ++i) {
                int tempPixel = static_cast<int>(pixel[i]) + static_cast<int>(brightnessIncrement);
                pixel[i] = std::max(RBG_MIN, std::min(RBG_MAX, tempPixel));
            }
        }
    }
}

bool RenderBrightness(OH_EffectFilter *filter, OH_EffectBufferInfo *info, OH_EffectFilterDelegate_PushData pushData)
{
    // 获取图像信息具体参数。
    EffectBufferInfo inputBufferInfo;
    OH_EffectBufferInfo_GetAddr(info, &inputBufferInfo.addr);
    OH_EffectBufferInfo_GetWidth(info, &inputBufferInfo.width);
    OH_EffectBufferInfo_GetHeight(info, &inputBufferInfo.height);
    OH_EffectBufferInfo_GetRowSize(info, &inputBufferInfo.rowSize);
    OH_EffectBufferInfo_GetEffectFormat(info, &inputBufferInfo.format);

    // 调用自定义滤镜算法。
    ApplyCustomBrightnessAlgo(filter, inputBufferInfo);

    // 编辑完成后调用pushData直接传递原图。
    pushData(filter, info);
    return true;
}

void ApplyCustomCropAlgo(OH_EffectFilter *filter, EffectBufferInfo inputBufferInfo,
                         EffectBufferInfo &outputBufferInfo)
{
    ImageEffect_Any value;
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_GetValue(filter, "crop", &value);
    CHECK_AND_RETURN_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS,
                         "OH_EffectFilter_GetValue fail! 22 %{public}d", errorCode);

    float cropIncrement = value.dataValue.floatValue;

    // 计算新的高度
    int32_t newHeight = static_cast<int32_t>(inputBufferInfo.height * cropIncrement / 100);

    // 分配新的内存来存储裁剪后的图像数据
    uint8_t *croppedData = new uint8_t[newHeight * inputBufferInfo.rowSize];

    // 复制裁剪后的图像数据
    for (int y = 0; y < newHeight; ++y) {
        uint8_t *src = static_cast<uint8_t *>(inputBufferInfo.addr) + y * inputBufferInfo.rowSize;
        uint8_t *dst = croppedData + y * inputBufferInfo.rowSize;
        for (int x = 0; x < inputBufferInfo.rowSize; ++x) {
            dst[x] = src[x];
        }
    }

    // 设置输出缓冲区的信息
    outputBufferInfo.addr = croppedData;
    outputBufferInfo.width = inputBufferInfo.width;
    outputBufferInfo.height = newHeight;
    outputBufferInfo.rowSize = inputBufferInfo.rowSize;
    outputBufferInfo.format = inputBufferInfo.format;
}

bool RenderCrop(OH_EffectFilter *filter, OH_EffectBufferInfo *info, OH_EffectFilterDelegate_PushData pushData)
{
    // 获取图像信息具体参数。
    EffectBufferInfo inputBufferInfo;
    OH_EffectBufferInfo_GetAddr(info, &inputBufferInfo.addr);
    OH_EffectBufferInfo_GetWidth(info, &inputBufferInfo.width);
    OH_EffectBufferInfo_GetHeight(info, &inputBufferInfo.height);
    OH_EffectBufferInfo_GetRowSize(info, &inputBufferInfo.rowSize);
    OH_EffectBufferInfo_GetEffectFormat(info, &inputBufferInfo.format);

    // 创建输出像素信息。
    EffectBufferInfo outputBufferInfo;

    // 调用自定义滤镜算法。
    ApplyCustomCropAlgo(filter, inputBufferInfo, outputBufferInfo);

    // 生成outputOhInfo。
    OH_EffectBufferInfo *outputOhInfo = OH_EffectBufferInfo_Create();
    OH_EffectBufferInfo_SetAddr(outputOhInfo, outputBufferInfo.addr);
    OH_EffectBufferInfo_SetWidth(outputOhInfo, outputBufferInfo.width);
    OH_EffectBufferInfo_SetHeight(outputOhInfo, outputBufferInfo.height);
    OH_EffectBufferInfo_SetRowSize(outputOhInfo, outputBufferInfo.rowSize);
    OH_EffectBufferInfo_SetEffectFormat(outputOhInfo, outputBufferInfo.format);

    // 编辑完成后调用pushData传递outputOhInfo。
    pushData(filter, outputOhInfo);

    // 释放资源。
    OH_EffectBufferInfo_Release(outputOhInfo);

    return true;
}

bool SaveFilterBrightness(OH_EffectFilter *filter, char **info)
{
    // 获取自定义所设置的滤镜参数，其中"brightness"为自定义滤镜的Key，由开发者自己任意指定。
    ImageEffect_Any value;
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_GetValue(filter, "brightness", &value);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, false,
                             "OH_EffectFilter_GetValue fail! 33 %{public}d", errorCode);

    // 生成键值对信息。
    Json values;
    values["brightness"] = value.dataValue.floatValue;
    Json root;
    root["name"] = "CustomBrightness";
    root["values"] = values;

    // 将json对象转成字符串infoStr
    std::string infoStr = root.Dump();

    // 对*info赋值序列化字符串地址。
    *info = strdup(infoStr.data());
    
    return true;
}

bool SaveFilterCrop(OH_EffectFilter *filter, char **info)
{
    // 获取自定义所设置的滤镜参数，其中"crop"为自定义滤镜的Key，由开发者自己任意指定。
    ImageEffect_Any value;
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_GetValue(filter, "crop", &value);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, false,
                             "OH_EffectFilter_GetValue fail! 44 %{public}d", errorCode);

    // 生成键值对信息。
    Json values;
    values["crop"] = value.dataValue.floatValue;
    Json root;
    root["name"] = "CustomCrop";
    root["values"] = values;

    // 将json对象转成字符串infoStr
    std::string infoStr = root.Dump();

    // 对*info赋值序列化字符串地址。
    *info = strdup(infoStr.data());
    
    return true;
}

napi_value ImageEdit::RegisterCustomBrightness()
{
    napi_value result = nullptr;
    // 创建 OH_EffectFilterInfo 实例。
    OH_EffectFilterInfo *customFilterInfo = OH_EffectFilterInfo_Create();
    CHECK_AND_RETURN_RET_LOG(customFilterInfo != nullptr, result, "OH_EffectFilter_GetValue fail!");
    // 设置自定义滤镜滤镜名。
    OH_EffectFilterInfo_SetFilterName(customFilterInfo, "CustomBrightness");
    // 设置自定义滤镜所支持的内存类型。
    ImageEffect_BufferType bufferTypeArray[] = {ImageEffect_BufferType::EFFECT_BUFFER_TYPE_PIXEL};
    OH_EffectFilterInfo_SetSupportedBufferTypes(customFilterInfo,
        sizeof(bufferTypeArray) / sizeof(ImageEffect_BufferType), bufferTypeArray);
    // 设置自定义滤镜所支持的像素格式。
    ImageEffect_Format formatArray = ImageEffect_Format::EFFECT_PIXEL_FORMAT_RGBA8888;
    OH_EffectFilterInfo_SetSupportedFormats(customFilterInfo,
        sizeof(formatArray) / sizeof(ImageEffect_Format), &formatArray);
    // 自定义滤镜具体实现。
    delegateBrightness = {
        .setValue =
            [](OH_EffectFilter *filter, const char *key, const ImageEffect_Any *value) {
                // 参数校验，校验成功时返回true，否则返回false。
                if (value->dataValue.floatValue >= DATA_VALUE_MIN && value->dataValue.floatValue <= DATA_VALUE_MAX) {
                    return true;
                } else {
                    return false;
                }
            },
        .render = [](OH_EffectFilter *filter, OH_EffectBufferInfo *info,
                     OH_EffectFilterDelegate_PushData pushData) { return RenderBrightness(filter, info, pushData); },
        .save = SaveFilterBrightness,
        .restore = [](const char *info) -> OH_EffectFilter * {
            // 创建 OH_EffectFilter 实例，其中"CustomBrightness"为自定义滤镜的滤镜名。
            OH_EffectFilter *filter = OH_EffectFilter_Create("CustomBrightness");
            CHECK_AND_RETURN_RET_LOG(filter != nullptr, nullptr, "OH_EffectFilter_Create fail!");
            // 解析json字符串info获取key和value。
            std::map<std::string, std::string> parsedJson = Json::Parse(info);
            if (parsedJson.find("values") != parsedJson.end()) {
                std::string valuesStr = parsedJson["values"];
                std::map<std::string, std::string> valuesJson = Json::Parse(valuesStr);
                if (valuesJson.find("brightness") != valuesJson.end()) {
                    float brightness =
                        std::stof(valuesJson["brightness"].substr(1, valuesJson["brightness"].size() - 2));
                    ImageEffect_Any value;
                    value.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT;
                    value.dataValue.floatValue = brightness;
                    // 设置滤镜参数, value为info中按json解析出来的参数。
                    LOG_E("brightness value: %{public}f ", value.dataValue.floatValue);
                    ImageEffect_ErrorCode errorCode = OH_EffectFilter_SetValue(filter, "brightness", &value);
                    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, nullptr,
                                             "OH_EffectFilter_SetValue fail!");
                }
            }
            return filter;
        }};

    ImageEffect_ErrorCode errorCode = OH_EffectFilter_Register(customFilterInfo, &delegateBrightness);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_EffectFilter_Register fail! errorCode = %{public}d", errorCode);
    return result;
}

napi_value ImageEdit::RegisterCustomCrop()
{
    napi_value result = nullptr;
    // 创建 OH_EffectFilterInfo 实例。
    OH_EffectFilterInfo *customFilterInfo = OH_EffectFilterInfo_Create();
    CHECK_AND_RETURN_RET_LOG(customFilterInfo != nullptr, result, "OH_EffectFilter_GetValue fail!");
    // 设置自定义滤镜滤镜名。
    OH_EffectFilterInfo_SetFilterName(customFilterInfo, "CustomCrop");
    // 设置自定义滤镜所支持的内存类型。
    ImageEffect_BufferType bufferTypeArray[] = {ImageEffect_BufferType::EFFECT_BUFFER_TYPE_PIXEL};
    OH_EffectFilterInfo_SetSupportedBufferTypes(customFilterInfo,
        sizeof(bufferTypeArray) / sizeof(ImageEffect_BufferType), bufferTypeArray);
    // 设置自定义滤镜所支持的像素格式。
    ImageEffect_Format formatArray = ImageEffect_Format::EFFECT_PIXEL_FORMAT_RGBA8888;
    OH_EffectFilterInfo_SetSupportedFormats(customFilterInfo,
        sizeof(formatArray) / sizeof(ImageEffect_Format), &formatArray);
    // 自定义滤镜具体实现。
    delegateCrop = {
        .setValue =
            [](OH_EffectFilter *filter, const char *key, const ImageEffect_Any *value) {
                // 参数校验，校验成功时返回true，否则返回false。
                if (value->dataValue.floatValue >= DATA_VALUE_MIN && value->dataValue.floatValue <= DATA_VALUE_MAX) {
                    return true;
                } else {
                    return false;
                }
            },
        .render = [](OH_EffectFilter *filter, OH_EffectBufferInfo *info,
                     OH_EffectFilterDelegate_PushData pushData) { return RenderCrop(filter, info, pushData); },
        .save = SaveFilterCrop,
        .restore = [](const char *info) -> OH_EffectFilter * {
            // 创建 OH_EffectFilter 实例，其中"CustomBrightness"为自定义滤镜的滤镜名。
            OH_EffectFilter *filter = OH_EffectFilter_Create("CustomCrop");
            CHECK_AND_RETURN_RET_LOG(filter != nullptr, nullptr, "OH_EffectFilter_Create fail!");
            // 解析json字符串info获取key和value。
            std::map<std::string, std::string> parsedJson = Json::Parse(info);
            if (parsedJson.find("values") != parsedJson.end()) {
                std::string valuesStr = parsedJson["values"];
                std::map<std::string, std::string> valuesJson = Json::Parse(valuesStr);
                if (valuesJson.find("crop") != valuesJson.end()) {
                    float crop = std::stof(valuesJson["crop"].substr(1, valuesJson["crop"].size() - 2));
                    ImageEffect_Any value;
                    value.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_FLOAT;
                    value.dataValue.floatValue = crop;
                    // 设置滤镜参数, value为info中按json解析出来的参数。
                    LOG_E("crop value: %{public}f ", value.dataValue.floatValue);
                    ImageEffect_ErrorCode errorCode = OH_EffectFilter_SetValue(filter, "crop", &value);
                    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, nullptr,
                                             "OH_EffectFilter_SetValue fail!");
                }
            }
            return filter;
        }};

    ImageEffect_ErrorCode errorCode = OH_EffectFilter_Register(customFilterInfo, &delegateCrop);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_EffectFilter_Register fail! errorCode = %{public}d", errorCode);
    return result;
}

napi_value ImageEdit::LookupFilters(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_undefined(env, &result);
    size_t argc = EXPECTED_ARGS_ONE;
    napi_value args[EXPECTED_ARGS_ONE] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "napi_get_cb_info fail! status = %{public}d", status);
    const char *key = CommonUtils::GetStringArgument(env, args[EXPECTED_ARGS_ZERO]);

    ImageEffect_FilterNames *filterNames = OH_EffectFilter_LookupFilters(key);
    CHECK_AND_RETURN_RET_LOG(filterNames != nullptr, result, "OH_EffectFilter_LookupFilters fail!");

    std::string res = "size: " + std::to_string(filterNames->size) + std::string(", name: ");
    for (int i = 0; i < filterNames->size; i++) {
        res += filterNames->nameList[i];
        if (i < filterNames->size - 1) {
            res += " | ";
        }
    }
    status = napi_create_string_utf8(env, res.c_str(), res.size(), &result);
    // 释放FilterNames虚拟内存资源。
    OH_EffectFilter_ReleaseFilterNames();
    return result;
}

napi_value ImageEdit::getSurfaceId(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_undefined(env, &result);

    size_t argc = EXPECTED_ARGS_ONE;
    napi_value args[EXPECTED_ARGS_ONE] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "napi_get_cb_info fail! status = %{public}d", status);

    std::string surfaceId = CommonUtils::GetStringArgument(env, args[EXPECTED_ARGS_ZERO]);
    // 根据SurfaceId创建NativeWindow，注意创建出来的NativeWindow在使用结束后需要主动调用OH_NativeWindow_DestoryNativeWindow进行释放。
    uint64_t iSurfaceId;
    std::istrstream iss(surfaceId.c_str());
    iss >> iSurfaceId;
    LOG_I("iSurfaceId %{public}llu", iSurfaceId);
    OHNativeWindow *outputNativeWindow = nullptr;
    int32_t res = OH_NativeWindow_CreateNativeWindowFromSurfaceId(iSurfaceId, &outputNativeWindow);
    CHECK_AND_RETURN_RET_LOG(res == 0, result, "OH_NativeWindow_CreateNativeWindowFromSurfaceId fail!");

    OH_ImageEffect *imageEffect = OH_ImageEffect_Create("imageEdit");
    CHECK_AND_RETURN_RET_LOG(imageEffect != nullptr, result, "OH_ImageEffect_Create fail!");
    
    ImageEffect_Any runningType;
    runningType.dataType = ImageEffect_DataType::EFFECT_DATA_TYPE_INT32;
    runningType.dataValue.int32Value = 1;
    ImageEffect_ErrorCode errorCode = OH_ImageEffect_Configure(imageEffect, "runningType", &runningType);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_Configure fail!");
    
    // 设置输出显示的Surface。
    errorCode = OH_ImageEffect_SetOutputSurface(imageEffect, outputNativeWindow);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_SetOutputSurface fail!");
    
    // 获取输入的Surface。注意获取的inputNativeWindow在使用结束后需要主动调用OH_NativeWindow_DestoryNativeWindow进行释放。
    OHNativeWindow *inputNativeWindow = nullptr;
    errorCode = OH_ImageEffect_GetInputSurface(imageEffect, &inputNativeWindow);
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
                             "OH_ImageEffect_GetInputSurface fail!");
    
    ImageEdit::imageEffect_ = imageEffect;
    
    // 从获取到输入的NativeWindow中获取SurfaceId。
    uint64_t inputSurfaceId = 0;
    res = OH_NativeWindow_GetSurfaceId(inputNativeWindow, &inputSurfaceId);
    CHECK_AND_RETURN_RET_LOG(res == 0, result, "OH_NativeWindow_GetSurfaceId fail!");

    OH_NativeWindow_DestroyNativeWindow(outputNativeWindow);
    OH_NativeWindow_DestroyNativeWindow(inputNativeWindow);

    std::string inputSurfaceIdStr = std::to_string(inputSurfaceId);
    
    status = napi_create_string_utf8(env, inputSurfaceIdStr.c_str(), inputSurfaceIdStr.length(), &result);
    CHECK_AND_RETURN_RET_LOG(status == napi_status::napi_ok, result, "napi_create_string_utf8 fail!");
    return result;
}
