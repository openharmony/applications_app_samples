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

#include "common_event_unsubscriber.h"
// [Start event_unsubscriber]
void Unsubscribe(CommonEvent_Subscriber* subscriber)
{
    // 通过传入订阅者来退订事件
    int32_t ret = OH_CommonEvent_UnSubscribe(subscriber);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_UnSubscribe ret <%{public}d>.", ret);
}
// [End event_unsubscriber]