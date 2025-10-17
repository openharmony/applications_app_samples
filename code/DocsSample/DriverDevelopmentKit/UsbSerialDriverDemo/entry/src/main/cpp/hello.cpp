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

#include "data_parser.h"
#include "napi/native_api.h"
#include <cerrno>
#include <cstdint>
#include <cstdlib>
#include <chrono>
#include <hilog/log.h>
#include <string>
#include <usb_serial/usb_serial_types.h>

#define LOG_TAG "thermometer [NATIVE]"
uint8_t writeCommand[] = {0x01, 0x03, 0x00, 0x00, 0x00, 0x01, 0x84, 0x0A};

template <typename Func, typename ResultType = decltype(std::declval<Func>()())>
ResultType TrackTime(Func &&func, const char *desc = "") {
    auto start = std::chrono::high_resolution_clock::now();
    ResultType result = func();
    auto end = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration<double, std::milli>(end - start);
    OH_LOG_INFO(LOG_APP, "Function [%{public}s] took [%{public}.2f]ms with result [%{public}d]", desc,
                duration_ms.count());
    return result;
}

uint32_t StartWork() {
    // 打开 USB 串口设备
    UsbSerial_Device *serial = nullptr;
    // 打开deviceId和bInterfacenum指定的USB串口设备
    uint32_t ret = OH_UsbSerial_Open(DataParser::GetInstance().GetDeviceID(), bInterfacenum, &serial);
    if (ret != USB_SERIAL_DDK_SUCCESS) {
        OH_UsbSerial_Close(&serial);
        OH_LOG_ERROR(LOG_APP, "Failed to open USB serial device: %{public}d", ret);
        return ret;
    }
    
    DataParser::GetInstance().SetSerialObject(serial);
    // 分配并初始化 UsbSerial_Params 结构体
    struct UsbSerial_Params *serialParams = (struct UsbSerial_Params *)malloc(sizeof(struct UsbSerial_Params));
    if (serialParams == NULL) {
        OH_LOG_ERROR(LOG_APP, "Failed to allocate memory for UsbSerial_Params");
        OH_UsbSerial_Close(&serial);
        return ENOMEM;
    }
    // 初始化 UsbSerial_Params 成员变量
    serialParams->baudRate = DataParser::GetInstance().GetBaudRate();
    serialParams->nDataBits = DataParser::GetInstance().GetDataBits();
    serialParams->nStopBits = DataParser::GetInstance().GetStopBits();
    serialParams->parity = DataParser::GetInstance().GetParity();

    OH_LOG_INFO(LOG_APP, "serialParams->baudRate:%{public}d, serialParams->nDataBits:%{public}d, "
                "serialParams->nStopBits:%{public}d, serialParams->parity:%{public}d",
                serialParams->baudRate, serialParams->nDataBits, serialParams->nStopBits, serialParams->parity);

    // 设置 USB 串口参数
    ret = OH_UsbSerial_SetParams(DataParser::GetInstance().GetSerialObject(), serialParams);
    if (ret != USB_SERIAL_DDK_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "Failed to set USB serial parameters: %d", ret);
        free(serialParams);
        OH_UsbSerial_Close(&serial);
        return ret;
    }
    // 释放分配的内存
    free(serialParams);

    UsbSerial_FlowControl flowControl = UsbSerial_FlowControl(DataParser::GetInstance().GetFlowControl());
    OH_UsbSerial_SetFlowControl(DataParser::GetInstance().GetSerialObject(), flowControl);
    OH_LOG_INFO(LOG_APP, "Set the flow control finished. \n");

    OH_UsbSerial_Flush(DataParser::GetInstance().GetSerialObject());
    OH_LOG_INFO(LOG_APP, "Flush the input and output buffers finished. \n");

    OH_UsbSerial_FlushInput(DataParser::GetInstance().GetSerialObject());
    OH_LOG_INFO(LOG_APP, "Flush the input buffer finished. \n");

    OH_UsbSerial_FlushOutput(DataParser::GetInstance().GetSerialObject());
    OH_LOG_INFO(LOG_APP, "Flush the output buffer finished. \n");

    return ret;
}

static napi_value Config(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_status status;
    napi_value args[2];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < 2) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }

    uint32_t key = 0;
    size_t str_len;
    char *utf8_buf;
    status = napi_get_value_uint32(env, args[0], &key);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "First argument must be a number\n");
        return nullptr;
    }

    status = napi_get_value_string_utf8(env, args[1], nullptr, 0, &str_len);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "Second argument must be a string\n");
        return nullptr;
    }

    utf8_buf = (char *)malloc(str_len + 1);
    if (utf8_buf == NULL) {
        OH_LOG_INFO(LOG_APP, "Failed to allocate memory for string\n");
        return nullptr;
    }

    status = napi_get_value_string_utf8(env, args[1], utf8_buf, str_len + 1, &str_len);
    if (status != napi_ok) {
        free(utf8_buf);
        OH_LOG_INFO(LOG_APP, "Failed to get string value\n");
        return nullptr;
    }
    utf8_buf[str_len] = '\0';
    DataParser::GetInstance().UpdateKeyCodeMap(key, utf8_buf);
    if (utf8_buf != nullptr) {
        free(utf8_buf);
    }
    uint32_t ret;

    ret = StartWork();
    OH_LOG_INFO(LOG_APP, "StartWork ret %{public}d", ret);

    napi_value result = nullptr;
    napi_create_uint32(env, ret, &result);
    return result;
}

