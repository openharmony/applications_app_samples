/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

// entry/src/main/cpp/NativeEntry.h
#ifndef NATIVE_ENTRY_H
#define NATIVE_ENTRY_H

#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_interface.h>
#include <js_native_api.h>

namespace NativeModule {

    // 获取ArkUI Native Node API
    inline ArkUI_NativeNodeAPI_1 *GetNativeNodeAPI()
    {
        static ArkUI_NativeNodeAPI_1 *api = nullptr;
        if (api == nullptr) {
            OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
        }
        return api;
    }

    class NativeEntry {
    public:
        static NativeEntry *GetInstance()
        {
            static NativeEntry instance;
            return &instance;
        }

        void SetContentHandle(ArkUI_NodeContentHandle contentHandle)
        {
            contentHandle_ = contentHandle;
        }

        void SetRootNode(ArkUI_NodeHandle rootNode)
        {
            if (rootNode != nullptr && contentHandle_ != nullptr) {
                rootNode_ = rootNode;
                OH_ArkUI_NodeContent_AddNode(contentHandle_, rootNode);
            }
        }

        void DisposeRootNode()
        {
            if (rootNode_ != nullptr && contentHandle_ != nullptr) {
                OH_ArkUI_NodeContent_RemoveNode(contentHandle_, rootNode_);
                // 使用正确的方式销毁节点
                GetNativeNodeAPI()->disposeNode(rootNode_);
                rootNode_ = nullptr;
            }
        }

    private:
        NativeEntry() = default;
        ~NativeEntry() = default;

        ArkUI_NodeContentHandle contentHandle_ = nullptr;
        ArkUI_NodeHandle rootNode_ = nullptr;
    };

    // NAPI函数声明
    napi_value CreateNativeRoot(napi_env env, napi_callback_info info);
    napi_value DestroyNativeRoot(napi_env env, napi_callback_info info);

} // namespace NativeModule

#endif // NATIVE_ENTRY_H