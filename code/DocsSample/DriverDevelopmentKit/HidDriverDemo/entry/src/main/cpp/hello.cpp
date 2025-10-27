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
#include "hilog/log.h"
#include "data_parser.h"
#include <cstdint>
#include <cstdlib> // for strtol
#include <chrono>
#include <climits> // for LONG_MIN, LONG_MAX
#include <cctype>  // for isspace
#include <iostream>
#include <string>
#include <stdexcept>
#include <cstdio>
#include <sstream>

#define LOG_TAG "hidTag [NATIVE]"

const int NUM_TWO = 2;
const int NUM_FOUR = 4;
const int NUM_EIGHT = 8;
const int NUM_NINE = 9;
const int NUM_SIXTEEN = 16;
const int NUM_THIRTY_TWO = 32;
const int NUM_SIXTY_FOUR = 64;
const int HEX_FORMAT_SIZE = 256;
const int DATA_BUFF_SIZE = 1024;
const int DATA_BUFF_SIZE1 = 4096;
const int CONST_TIMEOUT = 5000;

static napi_value HidInit(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);
    size_t argc = 1;
    napi_status status;
    napi_value args[1];
    status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s argc:%{public}zu", FILE_NAME, __LINE__, __func__, argc);
    if (status != napi_ok || argc != 1) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }

    uint32_t deviceId = 0;
    status = napi_get_value_uint32(env, args[0], &deviceId);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, nullptr, "Failed to get uint32 value");
        return nullptr;
    }

    uint32_t busNum = ((deviceId & 0xFFFF0000) >> NUM_SIXTEEN);
    uint32_t deviceNum = deviceId & 0xFFFF;

    DataParser::GetInstance().UpdateKeyCodeMap((static_cast<uint64_t>(busNum) << NUM_THIRTY_TWO) | deviceNum);

    uint32_t ret = DataParser::GetInstance().StartWork();

    napi_value result = nullptr;
    napi_create_uint32(env, ret, &result);
    return result;
}

static napi_value GetRawInfo(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);

    // [Start driver_hid_report_step5_1]
    Hid_RawDevInfo rawDevInfo;
    int32_t ret = OH_Hid_GetRawInfo(DataParser::GetInstance().getHidObject(), &rawDevInfo);
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_GetRawInfo failed, ret:%{public}d", ret);
        return nullptr;
    }
    // [End driver_hid_report_step5_1]

    char hexFormat[HEX_FORMAT_SIZE];
    sprintf(hexFormat, "busType:%02X vendor:%04X product:%04X", rawDevInfo.busType,
        rawDevInfo.vendor, rawDevInfo.product);

    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s %{public}s", FILE_NAME, __LINE__, __func__, hexFormat);
    napi_value result = nullptr;
    napi_create_string_utf8(env, hexFormat, strlen(hexFormat), &result);
    return result;
}

static napi_value GetRawName(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);

    // [Start driver_hid_report_step5_2]
    char dataBuff[DATA_BUFF_SIZE];
    int32_t ret = OH_Hid_GetRawName(DataParser::GetInstance().getHidObject(), dataBuff, sizeof(dataBuff));
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_GetRawName failed, ret:%{public}d", ret);
        return nullptr;
    }
    // [End driver_hid_report_step5_2]

    napi_value result = nullptr;
    napi_create_string_utf8(env, dataBuff, strlen(dataBuff), &result);
    return result;
}

static napi_value GetPhysicalAddress(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);

    // [Start driver_hid_report_step5_3]
    char dataBuff[DATA_BUFF_SIZE];
    int32_t ret = OH_Hid_GetPhysicalAddress(DataParser::GetInstance().getHidObject(), dataBuff, sizeof(dataBuff));
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_GetPhysicalAddress failed, ret:%{public}d", ret);
        return nullptr;
    }
    // [End driver_hid_report_step5_3]

    napi_value result = nullptr;
    napi_create_string_utf8(env, dataBuff, strlen(dataBuff), &result);
    return result;
}

