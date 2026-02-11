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

// [Start unified_data_channels_c_head_file]
#include <cstdio>
#include <cstring>
#include <database/udmf/utd.h>
#include <database/udmf/uds.h>
#include <database/udmf/udmf.h>
#include <database/udmf/udmf_meta.h>
#include <database/udmf/udmf_err_code.h>
#include <hilog/log.h>

#undef LOG_TAG
#define LOG_TAG "MY_LOG"
// [End unified_data_channels_c_head_file]

// [Start unified_data_channels_c_write_data]
int32_t SetHyperlinkData(OH_UdsHyperlink* hyperlink, OH_UdmfRecord* record, OH_UdmfData* data)
{
    // 2.设置hyperlink中的URL和描述信息。
    int ret = OH_UdsHyperlink_SetUrl(hyperlink, "www.demo.com");
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Hyperlink set url error!");
        return ret;
    }
    ret = OH_UdsHyperlink_SetDescription(hyperlink, "This is the description.");
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Hyperlink set description error!");
        return ret;
    }
    // 3. 向OH_UdmfRecord中添加超链接类型数据。
    ret = OH_UdmfRecord_AddHyperlink(record, hyperlink);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Add hyperlink to record error!");
        return ret;
    }
    // 4. 并向OH_UdmfData中添加OH_UdmfRecord。
    ret = OH_UdmfData_AddRecord(data, record);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Add record to data error!");
        return ret;
    }
    return UDMF_E_OK;
}

int32_t CreateDataTest()
{
    // 1.创建hyperlink的UDS数据结构、OH_UdmfRecord对象及OH_UdmfData对象。
    OH_UdsHyperlink* hyperlink = OH_UdsHyperlink_Create();
    OH_UdmfRecord* record = OH_UdmfRecord_Create();
    OH_UdmfData* data = OH_UdmfData_Create();
    int32_t ret = SetHyperlinkData(hyperlink, record, data);
    if (ret != UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Create data error!");
        OH_UdsHyperlink_Destroy(hyperlink);
        OH_UdmfRecord_Destroy(record);
        OH_UdmfData_Destroy(data);
        return ret;
    }
    // 构建数据操作选项。
    OH_UdmfOptions* options = OH_UdmfOptions_Create();
    ret = OH_UdmfOptions_SetIntention(options, Udmf_Intention::UDMF_INTENTION_DATA_HUB);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Set option error!");
        OH_UdsHyperlink_Destroy(hyperlink);
        OH_UdmfRecord_Destroy(record);
        OH_UdmfData_Destroy(data);
        OH_UdmfOptions_Destroy(options);
        return ret;
    }
    // 6. 构建数据，将数据写入数据库中，得到返回的key值。
    char key[UDMF_KEY_BUFFER_LEN] = {0};
    ret = OH_Udmf_SetUnifiedDataByOptions(options, data, key, sizeof(key));
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Set data error!");
        OH_UdsHyperlink_Destroy(hyperlink);
        OH_UdmfRecord_Destroy(record);
        OH_UdmfData_Destroy(data);
        OH_UdmfOptions_Destroy(options);
        return ret;
    }
    OH_LOG_INFO(LOG_APP, "key = %{public}s", key);
    // 7. 使用完成后销毁指针。
    OH_UdsHyperlink_Destroy(hyperlink);
    OH_UdmfRecord_Destroy(record);
    OH_UdmfData_Destroy(data);
    OH_UdmfOptions_Destroy(options);
    return UDMF_E_OK;
}
// [End unified_data_channels_c_write_data]

