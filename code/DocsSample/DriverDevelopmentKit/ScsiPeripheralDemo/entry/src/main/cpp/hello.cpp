/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "napi/native_api.h"
#include "hilog/log.h"
#include "scsi_peripheral/scsi_peripheral_api.h"
#include <chrono>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <string>
#include <vector>
#include <numeric>
#include <cstdio>
#include <unistd.h>
#include <algorithm>

using namespace std;

#define LOG_TAG "testTag [NATIVE]"

uint64_t g_devHandle = 0;
ScsiPeripheral_Device *g_scsiPeripheralDevice = nullptr;
ScsiPeripheral_DeviceMemMap *g_scsiDeviceMemMap = nullptr;
constexpr size_t DEVICE_MEM_MAP_SIZE = 10 * 1024;
constexpr size_t PARSE_SENSE_DATA_MAX_LENGTH = 1024;
constexpr int32_t DIRECTION_ERROR = -3;
constexpr int32_t MAX_SCSI_COUNT = 4;
constexpr int32_t DIRECTION_WARNING = -4;
constexpr int32_t ARGC_SIZE = 3;
constexpr int32_t ALLOCATION_LENGTH = 512;
constexpr int32_t REQUEST_TIMEOUT = 5000;
constexpr int32_t RIGHT_OFFSET = 16;
constexpr int32_t LEFT_OFFSET = 32;
constexpr int32_t NUM_TWO = 2;
constexpr int32_t NUM_FIVE = 5;
constexpr int32_t NUM_NINETY = 19;

static napi_status CreateStringFromCString(napi_env env, const char *str, napi_value* result)
{
    size_t length = strlen(str);
    return napi_create_string_utf8(env, str, length, result);
}

char* ConvertHexDataToHexStr(char* hexStr, uint8_t* hexData, uint32_t len)
{
    memset(hexStr, 0x00, MAX_SCSI_COUNT * len);
    int32_t num = 0;
    for (int i = 0; i < len; i++) {
        num += sprintf(hexStr + num, "%02X ", hexData[i]);
    }
    OH_LOG_INFO(LOG_APP, "HexStr is: %{public}s", hexStr);
    
    return hexStr;
}

bool IsAllZero(const uint8_t* array, size_t length)
{
    return all_of(array, array + length, [](uint8_t value) { return value == 0; });
}

uint32_t convertSenseInfoToSenseInfoStr(ScsiPeripheral_BasicSenseInfo& senseInfo, char* buffer, uint32_t len)
{
    if (buffer == nullptr || len == 0) {
        return 0;
    }

    memset(buffer, 0, len);
    uint32_t num = 0;

    num += sprintf(buffer + num, "responseCode=0x%x;\n", senseInfo.responseCode);
    num += sprintf(buffer + num, "valid=%d;\n", senseInfo.valid);
    num += sprintf(buffer + num, "information=0x%x;\n", senseInfo.information);
    num += sprintf(buffer + num, "commandSpecific=0x%x;\n", senseInfo.commandSpecific);
    num += sprintf(buffer + num, "sksv=%d;\n", senseInfo.sksv);
    num += sprintf(buffer + num, "senseKeySpecific=0x%x;\n", senseInfo.senseKeySpecific);

    return num;
}

static napi_value ScsiInit(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter ScsiInit\n");
    sleep(1); // 防止拔掉后很快就插上设备，所以这里sleep

    // 解析deviceId
    size_t argc = 1;
    napi_value argv;
    napi_get_cb_info(env, info, &argc, &argv, nullptr, nullptr);
    if (argc < 1) {
        OH_LOG_ERROR(LOG_APP, "ScsiInit argc is invalid");
        return nullptr;
    }

    uint32_t devicedId = 0;
    napi_get_value_uint32(env, argv, &devicedId);
    uint32_t busNum = ((devicedId & 0xFFFF0000) >> RIGHT_OFFSET);
    uint32_t deviceNum = devicedId & 0xFFFF;
    g_devHandle = (static_cast<uint64_t>(busNum) << LEFT_OFFSET) | deviceNum;
    // [Start driver_scsi_step1]
    // 初始化SCSI Peripheral DDK
    int32_t ret = OH_ScsiPeripheral_Init();
    // [End driver_scsi_step1]
    if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ScsiPeripheral_Init failed, ret = %{public}d\n", ret);
        return nullptr;
    }
    
    int i = 0;
    uint8_t interfaceIndex = 0;
    while (i < MAX_SCSI_COUNT) {
        i++;
        sleep(1);
        // [Start driver_scsi_step2]
        ret = OH_ScsiPeripheral_Open(g_devHandle, interfaceIndex, &g_scsiPeripheralDevice);
        // [End driver_scsi_step2]
        if (ret == SCSIPERIPHERAL_DDK_SUCCESS) {
            break;
        }
            
        OH_LOG_ERROR(LOG_APP, "OH_ScsiPeripheral_Open failed, ret = %{public}d\n", ret);
        if (i >= NUM_TWO) {
            interfaceIndex = 1;
        }
    }
    if (i >= MAX_SCSI_COUNT) {
        return nullptr;
    }

    if (g_scsiDeviceMemMap == nullptr) {
        // [Start driver_scsi_step3]
        ret = OH_ScsiPeripheral_CreateDeviceMemMap(g_scsiPeripheralDevice, DEVICE_MEM_MAP_SIZE, &g_scsiDeviceMemMap);
        // [End driver_scsi_step3]
        if (ret != SCSIPERIPHERAL_DDK_SUCCESS || g_scsiDeviceMemMap == nullptr) {
            OH_LOG_ERROR(LOG_APP, "OH_ScsiPeripheral_CreateDeviceMemMap failed, ret = %{public}d\n", ret);
            return nullptr;
        }
    }

    OH_LOG_DEBUG(LOG_APP, "ScsiInit, g_scsiDeviceMemMap->size=%{public}d\n", g_scsiDeviceMemMap->size);
    napi_value result = nullptr;
    napi_create_uint32(env, ret, &result);
    return result;
}