static napi_value GetRawUniqueId(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);

    // [Start driver_hid_report_step5_4]
    uint8_t dataBuff[NUM_SIXTY_FOUR];
    int32_t ret = OH_Hid_GetRawUniqueId(DataParser::GetInstance().getHidObject(), dataBuff, sizeof(dataBuff));
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_GetRawUniqueId failed, ret:%{public}d", ret);
        return nullptr;
    }
    // [End driver_hid_report_step5_4]

    char hexFormat[HEX_FORMAT_SIZE];
    int32_t num = 0;
    for (int i = 0; i < NUM_SIXTEEN; i++) {
        num += sprintf(hexFormat + num, "%02X ", dataBuff[i]);
    }

    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s %{public}s", FILE_NAME, __LINE__, __func__, hexFormat);
    napi_value result = nullptr;
    napi_create_string_utf8(env, hexFormat, strlen(hexFormat), &result);
    return result;
}

static napi_value BuildKeyboardResult(napi_env env, napi_value result, napi_value modifierKeysArray, napi_status status,
    KeysState object)
{
    status = napi_set_named_property(env, result, "states", modifierKeysArray);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_set_named_property failed, status: %{public}u", status);
        return result;
    }

    napi_value regularKey = nullptr;
    status = napi_create_string_utf8(env, object.keys.c_str(), NAPI_AUTO_LENGTH, &regularKey);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_create_string_utf8 failed, status: %{public}u", status);
        return result;
    }

    status = napi_set_named_property(env, result, "keys", regularKey);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_set_named_property failed, status: %{public}u", status);
    }
    return result;
}

static napi_value GetKeyboardState(napi_env env, napi_callback_info info)
{
    // [Start driver_hid_report_step4_3]
    uint8_t dataBuff[NUM_NINE] = { 0x00 };
    // 读取输入报告
    int32_t ret = OH_Hid_GetReport(DataParser::GetInstance().getHidObject(), HID_INPUT_REPORT, dataBuff,
                                   sizeof(dataBuff));
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_GetReport failed. ret: %{public}u", ret);
        return nullptr;
    }
    // [End driver_hid_report_step4_3]

    KeysState object = DataParser::GetInstance().ParseKeys(dataBuff, 9, false);

    napi_value result = nullptr;
    napi_status status = napi_create_object(env, &result);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_create_object failed, status: %{public}u", status);
        return result;
    }

    napi_value modifierKeysArray;
    size_t modifierKeysLength = sizeof(object.states) / sizeof(object.states[0]);
    status = napi_create_array_with_length(env, modifierKeysLength, &modifierKeysArray);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_create_array_with_length failed, status: %{public}u", status);
        return result;
    }

    for (size_t i = 0; i < modifierKeysLength; i++) {
        napi_value element;
        status = napi_get_boolean(env, (object.states[i] != 0), &element);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP, "napi_get_boolean failed, i:%{public}zu status: %{public}u", i, status);
            return result;
        }
        status = napi_set_element(env, modifierKeysArray, i, element);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP, "napi_set_element failed, i:%{public}zu status: %{public}u", i, status);
            return result;
        }
    }

    return BuildKeyboardResult(env, result, modifierKeysArray, status, object);
}

static bool SetNonBlock(napi_env env, napi_callback_info info, bool& nonblock)
{
    size_t argc = 1;
    napi_value args[1];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s argc:%{public}zu", FILE_NAME, __LINE__, __func__, argc);
    if (status != napi_ok || argc < 1) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return false;
    }

    bool nonblockTag;
    status = napi_get_value_bool(env, args[0], &nonblockTag);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to get boolean value");
        return false;
    }

    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s nonblockTag:%{public}d", FILE_NAME, __LINE__, __func__,
                nonblockTag);
    int32_t ret;
    if (nonblockTag) {
        // [Start driver_hid_report_step4_1]
        // nonblock取值：1启用非阻塞，0禁用非阻塞
        ret = OH_Hid_SetNonBlocking(DataParser::GetInstance().getHidObject(), nonblockTag);
        if (ret != HID_DDK_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "OH_Hid_SetNonBlocking failed. ret: %{public}u", ret);
            return false;
        }
        // [End driver_hid_report_step4_1]
    }
    nonblock = nonblockTag;
    return true;
}

