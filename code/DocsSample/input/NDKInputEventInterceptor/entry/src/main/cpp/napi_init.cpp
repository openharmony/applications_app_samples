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

#include <string>
#include <sstream>
#include <map>
#include "napi/native_api.h"
#include "multimodalinput/oh_input_manager.h"

std::string g_value = "";
napi_ref g_callback_ref = nullptr;
napi_env g_env = nullptr;

napi_value OnChange(napi_env env, napi_callback_info info)
{
    g_env = env;
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 保存 callback 引用
    napi_create_reference(env, args[0], 1, &g_callback_ref);
    return nullptr;
}

void NotifyValueChange()
{
    if (g_callback_ref == nullptr || g_env == nullptr) {
        return;
    }

    napi_value callback;
    napi_get_reference_value(g_env, g_callback_ref, &callback);

    // callback的输入参数
    napi_value event;
    napi_create_object(g_env, &event);

    napi_value value_js;
    napi_create_string_utf8(g_env, g_value.c_str(), g_value.length(), &value_js);
    napi_set_named_property(g_env, event, "value", value_js);
    napi_value global;
    napi_get_global(g_env, &global);
    napi_call_function(g_env, global, callback, 1, &event, nullptr);
}

// [Start key_event_interceptor]
struct KeyEvent {
    int32_t action;
    int32_t keyCode;
    int64_t actionTime { -1 };
};

//定义按键事件回调函数
void OnKeyEventCallback(const Input_KeyEvent* keyEvent)
{
    KeyEvent event;
    //Input_KeyEvent的生命周期仅限于回调函数内，回调函数执行完毕后会被自动销毁
    event.action = OH_Input_GetKeyEventAction(keyEvent);
    event.keyCode = OH_Input_GetKeyEventKeyCode(keyEvent);
    event.actionTime = OH_Input_GetKeyEventActionTime(keyEvent);
    // [StartExclude key_event_interceptor]
    std::ostringstream oss;
    oss << "监听到按键事件 action："  << event.action
    << " keyCode： " << event.keyCode
    << " actionTime：" << event.actionTime;
    g_value = oss.str();
    NotifyValueChange();
    // [EndExclude key_event_interceptor]
}

static napi_value AddKeyEventInterceptor(napi_env env, napi_callback_info info)
{
    Input_Result ret = OH_Input_AddKeyEventInterceptor(OnKeyEventCallback, nullptr);
    // [StartExclude key_event_interceptor]
    std::string message = "";
    if (ret == INPUT_SUCCESS) {
        message = "Key event interceptor added successfully, return " + std::to_string(ret);
    } else {
        message = "Key event interceptor added failed, return " + std::to_string(ret);
    }
    napi_value result;
    napi_create_string_utf8(env, message.c_str(), message.size(), &result);
    return result;
    // [EndExclude key_event_interceptor]
}

static napi_value RemoveKeyEventInterceptor(napi_env env, napi_callback_info info)
{
    Input_Result ret = OH_Input_RemoveKeyEventInterceptor();
    // [StartExclude key_event_interceptor]
    std::string message = "";
    if (ret == INPUT_SUCCESS) {
        message = "Key event interceptor removed successfully, return " + std::to_string(ret);
    } else {
        message = "Key event interceptor removed failed, return " + std::to_string(ret);
    }
    napi_value result;
    napi_create_string_utf8(env, message.c_str(), message.size(), &result);
    return result;
    // [EndExclude key_event_interceptor]
}
// [End key_event_interceptor]

// [Start input_event_interceptor]
struct MouseEvent {
    int32_t action;
    int32_t displayX;
    int32_t displayY;
    int32_t button { -1 };
    int32_t axisType { -1 };
    float axisValue { 0.0f };
    int64_t actionTime { -1 };
};

struct TouchEvent {
    int32_t action;
    int32_t id;
    int32_t displayX;
    int32_t displayY;
    int64_t actionTime { -1 };
};

struct AxisEvent {
    int32_t axisAction;
    float displayX;
    float displayY;
    std::map<int32_t, double> axisValues;
    int64_t actionTime { -1 };
    int32_t sourceType;
    int32_t axisEventType { -1 };
};

//定义鼠标事件回调函数
void OnMouseEventCallback(const Input_MouseEvent* mouseEvent)
{
    MouseEvent event;
    //Input_MouseEvent的生命周期仅在回调函数内，出了回调函数会被销毁
    event.action = OH_Input_GetMouseEventAction(mouseEvent);
    event.displayX = OH_Input_GetMouseEventDisplayX(mouseEvent);
    event.displayY = OH_Input_GetMouseEventDisplayY(mouseEvent);
    event.button = OH_Input_GetMouseEventButton(mouseEvent);
    event.axisType = OH_Input_GetMouseEventAxisType(mouseEvent);
    event.axisValue = OH_Input_GetMouseEventAxisValue(mouseEvent);
    event.actionTime = OH_Input_GetMouseEventActionTime(mouseEvent);
    // [StartExclude input_event_interceptor]
    std::ostringstream oss;
    oss << "监听到鼠标事件 action："  << event.action
    << " displayX： " << event.displayX
    << " displayY：" << event.displayY
    << " button：" << event.button
    << " axisType：" << event.axisType
    << " axisValue：" << event.axisValue
    << " actionTime：" << event.actionTime;
    g_value = oss.str();
    NotifyValueChange();
    // [EndExclude input_event_interceptor]
}

