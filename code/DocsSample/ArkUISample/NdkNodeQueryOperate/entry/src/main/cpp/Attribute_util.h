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

// [Start ndknodequeryoperate7_start]
#ifndef MYAPPLICATION_ATTRIBUTE_UTIL_H
#define MYAPPLICATION_ATTRIBUTE_UTIL_H

#include <arkui/native_node.h>
#include <cstdint>
#include <string>
class AttributeUtil {
public:
    ArkUI_NativeNodeAPI_1 *api_;
    ArkUI_NodeHandle node_;
    AttributeUtil(ArkUI_NodeHandle node, ArkUI_NativeNodeAPI_1 *api)
    {
        this->node_ = node;
        api_ = api;
    }
    int32_t Width(float width)
    {
        ArkUI_NumberValue NODE_WIDTH_value[] = {width};
        ArkUI_AttributeItem NODE_WIDTH_Item = {NODE_WIDTH_value, 1};
        return api_->setAttribute(node_, NODE_WIDTH, &NODE_WIDTH_Item);
    }
    int32_t Height(float height)
    {
        ArkUI_NumberValue NODE_HEIGHT_value[] = {height};
        ArkUI_AttributeItem NODE_HEIGHT_Item = {NODE_HEIGHT_value, 1};
        return api_->setAttribute(node_, NODE_HEIGHT, &NODE_HEIGHT_Item);
    }
    int32_t ImageSrc(std::string src)
    {
        ArkUI_AttributeItem NODE_IMAGE_SRC_VALUE = {.string = src.c_str()};
        return api_->setAttribute(node_, NODE_IMAGE_SRC, &NODE_IMAGE_SRC_VALUE);
    }
    int32_t ImageSyncLoad()
    {
        ArkUI_NumberValue NODE_TRANSLATE_ITEM_VALUE[] = {{.i32 = 1}};
        ArkUI_AttributeItem NODE_BORDER_WIDTH_ITEM = {NODE_TRANSLATE_ITEM_VALUE, 1};
        return api_->setAttribute(node_, NODE_IMAGE_SYNC_LOAD, &NODE_BORDER_WIDTH_ITEM);
    }
};
#endif // MYAPPLICATION_ATTRIBUTE_UTIL_H
// [End ndknodequeryoperate7_start]
