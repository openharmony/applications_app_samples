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

#ifndef CAPI_MANAGER_H
#define CAPI_MANAGER_H

#include "napi/native_api.h"
#include <arkui/native_node.h>
#include <ace/xcomponent/native_interface_xcomponent.h>

namespace NativeNodeManager {

class NodeManager {
public:
    ~NodeManager() = default;
    static NodeManager& GetInstance()
    {
        static NodeManager instance;
        return instance;
    };
    napi_value CreateNativeNode(napi_env env, napi_callback_info info);
    void *GetUserData();
    void SetUserData();
    void RegisterEvent();

private:
    ArkUI_NodeHandle CreateNodeHandle();
    void *CreateUserData();
    NodeManager() = default;
};
}

#endif //CAPI_MANAGER_H
