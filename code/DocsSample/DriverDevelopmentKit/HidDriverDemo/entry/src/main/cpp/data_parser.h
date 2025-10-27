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

#include <hid/hid_ddk_types.h>
#include <hid/hid_ddk_api.h>

#include <cstdint>
#include <map>
#include <string>
#include <filesystem>

using namespace std;
namespace fs = std::filesystem;

#define FILE_NAME fs::path(__FILE__).filename().string().c_str()
#define READ_INPUT_ARRAY_LEN 9

struct KeysState {
    bool states[8];
    string keys;
};

struct KeysSetting {
    std::map<std::string, bool> led;
};

class DataParser {
  public:
    DataParser() = default;

    virtual ~DataParser() = default;

    static DataParser &GetInstance();

    bool CheckIfZeroArray(const uint8_t *buff, uint32_t length);
    
    virtual KeysState ParseKeys(const uint8_t *buffer, uint32_t length, bool bRead);

    void Init();

    void UpdateKeyCodeMap(uint64_t deviceID);
    void UpdateHid(Hid_DeviceHandle *hid);
    void UpdateHid2(Hid_DeviceHandle *hid2);
    
    uint32_t StartWork();
    
    Hid_DeviceHandle *getHidObject();
    Hid_DeviceHandle *getHid2Object();

  private:
    uint64_t deviceID_;
    Hid_DeviceHandle *hid_;
    Hid_DeviceHandle *hid2_;
    unordered_map<uint8_t, string> inputContentMap;
    
    void InitLetter();
    void InitSpecialChar();
};

#endif // DATA_PARSER_H
