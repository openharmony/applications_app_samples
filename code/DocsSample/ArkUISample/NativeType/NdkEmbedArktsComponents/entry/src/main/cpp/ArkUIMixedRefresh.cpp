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
// [Start arkui_mixed_refresh]
// ArkUIMixedRefresh.cpp

#include "ArkUIMixedRefresh.h"
#include <hilog/log.h>

namespace NativeModule {
namespace {
napi_env g_env;
napi_ref g_createRefresh;
napi_ref g_updateRefresh;
const int REFRESH_OFFSET_INDEX0 = 0;
const int REFRESH_OFFSET_INDEX1 = 1;
const int REFRESH_OFFSET_INDEX2 = 2;
const int REFRESH_OFFSET_INDEX3 = 3;
const int REFRESH_OFFSET_INDEX4 = 4;
const int REFRESH_OFFSET_INDEX5 = 5;
const int REFRESH_OFFSET_INDEX6 = 6;
const int REFRESH_OFFSET_INDEX7 = 7;
} // namespace

void ArkUIMixedRefresh::Attribute2Descriptor(const NativeRefreshAttribute &attribute, napi_property_descriptor *desc)
{
    if (attribute.width) {
        napi_value width;
        napi_create_double(g_env, attribute.width.value(), &width);
        desc[REFRESH_OFFSET_INDEX0].value = width;
    }
    if (attribute.height) {
        napi_value height;
        napi_create_double(g_env, attribute.height.value(), &height);
        desc[REFRESH_OFFSET_INDEX1].value = height;
    }
    if (attribute.backgroundColor) {
        napi_value backgroundColor;
        napi_create_uint32(g_env, attribute.backgroundColor.value(), &backgroundColor);
        desc[REFRESH_OFFSET_INDEX2].value = backgroundColor;
    }
    if (attribute.pullToRefresh) {
        napi_value pullToRefresh;
        napi_create_int32(g_env, attribute.pullToRefresh.value(), &pullToRefresh);
        desc[REFRESH_OFFSET_INDEX3].value = pullToRefresh;
    }
    if (attribute.isRefreshing) {
        napi_value isRefreshing;
        napi_create_int32(g_env, attribute.isRefreshing.value(), &isRefreshing);
        desc[REFRESH_OFFSET_INDEX4].value = isRefreshing;
    }
    if (attribute.refreshOffset) {
        napi_value refreshOffset;
        napi_create_double(g_env, attribute.refreshOffset.value(), &refreshOffset);
        desc[REFRESH_OFFSET_INDEX5].value = refreshOffset;
    }
    if (attribute.onRefreshing) {
        OH_LOG_INFO(LOG_APP, "onRefreshing start");
        desc[REFRESH_OFFSET_INDEX6].method = [](napi_env env, napi_callback_info info) -> napi_value {
            OH_LOG_INFO(LOG_APP, "onRefreshing callback");
            size_t argc = 0;
            napi_value args[0];
            void *data;
            napi_get_cb_info(env, info, &argc, args, nullptr, &data);
            auto refresh = reinterpret_cast<ArkUIMixedRefresh *>(data);
            if (refresh && refresh->attribute_.onRefreshing) {
                refresh->attribute_.onRefreshing();
            }
            return nullptr;
        };
    }
}

// 使用Napi接口创建与ArkTS侧交互的数据结构，用于Refresh组件的创建和更新。
napi_value ArkUIMixedRefresh::CreateRefreshAttribute(const NativeRefreshAttribute &attribute, void *userData)
{
    napi_property_descriptor desc[] = {
        {"width", nullptr, nullptr, nullptr, nullptr, nullptr, napi_default, userData},
        {"height", nullptr, nullptr, nullptr, nullptr, nullptr, napi_default, userData},
        {"backgroundColor", nullptr, nullptr, nullptr, nullptr, nullptr, napi_default, userData},
        {"pullToRefresh", nullptr, nullptr, nullptr, nullptr, nullptr, napi_default, userData},
        {"isRefreshing", nullptr, nullptr, nullptr, nullptr, nullptr, napi_default, userData},
        {"refreshOffset", nullptr, nullptr, nullptr, nullptr, nullptr, napi_default, userData},
        {"onRefreshing", nullptr, nullptr, nullptr, nullptr, nullptr, napi_default, userData},
        {"onOffsetChange", nullptr, nullptr, nullptr, nullptr, nullptr, napi_default, userData},
    };
    Attribute2Descriptor(attribute, desc);
    if (attribute.onOffsetChange) {
        OH_LOG_INFO(LOG_APP, "onOffsetChange start");
        desc[REFRESH_OFFSET_INDEX7].method = [](napi_env env, napi_callback_info info) -> napi_value {
            OH_LOG_INFO(LOG_APP, "onOffsetChange callback");
            size_t argc = 1;
            napi_value args[1] = {nullptr};
            void *data;
            napi_get_cb_info(env, info, &argc, args, nullptr, &data);
            double offset = 0.0;
            napi_get_value_double(env, args[0], &offset);
            auto refresh = reinterpret_cast<ArkUIMixedRefresh *>(data);
            if (refresh && refresh->attribute_.onOffsetChange) {
                refresh->attribute_.onOffsetChange(offset);
            }
            return nullptr;
        };
    }
    napi_value refreshAttribute = nullptr;
    auto result = napi_create_object_with_properties(g_env, &refreshAttribute, sizeof(desc) / sizeof(desc[0]), desc);
    if (result != napi_ok) {
        return nullptr;
    }
    return refreshAttribute;
}

// 创建ArkTS侧的组件并保存在Native侧的封装对象中。
const std::shared_ptr<ArkUIMixedRefresh> ArkUIMixedRefresh::Create(const NativeRefreshAttribute &attribute)
{
    napi_handle_scope scope;
    napi_open_handle_scope(g_env, &scope);
    auto refresh = std::make_shared<ArkUIMixedRefresh>();
    auto refreshAttribute = CreateRefreshAttribute(attribute, refresh.get());
    if (refreshAttribute == nullptr) {
        napi_close_handle_scope(g_env, scope);
        return nullptr;
    }
    napi_value result = nullptr;
    napi_value argv[1] = {refreshAttribute};
    napi_value createRefresh = nullptr;
    napi_get_reference_value(g_env, g_createRefresh, &createRefresh);
    // 调用ArkTS的Create函数创建ArkTS的ComponentContent。
    napi_call_function(g_env, nullptr, createRefresh, 1, argv, &result);

    // 获取ArkTS的Refresh组件。
    napi_value componentContent = nullptr;
    napi_get_named_property(g_env, result, "content", &componentContent);
    ArkUI_NodeHandle handle;
    OH_ArkUI_GetNodeHandleFromNapiValue(g_env, componentContent, &handle);
    // 获取ArkTS的Refresh组件的子组件插槽。
    napi_value nodeContent = nullptr;
    napi_get_named_property(g_env, result, "childSlot", &nodeContent);
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(g_env, nodeContent, &contentHandle);
    // 保存ArkTS的ComponentContent用于防止ArkTS侧对象释放以及后续的更新。
    napi_ref componentContentRef;
    napi_create_reference(g_env, componentContent, 1, &componentContentRef);
    // 保存ArkTS的NodeContent用于防止ArkTS侧对象释放以及后续的更新。
    napi_ref nodeContentRef;
    napi_create_reference(g_env, nodeContent, 1, &nodeContentRef);
    // 更新Refresh组件相关参数。
    refresh->handle_ = handle;
    refresh->env_ = g_env;
    refresh->componentContent_ = componentContentRef;
    refresh->nodeContent_ = nodeContentRef;
    refresh->contentHandle_ = contentHandle;
    refresh->attribute_ = attribute;
    return refresh;
}
// 更新函数实现。
void ArkUIMixedRefresh::FlushMixedModeCmd()
{
    napi_handle_scope scope;
    napi_open_handle_scope(g_env, &scope);
    // 创建调用ArkTS接口入参。
    auto refreshAttribute = CreateRefreshAttribute(attribute_, this);
    if (refreshAttribute == nullptr) {
        napi_close_handle_scope(g_env, scope);
        return;
    }
    // 获取更新接口的剩余两个接口参数。
    napi_value componentContent = nullptr;
    napi_get_reference_value(g_env, componentContent_, &componentContent);
    napi_value nodeContent = nullptr;
    napi_get_reference_value(g_env, nodeContent_, &nodeContent);

    napi_value argv[3] = {componentContent, nodeContent, refreshAttribute};
    napi_value updateRefresh = nullptr;
    napi_get_reference_value(g_env, g_updateRefresh, &updateRefresh);
    // 调用ArkTS的Update函数进行更新。
    napi_value result = nullptr;
    napi_call_function(g_env, nullptr, updateRefresh, sizeof(argv) / sizeof(argv[0]), argv, &result);
}

napi_value ArkUIMixedRefresh::RegisterCreateRefresh(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    g_env = env;
    napi_ref refer;
    napi_create_reference(env, args[0], 1, &refer);

    g_createRefresh = refer;
    return nullptr;
}

napi_value ArkUIMixedRefresh::RegisterUpdateRefresh(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    g_env = env;
    napi_ref refer;
    napi_create_reference(env, args[0], 1, &refer);

    g_updateRefresh = refer;
    return nullptr;
}

} // namespace NativeModule
// [End arkui_mixed_refresh]