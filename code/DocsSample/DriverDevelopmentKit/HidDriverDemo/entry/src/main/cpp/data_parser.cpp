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
#include <hilog/log.h>

#define LOG_TAG "hidTag [NATIVE]"

const int NUM_TWO = 2;
const int NUM_FOUR = 4;
const int NUM_SIX = 6;
const int NUM_SIXTY_FOUR = 64;

DataParser &DataParser::GetInstance()
{
    static DataParser parser;
    return parser;
}

uint32_t DataParser::StartWork()
{
    // [Start driver_hid_report_step1]
    // 初始化HID DDK
    int32_t ret = OH_Hid_Init();
    if (ret != HID_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Hid_Init() return failed: %{public}d", ret);
        return ret;
    }
    // [End driver_hid_report_step1]
    
    // [Start driver_hid_report_step2]
    uint32_t bInterfaceNum1 = 0x00;
    // 打开deviceId和interfaceIndex1指定的HID设备（一般为/dev/hidraw0设备文件）
    ret = OH_Hid_Open(deviceID_, bInterfaceNum1, &hid_);
    if (ret != 0) {
        OH_LOG_ERROR(LOG_APP, "Failed to open hid device, interface number:%{public}u ret:%{public}d",
            bInterfaceNum1, ret);
        return ret;
    }
    uint32_t bInterfaceNum2 = 0x01;
    // 打开deviceId和interfaceIndex2指定的HID设备（一般为/dev/hidraw1设备文件）
    ret = OH_Hid_Open(deviceID_, bInterfaceNum2, &hid2_);
    if (ret != 0) {
        OH_LOG_ERROR(LOG_APP, "Failed to open hid device, interface number:%{public}u ret:%{public}d",
            bInterfaceNum2, ret);
        return ret;
    }
    // [End driver_hid_report_step2]

    Init();
    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s hid device initialized successfully", FILE_NAME, __LINE__,
                __func__);
    return ret;
}

bool DataParser::CheckIfZeroArray(const uint8_t *buff, uint32_t length)
{
    uint8_t zeroBuff[READ_INPUT_ARRAY_LEN] = {0x00};
    for (int i = 0; i < length; i++) {
        if (zeroBuff[i] != buff[i]) {
            return false;
        }
    }
    
    return true;
}

KeysState DataParser::ParseKeys(const uint8_t *buff, uint32_t length, bool bRead)
{
    // 检查输入是否有效
    if (buff == nullptr || length == 0) {
        OH_LOG_ERROR(LOG_APP, "buff is null or length is invalid");
        exit(0);
    }

    char hexFormat[NUM_SIXTY_FOUR];
    int32_t num = 0;
    for (int i = 0; i < length; i++) {
        num += sprintf(hexFormat + num, "%02X ", buff[i]);
    }

    OH_LOG_INFO(LOG_APP, "[%{public}s:%{public}d] %{public}s %{public}s", FILE_NAME, __LINE__, __func__, hexFormat);

    int baseIndex = 0;
    if (!bRead) {
        baseIndex = 1;
    }
	
    KeysState result = { 0x00 };
    for (int i = 0; i < sizeof(result.states) / sizeof(result.states[0]); i++) {
        if (buff[baseIndex] & (1 << i)) {
            result.states[i] = true;
        } else {
            result.states[i] = false;
        }
    }

    uint8_t code = 0;
    bool bNotFirst = false;
    bool bHasValidData = false;
    for (int i = 0; i < NUM_SIX; i++) {
        code = buff[i + NUM_TWO + baseIndex];
        if (code >= NUM_FOUR && code <= 0x65 && code != 0x32 && code != 0x64) {
            if (bNotFirst) {
                result.keys.append("    ");
            }
            result.keys.append(inputContentMap[code]);
            bHasValidData = true;
        }
        bNotFirst = true;
    }
    
    if (!bHasValidData) {
        result.keys.append("未输入有效数据");
    }

    return result;
}

void DataParser::UpdateKeyCodeMap(uint64_t deviceID)
{
    deviceID_ = deviceID;
}

void DataParser::UpdateHid(Hid_DeviceHandle *hid)
{
    hid_ = hid;
}