static bool BuildInquiryResult(napi_env env, napi_value& result, ScsiPeripheral_InquiryInfo& inquiryInfo,
    ScsiPeripheral_Response& response)
{
    napi_value deviceInfo;
    napi_create_object(env, &deviceInfo);

    napi_value devTypeValue;
    napi_create_int32(env, inquiryInfo.deviceType, &devTypeValue);
    napi_set_named_property(env, deviceInfo, "devType", devTypeValue);

    napi_value vendorValue;
    CreateStringFromCString(env, inquiryInfo.idVendor, &vendorValue);
    napi_set_named_property(env, deviceInfo, "vendor", vendorValue);

    napi_value productValue;
    CreateStringFromCString(env, inquiryInfo.idProduct, &productValue);
    napi_set_named_property(env, deviceInfo, "product", productValue);

    napi_value revisionValue;
    CreateStringFromCString(env, inquiryInfo.revProduct, &revisionValue);
    napi_set_named_property(env, deviceInfo, "revision", revisionValue);

    // 拼接查询的原始数据到字符串，方便传给arkts侧
    napi_value originData = nullptr;
    char *hexFormat = new char[MAX_SCSI_COUNT * g_scsiDeviceMemMap->transferredLength];
    if (hexFormat != nullptr) {
        ConvertHexDataToHexStr(hexFormat, g_scsiDeviceMemMap->address, g_scsiDeviceMemMap->transferredLength);
        napi_create_string_utf8(env, hexFormat,
            MAX_SCSI_COUNT * g_scsiDeviceMemMap->transferredLength, &originData);
        delete [] hexFormat;
        hexFormat = nullptr;
    } else {
        napi_create_string_utf8(env, "error", NUM_FIVE, &originData);
    }
    napi_set_named_property(env, deviceInfo, "originData", originData);

    napi_value status;
    napi_create_int32(env, response.status, &status);
    
    if (napi_create_array(env, &result) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_array failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 0, deviceInfo) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 0 failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 1, status) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 1 failed", __func__);
        return false;
    }
    return true;
}

static bool DoInquiry(napi_env env, napi_value& result)
{
    if (g_scsiDeviceMemMap == nullptr) {
        return false;
    }
    OH_LOG_DEBUG(LOG_APP, "Inquiry, g_scsiDeviceMemMap->size=%{public}d\n", g_scsiDeviceMemMap->size);
    ScsiPeripheral_InquiryRequest inquiryRequest;
    inquiryRequest.allocationLength = ALLOCATION_LENGTH;
    inquiryRequest.timeout = REQUEST_TIMEOUT;
    ScsiPeripheral_InquiryInfo inquiryInfo = {0};
    inquiryInfo.data = g_scsiDeviceMemMap;
    memset(g_scsiDeviceMemMap->address, 0x00, DEVICE_MEM_MAP_SIZE);
    ScsiPeripheral_Response response;
    // [Start driver_scsi_step5]
    int32_t ret = OH_ScsiPeripheral_Inquiry(g_scsiPeripheralDevice, &inquiryRequest, &inquiryInfo, &response);
    // [End driver_scsi_step5]
    if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "GetDeviceInfo OH_ScsiPeripheral_Inquiry failed, ret = %{public}d\n", ret);
        return false;
    }

    OH_LOG_DEBUG(LOG_APP, "%{public}s success. devType=%{public}x\n", __func__, inquiryInfo.deviceType);
    OH_LOG_DEBUG(LOG_APP, "%{public}s success. idVendor=%{public}s\n",  __func__, inquiryInfo.idVendor);
    OH_LOG_DEBUG(LOG_APP, "%{public}s success. idProduct=%{public}s\n",  __func__, inquiryInfo.idProduct);
    OH_LOG_DEBUG(LOG_APP, "%{public}s success. revProduct=%{public}s\n",  __func__, inquiryInfo.revProduct);
    OH_LOG_DEBUG(LOG_APP, "%{public}s success. transferredLength=%{public}d\n",
        __func__, g_scsiDeviceMemMap->transferredLength);
    OH_LOG_DEBUG(LOG_APP, "%{public}s success. inquiry data=%{public}s, size=%{public}d, offset=%{public}d,"
                          "bufferLength=%{public}d, transferredLength=%{public}d", __func__,
        g_scsiDeviceMemMap->address, g_scsiDeviceMemMap->size, g_scsiDeviceMemMap->offset,
        g_scsiDeviceMemMap->bufferLength, g_scsiDeviceMemMap->transferredLength);

    if (!BuildInquiryResult(env, result, inquiryInfo, response)) {
        return false;
    }

    OH_LOG_INFO(LOG_APP, "GetDeviceInfo success");
    return true;
}

