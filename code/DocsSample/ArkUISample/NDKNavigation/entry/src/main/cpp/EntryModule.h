/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#ifndef NDKNAVIGATION_ENTRYMODULE_H
#define NDKNAVIGATION_ENTRYMODULE_H
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <string>
namespace NativeModule {
class NativeEntry {
public:
    static NativeEntry *GetInstance()
    {
        static NativeEntry nativeEntry;
        return &nativeEntry;
    }
    
    NativeEntry()
    {
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, arkUINativeNode_);
    }
    
    ArkUI_NativeNodeAPI_1* GetNativeNodeApi() const
    {
        return arkUINativeNode_;
    }
    
    void SetWidth(ArkUI_NodeHandle node, float width);
    
    void SetHeight(ArkUI_NodeHandle node, float height);
    
    void SetColor(ArkUI_NodeHandle node, uint32_t color);
    
    ArkUI_NodeHandle AddButton(ArkUI_NodeHandle node, const std::string& content);
    
    void InitNavDestinationState(ArkUI_NodeHandle handle);
    
    void InitPageName(ArkUI_NodeHandle handle);
    
    void InitPageIndex(ArkUI_NodeHandle handle);
private:
    void ReportError(ArkUI_NodeHandle handle, const std::string& info);
    ArkUI_NativeNodeAPI_1 *arkUINativeNode_;
};
}
#endif //NDKNAVIGATION_ENTRYMODULE_H