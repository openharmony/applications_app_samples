/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#include "plugin_manager.h"

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <cstdint>
#include <cstdio>
#include <string>


#include <hilog/log.h>
// native render
#include <native_buffer/native_buffer.h>
#include <native_window/buffer_handle.h>
#include <native_window/external_window.h>

#include "common/common.h"

#include "xcomponent_manager.h"

using namespace std;

namespace NativeXComponentSample {
PluginManager PluginManager::pluginManager_;
AbilityInfo PluginManager::m_abilityInfo;

const char *LOG_TAG_RECT = "TestRect";

napi_status callMethod(napi_env env, napi_value obj, const std::string &methodName, napi_value *out)
{
    napi_value func = nullptr;
    napi_status ret = napi_ok;

    ret = napi_get_named_property(env, obj, methodName.data(), &func);
    if (ret != napi_ok) {
        return ret;
    }
    ret = napi_call_function(env, obj, func, 0, nullptr, out);

    return ret;
}

void AbilityInfo::Init(napi_env env, napi_value uiAbility, napi_value windowStage)
{
    napi_value ohosWindow;
    napi_status code = callMethod(env, windowStage, "getMainWindowSync", &ohosWindow);
    if (code != napi_ok) {
        napi_throw_error(env, nullptr, "call getMainWindowSync failed");
    }
    this->env = env;

    napi_create_reference(env, uiAbility, 1, &this->uiAbility);
    napi_create_reference(env, windowStage, 1, &this->windowStage);
    napi_create_reference(env, ohosWindow, 1, &this->window);
}

napi_value AbilityInfo::getWindow()
{
    napi_value value;
    if (this->window) {
        napi_status status = napi_get_reference_value(env, window, &value);
        if (status != napi_ok) {
            napi_throw_type_error(env, NULL, "getWindow failed");
        }
    }
    return value;
}

AbilityInfo::~AbilityInfo()
{
    // todo release ref
}

void setupNativeWindowBufferUsage(::OHNativeWindow *nativeWindow, std::uint64_t usageSetBits)
{
    std::uint64_t windowBufferUsage = 0;
    auto getUsageRes =
        ::OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, ::NativeWindowOperation::GET_USAGE, &windowBufferUsage);

    std::uint64_t requestedWindowBufferUsage = windowBufferUsage | usageSetBits;
    if (requestedWindowBufferUsage != windowBufferUsage) {
        auto setUsageRes = ::OH_NativeWindow_NativeWindowHandleOpt(
            nativeWindow, ::NativeWindowOperation::SET_USAGE, requestedWindowBufferUsage);
    }
}

PluginManager::PluginManager()
    :xcomponentMgr(new XComponentManager)
{
}

PluginManager::~PluginManager()
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Callback", "~PluginManager");
    delete xcomponentMgr;
}

void PluginManager::AttachXComponent(const std::string &id,
    OH_NativeXComponent *nativeXComponent, OHNativeWindow *window)
{
    this->xcomponentMgr->SetNativeXComponent(id, nativeXComponent, window);
}

void PluginManager::Export(napi_env env, napi_value exports)
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "Export: start execute");
    if ((env == nullptr) || (exports == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "Export: env or exports is null");
        return;
    }

    napi_value exportInstance = nullptr;
    if (napi_get_named_property(env, exports, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "Export: napi_get_named_property fail");
        return;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "Export: napi_unwrap fail");
        return;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        OH_LOG_Print(
            LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "Export: OH_NativeXComponent_GetXComponentId fail");
        return;
    }

    this->xcomponentMgr->RegisterCallback(nativeXComponent);
}

}  // namespace NativeXComponentSample