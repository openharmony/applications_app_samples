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

#ifndef CAPI_CHILD_PROCESS_TEST_IPC_INTERFACE_H
#define CAPI_CHILD_PROCESS_TEST_IPC_INTERFACE_H

#include <cstdint>

class IpcInterface {
public:
    virtual ~IpcInterface() = default;
    virtual bool RequestExitChildProcess(int32_t exitCode) = 0;
    virtual int32_t Add(int32_t a, int32_t b) = 0;
    virtual int32_t StartNativeChildProcess() = 0;
    
protected:
    enum IpcId {
        IPC_ID_REQUEST_EXIT_PROCESS = 1,
        IPC_ID_ADD,
        IPC_ID_START_NATIVE_CHILD_PROCESS
    };
    
    inline static constexpr char interfaceToken_[] = "NativeChildIpcTest";
};

#endif // CAPI_CHILD_PROCESS_TEST_IPC_INTERFACE_H
