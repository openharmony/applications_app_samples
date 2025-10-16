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

#include "hid_simulator.h"

#define MAX_KEY_NUM 4

class DataParser {
  public:
    DataParser() = default;

    virtual ~DataParser() = default;

    static DataParser &GetInstance();
    
    void Init(int vid, int pid);

    // 解析数据
    virtual int32_t ParseData(const uint8_t *buffer, uint32_t length);

    virtual bool IsPenUp(const uint8_t *buffer, uint32_t length);

    virtual bool IsPenMove(const uint8_t *buffer, uint32_t length);

    // 设置keycode map
    void UpdateKeyCodeMap(int keyIndex, int keyValue);

    // 设置屏幕宽高
    void SetScreenSize(int screenWidth, int screenHeight);
    
    void GetAbsMax(int32_t &absXMax, int32_t &absYMax, int32_t &absPressureMax);
    
    void SetDirection(uint32_t direction);
    
    uint32_t GetDirection();

    // 开启EmitEvent
    void StartWork();

  private:
    int32_t ParseKeyData(const uint8_t *buffer, uint32_t length);

    int32_t ParseMoveData(const uint8_t *buffer, uint32_t length);

    int32_t ParsePenKeyData(const uint8_t *buffer, uint32_t length);

    int32_t ParseEventData(const uint8_t *buffer, uint32_t length);

    int32_t ParsePrivateData(const uint8_t *buffer, uint32_t length);

    void ConvertAbs(uint32_t &absX, uint32_t &absY);
    
  private:
    int screenWidth_;
    int screenHeight_;
    EventData eventData_;
    EventData lastData_;
    int keyCodeMap_[MAX_KEY_NUM];
    HidSimulator simulator_;
};

#endif // DATA_PARSER_H
