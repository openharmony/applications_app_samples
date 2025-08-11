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
#include "plugin_manager.h"
#include <arkui/native_interface.h>
#include <cstdint>
#include <hilog/log.h>
#include <string>

namespace NativeXComponentSample {
std::unordered_map<std::string, ArkUI_NodeHandle> PluginManager::nodeHandleMap_;
std::unordered_map<void *, OH_ArkUI_SurfaceCallback *> PluginManager::callbackMap_;
std::unordered_map<void *, OH_ArkUI_SurfaceHolder *> PluginManager::surfaceHolderMap_;
ArkUI_AccessibilityProvider *PluginManager::provider_ = nullptr;
ArkUI_NativeNodeAPI_1 *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
    OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
namespace {
std::string value2String(napi_env env, napi_value value) // 将napi_value转化为string类型的变量
{
    size_t stringSize = 0;
    napi_get_value_string_utf8(env, value, nullptr, 0, &stringSize);
    std::string valueString;
    valueString.resize(stringSize);
    napi_get_value_string_utf8(env, value, &valueString[0], stringSize + 1, &stringSize);
    return valueString;
}

void OnSurfaceCreated(OH_ArkUI_SurfaceHolder *holder)
{
    auto window = OH_ArkUI_XComponent_GetNativeWindow(holder); // 获取native window
    auto render = reinterpret_cast<EGLRender*>(OH_ArkUI_SurfaceHolder_GetUserData(holder));
    render->SetUpEGLContext(window); // 初始化egl环境
}

void OnSurfaceChanged(OH_ArkUI_SurfaceHolder *holder, uint64_t width, uint64_t height)
{
    EGLRender* render = reinterpret_cast<EGLRender*>(OH_ArkUI_SurfaceHolder_GetUserData(holder));
    render->SetEGLWindowSize(width, height); // 设置绘制区域大小
    render->DrawStar(true);                  // 绘制五角星
}

void OnSurfaceDestroyed(OH_ArkUI_SurfaceHolder *holder)
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0xff00, "onBind", "on destroyed");
    EGLRender* render = reinterpret_cast<EGLRender*>(OH_ArkUI_SurfaceHolder_GetUserData(holder));
    render->DestroySurface();  // 销毁eglSurface相关资源
}

void OnSurfaceShow(OH_ArkUI_SurfaceHolder *holder)
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "onBind", "on surface show");
}

void OnSurfaceHide(OH_ArkUI_SurfaceHolder *holder)
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "onBind", "on surface hide");
}

void OnFrameCallback(ArkUI_NodeHandle node, uint64_t timestamp, uint64_t targetTimestamp)
{
    if (!PluginManager::surfaceHolderMap_.count(node)) {
        return;
    }
    static uint64_t count = 0;
    count++;
    if (count % FRAME_COUNT == 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "onBind", "OnFrameCallback count = %{public}ld", count);
    }
}

void onEvent(ArkUI_NodeEvent *event)
{
    auto eventType = OH_ArkUI_NodeEvent_GetEventType(event); // 获取组件事件类型
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "onBind", "on event");
    if (eventType == NODE_TOUCH_EVENT) {
        ArkUI_NodeHandle handle = OH_ArkUI_NodeEvent_GetNodeHandle(event); // 获取触发该事件的组件对象
        auto holder = PluginManager::surfaceHolderMap_[handle];
        EGLRender* render = reinterpret_cast<EGLRender*>(OH_ArkUI_SurfaceHolder_GetUserData(holder));
        render->DrawStar(false); // 绘制五角星
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "onBind", "on touch");
    }
}
} // namespace

napi_value PluginManager::BindNode(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    std::string nodeId = value2String(env, args[0]);
    ArkUI_NodeHandle handle;
    OH_ArkUI_GetNodeHandleFromNapiValue(env, args[1], &handle);             // 获取 nodeHandle
    OH_ArkUI_SurfaceHolder *holder = OH_ArkUI_SurfaceHolder_Create(handle); // 获取 SurfaceHolder
    nodeHandleMap_[nodeId] = handle;
    surfaceHolderMap_[handle] = holder;
    auto callback = OH_ArkUI_SurfaceCallback_Create(); // 创建 SurfaceCallback
    callbackMap_[holder] = callback;
    auto render = new EGLRender();
    OH_ArkUI_SurfaceHolder_SetUserData(holder, render); // 将render保存在holder中
    OH_ArkUI_SurfaceCallback_SetSurfaceCreatedEvent(callback, OnSurfaceCreated);     // 注册OnSurfaceCreated回调
    OH_ArkUI_SurfaceCallback_SetSurfaceChangedEvent(callback, OnSurfaceChanged);     // 注册OnSurfaceChanged回调
    OH_ArkUI_SurfaceCallback_SetSurfaceDestroyedEvent(callback, OnSurfaceDestroyed); // 注册OnSurfaceDestroyed回调
    OH_ArkUI_SurfaceCallback_SetSurfaceShowEvent(callback, OnSurfaceShow);           // 注册OnSurfaceShow回调
    OH_ArkUI_SurfaceCallback_SetSurfaceHideEvent(callback, OnSurfaceHide);           // 注册OnSurfaceHide回调
    OH_ArkUI_XComponent_RegisterOnFrameCallback(handle, OnFrameCallback);            // 注册OnFrameCallback回调
    OH_ArkUI_SurfaceHolder_AddSurfaceCallback(holder, callback);                     // 注册SurfaceCallback回调
    if (!nodeAPI->addNodeEventReceiver(handle, onEvent)) { // 添加事件监听，返回成功码 0
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "onBind", "addNodeEventReceiver error");
    }
    if (!nodeAPI->registerNodeEvent(handle, NODE_TOUCH_EVENT, 0, nullptr)) { // 用C接口注册touch事件，返回成功码 0
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "onBind", "registerTouchEvent error");
    }
    provider_ = OH_ArkUI_AccessibilityProvider_Create(handle); // 创建一个ArkUI_AccessibilityProvider类型的对象
    /**
     * 获取ArkUI_AccessibilityProvider后，如果注册无障碍回调函数请参考：
     * https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ndk-accessibility-xcomponent.md
     * **/
    return nullptr;
}

