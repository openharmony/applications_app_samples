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

#include "common_event_subscribe.h"
// [Start event_subscriber_create_destroy]
CommonEvent_SubscribeInfo *CreateSubscribeInfo(const char *events[], int32_t eventsNum, const char *permission,
                                               const char *bundleName)
{
    int32_t ret = -1;
    // 创建订阅者信息
    CommonEvent_SubscribeInfo *info = OH_CommonEvent_CreateSubscribeInfo(events, eventsNum);

    // 设置发布者权限
    ret = OH_CommonEvent_SetPublisherPermission(info, permission);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetPublisherPermission ret <%{public}d>.", ret);

    // 设置发布者包名称
    ret = OH_CommonEvent_SetPublisherBundleName(info, bundleName);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetPublisherBundleName ret <%{public}d>.", ret);
    return info;
}

// 销毁订阅者信息
void DestroySubscribeInfo(CommonEvent_SubscribeInfo *info)
{
    OH_CommonEvent_DestroySubscribeInfo(info);
    info = nullptr;
}

// [End event_subscriber_create_destroy]

// [Start event_subscriber_on_receive]
// 公共事件回调函数
void OnReceive(const CommonEvent_RcvData *data)
{
    // 获取回调公共事件名称
    const char *event = OH_CommonEvent_GetEventFromRcvData(data);

    // 获取回调公共事件结果代码
    int code = OH_CommonEvent_GetCodeFromRcvData(data);

    // 获取回调公共事件自定义结果数据
    const char *retData = OH_CommonEvent_GetDataStrFromRcvData(data);

    // 获取回调公共事件包名称
    const char *bundle = OH_CommonEvent_GetBundleNameFromRcvData(data);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST",
                 "event: %{public}s, code: %{public}d, data: %{public}s, bundle: %{public}s", event, code, retData,
                 bundle);
}
// [End event_subscriber_on_receive]

// [Start event_subscriber_get_parameters]
void GetParameters(const CommonEvent_RcvData *data)
{
    // 获取回调公共事件附件信息
    bool exists = false;
    const CommonEvent_Parameters *parameters = OH_CommonEvent_GetParametersFromRcvData(data);

    // 检查公共事件附加信息中是否包含某个键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "intKey");
    // 获取公共事件附加信息中int数据信息
    int intValue = OH_CommonEvent_GetIntFromParameters(parameters, "intKey", 10);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "exists = %{public}d, intValue = %{public}d", exists, intValue);

    // 补充说明：除int类型外，还支持获取以下多种类型的公共事件附加信息，调用对应鸿蒙API即可：
    // - 基础数据类型：bool（OH_CommonEvent_GetBoolFromParameters）、long（OH_CommonEvent_GetLongFromParameters）、
    //   double（OH_CommonEvent_GetDoubleFromParameters）、char（OH_CommonEvent_GetCharFromParameters）
    // -
    // 数组数据类型：int数组（OH_CommonEvent_GetIntArrayFromParameters）、long数组（OH_CommonEvent_GetLongArrayFromParameters）、
    //   double数组（OH_CommonEvent_GetDoubleArrayFromParameters）、char数组（OH_CommonEvent_GetCharArrayFromParameters）、
    //   bool数组（OH_CommonEvent_GetBoolArrayFromParameters）
    // 所有类型均支持通过OH_CommonEvent_HasKeyInParameters先校验键是否存在，避免获取失败
}
// [End event_subscriber_get_parameters]

void GetCommonEventBoolParam(const CommonEvent_Parameters *parameters)
{
    bool exists = false;
    // 检查公共事件附加信息中是否包含boolKey键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "boolKey");
    // 获取公共事件附加信息中bool数据信息
    bool boolValue = OH_CommonEvent_GetBoolFromParameters(parameters, "boolKey", false);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "exists = %{public}d, boolValue = %{public}d", exists, boolValue);
}

void GetCommonEventLongParam(const CommonEvent_Parameters *parameters)
{
    bool exists = false;
    // 检查公共事件附加信息中是否包含longKey键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "longKey");
    // 获取公共事件附加信息中long数据信息
    long longValue = OH_CommonEvent_GetLongFromParameters(parameters, "longKey", 1111111111);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "exists = %{public}d, longValue = %{public}ld", exists, longValue);
}

