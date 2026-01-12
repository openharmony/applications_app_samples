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

// [Start stub_implement]
#include "IpcStub.h"
#include <IPCKit/ipc_error_code.h>
#include <cstring>
#include <new>

IpcStub::IpcStub()
{
    ipcStub_ = OH_IPCRemoteStub_Create("NativeChildIPCStubSample",
        IpcStub::OnRemoteRequest, IpcStub::OnRemoteObjectDestroy, this);
}

IpcStub::~IpcStub()
{
    OH_IPCRemoteStub_Destroy(ipcStub_);
}

OHIPCRemoteStub* IpcStub::GetIpcStub()
{
    return ipcStub_;
}

void IpcStub::OnRemoteObjectDestroy(void *userData)
{
}

int IpcStub::OnRemoteRequest(uint32_t code, const OHIPCParcel *data, OHIPCParcel *reply, void *userData)
{
    if (userData == nullptr) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    
    if (!CheckInterfaceToken(data)) {
        return OH_IPC_CHECK_PARAM_ERROR;
    }
    
    int ret;
    IpcStub *thiz = reinterpret_cast<IpcStub*>(userData);
    switch (code) {
        case IPC_ID_REQUEST_EXIT_PROCESS:
            ret = thiz->HandleRequestExitChildProcess(data, reply);
            break;
        
        case IPC_ID_ADD:
            ret = thiz->HandleAdd(data, reply);
            break;
        
        case IPC_ID_START_NATIVE_CHILD_PROCESS:
            ret = thiz->HandleStartNativeChildProcess(data, reply);
            break;
        
        default:
            ret = OH_IPC_CODE_OUT_OF_RANGE;
            break;
    }
    
    return ret;
}

void* IpcStub::OnIpcMemAlloc(int32_t len)
{
    // limit ipc memory alloc size to 128 bytes
    if (len > 128) {
        return nullptr;
    }

    return new (std::nothrow) char[len];
}

void IpcStub::ReleaseIpcMem(void* ipcMem)
{
    delete[] reinterpret_cast<char*>(ipcMem);
}

bool IpcStub::CheckInterfaceToken(const OHIPCParcel* data)
{
    char *token;
    int32_t tokenLen;
    int ret = OH_IPCParcel_ReadInterfaceToken(data, &token, &tokenLen, IpcStub::OnIpcMemAlloc);
    if (ret != OH_IPC_SUCCESS) {
        return false;
    }
    
    bool tokenCheckRes = strcmp(token, interfaceToken_) == 0;
    ReleaseIpcMem(token);
    return tokenCheckRes;
}

int IpcStub::HandleRequestExitChildProcess(const OHIPCParcel *data, OHIPCParcel *reply)
{
    int exitCode = 0;
    if (OH_IPCParcel_ReadInt32(data, &exitCode) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_READ_ERROR;
    }
    int32_t ret = RequestExitChildProcess(exitCode) ? 1 : 0;
    return OH_IPCParcel_WriteInt32(reply, ret);
}

int32_t IpcStub::HandleAdd(const OHIPCParcel *data, OHIPCParcel *reply)
{
    int32_t a = 0;
    int32_t b = 0;
    if (OH_IPCParcel_ReadInt32(data, &a) != OH_IPC_SUCCESS ||
        OH_IPCParcel_ReadInt32(data, &b) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_READ_ERROR;
    }
    
    int32_t result = Add(a, b);
    if (OH_IPCParcel_WriteInt32(reply, result) != OH_IPC_SUCCESS) {
        return OH_IPC_PARCEL_WRITE_ERROR;
    }
    
    return OH_IPC_SUCCESS;
}

int IpcStub::HandleStartNativeChildProcess(const OHIPCParcel *data, OHIPCParcel *reply)
{
    int32_t ret = StartNativeChildProcess();
    return OH_IPCParcel_WriteInt32(reply, ret);
}
// [End stub_implement]
