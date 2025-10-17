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

#include "data_parser.h"
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <hilog/log.h>
#include <usb_serial/usb_serial_types.h>

DataParser &DataParser::GetInstance() {
    static DataParser parser;
    return parser;
}

uint64_t DataParser::KeyValueToDeviceID(char *keyValue) {
    char *endptr;
    uint64_t deviceID = strtoull(keyValue, &endptr, 10);

    // 检查转换是否成功以及是否整个字符串都被解析
    if (*endptr != '\0' || keyValue == endptr) {
        OH_LOG_INFO(LOG_APP, "DeviceID must be a valid number string\n");
        return false;
    }
    return deviceID;
}

uint32_t DataParser::KeyValueToUint32OrUint8(char *keyValue) {
    char *end;
    unsigned long configData = std::strtoul(keyValue, &end, 10);

    // Check if the whole string was consumed and it's within uint32_t range.
    if (*end != '\0' || configData > UINT32_MAX) {
        OH_LOG_INFO(LOG_APP, "parers must be a valid number string\n");
    }
    return configData;
}

uint8_t DataParser::KeyValueToParity(char *keyValue) {
    if (strcmp(keyValue, "None") == 0) {
        return NONE;
    } else if (strcmp(keyValue, "Odd") == 0) {
        return ODD;
    } else if (strcmp(keyValue, "Even") == 0) {
        return EVEN;
    }
    return NONE;
}

void DataParser::UpdateKeyCodeMap(int key, char *keyValue) {
    switch (key) {
    case KEY_DEVICEID:
        deviceID_ = KeyValueToDeviceID(keyValue);
        break;
    case KEY_BAUDRATE:
        baudRate_ = KeyValueToUint32OrUint8(keyValue);
        break;
    case KEY_DATABITS:
        nDataBits_ = KeyValueToUint32OrUint8(keyValue);
        break;
    case KEY_STOPBITS:
        nStopBits_ = KeyValueToUint32OrUint8(keyValue);
        break;
    case KEY_PARITY:
        parity_ = KeyValueToParity(keyValue);
        break;
    case KEY_FLOW_CONTROL:
        flowControl_ = KeyValueToUint32OrUint8(keyValue);
        break;
    default:
        OH_LOG_INFO(LOG_APP, "key:%{public}d is incorrect", key);
        break;
    }
}

uint64_t DataParser::GetDeviceID() { return deviceID_; }

uint32_t DataParser::GetBaudRate() { return baudRate_; }

uint8_t DataParser::GetDataBits() { return nDataBits_; }

uint8_t DataParser::GetStopBits() { return nStopBits_; }

uint8_t DataParser::GetParity() { return parity_; }

uint8_t DataParser::GetFlowControl() { return flowControl_; }

UsbSerial_Device *DataParser::GetSerialObject() { return serial_; }

void DataParser::SetSerialObject(UsbSerial_Device *devHandle) { this->serial_ = devHandle; }

double DataParser::ParseData(const uint8_t *buff, uint32_t length) {
    // 检查输入是否有效
    if (buff == nullptr) {
        OH_LOG_INFO(LOG_APP, "buff is null\n");
    }

    // 提取第5位和第6位（即数组索引4和5）
    uint8_t highByte = buff[3];
    uint8_t lowByte = buff[4];
    OH_LOG_INFO(LOG_APP, "highByte=%{public}d lowByte=%{public}d\n", highByte, lowByte);
    // 组合成16位整数
    int16_t temperatureRaw = (static_cast<int16_t>(highByte) << 8) | lowByte;
    // 判断正负
    if (highByte >= 0x08) {
        // 负数处理
        temperatureRaw = temperatureRaw - 65536;
    }

    // 将16进制转换为10进制并除以10得到温度值
    double temperature = static_cast<double>(temperatureRaw) / temperatureBase;
    return temperature;
}