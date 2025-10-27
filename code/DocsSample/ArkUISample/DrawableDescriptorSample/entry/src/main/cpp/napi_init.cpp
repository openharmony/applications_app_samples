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
#include "rawfile/raw_file_manager.h"
#include <arkui/drawable_descriptor.h>
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <hilog/log.h>
#include <multimedia/image_framework/image/image_common.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include <napi/native_api.h>
#include <native_drawing/drawing_pixel_map.h>
#include <resourcemanager/ohresmgr.h>


enum class PixelMapFormat { RGBA_8888 = PIXEL_FORMAT_BGRA_8888 };
class DecodingOptions {
public:
    DecodingOptions()
    {
        OH_DecodingOptions *options;
        OH_DecodingOptions_Create(&options);
        options_ = options;
    }
    ~DecodingOptions() = default;

    void SetPixelFormat(PixelMapFormat format)
    {
        OH_DecodingOptions_SetPixelFormat(options_, static_cast<int32_t>(PixelMapFormat::RGBA_8888));
    }

    OH_DecodingOptions *GetNativePointer() { return options_; }

private:
    OH_DecodingOptions *options_;
};

struct PixelMaps {
    OH_PixelmapNative** pixelMaps;
    size_t size;
};

static ArkUI_NodeHandle mainPageScroll = nullptr;
static ArkUI_NativeNodeAPI_1* GetNodeApi()
{
    static ArkUI_NativeNodeAPI_1* nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1*>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    return nodeApi;
}

static ArkUI_NodeHandle GetMainPageSroll()
{
    if (mainPageScroll == nullptr) {
        ArkUI_NativeNodeAPI_1* nodeApi = GetNodeApi();
        mainPageScroll = nodeApi->createNode(ARKUI_NODE_SCROLL);
    }
    return mainPageScroll;
}

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
    DrawableManager::GetInstance().RemoveDrawable(imagePixelMapId);
    return nullptr;
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
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "Dispose success");
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
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "---test SetAnimationDuration, %{public}d", duration);
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
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "---test GetAnimationDuration, %{public}d", duration);
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
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "---test SetAnimationIteration, %{public}d", iteration);
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
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "---test GetAnimationIteration, %{public}d", iteration);
    return result;
}

PixelMaps CreatePixelMapList(OH_ImageSourceNative *source, DecodingOptions options)
{
    if (source == nullptr) {
        return {nullptr, 0};
    }
    uint32_t count = 0;
    OH_ImageSourceNative_GetFrameCount(source, &count);
    if (count <= 1) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "---test CreatePixelMapList failed, count = %{public}d", count);
        return {nullptr, 0};
    }
    OH_PixelmapNative **resPixMapList = new OH_PixelmapNative *[count];
    auto code = OH_ImageSourceNative_CreatePixelmapList(source, options.GetNativePointer(), resPixMapList,
                                                        static_cast<size_t>(count));
    if (code != Image_ErrorCode::IMAGE_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "---test CreatePixelMapList failed, code = %{public}d", code);
        delete[] resPixMapList;
        return {nullptr, 0};
    }
    PixelMaps maps;
    maps.pixelMaps = resPixMapList;
    maps.size = count;
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "---test CreatePixelMapList succ, count = %{public}d", count);
    return maps;
}

ArkUI_DrawableDescriptor* GetPixelMapArray(napi_env env, napi_callback_info info, size_t &size)
{
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    uint8_t *data = nullptr;
    uint64_t dataLen = 0;
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[1]);
    OH_ResourceManager_GetMediaByName(mNativeResMgr, "test1", &data, &dataLen);

    OH_ImageSourceNative *source = nullptr;
    auto code = OH_ImageSourceNative_CreateFromData(data, dataLen, &source);

    DecodingOptions options;
    PixelMaps maps = CreatePixelMapList(source, options);

    auto descriptor = OH_ArkUI_DrawableDescriptor_CreateFromAnimatedPixelMap(maps.pixelMaps, maps.size);
    if (descriptor == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "---test CreateFromAnimatedPixelMap failed");
    }
    size = maps.size;
    return descriptor;
}

static napi_value AddPixelMapArray(napi_env env, napi_callback_info info, ArkUI_NodeHandle sroll)
{
    ArkUI_NativeNodeAPI_1* nodeApi = GetNodeApi();
    size_t mapSize = 0;
    ArkUI_DrawableDescriptor* pixelArrayDes = GetPixelMapArray(env, info, mapSize);
    
    ArkUI_NodeHandle imageNode = nodeApi->createNode(ARKUI_NODE_IMAGE);
    ArkUI_AttributeItem item = {.object = pixelArrayDes};
    nodeApi->setAttribute(imageNode, NODE_IMAGE_SRC, &item);
    nodeApi->addChild(sroll, imageNode);

    // 将DrawableDescriptor添加到管理器并获取资源ID
    int32_t imagePixelMapId = DrawableManager::GetInstance().AddDrawable(pixelArrayDes);
    napi_value result;
    napi_create_int32(env, imagePixelMapId, &result);
    return result;
}

static napi_value CreateNodePage(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        return nullptr;
    }
    size_t argCnt = 2;
    napi_value args[2] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "Drawable", "---test napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);
    ArkUI_NativeNodeAPI_1* nodeApi = GetNodeApi();
    if (nodeApi != nullptr) {
        if (nodeApi->createNode != nullptr && nodeApi->addChild != nullptr) {
            ArkUI_NodeHandle scrollNode = GetMainPageSroll();
            napi_value mapArrayId = AddPixelMapArray(env, info, scrollNode);
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle, scrollNode);
            return mapArrayId;
        }
    }
    return nullptr;
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
        {"createNodePage", nullptr, CreateNodePage, nullptr, nullptr, nullptr, napi_default, nullptr},
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
