/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

#include "image_edit.h"
#include <map>
#include <bits/alltypes.h>

#include <multimedia/image_effect/image_effect.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include "logging.h"
#include "utils/common_utils.h"
#include "utils/pixelmap_helper.h"

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

static ImageEffect_FilterDelegate delegate;

std::vector<std::vector<FilterArrayData>> GetFilters(napi_env env, napi_value arg);

OH_EffectFilter *AddFilter(OH_ImageEffect *imageEffect, const char *filterName);
napi_value SetFilterValue(OH_EffectFilter *filter, const char *filterName, float filterValue,
    OH_PixelmapNative *pixelmap);

const double PI = 3.14159265;

constexpr int EXPECTED_ARGS_ZERO = 0;
constexpr int EXPECTED_ARGS_ONE = 1;
constexpr int EXPECTED_ARGS_TWO = 2;

constexpr int AREA_INFO_ZERO = 0;
constexpr int AREA_INFO_ONE = 1;
constexpr int AREA_INFO_TWO = 2;
constexpr int AREA_INFO_THREE = 3;

constexpr int RGB_IDX_ONE = 1;
constexpr int RGB_IDX_TWO = 2;
constexpr int RGB_IDX_THREE = 3;

constexpr int EXPECTED_CONSTANT_THREE = 3;
constexpr int EXPECTED_CONSTANT_FOUR = 4;
constexpr int EXPECTED_LUT_SIZE_LIMIT = 256;

const int LUT_CYCLE_SIZE = 256;

napi_value ImageEdit::Apply(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_undefined(env, &result);

    size_t argc = EXPECTED_ARGS_TWO;
    napi_value args[EXPECTED_ARGS_TWO] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    CHECK_AND_RETURN_RET_LOG(status == napi_ok, result, "napi_get_cb_info fail! status = %{public}d", status);

    std::string path = CommonUtils::GetStringArgument(env, args[EXPECTED_ARGS_ZERO]);
    std::vector<std::vector<FilterArrayData>> filters = GetFilters(env, args[EXPECTED_ARGS_ONE]);

    OH_ImageEffect *imageEffect = OH_ImageEffect_Create("imageEdit");
    CHECK_AND_RETURN_RET_LOG(imageEffect != nullptr, result, "OH_ImageEffect_Create fail!");
    std::shared_ptr<OH_ImageEffect> imageEffectPtr(imageEffect, [](OH_ImageEffect *imageEffect) {
        OH_ImageEffect_Release(imageEffect);
    });

    std::shared_ptr<OH_PixelmapNative> pixelmapNativePtr = PixelMapHelper::Decode(path);
    CHECK_AND_RETURN_RET_LOG(pixelmapNativePtr != nullptr, result, "Decode path fail! path=%{public}s", path.c_str());

    for (int i = 0; i < filters.size(); i++) {
        OH_EffectFilter *filter = AddFilter(imageEffectPtr.get(), filters[i][0].name.c_str());
        CHECK_AND_RETURN_RET_LOG(filter != nullptr, result, "OH_ImageEffect_AddFilter fail!");
        SetFilterValue(filter, filters[i][0].name.c_str(), filters[i][0].value, pixelmapNativePtr.get());
    }

    ImageEffect_ErrorCode errorCode = OH_ImageEffect_SetInputPixelmap(imageEffectPtr.get(), pixelmapNativePtr.get());
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
        "OH_ImageEffect_SetInputPixelMap fail! errorCode = %{public}d", errorCode);

    errorCode = OH_ImageEffect_Start(imageEffectPtr.get());
    CHECK_AND_RETURN_RET_LOG(errorCode == ImageEffect_ErrorCode::EFFECT_SUCCESS, result,
        "OH_ImageEffect_Start fail! errorCode = %{public}d", errorCode);

    bool encodeRes = PixelMapHelper::Encode(pixelmapNativePtr.get(), path);
    CHECK_AND_RETURN_RET_LOG(encodeRes, result, "Encode path fail! path=%{public}s", path.c_str());

    return result;
}

OH_EffectFilter *AddFilter(OH_ImageEffect *imageEffect, const char *filterName)
{
    OH_EffectFilter *filter = OH_ImageEffect_AddFilter(imageEffect, filterName);
    CHECK_AND_RETURN_RET_LOG(filter != nullptr, filter, "OH_ImageEffect_AddFilter fail!");
    return filter;
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

    // Handle napi array length
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
                "GetFilters child napi_typeof fail! status=%{public}d, value=%{public}d", status, valueType);

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

napi_value ImageEdit::RegisterCustomBrightness()
{
    napi_value result = nullptr;
    // 自定义算子能力信息
    OH_EffectFilterInfo *effectInfo = OH_EffectFilterInfo_Create();
    OH_EffectFilterInfo_SetFilterName(effectInfo, "CustomBrightness");
    ImageEffect_BufferType bufferType = ImageEffect_BufferType::EFFECT_BUFFER_TYPE_PIXEL;
    OH_EffectFilterInfo_SetSupportedBufferTypes(effectInfo, 1, &bufferType);
    ImageEffect_Format format = ImageEffect_Format::EFFECT_PIXEL_FORMAT_RGBA8888;
    OH_EffectFilterInfo_SetSupportedFormats(effectInfo, 1, &format);
    // 自定义算子实现接口
    delegate = {
        .setValue = [](OH_EffectFilter *filter, const char *key, const ImageEffect_Any *value) { return true; },
        .render = [](OH_EffectFilter *filter, OH_EffectBufferInfo *src,
            OH_EffectFilterDelegate_PushData pushData) { return true; },
        .save = [](OH_EffectFilter *filter, char **info) { return true; },
        .restore = [](const char *info) { return OH_EffectFilter_Create("CustomBrightness"); }};
    ImageEffect_ErrorCode errorCode = OH_EffectFilter_Register(effectInfo, &delegate);
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
    return result;
}