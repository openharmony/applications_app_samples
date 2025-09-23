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

#ifndef SCROLLABLENDK_COMPONENTS_LIST_EXAMPLES_LAZYTEXLISTEXAMPLE_H
#define SCROLLABLENDK_COMPONENTS_LIST_EXAMPLES_LAZYTEXLISTEXAMPLE_H

#include <arkui/native_node_napi.h>
#include <napi/native_api.h>

#include "common/ArkUINode.h"
#include "components/list/ListItemGroupNode.h"
#include "components/list/ListNode.h"

namespace ScrollableNDK::Examples {

struct AlphabetIndexedListImpl {
    static napi_value NAPI(napi_env env, napi_callback_info info);
};

} // namespace ScrollableNDK::Examples

#endif // SCROLLABLENDK_COMPONENTS_LIST_EXAMPLES_LAZYTEXLISTEXAMPLE_H
