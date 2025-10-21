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

// [Start child_process_must_method]
// [Start child_process_head_file]
#include <IPCKit/ipc_kit.h>
// [StartExclude child_process_must_method]
#include <AbilityKit/native_child_process.h>
// [EndExclide child_process_must_method]
// [End child_process_head_file]
#include <IPCKit/ipc_cremote_object.h>
#include <IPCKit/ipc_cparcel.h>
#include <IPCKit/ipc_error_code.h>

class IpcCapiStubTest {
public:
    explicit IpcCapiStubTest();
    ~IpcCapiStubTest();
    OHIPCRemoteStub *GetRemoteStub();
    static int OnRemoteRequest(uint32_t code, const OHIPCParcel *data, OHIPCParcel *reply, void *userData);

private:
    OHIPCRemoteStub *stub_{nullptr};
};

IpcCapiStubTest::IpcCapiStubTest()
{
    // 创建stub对象
    stub_ = OH_IPCRemoteStub_Create("testIpc", &IpcCapiStubTest::OnRemoteRequest, nullptr, this);
}

IpcCapiStubTest::~IpcCapiStubTest()
{
    if (stub_ != nullptr) {
        OH_IPCRemoteStub_Destroy(stub_);
    }
}

OHIPCRemoteStub *IpcCapiStubTest::GetRemoteStub() { return stub_; }

int IpcCapiStubTest::OnRemoteRequest(uint32_t code, const OHIPCParcel *data, OHIPCParcel *reply, void *userData)
{
    return OH_IPC_SUCCESS;
}

IpcCapiStubTest ipcStubObj;

extern "C" {

OHIPCRemoteStub *NativeChildProcess_OnConnect()
{
    // ipcRemoteStub指向子进程实现的ipc stub对象，用于接收来自主进程的IPC消息并响应
    // 子进程根据业务逻辑控制其生命周期
    return ipcStubObj.GetRemoteStub();
}

void NativeChildProcessMainProc()
{
    // 相当于子进程的Main函数，实现子进程的业务逻辑
    // ...
    // 函数返回后子进程随即退出
}

} // extern "C"
// [End child_process_must_method]