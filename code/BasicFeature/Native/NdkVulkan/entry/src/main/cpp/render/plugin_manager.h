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

#ifndef PLUGIN_MANAGER_H
#define PLUGIN_MANAGER_H

#include <napi/native_api.h>
#include <uv.h>
#include <string>
#include <unordered_map>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include "logger_common.h"
#include "plugin_render.h"
#include <rawfile/raw_file_manager.h>

class PluginManager {
  public:
    ~PluginManager() = default;
    static PluginManager *GetInstance()
    {
        static PluginManager instance;
        return &instance;
    }
    bool Init(napi_env env, napi_value exports);
    void SetNativeXComponent(std::string &id, OH_NativeXComponent *nativeXComponent);
    PluginRender *GetRender(std::string &id);

  private:
    PluginManager() = default;
    std::unordered_map<std::string, OH_NativeXComponent*> nativeXComponentMap;
    std::unordered_map<std::string, PluginRender*> pluginRenderMap;
};
#endif // PLUGIN_MANAGER_H