static napi_value BuildReadKeyboardResult(napi_env env, KeysState object)
{
    napi_value result = nullptr;
    napi_status status = napi_create_object(env, &result);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_create_object failed, status: %{public}u", status);
        return result;
    }

    napi_value modifierKeysArray;
    size_t modifierKeysLength = sizeof(object.states) / sizeof(object.states[0]);
    status = napi_create_array_with_length(env, modifierKeysLength, &modifierKeysArray);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_create_array_with_length failed, status: %{public}u", status);
        return result;
    }

    for (size_t i = 0; i < modifierKeysLength; i++) {
        napi_value element;
        status = napi_get_boolean(env, (object.states[i] != 0), &element);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP, "napi_get_boolean failed, i:%{public}zu status: %{public}u", i, status);
            return result;
        }

        status = napi_set_element(env, modifierKeysArray, i, element);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP, "napi_set_element failed, i:%{public}zu status: %{public}u", i, status);
            return result;
        }
    }

    status = napi_set_named_property(env, result, "states", modifierKeysArray);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_set_named_property failed, status: %{public}u", status);
        return result;
    }

    napi_value regularKey = nullptr;
    status = napi_create_string_utf8(env, object.keys.c_str(), NAPI_AUTO_LENGTH, &regularKey);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_create_string_utf8 failed, status: %{public}u", status);
        return result;
    }

    status = napi_set_named_property(env, result, "keys", regularKey);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_set_named_property failed, status: %{public}u", status);
    }
    return result;
}

static napi_value ReadKeyboardState(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);
    bool nonblock;
    if (!SetNonBlock(env, info, nonblock)) {
        return nullptr;
    }

    uint8_t dataBuff[READ_INPUT_ARRAY_LEN];
    dataBuff[0] = 0x00;
    uint32_t bytesRead = 0;
    KeysState object;
    int32_t ret;
    for (int i = 0; i < NUM_TWO; i++) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_Read. i: %{public}u", i);
        memset(dataBuff, 0, sizeof(dataBuff));
        // [Start driver_hid_report_step4_2]
        if (nonblock) {
            ret = OH_Hid_Read(DataParser::GetInstance().getHidObject(), dataBuff, sizeof(dataBuff), &bytesRead);
        } else {
            ret = OH_Hid_ReadTimeout(DataParser::GetInstance().getHidObject(), dataBuff, sizeof(dataBuff),
                                     CONST_TIMEOUT, &bytesRead);
        }
        // [End driver_hid_report_step4_2]

        if (ret != HID_DDK_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "OH_Hid_ReadTimeout or OH_Hid_Read  failed. ret: %{public}u", ret);
            return nullptr;
        }

        OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s bytesRead:%{public}u", FILE_NAME, __LINE__, __func__,
                    bytesRead);
        if (DataParser::GetInstance().CheckIfZeroArray(dataBuff, READ_INPUT_ARRAY_LEN)) {
            OH_LOG_INFO(LOG_APP, "OH_Hid_Read. dataBuff is all zero.");
            continue;
        } else {
            object = DataParser::GetInstance().ParseKeys(dataBuff, NUM_EIGHT, true);
            break;
        }
    }

    return BuildReadKeyboardResult(env, object);
}

static napi_value ApplyKeyboardSettings(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[NUM_FOUR];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s argc:%{public}zu", FILE_NAME, __LINE__, __func__, argc);
    if (status != napi_ok || argc < 1) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }
    
    bool isArray;
    status = napi_is_array(env, args[0], &isArray);
    if (status != napi_ok || !isArray) {
        OH_LOG_ERROR(LOG_APP, "First argument must be an array");
        return nullptr;
    }
    
    uint32_t length;
    status = napi_get_array_length(env, args[0], &length);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Failed to get array length");
        return nullptr;
    }
    
    uint8_t dataBuff[NUM_TWO] = { 0x00 };
    for (uint32_t i = 0; i < length; ++i) {
        napi_value element;
        status = napi_get_element(env, args[0], i, &element);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP, "Failed to get element from array");
            return nullptr;
        }

        bool value;
        status = napi_get_value_bool(env, element, &value);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP, "Failed to get boolean value");
            return nullptr;
        }

        if (value)  {
            dataBuff[1] |= 1 << i;
        }
    }

    OH_LOG_INFO(LOG_APP, "dataBuff[1]:%{public}d", dataBuff[1]);
    // [Start driver_hid_report_step3_2]
    // 发送输出报告
    int32_t ret = OH_Hid_SendReport(DataParser::GetInstance().getHidObject(), HID_OUTPUT_REPORT, dataBuff,
                                    sizeof(dataBuff));
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_SendReport failed. ret: %{public}u", ret);
    }
    // [End driver_hid_report_step3_2]

    napi_value result = nullptr;
    napi_create_uint32(env, ret, &result);
    return result;
}

