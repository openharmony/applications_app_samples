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

#define LOG_TAG "testTag [NATIVE]"

#include "napi/native_api.h"
#include "hilog/log.h"
#include "data_parser.h"

#include <cstdint>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <memory>
#include <tuple>
#include <usb/usb_ddk_types.h>
#include <usb/usb_ddk_api.h>
#include <string>
#include <optional>
#include <functional>
#include <ctime>

uint64_t g_devHandle = 0;
uint64_t g_interfaceHandle = 0;
uint8_t g_dataEp = 0;
uint8_t g_interface = 0;
uint16_t g_maxPktSize = 0;
bool g_stopIo = false;
UsbDeviceMemMap *devMmap = nullptr;
DDK_Ashmem *ashmem = nullptr;
constexpr size_t BTN_MAPPING_INFO_SIZE = 4;
constexpr size_t PRODUCT_DESC_MAX_LEN = 100;
constexpr unsigned long long TIME_CONVERSION_NS_S = 1000000000ULL;
constexpr int NUM_TWO = 2;
constexpr int NUM_THREE = 3;
constexpr int BIT_THIRTY_TWO = 32;
constexpr int BIT_EIGHT = 8;
constexpr int BIT_SEVEN = 7;

// 将unicode编码形式的字符串转化为ASCII码
std::string UnicodeToAsc(unsigned char *in, int inLen)
{
    wchar_t wstr[PRODUCT_DESC_MAX_LEN] = {0};
    unsigned short tmpShort;
    int indexCnt = 0;

    for (uint32_t j = 0; j < inLen; j += NUM_TWO) {
        memcpy(&tmpShort, in + j, NUM_TWO);
        wstr[indexCnt++] = tmpShort;
    }
    char str[PRODUCT_DESC_MAX_LEN] = {0};
    size_t result = wcstombs(str, wstr, PRODUCT_DESC_MAX_LEN);
    if (result == static_cast<size_t>(-1)) {
        OH_LOG_INFO(LOG_APP, "wcstombs error");
        return "";
    }
    return std::string(str);
}

static bool IsInterfaceIn(struct UsbEndpointDescriptor epDesc)
{
    return (((epDesc.bEndpointAddress >> BIT_SEVEN) & 1) == 1) && ((epDesc.bmAttributes & 0x03) == 0x03);
}

static std::tuple<bool, uint8_t, uint8_t, uint16_t> GetInfoFromEndpoint(struct UsbDdkEndpointDescriptor *epDesc,
    uint8_t bInterfaceNumber, uint32_t numEp)
{
    for (uint32_t epIdx = 0; epIdx < numEp; ++epIdx) {
        struct UsbEndpointDescriptor endpointDescriptor = epDesc[epIdx].endpointDescriptor;
        // interrupt in
        if (IsInterfaceIn(endpointDescriptor)) {
            OH_LOG_INFO(LOG_APP, "bInterfaceNumber: %{public}u\n", bInterfaceNumber);
            OH_LOG_INFO(LOG_APP, "bEndpointAddress: %{public}u\n", endpointDescriptor.bEndpointAddress);
            return {true, bInterfaceNumber, endpointDescriptor.bEndpointAddress, endpointDescriptor.wMaxPacketSize};
        }
    }
    return {false, {}, {}, {}};
}

// 获取手写板的接口和端点
static std::tuple<bool, uint8_t, uint8_t, uint16_t> GetInterfaceAndEndpoint(const struct UsbDdkConfigDescriptor *config)
{
    for (uint32_t intIdx = 0; intIdx < config->configDescriptor.bNumInterfaces; ++intIdx) {
        struct UsbDdkInterfaceDescriptor *intDesc = config->interface[intIdx].altsetting;
        uint32_t numSetting = config->interface[intIdx].numAltsetting;
        for (uint32_t setIdx = 0; setIdx < numSetting; ++setIdx) {
            uint32_t numEp = intDesc[setIdx].interfaceDescriptor.bNumEndpoints;
            struct UsbDdkEndpointDescriptor *epDesc = intDesc[setIdx].endPoint;
            uint8_t bInterfaceNumber = intDesc[setIdx].interfaceDescriptor.bInterfaceNumber;
            return GetInfoFromEndpoint(epDesc, bInterfaceNumber, numEp);
        }
    }
    return {false, {}, {}, {}};
}