// [Start unified_data_channels_c_get_data]
int32_t ProcessHyperlinks(OH_UdmfRecord* record, unsigned int recordTypeIdCount, char** typeIdsFromRecord)
{
    for (unsigned int k = 0; k < recordTypeIdCount; k++) {
         // 从OH_UdmfRecord中获取超链接类型数据。
        if (strcmp(typeIdsFromRecord[k], UDMF_META_HYPERLINK) == 0) {
             // 创建hyperlink的UDS，用来承载record中读取出来的hyperlink数据。
            OH_UdsHyperlink* hyperlink = OH_UdsHyperlink_Create();
            int32_t ret = OH_UdmfRecord_GetHyperlink(record, hyperlink);
            if (ret != Udmf_ErrCode::UDMF_E_OK) {
                OH_LOG_ERROR(LOG_APP, "Fail get hyperlink from record!");
                return ret;
            }
            // 读取OH_UdsHyperlink中的各项信息。
            OH_LOG_INFO(LOG_APP, "The hyperlink type id is : %{public}s", OH_UdsHyperlink_GetType(hyperlink));
            OH_LOG_INFO(LOG_APP, "The hyperlink url is : %{public}s", OH_UdsHyperlink_GetUrl(hyperlink));
            OH_LOG_INFO(LOG_APP, "The hyperlink description is : %{public}s",
                OH_UdsHyperlink_GetDescription(hyperlink));
            OH_UdsHyperlink_Destroy(hyperlink);
        }
    }
    return UDMF_E_OK;
}

int32_t ProcessData(OH_UdmfData* data)
{
    unsigned int recordsCount = 0;
    OH_UdmfRecord** records = OH_UdmfData_GetRecords(data, &recordsCount);
    OH_LOG_INFO(LOG_APP, "the count of records count is %{public}u", recordsCount);
    for (unsigned int j = 0; j < recordsCount; j++) {
        // 获取OH_UdmfRecord类型列表。
        unsigned int recordTypeIdCount = 0;
        char** typeIdsFromRecord = OH_UdmfRecord_GetTypes(records[j], &recordTypeIdCount);
        int32_t ret = ProcessHyperlinks(records[j], recordTypeIdCount, typeIdsFromRecord);
        if (ret != Udmf_ErrCode::UDMF_E_OK) {
            OH_LOG_ERROR(LOG_APP, "ProcessRecordHyperlinks error!");
            return ret;
        }
    }
    return UDMF_E_OK;
}

int32_t HandleUdmfHyperlinkData(OH_UdmfData* readData, unsigned int dataSize, OH_UdmfData** dataArray)
{
    for (unsigned int i = 0; i < dataSize; i++) {
        OH_UdmfData* data = OH_UDMF_GetDataElementAt(dataArray, i);
         // 3. 判断OH_UdmfData是否有对应的类型。
        if (!OH_UdmfData_HasType(data, UDMF_META_HYPERLINK)) {
            OH_LOG_INFO(LOG_APP, "There is no hyperlink type in data[%{public}u].", i);
            continue;
        }
        // 4. 获取数据记录和hyperlink数据。
        int32_t ret = ProcessData(data);
        if (ret != Udmf_ErrCode::UDMF_E_OK) {
            OH_LOG_ERROR(LOG_APP, "Process data error!");
            return ret;
        }
    }
    return UDMF_E_OK;
}

int32_t GetDataTest()
{
    // 1. 构建数据操作选项。
    OH_UdmfOptions* options = OH_UdmfOptions_Create();
    int32_t ret = OH_UdmfOptions_SetIntention(options, Udmf_Intention::UDMF_INTENTION_DATA_HUB);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Set option error!");
        OH_UdmfOptions_Destroy(options);
        return ret;
    }
    // 2. 通过数据操作选项获取数据。
    unsigned int dataSize = 0;
    OH_UdmfData* readData = nullptr;
    ret = OH_Udmf_GetUnifiedDataByOptions(options, &readData, &dataSize);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Get Data error!");
        OH_UdmfOptions_Destroy(options);
        return ret;
    }
    OH_UdmfOptions_Destroy(options);
    OH_LOG_INFO(LOG_APP, "the size of data is %{public}u", dataSize);
    OH_UdmfData** dataArray = &readData;
    ret = HandleUdmfHyperlinkData(readData, dataSize, dataArray);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Get Data error!");
        return ret;
    }
    // 5.销毁指针。
    OH_Udmf_DestroyDataArray(dataArray, dataSize);
    return UDMF_E_OK;
}
// [End unified_data_channels_c_get_data]

