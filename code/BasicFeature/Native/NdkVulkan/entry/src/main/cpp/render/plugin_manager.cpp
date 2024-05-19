/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

#include "plugin_manager.h"
#include "logger_common.h"
#include <hilog/log.h>

// Get NativeXComponent pointer and render backend.
bool PluginManager::Init(napi_env env, napi_value exports)
{
    napi_value exportInstance = nullptr;
    OH_NativeXComponent *nativeXComponent = nullptr;
    // get exportInstance
    napi_status status = napi_get_named_property(env, exports, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);

    // get nativeXComponent
    status = napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent));

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    // get nativeXComponent Id
    int32_t ret = OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize);

    std::string id(idStr);
    auto context = PluginManager::GetInstance();
    if (context != nullptr) {
        context->SetNativeXComponent(id, nativeXComponent);
        auto render = context->GetRender(id);
        if (render == nullptr) {
            LOGE("Failed to get render context!");
            return false;
        }
        render->Export(env, exports);
        render->SetNativeXComponent(nativeXComponent);
        return true;
    }
    LOGE("Failed to get PluginManager instance! XComponentId:%{public}s", idStr);
    return false;
}

PluginRender* PluginManager::GetRender(std::string &id)
{
    if (pluginRenderMap.find(id) == pluginRenderMap.end()) {
        PluginRender *instance = PluginRender::GetInstance(id);
        pluginRenderMap[id] = instance;
    }
    return pluginRenderMap[id];
}

void PluginManager::SetNativeXComponent(std::string &id, OH_NativeXComponent *nativeXComponent)
{
    nativeXComponentMap[id] = nativeXComponent;
}