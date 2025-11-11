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

#include "ChildProcess.h"
#include <AbilityKit/native_child_process.h>

static void DummyCallBack(int errCode, OHIPCRemoteProxy *remoteProxy)
{
    if (remoteProxy != nullptr) {
        OH_IPCRemoteProxy_Destroy(remoteProxy);
    }
}

void ChildProcess::MainProc()
{
    StdUniLock autoLock(processMutex_);
    mRunning = true;
    processCondVar_.wait(autoLock);
    mRunning = false;
}

bool ChildProcess::RequestExitChildProcess(int32_t exitCode)
{
    StdUniLock autoLock(processMutex_);
    if (!mRunning) {
        return false;
    }
    
    // mock child proces crash generate signal
    if (exitCode > 0) {
        int *ptr = nullptr;
        *ptr = 1;
        return true;
    }
    processCondVar_.notify_all();
    return true;
}

int32_t ChildProcess::Add(int32_t a, int32_t b)
{
    return a + b;
}

int32_t ChildProcess::StartNativeChildProcess()
{
    return OH_Ability_CreateNativeChildProcess("libentry.so", DummyCallBack);
}