static napi_value Inquiry(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter Inquiry\n");
    
    napi_value result = nullptr;
    if (DoInquiry(env, result)) {
        OH_LOG_INFO(LOG_APP, "DoInquiry success\n");
        return result;
    }
    OH_LOG_INFO(LOG_APP, "GetDeviceInfo failed\n");

    napi_value deviceInfo;
    napi_create_object(env, &deviceInfo);
    napi_value devTypeValue;
    napi_create_int32(env, 0, &devTypeValue);
    napi_set_named_property(env, deviceInfo, "devType", devTypeValue);
    napi_value vendorValue;
    CreateStringFromCString(env, "", &vendorValue);
    napi_set_named_property(env, deviceInfo, "vendor", vendorValue);
    napi_value productValue;
    CreateStringFromCString(env, "", &productValue);
    napi_set_named_property(env, deviceInfo, "product", productValue);
    napi_value revisionValue;
    CreateStringFromCString(env, "", &revisionValue);
    napi_set_named_property(env, deviceInfo, "revision", revisionValue);
    napi_value status;
    napi_create_int32(env, -1, &status);
    napi_value result1;
    napi_create_array(env, &result1);
    napi_set_element(env, result, 0, deviceInfo);
    napi_set_element(env, result, 1, status);
    return result;
}

static bool BuildReadCapacityResult(napi_env env, ScsiPeripheral_CapacityInfo& capacityInfo,
    ScsiPeripheral_Response& response, napi_value& result)
{
    napi_value address;
    if (napi_create_uint32(env, capacityInfo.lbAddress, &address) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_uint32 address failed", __func__);
        return false;
    }

    napi_value length;
    if (napi_create_uint32(env, capacityInfo.lbLength, &length) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_uint32 length failed", __func__);
        return false;
    }

    napi_value status;
    if (napi_create_int32(env, response.status, &status) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_uint32 status failed", __func__);
        return false;
    }

    if (napi_create_array(env, &result) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_array failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 0, address) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 0 failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 1, length) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 1 failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, NUM_TWO, status) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 2 failed", __func__);
        return false;
    }

    OH_LOG_INFO(LOG_APP, "ReadCapacity success\n");
    return true;
}

static bool DoReadCapacity(napi_env env, napi_callback_info info, napi_value& result)
{
    size_t argc = NUM_TWO;
    napi_value args[NUM_TWO] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < NUM_TWO) {
        OH_LOG_ERROR(LOG_APP, "ReadCapacity argc is invalid");
        return false;
    }

    uint32_t blockAddr = 0;
    napi_get_value_uint32(env, args[1], &blockAddr);
    OH_LOG_INFO(LOG_APP, "===ReadCapacity. blockAddr: %{public}u", blockAddr);

    ScsiPeripheral_ReadCapacityRequest readCapacityRequest;
    readCapacityRequest.lbAddress = blockAddr;
    readCapacityRequest.control = 0;
    readCapacityRequest.byte8 = 0;
    readCapacityRequest.timeout = REQUEST_TIMEOUT;
    ScsiPeripheral_CapacityInfo capacityInfo;
    ScsiPeripheral_Response response;

    int32_t ret = 0;
    // 获取开始时间点
    auto start = std::chrono::high_resolution_clock::now();
    // [Start driver_scsi_step6]
    ret = OH_ScsiPeripheral_ReadCapacity10(g_scsiPeripheralDevice, &readCapacityRequest, &capacityInfo, &response);
    // [End driver_scsi_step6]
    // 获取结束时间点
    auto end = std::chrono::high_resolution_clock::now();
    // 计算时间差，并转换为微秒
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
    // 打印时间差
    OH_LOG_INFO(LOG_APP, "%{public}s scsi read capacity time difference in milliseconds, duration:%{public}lld us",
        __func__, duration);

    if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ReadCapacity OH_ScsiPeripheral_ReadCapacity10 failed, ret = %{public}d\n", ret);
        return false;
    }
    OH_LOG_INFO(LOG_APP, "%{public}s success. %{public}zu, %{public}zu", __func__, capacityInfo,
        capacityInfo.lbLength);

    if (!BuildReadCapacityResult(env, capacityInfo, response, result)) {
        return false;
    }
    OH_LOG_INFO(LOG_APP, "ReadCapacity success\n");
    return true;
}

