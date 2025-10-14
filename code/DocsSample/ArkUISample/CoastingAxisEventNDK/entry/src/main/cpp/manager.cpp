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

#include <arkui/native_interface.h>
#include <hilog/log.h>

#include "manager.h"

namespace NativeXComponentSample {
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
static ArkUI_NativeNodeAPI_1* nativeModule_ = nullptr;
double g_px2vp = 0;

const std::vector<ContactsGroup> staticContacts = {
    { "A", { Contact("Alice"), Contact("Alan"), Contact("Amy"), Contact("Andy"), Contact("Anna") } },
    { "B",
        { Contact("Bob"), Contact("Betty"), Contact("Bruce"), Contact("Bella"), Contact("Brian"), Contact("Blake") } },
    { "C", { Contact("Charlie"), Contact("Cindy"), Contact("Chris"), Contact("Clara"), Contact("Carter") } },
    { "D", { Contact("David"), Contact("Diana"), Contact("Dan"), Contact("Daisy"), Contact("Duke"), Contact("Dora") } },
    { "E", { Contact("Emma"), Contact("Eric"), Contact("Eva"), Contact("Ethan"), Contact("Elise") } },
    { "F",
        { Contact("Frank"), Contact("Fiona"), Contact("Felix"), Contact("Faith"), Contact("Flora"), Contact("Fred") } },
    { "G", { Contact("George"), Contact("Grace"), Contact("Gary"), Contact("Gina"), Contact("Gavin") } },
    { "H",
        { Contact("Helen"), Contact("Henry"), Contact("Hank"), Contact("Hazel"), Contact("Hugo"), Contact("Holly") } },
    { "I", { Contact("Ivy"), Contact("Ian"), Contact("Iris"), Contact("Ivan"), Contact("Isla") } },
    { "J", { Contact("John"), Contact("Jane"), Contact("Jack"), Contact("Jill"), Contact("James"), Contact("Julia") } },
    { "K", { Contact("Kevin"), Contact("Kate"), Contact("Kyle"), Contact("Karen"), Contact("Karl") } },
    { "L", { Contact("Lucy"), Contact("Leo"), Contact("Lily"), Contact("Luke"), Contact("Liam"), Contact("Luna") } },
    { "M", { Contact("Mike"), Contact("Mary"), Contact("Mark"), Contact("Mia"), Contact("Max") } },
    { "N", { Contact("Nancy"), Contact("Nick"), Contact("Nora"), Contact("Noah"), Contact("Nina"), Contact("Nate") } },
    { "O", { Contact("Olivia"), Contact("Oscar"), Contact("Olive"), Contact("Owen"), Contact("Opal") } },
    { "P", { Contact("Peter"), Contact("Paula"), Contact("Paul"), Contact("Pam"), Contact("Phil"), Contact("Piper") } },
    { "Q", { Contact("Quinn"), Contact("Quentin"), Contact("Queen"), Contact("Quincy"), Contact("Quella") } },
    { "R", { Contact("Robert"), Contact("Rose"), Contact("Ryan"), Contact("Ruth"), Contact("Roy"), Contact("Rex") } },
    { "S", { Contact("Sarah"), Contact("Sam"), Contact("Steve"), Contact("Sue"), Contact("Sean") } },
    { "T", { Contact("Tom"), Contact("Tina"), Contact("Tim"), Contact("Tara"), Contact("Ted"), Contact("Troy") } },
    { "U", { Contact("Uma"), Contact("Ulysses"), Contact("Uriah"), Contact("Ulric"), Contact("Ula") } },
    { "V",
        { Contact("Victor"), Contact("Vera"), Contact("Vince"), Contact("Violet"), Contact("Van"), Contact("Vicky") } },
    { "W", { Contact("William"), Contact("Wendy"), Contact("Wayne"), Contact("Willa"), Contact("Wade") } },
    { "X", { Contact("Xander"), Contact("Xena"), Contact("Xavier"), Contact("Xia"), Contact("Xerxes") } },
    { "Y",
        { Contact("Yvonne"), Contact("Yves"), Contact("Yael"), Contact("Yuri"), Contact("Yolanda"), Contact("Yan") } },
    { "Z", { Contact("Zoe"), Contact("Zack"), Contact("Zara"), Contact("Zane"), Contact("Zelda") } }
};

NodeManager& NodeManager::GetInstance()
{
    static NodeManager instance;
    return instance;
}

void NodeManager::SetXComponent(OH_NativeXComponent* xComponent)
{
    xComponent_ = xComponent;
}

void NodeManager::CreateNativeNode(double px2vp)
{
    if (!xComponent_ || px2vp == 0) {
        return;
    }
    g_px2vp = px2vp;
    nativeModule_ = reinterpret_cast<ArkUI_NativeNodeAPI_1*>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nativeModule_ == nullptr) {
        return;
    }
    // 创建一个Column容器组件
    ArkUI_NodeHandle column = nativeModule_->createNode(ARKUI_NODE_COLUMN);
    // 创建List
    ArkUI_NodeHandle listNode = CreateList();
    nativeModule_->addChild(column, listNode);
    // 为List注册惯性轴事件监听
    RegisterCoastingAxisEvent(listNode);
    OH_NativeXComponent_AttachNativeRootNode(xComponent_, column);
}

