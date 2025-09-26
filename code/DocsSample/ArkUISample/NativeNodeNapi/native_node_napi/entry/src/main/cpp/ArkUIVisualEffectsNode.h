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
    auto textNodeTran = std::make_shared<ArkUITextNode>();
    textNodeTran->SetTextContent("translate");
    textNodeTran->SetWidth(MIDDLE_LENGTH);
    textNodeTran->SetHeight(SMALL_LENGTH);
    auto columnTran = std::make_shared<ArkUIColumnNode>();
    columnTran->SetWidth(SMALL_LENGTH);
    columnTran->SetHeight(SMALL_LENGTH);
    columnTran->SetBackgroundColor(COLOR_PINK);
    columnTran->SetTranslate(SMALL_LENGTH, NUMBER_0, NUMBER_0);
    
    auto textNodeScale = std::make_shared<ArkUITextNode>();
    textNodeScale->SetTextContent("scale");
    textNodeScale->SetWidth(MIDDLE_LENGTH);
    textNodeScale->SetHeight(SMALL_LENGTH);
    auto columnScale = std::make_shared<ArkUIColumnNode>();
    columnScale->SetWidth(SMALL_LENGTH);
    columnScale->SetHeight(SMALL_LENGTH);
    columnScale->SetBackgroundColor(COLOR_PINK);
    columnScale->SetScale(NUMBER_2, NUMBER_05);

    auto textNodeRotate = std::make_shared<ArkUITextNode>();
    textNodeRotate->SetTextContent("rotate");
    textNodeRotate->SetWidth(SMALL_LENGTH);
    textNodeRotate->SetHeight(SMALL_LENGTH);
    auto columnRotate = std::make_shared<ArkUIColumnNode>();
    columnRotate->SetWidth(SMALL_LENGTH);
    columnRotate->SetHeight(SMALL_LENGTH);
    columnRotate->SetBackgroundColor(COLOR_PINK);
    columnRotate->SetRotate(NUMBER_0, NUMBER_0, NUMBER_1, LARGE_LENGTH, NUMBER_0);
    
    column->AddChild(textNodeTran);
    column->AddChild(columnTran);
    column->AddChild(textNodeScale);
    column->AddChild(columnScale);
    column->AddChild(textNodeRotate);
    column->AddChild(columnRotate);

    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsBlur()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeBrightness = std::make_shared<ArkUITextNode>();
    textNodeBrightness->SetTextContent("Brightness");
    textNodeBrightness->SetWidth(MIDDLE_LENGTH);
    textNodeBrightness->SetHeight(SMALL_LENGTH);
    auto columnBrightness = std::make_shared<ArkUIColumnNode>();
    columnBrightness->SetWidth(NUMBER_100);
    columnBrightness->SetHeight(NUMBER_100);
    columnBrightness->SetBackgroundColor(COLOR_PINK);
    columnBrightness->SetBrightness(NUMBER_05);
    column->AddChild(textNodeBrightness);
    column->AddChild(columnBrightness);

    auto textNodeSaturate = std::make_shared<ArkUITextNode>();
    textNodeSaturate->SetTextContent("saturate");
    textNodeSaturate->SetWidth(MIDDLE_LENGTH);
    textNodeSaturate->SetHeight(SMALL_LENGTH);
    auto columnSaturate = std::make_shared<ArkUIColumnNode>();
    columnSaturate->SetWidth(NUMBER_100);
    columnSaturate->SetHeight(NUMBER_100);
    columnSaturate->SetBackgroundColor(COLOR_PINK);
    columnSaturate->SetSaturate(NUMBER_30);
    column->AddChild(textNodeSaturate);
    column->AddChild(columnSaturate);

    auto textNodeBlur = std::make_shared<ArkUITextNode>();
    textNodeBlur->SetTextContent("blur");
    textNodeBlur->SetWidth(MIDDLE_LENGTH);
    textNodeBlur->SetHeight(SMALL_LENGTH);
    
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextContent("NODE_BLUR");
    text->SetWidth(MIDDLE_LENGTH);
    text->SetHeight(NUMBER_100);
    text->SetBackgroundColor(COLOR_PINK);
    text->SetBlur(NUMBER_10);
    column->AddChild(textNodeBlur);
    column->AddChild(text);
 
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsShape()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeLinearGradient = std::make_shared<ArkUITextNode>();
    textNodeLinearGradient->SetTextContent("linearGradient");
    textNodeLinearGradient->SetWidth(MIDDLE_LENGTH);
    textNodeLinearGradient->SetHeight(SMALL_LENGTH);
    auto columnLinearGradient = std::make_shared<ArkUIColumnNode>();
    columnLinearGradient->SetWidth(NUMBER_100);
    columnLinearGradient->SetHeight(NUMBER_100);
    columnLinearGradient->SetLinearGradient(NUMBER_90, ARKUI_LINEAR_GRADIENT_DIRECTION_CUSTOM, NUMBER_0);
    column->AddChild(textNodeLinearGradient);
    column->AddChild(columnLinearGradient);
    
    auto textNodeOpacity = std::make_shared<ArkUITextNode>();
    textNodeOpacity->SetTextContent("opacity");
    textNodeOpacity->SetWidth(MIDDLE_LENGTH);
    textNodeOpacity->SetHeight(SMALL_LENGTH);
    auto columnOpacity = std::make_shared<ArkUIColumnNode>();
    columnOpacity->SetWidth(NUMBER_100);
    columnOpacity->SetHeight(NUMBER_100);
    columnOpacity->SetBackgroundColor(COLOR_PINK);
    columnOpacity->SetOpacity(NUMBER_03);
    column->AddChild(textNodeOpacity);
    column->AddChild(columnOpacity);
    
    auto textNodeClip = std::make_shared<ArkUITextNode>();
    textNodeClip->SetTextContent("clip");
    textNodeClip->SetWidth(MIDDLE_LENGTH);
    textNodeClip->SetHeight(SMALL_LENGTH);
    auto columnInside = std::make_shared<ArkUIColumnNode>();
    columnInside->SetWidth(NUMBER_100);
    columnInside->SetHeight(NUMBER_100);
    columnInside->SetBackgroundColor(COLOR_PINK);
    columnInside->SetBorderRadius(NUMBER_20);
    auto columnClip = std::make_shared<ArkUIColumnNode>();
    columnClip->SetBorderRadius(NUMBER_20);
    columnClip->SetClip(NUMBER_1);
    columnClip->AddChild(columnInside);
    column->AddChild(textNodeClip);
    column->AddChild(columnClip);
    
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsShadow()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeCircleShape = std::make_shared<ArkUITextNode>();
    textNodeCircleShape->SetTextContent("CircleShape");
    textNodeCircleShape->SetWidth(MIDDLE_LENGTH);
    textNodeCircleShape->SetHeight(SMALL_LENGTH);
    auto columnCircleShape = std::make_shared<ArkUIColumnNode>();
    columnCircleShape->SetWidth(MIDDLE_LENGTH);
    columnCircleShape->SetHeight(MIDDLE_LENGTH);
    columnCircleShape->SetBackgroundColor(COLOR_PINK);
    columnCircleShape->SetCircleShape(ARKUI_CLIP_TYPE_CIRCLE, MIDDLE_LENGTH, MIDDLE_LENGTH);
    column->AddChild(textNodeCircleShape);
    column->AddChild(columnCircleShape);
    
    auto textNodeTransform = std::make_shared<ArkUITextNode>();
    textNodeTransform->SetTextContent("Transform");
    textNodeTransform->SetWidth(MIDDLE_LENGTH);
    textNodeTransform->SetHeight(SMALL_LENGTH);
    auto columnTransform = std::make_shared<ArkUIColumnNode>();
    columnTransform->SetWidth(MIDDLE_LENGTH);
    columnTransform->SetHeight(MIDDLE_LENGTH);
    columnTransform->SetBackgroundColor(COLOR_PINK);
    columnTransform->SetTransform();
    column->AddChild(textNodeTransform);
    column->AddChild(columnTransform);

    auto textNodeShadow = std::make_shared<ArkUITextNode>();
    textNodeShadow->SetTextContent("Shadow");
    textNodeShadow->SetWidth(MIDDLE_LENGTH);
    textNodeShadow->SetHeight(SMALL_LENGTH);
    auto columnShadow = std::make_shared<ArkUIColumnNode>();
    columnShadow->SetWidth(MIDDLE_LENGTH);
    columnShadow->SetHeight(MIDDLE_LENGTH);
    columnShadow->SetBackgroundColor(COLOR_PINK);
    columnShadow->SetShadow(ARKUI_SHADOW_STYLE_OUTER_DEFAULT_LG);
    column->AddChild(textNodeShadow);
    column->AddChild(columnShadow);
    
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsSepia()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeSweepGradient = std::make_shared<ArkUITextNode>();
    textNodeSweepGradient->SetTextContent("sweepGradient");
    textNodeSweepGradient->SetWidth(MIDDLE_LENGTH);
    textNodeSweepGradient->SetHeight(SMALL_LENGTH);
    auto columnSweepGradient = std::make_shared<ArkUIColumnNode>();
    columnSweepGradient->SetWidth(MIDDLE_LENGTH);
    columnSweepGradient->SetHeight(MIDDLE_LENGTH);
    columnSweepGradient->SetBackgroundColor(COLOR_PINK);
    columnSweepGradient->SetSweepGradient();
    column->AddChild(textNodeSweepGradient);
    column->AddChild(columnSweepGradient);
    
    auto textNodeRadialGradient = std::make_shared<ArkUITextNode>();
    textNodeRadialGradient->SetTextContent("radialGradient");
    textNodeRadialGradient->SetWidth(MIDDLE_LENGTH);
    textNodeRadialGradient->SetHeight(SMALL_LENGTH);
    auto columnRadialGradient = std::make_shared<ArkUIColumnNode>();
    columnRadialGradient->SetWidth(MIDDLE_LENGTH);
    columnRadialGradient->SetHeight(MIDDLE_LENGTH);
    columnSweepGradient->SetBackgroundColor(COLOR_PINK);
    columnRadialGradient->SetRadialGradient();
    column->AddChild(textNodeRadialGradient);
    column->AddChild(columnRadialGradient);

    auto textNodeMask = std::make_shared<ArkUITextNode>();
    textNodeMask->SetTextContent("mask");
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

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsMask()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeGrayScale = std::make_shared<ArkUITextNode>();
    textNodeGrayScale->SetTextContent("GrayScale");
    textNodeGrayScale->SetWidth(MIDDLE_LENGTH);
    textNodeGrayScale->SetHeight(SMALL_LENGTH);
    auto columnGrayScale = std::make_shared<ArkUIColumnNode>();
    columnGrayScale->SetWidth(MIDDLE_LENGTH);
    columnGrayScale->SetHeight(MIDDLE_LENGTH);
    columnGrayScale->SetBackgroundColor(COLOR_PINK);
    columnGrayScale->SetGrayScale(NUMBER_05);
    column->AddChild(textNodeGrayScale);
    column->AddChild(columnGrayScale);
    
    auto textNodeInvert = std::make_shared<ArkUITextNode>();
    textNodeInvert->SetTextContent("Invert");
    textNodeInvert->SetWidth(MIDDLE_LENGTH);
    textNodeInvert->SetHeight(SMALL_LENGTH);
    auto columnInvert = std::make_shared<ArkUIColumnNode>();
    columnInvert->SetWidth(MIDDLE_LENGTH);
    columnInvert->SetHeight(MIDDLE_LENGTH);
    columnInvert->SetBackgroundColor(COLOR_PINK);
    columnInvert->SetInvert(NUMBER_05);
    column->AddChild(textNodeInvert);
    column->AddChild(columnInvert);
    
    auto textNodeSepia = std::make_shared<ArkUITextNode>();
    textNodeSepia->SetTextContent("Sepia");
    textNodeSepia->SetWidth(MIDDLE_LENGTH);
    textNodeSepia->SetHeight(SMALL_LENGTH);
    auto columnSepia = std::make_shared<ArkUIColumnNode>();
    columnSepia->SetWidth(MIDDLE_LENGTH);
    columnSepia->SetHeight(MIDDLE_LENGTH);
    columnSepia->SetBackgroundColor(COLOR_PINK);
    columnSepia->SetSepia(NUMBER_05);
    column->AddChild(textNodeSepia);
    column->AddChild(columnSepia);

    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsCont()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeContrast = std::make_shared<ArkUITextNode>();
    textNodeContrast->SetTextContent("Contrast");
    textNodeContrast->SetWidth(MIDDLE_LENGTH);
    textNodeContrast->SetHeight(SMALL_LENGTH);
    auto columnContrast = std::make_shared<ArkUIColumnNode>();
    columnContrast->SetWidth(MIDDLE_LENGTH);
    columnContrast->SetHeight(MIDDLE_LENGTH);
    columnContrast->SetBackgroundColor(COLOR_PINK);
    columnContrast->SetContrast(NUMBER_01);
    column->AddChild(textNodeContrast);
    column->AddChild(columnContrast);

    auto columBlank = std::make_shared<ArkUIColumnNode>();
    columBlank->SetHeight(NUMBER_20);
    column->AddChild(columBlank);
    
    auto textNodeForegroundColor = std::make_shared<ArkUITextNode>();
    textNodeForegroundColor->SetTextContent("ForegroundColor");
    textNodeForegroundColor->SetWidth(MIDDLE_LENGTH);
    textNodeForegroundColor->SetHeight(SMALL_LENGTH);
    textNodeForegroundColor->SetBackgroundColor(COLOR_PINK);
    textNodeForegroundColor->SetForegroundColor(COLOR_RED);
    column->AddChild(textNodeForegroundColor);

    auto textNodeMarkAnchor = std::make_shared<ArkUITextNode>();
    textNodeMarkAnchor->SetTextContent("MarkAnchor");
    textNodeMarkAnchor->SetWidth(MIDDLE_LENGTH);
    textNodeMarkAnchor->SetHeight(SMALL_LENGTH);
    auto columnMarkAnchor = std::make_shared<ArkUIColumnNode>();
    columnMarkAnchor->SetWidth(MIDDLE_LENGTH);
    columnMarkAnchor->SetHeight(MIDDLE_LENGTH);
    columnMarkAnchor->SetBackgroundColor(COLOR_PINK);
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("text");
    textNode->SetHeight(NUMBER_25);
    textNode->SetHeight(NUMBER_25);
    textNode->SetMarkAnchor(NUMBER_25, NUMBER_25);
    column->AddChild(textNodeMarkAnchor);
    column->AddChild(columnMarkAnchor);
    column->AddChild(textNode);
    
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsAngle()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeTranslateWithPercent = std::make_shared<ArkUITextNode>();
    textNodeTranslateWithPercent->SetTextContent("TranslateWithPercent");
    textNodeTranslateWithPercent->SetWidth(MIDDLE_LENGTH);
    textNodeTranslateWithPercent->SetHeight(SMALL_LENGTH);
    auto columnTranslateWithPercent = std::make_shared<ArkUIColumnNode>();
    columnTranslateWithPercent->SetWidth(MIDDLE_LENGTH);
    columnTranslateWithPercent->SetHeight(MIDDLE_LENGTH);
    columnTranslateWithPercent->SetBackgroundColor(COLOR_PINK);
    columnTranslateWithPercent->SetTranslateWithPercent(NUMBER_04, NUMBER_02, NUMBER_0);
    column->AddChild(textNodeTranslateWithPercent);
    column->AddChild(columnTranslateWithPercent);
    
    auto textNodeRotateAngle = std::make_shared<ArkUITextNode>();
    textNodeRotateAngle->SetTextContent("RotateAngle");
    textNodeRotateAngle->SetWidth(MIDDLE_LENGTH);
    textNodeRotateAngle->SetHeight(SMALL_LENGTH);
    auto columnRotateAngle = std::make_shared<ArkUIColumnNode>();
    columnRotateAngle->SetWidth(MIDDLE_LENGTH);
    columnRotateAngle->SetHeight(MIDDLE_LENGTH);
    columnRotateAngle->SetBackgroundColor(COLOR_PINK);
    columnRotateAngle->SetRotateAngle(NUMBER_45, NUMBER_45, NUMBER_0, NUMBER_0);
    column->AddChild(textNodeRotateAngle);
    column->AddChild(columnRotateAngle);

    auto textNodeCustomShadow = std::make_shared<ArkUITextNode>();
    textNodeCustomShadow->SetTextContent("CustomShadow");
    textNodeCustomShadow->SetWidth(MIDDLE_LENGTH);
    textNodeCustomShadow->SetHeight(SMALL_LENGTH);
    auto columnCustomShadow = std::make_shared<ArkUIColumnNode>();
    columnCustomShadow->SetWidth(MIDDLE_LENGTH);
    columnCustomShadow->SetHeight(MIDDLE_LENGTH);
    columnCustomShadow->SetBackgroundColor(COLOR_PINK);
    columnCustomShadow->SetCustomShadow();
    column->AddChild(textNodeCustomShadow);
    column->AddChild(columnCustomShadow);

    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsStyle()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeBlurStyle = std::make_shared<ArkUITextNode>();
    textNodeBlurStyle->SetTextContent("BackgroundBlurStyle");
    textNodeBlurStyle->SetWidth(MIDDLE_LENGTH);
    textNodeBlurStyle->SetHeight(SMALL_LENGTH);
    auto columnBlurStyle = std::make_shared<ArkUIColumnNode>();
    columnBlurStyle->SetWidth(MIDDLE_LENGTH);
    columnBlurStyle->SetHeight(MIDDLE_LENGTH);
    columnBlurStyle->SetBackgroundColor(COLOR_PINK);
    columnBlurStyle->SetBackgroundBlurStyle(ARKUI_BLUR_STYLE_THICK);
    column->AddChild(textNodeBlurStyle);
    column->AddChild(columnBlurStyle);
 
    auto textNodeForegroundBlurStyle = std::make_shared<ArkUITextNode>();
    textNodeForegroundBlurStyle->SetTextContent("ForegroundBlurStyle");
    textNodeForegroundBlurStyle->SetWidth(MIDDLE_LENGTH);
    textNodeForegroundBlurStyle->SetHeight(SMALL_LENGTH);
    auto columnTextNode = std::make_shared<ArkUITextNode>();
    columnTextNode->SetTextContent("厚材质模糊");
    columnTextNode->SetWidth(MIDDLE_LENGTH);
    columnTextNode->SetHeight(SMALL_LENGTH);
    columnTextNode->SetBackgroundColor(COLOR_PINK);
    columnTextNode->SetForegroundBlurStyle(ARKUI_BLUR_STYLE_THICK);
    column->AddChild(textNodeForegroundBlurStyle);
    column->AddChild(columnTextNode);

    auto textNodeColorBlend = std::make_shared<ArkUITextNode>();
    textNodeColorBlend->SetTextContent("ColorBlend");
    textNodeColorBlend->SetWidth(MIDDLE_LENGTH);
    textNodeColorBlend->SetHeight(SMALL_LENGTH);
    auto columnColorBlend = std::make_shared<ArkUIColumnNode>();
    columnColorBlend->SetWidth(MIDDLE_LENGTH);
    columnColorBlend->SetHeight(MIDDLE_LENGTH);
    columnColorBlend->SetBackgroundColor(COLOR_YELLOW);
    columnColorBlend->SetColorBlend(COLOR_RED);
    column->AddChild(textNodeColorBlend);
    column->AddChild(columnColorBlend);
    
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateVisualEffectsGroup()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeBackdropBlur = std::make_shared<ArkUITextNode>();
    textNodeBackdropBlur->SetTextContent("BackdropBlur");
    textNodeBackdropBlur->SetWidth(MIDDLE_LENGTH);
    textNodeBackdropBlur->SetHeight(SMALL_LENGTH);
    textNodeBackdropBlur->SetBackgroundColor(COLOR_PINK);
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("backdropBlur");
    textNode->SetWidth(MIDDLE_LENGTH);
    textNode->SetHeight(MIDDLE_LENGTH);
    textNode->SetBackgroundColor(COLOR_PINK);
    textNode->SetBackdropBlur(NUMBER_20);
    column->AddChild(textNodeBackdropBlur);
    column->AddChild(textNode);

    auto textNodeRenderGroup = std::make_shared<ArkUITextNode>();
    textNodeRenderGroup->SetTextContent("RenderGroup");
    textNodeRenderGroup->SetWidth(MIDDLE_LENGTH);
    textNodeRenderGroup->SetHeight(SMALL_LENGTH);
    auto column1 = std::make_shared<ArkUIColumnNode>();
    column1->SetWidth(MIDDLE_LENGTH);
    column1->SetHeight(MIDDLE_LENGTH);
    column1->SetBackgroundColor(COLOR_BLACK);
    column1->SetOpacity(NUMBER_1);
    column1->SetColumnJustifyContent(ARKUI_FLEX_ALIGNMENT_CENTER);
     
    auto column2 = std::make_shared<ArkUIColumnNode>();
    column2->SetWidth(NUMBER_150);
    column2->SetHeight(NUMBER_150);
    column2->SetBackgroundColor(COLOR_WHITE);
    column2->SetColumnJustifyContent(ARKUI_FLEX_ALIGNMENT_CENTER);
    column2->SetOpacity(NUMBER_06);
    column2->SetRenderGroup(NUMBER_1);
    
    auto column3 = std::make_shared<ArkUIColumnNode>();
    column3->SetWidth(NUMBER_100);
    column3->SetHeight(NUMBER_100);
    column3->SetBackgroundColor(COLOR_BLACK);
    column3->SetOpacity(NUMBER_1);
    column3->SetColumnJustifyContent(ARKUI_FLEX_ALIGNMENT_CENTER);
    
    column->AddChild(textNodeRenderGroup);
    column->AddChild(column1);
    column1->AddChild(column2);
    column2->AddChild(column3);
    column->AddChild(column1);

    return column;
}


} // namespace NativeModule

#endif