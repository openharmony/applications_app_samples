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

#ifndef MYAPPLICATION_ARKUIDOBASENODE_H
#define MYAPPLICATION_ARKUIDOBASENODE_H
#include "ArkUIColumnNode.h"
#include "ArkUITextNode.h"
#include "ArkUINumber.h"
#include <hilog/log.h>

namespace NativeModule {
std::shared_ptr<ArkUITextNode> g_keyframe_text = nullptr;
std::shared_ptr<ArkUIColumnNode> g_keyframe_column1 = nullptr;
std::shared_ptr<ArkUIColumnNode> g_keyframe_column2 = nullptr;
std::shared_ptr<ArkUIBaseNode> CreateAnimationCenter()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeTransformCenter = std::make_shared<ArkUITextNode>();
    textNodeTransformCenter->SetTextContent("transformCenter");
    textNodeTransformCenter->SetWidth(MIDDLE_LENGTH);
    textNodeTransformCenter->SetHeight(SMALL_LENGTH);
    auto columnTransformCenter = std::make_shared<ArkUIColumnNode>();
    columnTransformCenter->SetWidth(MIDDLE_LENGTH);
    columnTransformCenter->SetHeight(MIDDLE_LENGTH);
    columnTransformCenter->SetBackgroundColor(COLOR_PINK);
    columnTransformCenter->SetRotateTransition();
    columnTransformCenter->SetTransformCenter(NUMBER_20);
    column->AddChild(textNodeTransformCenter);
    column->AddChild(columnTransformCenter);

    auto textNodeTransition = std::make_shared<ArkUITextNode>();
    textNodeTransition->SetTextContent("NODE_TRANSITION");
    textNodeTransition->SetWidth(MIDDLE_LENGTH);
    textNodeTransition->SetHeight(SMALL_LENGTH);
    ArkUI_RotationOptions rotation;
    rotation.x = NUMBER_0;
    rotation.y = NUMBER_0;
    rotation.z = NUMBER_1;
    rotation.angle = NUMBER_180;
    rotation.perspective = NUMBER_0;
    ArkUI_TransitionEffect* options = OH_ArkUI_CreateRotationTransitionEffect(&rotation);
    static ArkUI_AnimateOption *option =  OH_ArkUI_AnimateOption_Create();
    OH_ArkUI_AnimateOption_SetCurve(option, ARKUI_CURVE_EASE);
    OH_ArkUI_AnimateOption_SetDuration(option, DURATION_TIME);
    OH_ArkUI_TransitionEffect_SetAnimation(options, option);
    auto columnTransition = std::make_shared<ArkUIColumnNode>();
    columnTransition->SetWidth(MIDDLE_LENGTH);
    columnTransition->SetHeight(MIDDLE_LENGTH);
    columnTransition->SetBackgroundColor(COLOR_RED);
    columnTransition->SetTransition(options);
    column->AddChild(textNodeTransition);
    column->AddChild(columnTransition);
    
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateAnimationOpacity()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeOpacityTransition = std::make_shared<ArkUITextNode>();
    textNodeOpacityTransition->SetTextContent("OpacityTransition");
    textNodeOpacityTransition->SetWidth(MIDDLE_LENGTH);
    textNodeOpacityTransition->SetHeight(SMALL_LENGTH);
    auto columnOpacityTransition = std::make_shared<ArkUIColumnNode>();
    columnOpacityTransition->SetWidth(MIDDLE_LENGTH);
    columnOpacityTransition->SetHeight(MIDDLE_LENGTH);
    columnOpacityTransition->SetBackgroundColor(COLOR_RED);
    columnOpacityTransition->SetOpacityTransition();
    column->AddChild(textNodeOpacityTransition);
    column->AddChild(columnOpacityTransition);
    
    auto textNodeRotateTransition = std::make_shared<ArkUITextNode>();
    textNodeRotateTransition->SetTextContent("RotateTransition");
    textNodeRotateTransition->SetWidth(MIDDLE_LENGTH);
    textNodeRotateTransition->SetHeight(SMALL_LENGTH);
    auto columnRotateTransition = std::make_shared<ArkUIColumnNode>();
    columnRotateTransition->SetWidth(MIDDLE_LENGTH);
    columnRotateTransition->SetHeight(MIDDLE_LENGTH);
    columnRotateTransition->SetBackgroundColor(COLOR_PINK);
    columnRotateTransition->SetRotateTransition();
    column->AddChild(textNodeRotateTransition);
    column->AddChild(columnRotateTransition);

    auto textNodeScaleTransition = std::make_shared<ArkUITextNode>();
    textNodeScaleTransition->SetTextContent("ScaleTransition");
    textNodeScaleTransition->SetWidth(MIDDLE_LENGTH);
    textNodeScaleTransition->SetHeight(SMALL_LENGTH);
    auto columnScaleTransition = std::make_shared<ArkUIColumnNode>();
    columnScaleTransition->SetWidth(MIDDLE_LENGTH);
    columnScaleTransition->SetHeight(MIDDLE_LENGTH);
    columnScaleTransition->SetBackgroundColor(COLOR_PINK);
    columnScaleTransition->SetScaleTransition();
    column->AddChild(textNodeScaleTransition);
    column->AddChild(columnScaleTransition);

    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateAnimationTranslate()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeTranslateTransition = std::make_shared<ArkUITextNode>();
    textNodeTranslateTransition->SetTextContent("TranslateTransition");
    textNodeTranslateTransition->SetWidth(MIDDLE_LENGTH);
    textNodeTranslateTransition->SetHeight(SMALL_LENGTH);
    auto columnTranslateTransition = std::make_shared<ArkUIColumnNode>();
    columnTranslateTransition->SetWidth(MIDDLE_LENGTH);
    columnTranslateTransition->SetHeight(MIDDLE_LENGTH);
    columnTranslateTransition->SetBackgroundColor(COLOR_RED);
    columnTranslateTransition->SetTranslateTransition();
    column->AddChild(textNodeTranslateTransition);
    column->AddChild(columnTranslateTransition);
    
