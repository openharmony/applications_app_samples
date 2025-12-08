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

// [Start proxy_implement]
#include "IpcProxy.h"
#include <IPCKit/ipc_error_code.h>
#include "Ipchelper.h"

IpcProxy::IpcProxy(OHIPCRemoteProxy *ipcProxy)
    : ipcProxy_(ipcProxy)
{
}

IpcProxy::~IpcProxy()
{
    if (ipcProxy_ != nullptr) {
        OH_IPCRemoteProxy_Destroy(ipcProxy_);
    }
}

bool IpcProxy::RequestExitChildProcess(int32_t exitCode)
{
    if (ipcProxy_ == nullptr) {
        return false;
    }
    
    StdUniPtrIpcParcel data(OH_IPCParcel_Create(), OH_IPCParcel_Destroy);
    StdUniPtrIpcParcel reply(OH_IPCParcel_Create(), OH_IPCParcel_Destroy);
    if (data == nullptr || reply == nullptr) {
        return false;
    }
    
    if (!WriteInterfaceToken(data.get()) ||
        OH_IPCParcel_WriteInt32(data.get(), exitCode) != OH_IPC_SUCCESS) {
        return false;
    }
    
    OH_IPC_MessageOption ipcOpt;
    ipcOpt.mode = OH_IPC_REQUEST_MODE_SYNC;
    ipcOpt.timeout = 0;
    ipcOpt.reserved = nullptr;
    int ret = OH_IPCRemoteProxy_SendRequest(ipcProxy_, IPC_ID_REQUEST_EXIT_PROCESS, data.get(), reply.get(), &ipcOpt);
    if (ret != OH_IPC_SUCCESS) {
        return false;
    }
    
    return true;
}

int32_t IpcProxy::Add(int32_t a, int32_t b)
{
    if (ipcProxy_ == nullptr) {
        return INT32_MIN;
    }
    
    int32_t result = INT32_MIN;
    StdUniPtrIpcParcel data(OH_IPCParcel_Create(), OH_IPCParcel_Destroy);
    StdUniPtrIpcParcel reply(OH_IPCParcel_Create(), OH_IPCParcel_Destroy);
    if (data == nullptr || reply == nullptr) {
        return result;
    }
    
    if (!WriteInterfaceToken(data.get()) ||
        OH_IPCParcel_WriteInt32(data.get(), a) != OH_IPC_SUCCESS ||
        OH_IPCParcel_WriteInt32(data.get(), b) != OH_IPC_SUCCESS) {
        return result;
    }
    
    OH_IPC_MessageOption ipcOpt;
    ipcOpt.mode = OH_IPC_REQUEST_MODE_SYNC;
    ipcOpt.timeout = 0;
    ipcOpt.reserved = nullptr;
    int ret = OH_IPCRemoteProxy_SendRequest(ipcProxy_, IPC_ID_ADD, data.get(), reply.get(), &ipcOpt);
    if (ret != OH_IPC_SUCCESS) {
        return result;
    }
    
    OH_IPCParcel_ReadInt32(reply.get(), &result);
    return result;
}

int32_t IpcProxy::StartNativeChildProcess()
{
    if (ipcProxy_ == nullptr) {
        return INT32_MIN;
    }
    
    int32_t result = INT32_MIN;
    StdUniPtrIpcParcel data(OH_IPCParcel_Create(), OH_IPCParcel_Destroy);
    StdUniPtrIpcParcel reply(OH_IPCParcel_Create(), OH_IPCParcel_Destroy);
    if (data == nullptr || reply == nullptr) {
        return result;
    }
    
    if (!WriteInterfaceToken(data.get())) {
        return result;
    }
    
    OH_IPC_MessageOption ipcOpt;
    ipcOpt.mode = OH_IPC_REQUEST_MODE_SYNC;
    ipcOpt.timeout = 0;
    ipcOpt.reserved = nullptr;
    int ret = OH_IPCRemoteProxy_SendRequest(
        ipcProxy_, IPC_ID_START_NATIVE_CHILD_PROCESS, data.get(), reply.get(), &ipcOpt);
    if (ret != OH_IPC_SUCCESS) {
        return result;
    }
    
    OH_IPCParcel_ReadInt32(reply.get(), &result);
    return result;
}

bool IpcProxy::WriteInterfaceToken(OHIPCParcel* data)
{
    return OH_IPCParcel_WriteInterfaceToken(data, interfaceToken_) == OH_IPC_SUCCESS;
}
// [End proxy_implement]
