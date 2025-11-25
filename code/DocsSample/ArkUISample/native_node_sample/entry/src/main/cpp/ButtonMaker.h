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

#ifndef BUTTON_MAKER_H
#define BUTTON_MAKER_H

#include "ScrollableNode.h"

#ifndef LOG_TAG
#define LOG_TAG "ButtonMaker"
#endif

class ButtonMaker : public BaseNode {
public:
    ButtonMaker() : BaseNode(NodeApiInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_BUTTON))
    {
        if (!IsNotNull(nodeApi_) || !IsNotNull(GetHandle())) {
            return;
        }

        nodeApi_->addNodeEventReceiver(GetHandle(), &ButtonMaker::StaticEventReceiver);
    }

    ~ButtonMaker() override = default;
};

#endif // BUTTON_MAKER_H
