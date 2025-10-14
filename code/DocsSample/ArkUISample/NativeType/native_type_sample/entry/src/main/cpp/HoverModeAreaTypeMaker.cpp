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

#include "HoverModeAreaTypeMaker.h"
#include "baseUtils.h"

namespace ConstIde {
    const uint32_t COLOR_GREEN = 0xFF00FF00;
    const uint32_t COLOR_BLUE = 0xFF0000FF;
    const uint32_t COLOR_YELLOW = 0xFFFFFF00;
    const uint32_t COLOR_WHITE = 0xFFFFFFFF;
    const uint32_t COLOR_PINK = 0xFFFFC0CB;
    const uint32_t PARAM_10 = 10;
    const uint32_t PARAM_240 = 240;
}  // namespace ConstIde

// 设置对话框样式属性
static void SetDialogStyles(ArkUI_NativeDialogAPI_3 *dialogAPI3, ArkUI_NativeDialogHandle customDialog,
                            ArkUI_NodeHandle column)
{
    // 设置背景色
    int32_t ret = dialogAPI3->nativeDialogAPI1.setBackgroundColor(customDialog, ConstIde::COLOR_WHITE);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                     "SetDialogStyles setBackgroundColor failed, ret = %{public}d ", ret);
    }

    // 设置边框
    ret = dialogAPI3->setBorderColor(customDialog, ConstIde::COLOR_GREEN, ConstIde::COLOR_BLUE, ConstIde::COLOR_PINK,
                                     ConstIde::COLOR_YELLOW);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                     "SetDialogStyles setBorderColor failed, ret = %{public}d ", ret);
    }

    ret = dialogAPI3->setBorderWidth(customDialog, ConstIde::PARAM_10, ConstIde::PARAM_10, ConstIde::PARAM_10,
                                     ConstIde::PARAM_10, ARKUI_LENGTH_METRIC_UNIT_PX);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                     "SetDialogStyles setBorderWidth failed, ret = %{public}d ", ret);
    }

    // 设置尺寸
    ret = dialogAPI3->setWidth(customDialog, ConstIde::PARAM_240, ARKUI_LENGTH_METRIC_UNIT_VP);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                     "SetDialogStyles setWidth failed, ret = %{public}d ", ret);
    }

    ret = dialogAPI3->setHeight(customDialog, ConstIde::PARAM_240, ARKUI_LENGTH_METRIC_UNIT_VP);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                     "SetDialogStyles setHeight failed, ret = %{public}d ", ret);
    }
    // 设置对话框内容
    ret = dialogAPI3->nativeDialogAPI1.setContent(customDialog, column);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                     "SetDialogStyles setContent failed, ret = %{public}d ", ret);
    }
}

// 设置对话框悬停属性
static void SetDialogInteractionProperties(ArkUI_NativeDialogAPI_3 *dialogAPI3, ArkUI_NativeDialogHandle customDialog,
                                           ArkUI_HoverModeAreaType hoverModeAreaType)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                 "SetDialogInteractionProperties hoverModeAreaType = %{public}d ", hoverModeAreaType);
    // 设置弹窗是否响应悬停态
    int32_t ret = dialogAPI3->enableHoverMode(customDialog, true);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                     "SetDialogInteractionProperties enableHoverMode failed, ret = %{public}d ", ret);
    }

    // 设置悬停态下弹窗默认展示区域
    ret = dialogAPI3->setHoverModeArea(customDialog, hoverModeAreaType);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                     "SetDialogInteractionProperties setHoverModeArea failed, ret = %{public}d ", ret);
    }
}

ArkUI_NodeHandle HoverModeAreaTypeMaker::SetHoverModeAreaType(int32_t type)
{
    // 创建对话框内容
    auto column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);

    // 创建对话框
    ArkUI_NativeDialogAPI_3 *dialogAPI3 = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_DIALOG, ArkUI_NativeDialogAPI_3, dialogAPI3);
    auto customDialog = dialogAPI3->nativeDialogAPI1.create();

    // 设置各种样式
    SetDialogStyles(dialogAPI3, customDialog, column);
    // 设置悬停位置
    ArkUI_HoverModeAreaType hoverModeAreaType = static_cast<ArkUI_HoverModeAreaType>(type);
    SetDialogInteractionProperties(dialogAPI3, customDialog, hoverModeAreaType);

    // 显示对话框
    int32_t ret = dialogAPI3->nativeDialogAPI1.show(customDialog, true);
    if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TypeSampleTest",
                     "CreateHoverModeAreaTypePage show failed, ret = %{public}d ", ret);
    }
    return column;
}