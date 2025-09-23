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
#include "ArkUIButtonNode.h"
#include <hilog/log.h>

namespace NativeModule {
constexpr int32_t NUM_100 = 100;
constexpr int32_t NUM_120 = 120;
constexpr int32_t NUM_150 = 150;
constexpr int32_t NUM_200 = 200;
constexpr int32_t NUM_250 = 250;
constexpr int32_t NUM_300 = 300;
constexpr int32_t NUM_400 = 400;
constexpr int32_t NUM_500 = 500;
constexpr int32_t NUM_1000 = 1000;
constexpr int32_t NUM_1500 = 1500;
constexpr int32_t NUM_2000 = 2000;
constexpr int32_t NUM_0 = 0;
constexpr int32_t NUM_1 = 1;
constexpr int32_t NUM_2 = 2;
constexpr int32_t NUM_3 = 3;
constexpr int32_t NUM_4 = 4;
constexpr int32_t NUM_5 = 5;
constexpr int32_t NUM_6 = 6;
constexpr int32_t NUM_7 = 7;
constexpr int32_t NUM_8 = 8;
constexpr int32_t NUM_9 = 9;
constexpr int32_t NUM_10 = 10;
constexpr int32_t NUM_20 = 20;
constexpr int32_t NUM_30 = 30;
constexpr int32_t NUM_40 = 40;
constexpr int32_t NUM_50 = 50;
constexpr int32_t NUM_60 = 60;
constexpr int32_t NUM_80 = 80;
std::shared_ptr<ArkUIButtonNode> g_keyframe_button = nullptr;
std::shared_ptr<ArkUITextNode> g_keyframe_text = nullptr;
std::shared_ptr<ArkUIButtonNode> g_animateto_button = nullptr;
std::shared_ptr<ArkUITextNode> g_animateto_text = nullptr;
std::shared_ptr<ArkUIButtonNode> g_transition_button = nullptr;
std::shared_ptr<ArkUIButtonNode> g_animator_button = nullptr;
std::shared_ptr<ArkUITextNode> g_animator_text = nullptr;
ArkUI_AnimatorHandle animatorHandle = nullptr;
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

struct KeyFrameAnimateToData {
    ArkUI_KeyframeAnimateOption* option;
    ArkUI_CurveHandle curve;
};

struct AnimateData {
    ArkUI_AnimateOption* option;
    ArkUI_CurveHandle curve;
};

struct TransitionData {
    ArkUI_AnimateOption* option;
    ArkUI_TransitionEffect* effect;
};
std::shared_ptr<ArkUIBaseNode> CreateAnimationCenter()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNodeMoveTransition = std::make_shared<ArkUITextNode>();
    textNodeMoveTransition->SetTextContent("ArkUI_TransitionEdge");
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

std::shared_ptr<ArkUIBaseNode> CreateAnimationOpacity()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("ArkUI_RenderFit");
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

ArkUI_AnimateCompleteCallback* CreateComplete(ArkUI_AnimateOption *option, ArkUI_CurveHandle cubicBezierCurve)
{
    ArkUI_AnimateCompleteCallback *completeCallback = new ArkUI_AnimateCompleteCallback;
    completeCallback->type = ARKUI_FINISH_CALLBACK_REMOVED;
    AnimateData* data = new AnimateData();
    data->option = option;
    data->curve = cubicBezierCurve;
    completeCallback->userData = reinterpret_cast<void*>(data);
    completeCallback->callback = [](void *userData) {
        AnimateData* data = reinterpret_cast<AnimateData*>(userData);
        if (data) {
            ArkUI_AnimateOption* option = data->option;
            ArkUI_CurveHandle curve = data->curve;
            if (option) {
                OH_ArkUI_AnimateOption_Dispose(option);
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                    "Init", "CXX OH_ArkUI_AnimateOption_Dispose  success!");
            }
            if (curve) {
                OH_ArkUI_Curve_DisposeCurve(curve);
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                    "Init", "CXX OH_ArkUI_Curve_DisposeCurve  success!");
            }
            delete data;
        }
    };
    return completeCallback;
}

