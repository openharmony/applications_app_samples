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

#ifndef DATA_PARSER_H
#define DATA_PARSER_H

#include <usb_serial/usb_serial_api.h>
#include <cstdint>

enum KeyCode {
    KEY_BAUDRATE = 0,
    KEY_DATABITS,
    KEY_STOPBITS,
    KEY_PARITY,
    KEY_FLOW_CONTROL,
    KEY_DEVICEID,
};

enum ParityCode {
    NONE = 0,
    ODD,
    EVEN,
};

const uint32_t TEMPERATURE_BASE = 10;

class DataParser {
public:
    DataParser() = default;

    virtual ~DataParser() = default;

    static DataParser &GetInstance();

    // 解析数据
    double ParseData(const uint8_t *buffer, uint32_t length);

    // 设置keycode map
    void UpdateKeyCodeMap(int key, char *keyValue);

    UsbSerial_Device *GetSerialObject();
    void SetSerialObject(UsbSerial_Device *devHandle);
    uint64_t GetDeviceID();
    uint32_t GetBaudRate();
    uint8_t GetDataBits();
    uint8_t GetStopBits();
    uint8_t GetParity();
    uint8_t GetFlowControl();

private:
    uint64_t KeyValueToDeviceID(char *keyValue);
    uint32_t KeyValueToUint32OrUint8(char *keyValue);
    uint8_t KeyValueToParity(char *keyValue);

private:
    uint64_t deviceID_;
    uint32_t baudRate_;
    uint8_t nDataBits_;
    uint8_t nStopBits_;
    uint8_t parity_;
    uint8_t flowControl_;
    UsbSerial_Device *serial_;
};

#endif // DATA_PARSER_H