napi_value PluginManager::UnbindNode(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    std::string nodeId = value2String(env, args[0]);
    ArkUI_NodeHandle node;
    if (nodeHandleMap_.find(nodeId) == nodeHandleMap_.end()) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "SetNeedSoftKeyboard", "nodeId not exit error");
        return nullptr;
    }
    node = nodeHandleMap_[nodeId];
    OH_ArkUI_XComponent_UnregisterOnFrameCallback(node); // 解注册帧回调
    OH_ArkUI_AccessibilityProvider_Dispose(provider_);   // 销毁 ArkUI_AccessibilityProvider
    auto holder = surfaceHolderMap_[node];
    if (PluginManager::callbackMap_.count(holder)) {
        auto callback = PluginManager::callbackMap_[holder];
        OH_ArkUI_SurfaceHolder_RemoveSurfaceCallback(holder, callback); // 移除SurfaceCallback
        OH_ArkUI_SurfaceCallback_Dispose(callback);                     // 销毁surfaceCallback
        PluginManager::callbackMap_.erase(holder);
    }
    auto render = reinterpret_cast<EGLRender*>(OH_ArkUI_SurfaceHolder_GetUserData(holder));
    delete render; // 销毁EGLRender对象
    OH_ArkUI_SurfaceHolder_Dispose(holder); // 销毁surfaceHolder
    nodeAPI->disposeNode(node);             // 销毁nodeHandle
    nodeHandleMap_.erase(nodeId);
    return nullptr;
}

napi_value PluginManager::SetFrameRate(napi_env env, napi_callback_info info)
{
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    std::string nodeId = value2String(env, args[0]);
    auto node = nodeHandleMap_[nodeId];

    int32_t min = 0;
    napi_get_value_int32(env, args[FIRST_ARG], &min);

    int32_t max = 0;
    napi_get_value_int32(env, args[SECOND_ARG], &max);

    int32_t expected = 0;
    napi_get_value_int32(env, args[THIRD_ARG], &expected);
    OH_NativeXComponent_ExpectedRateRange range = {.min = min, .max = max, .expected = expected};
    OH_ArkUI_XComponent_SetExpectedFrameRateRange(node, range); // 设置期望帧率
    return nullptr;
}

napi_value PluginManager::SetNeedSoftKeyboard(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    std::string nodeId = value2String(env, args[0]);
    ArkUI_NodeHandle node;
    if (nodeHandleMap_.find(nodeId) == nodeHandleMap_.end()) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "SetNeedSoftKeyboard", "nodeId not exit error");
        return nullptr;
    }
    node = nodeHandleMap_[nodeId];

    bool needSoftKeyboard = false;
    napi_get_value_bool(env, args[1], &needSoftKeyboard);
    OH_ArkUI_XComponent_SetNeedSoftKeyboard(node, needSoftKeyboard); // 设置是否需要软键盘
    return nullptr;
}

napi_value PluginManager::Initialize(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    std::string nodeId = value2String(env, args[0]);
    ArkUI_NodeHandle node;
    if (nodeHandleMap_.find(nodeId) == nodeHandleMap_.end()) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "SetNeedSoftKeyboard", "nodeId not exit error");
        return nullptr;
    }
    node = nodeHandleMap_[nodeId];
    OH_ArkUI_XComponent_Initialize(node);
    auto holder = surfaceHolderMap_[node];
    EGLRender* render = reinterpret_cast<EGLRender*>(OH_ArkUI_SurfaceHolder_GetUserData(holder));
    render->DrawStar(true); // 绘制五角星
    return nullptr;
}

napi_value PluginManager::Finalize(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    std::string nodeId = value2String(env, args[0]);
    ArkUI_NodeHandle node;
    if (nodeHandleMap_.find(nodeId) == nodeHandleMap_.end()) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "SetNeedSoftKeyboard", "nodeId not exit error");
        return nullptr;
    }
    node = nodeHandleMap_[nodeId];
    auto holder = surfaceHolderMap_[node];
    EGLRender* render = reinterpret_cast<EGLRender*>(OH_ArkUI_SurfaceHolder_GetUserData(holder));
    render->Clear();
    OH_ArkUI_XComponent_Finalize(node);
    return nullptr;
}

napi_value PluginManager::DrawStar(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    std::string nodeId = value2String(env, args[0]);
    ArkUI_NodeHandle node;
    if (nodeHandleMap_.find(nodeId) == nodeHandleMap_.end()) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "SetNeedSoftKeyboard", "nodeId not exit error");
        return nullptr;
    }
    node = nodeHandleMap_[nodeId];
    auto holder = surfaceHolderMap_[node];
    EGLRender* render = reinterpret_cast<EGLRender*>(OH_ArkUI_SurfaceHolder_GetUserData(holder));
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0xff00, "onBind", "YGB DrawStar w:[%{public}d],h[%{public}d]", render->width_,
                 render->height_);
    render->DrawStar(true); // 绘制五角星
    return nullptr;
}
} // namespace NativeXComponentSample