    auto textNodeMoveTransition = std::make_shared<ArkUITextNode>();
    textNodeMoveTransition->SetTextContent("MoveTransition");
    textNodeMoveTransition->SetWidth(MIDDLE_LENGTH);
    textNodeMoveTransition->SetHeight(SMALL_LENGTH);
    auto columnMoveTransition = std::make_shared<ArkUIColumnNode>();
    columnMoveTransition->SetWidth(MIDDLE_LENGTH);
    columnMoveTransition->SetHeight(MIDDLE_LENGTH);
    columnMoveTransition->SetBackgroundColor(COLOR_PINK);
    columnMoveTransition->SetMoveTransition();
    column->AddChild(textNodeMoveTransition);
    column->AddChild(columnMoveTransition);
 
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateAnimationFit()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("NODE_RENDER_FIT");
    textNode->SetWidth(MIDDLE_LENGTH);
    textNode->SetHeight(SMALL_LENGTH);
    
    auto text = std::make_shared<ArkUITextNode>();
    text->SetWidth(MIDDLE_LENGTH);
    text->SetHeight(SMALL_LENGTH);
    text->SetBackgroundColor(COLOR_PINK);
    text->SetTextContent("NODE_RENDER_FIT");
    text->SetRenderFit(ARKUI_RENDER_FIT_BOTTOM);
    
    g_keyframe_text = text;
    text->RegisterNodeEvent(text->GetHandle(), NODE_ON_CLICK, NUMBER_1, nullptr);
    auto onTouch1 = [](ArkUI_NodeEvent *event) {
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUMBER_1) {
            static ArkUI_ContextHandle context = nullptr;
            context = OH_ArkUI_GetContextByNode(g_keyframe_text->GetHandle());
            ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
            OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);
            static ArkUI_AnimateOption *option =  OH_ArkUI_AnimateOption_Create();
            OH_ArkUI_AnimateOption_SetCurve(option, ARKUI_CURVE_EASE);
            ArkUI_AnimateCompleteCallback *completeCallback = new ArkUI_AnimateCompleteCallback;
            completeCallback->type = ARKUI_FINISH_CALLBACK_REMOVED;
            completeCallback->callback = [](void *userData) {
            };
            ArkUI_ContextCallback *update = new ArkUI_ContextCallback;
            update->callback = [](void *user) {
                g_keyframe_text->SetWidth(LARGE_LENGTH);
                g_keyframe_text->SetHeight(MIDDLE_LENGTH);
                g_keyframe_text->SetBackgroundColor(COLOR_RED);
            };
            animateApi->animateTo(context, option, update, completeCallback);
        }
    };
    text->RegisterNodeEventReceiver(onTouch1);
    column->AddChild(textNode);
    column->AddChild(text);

    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateAnimationGeometry()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeTitle1 = std::make_shared<ArkUITextNode>();
    textNodeTitle1->SetTextContent("GeometryTransition");
    textNodeTitle1->SetWidth(MIDDLE_LENGTH);
    textNodeTitle1->SetHeight(SMALL_LENGTH);
    const char* str = "animation";
    auto column1 = std::make_shared<ArkUIColumnNode>();
    column1->SetWidth(MIDDLE_LENGTH);
    column1->SetHeight(MIDDLE_LENGTH);
    column1->SetBackgroundColor(COLOR_PINK);
    column1->SetOpacityTransition();
    column1->SetGeometryTransition(NUMBER_0, str);
    
    auto column2 = std::make_shared<ArkUIColumnNode>();
    column2->SetWidth(LARGE_LENGTH);
    column2->SetHeight(LARGE_LENGTH);
    column2->SetBackgroundColor(COLOR_RED);
    column2->SetVisibility(ARKUI_VISIBILITY_NONE);
    column2->SetGeometryTransition(NUMBER_1, str);
    column2->SetOpacityTransition();
    
    g_keyframe_column1 = column1;
    g_keyframe_column2 = column2;
    column1->RegisterNodeEvent(column1->GetHandle(), NODE_ON_CLICK, NUMBER_1, nullptr);
    auto onTouch1 = [](ArkUI_NodeEvent *event) {
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUMBER_1) {
            static ArkUI_ContextHandle context = nullptr;
            context = OH_ArkUI_GetContextByNode(g_keyframe_column1->GetHandle());
            ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
            OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);
            static ArkUI_AnimateOption *option =  OH_ArkUI_AnimateOption_Create();
            OH_ArkUI_AnimateOption_SetDuration(option, NUMBER_1000);
            ArkUI_AnimateCompleteCallback *completeCallback = new ArkUI_AnimateCompleteCallback;
            completeCallback->type = ARKUI_FINISH_CALLBACK_REMOVED;
            completeCallback->callback = [](void *userData) {
            };
            ArkUI_ContextCallback *update = new ArkUI_ContextCallback;
            update->callback = [](void *user) {
                g_keyframe_column2->SetVisibility(ARKUI_VISIBILITY_VISIBLE);
                g_keyframe_column1->SetVisibility(ARKUI_VISIBILITY_NONE);
            };
            animateApi->animateTo(context, option, update, completeCallback);
        }
    };
    column1->RegisterNodeEventReceiver(onTouch1);
    column->AddChild(textNodeTitle1);
    column->AddChild(column1);
    column->AddChild(column2);
    
    return column;
}
} // namespace NativeModule

#endif