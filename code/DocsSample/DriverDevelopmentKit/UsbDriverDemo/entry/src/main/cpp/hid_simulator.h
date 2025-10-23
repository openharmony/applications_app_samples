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

#ifndef HID_SIMULATOR_H
#define HID_SIMULATOR_H

#include "inject_thread.h"

enum EventType {
    EVENT_TYPE_INVALID,
    EVENT_TYPE_KEY,
    EVENT_TYPE_MOVE,
    EVENT_TYPE_PEN_KEY,
};

struct EventData {
    EventType type;
    int32_t keyVal;
    uint32_t absX{0};
    uint32_t absY{0};
    uint32_t pressVal{0};
    bool changed{false};
    bool isDown{false}; // 按键是否按下，手写笔是否接触
    void Reset()
    {
        type = EVENT_TYPE_INVALID;
        keyVal = 0;
        absX = 0;
        absY = 0;
        pressVal = 0;
        changed = false;
        isDown = false;
    }
};

class HidSimulator {
  public:
    HidSimulator();
    virtual ~HidSimulator() = default;
    
    void StartWork();
    
    void ConvertEventData(const EventData &data);

    void ConvertMoveEventData(const EventData &data);

    void ConvertPenKeyEventData(const EventData &data);

    void ConvertKeyEventData(const EventData &data);

  private:
    std::unique_ptr<InjectThread> injectThread_;
    EventData eventData_;
};

#endif // handwriting-board_private_protocol_H