struct AsyncContext {
    napi_env env;
    napi_async_work work;

    napi_deferred deferred;
    napi_status status;
};

static auto g_getKeyboardExecute = [](napi_env env, void *data) {
    AsyncContext *asyncContext = reinterpret_cast<AsyncContext *>(data);
    uint32_t bufferLen = g_maxPktSize;
    // [Start driver_usb_step5_1]
    // 占用接口，同时也会卸载内核键盘驱动
    // 创建用于存放数据的缓冲区
    int32_t ret = OH_Usb_CreateDeviceMemMap(g_devHandle, bufferLen, &devMmap);
    // [End driver_usb_step5_1]
    if (ret != 0 || devMmap == nullptr) {
        OH_LOG_ERROR(LOG_APP, "OH_Usb_CreateDeviceMemMap failed");
        asyncContext->status = napi_generic_failure;
        return;
    }

    DataParser &parser = DataParser::GetInstance();
    parser.StartWork();
    OH_LOG_INFO(LOG_APP, "parser.StartWork");
    g_stopIo = false;
    while (!g_stopIo) {
        OH_LOG_INFO(LOG_APP, "excute OH_Usb_SendPipeRequest start");

        // [Start driver_usb_step5_2]
        struct UsbRequestPipe pipe;
        pipe.interfaceHandle = g_interfaceHandle;
        pipe.endpoint = g_dataEp;
        pipe.timeout = 4; //  中断传输超时时间，保持和手写板bInterval保持一致
        // 读取手写板数据
        // 通过USB中断传输方式，读取键值
        ret = OH_Usb_SendPipeRequest(&pipe, devMmap);
        // [End driver_usb_step5_2]
        if (ret != 0) {
            OH_LOG_ERROR(LOG_APP, "GetUsbKeyboardInput failed");
            continue;
        }

        // 处理读取到的数据
        parser.ParseData(devMmap->address, devMmap->transferedLength);
    }
    OH_LOG_ERROR(LOG_APP, "g_stopIo end");
    if (ret == 0) {
        asyncContext->status = napi_ok;
    } else {
        asyncContext->status = napi_generic_failure;
    }
};

static auto g_getKeyboardComplete = [](napi_env env, napi_status status, void *data) {
    AsyncContext *asyncContext = reinterpret_cast<AsyncContext *>(data);
    if (asyncContext->deferred) {
        napi_value result = nullptr;
        napi_create_int32(env, 0, &result);
        if (asyncContext->status == napi_ok) {
            napi_resolve_deferred(env, asyncContext->deferred, result);
        } else {
            napi_reject_deferred(env, asyncContext->deferred, result);
        }
    }

    napi_delete_async_work(env, asyncContext->work);
    delete asyncContext;
};

static napi_value GetBoardInput(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter GetBoardInput\n");

    auto asyncContext = new (std::nothrow) AsyncContext();
    asyncContext->env = env;
    asyncContext->status = napi_ok;

    napi_value result = nullptr;
    napi_create_promise(env, &asyncContext->deferred, &result);
    napi_value resource = nullptr;
    napi_create_string_utf8(env, "GetKbdInput", NAPI_AUTO_LENGTH, &resource);
    // 创建异步任务
    napi_status status = napi_create_async_work(env, nullptr, resource, g_getKeyboardExecute, g_getKeyboardComplete,
                                                reinterpret_cast<void *>(asyncContext), &asyncContext->work);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s create async work failed", __func__);
        return result;
    }
    napi_queue_async_work(env, asyncContext->work);
    return result;
}

static void SelectInterfaceSetting()
{
    // [Start driver_usb_step3]
    uint8_t settingIndex = 0;
    // 接口获取备用设置
    int32_t ret = OH_Usb_GetCurrentInterfaceSetting(g_interfaceHandle, &settingIndex);
    if (ret != USB_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Usb_GetCurrentInterfaceSetting failed, ret=%{public}d", ret);
    }

    // 激活备用设置
    ret = OH_Usb_SelectInterfaceSetting(g_interfaceHandle, settingIndex);
    if (ret != USB_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Usb_SelectInterfaceSetting failed, ret=%{public}d", ret);
    }
    // [End driver_usb_step3]
}

