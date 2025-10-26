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
// [Start mixed_refresh_example]
// MixedRefreshExample.h
// 混合模式示例代码。

#ifndef MYAPPLICATION_MIXEDREFRESHEXAMPLE_H
#define MYAPPLICATION_MIXEDREFRESHEXAMPLE_H

#include "ArkUIBaseNode.h"
#include "ArkUIMixedRefresh.h"
#include "NormalTextListExample.h"
#include "UITimer.h"

#include <js_native_api_types.h>

namespace NativeModule {

std::shared_ptr<ArkUIBaseNode> CreateMixedRefreshList(napi_env env)
{
    auto list = CreateTextListExample();
    // 混合模式创建Refresh组件并挂载List组件。
    NativeRefreshAttribute nativeRefreshAttribute{
        .backgroundColor = 0xFF89CFF0, .refreshOffset = 64, .pullToRefresh = true};
    auto refresh = ArkUIMixedRefresh::Create(nativeRefreshAttribute);
    refresh->AddChild(list);

    // 设置混合模式下的事件。
    refresh->SetOnOffsetChange(
        [](float offset) { OH_LOG_INFO(LOG_APP, "on refresh offset changed: %{public}f", offset); });
    refresh->SetRefreshCallback([refreshPtr = refresh.get(), env]() {
        OH_LOG_INFO(LOG_APP, "on refreshing");
        // 启动定时器，模拟数据获取。
        CreateNativeTimer(env, refreshPtr, 1, [](void *userData, int32_t count) {
            // 数据获取后关闭刷新。
            auto refresh = reinterpret_cast<ArkUIMixedRefresh *>(userData);
            refresh->SetRefreshState(false);
            refresh->FlushMixedModeCmd();
        });
    });

    // 更新事件到ArkTS侧。
    refresh->FlushMixedModeCmd();
    return refresh;
}

} // namespace NativeModule

#endif // MYAPPLICATION_MIXEDREFRESHEXAMPLE_H
// [End mixed_refresh_example]