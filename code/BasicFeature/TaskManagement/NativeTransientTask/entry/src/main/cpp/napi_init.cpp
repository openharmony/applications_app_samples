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

// [Start encapsulation_function]
#include "napi/native_api.h"
#include "transient_task/transient_task_api.h"

TransientTask_DelaySuspendInfo delaySuspendInfo;
const int32_t TransientTask_TIMER = 3;

static void Callback(void)
{
   // 短时任务即将结束，业务在这里取消短时任务
   OH_BackgroundTaskManager_CancelSuspendDelay(delaySuspendInfo.requestId);
}

// 申请短时任务
static napi_value RequestSuspendDelay(napi_env env, napi_callback_info info)
{
   napi_value result;
   int32_t res = OH_BackgroundTaskManager_RequestSuspendDelay("test", Callback, &delaySuspendInfo);
   if (res == 0) {
      napi_create_int32(env, delaySuspendInfo.requestId, &result);
   } else {
      napi_create_int32(env, -1, &result);
   }
   return result;
}

// 获取剩余时间
static napi_value GetRemainingDelayTime(napi_env env, napi_callback_info info)
{
   napi_value result;
   int32_t delayTime = 0;
   int32_t res = OH_BackgroundTaskManager_GetRemainingDelayTime(delaySuspendInfo.requestId, &delayTime);
   if (res == 0) {
      napi_create_int32(env, delayTime, &result);
   } else {
      napi_create_int32(env, -1, &result);
   }
   return result;
}

// 取消短时任务
static napi_value CancelSuspendDelay(napi_env env, napi_callback_info info)
{
   napi_value result;
   int32_t res = OH_BackgroundTaskManager_CancelSuspendDelay(delaySuspendInfo.requestId);
   napi_create_int32(env, res, &result);
   return result;
}

// 获取所有短时任务信息
TransientTask_TransientTaskInfo transientTaskInfo;

static napi_value GetTransientTaskInfo(napi_env env, napi_callback_info info)
{
   napi_value result;
   napi_create_object(env, &result);
   int32_t res = OH_BackgroundTaskManager_GetTransientTaskInfo(&transientTaskInfo);
   napi_value napiRemainingQuota = nullptr;
   // 获取成功，格式化数据并返回给接口
   if (res == 0) {
      napi_create_int32(env, transientTaskInfo.remainingQuota, &napiRemainingQuota);
      napi_set_named_property(env, result, "remainingQuota", napiRemainingQuota); // 格式化当日总配额

      napi_value info {nullptr};
      napi_create_array(env, &info);
      uint32_t count = 0;
      // 格式化所有已申请的短时任务信息
      for (int index = 0; index < TransientTask_TIMER; index++) {
         if (transientTaskInfo.transientTasks[index].requestId == 0) {
            continue;
         }
         
         napi_value napiWork = nullptr;
         napi_create_object(env, &napiWork);

         napi_value napiRequestId = nullptr;
         napi_create_int32(env, transientTaskInfo.transientTasks[index].requestId, &napiRequestId);
         napi_set_named_property(env, napiWork, "requestId", napiRequestId);

         napi_value napiActualDelayTime = nullptr;
         napi_create_int32(env, transientTaskInfo.transientTasks[index].actualDelayTime, &napiActualDelayTime);
         napi_set_named_property(env, napiWork, "actualDelayTime", napiActualDelayTime);

         napi_set_element(env, info, count, napiWork);
         count++;
      }
      napi_set_named_property(env, result, "transientTasks", info);
   } else {
      napi_create_int32(env, 0, &napiRemainingQuota);
      napi_set_named_property(env, result, "remainingQuota", napiRemainingQuota);
      napi_value info {nullptr};
      napi_create_array(env, &info);
      napi_set_named_property(env, result, "transientTasks", info);
   }
   return result;
}

// [End encapsulation_function]

// [Start registration_function]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
   napi_property_descriptor desc[] = {
      {"RequestSuspendDelay", nullptr, RequestSuspendDelay, nullptr, nullptr, nullptr, napi_default, nullptr},
      {"GetRemainingDelayTime", nullptr, GetRemainingDelayTime, nullptr, nullptr, nullptr, napi_default, nullptr},
      {"CancelSuspendDelay", nullptr, CancelSuspendDelay, nullptr, nullptr, nullptr, napi_default, nullptr},
      {"GetTransientTaskInfo", nullptr, GetTransientTaskInfo, nullptr, nullptr, nullptr, napi_default, nullptr },
   };
   napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
   return exports;
}
EXTERN_C_END
// [End registration_function]

// [Start registration_module]
static napi_module demoModule = {
   .nm_version = 1,
   .nm_flags = 0,
   .nm_filename = nullptr,
   .nm_register_func = Init,
   .nm_modname = "entry",
   .nm_priv = ((void*)0),
   .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
   napi_module_register(&demoModule);
}
// [End registration_module]