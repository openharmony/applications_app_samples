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

#include "InquireUniqueId.h"
#include "NativeModule.h"

#include <arkui/styled_string.h>
#include <arkui/native_node.h>
#include <hilog/log.h>

namespace NativeModule {
// [Start ndknodequeryoperate1_start]
const unsigned int VALUE_1 = 480;
const unsigned int VALUE_2 = 300;
const unsigned int VALUE_3 = 50;
    std::shared_ptr<ArkUIBaseNode> InquireUniqueId::GetNodeUniqueId()
    {
        ArkUI_NativeNodeAPI_1* nodeAPI = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();
        ArkUI_NodeHandle testNode = nodeAPI->createNode(ARKUI_NODE_COLUMN);
        ArkUI_NumberValue value[] = {VALUE_1};
        ArkUI_AttributeItem item = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        value[0].f32 = VALUE_2;
        nodeAPI->setAttribute(testNode, NODE_WIDTH, &item);
        nodeAPI->setAttribute(testNode, NODE_HEIGHT, &item);
        struct IdList {
            int32_t id = -1;
        };
        IdList *idl = new IdList;
        int32_t uid = -1;
        OH_ArkUI_NodeUtils_GetNodeUniqueId(testNode, &uid);
        idl->id = uid;
        auto button = nodeAPI->createNode(ARKUI_NODE_BUTTON);
        value[0].f32 = VALUE_3;
        nodeAPI->setAttribute(button, NODE_WIDTH, &item);
        nodeAPI->setAttribute(button, NODE_HEIGHT, &item);
        nodeAPI->addChild(testNode, button);
        nodeAPI->registerNodeEvent(button, NODE_ON_CLICK, 1, idl);
        OH_LOG_Print(LOG_APP, LOG_WARN, LOG_PRINT, "GetNodeUniqueId", "GetNodeHandleByUniqueId success1");
        nodeAPI->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
            auto targetId = OH_ArkUI_NodeEvent_GetTargetId(event);
            if (targetId == 1) {
                auto idl = (IdList *)OH_ArkUI_NodeEvent_GetUserData(event);
                ArkUI_NodeHandle Test_Column;
                auto ec = OH_ArkUI_NodeUtils_GetNodeHandleByUniqueId(idl->id, &Test_Column);
                if (ec == 0) {
                    OH_LOG_Print(LOG_APP, LOG_WARN, LOG_PRINT, "GetNodeUniqueId", "GetNodeHandleByUniqueId success");
                }
            }
        });
        // [End ndknodequeryoperate1_start]
        return std::make_shared<ArkUINode>(testNode);
    }
}
