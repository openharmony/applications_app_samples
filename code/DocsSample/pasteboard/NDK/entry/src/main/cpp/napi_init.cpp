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

// [Start oh_jsvm_get_arraybuffer_info]
#include "napi/native_api.h"
#include <cstdio>
#include <cstring>
#include <database/pasteboard/oh_pasteboard.h>
#include <database/udmf/udmf.h>
#include <database/udmf/uds.h>
#include <database/udmf/udmf_meta.h>
#include <hilog/log.h>
#undef LOG_TAG
#define LOG_TAG "MY_LOG"

// 定义剪贴板数据内容变更时的通知回调函数
static void Pasteboard_Notify_impl2(void* context, Pasteboard_NotifyType type)
{
  OH_LOG_INFO(LOG_APP,"Pasteboard_NotifyType, type: %d", type);
}
// 定义剪贴板数据变更观察者对象销毁时的通知回调函数
static void Pasteboard_Finalize_impl2(void* context)
{
  OH_LOG_INFO(LOG_APP,"callback: Pasteboard_Finalize");
}

static void pasteboard_test_observer()
{
    // 1. 创建一个剪贴板实例
    OH_Pasteboard* pasteboard = OH_Pasteboard_Create();
    // 2. 创建一个剪贴板数据变更观察者实例
    OH_PasteboardObserver* observer = OH_PasteboardObserver_Create();
    // 3. 将两个回调函数设置到观察者实例
    OH_PasteboardObserver_SetData(observer, (void* )pasteboard, Pasteboard_Notify_impl2, Pasteboard_Finalize_impl2);
    // 4. 设置对剪贴板本端数据变化的订阅
    OH_Pasteboard_Subscribe(pasteboard, NOTIFY_LOCAL_DATA_CHANGE, observer);
}
static void pasteboard_test_set()
{
    // 1. 创建一个剪贴板实例
    OH_Pasteboard* pasteboard = OH_Pasteboard_Create();

    // 2. 创建OH_UdmfRecord对象，并向OH_UdmfRecord中添加文本类型数据
    OH_UdsPlainText* plainText = OH_UdsPlainText_Create();
    OH_UdsPlainText_SetContent(plainText, "Hello world!");
    OH_UdsHtml* udsHtml = OH_UdsHtml_Create();
    OH_UdsHtml_SetContent(udsHtml, "hello world");
    OH_UdmfRecord* record = OH_UdmfRecord_Create();
    OH_UdmfRecord_AddPlainText(record, plainText);

    // 3. 创建OH_UdmfData对象，并向OH_UdmfData中添加OH_UdmfRecord
    OH_UdmfData* data = OH_UdmfData_Create();
    OH_UdmfData_AddRecord(data, record);

    // 4. 将数据写入剪贴板
    OH_Pasteboard_SetData(pasteboard, data);

    // 5. 使用完销毁指针
    OH_UdsPlainText_Destroy(plainText);
    OH_UdmfRecord_Destroy(record);
    OH_UdmfData_Destroy(data);
    OH_Pasteboard_Destroy(pasteboard);
}
static void pasteboard_test_get()
{
    // 1. 创建一个剪贴板实例
    OH_Pasteboard* pasteboard = OH_Pasteboard_Create();
    // 2. 判断剪贴板中是否有文本类型数据
    bool hasPlainTextData = OH_Pasteboard_HasType(pasteboard, "text/plain");
    if (hasPlainTextData) {
    // 3. 从剪贴板中获取统一类型数据OH_UdmfData
    int ret = 0;
    OH_UdmfData* udmfData = OH_Pasteboard_GetData(pasteboard, &ret);
    // 4. 从OH_UdmfData中获取第一个数据记录
    OH_UdmfRecord* record = OH_UdmfData_GetRecord(udmfData, 0);
    // 5. 从数据记录中获取文本数据内容
    OH_UdsPlainText* plainText = OH_UdsPlainText_Create();
    OH_UdmfRecord_GetPlainText(record, plainText);
    const char* content = OH_UdsPlainText_GetContent(plainText);
    if (content != nullptr){
    OH_LOG_INFO(LOG_APP,"Get plain text success.");
    }
    // 5. 使用完销毁指针
    OH_UdsPlainText_Destroy(plainText);
    OH_UdmfData_Destroy(udmfData);
    }
    OH_Pasteboard_Destroy(pasteboard);
}

