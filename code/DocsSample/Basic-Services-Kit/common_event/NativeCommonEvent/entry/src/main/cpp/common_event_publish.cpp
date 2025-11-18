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

#include "common_event_publish.h"

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

// [Start event_publisher_publish]
void Publish(const char* event)
{
    int32_t ret = OH_CommonEvent_Publish(event);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_Publish ret <%{public}d>.", ret);
}
// [End event_publisher_publish]

// [Start event_publisher_publish_info]
void PublishWithInfo(const char* event, CommonEvent_PublishInfo* info)
{
    // 创建时带入公共事件属性对象
    int32_t ret = OH_CommonEvent_PublishWithInfo(event, info);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_PublishWithInfo ret <%{public}d>.", ret);
}
// [End event_publisher_publish_info]

// [Start event_publisher_create_set]
// 创建并添加公共事件属性附加信息
CommonEvent_Parameters* CreateParameters()
{
    int32_t ret = -1;
    // 创建公共事件附加信息
    CommonEvent_Parameters* param = OH_CommonEvent_CreateParameters();
    
    // 设置int类型附加信息和key
    ret = OH_CommonEvent_SetIntToParameters(param, "intKey", PARAM_INT_VALUE1);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetIntToParameters ret <%{public}d>.", ret);

    // 设置int数组类型附加信息和key
    int intArray[] = {PARAM_INT_VALUE2, PARAM_INT_VALUE3, PARAM_INT_VALUE4};
    size_t arraySize = sizeof(intArray) / sizeof(intArray[0]);
    ret = OH_CommonEvent_SetIntArrayToParameters(param, "intArrayKey", intArray, arraySize);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetIntArrayToParameters ret <%{public}d>.", ret);
    
    // 设置long类型附加信息和key
    ret = OH_CommonEvent_SetLongToParameters(param, "longKey", PARAM_LONG_VALUE1);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetLongToParameters ret <%{public}d>.", ret);

    // 设置long数组类型附加信息和key
    long longArray[] = {PARAM_LONG_VALUE1, PARAM_LONG_VALUE3, PARAM_LONG_VALUE2};
    ret = OH_CommonEvent_SetLongArrayToParameters(param, "longArrayKey", longArray, arraySize);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetLongArrayToParameters ret <%{public}d>.", ret);
    
    // 设置double类型附加信息和key
    ret = OH_CommonEvent_SetDoubleToParameters(param, "doubleKey", PARAM_DOUBLE_VALUE1);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetDoubleToParameters ret <%{public}d>.", ret);

    // 设置double数组类型附加信息和key
    double doubleArray[] = {PARAM_DOUBLE_VALUE1, PARAM_DOUBLE_VALUE2, PARAM_DOUBLE_VALUE3};
    ret = OH_CommonEvent_SetDoubleArrayToParameters(param, "doubleArrayKey", doubleArray, arraySize);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetDoubleArrayToParameters ret <%{public}d>.", ret);
    
    // 设置boolean类型附加信息和key
    ret = OH_CommonEvent_SetBoolToParameters(param, "boolKey", true);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetBoolToParameters ret <%{public}d>.", ret);

    // 设置boolean数组类型附加信息和key
    bool boolArray[] = {true, false, true};
    ret = OH_CommonEvent_SetBoolArrayToParameters(param, "boolArrayKey", boolArray, arraySize);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetBoolArrayToParameters ret <%{public}d>.", ret);
    
    // 设置char类型附加信息和key
    ret = OH_CommonEvent_SetCharToParameters(param, "charKey", 'A');
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetCharToParameters ret <%{public}d>.", ret);

    // 设置char数组类型附加信息和key
    const char* value = "Char Array";
    size_t valueLength = strlen(value);
    ret = OH_CommonEvent_SetCharArrayToParameters(param, "charArrayKey", value, valueLength);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetCharArrayToParameters ret <%{public}d>.", ret);
    return param;
}

// 设置公共事件属性
void SetPublishInfo(const char* bundleName, const char* permissions[], int32_t num,
                    const int32_t code, const char* data)
{
    int32_t ret = -1;
    // 创建publishInfo，设置是否为有序公共事件，取值为true，表示有序公共事件；取值为false，表示无序公共事件
    CommonEvent_PublishInfo* info = OH_CommonEvent_CreatePublishInfo(true);

    // 设置公共事件包名称
    ret = OH_CommonEvent_SetPublishInfoBundleName(info, bundleName);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetPublishInfoBundleName ret <%{public}d>.", ret);

    // 设置公共事件权限，参数为权限数组和权限的数量
    ret = OH_CommonEvent_SetPublishInfoPermissions(info, permissions, num);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetPublishInfoPermissions ret <%{public}d>.", ret);

    // 设置公共事件结果码
    ret = OH_CommonEvent_SetPublishInfoCode(info, code);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetPublishInfoCode ret <%{public}d>.", ret);

    // 设置公共事件结果数据
    size_t dataLength = strlen(data);
    ret = OH_CommonEvent_SetPublishInfoData(info, data, dataLength);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetPublishInfoData ret <%{public}d>.", ret);

    // 设置公共事件附加信息
    CommonEvent_Parameters* param = CreateParameters();
    ret = OH_CommonEvent_SetPublishInfoParameters(info, param);
    OH_LOG_Print(LOG_APP, LOG_INFO, 1, "CES_TEST", "OH_CommonEvent_SetPublishInfoParameters ret <%{public}d>.", ret);
}
// [End event_publisher_create_set]

// [Start event_publisher_destroy]
void DestroyPublishInfo(CommonEvent_Parameters* param, CommonEvent_PublishInfo* info)
{
    // 先销毁Parameters
    OH_CommonEvent_DestroyParameters(param);
    param = nullptr;
    // 销毁PublishInfo
    OH_CommonEvent_DestroyPublishInfo(info);
    info = nullptr;
}
// [End event_publisher_destroy]