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

#ifndef NATIVE_NODE_NAPI_NAVIGATIONCONTEXT_H
#define NATIVE_NODE_NAPI_NAVIGATIONCONTEXT_H

#include "manager.h"

class NavigationContext {
public:
    NavigationContext() {}
    ~NavigationContext() {}
    static void NavigationInfoTest1(ArkUI_NodeHandle node);
    static void NavigationInfoTest2(ArkUI_NodeHandle node);
    static void RouterPageInfoTest(ArkUI_NodeHandle node);
};

#endif //NATIVE_NODE_NAPI_NAVIGATIONCONTEXT_H
