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

#ifndef COMMON_EVENT_PUBLISH_H
#define COMMON_EVENT_PUBLISH_H

// [Start event_publisher_import]
#include <cstdint>
#include <cstdio>
#include <cwchar>
#include <cstring>
#include "hilog/log.h"
#include "BasicServicesKit/oh_commonevent.h"

const long PARAM_LONG_VALUE1 = 2147483646;
const long PARAM_LONG_VALUE2 = 2147483645;
const long PARAM_LONG_VALUE3 = 555;
const double PARAM_DOUBLE_VALUE1 = 11.22;
const double PARAM_DOUBLE_VALUE2 = 33.44;
const double PARAM_DOUBLE_VALUE3 = 55.66;
const int PARAM_INT_VALUE1 = 10;
const int PARAM_INT_VALUE2 = 123;
const int PARAM_INT_VALUE3 = 234;
const int PARAM_INT_VALUE4 = 567;
// [End event_publisher_import]

#ifdef __cplusplus
extern "C" {
#endif

void Publish(const char *event);

void PublishWithInfo(const char *event, CommonEvent_PublishInfo *info);

void SetPublishInfo(const char *bundleName, const char *permissions[], int32_t num, const int32_t code,
                    const char *data);
CommonEvent_Parameters *CreateParameters();

void DestroyPublishInfo(CommonEvent_Parameters *param, CommonEvent_PublishInfo *info);

#ifdef __cplusplus
}
#endif

#endif // COMMON_EVENT_PUBLISH_H