static napi_value ReadCapacity(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter ReadCapacity\n");
    
    napi_value result;
    if (DoReadCapacity(env, info, result)) {
        OH_LOG_INFO(LOG_APP, "DoReadCapacity success\n");
        return result;
    }
    OH_LOG_INFO(LOG_APP, "ReadCapacity failed\n");

    napi_value address;
    napi_create_uint32(env, 0, &address);
    napi_value length;
    napi_create_uint32(env, 0, &length);
    napi_value status;
    napi_create_int32(env, -1, &status);
    napi_value result1;
    napi_create_array(env, &result1);
    napi_set_element(env, result, 0, address);
    napi_set_element(env, result, 1, length);
    napi_set_element(env, result, NUM_TWO, status);
    return result;
}

static napi_value TestUnitReady(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter TestUnitReady\n");
    do {
        ScsiPeripheral_TestUnitReadyRequest request;
        request.timeout = REQUEST_TIMEOUT;
        ScsiPeripheral_Response response;
        // [Start driver_scsi_step4]
        int32_t ret = OH_ScsiPeripheral_TestUnitReady(g_scsiPeripheralDevice, &request, &response);
        // [End driver_scsi_step4]
        if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "TestUnitReady OH_ScsiPeripheral_TestUnitReady failed, ret = %{public}d\n", ret);
            break;
        }

        napi_value result;
        napi_create_int32(env, response.status, &result);
        OH_LOG_INFO(LOG_APP, "TestUnitReady success");
        return result;
    } while (false);

    OH_LOG_INFO(LOG_APP, "TestUnitReady failed\n");
    napi_value result;
    napi_create_int32(env, -1, &result);
    return result;
}

static bool ParseData(napi_env env, ScsiPeripheral_Response& response, napi_value& senseData,
    napi_value& parseSenseInfo)
{
    char *hexFormat = new char[MAX_SCSI_COUNT * SCSIPERIPHERAL_MAX_SENSE_DATA_LEN];
    memset(hexFormat, 0, MAX_SCSI_COUNT * SCSIPERIPHERAL_MAX_SENSE_DATA_LEN);
    if (IsAllZero(response.senseData, SCSIPERIPHERAL_MAX_SENSE_DATA_LEN)) {
        // 生成senseData napi_value
        ConvertHexDataToHexStr(hexFormat, response.senseData, SCSIPERIPHERAL_MAX_SENSE_DATA_LEN);
        napi_create_string_utf8(env, hexFormat, MAX_SCSI_COUNT * SCSIPERIPHERAL_MAX_SENSE_DATA_LEN, &senseData);

        // 生成senseInfo napi_value
        napi_create_string_utf8(env, "senseInfo: no data", NUM_NINETY, &parseSenseInfo);
    } else {
        // 解析senseData
        ScsiPeripheral_BasicSenseInfo senseInfo;
        memset(&senseInfo, 0x00, sizeof(ScsiPeripheral_BasicSenseInfo));
        // [Start driver_scsi_step8]
        int32_t ret = OH_ScsiPeripheral_ParseBasicSenseInfo(response.senseData, SCSIPERIPHERAL_MAX_SENSE_DATA_LEN,
            &senseInfo);
        // [End driver_scsi_step8]
        if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "RequestSense OH_ScsiPeripheral_ParseBasicSenseInfo failed, ret = %{public}d",
                         ret);
            if (hexFormat != nullptr) {
                delete [] hexFormat;
                hexFormat = nullptr;
            }
            return false;
        }
        OH_LOG_INFO(LOG_APP, "senseInfo:  responseCode= 0x%{public}x, valid=%{public}d, information=0x%{public}x, "
                             "commandSpecific=0x%{public}x, sksv=%{public}d, senseKeySpecific=0x%{public}x",
                    senseInfo.responseCode, senseInfo.valid, senseInfo.information,
                    senseInfo.commandSpecific, senseInfo.sksv, senseInfo.senseKeySpecific);

        // 拼接解析后的senseData,即senseInfo
        char buffer[PARSE_SENSE_DATA_MAX_LENGTH];
        memset(buffer, 0, sizeof(buffer));
        uint32_t num = 0;
        num = convertSenseInfoToSenseInfoStr(senseInfo, buffer, PARSE_SENSE_DATA_MAX_LENGTH);
        OH_LOG_INFO(LOG_APP, "RequestSense buffer: %{public}s", buffer);

        // 生成senseData napi_value
        ConvertHexDataToHexStr(hexFormat, response.senseData, SCSIPERIPHERAL_MAX_SENSE_DATA_LEN);
        napi_create_string_utf8(env, hexFormat, MAX_SCSI_COUNT * SCSIPERIPHERAL_MAX_SENSE_DATA_LEN, &senseData);

        // 生成senseInfo napi_value
        napi_create_string_utf8(env, buffer, num, &parseSenseInfo);
    }
    
    if (hexFormat != nullptr) {
        delete [] hexFormat;
        hexFormat = nullptr;
    }
    return true;
}

