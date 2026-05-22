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

#ifndef CALCULATOR_PROXY_H
#define CALCULATOR_PROXY_H

#include "icalculator.h"

#include <IPCKit/ipc_kit.h>

// [Start modular_object_extension_proxy_header]
class CalculatorProxy : public ICalculator {
public:
    explicit CalculatorProxy(OHIPCRemoteProxy* remote) : remote_(remote) {}
    ~CalculatorProxy() override = default;

    OHIPCRemoteProxy* GetRemoteProxy() const
    {
        return remote_;
    }

    ErrCode Add(int32_t a, int32_t b, int32_t& result) override;

private:
    OHIPCRemoteProxy* remote_ = nullptr;
};
// [StartExclude modular_object_extension_proxy_header]

#endif // CALCULATOR_PROXY_H
// [EndExclude modular_object_extension_proxy_header]
// [End modular_object_extension_proxy_header]