static void GetDevices()
{
    // [Start driver_usb_step7]
    constexpr size_t maxUsbDeviceNum = 128;
    struct Usb_DeviceArray deviceArray;
    deviceArray.deviceIds = new uint64_t[maxUsbDeviceNum];
    // 获取设备列表
    int32_t ret = OH_Usb_GetDevices(&deviceArray);
    if (ret != USB_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_Usb_GetDevices failed, ret=%{public}d", ret);
    }
    // [End driver_usb_step7]
}

static std::optional<std::string> GetProductStringDescriptor(uint16_t iProduct)
{
    // [Start driver_usb_step4_2]
    uint8_t strDesc[100] = {0};
    // 获取产品字符串描述符
    uint32_t len = 100;
    struct UsbControlRequestSetup strDescSetup;
    strDescSetup.bmRequestType = 0x80;
    strDescSetup.bRequest = 0x06;
    strDescSetup.wValue = (0x03 << BIT_EIGHT) | (iProduct); // desc Index
    strDescSetup.wIndex = 0x409;                    // language Id
    strDescSetup.wLength = len;
    auto ret = OH_Usb_SendControlReadRequest(g_interfaceHandle, &strDescSetup, UINT32_MAX, strDesc, &len);
    // [End driver_usb_step4_2]
    if (ret != 0) {
        OH_LOG_ERROR(LOG_APP, "send ctrl read failed%{public}d", ret);
        return {};
    }

    // 将unicode形式的描述符转化为ASCII, 便于打印
    std::string desc = UnicodeToAsc(strDesc + 2, len - 2);
    OH_LOG_INFO(LOG_APP, "strDesc %{public}s\n", desc.data());
    return desc;
}

static napi_value CreateJsArray(napi_env env, const std::string &desc, uint16_t idProduct)
{
    napi_value result;
    // 将获取到的产品描述符传给js层
    napi_value jsDesc;
    if (napi_create_string_utf8(env, desc.data(), desc.length(), &jsDesc) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s napi_create_string_utf8 failed", __func__);
        napi_get_undefined(env, &result);
        return result;
    }
    napi_value jsProductId;
    if (napi_create_uint32(env, idProduct, &jsProductId) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s napi_create_uint32 failed", __func__);
        napi_get_undefined(env, &result);
        return result;
    }
    napi_value jsArray;
    if (napi_create_array(env, &jsArray) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s napi_create_array failed", __func__);
        napi_get_undefined(env, &result);
        return result;
    }
    if (napi_set_element(env, jsArray, 0, jsDesc) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s napi_set_element 0 failed", __func__);
        napi_get_undefined(env, &result);
        return result;
    }
    if (napi_set_element(env, jsArray, 1, jsProductId) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "%{public}s napi_set_element 1 failed", __func__);
        napi_get_undefined(env, &result);
        return result;
    }
    return jsArray;
}

static bool GetPipeInfo()
{
    OH_LOG_INFO(LOG_APP, "GetPipeInfo enter");
    
    // [Start driver_usb_step2]
    struct UsbDdkConfigDescriptor *config = nullptr;
    // 获取配置描述符
    auto ret = OH_Usb_GetConfigDescriptor(g_devHandle, 1, &config);
    OH_LOG_INFO(LOG_APP, "OH_Usb_GetConfigDescriptor ret = %{public}d", ret);
    if (ret != 0) {
        OH_LOG_ERROR(LOG_APP, "get config desc failed:%{public}d", ret);
        return false;
    }
    // 从配置描述符中找到手写板相关的接口和端点
    auto [res, interface, endpoint, maxPktSize] = GetInterfaceAndEndpoint(config);
    OH_LOG_INFO(LOG_APP, "OH_Usb_GetConfigDescriptor ret = %{public}d", res);
    if (!res) {
        OH_LOG_ERROR(LOG_APP, "GetInterfaceAndEndpoint failed");
        return false;
    }
    // 释放配置描述符，防止内存泄露
    OH_Usb_FreeConfigDescriptor(config);
    g_dataEp = endpoint;
    g_maxPktSize = maxPktSize;
    g_interface = interface;
    // 占用接口，同时也会卸载内核键盘驱动
    ret = OH_Usb_ClaimInterface(g_devHandle, g_interface, &g_interfaceHandle);
    // [End driver_usb_step2]
    if (ret != 0) {
        OH_LOG_ERROR(LOG_APP, "claim interface failed%{public}d", ret);
        return false;
    }
    return true;
}