static napi_value WriteKeyboardSettings(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);

    size_t argc = 1;
    napi_value args[NUM_FOUR];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }

    bool isArray;
    status = napi_is_array(env, args[0], &isArray);
    if (status != napi_ok || !isArray) {
        OH_LOG_ERROR(LOG_APP, "First argument must be an array");
        return nullptr;
    }

    uint32_t length;
    status = napi_get_array_length(env, args[0], &length);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Failed to get array length");
        return nullptr;
    }

    uint8_t dataBuff[NUM_TWO] = { 0x00 };
    for (uint32_t i = 0; i < length; ++i) {
        napi_value element;
        status = napi_get_element(env, args[0], i, &element);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP, "Failed to get element from array");
            return nullptr;
        }

        bool value;
        status = napi_get_value_bool(env, element, &value);
        if (status != napi_ok) {
            OH_LOG_ERROR(LOG_APP, "Failed to get boolean value");
            return nullptr;
        }

        if (value)  {
            dataBuff[1] |= 1 << i;
        }
    }

    OH_LOG_INFO(LOG_APP, "dataBuff[1]:%{public}d", dataBuff[1]);
    // [Start driver_hid_report_step3_1]
    uint32_t bytesWritten;
    // 写入报告
    int32_t ret = OH_Hid_Write(DataParser::GetInstance().getHidObject(), dataBuff, sizeof(dataBuff), &bytesWritten);
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_Write failed. ret: %{public}u", ret);
    }
    // [End driver_hid_report_step3_1]
    OH_LOG_INFO(LOG_APP, "bytesWritten:%{public}u", bytesWritten);

    napi_value result = nullptr;
    napi_create_uint32(env, ret, &result);
    return result;
}

static napi_value GetKeyboardFeatures(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);

    // [Start driver_hid_report_step4_4]
    uint8_t dataBuff[NUM_EIGHT] = { 0x00 };
    // 指定报告编号
    dataBuff[0] = 0x07;
    // 读取特性报告
    int32_t ret = OH_Hid_GetReport(DataParser::GetInstance().getHid2Object(), HID_FEATURE_REPORT, dataBuff,
                                   sizeof(dataBuff));
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_GetReport failed. ret: %{public}u", ret);
        return nullptr;
    }
    // [End driver_hid_report_step4_4]

    char hexFormat[HEX_FORMAT_SIZE];
    int32_t num = 0;
    for (int i = 0; i < sizeof(dataBuff) / sizeof(dataBuff[0]); i++) {
        num += sprintf(hexFormat + num, "%02X, ", dataBuff[i]);
    }

    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s %{public}s", FILE_NAME, __LINE__, __func__, hexFormat);
    napi_value result = nullptr;
    napi_create_string_utf8(env, hexFormat, strlen(hexFormat), &result);
    return result;
}

void HexStringToUint8Array(const std::string& hexString, uint8_t* dataBuff, size_t bufferSize)
{
    std::stringstream ss(hexString);
    std::string item;
    size_t index = 0;

    while (std::getline(ss, item, ',') && index < bufferSize) {
        // 去除可能的空格和 "0x" 前缀
        item.erase(std::remove_if(item.begin(), item.end(), ::isspace), item.end());
        if (item.substr(0, NUM_TWO) == "0x") {
            item = item.substr(NUM_TWO);
        }
        
        unsigned int value;
        std::stringstream converter(item);
        converter << std::hex << item; // 设置为十六进制模式
        converter >> value;

        if (converter.fail() || converter.bad()) {
            OH_LOG_ERROR(LOG_APP, "%{public}s, converter fail or bad.item: %{public}s", __func__, item.c_str());
        }

        dataBuff[index++] = static_cast<uint8_t>(value);
    }

    // 检查是否所有预期的值都被正确解析
    if (index != bufferSize) {
        OH_LOG_ERROR(LOG_APP, "[%{public}s:%{public}d] %{public}s. index:%{public}d Hex string does not contain"
                              "enough values to fill the buffer.", FILE_NAME, __LINE__, __func__, index);
    }
}

