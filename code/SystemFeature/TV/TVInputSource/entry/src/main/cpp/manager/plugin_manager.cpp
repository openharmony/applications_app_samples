/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "plugin_manager.h"
#include <cstdint>
#include <hilog/log.h>
#include <string>
#include "../common/common.h"
#include <native_window/external_window.h>

namespace NativeXComponent {

namespace {
constexpr int32_t NATIVE_WINDOW_OPT_SET_USAGE = 5;
constexpr int32_t VDP_USAGE_FLAG = (1ULL << 45);

int64_t ParseId(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ParseId", "env or info is null");
    }
    size_t argc = 1;
    napi_value args[1] = { nullptr };
    if (napi_ok != napi_get_cb_info(env, info, &argc, args, nullptr, nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ParseId", "GetContext napi_get_cb_info failed");
        return -1;
    }
    int64_t value = 0;
    bool isLossLess = false;
    napi_status status = napi_get_value_bigint_int64(env, args[0], &value, &isLossLess);
    if (!isLossLess) {
        napi_throw_error(env, nullptr, "BigInt values have not been lossless converted");
        return -1;
    }
    if (napi_ok != status) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ParseId", "Get value failed");
        return -1;
    }
    return value;
}

int64_t ParseId1(napi_env env, napi_callback_info info, int64_t *isSetVDP)
{
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ParseId", "env or info is null");
    }
    size_t argc = 1;
    napi_value args[2] = { nullptr };
    if (napi_ok != napi_get_cb_info(env, info, &argc, args, nullptr, nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ParseId", "GetContext napi_get_cb_info failed");
        return -1;
    }
    int64_t value = 0;
    bool isLossLess = false;
    napi_status status = napi_get_value_bigint_int64(env, args[0], &value, &isLossLess);
    if (!isLossLess) {
        napi_throw_error(env, nullptr, "BigInt values have not been lossless converted");
        return -1;
    }
    if (napi_ok != status) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ParseId", "Get value failed");
        return -1;
    }

    napi_status status1 = napi_get_value_bigint_int64(env, args[1], isSetVDP, &isLossLess);
    if ((isLossLess == true) && (status1 == napi_ok)) {
        *isSetVDP = 1;
    }
    return value;
}
} // namespace

std::unordered_map<int64_t, PluginRender *> PluginManager::pluginRenderMap_;
std::unordered_map<int64_t, OHNativeWindow *> PluginManager::windowMap_;

PluginManager::~PluginManager()
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Callback", "~PluginManager");
    for (auto iter = pluginRenderMap_.begin(); iter != pluginRenderMap_.end(); ++iter) {
        if (iter->second != nullptr) {
            delete iter->second;
            iter->second = nullptr;
        }
    }
    pluginRenderMap_.clear();
    for (auto iter = windowMap_.begin(); iter != windowMap_.end(); ++iter) {
        if (iter->second != nullptr) {
            delete iter->second;
            iter->second = nullptr;
        }
    }
    windowMap_.clear();
}

PluginRender *PluginManager::GetPlaginRender(int64_t &id)
{
    if (pluginRenderMap_.find(id) != pluginRenderMap_.end()) {
        return pluginRenderMap_[id];
    }
    return nullptr;
}

napi_value PluginManager::SetSurfaceId1(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "SetSurfaceId1 begin");
    int64_t isSetVDP = 0;
    int64_t surfaceId = ParseId1(env, info, &isSetVDP);
    OHNativeWindow *nativeWindow = nullptr;
    PluginRender *render = nullptr;
    if (windowMap_.find(surfaceId) == windowMap_.end()) {
        OH_NativeWindow_CreateNativeWindowFromSurfaceId(surfaceId, &nativeWindow);
        windowMap_[surfaceId] = nativeWindow;
    }

    if (isSetVDP == 1) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "SetSurfaceId1 begin isSetVDP");
        OH_NativeWindow_NativeWindowHandleOpt(nativeWindow, NATIVE_WINDOW_OPT_SET_USAGE, VDP_USAGE_FLAG);
    }

    if (pluginRenderMap_.find(surfaceId) == pluginRenderMap_.end()) {
        render = new(std::nothrow) PluginRender(surfaceId);
        if (render == nullptr) {
            return nullptr;
        }
        pluginRenderMap_[surfaceId] = render;
    }
    if (render != nullptr) {
        render->InitNativeWimdow(nativeWindow);
    }
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "SetSurfaceId1 end");
    return nullptr;
}