void GetCommonEventDoubleParam(const CommonEvent_Parameters *parameters)
{
    bool exists = false;
    // 检查公共事件附加信息中是否包含doubleKey键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "doubleKey");
    // 获取公共事件附加信息中double数据信息
    double doubleValue = OH_CommonEvent_GetDoubleFromParameters(parameters, "doubleKey", 11.11);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "exists = %{public}d, doubleValue = %{public}f", exists,
                 doubleValue);
}

void GetCommonEventCharParam(const CommonEvent_Parameters *parameters)
{
    bool exists = false;
    // 检查公共事件附加信息中是否包含charKey键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "charKey");
    // 获取公共事件附加信息中char数据信息
    char charValue = OH_CommonEvent_GetCharFromParameters(parameters, "charKey", 'A');
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "exists = %{public}d, charValue = %{public}c", exists, charValue);
}

void GetCommonEventIntArrayParam(const CommonEvent_Parameters *parameters)
{
    bool exists = false;
    int **arr = new int *;
    // 检查公共事件附加信息中是否包含intArrayKey键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "intArrayKey");
    // 获取公共事件附加信息中int数组信息
    int32_t intArraySize = OH_CommonEvent_GetIntArrayFromParameters(parameters, "intArrayKey", arr);
    if (intArraySize <= 0 || *arr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST",
                     "exists = %{public}d, Failed to get int array or invalid size: %{public}d", exists, intArraySize);
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "exists = %{public}d, intArraySize = %{public}d", exists,
                     intArraySize);
        for (int i = 0; i < intArraySize; i++) {
            OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "<%{public}d>", *((*arr) + i));
        }
    }
}

void GetCommonEventLongArrayParam(const CommonEvent_Parameters *parameters)
{
    bool exists = false;
    long **longArray = new long *;
    // 检查公共事件附加信息中是否包含longArrayKey键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "longArrayKey");
    // 获取公共事件附加信息中long数组信息
    int32_t longArraySize = OH_CommonEvent_GetLongArrayFromParameters(parameters, "longArrayKey", longArray);
    if (longArraySize <= 0 || *longArray == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST",
                     "exists = %{public}d, Failed to get long array or invalid size: %{public}d", exists,
                     longArraySize);
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "exists = %{public}d, longArraySize = %{public}d", exists,
                     longArraySize);
        for (int i = 0; i < longArraySize; i++) {
            OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "<%{public}ld>", *((*longArray) + i));
        }
    }
}

void GetCommonEventDoubleArrayParam(const CommonEvent_Parameters *parameters)
{
    bool exists = false;
    double **doubleArray = new double *;
    // 检查公共事件附加信息中是否包含doubleArrayKey键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "doubleArrayKey");
    // 获取公共事件附加信息中double数组信息
    int32_t doubleArraySize = OH_CommonEvent_GetDoubleArrayFromParameters(parameters, "doubleArrayKey", doubleArray);
    if (doubleArraySize <= 0 || *doubleArray == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST",
                     "exists = %{public}d, Failed to get double array or invalid size: %{public}d", exists,
                     doubleArraySize);
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "exists = %{public}d, doubleArraySize = %{public}d", exists,
                     doubleArraySize);
        for (int i = 0; i < doubleArraySize; i++) {
            OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "<%{public}f>", *((*doubleArray) + i));
        }
    }
}

void GetCommonEventCharArrayParam(const CommonEvent_Parameters *parameters)
{
    bool exists = false;
    char **charArray = new char *;
    // 检查公共事件附加信息中是否包含charArrayKey键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "charArrayKey");
    // 获取公共事件附加信息中char数组信息
    int32_t charArraySize = OH_CommonEvent_GetCharArrayFromParameters(parameters, "charArrayKey", charArray);
    if (charArraySize <= 0 || *charArray == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST",
                     "exists = %{public}d, Failed to get charArray or invalid size: %{public}d", exists, charArraySize);
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "charArray as string: %{public}s", *charArray);
    }
}