// [Start unified_data_channels_c_update_data]
int32_t AddHyperlinkToUdmfRecord(OH_UdsHyperlink* hyperlink, OH_UdmfRecord* record, OH_UdmfData* data)
{
    // 2. 设置hyperlink中的URL和描述信息。
    int32_t ret = OH_UdsHyperlink_SetUrl(hyperlink, "www.demo2.com");
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Hyperlink set url error!");
        return ret;
    }
    ret = OH_UdsHyperlink_SetDescription(hyperlink, "This is the new description.");
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Hyperlink set description error!");
        return ret;
    }
    // 3. 向OH_UdmfRecord中添加超链接类型数据。
    ret = OH_UdmfRecord_AddHyperlink(record, hyperlink);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Add hyperlink to record error!");
        return ret;
    }
    // 4. 向OH_UdmfData中添加OH_UdmfRecord。
    ret = OH_UdmfData_AddRecord(data, record);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Add record to data error!");
        return ret;
    }
    return UDMF_E_OK;
}

int32_t UpdateDataTest()
{
    // 1.创建hyperlink的UDS数据结构、OH_UdmfRecord对象及OH_UdmfData对象。
    OH_UdsHyperlink* hyperlink = OH_UdsHyperlink_Create();
    OH_UdmfRecord* record = OH_UdmfRecord_Create();
    OH_UdmfData* data = OH_UdmfData_Create();
    int32_t ret = AddHyperlinkToUdmfRecord(hyperlink, record, data);
    if (ret != UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Fail to create hyperlink!");
        OH_UdsHyperlink_Destroy(hyperlink);
        OH_UdmfRecord_Destroy(record);
        OH_UdmfData_Destroy(data);
        return ret;
    }
    // 5. 构建数据操作选项。
    OH_UdmfOptions* options = OH_UdmfOptions_Create();
    // 此处key为示例，不可直接使用，其值应与OH_Udmf_SetUnifiedDataByOptions接口中获取到的key值保持一致。
    char key[] = "udmf://DataHub/com.ohos.test/0123456789";
    ret = OH_UdmfOptions_SetIntention(options, Udmf_Intention::UDMF_INTENTION_DATA_HUB);
    if (ret != Udmf_ErrCode::UDMF_E_OK
        || OH_UdmfOptions_SetKey(options, key) != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Set option error!");
        OH_UdsHyperlink_Destroy(hyperlink);
        OH_UdmfRecord_Destroy(record);
        OH_UdmfData_Destroy(data);
        OH_UdmfOptions_Destroy(options);
        return ret;
    }
    // 6. 更新数据，将数据写入数据库中。
    ret = OH_Udmf_UpdateUnifiedData(options, data);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Update data error!");
        OH_UdsHyperlink_Destroy(hyperlink);
        OH_UdmfRecord_Destroy(record);
        OH_UdmfData_Destroy(data);
        OH_UdmfOptions_Destroy(options);
        return ret;
    }
    OH_LOG_INFO(LOG_APP, "update data success");
    // 7. 使用完成后销毁指针。
    OH_UdsHyperlink_Destroy(hyperlink);
    OH_UdmfRecord_Destroy(record);
    OH_UdmfData_Destroy(data);
    OH_UdmfOptions_Destroy(options);
    return UDMF_E_OK;
}
// [End unified_data_channels_c_update_data]

// [Start unified_data_channels_c_delete_data]
int32_t ProcessRecordHyperlinks(OH_UdmfRecord* record, unsigned int recordTypeIdCount, char** typeIdsFromRecord)
{
    for (unsigned int k = 0; k < recordTypeIdCount; k++) {
        // 从OH_UdmfRecord中获取超链接类型数据。
        if (strcmp(typeIdsFromRecord[k], UDMF_META_HYPERLINK) == 0) {
            // 创建hyperlink的UDS，用来承载record中读取出来的hyperlink数据。
            OH_UdsHyperlink* hyperlink = OH_UdsHyperlink_Create();
            int32_t ret = OH_UdmfRecord_GetHyperlink(record, hyperlink);
            if (ret != Udmf_ErrCode::UDMF_E_OK) {
                OH_LOG_ERROR(LOG_APP, "Fail get hyperlink from record!");
                OH_UdsHyperlink_Destroy(hyperlink);
                return ret;
            }
            // 读取OH_UdsHyperlink中的各项信息。
            OH_LOG_INFO(LOG_APP, "The hyperlink type id is : %{public}s", OH_UdsHyperlink_GetType(hyperlink));
            OH_LOG_INFO(LOG_APP, "The hyperlink url is : %{public}s", OH_UdsHyperlink_GetUrl(hyperlink));
            OH_LOG_INFO(LOG_APP, "The hyperlink description is : %{public}s",
                OH_UdsHyperlink_GetDescription(hyperlink));
            OH_UdsHyperlink_Destroy(hyperlink);
        }
    }
    return UDMF_E_OK;
}