napi_value PluginManager::SetSurfaceId(napi_env env, napi_callback_info info)
{
    int64_t surfaceId = ParseId(env, info);
    OHNativeWindow *nativeWindow = nullptr;
    PluginRender *render = nullptr;
    if (windowMap_.find(surfaceId) == windowMap_.end()) {
        OH_NativeWindow_CreateNativeWindowFromSurfaceId(surfaceId, &nativeWindow);
        windowMap_[surfaceId] = nativeWindow;
    }
    if (pluginRenderMap_.find(surfaceId) == pluginRenderMap_.end()) {
        render = new(std::nothrow) PluginRender(surfaceId);
        if (render == nullptr) {
            return nullptr;
        }
        pluginRenderMap_[surfaceId] = render;
    }
    if (render != nullptr) {
        render->InitNativeWimdow(nativeWindow);
    }
    return nullptr;
}

napi_value PluginManager::DestorySurface(napi_env env, napi_callback_info info)
{
    int64_t surfaceId = ParseId(env, info);
    auto PluginRenderMapIter = pluginRenderMap_.find(surfaceId);
    if (PluginRenderMapIter != pluginRenderMap_.end()) {
        delete PluginRenderMapIter->second;
        pluginRenderMap_.erase(PluginRenderMapIter);
    }
    auto windowMapIter = windowMap_.find(surfaceId);
    if (windowMapIter != windowMap_.end()) {
        OH_NativeWindow_DestroyNativeWindow(windowMapIter->second);
        windowMap_.erase(windowMapIter);
    }
    return nullptr;
}

napi_value PluginManager::ChangeSurface(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(
            LOG_APP,
            LOG_ERROR,
            LOG_PRINT_DOMAIN,
            "PluginManager",
            "ChangeSurfacel: Onload env or info is null ");
        return nullptr;
    }
    int64_t surfaceId = 0;
    size_t argc = 3;
    napi_value args[3] = { nullptr };

    if (napi_ok != napi_get_cb_info(env, info, &argc, args, nullptr, nullptr)) {
        OH_LOG_Print(
            LOG_APP,
            LOG_ERROR,
            LOG_PRINT_DOMAIN,
            "PluginManager",
            "ChangeSurfacel: GetContext napi_get_cb_info failed");
    }
    int index = 0;
    bool isLossLess = false;
    napi_status status = napi_get_value_bigint_int64(env, args[index++], &surfaceId, &isLossLess);
    if (!isLossLess) {
        napi_throw_error(env, nullptr, "BigInt values have not been lossless converted");
        return nullptr;
    }
    if (napi_ok != status) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "ChangeSurfacel: Get value failed");
    }
    double width;
    if (napi_ok != napi_get_value_double(env, args[index++], &width)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "ChangeSurfacel: Get width failed");
    }
    double height;
    if (napi_ok != napi_get_value_double(env, args[index++], &height)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "ChangeSurfacel: Get height failed");
    }
    auto pluginRender = GetPlaginRender(surfaceId);
    if (pluginRender == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "ChangeSurfacel: Get PluginRender failed");
        return nullptr;
    }
    pluginRender->UpdateNativeWindowSize(width, height);
    return nullptr;
}

napi_value PluginManager::DrawTransparentBuffer(napi_env env, napi_callback_info info)
{
    int64_t surfaceId = ParseId(env, info);
    auto pluginRender = GetPlaginRender(surfaceId);
    if (pluginRender == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "PluginManager", "ChangeSurfacel: Get PluginRender failed");
        return nullptr;
    }
    pluginRender->DrawTransparentBuffer();
    return nullptr;
}
} // namespace NativeXComponent
