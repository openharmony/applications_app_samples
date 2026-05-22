/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef CALCULATOR_STUB_H
#define CALCULATOR_STUB_H

#include "icalculator.h"

#include <AbilityKit/ability_runtime/modular_object_extension_context.h>
#include <IPCKit/ipc_kit.h>

// [Start modular_object_extension_stub_header]
class CalculatorStub : public ICalculator {
public:
    explicit CalculatorStub(OH_AbilityRuntime_ModObjExtensionContextHandle context);
    ~CalculatorStub() override;

    OHIPCRemoteStub *GetRemoteStub() const { return remoteStub_; }

    static int32_t OnRemoteRequest(uint32_t code, const OHIPCParcel *data, OHIPCParcel *reply, void *userData);

    ErrCode Add(int32_t a, int32_t b, int32_t &result) override;

private:
    int32_t HandleAdd(const OHIPCParcel *data, OHIPCParcel *reply);

private:
    OHIPCRemoteStub *remoteStub_ = nullptr;
    OH_AbilityRuntime_ModObjExtensionContextHandle context_ = nullptr;
};
// [StartExclude modular_object_extension_stub_header]
#endif // CALCULATOR_STUB_H
// [EndExclude modular_object_extension_stub_header]
// [End modular_object_extension_stub_header]