static bool DoRequestSense(napi_env env, napi_value& result)
{
    ScsiPeripheral_RequestSenseRequest senseRequest;
    senseRequest.allocationLength = SCSIPERIPHERAL_MAX_SENSE_DATA_LEN + 1;
    senseRequest.control = 0;
    senseRequest.byte1 = 0;
    senseRequest.timeout = REQUEST_TIMEOUT;
    ScsiPeripheral_Response response;
    memset(&response, 0x00, sizeof(ScsiPeripheral_Response));
    // [Start driver_scsi_step7]
    int32_t ret = OH_ScsiPeripheral_RequestSense(g_scsiPeripheralDevice, &senseRequest, &response);
    // [End driver_scsi_step7]
    if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "RequestSense OH_ScsiPeripheral_RequestSense failed, ret = %{public}d\n", ret);
        return false;
    }
        
    for (int i = 0; i < SCSIPERIPHERAL_MAX_SENSE_DATA_LEN; ++i) {
        OH_LOG_INFO(LOG_APP, "scsi request sense data: i:%{public}d, data:%{public}d", i, response.senseData[i]);
    }
    
    napi_value senseData = nullptr;
    napi_value parseSenseInfo = nullptr;
    if (!ParseData(env, response, senseData, parseSenseInfo)) {
        return false;
    }

    napi_value status;
    if (napi_create_int32(env, response.status, &status) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_uint32 status failed", __func__);
        return false;
    }
    
    if (napi_create_array(env, &result) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_array failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 0, senseData) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 0 failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 1, parseSenseInfo) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 1 failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, NUM_TWO, status) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 2 failed", __func__);
        return false;
    }

    OH_LOG_INFO(LOG_APP, "RequestSense success.\n");
    return true;
}

static napi_value RequestSense(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter RequestSense\n");
    
    napi_value result;
    if (DoRequestSense(env, result)) {
        OH_LOG_INFO(LOG_APP, "DoRequestSense success.\n");
        return result;
    }

    OH_LOG_INFO(LOG_APP, "RequestSense failed.\n");
    napi_value senseData;
    napi_create_string_utf8(env, "", 0, &senseData);
    napi_value parseSenseInfo;
    napi_create_string_utf8(env, "", 0, &parseSenseInfo);
    napi_value status;
    napi_create_int32(env, -1, &status);
    napi_value result1;
    napi_create_array(env, &result1);
    napi_set_element(env, result, 0, senseData);
    napi_set_element(env, result, 1, parseSenseInfo);
    napi_set_element(env, result, NUM_TWO, status);
    return result;
}

static bool BuildReadBlocksData(napi_env env, napi_value& result, ScsiPeripheral_Response& response)
{
    napi_value readData;
    char *hexFormat = new char[MAX_SCSI_COUNT * DEVICE_MEM_MAP_SIZE];
    memset(hexFormat, 0, MAX_SCSI_COUNT * DEVICE_MEM_MAP_SIZE);
    ConvertHexDataToHexStr(hexFormat, g_scsiDeviceMemMap->address, g_scsiDeviceMemMap->transferredLength);
    if (napi_create_string_utf8(env, hexFormat, MAX_SCSI_COUNT * g_scsiDeviceMemMap->transferredLength,
        &readData)!= napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_uint32 readData failed", __func__);
        if (hexFormat != nullptr) {
            delete [] hexFormat;
            hexFormat = nullptr;
        }
        return false;
    }
    
    if (hexFormat != nullptr) {
        delete [] hexFormat;
        hexFormat = nullptr;
    }

    napi_value status;
    if (napi_create_int32(env, response.status, &status) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_uint32 status failed", __func__);
        return false;
    }
    
    if (napi_create_array(env, &result) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_array failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 0, readData) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 0 failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 1, status) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 1 failed", __func__);
        return false;
    }
    return true;
}

