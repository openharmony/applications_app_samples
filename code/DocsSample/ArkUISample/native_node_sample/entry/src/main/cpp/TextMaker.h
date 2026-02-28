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

#ifndef TEXT_MAKER_H
#define TEXT_MAKER_H

#include "manager.h"

struct Boundary {
    size_t leftIndex = 0;  // include leftIndex_
    size_t rightIndex = 0; // not include rightIndex_

    Boundary(size_t left, size_t right)
    {
        leftIndex = left;
        rightIndex = right;
    }

    bool operator==(const Boundary &rhs) const { return leftIndex == rhs.leftIndex && rightIndex == rhs.rightIndex; }
};
class TextMaker {
public:
    TextMaker(){};
    ~TextMaker(){};
    static ArkUI_NodeHandle CreateNativeNode();
    static ArkUI_Node* text17;
    static ArkUI_Node* text22;
};

#endif // NATIVE_TYPE_SAMPLE_SWIPERMAKER_H
