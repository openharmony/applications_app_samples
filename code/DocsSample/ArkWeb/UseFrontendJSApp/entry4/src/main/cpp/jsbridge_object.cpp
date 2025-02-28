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

#include "jsbridge_object.h"

#include "hilog/log.h"

constexpr unsigned int LOG_PRINT_DOMAIN = 0xFF00;

JSBridgeObject::JSBridgeObject(const char *webTag) : webTag_(webTag) {}

void JSBridgeObject::Init() { weak_ptr_ = shared_from_this(); }

std::weak_ptr<JSBridgeObject> *JSBridgeObject::GetWeakPtr() { return &weak_ptr_; }

void JSBridgeObject::StaticRunJavaScriptCallback(
    const char *webTag, const ArkWeb_JavaScriptBridgeData *data, void *userData)
{
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "JSBridgeObject StaticRunJavaScriptCallback webTag:%{public}s", webTag);
    if (!userData) {
        OH_LOG_Print(
            LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
            "JSBridgeObject StaticRunJavaScriptCallback userData is nullptr");
        return;
    }
    std::weak_ptr<JSBridgeObject> jsb_weak_ptr = *static_cast<std::weak_ptr<JSBridgeObject> *>(userData);
    if (auto jsb_ptr = jsb_weak_ptr.lock()) {
        std::string result((char *)data->buffer, data->size);
        jsb_ptr->RunJavaScriptCallback(result.c_str());
    } else {
        OH_LOG_Print(
            LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
            "JSBridgeObject StaticRunJavaScriptCallback jsb_weak_ptr lock failed");
    }
}

void JSBridgeObject::RunJavaScriptCallback(const char *result)
{
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "JSBridgeObject OH_NativeArkWeb_RunJavaScript result:%{public}s", result);
}

void JSBridgeObject::ProxyMethod1(const ArkWeb_JavaScriptBridgeData *dataArray, int32_t arraySize)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "JSBridgeObject ProxyMethod1 argc:%{public}d",
                 arraySize);
    for (int i = 0; i < arraySize; i++) {
        std::string result((char *)dataArray[i].buffer, dataArray[i].size);
        OH_LOG_Print(
            LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
            "JSBridgeObject ProxyMethod1 argv[%{public}d]:%{public}s, size:%{public}d",
            i, result.c_str(), dataArray[i].size);
    }
}

void JSBridgeObject::ProxyMethod2(const ArkWeb_JavaScriptBridgeData *dataArray, int32_t arraySize)
{
    OH_LOG_Print(
        LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
        "JSBridgeObject ProxyMethod2 argc:%{public}d", arraySize);
    for (int i = 0; i < arraySize; i++) {
        std::string result((char *)dataArray[i].buffer, dataArray[i].size);
        OH_LOG_Print(
            LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb",
            "JSBridgeObject ProxyMethod2 argv[%{public}d]:%{public}s, size:%{public}d",
            i, result.c_str(), dataArray[i].size);
    }
}

void JSBridgeObject::SaySomething(const char *say)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ArkWeb", "JSBridgeObject SaySomething argc:%{public}s", say);
}