static bool DoReadBlocksData(napi_env env, napi_callback_info info, napi_value& result)
{
    size_t argc = ARGC_SIZE;
    napi_value args[ARGC_SIZE] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARGC_SIZE) {
        OH_LOG_ERROR(LOG_APP, "ReadBlocksData argc is invalid");
        return false;
    }

    uint32_t blockAddr = 0;
    napi_get_value_uint32(env, args[1], &blockAddr);

    uint32_t blockNum = 0;
    napi_get_value_uint32(env, args[NUM_TWO], &blockNum);

    OH_LOG_INFO(LOG_APP, "%{public}s, blockAddr:%{public}d, blockNum:%{public}d", __func__, blockAddr, blockNum);
    ScsiPeripheral_IORequest request;
    request.lbAddress = blockAddr;
    request.transferLength = blockNum;
    request.control = 0;
    request.byte1 = 0;
    request.byte6 = 0;
    request.timeout = REQUEST_TIMEOUT;
    request.data = g_scsiDeviceMemMap;
    memset(g_scsiDeviceMemMap->address, 0x00, DEVICE_MEM_MAP_SIZE);
    ScsiPeripheral_Response response;
    // [Start driver_scsi_step9]
    int32_t ret = OH_ScsiPeripheral_Read10(g_scsiPeripheralDevice, &request, &response);
    // [End driver_scsi_step9]
    if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ReadBlocksData OH_ScsiPeripheral_Read10 failed, ret = %{public}d\n", ret);
        return false;
    }
    OH_LOG_INFO(LOG_APP, "%{public}s, read response duration:%{public}d", __func__, response.duration);

    OH_LOG_INFO(LOG_APP, "%{public}s, readData:%{public}s, size:%{public}d, transferredLength:%{public}d",
        __func__, (char *)(g_scsiDeviceMemMap->address),
        g_scsiDeviceMemMap->size, g_scsiDeviceMemMap->transferredLength);
    
    if (!BuildReadBlocksData(env, result, response)) {
        return false;
    }
    
    OH_LOG_INFO(LOG_APP, "ReadBlocksData success");
    return true;
}

static napi_value ReadBlocksData(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter ReadBlocksData\n");
    
    napi_value result;
    if (DoReadBlocksData(env, info, result)) {
        OH_LOG_INFO(LOG_APP, "DoReadBlocksData success\n");
        return result;
    }

    OH_LOG_INFO(LOG_APP, "ReadBlocksData failed\n");
    napi_value readData;
    napi_create_string_utf8(env, "", 0, &readData);
    napi_value status;
    napi_create_int32(env, -1, &status);
    napi_value result1;
    napi_create_array(env, &result1);
    napi_set_element(env, result, 0, readData);
    napi_set_element(env, result, 1, status);
    return result;
}

static napi_value WriteBlocksData(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter WriteBlocksData\n");
    do {
        size_t argc = MAX_SCSI_COUNT;
        napi_value args[MAX_SCSI_COUNT] = {nullptr};
        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
        if (argc < ARGC_SIZE) {
            OH_LOG_ERROR(LOG_APP, "ReadBlocksData argc is invalid");
            break;
        }

        uint32_t blockAddr = 0;
        napi_get_value_uint32(env, args[1], &blockAddr);

        uint32_t blockNum = 0;
        napi_get_value_uint32(env, args[NUM_TWO], &blockNum);

        size_t writeDataSize;
        napi_get_value_string_utf8(env, args[ARGC_SIZE], nullptr, 0, &writeDataSize);
        std::string writeData;
        writeData.resize(writeDataSize);
        napi_get_value_string_utf8(env, args[ARGC_SIZE], &writeData[0], writeDataSize + 1, nullptr);

        OH_LOG_DEBUG(LOG_APP, "%{public}s, writeData:%{public}s", __func__, writeData.data());
        memset(g_scsiDeviceMemMap->address, 0x00, DEVICE_MEM_MAP_SIZE);
        memcpy(g_scsiDeviceMemMap->address, writeData.data(), writeDataSize);
        ScsiPeripheral_IORequest request;
        request.lbAddress = blockAddr;
        request.transferLength = blockNum;
        request.control = 0;
        request.byte1 = 0;
        request.byte6 = 0;
        request.timeout = REQUEST_TIMEOUT;
        request.data = g_scsiDeviceMemMap;
        ScsiPeripheral_Response response;
        // [Start driver_scsi_step10]
        int32_t ret = OH_ScsiPeripheral_Write10(g_scsiPeripheralDevice, &request, &response);
        // [End driver_scsi_step10]
        if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "WriteBlocksData OH_ScsiPeripheral_Write10 failed, ret = %{public}d\n", ret);
            break;
        }
        OH_LOG_INFO(LOG_APP, "%{public}s, write response duration:%{public}d", __func__, response.duration);

        napi_value result;
        napi_create_int32(env, response.status, &result);
        OH_LOG_INFO(LOG_APP, "WriteBlocksData success.");
        return result;
    } while (false);

    OH_LOG_INFO(LOG_APP, "WriteBlocksData failed.\n");
    napi_value result;
    napi_create_int32(env, -1, &result);
    return result;
}

