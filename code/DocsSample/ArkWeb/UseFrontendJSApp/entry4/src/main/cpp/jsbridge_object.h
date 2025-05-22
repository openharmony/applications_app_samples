#ifndef HEADER_GUARD_H
#define HEADER_GUARD_H
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

// [Start the_service_code_on_the_native_side]
#include "web/arkweb_type.h"
#include <string>

class JSBridgeObject : public std::enable_shared_from_this<JSBridgeObject> {
public:
    explicit JSBridgeObject(const char* webTag);
    ~JSBridgeObject() = default;
    void Init();
    std::weak_ptr<JSBridgeObject>* GetWeakPtr();
    static void StaticRunJavaScriptCallback(const char *webTag, const ArkWeb_JavaScriptBridgeData *data,
        void *userData);
    void RunJavaScriptCallback(const char *result);
    void ProxyMethod1(const ArkWeb_JavaScriptBridgeData *dataArray, int32_t arraySize);
    void ProxyMethod2(const ArkWeb_JavaScriptBridgeData *dataArray, int32_t arraySize);
    void SaySomething(const char* say);

private:
    std::string webTag_;
    std::weak_ptr<JSBridgeObject> weak_ptr_;
};
// [End the_service_code_on_the_native_side]
#endif // HEADER_GUARD_H