ArkUI_NodeHandle NodeManager::CreateList()
{
    ArkUI_NodeHandle listNode = nativeModule_->createNode(ARKUI_NODE_LIST);
    ArkUI_NumberValue value[] = { { .i32 = ARKUI_STICKY_STYLE_HEADER } };
    ArkUI_AttributeItem item = { value, 1 };
    nativeModule_->setAttribute(listNode, NODE_LIST_STICKY, &item);
    for (const auto& group : staticContacts) {
        auto groupNode = nativeModule_->createNode(ARKUI_NODE_LIST_ITEM_GROUP);
        ArkUI_AttributeItem Item = { .object = CreateHeader(group.title) };
        nativeModule_->setAttribute(groupNode, NODE_LIST_ITEM_GROUP_SET_HEADER, &Item);
        for (const auto& contact : group.contacts) {
            auto listItem = CreateListItem(contact);
            nativeModule_->addChild(groupNode, listItem);
        }
        nativeModule_->addChild(listNode, groupNode);
    }

    return listNode;
}

ArkUI_NodeHandle NodeManager::CreateListItem(const Contact& contact)
{
    auto listItem = nativeModule_->createNode(ARKUI_NODE_LIST_ITEM);
    auto row = nativeModule_->createNode(ARKUI_NODE_ROW);
    auto image = CreateListImage(contact.icon);
    auto text = CreateListText(contact.name);

    ArkUI_NumberValue paddingValue[] = { { .f32 = 12 } };
    ArkUI_AttributeItem padding = { paddingValue, 1 };
    nativeModule_->setAttribute(row, NODE_PADDING, &padding);

    ArkUI_NumberValue alignValue[] = { { .i32 = ARKUI_VERTICAL_ALIGNMENT_CENTER } };
    ArkUI_AttributeItem align = { alignValue, 1 };
    nativeModule_->setAttribute(row, NODE_ROW_ALIGN_ITEMS, &align);
    nativeModule_->addChild(row, image);
    nativeModule_->addChild(row, text);
    nativeModule_->addChild(listItem, row);

    return listItem;
}

ArkUI_NodeHandle NodeManager::CreateListImage(std::string icon)
{
    auto image = nativeModule_->createNode(ARKUI_NODE_IMAGE);
    ArkUI_AttributeItem item = { .string = icon.c_str() };
    nativeModule_->setAttribute(image, NODE_IMAGE_SRC, &item);
    ArkUI_NumberValue value[] = { { .f32 = 40 } };
    ArkUI_AttributeItem height = { value, 1 };
    ArkUI_AttributeItem width = { value, 1 };
    nativeModule_->setAttribute(image, NODE_HEIGHT, &height);
    nativeModule_->setAttribute(image, NODE_WIDTH, &width);
    ArkUI_NumberValue radiusValue[] = { { .f32 = 20 } };
    ArkUI_AttributeItem radius = { radiusValue, 1 };
    nativeModule_->setAttribute(image, NODE_BORDER_RADIUS, &radius);
    ArkUI_NumberValue marginValue[] = { { .f32 = 0 }, { .f32 = 17 }, { .f32 = 0 }, { .f32 = 0 } };
    ArkUI_AttributeItem margin = { marginValue, 4 };
    nativeModule_->setAttribute(image, NODE_MARGIN, &margin);
    return image;
}