void GetCommonEventBoolArrayParam(const CommonEvent_Parameters *parameters)
{
    bool exists = false;
    bool **boolArray = new bool *;
    // 检查公共事件附加信息中是否包含boolArrayKey键值对信息
    exists = OH_CommonEvent_HasKeyInParameters(parameters, "boolArrayKey");
    // 获取公共事件附加信息中bool数组信息
    int32_t boolArraySize = OH_CommonEvent_GetBoolArrayFromParameters(parameters, "boolArrayKey", boolArray);
    if (boolArraySize <= 0 || *boolArray == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST",
                     "exists = %{public}d, Failed to get boolArray or invalid size: %{public}d", exists, boolArraySize);
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "exists = %{public}d, boolArraySize = %{public}d", exists,
                     boolArraySize);
        for (int i = 0; i < boolArraySize; i++) {
            OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "<%{public}d>", *((*boolArray) + i));
        }
    }
}

// [Start event_subscriber_create_and_destroy]
// 创建订阅者
CommonEvent_Subscriber *CreateSubscriber(CommonEvent_SubscribeInfo *info)
{
    return OH_CommonEvent_CreateSubscriber(info, OnReceive);
}

// 销毁订阅者
void DestroySubscriber(CommonEvent_Subscriber *Subscriber)
{
    OH_CommonEvent_DestroySubscriber(Subscriber);
    Subscriber = nullptr;
}
// [End event_subscriber_create_and_destroy]

// [Start event_subscriber_subscriber]
void Subscribe(CommonEvent_Subscriber *subscriber)
{
    // 通过传入订阅者来订阅事件
    int32_t ret = OH_CommonEvent_Subscribe(subscriber);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_Subscribe ret <%{public}d>.", ret);
}
// [End event_subscriber_subscriber]

// [Start event_subscriber_abort_event]
void AbortCommonEvent(CommonEvent_Subscriber *subscriber)
{
    // 判断是否为有序公共事件
    if (!OH_CommonEvent_IsOrderedCommonEvent(subscriber)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "Not ordered common event.");
        return;
    }
    // 中止有序事件
    if (OH_CommonEvent_AbortCommonEvent(subscriber)) {
        if (OH_CommonEvent_FinishCommonEvent(subscriber)) {
            // 获取当前有序公共事件是否处于中止状态
            OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "Abort common event success, Get abort <%{public}d>.",
                         OH_CommonEvent_GetAbortCommonEvent(subscriber));
        }
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST", "Abort common event failed.");
    }
}
// [End event_subscriber_abort_event]

// [Start event_subscriber_clear]
void ClearAbortCommonEvent(CommonEvent_Subscriber *subscriber)
{
    // 判断是否为有序公共事件
    if (!OH_CommonEvent_IsOrderedCommonEvent(subscriber)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "Not ordered common event.");
        return;
    }
    // 中止有序事件
    if (!OH_CommonEvent_AbortCommonEvent(subscriber)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST", "Abort common event failed.");
        return;
    }
    // 取消中止有序事件
    if (OH_CommonEvent_ClearAbortCommonEvent(subscriber)) {
        if (OH_CommonEvent_FinishCommonEvent(subscriber)) {
            // 获取当前有序公共事件是否处于中止状态
            OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "Clear abort common event success, Get abort <%{public}d>.",
                         OH_CommonEvent_GetAbortCommonEvent(subscriber));
        }
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST", "Clear abort common event failed.");
    }
}
// [End event_subscriber_clear]

// [Start event_subscriber_set_get]
void SetToSubscriber(CommonEvent_Subscriber *subscriber, const int32_t code, const char *data)
{
    // 设置有序公共事件的代码
    if (!OH_CommonEvent_SetCodeToSubscriber(subscriber, code)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST", "OH_CommonEvent_SetCodeToSubscriber failed.");
        return;
    }
    // 设置有序公共事件的数据
    size_t dataLength = strlen(data);
    if (!OH_CommonEvent_SetDataToSubscriber(subscriber, data, dataLength)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 1, "CES_TEST", "OH_CommonEvent_SetDataToSubscriber failed.");
        return;
    }
}

void GetFromSubscriber(CommonEvent_Subscriber *subscriber)
{
    // 获取有序公共事件的数据和代码
    const char *data = OH_CommonEvent_GetDataFromSubscriber(subscriber);
    int32_t code = OH_CommonEvent_GetCodeFromSubscriber(subscriber);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "Subscriber data <%{public}s>, code <%{public}d>.", data, code);
}
// [End event_subscriber_set_get]