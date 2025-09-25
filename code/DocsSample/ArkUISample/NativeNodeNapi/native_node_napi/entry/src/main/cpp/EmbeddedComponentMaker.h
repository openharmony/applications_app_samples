/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#ifndef NATIVE_NODE_SAMPLE_EMBEDDED_COMPONENT_MAKER_H
#define NATIVE_NODE_SAMPLE_EMBEDDED_COMPONENT_MAKER_H

#include <functional>
#include <arkui/native_node.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <unordered_map>
#include "manager.h"

class EmbeddedComponentMaker {
public:
    EmbeddedComponentMaker(){};
    ~EmbeddedComponentMaker();
    static ArkUI_NodeHandle CreateNativeNode();
    static ArkUI_NodeHandle BuildEmbeddedComponentSection(ArkUI_NativeNodeAPI_1* nodeApi);
    static ArkUI_NodeHandle BuildTextNode(ArkUI_NativeNodeAPI_1* nodeApi, const char* content);
    static ArkUI_NodeHandle BuildColumnNode(ArkUI_NativeNodeAPI_1* nodeApi);
    static void CreateEmbeddedComponentOption();
    static void DisposeEmbeddedComponentOption();
    static void SetEmbeddedComponentOnError();
    static void SetEmbeddedComponentOnTerminated();
    static void SetEmbeddedComponentWant(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node);
    static void OnErrorCallback(int32_t code, const char* name, const char* message);
    static void OnTerminatedCallback(int32_t code, AbilityBase_Want* want);
};

#endif // NATIVE_NODE_SAMPLE_EMBEDDED_COMPONENT_MAKER_H