static napi_value ApplyKeyboardFeatures(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);

    size_t argc = 1;
    napi_status status;
    napi_value args[1];
    status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s argc:%{public}zu", FILE_NAME, __LINE__, __func__, argc);
    if (status != napi_ok || argc < 1) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }

    size_t bytesOut;
    char hexFormat[HEX_FORMAT_SIZE];
    status = napi_get_value_string_utf8(env, args[0], hexFormat, sizeof(hexFormat), &bytesOut);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Failed to get boolean value");
        return nullptr;
    }
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s. hextFormat: %{public}s", FILE_NAME, __LINE__, __func__,
                hexFormat);
    
    // [Start driver_hid_report_step3_3]
    uint8_t dataBuff[NUM_EIGHT] = { 0x00 };
    string str(hexFormat);
    HexStringToUint8Array(str, dataBuff, sizeof(dataBuff));
    // 发送特性报告
    int32_t ret = OH_Hid_SendReport(DataParser::GetInstance().getHid2Object(), HID_FEATURE_REPORT, dataBuff,
                                    sizeof(dataBuff));
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_SendReport failed. ret: %{public}u", ret);
    }
    // [End driver_hid_report_step3_3]

    napi_value result = nullptr;
    napi_create_uint32(env, ret, &result);
    return result;
}

static napi_value GetReportDescriptor(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);

    // [Start driver_hid_report_step6]
    uint8_t dataBuff[DATA_BUFF_SIZE1];
    uint32_t bytesRead;
    int32_t ret = OH_Hid_GetReportDescriptor(DataParser::GetInstance().getHidObject(), dataBuff, sizeof(dataBuff),
                                             &bytesRead);
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_GetReportDescriptor failed, ret:%{public}d", ret);
        return nullptr;
    }
    // [End driver_hid_report_step6]

    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s bytesRead:%{public}u", FILE_NAME, __LINE__, __func__,
                bytesRead);
    char *hexFormat = new char[NUM_FOUR * bytesRead];
    memset(hexFormat, 0x00, NUM_FOUR * bytesRead);
    int32_t num = 0;
    for (int i = 0; i < bytesRead; i++) {
        num += sprintf(hexFormat + num, "%02X ", dataBuff[i]);
    }

    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s %{public}s", FILE_NAME, __LINE__, __func__, hexFormat);
    napi_value result = nullptr;
    napi_create_string_utf8(env, hexFormat, strlen(hexFormat), &result);
    delete [] hexFormat;
    return result;
}

static napi_value ReleaseResource(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s enter", FILE_NAME, __LINE__, __func__);

    // [Start driver_hid_report_step7]
    Hid_DeviceHandle *hid = DataParser::GetInstance().getHidObject();
    int32_t ret1 = OH_Hid_Close(&hid);
    DataParser::GetInstance().UpdateHid(hid);
    // [End driver_hid_report_step7]
    
    Hid_DeviceHandle *hid2 = DataParser::GetInstance().getHid2Object();
    int32_t ret2 = OH_Hid_Close(&hid2);
    DataParser::GetInstance().UpdateHid2(hid);
    
    if (ret1 != HID_DDK_SUCCESS || ret2 != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_Init() return failed: %{public}d, %{public}d", ret1, ret2);
    } else {
        // [Start driver_hid_report_step8]
        ret1 = OH_Hid_Release();
        if (ret1 != HID_DDK_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "OH_Hid_Init() return failed: %{public}d", ret1);
        }
        // [End driver_hid_report_step8]
    }

    napi_value result = nullptr;
    napi_create_uint32(env, ret1, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"hidInit", nullptr, HidInit, nullptr, nullptr, nullptr, napi_default, nullptr },
        {"getRawInfo", nullptr, GetRawInfo, nullptr, nullptr, nullptr, napi_default, nullptr },
        {"getRawName", nullptr, GetRawName, nullptr, nullptr, nullptr, napi_default, nullptr },
        {"getPhysicalAddress", nullptr, GetPhysicalAddress, nullptr, nullptr, nullptr, napi_default, nullptr },
        {"getRawUniqueId", nullptr, GetRawUniqueId, nullptr, nullptr, nullptr, napi_default, nullptr },
        {"getKeyboardState", nullptr, GetKeyboardState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"readKeyboardState", nullptr, ReadKeyboardState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"applyKeyboardSettings", nullptr, ApplyKeyboardSettings, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"writeKeyboardSettings", nullptr, WriteKeyboardSettings, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getKeyboardFeatures", nullptr, GetKeyboardFeatures, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"applyKeyboardFeatures", nullptr, ApplyKeyboardFeatures, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getReportDescriptor", nullptr, GetReportDescriptor, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseResource", nullptr, ReleaseResource, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
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

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
