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

#define LOG_TAG "testTag [NATIVE]"

#include "data_parser.h"
#include "parse_point_info.h"
#include <hilog/log.h>

#define MIN_BUFFER_SIZE 10
#define ABSX_MAX_A13F (0x5750)
#define ABSY_MAX_A13F (0x3692)
#define ABSX_MAX_A153 (0x6338)
#define ABSY_MAX_A153 (0x6338)

static int g_absXMax = 1;
static int g_absYMax = 1;

static bool g_isKeyDown = false;
static bool g_isPenDown = false;
static bool g_isRightKeyDown = false;
static int g_direct = 1;
static int g_keyIndex = -1;
constexpr int NUM_TWO = 2;
constexpr int NUM_THREE = 3;
constexpr int NUM_FOUR = 4;
constexpr int NUM_SIX = 6;

#define HANDWRITING_ABSPRESSURE_MAX 8191

char g_outStr[256] = {0};
static void PrintBuffer(const uint8_t *buffer, uint32_t length)
{
    int32_t index = 0;
    for (uint32_t idx = 0; idx < length; ++idx) {
        index += sprintf(g_outStr + index, "%02X ", buffer[idx]);
    }
    OH_LOG_DEBUG(LOG_APP, "recv data len: %{public}u : %{public}s", length, g_outStr);
}

static void Reset()
{
    g_isKeyDown = false;
    g_isPenDown = false;
}

// 单例
DataParser &DataParser::GetInstance()
{
    static DataParser parser;
    return parser;
}

void DataParser::Init(int vid, int pid)
{
    if (pid == 0xA13F) {
        g_absXMax = ABSX_MAX_A13F;
        g_absYMax = ABSY_MAX_A13F;
    } else if (pid == 0xA150 || pid == 0xA153) {
        g_absXMax = ABSX_MAX_A153;
        g_absYMax = ABSY_MAX_A153;
    } else {
        OH_LOG_ERROR(LOG_APP, "invalid vid:%{public}x & pid:%{public}x", vid, pid);
    }
    g_isKeyDown = false;
    g_isPenDown = false;
    g_isRightKeyDown = false;
    g_keyIndex = -1;
}

void DataParser::StartWork()
{
    simulator_.StartWork();
}

// 更新按键映射键值
void DataParser::UpdateKeyCodeMap(int keyIndex, int keyValue)
{
    keyCodeMap_[keyIndex] = keyValue;
}

void DataParser::SetScreenSize(int screenWidth, int screenHeight)
{
    screenWidth_ = screenWidth;
    screenHeight_ = screenHeight;
}

void DataParser::GetAbsMax(int32_t &absXMax, int32_t &absYMax, int32_t &absPressureMax)
{
    if (screenWidth_ > screenHeight_) {
        absXMax = g_absXMax;
        absYMax = g_absYMax;
    } else {
        absXMax = g_absYMax;
        absYMax = g_absXMax;
    }
    absPressureMax = HANDWRITING_ABSPRESSURE_MAX;
}

// 根据屏幕宽高，调整手写板方向
void DataParser::ConvertAbs(uint32_t &absX, uint32_t &absY)
{
    float temp = 0;
    switch (g_direct) {
        case 1: // 手写板 90度
            temp = absX;
            absX = (static_cast<float>(absY) / g_absYMax * g_absXMax);
            absY = (static_cast<float>(g_absXMax - temp) / g_absXMax * g_absYMax);
            break;
        case NUM_TWO: // 手写板 180度
            absX = g_absXMax - absX;
            absY = g_absYMax - absY;
            break;
        case NUM_THREE: // 手写板 270度
            temp = absY;
            absY = (static_cast<float>(absX) / g_absXMax * g_absYMax);
            absX = (static_cast<float>(g_absYMax - temp) / g_absYMax * g_absXMax);
            break;
        default:
            break;
    }
}

void DataParser::SetDirection(uint32_t direction)
{
    g_direct = direction;
}

uint32_t DataParser::GetDirection()
{
    return g_direct;
}

int32_t DataParser::ParseKeyData(const uint8_t *buffer, uint32_t length)
{
    g_isKeyDown = true;
    if (buffer[NUM_THREE] == 0x1) {
        g_keyIndex = 0;
    } else if (buffer[NUM_THREE] == 0x2) {
        g_keyIndex = 1;
    } else if (buffer[NUM_THREE] == 0x4) {
        g_keyIndex = NUM_TWO;
    } else if (buffer[NUM_THREE] == 0x8) {
        g_keyIndex = NUM_THREE;
    } else {
        g_isKeyDown = false;
        if (g_keyIndex == -1) {
            g_keyIndex = 0;
        }
    }
    eventData_.type = EVENT_TYPE_KEY;
    eventData_.changed = true;
    eventData_.isDown = g_isKeyDown;
    eventData_.keyVal = keyCodeMap_[g_keyIndex];
    return 0;
}