static std::tuple<bool, UsbDeviceDescriptor> GetDeviceInfo()
{
    // [Start driver_usb_step1]
    // 初始化USB DDK
    int32_t ret = OH_Usb_Init();
    OH_LOG_INFO(LOG_APP, "OH_Usb_Init ret=:%{public}d\n", ret);
    // [StartExclude driver_usb_step1]
    if (ret != 0) {
        OH_LOG_ERROR(LOG_APP, "init ddk failed");
        return {false, {}};
    }
    // [EndExclude driver_usb_step1]
    struct UsbDeviceDescriptor devDesc;
    // 获取设备描述符
    ret = OH_Usb_GetDeviceDescriptor(g_devHandle, &devDesc);
    // [End driver_usb_step1]
    if (ret != 0) {
        OH_LOG_ERROR(LOG_APP, "get dev desc failed:%{public}d", ret);
        return {false, {}};
    }
    // 过滤目的设备
    if (devDesc.idVendor != 0x0b57 || (devDesc.idProduct != 0x8835 && devDesc.idProduct != 0xa153 &&
        devDesc.idProduct != 0xa150 && devDesc.idProduct != 0x8811 && devDesc.idProduct != 0xA13F)) {
        OH_LOG_ERROR(LOG_APP, "device invalid :%{public}u, %{public}u", devDesc.idVendor, devDesc.idProduct);
        return {false, {}};
    }

    return {true, devDesc};
}

static void SetFeature(uint16_t iProduct)
{
    OH_LOG_INFO(LOG_APP, "SetFeature enter\n");

    if (iProduct != 0xA150 && iProduct != 0xA153) {
        OH_LOG_WARN(LOG_APP, "no need set feature\n");
        return;
    }

    // [Start driver_usb_step4_1]
    // 设置feature
    uint32_t timeout = 5000;
    struct UsbControlRequestSetup strDescSetup;
    strDescSetup.bmRequestType = 0x21;
    strDescSetup.bRequest = 0x09;
    strDescSetup.wValue = ((0x03 << BIT_EIGHT) | 0x02); // desc Index
    strDescSetup.wIndex = 0x0;
    strDescSetup.wLength = 0x02;
    uint8_t data[128] = {0x02, 0x02};
    uint32_t dataLen = 2;
    int32_t ret = OH_Usb_SendControlWriteRequest(g_interfaceHandle, &strDescSetup, timeout, data, dataLen);
    // [End driver_usb_step4_1]
    if (ret < 0) {
        OH_LOG_ERROR(LOG_APP, "OH_Usb_SendControlWriteRequest error ret:%{public}d", ret);
    }
    OH_LOG_INFO(LOG_APP, "SetFeature OK!");
}

static napi_value GetProductDesc(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter GetProductDesc\n");
    napi_value result;
    // 解析deviceId
    size_t argc = 1;
    napi_value argv;

    napi_get_cb_info(env, info, &argc, &argv, nullptr, nullptr);
    if (argc < 1) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        napi_get_undefined(env, &result);
        return result;
    }

    uint32_t devicedId = 0;
    napi_get_value_uint32(env, argv, &devicedId);
    uint32_t busNum = ((devicedId & 0xFFFF0000) >> 16);
    uint32_t deviceNum = devicedId & 0xFFFF;
    g_devHandle = (static_cast<uint64_t>(busNum) << BIT_THIRTY_TWO) | deviceNum;

    auto [res, devDesc] = GetDeviceInfo();
    OH_LOG_INFO(LOG_APP, "GetDeviceInfo ret=:%{public}d\n", res);
    if (!res) {
        napi_get_undefined(env, &result);
        return result;
    }

    if (!GetPipeInfo()) {
        napi_get_undefined(env, &result);
        return result;
    }
    DataParser::GetInstance().Init(devDesc.idVendor, devDesc.idProduct);

    SetFeature(devDesc.idProduct);

    auto productDesc = GetProductStringDescriptor(devDesc.iProduct);
    if (!productDesc.has_value()) {
        OH_LOG_ERROR(LOG_APP, "GetProductStringDescriptor failed");
        napi_get_undefined(env, &result);
        return result;
    }
    return CreateJsArray(env, productDesc.value(), devDesc.idProduct);
}

