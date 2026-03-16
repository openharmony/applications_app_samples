/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#ifndef MYAPPLICATION_ARKUIANIMATE_H
#define MYAPPLICATION_ARKUIANIMATE_H
#include "EntryModule.h"
#include "arkui/native_animate.h"
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <string>

namespace NativeModule {
constexpr int NUM_100 = 100;
constexpr int NUM_120 = 120;
constexpr int NUM_150 = 150;
constexpr int NUM_200 = 200;
constexpr int NUM_250 = 250;
constexpr int NUM_300 = 300;
constexpr int NUM_400 = 400;
constexpr int NUM_500 = 500;
constexpr int NUM_1000 = 1000;
constexpr int NUM_1500 = 1500;
constexpr int NUM_2000 = 2000;
constexpr int NUM_0 = 0;
constexpr int NUM_1 = 1;
constexpr int NUM_2 = 2;
constexpr int NUM_3 = 3;
constexpr int NUM_4 = 4;
constexpr int NUM_5 = 5;
constexpr int NUM_6 = 6;
constexpr int NUM_7 = 7;
constexpr int NUM_8 = 8;
constexpr int NUM_9 = 9;
constexpr int NUM_10 = 10;
constexpr int NUM_20 = 20;
constexpr int NUM_30 = 30;
constexpr int NUM_40 = 40;
constexpr int NUM_50 = 50;
constexpr int NUM_60 = 60;
constexpr int NUM_80 = 80;

void InitNavigationNode(ArkUI_NodeHandle handle, const char* pageName)
{
    auto nativeEntry = NativeEntry::GetInstance();
    auto button = nativeEntry->AddButton(handle, pageName);
    nativeEntry->InitNavDestinationState(button);
}

void InitRouterNode(ArkUI_NodeHandle handle)
{
    auto nativeEntry = NativeEntry::GetInstance();
    auto button = nativeEntry->AddButton(handle, "getRouterName");
    nativeEntry->InitPageName(button);
    auto indexButton = nativeEntry->AddButton(handle, "getRouterIndex");
    nativeEntry->InitPageIndex(indexButton);
}

void CreateInitNode(napi_env env, ArkUI_NodeHandle node)
{
    auto nativeEntry = NativeEntry::GetInstance();
    auto nativeApi = nativeEntry->GetNativeNodeApi();
    auto column = nativeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue nums[] = { { .i32 = ArkUI_FlexAlignment::ARKUI_FLEX_ALIGNMENT_SPACE_EVENLY } };
    ArkUI_AttributeItem item = { .value = nums, .size = 1};
    nativeApi->setAttribute(column, NODE_COLUMN_JUSTIFY_CONTENT, &item);
    // 设置组件宽度，NUM_300
    nativeEntry->SetWidth(column, NUM_300);
    // 设置组件高度，NUM_250 = 250
    nativeEntry->SetHeight(column, NUM_250);
    // 获取页面名称
    char pageName[NUM_50];
    int32_t bufferLen = 0;
    OH_ArkUI_GetNavDestinationName(node, pageName, NUM_50, &bufferLen);
    // 获取页面跳转参数
    napi_value param = OH_ArkUI_GetNavDestinationParam(node);
    napi_value nameVal = nullptr;
    napi_get_named_property(env, param, "name", &nameVal);
    size_t len = 0;
    napi_get_value_string_utf8(env, nameVal, nullptr, 0, &len);
    std::unique_ptr<char[]> viewName = std::make_unique<char[]>(len + 1);
    napi_get_value_string_utf8(env, nameVal, viewName.get(), len + 1, &len);
    ArkUI_NodeHandle targetNode = nullptr;
    std::string view = viewName.get();
    if (view == "QueryNavigation") {
        InitNavigationNode(column, pageName);
    } else if (view == "QueryRouter") {
        InitRouterNode(column);
    }
    nativeApi->addChild(node, column);
}

void CreateQueryRootNode(napi_env env, ArkUI_NodeContentHandle handle)
{
    auto nativeEntry = NativeEntry::GetInstance();
    auto nativeApi = nativeEntry->GetNativeNodeApi();
    auto column = nativeApi->createNode(ARKUI_NODE_COLUMN);
    nativeEntry->SetHeight(column, NUM_1500);
    nativeEntry->SetWidth(column, NUM_300);
    OH_ArkUI_NodeContent_AddNode(handle, column);
    CreateInitNode(env, column);
}
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIANIMATE_H