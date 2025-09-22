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

#include "baseUtils.h"
#include "TextMaker.h"

namespace ConstIde {
    const uint32_t NUMBER_0 = 0;
    const uint32_t NUMBER_1 = 1;
    const uint32_t NUMBER_2 = 2;
    const uint32_t MARGIN_NUMBER_30 = 30;
}

void BaseUtils::SetNodeMargin(ArkUI_NodeHandle &node, float margin)
{
    ArkUI_NumberValue value[ConstIde::NUMBER_1];
    ArkUI_AttributeItem item = {.value = value, .size = ConstIde::NUMBER_1};
    value[ConstIde::NUMBER_0].f32 = margin;
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &item);
}

void BaseUtils::SetNodeBackGroundColor(ArkUI_NodeHandle &node, uint32_t color)
{
    ArkUI_NumberValue value[ConstIde::NUMBER_1];
    ArkUI_AttributeItem item = {.value = value, .size = ConstIde::NUMBER_1};
    value[ConstIde::NUMBER_0].u32 = color;
    Manager::nodeAPI_->setAttribute(node, NODE_BACKGROUND_COLOR, &item);
}