static napi_value VerifyBlocksData(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter VerifyBlocksData\n");
    do {
        size_t argc = ARGC_SIZE;
        napi_value args[ARGC_SIZE] = {nullptr};
        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
        if (argc < ARGC_SIZE) {
            OH_LOG_ERROR(LOG_APP, "ReadBlocksData argc is invalid");
            break;
        }

        uint32_t blockAddr = 0;
        napi_get_value_uint32(env, args[1], &blockAddr);

        uint32_t blockNum = 0;
        napi_get_value_uint32(env, args[NUM_TWO], &blockNum);

        ScsiPeripheral_VerifyRequest request;
        request.lbAddress = blockAddr;
        request.verificationLength = blockNum;
        request.timeout = REQUEST_TIMEOUT;
        ScsiPeripheral_Response response;
        // [Start driver_scsi_step11]
        int32_t ret = OH_ScsiPeripheral_Verify10(g_scsiPeripheralDevice, &request, &response);
        // [End driver_scsi_step11]
        if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "VerifyBlocksData OH_ScsiPeripheral_Verify10 failed, ret = %{public}d\n", ret);
            break;
        }

        napi_value result;
        napi_create_int32(env, response.status, &result);
        OH_LOG_INFO(LOG_APP, "VerifyBlocksData success");
        return result;
    } while (false);

    OH_LOG_INFO(LOG_APP, "VerifyBlocksData failed\n");
    napi_value result;
    napi_create_int32(env, -1, &result);
    return result;
}

static bool BuildSendCDBDataResult(napi_env env, napi_value& result, int32_t direction,
    ScsiPeripheral_Response& response)
{
    napi_value retData;
    napi_status retNapiStatus;
    char *hexFormat = new char[MAX_SCSI_COUNT * DEVICE_MEM_MAP_SIZE];
    memset(hexFormat, 0, MAX_SCSI_COUNT * DEVICE_MEM_MAP_SIZE);
    if (response.status == 0 && (direction == DIRECTION_ERROR || direction == DIRECTION_WARNING)) {
        ConvertHexDataToHexStr(hexFormat, g_scsiDeviceMemMap->address, g_scsiDeviceMemMap->transferredLength);
        retNapiStatus = napi_create_string_utf8(env, hexFormat,
            MAX_SCSI_COUNT * g_scsiDeviceMemMap->transferredLength, &retData);
    } else {
        retNapiStatus = napi_create_string_utf8(env, "", 0, &retData);
    }

    if (hexFormat != nullptr) {
        delete [] hexFormat;
        hexFormat = nullptr;
    }
    
    if (retNapiStatus != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_uint32 readData failed", __func__);
        return false;
    }

    napi_value status;
    if (napi_create_int32(env, response.status, &status) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_uint32 status failed", __func__);
        return false;
    }
    
    if (napi_create_array(env, &result) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_create_array failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 0, retData) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 0 failed", __func__);
        return false;
    }

    if (napi_set_element(env, result, 1, status) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s scsi napi_set_element 1 failed", __func__);
        return false;
    }
    OH_LOG_ERROR(LOG_APP, "%{public}s BuildSendCDBDataResult end", __func__);
    return true;
}

static bool BuildSendCDBDataReq(napi_env env, napi_callback_info info, int32_t& direction,
    ScsiPeripheral_Request& request)
{
    size_t argc = NUM_FIVE;
    napi_value args[NUM_FIVE] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < NUM_FIVE) {
        OH_LOG_ERROR(LOG_APP, "SendCDBData argc is invalid");
        return false;
    }

    uint32_t cmdDataLength;
    napi_get_array_length(env, args[1], &cmdDataLength);
    OH_LOG_INFO(LOG_APP, "SendCDBData cmdDataLength:%{public}d", cmdDataLength);

    for (size_t i = 0; i < cmdDataLength; ++i) {
        napi_value element;
        napi_get_element(env, args[1], i, &element);
        uint32_t elementValue;
        napi_get_value_uint32(env, element, &elementValue);
        OH_LOG_INFO(LOG_APP, "SendCDBData cmd[%{public}d]:[%{public}d]", i, elementValue);
    }

    uint32_t cmdLen = 0;
    napi_get_value_uint32(env, args[NUM_TWO], &cmdLen);
    OH_LOG_INFO(LOG_APP, "SendCDBData cmdLen:%{public}d", cmdLen);
    napi_get_value_int32(env, args[ARGC_SIZE], &direction);
    OH_LOG_INFO(LOG_APP, "SendCDBData direction:%{public}d", direction);
    size_t extraDataSize;
    napi_get_value_string_utf8(env, args[MAX_SCSI_COUNT], nullptr, 0, &extraDataSize);
    string extraData;
    extraData.resize(extraDataSize);
    napi_get_value_string_utf8(env, args[MAX_SCSI_COUNT], &extraData[0], extraDataSize + 1, nullptr);
    OH_LOG_INFO(LOG_APP, "SendCDBData extraDataSize:%{public}d, extraData:%{public}s",
        extraDataSize, extraData.data());
    memset(g_scsiDeviceMemMap->address, 0x00, DEVICE_MEM_MAP_SIZE);
    if (extraDataSize > 0) {
        memcpy(g_scsiDeviceMemMap->address, extraData.data(), extraDataSize);
    }
    
    request.cdbLength = cmdLen;
    for (int i = 0; i < SCSIPERIPHERAL_MAX_CMD_DESC_BLOCK_LEN && i < cmdDataLength; ++i) {
        napi_value element;
        napi_get_element(env, args[1], i, &element);
        uint32_t elementValue;
        napi_get_value_uint32(env, element, &elementValue);
        request.commandDescriptorBlock[i] = static_cast<int8_t>(elementValue);
    }
    request.dataTransferDirection = direction;
    request.timeout = REQUEST_TIMEOUT;
    request.data = g_scsiDeviceMemMap;
    
    return true;
}