//定义触摸事件回调函数
void OnTouchEventCallback(const Input_TouchEvent* touchEvent)
{
    TouchEvent event;
    //Input_TouchEvent的生命周期仅在回调函数内，出了回调函数会被销毁
    event.action = OH_Input_GetTouchEventAction(touchEvent);
    event.id = OH_Input_GetTouchEventFingerId(touchEvent);
    event.displayX = OH_Input_GetTouchEventDisplayX(touchEvent);
    event.displayY = OH_Input_GetTouchEventDisplayY(touchEvent);
    event.actionTime = OH_Input_GetTouchEventActionTime(touchEvent);
    // [StartExclude input_event_interceptor]
    std::ostringstream oss;
    oss << "监听到触摸事件 action："  << event.action
    << " displayX： " << event.displayX
    << " displayY：" << event.displayY
    << " id：" << event.id
    << " actionTime：" << event.actionTime;
    g_value = oss.str();
    NotifyValueChange();
    // [EndExclude input_event_interceptor]
}

//定义轴事件回调函数
void OnAxisEventCallback(const Input_AxisEvent* axisEvent)
{
    AxisEvent event;
    
    //Input_AxisEvent的生命周期仅在回调函数内，出了回调函数会被销毁
    InputEvent_AxisAction action;
    Input_Result ret = OH_Input_GetAxisEventAction(axisEvent, &action);
    event.axisAction = action;
    ret = OH_Input_GetAxisEventDisplayX(axisEvent, &event.displayX);
    ret = OH_Input_GetAxisEventDisplayY(axisEvent, &event.displayY);
    ret = OH_Input_GetAxisEventActionTime(axisEvent, &event.actionTime);
    InputEvent_SourceType sourceType;
    ret = OH_Input_GetAxisEventSourceType(axisEvent, &sourceType);
    event.sourceType = sourceType;
    InputEvent_AxisEventType axisEventType;
    ret = OH_Input_GetAxisEventType(axisEvent, &axisEventType);
    event.axisEventType = axisEventType;
    if (event.axisEventType == AXIS_EVENT_TYPE_PINCH) {
        double value = 0;
        ret = OH_Input_GetAxisEventAxisValue(axisEvent, AXIS_TYPE_PINCH, &value);
        event.axisValues.insert(std::make_pair(AXIS_TYPE_PINCH, value));
        ret = OH_Input_GetAxisEventAxisValue(axisEvent, AXIS_TYPE_ROTATE, &value);
        event.axisValues.insert(std::make_pair(AXIS_TYPE_ROTATE, value));
    } else if (event.axisEventType == AXIS_EVENT_TYPE_SCROLL) {
        double value = 0;
        ret = OH_Input_GetAxisEventAxisValue(axisEvent, AXIS_TYPE_SCROLL_VERTICAL, &value);
        event.axisValues.insert(std::make_pair(AXIS_TYPE_SCROLL_VERTICAL, value));
        ret = OH_Input_GetAxisEventAxisValue(axisEvent, AXIS_TYPE_SCROLL_HORIZONTAL, &value);
        event.axisValues.insert(std::make_pair(AXIS_TYPE_SCROLL_HORIZONTAL, value));
    }
    // [StartExclude input_event_interceptor]
    std::ostringstream oss;
    oss << "监听到轴事件 axisAction："  << event.axisAction
    << " displayX： " << event.displayX
    << " displayY：" << event.displayY
    << " sourceType：" << event.sourceType
    << " actionTime：" << event.actionTime
    << " axisEventType：" << event.axisEventType
    << "\n axisValues:";
    for (const auto& pair : event.axisValues) {
        oss << " axis" << pair.first << "=" << pair.second;
    }
    g_value = oss.str();
    NotifyValueChange();
    // [EndExclude input_event_interceptor]
}

//输入事件回调函数结构体
Input_InterceptorEventCallback g_eventCallback;

static napi_value AddEventInterceptor(napi_env env, napi_callback_info info)
{
    //设置鼠标事件回调函数
    g_eventCallback.mouseCallback = OnMouseEventCallback;
    //设置触摸事件回调函数
    g_eventCallback.touchCallback = OnTouchEventCallback;
    //设置轴事件回调函数
    g_eventCallback.axisCallback = OnAxisEventCallback;
    Input_Result ret = OH_Input_AddInputEventInterceptor(&g_eventCallback, nullptr);
    // [StartExclude input_event_interceptor]
    std::string message = "";
    if (ret == INPUT_SUCCESS) {
        message = "填加输入事件拦截成功，返回码为" + std::to_string(ret);
    } else {
        message = "填加输入事件拦截失败，返回码为" + std::to_string(ret);
    }
    napi_value result;
    napi_create_string_utf8(env, message.c_str(), message.size(), &result);
    return result;
    // [EndExclude input_event_interceptor]
}

static napi_value RemoveEventInterceptor(napi_env env, napi_callback_info info)
{
    Input_Result ret = OH_Input_RemoveInputEventInterceptor();
    // [StartExclude input_event_interceptor]
    std::string message = "";
    if (ret == INPUT_SUCCESS) {
        message = "移除输入拦截成功，返回码为" + std::to_string(ret);
    } else {
        message = "移除输入拦截失败，返回码为" + std::to_string(ret);
    }
    napi_value result;
    napi_create_string_utf8(env, message.c_str(), message.size(), &result);
    return result;
    // [EndExclude input_event_interceptor]
}
// [End input_event_interceptor]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "onChange", nullptr, OnChange, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "addKeyEventInterceptor", nullptr, AddKeyEventInterceptor, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "removeKeyEventInterceptor", nullptr, RemoveKeyEventInterceptor, nullptr, nullptr, nullptr,
            napi_default, nullptr },
        { "addEventInterceptor", nullptr, AddEventInterceptor, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "removeEventInterceptor", nullptr, RemoveEventInterceptor, nullptr, nullptr, nullptr, napi_default, nullptr },
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
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
