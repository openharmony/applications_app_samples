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

#include "common_utils.h"

#include <map>

#include "logging.h"

const std::map<ImageEffect_Format, const char *> formatToStr_ = {
    {ImageEffect_Format::EFFECT_PIXEL_FORMAT_RGBA8888, "RGBA8888"},
    {ImageEffect_Format::EFFECT_PIXEL_FORMAT_NV12, "YUVNV12"},
    {ImageEffect_Format::EFFECT_PIXEL_FORMAT_NV21, "YUVNV21"},
};

const std::map<ImageEffect_BufferType, const char *> bufferTypeToStr_ = {
    {ImageEffect_BufferType::EFFECT_BUFFER_TYPE_PIXEL, "Pixel"},
    {ImageEffect_BufferType::EFFECT_BUFFER_TYPE_TEXTURE, "Texture"},
};

const char *CommonUtils::GetStringArgument(napi_env env, napi_value value)
{
    char *buffer = nullptr;
    size_t bufferLength = 0;
    napi_status status = napi_get_value_string_utf8(env, value, nullptr, 0, &bufferLength);
    if (status == napi_ok && bufferLength > 0) {
        buffer = reinterpret_cast<char *>(malloc((bufferLength + 1) * sizeof(char)));
        if (buffer == nullptr) {
            LOG_E("No memory");
            return nullptr;
        }
        
        status = napi_get_value_string_utf8(env, value, buffer, bufferLength + 1, &bufferLength);
        if (status != napi_ok) {
            LOG_E("napi_get_value_string_utf8 fail");
            free(buffer);
            buffer = nullptr;
        }
    }
    return buffer;
}

const char *GetBufferType(ImageEffect_BufferType &bufferType)
{
    auto it = bufferTypeToStr_.find(bufferType);
    if (it == bufferTypeToStr_.end()) {
        return "unknown";
    }
    
    return it->second;
}

const char *GetFormat(ImageEffect_Format &ohFormat)
{
    auto it = formatToStr_.find(ohFormat);
    if (it == formatToStr_.end()) {
        return "unknown";
    }
    
    return it->second;
}

std::string CommonUtils::EffectInfoToString(OH_EffectFilterInfo *info)
{
    std::string result = "";
    
    char *name = nullptr;
    OH_EffectFilterInfo_GetFilterName(info, &name);
    result += "name:" + std::string(name) + ", ";
    
    uint32_t supportedBufferTypesSize = 0;
    ImageEffect_BufferType *bufferTypeArray = nullptr;
    OH_EffectFilterInfo_GetSupportedBufferTypes(info, &supportedBufferTypesSize, &bufferTypeArray);
    result += "supportedBufferType: {";
    for (uint32_t i = 0;i < supportedBufferTypesSize; ++i) {
        ImageEffect_BufferType bufferType = bufferTypeArray[i];
        result += GetBufferType(bufferType) + std::string(" ");
    }
    result += "}";
    
    uint32_t supportedFormatsSize = 0;
    ImageEffect_Format *formatArray = nullptr;
    OH_EffectFilterInfo_GetSupportedFormats(info, &supportedFormatsSize, &formatArray);
    result += "supportedFormat: {";
    for (uint32_t i = 0;i < supportedFormatsSize; ++i) {
        ImageEffect_Format ohFormat = formatArray[i];
        result += GetFormat(ohFormat) + std::string(" ");
    }
    result += "}";

    return result;
}