int32_t ProcessDataElement(OH_UdmfData* data)
{
    unsigned int recordsCount = 0;
    OH_UdmfRecord** records = OH_UdmfData_GetRecords(data, &recordsCount);
    OH_LOG_INFO(LOG_APP, "the count of records count is %{public}u", recordsCount);
    // 5. 获取数据记录中的元素。
    for (unsigned int j = 0; j < recordsCount; j++) {
        // 获取OH_UdmfRecord类型列表。
        unsigned int recordTypeIdCount = 0;
        char** typeIdsFromRecord = OH_UdmfRecord_GetTypes(records[j], &recordTypeIdCount);
        int32_t ret = ProcessRecordHyperlinks(records[j], recordTypeIdCount, typeIdsFromRecord);
        if (ret != Udmf_ErrCode::UDMF_E_OK) {
            OH_LOG_ERROR(LOG_APP, "ProcessRecordHyperlinks error!");
            return ret;
        }
    }
    return UDMF_E_OK;
}

int32_t ProcessHyperlinkDataFromArray(OH_UdmfData* readData, unsigned int dataSize, OH_UdmfData** dataArray)
{
    for (unsigned int i = 0; i < dataSize - 1; i++) {
        OH_UdmfData* data = OH_UDMF_GetDataElementAt(dataArray, i);
        // 3. 判断OH_UdmfData是否有对应的类型。
        if (!OH_UdmfData_HasType(data, UDMF_META_HYPERLINK)) {
            OH_LOG_INFO(LOG_APP, "There is no hyperlink type in data[%{public}u].", i);
            continue;
        }
        // 4. 获取数据记录和hyperlink数据。
        int32_t ret = ProcessDataElement(data);
        if (ret != UDMF_E_OK) {
            OH_LOG_ERROR(LOG_APP, "processDataElement data error!");
            return ret;
        }
    }
    return UDMF_E_OK;
}

int32_t DeleteDataTest()
{
    // 1. 构建数据操作选项。
    OH_UdmfOptions* options = OH_UdmfOptions_Create();
    int32_t ret = OH_UdmfOptions_SetIntention(options, Udmf_Intention::UDMF_INTENTION_DATA_HUB);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Set option error!");
        OH_UdmfOptions_Destroy(options);
        return ret;
    }
    // 2. 通过数据操作选项删除数据。
    unsigned int dataSize = 0;
    OH_UdmfData* readData = nullptr;
    ret = OH_Udmf_DeleteUnifiedData(options, &readData, &dataSize);
    if (ret != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Delete Data error!");
        OH_UdmfOptions_Destroy(options);
        return ret;
    }
    OH_UdmfOptions_Destroy(options);
    if (dataSize == 0) {
        OH_LOG_INFO(LOG_APP, "the size of data is %{public}u", dataSize);
        return UDMF_E_OK;
    }
    OH_LOG_INFO(LOG_APP, "the size of data is %{public}u", dataSize);
    OH_UdmfData** dataArray = &readData;
    ret = ProcessHyperlinkDataFromArray(readData, dataSize, dataArray);
    if (ret != UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Process hyperlink data error!");
        return ret;
    }
    // 6. 销毁指针。
    OH_Udmf_DestroyDataArray(dataArray, dataSize);
    return UDMF_E_OK;
}
// [End unified_data_channels_c_delete_data]

