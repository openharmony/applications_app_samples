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

#ifndef MYAPPLICATION_ARKUIANIMATE_H
#define MYAPPLICATION_ARKUIANIMATE_H
#include "ArkUIButtonNode.h"
#include "ArkUIScrollNode.h"
#include "ArkUIColumnNode.h"
#include "ArkUITextNode.h"
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

std::shared_ptr<ArkUIBaseNode> CreateKeyFrameAnimeteto()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(NUM_300);
    column->SetHeight(NUM_250);
    // 创建文本节点，内容区介绍“这是关键帧动画”
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("这是关键帧动画");
    textNode->SetWidth(NUM_120);
    textNode->SetHeight(NUM_50);
    // 创建button，后续创建的关键帧动画作用在button组件上
    auto button = std::make_shared<ArkUIButtonNode>();
    // 设置button初始宽高
    button->SetWidth(NUM_100);
    button->SetHeight(NUM_100);
    // 存储button全局变量，在onTouch注册时需要使用
    g_keyframe_button = button;
    // 注册点击事件到button上
    button->RegisterNodeEvent(button->GetHandle(), NODE_ON_CLICK, NUM_1, nullptr);
    g_keyframe_text = std::make_shared<ArkUITextNode>();
    g_keyframe_text->KeyframeAnimatetoToString();
    auto onTouch = [](ArkUI_NodeEvent *event) {
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_1) {
            // 获取context对象
            ArkUI_ContextHandle context = nullptr;
            context = OH_ArkUI_GetContextByNode(g_keyframe_button->GetHandle());

            // 获取ArkUI_NativeAnimateAPI接口
            ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
            OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);
            
            // 以下代码为创建关键帧动画的关键流程，包括设置关键帧动画参数、开启关键帧动画
            // 设置ArkUI_KeyframeAnimateOption参数，通过提供的C方法设置对应的参数
            ArkUI_KeyframeAnimateOption *option =  OH_ArkUI_KeyframeAnimateOption_Create(NUM_2); // 关键帧动画状态数
            OH_ArkUI_KeyframeAnimateOption_SetDelay(option, NUM_500);
            OH_ArkUI_KeyframeAnimateOption_SetDuration(option, NUM_1000, NUM_0); // 第一段关键帧动画的持续时间
            OH_ArkUI_KeyframeAnimateOption_SetDuration(option, NUM_2000, NUM_1); // 第二段关键帧动画的持续时间
            OH_ArkUI_KeyframeAnimateOption_SetIterations(option, NUM_5); // 关键帧动画播放次数
            ArkUI_CurveHandle curve = OH_ArkUI_Curve_CreateCubicBezierCurve(0.5f, 4.0f, 1.2f, 0.0f);
            // 以下四种曲线根据自己得业务需要选择
            ArkUI_CurveHandle springCurve = OH_ArkUI_Curve_CreateSpringCurve(0.5f, 4.0f, 1.2f, 0.0f);
            ArkUI_CurveHandle springMotionCurve = OH_ArkUI_Curve_CreateSpringMotion(0.5f, 0.6f, 0.0f);
            ArkUI_CurveHandle responsiveSpringMotionCurve = OH_ArkUI_Curve_CreateResponsiveSpringMotion(0.5f,
                4.0f, 1.2f);
            ArkUI_CurveHandle interpolatingSpringCurve = OH_ArkUI_Curve_CreateInterpolatingSpring(0.5f,
                4.0f, 1.2f, 0.0f);
            OH_ArkUI_KeyframeAnimateOption_SetCurve(option, curve, 1);
            OH_ArkUI_KeyframeAnimateOption_RegisterOnEventCallback(option, nullptr, [](void *userData) {
                  g_keyframe_button->SetWidth(NUM_150);
            }, NUM_0); // 第一段关键帧时刻状态的闭包函数
            OH_ArkUI_KeyframeAnimateOption_RegisterOnEventCallback(option, nullptr, [](void *userData) {
                  g_keyframe_button->SetWidth(80);
            }, NUM_1); // 第二段关键帧时刻状态的闭包函数
            KeyFrameAnimateToData* data = new KeyFrameAnimateToData();
            data->option = option;
            data->curve = curve;
            OH_ArkUI_KeyframeAnimateOption_RegisterOnFinishCallback(option, nullptr, [](void *user) {
                KeyFrameAnimateToData* data = reinterpret_cast<KeyFrameAnimateToData*>(user);
                if (data) {
                    ArkUI_KeyframeAnimateOption* option = data->option;
                    ArkUI_CurveHandle curve = data->curve;
                    if (option) {
                        OH_ArkUI_KeyframeAnimateOption_Dispose(option);
                        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                            "Init", "CXX OH_ArkUI_KeyframeAnimateOption_Dispose  success!");
                    }
                    if (curve) {
                        OH_ArkUI_Curve_DisposeCurve(curve);
                        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                            "Init", "CXX OH_ArkUI_Curve_DisposeCurve  success!");
                    }
                    delete data; // 释放结构体
                }
            }); // 关键帧动画结束回调
            ArkUI_ExpectedFrameRateRange *range = new ArkUI_ExpectedFrameRateRange;
            range->max = NUM_120;
            range->expected = NUM_60;
            range->min = NUM_30;
            OH_ArkUI_KeyframeAnimateOption_SetExpectedFrameRate(option, range); // 关键帧设置期望帧率

            // 执行对应的动画
            animateApi->keyframeAnimateTo(context, option);
            auto delay = OH_ArkUI_KeyframeAnimateOption_GetDelay(option);
            auto iter = OH_ArkUI_KeyframeAnimateOption_GetIterations(option);
            auto expected = OH_ArkUI_KeyframeAnimateOption_GetExpectedFrameRate(option); // 获取关键帧动画参数的期望帧率
            auto dur0 = OH_ArkUI_KeyframeAnimateOption_GetDuration(option, NUM_1);
            auto dur1 = OH_ArkUI_KeyframeAnimateOption_GetDuration(option, NUM_1);
            auto curves = OH_ArkUI_KeyframeAnimateOption_GetCurve(option, NUM_1); //获取关键帧动画某段状态动画曲线
            g_keyframe_text->KeyframeAnimatetoToString(dur0, dur1, delay, iter, *expected);
        }
    };
    // 注册点击事件的回调函数
    button->RegisterNodeEventReceiver(onTouch);
    // 将button挂载在column上，返回column节点
    column->AddChild(g_keyframe_text);
    column->AddChild(textNode);
    column->AddChild(button);
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateAnimeteto()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(NUM_300);
    column->SetHeight(NUM_250);
    // 创建文本节点，内容区介绍“这是animateto动画”
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("这是animateto动画");
    textNode->SetWidth(NUM_150);
    textNode->SetHeight(NUM_50);
    // 创建button，后续创建的动画作用在button组件上
    auto button = std::make_shared<ArkUIButtonNode>();
    // 设置button初始宽高及颜色
    button->SetWidth(NUM_100);
    button->SetHeight(NUM_100);
    button->SetBackgroundColor(0xFFA280FF);
    // 存储button全局变量，在onTouch注册时需要使用
    g_animateto_button = button;
    // 注册点击事件到button上
    button->RegisterNodeEvent(button->GetHandle(), NODE_ON_CLICK, NUM_2, nullptr);
    g_animateto_text = std::make_shared<ArkUITextNode>();
    g_animateto_text->AnimatetoToString();
    auto onTouch = [](ArkUI_NodeEvent *event) {
        // 获取context对象
        static ArkUI_ContextHandle context = nullptr;
        context = OH_ArkUI_GetContextByNode(g_animateto_button->GetHandle());
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_2) {
            // 获取ArkUI_NativeAnimateAPI接口
            ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
            OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);
            
            // 设置动画参数
            ArkUI_AnimateOption *option = OH_ArkUI_AnimateOption_Create();
            OH_ArkUI_AnimateOption_SetDuration(option, NUM_2000);
            OH_ArkUI_AnimateOption_SetTempo(option, 1.1);
            OH_ArkUI_AnimateOption_SetCurve(option, ARKUI_CURVE_EASE);
            ArkUI_CurveHandle cubicBezierCurve = OH_ArkUI_Curve_CreateCubicBezierCurve(0.5f, 4.0f, 1.2f, 0.0f);
            // 设置动画的动画曲线，优先于OH_ArkUI_AnimateOption_SetCurve生效
            OH_ArkUI_AnimateOption_SetICurve(option, cubicBezierCurve);
            OH_ArkUI_AnimateOption_SetDelay(option, NUM_20);
            OH_ArkUI_AnimateOption_SetIterations(option, NUM_1);
            OH_ArkUI_AnimateOption_SetPlayMode(option, ARKUI_ANIMATION_PLAY_MODE_REVERSE);
            ArkUI_ExpectedFrameRateRange *range = new ArkUI_ExpectedFrameRateRange;
            range->min = NUM_10;
            range->max = NUM_120;
            range->expected = NUM_60;
            OH_ArkUI_AnimateOption_SetExpectedFrameRateRange(option, range);
            
            // 设置完成的回调
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
                    delete data; // 释放结构体
                }
            };
            
            // 设置闭包函数
            static bool isback = true;
            ArkUI_ContextCallback *update = new ArkUI_ContextCallback;
            update->callback = [](void *user) {
                // 对应的属性变化 width height
                if (isback) {
                    g_animateto_button->SetWidth(NUM_200);
                    g_animateto_button->SetHeight(NUM_80);
                    g_animateto_button->SetBackgroundColor(0xFFA280FF);
                } else {
                    g_animateto_button->SetWidth(NUM_100);
                    g_animateto_button->SetHeight(NUM_40);
                    g_animateto_button->SetBackgroundColor(0xFFFF2E77);
                }
                isback = !isback;
            };
            // 执行对应的动画
            animateApi->animateTo(context, option, update, completeCallback);
            
            auto duration = OH_ArkUI_AnimateOption_GetDuration(option);
            auto tempo = OH_ArkUI_AnimateOption_GetTempo(option);
            auto curve = OH_ArkUI_AnimateOption_GetCurve(option);
            auto delay = OH_ArkUI_AnimateOption_GetDelay(option);
            auto iteration = OH_ArkUI_AnimateOption_GetIterations(option);
            auto playmode = OH_ArkUI_AnimateOption_GetPlayMode(option);
            auto expectedFrameRateRange = OH_ArkUI_AnimateOption_GetExpectedFrameRateRange(option);
            auto iCurve = OH_ArkUI_AnimateOption_GetICurve(option); // 获取动画的动画曲线
            g_animateto_text->AnimatetoToString(duration, tempo, curve, delay, iteration, playmode,
                *expectedFrameRateRange);
        }
    };
    button->RegisterNodeEventReceiver(onTouch);
    column->AddChild(g_animateto_text);
    column->AddChild(textNode);
    column->AddChild(button);
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateTransitionEffect()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(NUM_300);
    column->SetHeight(NUM_250);
    // 创建文本节点，内容区介绍“这是TransitionEffect”
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("这是TransitionEffect");
    textNode->SetWidth(NUM_150);
    textNode->SetHeight(NUM_50);
    // 创建transitionButton，后续创建的动画作用在transitionButton组件上
    auto transitionButton = std::make_shared<ArkUIButtonNode>();
    // 设置button初始宽高及颜色
    transitionButton->SetWidth(NUM_100);
    transitionButton->SetHeight(NUM_100);
    transitionButton->SetBackgroundColor(0xFFA280FF);
    // 存储button全局变量
    g_transition_button = transitionButton;
    g_transition_button->SetVisibility(ARKUI_VISIBILITY_VISIBLE);
    // 创建button，后续动画逻辑在button的点击事件中实现
    auto button = std::make_shared<ArkUIButtonNode>();
    button->SetButtonLabel("transition");
    // 创建buttonColumn容器，用于调整button的布局效果
    auto buttonColumn = std::make_shared<ArkUIColumnNode>();
    buttonColumn->SetWidth(NUM_300);
    buttonColumn->SetPadding(NUM_10, false); // 设置布局格式，调整组件内间距
    // 注册点击事件到button上
    button->RegisterNodeEvent(button->GetHandle(), NODE_ON_CLICK, NUM_10, nullptr);
    auto onTouch = [](ArkUI_NodeEvent *event) {
        // 获取context对象
        static ArkUI_ContextHandle context = nullptr;
        context = OH_ArkUI_GetContextByNode(g_transition_button->GetHandle());
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_10) {
            // 获取ArkUI_NativeAnimateAPI接口
            ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
            OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);
            
            // 设置动画参数
            ArkUI_AnimateOption *option = OH_ArkUI_AnimateOption_Create();
            OH_ArkUI_AnimateOption_SetDuration(option, NUM_2000);
            OH_ArkUI_AnimateOption_SetCurve(option, ARKUI_CURVE_EASE);
            // 根据业务所需调整OH_ArkUI_TransitionEffect_SetAnimation的第一个入参
            // 创建组件转场时的透明度效果对象
            auto opacityTransitionEffect = OH_ArkUI_CreateOpacityTransitionEffect(0.7);
            // 创建组件转场时的平移效果对象
            ArkUI_TranslationOptions* translate = new ArkUI_TranslationOptions;
            translate->x = NUM_10;
            translate->y = NUM_0;
            translate->z = NUM_0;
            auto translationTransitionEffect = OH_ArkUI_CreateTranslationTransitionEffect(translate);
            // 创建组件转场时的缩放效果对象
            ArkUI_ScaleOptions* scale = new ArkUI_ScaleOptions;
            scale->x = 1.5;
            scale->y = 0.0;
            scale->z = 0.0;
            scale->centerX = 0.0;
            scale->centerY = 0.0;
            auto scaleTransitionEffect = OH_ArkUI_CreateScaleTransitionEffect(scale);
            // 创建组件转场时的旋转效果对象
            ArkUI_RotationOptions* rotate = new ArkUI_RotationOptions;
            rotate->x = 10.0;
            rotate->y = 0.0;
            rotate->z = 0.0;
            rotate->centerX = 0.0;
            rotate->centerY = 0.1;
            rotate->angle = 30.0;
            rotate->centerZ = 0.1;
            rotate->perspective = NUM_0;
            auto rotationTransition = OH_ArkUI_CreateRotationTransitionEffect(rotate);
            // 创建组件平移效果对象
            auto movementTransition = OH_ArkUI_CreateMovementTransitionEffect(ARKUI_TRANSITION_EDGE_TOP);
            // 创建非对称的转场效果对象
            auto asymmetricTransition = OH_ArkUI_CreateAsymmetricTransitionEffect(
                rotationTransition, movementTransition);
            // 设置转场效果动画参数，此动画设置的是透明度效果
            OH_ArkUI_TransitionEffect_SetAnimation(opacityTransitionEffect, option);
            // 设置转场效果链式组合，以形成包含多种转场效果的TransitionEffect
            OH_ArkUI_TransitionEffect_Combine(translationTransitionEffect, scaleTransitionEffect);
            
            // 设置完成的回调
            ArkUI_AnimateCompleteCallback *completeCallback = new ArkUI_AnimateCompleteCallback;
            completeCallback->type = ARKUI_FINISH_CALLBACK_REMOVED;
            TransitionData* data = new TransitionData();
            data->option = option;
            data->effect = opacityTransitionEffect;
            completeCallback->userData = reinterpret_cast<void*>(data);
            completeCallback->callback = [](void *userData) {
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
                    delete data; // 释放结构体
                }
            };
            
            // 设置闭包函数
            static bool transitionIsBack = false;
            ArkUI_ContextCallback *update = new ArkUI_ContextCallback;
            update->callback = [](void *user) {
                // 通过transitionIsBack变量使组件做显隐变化
                if (transitionIsBack) {
                    g_transition_button->SetVisibility(ARKUI_VISIBILITY_VISIBLE);
                } else {
                    g_transition_button->SetVisibility(ARKUI_VISIBILITY_HIDDEN);
                }
                transitionIsBack = !transitionIsBack;
            };
            // 执行对应的动画
            animateApi->animateTo(context, option, update, completeCallback);
        }
    };
    button->RegisterNodeEventReceiver(onTouch);
    column->AddChild(textNode);
    column->AddChild(transitionButton);
    buttonColumn->AddChild(button);
    column->AddChild(buttonColumn);
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateAnimator()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(NUM_300);
    column->SetHeight(NUM_250);
    // 创建文本节点，内容区介绍“这是animator动画”
    auto textNode = std::make_shared<ArkUITextNode>();
    textNode->SetTextContent("这是animator动画");
    textNode->SetWidth(NUM_120);
    textNode->SetHeight(NUM_50);
    // 创建createButton，用于初始化animator参数
    auto createButton = std::make_shared<ArkUIButtonNode>();
    // 创建button，后续创建的animator动画作用在button组件上
    auto button = std::make_shared<ArkUIButtonNode>();
    // 设置button初始宽高
    button->SetWidth(NUM_100);
    button->SetHeight(NUM_100);
    // 存储button全局变量，在onTouch注册时需要使用
    g_animator_button = button;
    // 注册点击事件到button上
    createButton->RegisterNodeEvent(createButton->GetHandle(), NODE_ON_CLICK, NUM_3, nullptr);
    g_animator_text = std::make_shared<ArkUITextNode>();
    g_animator_text->AnimatorToString();
    auto onTouch = [](ArkUI_NodeEvent *event) {
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_3) {
            // 获取context对象
            static ArkUI_ContextHandle context = nullptr;
            context = OH_ArkUI_GetContextByNode(g_animator_button->GetHandle());

            // 获取ArkUI_NativeAnimateAPI接口
            ArkUI_NativeAnimateAPI_1 *animateApi = nullptr;
            OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_ANIMATE, ArkUI_NativeAnimateAPI_1, animateApi);
            
            // 以下代码为创建Animator动画的关键流程，包括设置Animator动画参数、开启Animator动画
            // 设置ArkUI_AnimatorOption参数，通过提供的C方法设置对应的参数
            static ArkUI_AnimatorOption *option =  OH_ArkUI_AnimatorOption_Create(NUM_0); // Animator动画状态数
            OH_ArkUI_AnimatorOption_SetDuration(option, NUM_2000);
            OH_ArkUI_AnimatorOption_SetDelay(option, NUM_10);
            OH_ArkUI_AnimatorOption_SetIterations(option, NUM_3);
            OH_ArkUI_AnimatorOption_SetFill(option, ARKUI_ANIMATION_FILL_MODE_NONE);
            OH_ArkUI_AnimatorOption_SetDirection(option, ARKUI_ANIMATION_DIRECTION_NORMAL);
            ArkUI_CurveHandle curve = OH_ArkUI_Curve_CreateCubicBezierCurve(0.5f, 4.0f, 1.2f, 0.0f); // 构造三阶贝塞尔曲线对象
            OH_ArkUI_AnimatorOption_SetCurve(option, curve);
            OH_ArkUI_AnimatorOption_SetBegin(option, NUM_100);
            OH_ArkUI_AnimatorOption_SetEnd(option, NUM_150);
            ArkUI_ExpectedFrameRateRange *range = new ArkUI_ExpectedFrameRateRange;
            range->max = NUM_120;
            range->expected = NUM_60;
            range->min = NUM_30;
            OH_ArkUI_AnimatorOption_SetExpectedFrameRateRange(option, range);
            OH_ArkUI_AnimatorOption_SetKeyframe(option, 0.5, 120.5, NUM_0); // 设置animator动画关键帧参数
            OH_ArkUI_AnimatorOption_SetKeyframeCurve(option, curve, NUM_0); // 设置animator动画关键帧曲线类型
            OH_ArkUI_AnimatorOption_RegisterOnFrameCallback(option, nullptr, [](ArkUI_AnimatorOnFrameEvent *event)
            {
                OH_ArkUI_AnimatorOnFrameEvent_GetUserData(event); // 获取动画事件对象中的用户自定义对象
                auto value = OH_ArkUI_AnimatorOnFrameEvent_GetValue(event); // 获取动画事件对象中的当前进度
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Init",
                    "CXX OH_ArkUI_AnimatorOption_RegisterOnFrameCallback  %{public}f", value);
                g_animator_button->SetWidth(value);
            });
            OH_ArkUI_AnimatorOption_RegisterOnFinishCallback(option, nullptr, [](ArkUI_AnimatorEvent* event)
            {
                OH_ArkUI_AnimatorEvent_GetUserData(event); // 获取动画事件对象中的用户自定义对象
            });
            OH_ArkUI_AnimatorOption_RegisterOnCancelCallback(option, nullptr, [](ArkUI_AnimatorEvent* event)
            {
            });
            OH_ArkUI_AnimatorOption_RegisterOnRepeatCallback(option, nullptr, [](ArkUI_AnimatorEvent* event)
            {
            });
            // 执行对应的动画
            animatorHandle = animateApi->createAnimator(context, option);
            
            auto duration = OH_ArkUI_AnimatorOption_GetDuration(option);
            auto delay = OH_ArkUI_AnimatorOption_GetDelay(option);
            auto iterations = OH_ArkUI_AnimatorOption_GetIterations(option);
            auto fill = OH_ArkUI_AnimatorOption_GetFill(option);
            auto direction = OH_ArkUI_AnimatorOption_GetDirection(option);
            auto curves = OH_ArkUI_AnimatorOption_GetCurve(option); // 获取animator动画插值曲线
            auto begin = OH_ArkUI_AnimatorOption_GetBegin(option);
            auto end = OH_ArkUI_AnimatorOption_GetEnd(option); // 获取animator动画插值终点
            auto expected = OH_ArkUI_AnimatorOption_GetExpectedFrameRateRange(option); // 获取关键帧动画参数的期望帧率
            auto keyframeTime = OH_ArkUI_AnimatorOption_GetKeyframeTime(option, NUM_0); // 获取animator动画关键帧时间
            auto keyframeValue = OH_ArkUI_AnimatorOption_GetKeyframeValue(option, NUM_0); // 获取animator动画关键帧数值
            auto keyframeCurve = OH_ArkUI_AnimatorOption_GetKeyframeCurve(option, NUM_0); // 获取animator动画关键帧动画插值曲线
            g_animator_text->AnimatorToString(duration, delay, iterations, fill, direction, begin,
                end, *expected, keyframeTime, keyframeValue);
        }
    };

    // 注册点击事件的回调函数
    createButton->RegisterNodeEventReceiver(onTouch);
    createButton->SetButtonLabel("create");
    // 创建容器，用于存放button按键
    auto buttoColumn = std::make_shared<ArkUIColumnNode>();
    buttoColumn->SetPadding(NUM_30, false); // 设置布局格式，调整组件内间距
    buttoColumn->SetWidth(NUM_300);
    // 创建容器，用于存放playButton按键
    auto playButtonColumn = std::make_shared<ArkUIColumnNode>();
    playButtonColumn->SetPadding(NUM_10, false); // 设置布局格式，调整组件内间距
    playButtonColumn->SetWidth(NUM_300);
    // 设置animator播放按钮
    auto playButton = std::make_shared<ArkUIButtonNode>();
    playButton->SetButtonLabel("play");
    playButton->RegisterNodeEvent(playButton->GetHandle(), NODE_ON_CLICK, NUM_4, nullptr);
    auto onTouchPlay = [](ArkUI_NodeEvent *event) {
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_4) {
            OH_ArkUI_Animator_Play(animatorHandle);
        }
    };
    playButton->RegisterNodeEventReceiver(onTouchPlay);
    // 设置animator结束按钮
    auto finishButton = std::make_shared<ArkUIButtonNode>();
    finishButton->SetButtonLabel("finish");
    finishButton->RegisterNodeEvent(finishButton->GetHandle(), NODE_ON_CLICK, NUM_5, nullptr);
    auto onTouchFinish = [](ArkUI_NodeEvent *event) {
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_5) {
            OH_ArkUI_Animator_Finish(animatorHandle);
        }
    };
    finishButton->RegisterNodeEventReceiver(onTouchFinish);
    // 创建容器，用于存放resetButton按键
    auto resetButtonColumn = std::make_shared<ArkUIColumnNode>();
    resetButtonColumn->SetPadding(NUM_10, false); // 设置布局格式，调整组件内间距
    resetButtonColumn->SetWidth(NUM_300);
    // 设置animator更新按钮
    auto resetButton = std::make_shared<ArkUIButtonNode>();
    resetButton->SetButtonLabel("reset");
    resetButton->RegisterNodeEvent(resetButton->GetHandle(), NODE_ON_CLICK, NUM_6, nullptr);
    auto onTouchReset = [](ArkUI_NodeEvent *event) {
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_6) {
            static ArkUI_AnimatorOption *option =  OH_ArkUI_AnimatorOption_Create(NUM_0); // Animator动画状态数
            OH_ArkUI_AnimatorOption_SetDuration(option, NUM_1000);
            OH_ArkUI_AnimatorOption_SetDelay(option, NUM_0);
            OH_ArkUI_AnimatorOption_SetIterations(option, NUM_4);
            // 根据自己得需要选择下述两种曲线适合得去设置OH_ArkUI_AnimatorOption_SetCurve
            auto curve = OH_ArkUI_Curve_CreateCurveByType(ARKUI_CURVE_EASE); // 动画以低速开始，然后加快，在结束前变慢
            auto stepsCurve = OH_ArkUI_Curve_CreateStepsCurve(NUM_20, true); // 构造阶梯曲线对象
            OH_ArkUI_AnimatorOption_SetCurve(option, curve);
            OH_ArkUI_AnimatorOption_SetBegin(option, NUM_200);
            OH_ArkUI_AnimatorOption_SetEnd(option, NUM_100);
            OH_ArkUI_AnimatorOption_RegisterOnFrameCallback(option, nullptr, [](ArkUI_AnimatorOnFrameEvent *event)
            {
                OH_ArkUI_AnimatorOnFrameEvent_GetUserData(event); // 获取动画事件对象中的用户自定义对象
                auto value = OH_ArkUI_AnimatorOnFrameEvent_GetValue(event); // 获取动画事件对象中的当前进度
                g_animator_button->SetWidth(value);
            });
            OH_ArkUI_Animator_ResetAnimatorOption(animatorHandle, option);
        }
    };
    resetButton->RegisterNodeEventReceiver(onTouchReset);
    // 设置animator暂停按钮
    auto pauseButton = std::make_shared<ArkUIButtonNode>();
    pauseButton->SetButtonLabel("pause");
    pauseButton->RegisterNodeEvent(pauseButton->GetHandle(), NODE_ON_CLICK, NUM_7, nullptr);
    auto onTouchPause = [](ArkUI_NodeEvent *event) {
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_7) {
            OH_ArkUI_Animator_Pause(animatorHandle);
        }
    };
    pauseButton->RegisterNodeEventReceiver(onTouchPause);
    // 创建容器，用于存放cancelButton按键
    auto cancelButtonColumn = std::make_shared<ArkUIColumnNode>();
    cancelButtonColumn->SetPadding(NUM_10, false); // 设置布局格式，调整组件内间距
    cancelButtonColumn->SetWidth(NUM_300);
    // 设置animator取消按钮
    auto cancelButton = std::make_shared<ArkUIButtonNode>();
    cancelButton->SetButtonLabel("cancel");
    cancelButton->RegisterNodeEvent(cancelButton->GetHandle(), NODE_ON_CLICK, NUM_8, nullptr);
    auto onTouchCancel = [](ArkUI_NodeEvent *event) {
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_8) {
            OH_ArkUI_Animator_Cancel(animatorHandle);
        }
    };
    cancelButton->RegisterNodeEventReceiver(onTouchCancel);
    // 设置animator以相反的顺序播放按钮
    auto reverseButton = std::make_shared<ArkUIButtonNode>();
    reverseButton->SetButtonLabel("reverse");
    reverseButton->RegisterNodeEvent(reverseButton->GetHandle(), NODE_ON_CLICK, NUM_9, nullptr);
    auto onTouchReverse = [](ArkUI_NodeEvent *event) {
        // 点击button按钮时触发该逻辑
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == NUM_9) {
            OH_ArkUI_Animator_Reverse(animatorHandle);
        }
    };
    reverseButton->RegisterNodeEventReceiver(onTouchReverse);
    // 将button挂载在column上，返回column节点
    column->AddChild(g_animator_text);
    column->AddChild(textNode);
    column->AddChild(button);
    buttoColumn->AddChild(createButton);
    playButtonColumn->AddChild(playButton);
    buttoColumn->AddChild(playButtonColumn);
    buttoColumn->AddChild(finishButton);
    resetButtonColumn->AddChild(resetButton);
    buttoColumn->AddChild(resetButtonColumn);
    buttoColumn->AddChild(pauseButton);
    cancelButtonColumn->AddChild(cancelButton);
    buttoColumn->AddChild(cancelButtonColumn);
    buttoColumn->AddChild(reverseButton);
    column->AddChild(buttoColumn);
    return column;
}

std::shared_ptr<ArkUIBaseNode> CreateAnimateRootNode()
{
    auto scroll = std::make_shared<ArkUIScrollNode>();
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetPadding(NUM_30, false); // 设置布局格式，调整组件内间距
    column->SetHeight(NUM_1500);
    scroll->SetWidth(NUM_400);
    scroll->SetBackgroundColor(0xFFEDF3FF);
    auto keyFrameNode = CreateKeyFrameAnimeteto();
    auto animeteToNode = CreateAnimeteto();
    auto transitionEffectNode = CreateTransitionEffect();
    auto animatorNode = CreateAnimator();
    column->AddChild(keyFrameNode);
    column->AddChild(animeteToNode);
    column->AddChild(transitionEffectNode);
    column->AddChild(animatorNode);
    scroll->AddChild(column);
    return scroll;
}
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIANIMATE_H