void CreateUpdate(bool isback)
{
    if (isback) {
        g_animateto_button->SetWidth(NUM_200);
        g_animateto_button->SetHeight(NUM_80);
        g_animateto_button->SetBackgroundColor(COLOR_PINK);
    } else {
        g_animateto_button->SetWidth(NUM_100);
        g_animateto_button->SetHeight(NUM_40);
        g_animateto_button->SetBackgroundColor(COLOR_RED);
    }
}

void CreateTouchAnimateTo(ArkUI_NodeEvent *event)
{
    static ArkUI_ContextHandle context = nullptr;
    context = OH_ArkUI_GetContextByNode(g_animateto_button->GetHandle());
    if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_2) {
        ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);
        ArkUI_AnimateOption *option = OH_ArkUI_AnimateOption_Create();
        OH_ArkUI_AnimateOption_SetDuration(option, NUM_2000);
        OH_ArkUI_AnimateOption_SetTempo(option, NUMBER_11F);
        OH_ArkUI_AnimateOption_SetCurve(option, ARKUI_CURVE_EASE);
        ArkUI_CurveHandle cubicBezierCurve = OH_ArkUI_Curve_CreateCubicBezierCurve(
            NUMBER_05, NUMBER_4F, NUMBER_12F, NUMBER_00);
        OH_ArkUI_AnimateOption_SetICurve(option, cubicBezierCurve);
        OH_ArkUI_AnimateOption_SetDelay(option, NUM_20);
        OH_ArkUI_AnimateOption_SetIterations(option, NUM_1);
        OH_ArkUI_AnimateOption_SetPlayMode(option, ARKUI_ANIMATION_PLAY_MODE_REVERSE);
        ArkUI_ExpectedFrameRateRange *range = new ArkUI_ExpectedFrameRateRange;
        range->min = NUM_10;
        range->max = NUM_120;
        range->expected = NUM_60;
        OH_ArkUI_AnimateOption_SetExpectedFrameRateRange(option, range);
        ArkUI_AnimateCompleteCallback *completeCallback = CreateComplete(option, cubicBezierCurve);
        static bool isback = true;
        ArkUI_ContextCallback *update = new ArkUI_ContextCallback;
        update->callback = [](void *user) {
            CreateUpdate(isback);
            isback = !isback;
        };
        animateApi->animateTo(context, option, update, completeCallback);
    }
}

std::shared_ptr<ArkUIBaseNode> CreateAnimeteto()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(NUM_300);
    column->SetHeight(NUM_250);
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("这是animateto动画");
    textNode->SetWidth(NUM_150);
    textNode->SetHeight(NUM_50);
    auto button = std::make_shared<ArkUIButtonNode>();
    button->SetWidth(NUM_100);
    button->SetHeight(NUM_100);
    button->SetBackgroundColor(COLOR_PINK);
    g_animateto_button = button;
    button->RegisterNodeEvent(button->GetHandle(), NODE_ON_CLICK, NUM_2, nullptr);
    auto onTouch = [](ArkUI_NodeEvent *event) {
        CreateTouchAnimateTo(event);
    };
    button->RegisterNodeEventReceiver(onTouch);
    column->AddChild(textNode);
    column->AddChild(button);
    return column;
}

