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

#ifndef COMMON_EVENT_UNSUBSCRIBER_H
#define COMMON_EVENT_UNSUBSCRIBER_H

// [Start event_unsubscriber_import]
#include <cstdint>
#include "hilog/log.h"
#include "BasicServicesKit/oh_commonevent.h"
// [End event_unsubscriber_import]

#ifdef __cplusplus
extern "C" {
#endif

// 取消订阅公共事件
void Unsubscribe(CommonEvent_Subscriber* subscriber);

#ifdef __cplusplus
}
#endif

#endif // COMMON_EVENT_UNSUBSCRIBER_H