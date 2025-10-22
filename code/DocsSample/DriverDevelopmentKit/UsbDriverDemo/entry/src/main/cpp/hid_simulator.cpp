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

#include "hid_simulator.h"
#include "data_parser.h"
#include <linux/input.h>
#include <linux/input-event-codes.h>
#include "key_code.h"

#define DOWN 1
#define UP 0U

Hid_EmitItem synEvent = {.type = EV_SYN, .code = SYN_REPORT, .value = 0};

static const uint16_t GetLittleKeyCode(int ohosKeyCode)
{
    switch (ohosKeyCode) {
        case KEYCODE_A: return KEY_A;
        case KEYCODE_B: return KEY_B;
        case KEYCODE_C: return KEY_C;
        case KEYCODE_D: return KEY_D;
        case KEYCODE_E: return KEY_E;
        case KEYCODE_F: return KEY_F;
        case KEYCODE_G: return KEY_G;
        case KEYCODE_H: return KEY_H;
        case KEYCODE_I: return KEY_I;
        case KEYCODE_J: return KEY_J;
        case KEYCODE_K: return KEY_K;
        case KEYCODE_L: return KEY_L;
        case KEYCODE_M: return KEY_M;
        case KEYCODE_N: return KEY_N;
        case KEYCODE_O: return KEY_O;
        case KEYCODE_P: return KEY_P;
        case KEYCODE_Q: return KEY_Q;
        case KEYCODE_R: return KEY_R;
        case KEYCODE_S: return KEY_S;
        case KEYCODE_T: return KEY_T;
        case KEYCODE_U: return KEY_U;
        case KEYCODE_V: return KEY_V;
        case KEYCODE_W: return KEY_W;
        case KEYCODE_X: return KEY_X;
        case KEYCODE_Y: return KEY_Y;
        case KEYCODE_Z: return KEY_Z;
        case KEYCODE_1: return KEY_1;
        case KEYCODE_2: return KEY_2;
        case KEYCODE_3: return KEY_3;
        case KEYCODE_4: return KEY_4;
        case KEYCODE_5: return KEY_5;
        case KEYCODE_6: return KEY_6;
        case KEYCODE_7: return KEY_7;
        case KEYCODE_8: return KEY_8;
        case KEYCODE_9: return KEY_9;
        case KEYCODE_0: return KEY_0;
        default: return KEY_UNKNOWN;
    }
}

static const uint16_t GetLinuxKeyCode(int ohosKeyCode)
{
    switch (ohosKeyCode) {
        case KEYCODE_UNKNOWN: return KEY_UNKNOWN;
        case KEYCODE_BACK: return KEY_BACKSPACE;
        case KEYCODE_SPACE: return KEY_SPACE;
        case KEYCODE_DEL: return KEY_DELETE;
        case KEYCODE_ESCAPE: return KEY_ESC;
        case KEYCODE_SYSRQ: return KEY_SYSRQ;
        case KEYCODE_ENTER: return KEY_ENTER;
        case KEYCODE_SHIFT_LEFT: return KEY_LEFTSHIFT;
        case KEYCODE_SHIFT_RIGHT: return KEY_RIGHTSHIFT;
        case KEYCODE_BRIGHTNESS_DOWN: return KEY_BRIGHTNESSDOWN;
        case KEYCODE_BRIGHTNESS_UP: return KEY_BRIGHTNESSUP;
        case KEYCODE_MUTE: return KEY_MUTE;
        case KEYCODE_VOLUME_DOWN: return KEY_VOLUMEDOWN;
        case KEYCODE_VOLUME_UP: return KEY_VOLUMEUP;
        default: return GetLittleKeyCode(ohosKeyCode);
    }
}

HidSimulator::HidSimulator()
{
    injectThread_ = std::make_unique<InjectThread>();
}

void HidSimulator::StartWork()
{
    injectThread_->Start();
}

void HidSimulator::ConvertEventData(const EventData &data)
{
    if (data.type == EVENT_TYPE_MOVE) {
        ConvertMoveEventData(data);
    } else if (data.type == EVENT_TYPE_PEN_KEY) {
        ConvertPenKeyEventData(data);
    } else if (data.type == EVENT_TYPE_KEY) {
        ConvertKeyEventData(data);
    }
    injectThread_->Sync();
    eventData_ = data;
}

void HidSimulator::ConvertMoveEventData(const EventData &data)
{
    if (data.changed) {
        Hid_EmitItem event = {.type = EV_MSC, .code = MSC_SCAN, .value = 0x000d0042};
        injectThread_->InjectEvent(DEV_TOUCH_PAD, event);
        event = {.type = EV_KEY, .code = BTN_TOUCH, .value = data.isDown ? DOWN : UP};
        injectThread_->InjectEvent(DEV_TOUCH_PAD, event);
    }
    if (data.absX != eventData_.absX) {
        Hid_EmitItem event = {.type = EV_ABS, .code = ABS_X, .value = data.absX};
        injectThread_->InjectEvent(DEV_TOUCH_PAD, event);
    }
    if (data.absY != eventData_.absY) {
        Hid_EmitItem event = {.type = EV_ABS, .code = ABS_Y, .value = data.absY};
        injectThread_->InjectEvent(DEV_TOUCH_PAD, event);
    }
    // 压力值
    if (data.pressVal) {
        Hid_EmitItem event = {.type = EV_ABS, .code = ABS_PRESSURE, .value = data.pressVal};
        injectThread_->InjectEvent(DEV_TOUCH_PAD, event);
    } else if (eventData_.pressVal) {
        Hid_EmitItem event = {.type = EV_ABS, .code = ABS_PRESSURE, .value = 0};
        injectThread_->InjectEvent(DEV_TOUCH_PAD, event);
    }
    injectThread_->InjectEvent(DEV_TOUCH_PAD, synEvent);
}

void HidSimulator::ConvertKeyEventData(const EventData &data)
{
    Hid_EmitItem event = {
        .type = EV_KEY,
        .code = GetLinuxKeyCode(data.keyVal),
        .value = (data.isDown ? DOWN : UP)};
    injectThread_->InjectEvent(DEV_KEYBOARD, event);
    injectThread_->InjectEvent(DEV_KEYBOARD, synEvent);
}

void HidSimulator::ConvertPenKeyEventData(const EventData &data)
{
    if (data.changed) {
        Hid_EmitItem event = {.type = EV_KEY, .code = BTN_RIGHT, .value = data.isDown ? DOWN : UP};
        injectThread_->InjectEvent(DEV_KEYBOARD, event);
    }
}