// [Start unified_data_channels_c_define_get_data_callback]
// 为了代码可读性，代码中省略了各个步骤操作结果的校验，实际开发中需要确认每次调用的成功。
// 1. 获取数据时触发的提供UDS数据的回调函数。
static void* GetDataCallback(void* context, const char* type)
{
    if (strcmp(type, UDMF_META_HYPERLINK) == 0) {
        // 2. 创建超链接hyperlink数据的UDS数据结构。
        OH_UdsHyperlink* hyperlink = OH_UdsHyperlink_Create();
        // 3. 设置hyperlink中的URL和描述信息。
        OH_UdsHyperlink_SetUrl(hyperlink, "www.demo.com");
        OH_UdsHyperlink_SetDescription(hyperlink, "This is the description.");
        return hyperlink;
    }
    return nullptr;
}
// 4. OH_UdmfRecordProvider销毁时触发的回调函数。
static void ProviderFinalizeCallback(void* context) { OH_LOG_INFO(LOG_APP, "OH_UdmfRecordProvider finalize."); }
// [End unified_data_channels_c_define_get_data_callback]

// [Start unified_data_channels_c_delay_write_data]
int32_t ProviderSetDataTest()
{
    // 为了代码可读性，代码中省略了各个步骤操作结果的校验，实际开发中需要确认每次调用的成功。
    // 1. 创建一个OH_UdmfRecordProvider，设置它的数据提供函数和销毁回调函数。
    OH_UdmfRecordProvider* provider = OH_UdmfRecordProvider_Create();
    OH_UdmfRecordProvider_SetData(provider, (void*)provider, GetDataCallback, ProviderFinalizeCallback);

    // 2. 创建OH_UdmfRecord对象，并配置OH_UdmfRecordProvider。
    OH_UdmfRecord* record = OH_UdmfRecord_Create();
    const char* types[1] = {UDMF_META_HYPERLINK};
    OH_UdmfRecord_SetProvider(record, types, 1, provider);

    // 3. 创建OH_UdmfData对象，并向OH_UdmfData中添加OH_UdmfRecord。
    OH_UdmfData* data = OH_UdmfData_Create();
    OH_UdmfData_AddRecord(data, record);

    // 4. 构建数据并写入数据库中，获取返回的Key值。
    OH_UdmfOptions* options = OH_UdmfOptions_Create();
    if (OH_UdmfOptions_SetIntention(options, Udmf_Intention::UDMF_INTENTION_DATA_HUB) != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Set option error!");
        OH_UdmfOptions_Destroy(options);
        return UDMF_ERR;
    }
    char key[UDMF_KEY_BUFFER_LEN] = {0};
    if (OH_Udmf_SetUnifiedDataByOptions(options, data, key, sizeof(key)) != Udmf_ErrCode::UDMF_E_OK) {
        OH_LOG_ERROR(LOG_APP, "Set data error!");
    }
    OH_LOG_INFO(LOG_APP, "key = %{public}s", key);

    // 5. 使用完成后销毁指针。
    OH_UdmfRecord_Destroy(record);
    OH_UdmfData_Destroy(data);
    OH_UdmfOptions_Destroy(options);
    return UDMF_E_OK;
}
// [End unified_data_channels_c_delay_write_data]

static napi_value NAPI_Global_createData(napi_env env, napi_callback_info info)
{
    int32_t ret = CreateDataTest();
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value NAPI_Global_getData(napi_env env, napi_callback_info info)
{
    int32_t ret = GetDataTest();
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value NAPI_Global_updateData(napi_env env, napi_callback_info info)
{
    int32_t ret = UpdateDataTest();
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value NAPI_Global_deleteData(napi_env env, napi_callback_info info)
{
    int32_t ret = DeleteDataTest();
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value NAPI_Global_setProviderData(napi_env env, napi_callback_info info)
{
    int32_t ret = ProviderSetDataTest();
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"createData", nullptr, NAPI_Global_createData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getData", nullptr, NAPI_Global_getData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"updateData", nullptr, NAPI_Global_updateData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"deleteData", nullptr, NAPI_Global_deleteData, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setProviderData", nullptr, NAPI_Global_setProviderData, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    napi_define_properties(env, exports, sizeof(desc)/sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

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
