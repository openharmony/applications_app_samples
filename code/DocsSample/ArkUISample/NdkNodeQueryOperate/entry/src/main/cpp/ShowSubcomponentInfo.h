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

#ifndef NDKNODEQUERYOPERATE_SHOWSUBCOMPONENTINFO_H
#define NDKNODEQUERYOPERATE_SHOWSUBCOMPONENTINFO_H

#include <arkui/styled_string.h>
#include <hilog/log.h>
#include <arkui/native_node.h>
#include "ArkUINode.h"

#define LOG_TAG "ShowSubcomponentInfo"
#define LOG_INFO(...) OH_LOG_Print(LOG_APP, LOG_INFO, 0xD001400, LOG_TAG, __VA_ARGS__)

namespace NativeModule {
std::shared_ptr<ArkUIBaseNode> ShowSubcomponentInfo()
{
    // [Start ndknodequeryoperate9_start]
    ArkUI_NodeHandle childNode = nullptr;
    OH_ArkUI_NodeUtils_GetAttachedNodeHandleById("N3", &childNode);
    
    uint32_t index = 0;
    OH_ArkUI_NodeUtils_GetFirstChildIndexWithoutExpand(childNode, &index);
    uint32_t index1 = 0;
    OH_ArkUI_NodeUtils_GetLastChildIndexWithoutExpand(childNode, &index1);
    ArkUI_NodeHandle child = nullptr;
    auto result = OH_ArkUI_NodeUtils_GetChildWithExpandMode(childNode, 3, &child, 0);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "Manager",
        "firstChildIndex - lastChildIndex == %{d -- %{public}d, -- getResult = %{public}d",
        index, index1, result);
    // [End ndknodequeryoperate9_start]
    return nullptr;
}
}
#endif //NDKNODEQUERYOPERATE_SHOWSUBCOMPONENTINFO_H