static bool DoSendCDBData(napi_env env, napi_callback_info info, napi_value& result)
{
    ScsiPeripheral_Request request;
    int32_t direction = 0;
    if (!BuildSendCDBDataReq(env, info, direction, request)) {
        return false;
    }
    
    OH_LOG_INFO(LOG_APP, "SendCDBData request.cdbLength:%{public}d,", request.cdbLength);
    ScsiPeripheral_Response response;
    // [Start driver_scsi_step12]
    int32_t ret = OH_ScsiPeripheral_SendRequestByCdb(g_scsiPeripheralDevice, &request, &response);
    // [End driver_scsi_step12]
    if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "SendCDBData  OH_ScsiPeripheral_SendRequestByCdb failed, ret = %{public}d\n", ret);
        return false;
    }

    OH_LOG_INFO(LOG_APP, "%{public}s, retData:%{public}s, size:%{public}d, transferredLength:%{public}d, "
                         "status = %{public}d", __func__, (char *)(g_scsiDeviceMemMap->address),
        g_scsiDeviceMemMap->size, g_scsiDeviceMemMap->transferredLength, response.status);
    if (!BuildSendCDBDataResult(env, result, direction, response)) {
        return false;
    }
    
    OH_LOG_INFO(LOG_APP, "SendCDBData success");
    return true;
}

static napi_value SendCDBData(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter SendCDBData\n");
    
    napi_value result;
    if (DoSendCDBData(env, info, result)) {
        OH_LOG_INFO(LOG_APP, "%{public}s, DoSendCDBData success", __func__);
        return result;
    }
    
    OH_LOG_INFO(LOG_APP, "SendCDBData failed\n");
    napi_value retData;
    napi_create_string_utf8(env, "", 0, &retData);
    napi_value status;
    napi_create_int32(env, -1, &status);
    napi_value result1;
    napi_create_array(env, &result1);
    napi_set_element(env, result, 0, retData);
    napi_set_element(env, result, 1, status);
    return result;
}

static napi_value ReleaseResource(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter ReleaseResource\n");
    do {
        int32_t ret = SCSIPERIPHERAL_DDK_SUCCESS;
        if (g_scsiDeviceMemMap != nullptr) {
            // [Start driver_scsi_step13]
            ret = OH_ScsiPeripheral_DestroyDeviceMemMap(g_scsiDeviceMemMap);
            // [End driver_scsi_step13]
            if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
                OH_LOG_ERROR(LOG_APP, "OH_ScsiPeripheral_DestroyDeviceMemMap failed, ret = %{public}d\n", ret);
                break;
            }
            g_scsiDeviceMemMap = nullptr;
        }

        if (g_scsiPeripheralDevice != nullptr) {
            // [Start driver_scsi_step14]
            ret = OH_ScsiPeripheral_Close(&g_scsiPeripheralDevice);
            // [End driver_scsi_step14]
            if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
                OH_LOG_ERROR(LOG_APP, "OH_ScsiPeripheral_Close failed, ret = %{public}d\n", ret);
                break;
            }
            g_scsiPeripheralDevice = nullptr;
        }
        // [Start driver_scsi_step15]
        ret = OH_ScsiPeripheral_Release();
        // [End driver_scsi_step15]
        if (ret != SCSIPERIPHERAL_DDK_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "OH_ScsiPeripheral_Release failed, ret = %{public}d\n", ret);
            break;
        }
    } while (false);
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    OH_LOG_INFO(LOG_APP, "luobin1120 Init\n");
    napi_property_descriptor desc[] = {
        {"scsiInit", nullptr, ScsiInit, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"inquiry", nullptr, Inquiry, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"readCapacity", nullptr, ReadCapacity, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"testUnitReady", nullptr, TestUnitReady, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"requestSense", nullptr, RequestSense, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"readBlocksData", nullptr, ReadBlocksData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"writeBlocksData", nullptr, WriteBlocksData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"verifyBlocksData", nullptr, VerifyBlocksData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"sendCDBData", nullptr, SendCDBData, nullptr, nullptr, nullptr, napi_default, nullptr},
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
    printf("limabiao RegisterEntryModule enter\n");
    OH_LOG_INFO(LOG_APP, "limabiao RegisterEntryModule enter\n");
    napi_module_register(&demoModule);
}
