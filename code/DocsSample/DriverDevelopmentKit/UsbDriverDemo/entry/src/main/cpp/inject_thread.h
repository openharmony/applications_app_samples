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

#ifndef INJECT_THREAD_H
#define INJECT_THREAD_H

#include <mutex>
#include <thread>
#include <hid/hid_ddk_types.h>

const std::string DEV_KEYBOARD = "VSoC keyboard";
const std::string DEV_TOUCH_PAD = "VSoC touchpad";

class InjectThread {
  public:
    InjectThread();
    virtual ~InjectThread();
    void Start();
    void InjectEvent(std::string deviceName, Hid_EmitItem &injectInputEvent);
    void Sync();
    int32_t CreateKeyBoardDevice(std::string deviceName);
    int32_t CreateTouchPadDevice(std::string deviceName);
    void DestroyDevice(int32_t deviceId);
    void CreateAllDevice();

private:
    static void RunThread(void *param);
    void InjectFunc();
    int32_t CreateDevice(Hid_Device *hidDevice, Hid_EventProperties *hidEventProperties);

private:
    static std::mutex mutex_;
    static std::condition_variable conditionVariable_;
    static std::unordered_map<int32_t, std::vector<Hid_EmitItem>> injectMap_;
    static std::unordered_map<std::string, int32_t> deviceMap_;
    bool isRunning_;
    std::thread thread_;
};

#endif // INJECT_THREAD_H