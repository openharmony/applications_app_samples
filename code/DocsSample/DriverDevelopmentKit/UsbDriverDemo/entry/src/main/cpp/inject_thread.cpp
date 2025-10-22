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

#include <hid/hid_ddk_api.h>
#include <linux/input.h>
#define LOG_TAG "testTag [NATIVE]"

#include "inject_thread.h"
#include "data_parser.h"

#include <hilog/log.h>
#include <hid/hid_ddk_api.h>

std::mutex InjectThread::mutex_;
std::condition_variable InjectThread::conditionVariable_;
std::unordered_map<int32_t, std::vector<Hid_EmitItem>> InjectThread::injectMap_;
std::unordered_map<std::string, int32_t> InjectThread::deviceMap_;

InjectThread::InjectThread()
{
    isRunning_ = true;
}

InjectThread::~InjectThread()
{
    isRunning_ = false;
    conditionVariable_.notify_one();
}

void InjectThread::RunThread(void *param)
{
    InjectThread *thread = (InjectThread *)param;
    thread->InjectFunc();
}

void InjectThread::Start()
{
    thread_ = std::thread(InjectThread::RunThread, this);
    pthread_setname_np(thread_.native_handle(), "emitEvent");
    thread_.detach();
}

void InjectThread::InjectFunc()
{
    std::unique_lock<std::mutex> uniqueLock(mutex_);
    CreateAllDevice();
    while (isRunning_) {
        conditionVariable_.wait(uniqueLock);
        for (auto &item : injectMap_) {
            if (item.second.size() == 0) {
                continue;
            }
            
            // [Start driver_hid1_step2]
            // 向指定deviceId的设备发送事件，事件来源于物理外设，通过InjectEvent方法注入
            int32_t ret = OH_Hid_EmitEvent(item.first, item.second.data(), (uint16_t)item.second.size());
            if (ret != HID_DDK_SUCCESS) {
                OH_LOG_ERROR(LOG_APP, "OH_Hid_EmitEvent failed, deviceId:%{public}d", item.first);
            }
            // [End driver_hid1_step2]
        }
        for (auto &item : injectMap_) {
            item.second.clear();
        }
    }

    for (auto &item : injectMap_) {
        OH_LOG_INFO(LOG_APP, "OH_Usb_DestroyDevice deviceId:%{public}d", item.first);
        DestroyDevice(item.first);
        item.second.clear();
    }
    injectMap_.clear();
}

void InjectThread::InjectEvent(std::string deviceName, Hid_EmitItem &injectInputEvent)
{
    std::lock_guard<std::mutex> lockGuard(mutex_);
    auto pos = deviceMap_.find(deviceName);
    if (pos == deviceMap_.end()) {
        OH_LOG_ERROR(LOG_APP, "InjectEvent deviceName:%{public}s not found", deviceName.c_str());
        return;
    }
    injectMap_[pos->second].push_back(injectInputEvent);
}

void InjectThread::Sync()
{
    for (auto &item : injectMap_) {
        if (item.second.size() > 0) {
            conditionVariable_.notify_one();
        }
    }
}

void InjectThread::CreateAllDevice()
{
    if (deviceMap_.size() > 0) {
        return;
    }
    int32_t boardId = CreateKeyBoardDevice(DEV_KEYBOARD);
    if (boardId < 0) {
        OH_LOG_INFO(LOG_APP, "CreateKeyBoardDevice fail result:%{public}d", boardId);
        return;
    }
    int32_t deviceId = CreateTouchPadDevice(DEV_TOUCH_PAD);
    if (deviceId < 0) {
        OH_LOG_INFO(LOG_APP, "CreateTouchPadDevice fail result:%{public}d", deviceId);
        DestroyDevice(boardId);
        deviceMap_.clear();
    }
}

void InjectThread::DestroyDevice(int32_t deviceId)
{
    // [Start driver_hid1_step3]
    // 销毁HID设备
    int32_t res = OH_Hid_DestroyDevice(deviceId);
    // [End driver_hid1_step3]
    OH_LOG_INFO(LOG_APP, "DestroyDevice deviceId:%{public}d, result:%{public}d", deviceId, res);
}

int32_t InjectThread::CreateDevice(Hid_Device *hidDevice, Hid_EventProperties *hidEventProperties)
{
    int deviceId = OH_Hid_CreateDevice(hidDevice, hidEventProperties);
    if (deviceId < 0) {
        OH_LOG_ERROR(LOG_APP, "CreateDevice failed error:%{public}d, deviceName:%{public}s", deviceId,
            hidDevice->deviceName);
    } else {
        deviceMap_.emplace(hidDevice->deviceName, deviceId);
        std::vector<Hid_EmitItem> items;
        injectMap_.emplace(deviceId, items);
        OH_LOG_INFO(LOG_APP, "CreateDevice success deviceId:%{public}d, deviceName:%{public}s", deviceId,
                    hidDevice->deviceName);
    }
    return deviceId;
}

