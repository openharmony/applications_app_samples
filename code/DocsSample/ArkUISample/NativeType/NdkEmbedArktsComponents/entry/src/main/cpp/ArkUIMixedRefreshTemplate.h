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
// [Start arkui_mixed_refresh_template]

// 混合模式交互类。

#ifndef MYAPPLICATION_ARKUIMIXEDREFRESHTEMPLATE_H
#define MYAPPLICATION_ARKUIMIXEDREFRESHTEMPLATE_H

#include "ArkUIMixedNode.h"

#include <optional>

#include <arkui/native_node_napi.h>
#include <js_native_api_types.h>

namespace NativeModule {

class ArkUIMixedRefresh : public ArkUIMixedNode {
public:
    static napi_value RegisterCreateAndUpdateRefresh(napi_env env, napi_callback_info info);
};

} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIMIXEDREFRESHTEMPLATE_H
// [End arkui_mixed_refresh_template]