void CreateButton(ArkUI_NodeEvent *event)
{
    if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_3) {
        static ArkUI_ContextHandle context = nullptr;
        context = OH_ArkUI_GetContextByNode(g_animator_button->GetHandle());
        ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);
        static ArkUI_AnimatorOption *option =  OH_ArkUI_AnimatorOption_Create(NUM_0); // Animator动画状态数
        OH_ArkUI_AnimatorOption_SetDuration(option, NUM_2000);
        OH_ArkUI_AnimatorOption_SetDelay(option, NUM_10);
        OH_ArkUI_AnimatorOption_SetIterations(option, NUM_3);
        OH_ArkUI_AnimatorOption_SetFill(option, ARKUI_ANIMATION_FILL_MODE_NONE);
        OH_ArkUI_AnimatorOption_SetDirection(option, ARKUI_ANIMATION_DIRECTION_NORMAL);
        ArkUI_CurveHandle curve = OH_ArkUI_Curve_CreateCubicBezierCurve(
            NUMBER_05, NUMBER_4F, NUMBER_12F, NUMBER_00); // 构造三阶贝塞尔曲线对象
        OH_ArkUI_AnimatorOption_SetCurve(option, curve);
        OH_ArkUI_AnimatorOption_SetBegin(option, NUM_100);
        OH_ArkUI_AnimatorOption_SetEnd(option, NUM_150);
        ArkUI_ExpectedFrameRateRange *range = new ArkUI_ExpectedFrameRateRange;
        range->max = NUM_120;
        range->expected = NUM_60;
        range->min = NUM_30;
        OH_ArkUI_AnimatorOption_SetExpectedFrameRateRange(option, range);
        OH_ArkUI_AnimatorOption_SetKeyframe(option, NUMBER_05, NUMBER_1205F, NUM_0); // 设置animator动画关键帧参数
        OH_ArkUI_AnimatorOption_SetKeyframeCurve(option, curve, NUM_0); // 设置animator动画关键帧曲线类型
        OH_ArkUI_AnimatorOption_RegisterOnFrameCallback(option, nullptr, [](ArkUI_AnimatorOnFrameEvent *event) {
            OH_ArkUI_AnimatorOnFrameEvent_GetUserData(event);
            auto value = OH_ArkUI_AnimatorOnFrameEvent_GetValue(event);
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Init",
                "CXX OH_ArkUI_AnimatorOption_RegisterOnFrameCallback  %{public}f", value);
            g_animator_button->SetWidth(value);
        });
        OH_ArkUI_AnimatorOption_RegisterOnFinishCallback(option, nullptr, [](ArkUI_AnimatorEvent* event) {
            OH_ArkUI_AnimatorEvent_GetUserData(event);
        });
        OH_ArkUI_AnimatorOption_RegisterOnCancelCallback(option, nullptr, [](ArkUI_AnimatorEvent* event) {
        });
        OH_ArkUI_AnimatorOption_RegisterOnRepeatCallback(option, nullptr, [](ArkUI_AnimatorEvent* event) {
        });
        animatorHandle = animateApi->createAnimator(context, option);
    }
}

std::shared_ptr<ArkUIBaseNode> CreateAnimator()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(NUM_300);
    column->SetHeight(NUM_250);
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("这是animator动画");
    textNode->SetWidth(NUM_120);
    textNode->SetHeight(NUM_50);
    auto createButton = std::make_shared<ArkUIButtonNode>();
    auto button = std::make_shared<ArkUIButtonNode>();
    button->SetWidth(NUM_100);
    button->SetHeight(NUM_100);
    g_animator_button = button;
    createButton->RegisterNodeEvent(createButton->GetHandle(), NODE_ON_CLICK, NUM_3, nullptr);
    auto onTouch = [](ArkUI_NodeEvent *event) {
        CreateButton(event);
    };
    createButton->RegisterNodeEventReceiver(onTouch);
    createButton->SetButtonLabel("create");
    auto buttoColumn = std::make_shared<ArkUIColumnNode>();
    buttoColumn->SetPadding(NUM_30, false);
    buttoColumn->SetWidth(NUM_300);
    auto playButtonColumn = std::make_shared<ArkUIColumnNode>();
    playButtonColumn->SetPadding(NUM_10, false);
    playButtonColumn->SetWidth(NUM_300);
    auto playButton = std::make_shared<ArkUIButtonNode>();
    playButton->SetButtonLabel("play");
    playButton->RegisterNodeEvent(playButton->GetHandle(), NODE_ON_CLICK, NUM_4, nullptr);
    auto onTouchPlay = [](ArkUI_NodeEvent *event) {
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_4) {
            OH_ArkUI_Animator_Play(animatorHandle);
        }
    };
    playButton->RegisterNodeEventReceiver(onTouchPlay);
    column->AddChild(textNode);
    column->AddChild(button);
    buttoColumn->AddChild(createButton);
    playButtonColumn->AddChild(playButton);
    buttoColumn->AddChild(playButtonColumn);
    column->AddChild(buttoColumn);
    return column;
}

