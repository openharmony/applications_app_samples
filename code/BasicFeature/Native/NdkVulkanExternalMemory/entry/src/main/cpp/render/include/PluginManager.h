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

#ifndef VULKAN_PLUGINMANAGER_H
#define VULKAN_PLUGINMANAGER_H

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <string>
#include <unordered_map>
#include "PluginRender.h"

namespace NativeXComponentSample {
class PluginManager {
public:
    ~PluginManager();

    static PluginManager *GetInstance() { return &PluginManager::pluginManager_; }

    void SetNativeXComponent(std::string &id, OH_NativeXComponent *nativeXComponent);
    void RenderConfig(napi_env env, napi_value exports);
    PluginRender *GetRender(std::string &id);

private:
    static PluginManager pluginManager_;

    std::unordered_map<std::string, OH_NativeXComponent *> nativeXComponentMap_;
    std::unordered_map<std::string, PluginRender *> pluginRenderMap_;
};
} // namespace NativeXComponentSample
#endif //VULKAN_PLUGINMANAGER_H