ArkUI_NodeHandle NodeManager::CreateListText(std::string text)
{
    auto textNode = nativeModule_->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem str = { nullptr, 0, text.c_str() };
    nativeModule_->setAttribute(textNode, NODE_TEXT_CONTENT, &str);
    ArkUI_NumberValue fontSizeValue[] = { { .f32 = 18 } };
    ArkUI_AttributeItem fontSize = { fontSizeValue, 1 };
    nativeModule_->setAttribute(textNode, NODE_FONT_SIZE, &fontSize);
    return textNode;
}

ArkUI_NodeHandle NodeManager::CreateHeader(const std::string& text)
{
    auto textNode = nativeModule_->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem str = { nullptr, 0, text.c_str() };
    nativeModule_->setAttribute(textNode, NODE_TEXT_CONTENT, &str);

    ArkUI_NumberValue fontSizeValue[] = { { .f32 = 20 } };
    ArkUI_AttributeItem fontSize = { fontSizeValue, 1 };
    nativeModule_->setAttribute(textNode, NODE_FONT_SIZE, &fontSize);

    ArkUI_NumberValue widthValue[] = { { .f32 = 100 } };
    ArkUI_AttributeItem width = { widthValue, 1 };
    nativeModule_->setAttribute(textNode, NODE_WIDTH_PERCENT, &width);

    ArkUI_NumberValue colorValue[] = { { .u32 = 0xfff1f3f5 } };
    ArkUI_AttributeItem color = { colorValue, 1 };
    nativeModule_->setAttribute(textNode, NODE_BACKGROUND_COLOR, &color);

    ArkUI_NumberValue paddingValue[] = { { .f32 = 5 } };
    ArkUI_AttributeItem padding = { paddingValue, 1 };
    nativeModule_->setAttribute(textNode, NODE_PADDING, &padding);
    return textNode;
}

void NodeManager::RegisterCoastingAxisEvent(ArkUI_NodeHandle node)
{
    nativeModule_->registerNodeEvent(node, NODE_ON_COASTING_AXIS_EVENT, 0, nullptr);
    nativeModule_->registerNodeEvent(node, NODE_ON_AXIS, 0, nullptr);
    nativeModule_->addNodeEventReceiver(node, [](ArkUI_NodeEvent* event) {
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        switch (eventType) {
            case NODE_ON_COASTING_AXIS_EVENT: {
                auto uiInputEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
                auto handler = OH_ArkUI_NodeEvent_GetNodeHandle(event);
                auto coastingAxisEvent = OH_ArkUI_UIInputEvent_GetCoastingAxisEvent(uiInputEvent);
                auto time = OH_ArkUI_CoastingAxisEvent_GetEventTime(coastingAxisEvent);
                auto phase = OH_ArkUI_CoastingAxisEvent_GetPhase(coastingAxisEvent);
                auto deltaX = OH_ArkUI_CoastingAxisEvent_GetDeltaX(coastingAxisEvent);
                auto deltaY = OH_ArkUI_CoastingAxisEvent_GetDeltaY(coastingAxisEvent);
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NODE_ON_COASTING_AXIS_EVENT",
                    "phase=%{public}d, deltaX=%{public}f, deltaY=%{public}f, "
                    "time=%{public}ld",
                    phase, deltaX, deltaY, time);
                ArkUI_NumberValue scrollOffset[] = { { .f32 = static_cast<float>(deltaX * g_px2vp) },
                    { .f32 = static_cast<float>(deltaY * g_px2vp) } };
                ArkUI_AttributeItem scrollOffsetItem = { scrollOffset,
                    sizeof(scrollOffset) / sizeof(ArkUI_NumberValue) };
                nativeModule_->setAttribute(handler, NODE_SCROLL_BY, &scrollOffsetItem);
                break;
            }
            default: {
                break;
            }
        }
    });
}
} // namespace NativeXComponentSample
