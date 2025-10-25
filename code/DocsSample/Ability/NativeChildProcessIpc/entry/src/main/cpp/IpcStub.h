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

#ifndef CAPI_CHILD_PROCESS_TEST_IPCSTUB_H
#define CAPI_CHILD_PROCESS_TEST_IPCSTUB_H

#include <IPCKit/ipc_kit.h>
#include "IpcInterface.h"

class IpcStub : public IpcInterface {
public:
    IpcStub();
    ~IpcStub() override;
    
    OHIPCRemoteStub* GetIpcStub();
    
private:
    IpcStub(const IpcStub&) = delete;
    IpcStub& operator = (const IpcStub&) = delete;
    IpcStub(const IpcStub&&) = delete;
    IpcStub& operator = (const IpcStub&&) = delete;
    
    static void OnRemoteObjectDestory(void *userData);
    static int OnRemoteRequest(uint32_t code, const OHIPCParcel *data, OHIPCParcel *reply, void *userData);
    static void* OnIpcMemAlloc(int32_t len);
    static void ReleaseIpcMem(void* ipcMem);
    static bool CheckInterfaceToken(const OHIPCParcel* data);
    
    int HandleRequestExitChildProcess(const OHIPCParcel *data, OHIPCParcel *reply);
    int HandleAdd(const OHIPCParcel *data, OHIPCParcel *reply);
    int HandleStartNativeChildProcess(const OHIPCParcel *data, OHIPCParcel *reply);
    
    OHIPCRemoteStub *ipcStub_ = nullptr;
};

#endif // CAPI_CHILD_PROCESS_TEST_IPCSTUB_H