static napi_value ReleaseResource(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter ReleaseResource\n");
    g_stopIo = true;
    // [Start driver_usb_step6]
    // 销毁缓冲区
    OH_Usb_DestroyDeviceMemMap(devMmap);
    // 释放接口
    int32_t ret = OH_Usb_ReleaseInterface(g_interfaceHandle);
    if (ret != 0) {
        OH_LOG_ERROR(LOG_APP, "ReleaseInterface failed %{public}d", ret);
    }
    // 释放USB DDK
    OH_Usb_Release();
    // [End driver_usb_step6]
    return nullptr;
}

// 设置屏幕分辨率，方便后续坐标标准化
static napi_value SetDisplayInfo(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter SetDisplayInfo\n");
    size_t argc = NUM_TWO;
    napi_value args[NUM_TWO] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < NUM_TWO) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }

    uint32_t width;
    uint32_t height = 0;
    napi_get_value_uint32(env, args[0], &width);
    napi_get_value_uint32(env, args[1], &height);
    OH_LOG_INFO(LOG_APP, "display info width:%{public}u, height:%{public}u", width, height);
    DataParser::GetInstance().SetScreenSize(width, height);
    return nullptr;
}

// 设置按键定制
static napi_value SetButtonMapping(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter SetButtonMapping\n");
    size_t argc = 1;
    napi_value arg = {nullptr};

    napi_get_cb_info(env, info, &argc, &arg, nullptr, nullptr);
    if (argc < 1) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }
    bool isTypedArray = false;
    if (napi_is_typedarray(env, arg, &isTypedArray) != napi_ok || !isTypedArray) {
        OH_LOG_ERROR(LOG_APP, "The type of mappingInfo must be TypedArray.");
        return nullptr;
    }

    napi_typedarray_type type;
    napi_value buffer;
    int32_t *int32Buffer = nullptr;
    size_t bufferSize = 0;
    size_t offset = 0;
    napi_status infoStatus = napi_get_typedarray_info(
        env, arg, &type, &bufferSize, reinterpret_cast<void **>(&int32Buffer), &buffer, &offset);
    if (infoStatus != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "get typedarray info failed, status: %{public}d", infoStatus);
        return nullptr;
    }
    if (type != napi_int32_array) {
        OH_LOG_ERROR(LOG_APP, "The type of buffer must be int32Array.");
        return nullptr;
    }
    if (bufferSize == 0 || bufferSize > BTN_MAPPING_INFO_SIZE * sizeof(int32_t)) {
        OH_LOG_ERROR(LOG_APP, "The size of buffer invalid%{public}zu", bufferSize);
        return nullptr;
    }
    DataParser::GetInstance().UpdateKeyCodeMap(0, int32Buffer[0]);
    DataParser::GetInstance().UpdateKeyCodeMap(1, int32Buffer[1]);
    DataParser::GetInstance().UpdateKeyCodeMap(NUM_TWO, int32Buffer[NUM_TWO]);
    DataParser::GetInstance().UpdateKeyCodeMap(NUM_THREE, int32Buffer[NUM_THREE]);
    return nullptr;
}

// 设置按键定制
static napi_value SetOneButtonMapping(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter SetOneButtonMapping\n");
    size_t argc = NUM_TWO;
    napi_value args[NUM_TWO] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < NUM_TWO) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }

    uint32_t index;
    uint32_t keyCode = 0;
    napi_get_value_uint32(env, args[0], &index);
    napi_get_value_uint32(env, args[1], &keyCode);
    DataParser::GetInstance().UpdateKeyCodeMap(index, keyCode);
    return nullptr;
}

// 设置按键定制
static napi_value SetDirection(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter SetDirection\n");
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < 1) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }

    uint32_t direction = 0;
    napi_get_value_uint32(env, args[0], &direction);
    DataParser::GetInstance().SetDirection(direction);
    return nullptr;
}

// 设置按键定制
static napi_value GetDirection(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "enter GetDirection\n");
    uint32_t direction = DataParser::GetInstance().GetDirection();
    napi_value result = nullptr;
    napi_create_int32(env, direction, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getBoardInput", nullptr, GetBoardInput, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getProductDesc", nullptr, GetProductDesc, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseResource", nullptr, ReleaseResource, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setDisplayInfo", nullptr, SetDisplayInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setButtonMapping", nullptr, SetButtonMapping, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setOneButtonMapping", nullptr, SetOneButtonMapping, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setDirection", nullptr, SetDirection, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getDirection", nullptr, GetDirection, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
