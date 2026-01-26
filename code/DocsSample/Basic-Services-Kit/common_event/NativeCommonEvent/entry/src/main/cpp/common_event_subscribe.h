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

#ifndef COMMON_EVENT_SUBSCRIBE_H
#define COMMON_EVENT_SUBSCRIBE_H

// [Start event_subscriber_import]
#include <cstdint>
#include <cstring>
#include "hilog/log.h"
#include "BasicServicesKit/oh_commonevent.h"
// [End event_subscriber_import]

#ifdef __cplusplus
extern "C" {
#endif

// 订阅者信息创建和销毁
CommonEvent_SubscribeInfo *CreateSubscribeInfo(const char *events[], int32_t eventsNum, const char *permission,
                                               const char *bundleName);
void DestroySubscribeInfo(CommonEvent_SubscribeInfo *info);

// 订阅者创建和销毁
CommonEvent_Subscriber *CreateSubscriber(CommonEvent_SubscribeInfo *info);
void DestroySubscriber(CommonEvent_Subscriber *subscriber);

// 事件订阅
void Subscribe(CommonEvent_Subscriber *subscriber);

// 公共事件回调函数
void OnReceive(const CommonEvent_RcvData *data);
void GetParameters(const CommonEvent_RcvData *data);
void GetCommonEventBoolParam(const CommonEvent_Parameters *parameters);
void GetCommonEventLongParam(const CommonEvent_Parameters *parameters);
void GetCommonEventDoubleParam(const CommonEvent_Parameters *parameters);
void GetCommonEventCharParam(const CommonEvent_Parameters *parameters);
void GetCommonEventIntArrayParam(const CommonEvent_Parameters *parameters);
void GetCommonEventLongArrayParam(const CommonEvent_Parameters *parameters);
void GetCommonEventDoubleArrayParam(const CommonEvent_Parameters *parameters);
void GetCommonEventCharArrayParam(const CommonEvent_Parameters *parameters);
void GetCommonEventBoolArrayParam(const CommonEvent_Parameters *parameters);

// 有序公共事件处理
void AbortCommonEvent(CommonEvent_Subscriber *subscriber);
void ClearAbortCommonEvent(CommonEvent_Subscriber *subscriber);
void SetToSubscriber(CommonEvent_Subscriber *subscriber, const int32_t code, const char *data);
void GetFromSubscriber(CommonEvent_Subscriber *subscriber);

#ifdef __cplusplus
}
#endif

#endif // COMMON_EVENT_SUBSCRIBE_H