int32_t DataParser::ParsePenKeyData(const uint8_t *buffer, uint32_t length)
{
    // 按下按键，或者抬起按键时，buffer[1] = 0，其他时刻是2
    if (buffer[1] == 0) {
        g_isRightKeyDown = !g_isRightKeyDown;
        eventData_.changed = true;
    }
    uint32_t xOffset = *reinterpret_cast<const uint16_t*>(&buffer[NUM_TWO]);
    uint32_t yOffset = *reinterpret_cast<const uint16_t*>(&buffer[NUM_FOUR]);
    ConvertAbs(xOffset, yOffset);
    if (eventData_.changed) {
        eventData_.type = EVENT_TYPE_PEN_KEY;
        eventData_.isDown = g_isRightKeyDown;
    } else {
        eventData_.type = EVENT_TYPE_MOVE;
        eventData_.isDown = false;
    }
    eventData_.absX = xOffset;
    eventData_.absY = yOffset;
    return 0;
}

bool DataParser::IsPenUp(const uint8_t *buffer, uint32_t length)
{
    // 笔是否接触到手写板，接触到则为1，不接触到则为0
    return (length < MIN_BUFFER_SIZE || buffer[1] != 0xA1);
}

bool DataParser::IsPenMove(const uint8_t *buffer, uint32_t length)
{
    return (length >= MIN_BUFFER_SIZE && buffer[0] == 0x03);
}

int32_t DataParser::ParseMoveData(const uint8_t *buffer, uint32_t length)
{
    // 笔是否接触到手写板，接触到则为1，不接触到则为0
    bool downState = (buffer[1] == 0xA1);
    if (g_isPenDown != downState) {
        eventData_.changed = true;
        g_isPenDown = downState;
    }

    // x offset
    uint32_t xOffset = *reinterpret_cast<const uint16_t*>(&buffer[NUM_TWO]);

    // y offset
    uint32_t yOffset = *reinterpret_cast<const uint16_t*>(&buffer[NUM_FOUR]);

    // press
    uint16_t pressValue = *reinterpret_cast<const uint16_t*>(&buffer[NUM_SIX]);

    ConvertAbs(xOffset, yOffset);
    eventData_.type = EVENT_TYPE_MOVE;
    eventData_.absX = xOffset;
    eventData_.absY = yOffset;
    eventData_.isDown = g_isPenDown;
    eventData_.pressVal = pressValue;
    return 0;
}

int32_t DataParser::ParsePrivateData(const uint8_t *buffer, uint32_t length)
{
    auto [withinRange, x, y, pressure, btnRight] = ParsePointInfo(buffer);
    // 1 笔到达时清理现场
    if (!withinRange) {
        if (btnRight) {
            OH_LOG_INFO(LOG_APP, "Pen is comming");
            Reset();
        } else {
            OH_LOG_INFO(LOG_APP, "Pen is leave");
        }
        return -1;
    }
    OH_LOG_ERROR(LOG_APP, "withinRange:%{public}d btnRight:%{public}d g_isRightKeyDown:%{public}d", withinRange,
                 btnRight, g_isRightKeyDown);
    // 如果笔上按键动作变化，则发送 EVENT_TYPE_PEN_KEY
    if (g_isRightKeyDown != btnRight) {
        eventData_.changed = true;
        g_isRightKeyDown = btnRight;
        eventData_.isDown = g_isRightKeyDown;
        eventData_.type = EVENT_TYPE_PEN_KEY;
    } else {
        bool downState = (pressure > 0);
        if (g_isPenDown != downState) {
            eventData_.changed = true;
            g_isPenDown = downState;
        }
        eventData_.isDown = g_isPenDown;
        eventData_.type = EVENT_TYPE_MOVE;
    }
    ConvertAbs(x, y);
    eventData_.absX = x;
    eventData_.absY = y;
    eventData_.pressVal = pressure;
    return 0;
}

int32_t DataParser::ParseData(const uint8_t *buffer, uint32_t length)
{
    PrintBuffer(buffer, length);
    if (length < MIN_BUFFER_SIZE) {
        OH_LOG_ERROR(LOG_APP, "invalid length");
        return -1;
    }
    int ret = -1;
    if (buffer[0] == 0x03) { // 笔的移动或者按下事件
        ret = ParseMoveData(buffer, length);
    } else if (buffer[0] == 0x0c) { // 按键的按下或者抬起事件
        ret = ParseKeyData(buffer, length);
    } else if (buffer[0] == 0x1) { // 笔上的按键，无法区分上下键
        ret = ParsePenKeyData(buffer, length);
    } else if (buffer[0] == 0x2) { // 私有协议
        ret = ParsePrivateData(buffer, length);
    } else {
        OH_LOG_INFO(LOG_APP, "recv not interesting data");
    }
    OH_LOG_INFO(LOG_APP, "type:%{public}d,isDown:%{public}d,press:%{public}d,x:%{public}d,y:%{public}d,key:%{public}d",
                eventData_.type, eventData_.isDown, eventData_.pressVal, eventData_.absX, eventData_.absY,
                eventData_.keyVal);
    if (ret == 0) {
        simulator_.ConvertEventData(eventData_);
    }
    lastData_ = eventData_;
    eventData_.Reset();
    return ret;
}