void DataParser::UpdateHid2(Hid_DeviceHandle *hid2)
{
    hid2_ = hid2;
}

Hid_DeviceHandle *DataParser::getHidObject()
{
    return hid_;
}

Hid_DeviceHandle *DataParser::getHid2Object()
{
    return hid2_;
}

void DataParser::Init()
{
    inputContentMap.clear();
    
    InitLetter();
    InitSpecialChar();
    
    vector<pair<uint8_t, string>> vec = {
        {0x53, "NumLockSmallKeyboard"},
        {0x54, "/SmallKeyboard"},
        {0x55, "*SmallKeyboard"},
        {0x56, "-SmallKeyboard"},
        {0x57, "+SmallKeyboard"},
        {0x58, "回车SmallKeyboard"},
        {0x59, "1SmallKeyboard"},
        {0x5a, "2SmallKeyboard"},
        {0x5b, "3SmallKeyboard"},
        {0x5c, "4SmallKeyboard"},
        {0x5d, "5SmallKeyboard"},
        {0x5e, "6SmallKeyboard"},
        {0x5f, "7SmallKeyboard"},
        {0x60, "8SmallKeyboard"},
        {0x61, "9SmallKeyboard"},
        {0x62, "0SmallKeyboard"},
        {0x63, ".SmallKeyboard"},
        {0x65, "目字键"},
    };
    inputContentMap.insert(vec.begin(), vec.end());
}

void DataParser::InitLetter()
{
    vector<pair<uint8_t, string>> vec = {
        {4, "a"},
        {5, "b"},
        {6, "c"},
        {7, "d"},
        {8, "e"},
        {9, "f"},
        {0xa, "g"},
        {0xb, "h"},
        {0xc, "i"},
        {0xd, "j"},
        {0xe, "k"},
        {0xf, "l"},
        {0x10, "m"},
        {0x11, "n"},
        {0x12, "o"},
        {0x13, "p"},
        {0x14, "q"},
        {0x15, "r"},
        {0x16, "s"},
        {0x17, "t"},
        {0x18, "u"},
        {0x19, "v"},
        {0x1a, "w"},
        {0x1b, "x"},
        {0x1c, "y"},
        {0x1d, "z"},
        {0x1e, "1"},
        {0x1f, "2"},
        {0x20, "3"},
        {0x21, "4"},
        {0x22, "5"},
        {0x23, "6"},
        {0x24, "7"},
        {0x25, "8"},
        {0x26, "9"},
        {0x27, "0"},
    };
    inputContentMap.insert(vec.begin(), vec.end());
}

void DataParser::InitSpecialChar()
{
    vector<pair<uint8_t, string>> vec = {
        {0x28, "回车"},
        {0x29, "Esc"},
        {0x2a, "BackSpace"},
        {0x2b, "Tab"},
        {0x2c, "空格"},
        {0x2d, "-"},
        {0x2e, "="},
        {0x2f, "["},
        {0x30, "]"},
        {0x31, "\\"},
        {0x33, ";"},
        {0x34, "''"},
        {0x35, "``"},
        {0x36, ","},
        {0x37, "."},
        {0x38, "/"},
        {0x39, "CapsLock"},
        {0x3a, "F1"},
        {0x3b, "F2"},
        {0x3c, "F3"},
        {0x3d, "F4"},
        {0x3e, "F5"},
        {0x3f, "F6"},
        {0x40, "F7"},
        {0x41, "F8"},
        {0x42, "F9"},
        {0x43, "F10"},
        {0x44, "F11"},
        {0x45, "F12"},
        {0x46, "PrintScreen"},
        {0x47, "ScrollLock"},
        {0x48, "PauseBreak"},
        {0x49, "Insert"},
        {0x4a, "Home"},
        {0x4b, "PageUp"},
        {0x4c, "Delete"},
        {0x4d, "End"},
        {0x4e, "PageDown"},
        {0x4f, "Right"},
        {0x50, "Left"},
        {0x51, "Down"},
        {0x52, "Up"},
    };
    inputContentMap.insert(vec.begin(), vec.end());
}