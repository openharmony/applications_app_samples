/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "common/common.h"
#include "xcomponent_manager.h"
#include <cstdint>
#include <string>

#include <native_buffer/native_buffer.h>
#include <native_window/external_window.h>

#include "manager/AccessibilityManager.h"
#include "plugin_manager.h"


void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Callback", "OnSurfaceCreatedCB");
    if ((component == nullptr) || (window == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Callback",
                     "OnSurfaceCreatedCB: component or window is null");
        return;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Callback",
                     "OnSurfaceCreatedCB: Unable to get XComponent id");
        return;
    }

    std::string id(idStr);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Callback",
                 "OnSurfaceCreatedCB component id is %{public}s", id.c_str());
    
    auto plugin = NativeXComponentSample::PluginManager::GetInstance();
    plugin->AttachXComponent(id, component, reinterpret_cast<::OHNativeWindow *>(window));
}

void OnSurfaceChangedCB(OH_NativeXComponent *component, void *window)
{
}

void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
}

void DispatchTouchEventCB(OH_NativeXComponent *component, void *window)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Callback", "DispatchTouchEventCB");
    OH_NativeXComponent_TouchEvent touchEvent;
}

void DispatchHoverEvent(::OH_NativeXComponent *xComponent, bool isHover)
{
}

namespace NativeXComponentSample {

XComponentManager::XComponentManager() : accessibilityManager(new AccessibilityManager())
{
}

XComponentManager::~XComponentManager()
{
    delete accessibilityManager;
}

void XComponentManager::RegisterCallback(OH_NativeXComponent *nativeXComponent)
{
    renderCallback_.OnSurfaceCreated = ::OnSurfaceCreatedCB;
    renderCallback_.OnSurfaceChanged = ::OnSurfaceChangedCB;
    renderCallback_.OnSurfaceDestroyed = ::OnSurfaceDestroyedCB;
    renderCallback_.DispatchTouchEvent = ::DispatchTouchEventCB;
    int ret = OH_NativeXComponent_RegisterCallback(nativeXComponent, &renderCallback_);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "XComponentManager", "RegisterCallback %{public}d", ret);
}

void XComponentManager::SetNativeXComponent(const std::string &id, OH_NativeXComponent *nativeXComponent,
                                            OHNativeWindow *window)
{
    if (nativeXComponent == nullptr) {
        return;
    }
    auto it = nativeXComponentMap_.find(id);
    if (id.c_str() == singleInstanceId) {
        accessibilityManager->Initialize(nativeXComponent);
    } else {
        accessibilityManager->Initialize(id, nativeXComponent);
    }
    if (it != nativeXComponentMap_.end()) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "SetNativeXComponent", "%{public}s already exists",
                     id.data());
        return;
    } else {
        nativeXComponentMap_.emplace(id, XSurface{nativeXComponent, window});
    }
}
} // namespace NativeXComponentSample