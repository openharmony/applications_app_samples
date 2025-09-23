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

#ifndef MYAPPLICATION_ARKUIVISUALEFFECTSNODE_H
#define MYAPPLICATION_ARKUIVISUALEFFECTSNODE_H
#include "ArkUIColumnNode.h"
#include "ArkUITextNode.h"
#include <hilog/log.h>

namespace NativeModule {
std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsScale()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeCustomShadow = std::make_shared<ArkUITextNode>();
    textNodeCustomShadow->SetTextContent("ArkUI_ShadowType");
    textNodeCustomShadow->SetWidth(MIDDLE_LENGTH);
    textNodeCustomShadow->SetHeight(SMALL_LENGTH);
    auto columnCustomShadow = std::make_shared<ArkUIColumnNode>();
    columnCustomShadow->SetWidth(MIDDLE_LENGTH);
    columnCustomShadow->SetHeight(MIDDLE_LENGTH);
    columnCustomShadow->SetBackgroundColor(COLOR_PINK);
    columnCustomShadow->SetCustomShadow();
    column->AddChild(textNodeCustomShadow);
    column->AddChild(columnCustomShadow);
    
    auto textNodeShadow = std::make_shared<ArkUITextNode>();
    textNodeShadow->SetTextContent("ArkUI_ShadowStyle");
    textNodeShadow->SetWidth(MIDDLE_LENGTH);
    textNodeShadow->SetHeight(SMALL_LENGTH);
    auto columnShadow = std::make_shared<ArkUIColumnNode>();
    columnShadow->SetWidth(MIDDLE_LENGTH);
    columnShadow->SetHeight(MIDDLE_LENGTH);
    columnShadow->SetBackgroundColor(COLOR_PINK);
    columnShadow->SetShadow(ARKUI_SHADOW_STYLE_OUTER_DEFAULT_LG);
    column->AddChild(textNodeShadow);
    column->AddChild(columnShadow);
    
    auto textNodeMask = std::make_shared<ArkUITextNode>();
    textNodeMask->SetTextContent("ArkUI_MaskType");
    textNodeMask->SetWidth(MIDDLE_LENGTH);
    textNodeMask->SetHeight(SMALL_LENGTH);
    auto columnMask = std::make_shared<ArkUIColumnNode>();
    columnMask->SetWidth(MIDDLE_LENGTH);
    columnMask->SetHeight(MIDDLE_LENGTH);
    columnMask->SetBackgroundColor(COLOR_PINK);
    columnMask->SetMask();
    column->AddChild(textNodeMask);
    column->AddChild(columnMask);

    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsBlur()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeBlurStyle = std::make_shared<ArkUITextNode>();
    textNodeBlurStyle->SetTextContent("ArkUI_AdaptiveColor ArkUI_BlurStyle");
    textNodeBlurStyle->SetWidth(MIDDLE_LENGTH);
    textNodeBlurStyle->SetHeight(SMALL_LENGTH);
    auto columnBlurStyle = std::make_shared<ArkUIColumnNode>();
    columnBlurStyle->SetWidth(MIDDLE_LENGTH);
    columnBlurStyle->SetHeight(MIDDLE_LENGTH);
    columnBlurStyle->SetBackgroundColor(COLOR_PINK);
    columnBlurStyle->SetBackgroundBlurStyle(ARKUI_BLUR_STYLE_THICK);
    column->AddChild(textNodeBlurStyle);
    column->AddChild(columnBlurStyle);

    auto textNodeCircleShape = std::make_shared<ArkUITextNode>();
    textNodeCircleShape->SetTextContent("ArkUI_ClipType");
    textNodeCircleShape->SetWidth(MIDDLE_LENGTH);
    textNodeCircleShape->SetHeight(SMALL_LENGTH);
    auto columnCircleShape = std::make_shared<ArkUIColumnNode>();
    columnCircleShape->SetWidth(MIDDLE_LENGTH);
    columnCircleShape->SetHeight(MIDDLE_LENGTH);
    columnCircleShape->SetBackgroundColor(COLOR_PINK);
    columnCircleShape->SetCircleShape(ARKUI_CLIP_TYPE_CIRCLE, MIDDLE_LENGTH, MIDDLE_LENGTH);
    column->AddChild(textNodeCircleShape);
    column->AddChild(columnCircleShape);
 
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsShape()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeLinearGradient = std::make_shared<ArkUITextNode>();
    textNodeLinearGradient->SetTextContent("ArkUI_ColorStop ArkUI_LinearGradientDirection");
    textNodeLinearGradient->SetWidth(MIDDLE_LENGTH);
    textNodeLinearGradient->SetHeight(SMALL_LENGTH);
    auto columnLinearGradient = std::make_shared<ArkUIColumnNode>();
    columnLinearGradient->SetWidth(NUMBER_100);
    columnLinearGradient->SetHeight(NUMBER_100);
    columnLinearGradient->SetLinearGradient(NUMBER_90, ARKUI_LINEAR_GRADIENT_DIRECTION_CUSTOM, NUMBER_0);
    column->AddChild(textNodeLinearGradient);
    column->AddChild(columnLinearGradient);

    return column;
}
} // namespace NativeModule

#endif