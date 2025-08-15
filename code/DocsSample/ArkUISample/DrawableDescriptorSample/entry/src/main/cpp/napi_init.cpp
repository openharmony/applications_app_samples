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
#include "drawable_manager.h"
#include <arkui/drawable_descriptor.h>
#include <hilog/log.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include <napi/native_api.h>
#include <native_drawing/drawing_pixel_map.h>

// 从PixelMap创建DrawableDescriptor描述符
static napi_value CreateFromPixelMap(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    void *temp = nullptr;
    napi_unwrap(env, args[0], &temp);
    OH_PixelmapNative *nativePixelMap = reinterpret_cast<OH_PixelmapNative *>(temp);

    ArkUI_DrawableDescriptor *descriptor = OH_ArkUI_DrawableDescriptor_CreateFromPixelMap(nativePixelMap);
    if (descriptor == nullptr) {
        return nullptr;
    }

    OH_PixelmapNative *newHandle = OH_ArkUI_DrawableDescriptor_GetStaticPixelMap(descriptor);
    if (nativePixelMap == newHandle) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "GetStaticPixelMap success");
    }

    int32_t imagePixelMapId = DrawableManager::GetInstance().AddDrawable(descriptor);
    napi_value result;
    napi_create_int32(env, imagePixelMapId, &result);
    return result;
}

// 从PixelMap创建DrawableDescriptor描述符
static napi_value CreateFromAnimatedPixelMap(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    void *temp = nullptr;
    napi_unwrap(env, args[0], &temp);
    OH_PixelmapNative *nativePixelMapArray = reinterpret_cast<OH_PixelmapNative *>(temp);

    int32_t size;
    napi_get_value_int32(env, args[1], &size);
    
    ArkUI_DrawableDescriptor *descriptor = OH_ArkUI_DrawableDescriptor_CreateFromAnimatedPixelMap(
        &nativePixelMapArray, size);
    if (descriptor == nullptr) {
        return nullptr;
    }

    OH_PixelmapNativeHandle *newHandle = OH_ArkUI_DrawableDescriptor_GetAnimatedPixelMapArray(descriptor);
    if (nativePixelMapArray == *newHandle) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "GetAnimatedPixelMapArray success");
    }
    int32_t arraySize = OH_ArkUI_DrawableDescriptor_GetAnimatedPixelMapArraySize(descriptor);
    if (arraySize == size) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "GetAnimatedPixelMapArraySize success");
    }

    // 将DrawableDescriptor添加到管理器并获取资源ID
    int32_t imagePixelMapId = DrawableManager::GetInstance().AddDrawable(descriptor);
    napi_value result;
    napi_create_int32(env, imagePixelMapId, &result);
    return result;
}

// 释放DrawableDescriptor描述符
static napi_value DisposeDrawable(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t imagePixelMapId;
    napi_get_value_int32(env, args[0], &imagePixelMapId);
    DrawableManager::GetInstance().RemoveDrawable(imagePixelMapId);
    return nullptr;
}

// 设置duration属性值
static napi_value SetAnimationDuration(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t imagePixelMapId;
    napi_get_value_int32(env, args[0], &imagePixelMapId);
    int32_t duration;
    napi_get_value_int32(env, args[1], &duration);

    ArkUI_DrawableDescriptor* descriptor = DrawableManager::GetInstance().GetDrawable(imagePixelMapId);
    if (descriptor == nullptr) {
        return nullptr;
    }
    OH_ArkUI_DrawableDescriptor_SetAnimationDuration(descriptor, duration);
    return nullptr;
}

// 获取duration属性值
static napi_value GetAnimationDuration(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t imagePixelMapId;
    napi_get_value_int32(env, args[0], &imagePixelMapId);
    
    ArkUI_DrawableDescriptor* descriptor = DrawableManager::GetInstance().GetDrawable(imagePixelMapId);
    if (descriptor == nullptr) {
        return nullptr;
    }

    // 获取动画时长
    int32_t duration = OH_ArkUI_DrawableDescriptor_GetAnimationDuration(descriptor);
    napi_value result;
    napi_create_int32(env, duration, &result);
    return result;
}

// 设置iteration属性值
static napi_value SetAnimationIteration(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t imagePixelMapId;
    napi_get_value_int32(env, args[0], &imagePixelMapId);
    int32_t iteration;
    napi_get_value_int32(env, args[1], &iteration);
    // 获取Drawable描述符
    ArkUI_DrawableDescriptor* descriptor = DrawableManager::GetInstance().GetDrawable(imagePixelMapId);
    if (descriptor == nullptr) {
        return nullptr;
    }
    OH_ArkUI_DrawableDescriptor_SetAnimationIteration(descriptor, iteration);
    return nullptr;
}

// 获取iteration属性值
static napi_value GetAnimationIteration(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 解析参数
    int32_t imagePixelMapId;
    napi_get_value_int32(env, args[0], &imagePixelMapId);
    
    ArkUI_DrawableDescriptor* descriptor = DrawableManager::GetInstance().GetDrawable(imagePixelMapId);
    if (descriptor == nullptr) {
        return nullptr;
    }
    int32_t iteration = OH_ArkUI_DrawableDescriptor_GetAnimationIteration(descriptor);
    napi_value result;
    napi_create_int32(env, iteration, &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // 注册Native方法到ArkTS
    napi_property_descriptor desc[] = {
        {"createFromPixelMap", nullptr, CreateFromPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createFromAnimatedPixelMap", nullptr, CreateFromAnimatedPixelMap, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"disposeDrawable", nullptr, DisposeDrawable, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setAnimationDuration", nullptr, SetAnimationDuration, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getAnimationDuration", nullptr, GetAnimationDuration, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setAnimationIteration", nullptr, SetAnimationIteration, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getAnimationIteration", nullptr, GetAnimationIteration, nullptr, nullptr, nullptr, napi_default, nullptr},
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
