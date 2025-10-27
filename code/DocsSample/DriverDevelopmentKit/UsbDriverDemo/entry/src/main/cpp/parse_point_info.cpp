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

#include "parse_point_info.h"

// return 执行结果，x轴坐标，y轴坐标，压力值
std::tuple<bool, uint32_t, uint32_t, uint32_t, bool> ParsePointInfo(const uint8_t* buffer)
{
    // 笔离开
    if (buffer[1] == 0x80) {
        return {false, 0, 0, 0, false};
    } else if (buffer[1] == 0xC2) {
        return {false, 0, 0, 0, true};
    }

    bool btnRight = ((buffer[1] & 0x04) != 0);

    uint32_t x = ((buffer[2] << 8) | buffer[3]);
    uint32_t y = ((buffer[4] << 8) | buffer[5]);
    // 压力值第2位
    uint8_t tmp2 = buffer[1] & 0x01;
    // 压力值第1位
    uint8_t tmp1 = buffer[1] & 0x10;
    uint32_t pressure = (((buffer[7] >> 6) | buffer[6] << 2) << 3) | (tmp2 << 2) | (tmp1 >> 3) |
        ((buffer[1] & 0x08) >> 3);
    return {true, x, y, pressure, btnRight};
}
