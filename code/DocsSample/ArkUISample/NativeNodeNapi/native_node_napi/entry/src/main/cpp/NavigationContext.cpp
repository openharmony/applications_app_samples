/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#include <cstring>
#include <algorithm>
#include "NavigationContext.h"

constexpr int32_t BUFFER_LEN = 50;
constexpr int32_t SMALL_BUFFER_LEN = 1;
constexpr int32_t INIT_VAL = -10;

void NavigationContext::NavigationInfoTest1(ArkUI_NodeHandle node)
{
    char buffer[BUFFER_LEN];
    int32_t resLen = INIT_VAL;
    int32_t ret = INIT_VAL;
    // case 1
    ret = OH_ArkUI_GetNavigationId(node, buffer, BUFFER_LEN, &resLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "NavigationId %{public}s , ret: %{public}d, writeLen: %{public}d", buffer, ret, resLen);
    std::fill(std::begin(buffer), std::end(buffer), '\0');
    resLen = INIT_VAL;
    ret = INIT_VAL;
    // case 2
    ret = OH_ArkUI_GetNavDestinationName(node, buffer, BUFFER_LEN, &resLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "NavDestinationName %{public}s , ret: %{public}d, writeLen: %{public}d", buffer, ret, resLen);
    std::fill(std::begin(buffer), std::end(buffer), '\0');
    resLen = INIT_VAL;
    ret = INIT_VAL;
    // case 3
    int32_t stackLen = -100;
    ret = OH_ArkUI_GetNavStackLength(node, &stackLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "OH_ArkUI_GetNavStackLength ret: %{public}d, stackLen: %{public}d", ret, stackLen);
    std::fill(std::begin(buffer), std::end(buffer), '\0');
    resLen = INIT_VAL;
    ret = INIT_VAL;
    // case 4
    ret = OH_ArkUI_GetNavDestinationNameByIndex(node, 0, buffer, BUFFER_LEN, &resLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "OH_ArkUI_GetNavDestinationNameByIndex %{public}s , ret: %{public}d, writeLen: %{public}d", buffer,
                 ret, resLen);
    std::fill(std::begin(buffer), std::end(buffer), '\0');
    resLen = INIT_VAL;
    ret = INIT_VAL;
}

void NavigationContext::NavigationInfoTest2(ArkUI_NodeHandle node)
{
    char buffer[BUFFER_LEN];
    int32_t resLen = INIT_VAL;
    int32_t ret = INIT_VAL;
    // case 5
    ret = OH_ArkUI_GetNavDestinationId(node, buffer, BUFFER_LEN, &resLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "NavDestinationId %{public}s , ret: %{public}d, writeLen: %{public}d", buffer, ret, resLen);
    std::fill(std::begin(buffer), std::end(buffer), '\0');
    resLen = INIT_VAL;
    ret = INIT_VAL;
    // case 6
    ArkUI_NavDestinationState navDesState;
    ret = OH_ArkUI_GetNavDestinationState(node, &navDesState);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "OH_ArkUI_GetNavDestinationState  ret: %{public}d, state: %{public}d", ret, navDesState);
    ret = INIT_VAL;
    // case 7
    int32_t index;
    ret = OH_ArkUI_GetNavDestinationIndex(node, &index);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "OH_ArkUI_GetNavDestinationIndex  index: %{public}d  ret: %{public}d", index, ret);
    // case 8
    napi_value param = nullptr;
    param = OH_ArkUI_GetNavDestinationParam(node);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case", "OH_ArkUI_GetNavDestinationParam  isEmpty: %{public}d",
                 (param == nullptr));
}

void NavigationContext::RouterPageInfoTest(ArkUI_NodeHandle node)
{
    char buffer[BUFFER_LEN];
    int32_t resLen = INIT_VAL;
    int32_t ret = INIT_VAL;
    // case 1
    int32_t index;
    ret = OH_ArkUI_GetRouterPageIndex(node, &index);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "OH_ArkUI_GetRouterPageIndex index: %{public}d ret: %{public}d", index, ret);
    // case 2
    ret = OH_ArkUI_GetRouterPageName(node, buffer, BUFFER_LEN, &resLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "RouterPageName  %{public}s, ret: %{public}d, writeLen: %{public}d", buffer, ret, resLen);
    std::fill(std::begin(buffer), std::end(buffer), '\0');
    resLen = INIT_VAL;
    ret = INIT_VAL;
    // case 3
    ret = OH_ArkUI_GetRouterPagePath(node, buffer, BUFFER_LEN, &resLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "RouterPagePath  %{public}s, ret: %{public}d, writeLen: %{public}d", buffer, ret, resLen);
    std::fill(std::begin(buffer), std::end(buffer), '\0');
    resLen = INIT_VAL;
    ret = INIT_VAL;
    // case 4
    ArkUI_RouterPageState pageState;
    ret = OH_ArkUI_GetRouterPageState(node, &pageState);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "OH_ArkUI_GetNavDestinationState  ret: %{public}d, state: %{public}d", ret, pageState);
    ret = INIT_VAL;
    // case 5
    ret = OH_ArkUI_GetRouterPageId(node, buffer, BUFFER_LEN, &resLen);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "case",
                 "GetRouterPageId  %{public}s, ret: %{public}d, writeLen: %{public}d", buffer, ret, resLen);
    std::fill(std::begin(buffer), std::end(buffer), '\0');
    resLen = INIT_VAL;
    ret = INIT_VAL;
}