static napi_value ReadTemperature(napi_env env, napi_callback_info info) {
    OH_LOG_INFO(LOG_APP, "enter ReadTemperature\n");
    // 调用
    uint8_t dataBuff[8];
    uint32_t bytesRead;
    uint32_t bytesWritten;
    UsbSerial_Device *serial = DataParser::GetInstance().GetSerialObject();
    if (DataParser::GetInstance().GetSerialObject() == nullptr) {
        OH_LOG_INFO(LOG_APP, "fd is null\n");
    };

    auto ret = OH_UsbSerial_Write(DataParser::GetInstance().GetSerialObject(), writeCommand, sizeof(writeCommand),
                                  &bytesWritten);
    if (ret != USB_SERIAL_DDK_SUCCESS) {
        OH_LOG_INFO(LOG_APP, "write command fail,Actual bytes written = %{public}d", bytesWritten);
        TrackTime([&]() { return OH_UsbSerial_Close(&serial); }, "OH_UsbSerial_Close");
        napi_value result = nullptr;
        napi_create_uint32(env, ret, &result);
        return result;
    }
    ret = OH_UsbSerial_Read(serial, dataBuff, sizeof(dataBuff), &bytesRead);
    if (ret != USB_SERIAL_DDK_SUCCESS) {
        OH_LOG_INFO(LOG_APP, "read temperature data fail Actual bytes read= %{public}d\n", bytesRead);
        TrackTime([&]() { return OH_UsbSerial_Close(&serial); }, "OH_UsbSerial_Close");
        napi_value result = nullptr;
        napi_create_uint32(env, ret, &result);
        return result;
    }
    auto temperature = DataParser::GetInstance().ParseData(dataBuff, bytesRead);
    napi_value result = nullptr;
    napi_create_double(env, temperature, &result);
    return result;
}

static napi_value ReleaseResource(napi_env env, napi_callback_info info) {
    OH_LOG_INFO(LOG_APP, "enter ReleaseResource\n");
    UsbSerial_Device *serial = DataParser::GetInstance().GetSerialObject();
    if (serial != nullptr) {
        OH_LOG_INFO(LOG_APP, "function, serial != nullptr\n");
    }
    // 调用ddk 关闭串口
    OH_UsbSerial_Close(&serial);
    OH_UsbSerial_Release();
    return nullptr;
}

void test()
{
    // 1.初始化DDK。
    // 使用 usb_serial_api.h 的 OH_UsbSerial_Init 初始化DDK。
    
    // [Start driver_serial_step1]
    // 初始化USB Serial DDK
    OH_UsbSerial_Init();
    // [End driver_serial_step1]
    
    // 2.打开USB串口设备。
    // 使用 usb_serial_api.h 的 OH_UsbSerial_Open 打开设备。
    
    // [Start driver_serial_step2]
    UsbSerial_Device *dev = NULL;
    uint64_t deviceId = 4294967301;
    uint8_t interfaceIndex = 0;
    // 打开deviceId和interfaceIndex指定的USB串口设备
    OH_UsbSerial_Open(deviceId, interfaceIndex, &dev);
    // [End driver_serial_step2]
    
    // 3.设置USB串口设备的参数。
    // 使用 usb_serial_api.h 的 OH_UsbSerial_SetParams 接口设置串口参数，或者直接调用 OH_UsbSerial_SetBaudRate 设置波特率，使用 OH_UsbSerial_SetTimeout 设置读取数据的超时时间。
    
    // [Start driver_serial_step3]
    UsbSerial_Params params;
    params.baudRate = 9600;
    params.nDataBits = 8;
    params.nStopBits = 1;
    params.parity = 0;
    // 设置串口参数
    OH_UsbSerial_SetParams(dev, &params);
    
    // 设置波特率
    uint32_t baudRate = 9600;
    OH_UsbSerial_SetBaudRate(dev, baudRate);
    
    // 设置超时时间
    int timeout = 500;
    OH_UsbSerial_SetTimeout(dev, timeout);
    // [End driver_serial_step3]
    
    // 4.设置流控、清空缓冲区。
    //使用 usb_serial_api.h 的 OH_UsbSerial_SetFlowControl 设置流控方式，使用 OH_UsbSerial_Flush 清空缓冲区，使用 OH_UsbSerial_FlushInput 清空输入缓冲区，使用 OH_UsbSerial_FlushOutput 清空输出缓冲区。
    
    // [Start driver_serial_step4]
    // 设置软件流控
    OH_UsbSerial_SetFlowControl(dev, USB_SERIAL_SOFTWARE_FLOW_CONTROL);
    
    // 清空缓冲区
    OH_UsbSerial_Flush(dev);
    
    // 清空输入缓冲区
    OH_UsbSerial_FlushInput(dev);
    
    // 清空输出缓冲区
    OH_UsbSerial_FlushOutput(dev);
    // [End driver_serial_step4]
    
    //5.向USB串口设备写入/读取数据。
    // 使用 usb_serial_api.h 的 OH_UsbSerial_Write 给设备发送数据，并使用 OH_UsbSerial_Read 读取设备发送过来的数据。
    
    // [Start driver_serial_step5]
    uint32_t bytesWritten = 0;
    // 测试设备读取指令，具体指令根据设备协议而定
    uint8_t writeBuff[8] = {0x01, 0x03, 0x00, 0x00, 0x00, 0x01, 0x84, 0xA};
    // 发送数据
    OH_UsbSerial_Write(dev, writeBuff, sizeof(writeBuff), &bytesWritten);
    
    // 接收数据
    uint8_t readBuff[100];
    uint32_t bytesRead = 0;
    OH_UsbSerial_Read(dev, readBuff, sizeof(readBuff), &bytesRead);
    // [End driver_serial_step5]
    
    // 6.关闭USB串口设备。
    // 在所有请求处理完毕，程序退出前，使用 usb_serial_api.h 的 OH_UsbSerial_Close 关闭设备。
    
     // [Start driver_serial_step6]
    // 关闭设备
    OH_UsbSerial_Close(&dev);
    // [End driver_serial_step6]
    
    // 7.释放DDK。
    // 在关闭USB串口设备后，使用 usb_serial_api.h 的 OH_UsbSerial_Release 释放DDK。
    
    // [Start driver_serial_step7]
    // 释放USB Serial DDK
    OH_UsbSerial_Release();
    // [End driver_serial_step7]
}