int32_t InjectThread::CreateKeyBoardDevice(std::string deviceName)
{
    // [Start driver_hid1_step1]
    Hid_Device hidDevice = {
        .deviceName = deviceName.c_str(),
        .vendorId = 0x6006,
        .productId = 0x6008,
        .version = 1,
        .bustype = BUS_USB
    };
    std::vector<Hid_EventType> eventType = {HID_EV_KEY};
    Hid_EventTypeArray eventTypeArray = {.hidEventType = eventType.data(), .length = (uint16_t)eventType.size()};
    std::vector<Hid_KeyCode> keyCode = {
        HID_KEY_1,          HID_KEY_SPACE,       HID_KEY_BACKSPACE,   HID_KEY_ENTER,     HID_KEY_ESC, HID_KEY_SYSRQ,
        HID_KEY_LEFT_SHIFT, HID_KEY_RIGHT_SHIFT, HID_KEY_VOLUME_DOWN, HID_KEY_VOLUME_UP, HID_KEY_0,   HID_KEY_2,
        HID_KEY_3,          HID_KEY_4,           HID_KEY_5,           HID_KEY_6,         HID_KEY_7,   HID_KEY_8,
        HID_KEY_9,          HID_KEY_A,           HID_KEY_B,           HID_KEY_C,         HID_KEY_D,   HID_KEY_E,
        HID_KEY_F,          HID_KEY_G,           HID_KEY_H,           HID_KEY_I,         HID_KEY_J,   HID_KEY_K,
        HID_KEY_L,          HID_KEY_M,           HID_KEY_N,           HID_KEY_O,         HID_KEY_P,   HID_KEY_Q,
        HID_KEY_R,          HID_KEY_S,           HID_KEY_T,           HID_KEY_U,         HID_KEY_V,   HID_KEY_W,
        HID_KEY_X,          HID_KEY_Y,           HID_KEY_Z,           HID_KEY_DELETE};
    Hid_KeyCodeArray keyCodeArray = {.hidKeyCode = keyCode.data(), .length = (uint16_t)keyCode.size()};
    Hid_EventProperties hidEventProp = {.hidEventTypes = eventTypeArray, .hidKeys = keyCodeArray};
    int deviceId = OH_Hid_CreateDevice(&hidDevice, &hidEventProp);
    // [End driver_hid1_step1]
    if (deviceId < 0) {
        OH_LOG_ERROR(LOG_APP, "CreateDevice failed error:%{public}d, deviceName:%{public}s", deviceId,
                     hidDevice.deviceName);
        return deviceId;
    }
    deviceMap_.emplace(hidDevice.deviceName, deviceId);
    std::vector<Hid_EmitItem> items;
    injectMap_.emplace(deviceId, items);
    OH_LOG_INFO(LOG_APP, "CreateDevice success deviceId:%{public}d, deviceName:%{public}s", deviceId,
                hidDevice.deviceName);
    return deviceId;
}

int32_t InjectThread::CreateTouchPadDevice(std::string deviceName)
{
    std::vector<Hid_DeviceProp> deviceProp = {HID_PROP_DIRECT};
    Hid_Device hidDevice = {
        .deviceName = deviceName.c_str(),
        .vendorId = 0x6006,
        .productId = 0x6006,
        .version = 1,
        .bustype = BUS_USB,
        .properties = deviceProp.data(),
        .propLength = (uint16_t)deviceProp.size()
    };
    std::vector<Hid_EventType> eventType = {HID_EV_ABS, HID_EV_KEY, HID_EV_SYN, HID_EV_MSC};
    Hid_EventTypeArray eventTypeArray = {.hidEventType = eventType.data(), .length = (uint16_t)eventType.size()};
    std::vector<Hid_KeyCode> keyCode = {HID_BTN_TOOL_PEN, HID_BTN_TOOL_RUBBER, HID_BTN_TOUCH, HID_BTN_STYLUS,
        HID_BTN_RIGHT};
    Hid_KeyCodeArray keyCodeArray = {.hidKeyCode = keyCode.data(), .length = (uint16_t)keyCode.size()};
    std::vector<Hid_MscEvent> mscEvent = {HID_MSC_SCAN};
    Hid_MscEventArray mscEventArray = {.hidMscEvent = mscEvent.data(), .length = (uint16_t)mscEvent.size()};
    std::vector<Hid_AbsAxes> absAxes = {HID_ABS_X, HID_ABS_Y, HID_ABS_PRESSURE};
    Hid_AbsAxesArray absAxesArray = {.hidAbsAxes = absAxes.data(), .length = (uint16_t)absAxes.size()};
    Hid_EventProperties hidEventProp = {
        .hidEventTypes = eventTypeArray,
        .hidKeys = keyCodeArray,
        .hidAbs = absAxesArray,
        .hidMiscellaneous=mscEventArray
    };
    int32_t maxX;
    int32_t maxY;
    int32_t maxPressure;
    DataParser::GetInstance().GetAbsMax(maxX, maxY, maxPressure);
    OH_LOG_INFO(LOG_APP, "OH_Usb_CreateDevice maxX:%{public}d, maxY:%{public}d, maxPressure:%{public}d", maxX, maxY,
                maxPressure);
    hidEventProp.hidAbsMin[HID_ABS_X] = 0;
    hidEventProp.hidAbsMin[HID_ABS_Y] = 0;
    hidEventProp.hidAbsMin[HID_ABS_PRESSURE] = 0;
    hidEventProp.hidAbsMax[HID_ABS_X] = maxX;
    hidEventProp.hidAbsMax[HID_ABS_Y] = maxY;
    hidEventProp.hidAbsMax[HID_ABS_PRESSURE] = maxPressure;
    return CreateDevice(&hidDevice, &hidEventProp);
}