// 1. 获取数据时触发的提供剪贴板数据的回调函数。
void* GetDataCallback(void* context, const char* type) {
    // 纯文本类型
    if (strcmp(type, UDMF_META_PLAIN_TEXT) == 0) {
        // 创建纯文本类型的Uds对象。
        OH_UdsPlainText* udsText = OH_UdsPlainText_Create();
        // 设置纯文本内容。
        OH_UdsPlainText_SetContent(udsText, "hello world");
        return udsText;
    }
    // HTML类型
    else if (strcmp(type, UDMF_META_HTML) == 0) {
        // 创建HTML类型的Uds对象。
        OH_UdsHtml* udsHtml = OH_UdsHtml_Create();
        // 设置HTML内容。
        OH_UdsHtml_SetContent(udsHtml, "<div>hello world</div>");
        return udsHtml;
    }
    return nullptr;
}
// 2. OH_UdmfRecordProvider销毁时触发的回调函数。
void ProviderFinalizeCallback(void* context) {
    OH_LOG_INFO(LOG_APP,"OH_UdmfRecordProvider finalize.");
}
// 3. 定义应用退出时调用延迟同步接口触发的回调函数。
void SyncCallback(int errorCode)
{
    // 继续退出
}
static void pasteboard_test_time()
{

    // 4. 创建OH_UdmfRecord对象。
    OH_UdmfRecord* record = OH_UdmfRecord_Create();

    // 5. 创建OH_UdmfRecordProvider对象，并设置用于提供延迟数据、析构的两个回调函数。
    OH_UdmfRecordProvider* provider = OH_UdmfRecordProvider_Create();
    OH_UdmfRecordProvider_SetData(provider, (void*)record, GetDataCallback, ProviderFinalizeCallback);

    // 6. 将provider绑定到record，并设置支持的数据类型。
    const char* types[2] = { UDMF_META_PLAIN_TEXT, UDMF_META_HTML };
    OH_UdmfRecord_SetProvider(record, types, 2, provider);

    // 7. 创建OH_UdmfData对象，并向OH_UdmfData中添加OH_UdmfRecord。
    OH_UdmfData* setData = OH_UdmfData_Create();
    OH_UdmfData_AddRecord(setData, record);

    // 8. 创建OH_Pasteboard对象，将数据写入剪贴板中。
    OH_Pasteboard* pasteboard = OH_Pasteboard_Create();
    OH_Pasteboard_SetData(pasteboard, setData);

    // 9. 记录当前的剪贴板数据变化次数。
    uint32_t changeCount = OH_Pasteboard_GetChangeCount(pasteboard);

    // 10. 从剪贴板获取OH_UdmfData。
    int status = -1;
    OH_UdmfData* getData = OH_Pasteboard_GetData(pasteboard, &status);

    // 11. 获取OH_UdmfData中的所有OH_UdmfRecord。
    unsigned int recordCount = 0;
    OH_UdmfRecord** getRecords = OH_UdmfData_GetRecords(getData, &recordCount);
    OH_UdsPlainText* udsText = nullptr;
    OH_UdsHtml* udsHtml = nullptr;

    // 12. 遍历OH_UdmfRecord。
    for (unsigned int recordIndex = 0; recordIndex < recordCount; ++recordIndex) {
        OH_UdmfRecord* record = getRecords[recordIndex];

        // 13. 查询OH_UdmfRecord中的数据类型。
        unsigned typeCount = 0;
        char** recordTypes = OH_UdmfRecord_GetTypes(record, &typeCount);

        // 14. 遍历数据类型。
        for (unsigned int typeIndex = 0; typeIndex < typeCount; ++typeIndex) {
            char* recordType = recordTypes[typeIndex];

            // 纯文本类型
            if (strcmp(recordType, UDMF_META_PLAIN_TEXT) == 0) {
                // 创建纯文本类型的Uds对象
                udsText = OH_UdsPlainText_Create();
                if (udsText != nullptr) {
                 // 从record中获取纯文本类型的Uds对象
                 OH_UdmfRecord_GetPlainText(record, udsText);
                 // 从Uds对象中获取内容
                 const char* content = OH_UdsPlainText_GetContent(udsText);
                }
            }
            // HTML类型
            else if (strcmp(recordType, UDMF_META_HTML) == 0) {
                // 创建HTML类型的Uds对象
                udsHtml = OH_UdsHtml_Create();
                if (udsHtml != nullptr) {
                 // 从record中获取HTML类型的Uds对象
                 OH_UdmfRecord_GetHtml(record, udsHtml);
                 // 从Uds对象中获取内容
                 const char* content = OH_UdsHtml_GetContent(udsHtml);
                }
            }
        }
    }

    // 15. 查询剪贴板内的数据是否变化。
    OH_UdsPlainText_Destroy(udsText);
    OH_UdsHtml_Destroy(udsHtml);
    OH_UdmfRecordProvider_Destroy(provider);
    OH_UdmfRecord_Destroy(record);
    OH_UdmfData_Destroy(setData);
    OH_UdmfData_Destroy(getData);
    OH_Pasteboard_Destroy(pasteboard);
}
// [End oh_jsvm_get_arraybuffer_info]


