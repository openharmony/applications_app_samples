/*
* Copyright (c) 2023 Huawei Device Co., Ltd.
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

#include "napi/native_api.h"
#include "hilog/log.h"

#include <cstring>
#include <thread>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <thread>
#include <sys/time.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define MAKE_FILE_NAME (strrchr(__FILE__, '/') + 1)

#define NETMANAGER_VPN_LOGE(fmt, ...)                                                                                  \
    OH_LOG_Print(LOG_APP, LOG_ERROR, VPN_LOG_DOMAIN, VPN_LOG_TAG, "vpn [%{public}s %{public}d] " fmt, MAKE_FILE_NAME,  \
                 __LINE__, ##__VA_ARGS__)

#define NETMANAGER_VPN_LOGI(fmt, ...)                                                                                  \
    OH_LOG_Print(LOG_APP, LOG_INFO, VPN_LOG_DOMAIN, VPN_LOG_TAG, "vpn [%{public}s %{public}d] " fmt, MAKE_FILE_NAME,   \
                 __LINE__, ##__VA_ARGS__)

#define NETMANAGER_VPN_LOGD(fmt, ...)                                                                                  \
    OH_LOG_Print(LOG_APP, LOG_DEBUG, VPN_LOG_DOMAIN, VPN_LOG_TAG, "vpn [%{public}s %{public}d] " fmt, MAKE_FILE_NAME,  \
                 __LINE__, ##__VA_ARGS__)

constexpr string VPN_LOG_TAG = "NetMgrVpn";
constexpr int VPN_LOG_DOMAIN = 0x15b0;
constexpr int BUFFER_SIZE = 2048;
constexpr int EAGAIN = 11;

struct FdInfo {
    int32_t tunFd = 0;
    int32_t tunnelFd = 0;
    struct sockaddr_in serverAddr;
};

static bool threadRunF = false;
static std::thread threadt1;
static std::thread threadt2;

static constexpr const int MAX_STRING_LENGTH = 1024;
static std::string GetStringFromValueUtf8(napi_env env, napi_value value)
{
    std::string result;
    char str[MAX_STRING_LENGTH] = {0};
    size_t length = 0;
    napi_get_value_string_utf8(env, value, str, MAX_STRING_LENGTH, &length);
    if (length > 0) {
        return result.append(str, length);
    }
    return result;
}

static void HandleReadTunfd(FdInfo fdInfo)
{
    FdInfo fdInfo;
    uint8_t buffer[BUFFER_SIZE] = {0};
    while (threadRunF) {
        if (fdInfo.tunFd <= 0) {
            sleep(1);
            continue;
        }

        int ret = read(fdInfo.tunFd, buffer, sizeof(buffer));
        if (ret <= 0) {
            if (errno != EAGAIN) {
                //    NETMANAGER_VPN_LOGE("read tun device error: %{public}d %{public}d", errno, fdInfo.tunFd);
                sleep(1);
            }
            continue;
        }

        // 读取到虚拟网卡的数据，通过tcp隧道，发送给客户端
        NETMANAGER_VPN_LOGD("buffer: %{public}s, len: %{public}d", buffer, ret);
        ret = sendto(fdInfo.tunnelFd, buffer, ret, 0, static_cast<struct sockaddr *>(&fdInfo.serverAddr),
                     sizeof(fdInfo.serverAddr));
        if (ret <= 0) {
            NETMANAGER_VPN_LOGE("send to server[%{public}s:%{public}d] failed, ret: %{public}d, error: %{public}s",
                                inet_ntoa(fdInfo.serverAddr.sin_addr), ntohs(fdInfo.serverAddr.sin_port), ret,
                                strerror(errno));
            continue;
        }
    }
}

static void HandleTcpReceived(FdInfo fdInfo)
{
    FdInfo fdInfo;
    int addrlen = sizeof(struct sockaddr_in);
    uint8_t buffer[BUFFER_SIZE] = {0};
    while (threadRunF) {
        if (fdInfo.tunnelFd <= 0) {
            sleep(1);
            continue;
        }

        int length = recvfrom(fdInfo.tunnelFd, buffer, sizeof(buffer), 0,
                              static_cast<struct sockaddr *>(&fdInfo.serverAddr),
                              static_cast<socklen_t *>(&addrlen));
        if (length < 0) {
            if (errno != EAGAIN) {
                NETMANAGER_VPN_LOGE("read tun device error: %{public}d %{public}d", errno, fdInfo.tunnelFd);
            }
            continue;
        }

        NETMANAGER_VPN_LOGI("from [%{public}s:%{public}d] data: %{public}s, len: %{public}d",
                            inet_ntoa(fdInfo.serverAddr.sin_addr), ntohs(fdInfo.serverAddr.sin_port), buffer, length);
        int ret = write(fdInfo.tunFd, buffer, length);
        if (ret <= 0) {
            // NETMANAGER_VPN_LOGE("error Write To Tunfd, errno: %{public}d", errno);
        }
    }
}

static napi_value TcpConnect(napi_env env, napi_callback_info info)
{
    FdInfo fdInfo;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t port = 0;
    napi_get_value_int32(env, args[1], &port);
    std::string ipAddr = GetStringFromValueUtf8(env, args[0]);

    NETMANAGER_VPN_LOGI("ip: %{public}s port: %{public}d", ipAddr.c_str(), port);

    int32_t sockFd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockFd == -1) {
        NETMANAGER_VPN_LOGE("socket() error");
        return 0;
    }

    struct timeval timeout = {1, 0};
    setsockopt(sockFd, SOL_SOCKET, SO_RCVTIMEO, static_cast<char *>(&timeout), sizeof(struct timeval));

    memcpy_s(&fdInfo.serverAddr, sizeof(fdInfo.serverAddr), 0, sizeof(fdInfo.serverAddr));
    fdInfo.serverAddr.sin_family = AF_INET;
    fdInfo.serverAddr.sin_addr.s_addr = inet_addr(ipAddr.c_str()); // server's IP addr
    fdInfo.serverAddr.sin_port = htons(port);                      // port

    NETMANAGER_VPN_LOGI("Connection successful\n");

    napi_value tunnelFd;
    napi_create_int32(env, sockFd, &tunnelFd);
    return tunnelFd;
}

static napi_value StartVpn(napi_env env, napi_callback_info info)
{
    FdInfo fdInfo;
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_int32(env, args[0], &fdInfo.tunFd);
    napi_get_value_int32(env, args[1], &fdInfo.tunnelFd);

    if (threadRunF) {
        threadRunF = false;
        threadt1.join();
        threadt2.join();
    }

    threadRunF = true;
    std::thread tt1(HandleReadTunfd, fdInfo);
    std::thread tt2(HandleTcpReceived, fdInfo);

    threadt1 = std::move(tt1);
    threadt2 = std::move(tt2);

    NETMANAGER_VPN_LOGI("StartVpn successful\n");

    napi_value retValue;
    napi_create_int32(env, 0, &retValue);
    return retValue;
}

static napi_value StopVpn(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t tunnelFd;
    napi_get_value_int32(env, args[0], &tunnelFd);
    if (tunnelFd) {
        close(tunnelFd);
        tunnelFd = 0;
    }

    if (threadRunF) {
        threadRunF = false;
        threadt1.join();
        threadt2.join();
    }

    NETMANAGER_VPN_LOGI("StopVpn successful\n");

    napi_value retValue;
    napi_create_int32(env, 0, &retValue);
    return retValue;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"tcpConnect", nullptr, TcpConnect, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startVpn", nullptr, StartVpn, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopVpn", nullptr, StopVpn, nullptr, nullptr, nullptr, napi_default, nullptr},
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
    NETMANAGER_VPN_LOGI("vpn 15b0 HELLO ~~~~~~~~~~");
    napi_module_register(&demoModule);
}
