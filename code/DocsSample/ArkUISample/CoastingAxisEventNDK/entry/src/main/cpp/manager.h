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

#ifndef COASTING_AXIS_EVENT_MANAGER_H
#define COASTING_AXIS_EVENT_MANAGER_H

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <arkui/native_node.h>
#include <string>

namespace NativeXComponentSample {
struct Contact {
    explicit Contact(std::string name) : name(name){};
    std::string name = "";
    std::string icon = "/pages/common/icon.svg";
};

struct ContactsGroup {
    std::string title = "";
    std::vector<Contact> contacts = {};
};

class NodeManager {
public:
    ~NodeManager() = default;
    static NodeManager &GetInstance();
    void SetXComponent(OH_NativeXComponent *xComponent);
    void CreateNativeNode(double density);

private:
    NodeManager() = default;
    ArkUI_NodeHandle CreateList();
    ArkUI_NodeHandle CreateListItem(const Contact &contact);
    ArkUI_NodeHandle CreateHeader(const std::string &text);
    ArkUI_NodeHandle CreateListText(std::string text);
    ArkUI_NodeHandle CreateListImage(std::string icon);
    void RegisterCoastingAxisEvent(ArkUI_NodeHandle node);
    OH_NativeXComponent *xComponent_;
};
} // namespace NativeXComponentSample

#endif // COASTING_AXIS_EVENT_MANAGER_H