void CreateCompleteCallback(void *userData)
{
    TransitionData* data = reinterpret_cast<TransitionData*>(userData);
    if (data) {
        ArkUI_AnimateOption* option = data->option;
        ArkUI_TransitionEffect* effect = data->effect;
        if (option) {
            OH_ArkUI_AnimateOption_Dispose(option);
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                "Init", "CXX OH_ArkUI_AnimateOption_Dispose  success!");
        }
        if (effect) {
            OH_ArkUI_TransitionEffect_Dispose(effect);
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                "Init", "CXX OH_ArkUI_TransitionEffect_Dispose  success!");
        }
        delete data;
    }
}

ArkUI_AnimateCompleteCallback* CreateCallback(ArkUI_AnimateOption *option)
{
    ArkUI_AnimateCompleteCallback *completeCallback = new ArkUI_AnimateCompleteCallback;
    completeCallback->type = ARKUI_FINISH_CALLBACK_REMOVED;
    TransitionData* data = new TransitionData();
    data->option = option;
    completeCallback->userData = reinterpret_cast<void*>(data);
    completeCallback->callback = [](void *userData) {
        CreateCompleteCallback(userData);
    };
    return completeCallback;
}

void SetButton(bool transitionIsBack)
{
    if (transitionIsBack) {
        g_transition_button->SetVisibility(ARKUI_VISIBILITY_VISIBLE);
    } else {
        g_transition_button->SetVisibility(ARKUI_VISIBILITY_HIDDEN);
    }
}

void CreateTouch(ArkUI_NodeEvent *event)
{
    static ArkUI_ContextHandle context = nullptr;
    context = OH_ArkUI_GetContextByNode(g_transition_button->GetHandle());
    if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_10) {
        ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
        OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);
        ArkUI_AnimateOption *option = OH_ArkUI_AnimateOption_Create();
        OH_ArkUI_AnimateOption_SetDuration(option, NUM_2000);
        OH_ArkUI_AnimateOption_SetCurve(option, ARKUI_CURVE_EASE);
        ArkUI_RotationOptions* rotate = new ArkUI_RotationOptions;
        rotate->perspective = NUM_0;
        auto rotationTransition = OH_ArkUI_CreateRotationTransitionEffect(rotate);
        auto movementTransition = OH_ArkUI_CreateMovementTransitionEffect(ARKUI_TRANSITION_EDGE_TOP);
        auto asymmetricTransition = OH_ArkUI_CreateAsymmetricTransitionEffect(
            rotationTransition, movementTransition);
        ArkUI_AnimateCompleteCallback *completeCallback = CreateCallback(option);
        static bool transitionIsBack = false;
        ArkUI_ContextCallback *update = new ArkUI_ContextCallback;
        update->callback = [](void *user) {
            SetButton(transitionIsBack);
            transitionIsBack = !transitionIsBack;
        };
        animateApi->animateTo(context, option, update, completeCallback);
    }
}

std::shared_ptr<ArkUIBaseNode> CreateTransitionEffect()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(NUM_300);
    column->SetHeight(NUM_250);
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("这是TransitionEffect");
    textNode->SetWidth(NUM_150);
    textNode->SetHeight(NUM_50);
    auto transitionButton = std::make_shared<ArkUIButtonNode>();
    transitionButton->SetWidth(NUM_100);
    transitionButton->SetHeight(NUM_100);
    transitionButton->SetBackgroundColor(COLOR_PINK);
    g_transition_button = transitionButton;
    g_transition_button->SetVisibility(ARKUI_VISIBILITY_VISIBLE);
    auto button = std::make_shared<ArkUIButtonNode>();
    button->SetButtonLabel("transition");
    auto buttonColumn = std::make_shared<ArkUIColumnNode>();
    buttonColumn->SetWidth(NUM_300);
    buttonColumn->SetPadding(NUM_10, false);
    button->RegisterNodeEvent(button->GetHandle(), NODE_ON_CLICK, NUM_10, nullptr);
    auto onTouch = [](ArkUI_NodeEvent *event) {
        CreateTouch(event);
    };
    button->RegisterNodeEventReceiver(onTouch);
    column->AddChild(textNode);
    column->AddChild(transitionButton);
    buttonColumn->AddChild(button);
    column->AddChild(buttonColumn);
    return column;
}
} // namespace NativeModule
#endif // MYAPPLICATION_ARKUIDOBASENODE_H