static napi_value UsbSerialInit(napi_env env, napi_callback_info info) {

    napi_value result = nullptr;
    size_t argc = 1;
    napi_status status;
    napi_value args[1];
    status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (status != napi_ok || argc != 1) {
        OH_LOG_ERROR(LOG_APP, "argc is invalid");
        return nullptr;
    }

    uint32_t deviceId = 0;
    status = napi_get_value_uint32(env, args[0], &deviceId);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, nullptr, "Failed to get uint32 value");
        return nullptr;
    }

    OH_LOG_INFO(LOG_APP, "deviceId = %{public}d\n", deviceId);

    uint32_t busNum = ((deviceId & 0xFFFF0000) >> 16);
    OH_LOG_INFO(LOG_APP, "busNum = %{public}d\n", busNum);
    uint32_t deviceNum = deviceId & 0xFFFF;
    OH_LOG_INFO(LOG_APP, "deviceNum = %{public}d\n", deviceNum);

    uint64_t deviceId1 = ((uint64_t)busNum << 32) | deviceNum;

    OH_LOG_INFO(LOG_APP, "deviceId1 = %{public}d\n", deviceId1);

    std::string devStr = std::to_string(deviceId1);
    OH_LOG_INFO(LOG_APP, "devStr = %{public}s\n", devStr.c_str());

    DataParser::GetInstance().UpdateKeyCodeMap(KEY_DEVICEID, (char *)devStr.c_str());
    
    // 初始化USB Serial DDK
    uint32_t ret = OH_UsbSerial_Init();
    OH_LOG_INFO(LOG_APP, "enter UsbSerialInit ret = %{public}d\n", ret);
    
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value Close(napi_env env, napi_callback_info info) {
    UsbSerial_Device *serial = DataParser::GetInstance().GetSerialObject();
    OH_LOG_INFO(LOG_APP, "enter Close\n");
    uint32_t ret = OH_UsbSerial_Close(&serial);
    napi_value result = nullptr;
    napi_create_int32(env, ret, &result);
    DataParser::GetInstance().SetSerialObject(serial);
    OH_LOG_INFO(LOG_APP, "enter Close ret = %{public}d\n", ret);
    return result;
}

static napi_value SetTimeOut(napi_env env, napi_callback_info info) {
    OH_LOG_INFO(LOG_APP, "enter SetTimeOut\n");
    size_t argc = 1;
    napi_value args[1];
    int32_t timeOut;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    auto status = napi_get_value_int32(env, args[0], &timeOut);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "Timeout invalid\n");
        return nullptr;
    }
    int32_t ret = OH_UsbSerial_SetTimeout(DataParser::GetInstance().GetSerialObject(), timeOut);
    napi_value result = nullptr;
    napi_create_int32(env, ret, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"config", nullptr, Config, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"readTemperature", nullptr, ReadTemperature, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseResource", nullptr, ReleaseResource, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"usbSerialInit", nullptr, UsbSerialInit, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"close", nullptr, Close, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setTimeOut", nullptr, SetTimeOut, nullptr, nullptr, nullptr, napi_default, nullptr}};
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

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
