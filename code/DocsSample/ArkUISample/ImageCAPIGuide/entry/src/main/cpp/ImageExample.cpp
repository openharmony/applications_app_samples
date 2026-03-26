/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

// entry/src/main/cpp/ImageExample.cpp
#include "ImageExample.h"
#include "NativeEntry.h"
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <arkui/native_interface.h>
#include <hilog/log.h>

// 日志标签
#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "ImageExample"

// 全局事件接收器
// [start image_receiver]
void GlobalEventReceiver(ArkUI_NodeEvent *event)
{
    auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
    if (eventType == NODE_IMAGE_ON_COMPLETE) {
        ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        if (componentEvent != nullptr) {
            OH_LOG_INFO(LOG_APP, "Image loaded: %.0fx%.0f",
                        componentEvent->data[0].f32, componentEvent->data[1].f32);
        }
    } else if (eventType == NODE_IMAGE_ON_ERROR) {
        ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        if (componentEvent != nullptr) {
            OH_LOG_ERROR(LOG_APP, "Image load failed, error: %d", componentEvent->data[0].i32);
        }
    } else if (eventType == NODE_IMAGE_ON_SVG_PLAY_FINISH) {
        OH_LOG_INFO(LOG_APP, "SVG animation play finished");
    }
}
// [end image_receiver]

// 创建图片组件界面
// [start image_create]

// 函数1：初始化 + Column + 第一张图
ArkUI_NodeHandle CreateImageColumnAndFirstImage()
{
    auto nativeNodeApi = NativeModule::GetNativeNodeAPI();
    if (nativeNodeApi == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Get native node API failed");
        return nullptr;
    }

    // 注册全局事件接收器
    nativeNodeApi->registerNodeEventReceiver(GlobalEventReceiver);
    
    // 创建Column容器
    ArkUI_NodeHandle column = nativeNodeApi->createNode(ARKUI_NODE_COLUMN);
    if (column == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Create Column failed");
        return nullptr;
    }

    // 设置Column padding属性
    ArkUI_NumberValue paddingValue[] = {{.f32 = 20.0f}};
    ArkUI_AttributeItem paddingItem = {paddingValue, 1};
    nativeNodeApi->setAttribute(column, NODE_PADDING, &paddingItem);

    // 创建Image组件1 - 基础图片
    ArkUI_NodeHandle image1 = nativeNodeApi->createNode(ARKUI_NODE_IMAGE);
    if (image1 != nullptr) {
        // 设置图片源（使用rawfile资源）
        // [start image_source]
        ArkUI_AttributeItem srcItem = {nullptr, 0, "entry/resources/rawfile/pic0.png"};
        nativeNodeApi->setAttribute(image1, NODE_IMAGE_SRC, &srcItem);
        // [end image_source]

        // 设置宽高
        ArkUI_NumberValue widthValue[] = {{.f32 = 200.0f}};
        ArkUI_AttributeItem widthItem = {widthValue, 1};
        nativeNodeApi->setAttribute(image1, NODE_WIDTH, &widthItem);

        ArkUI_NumberValue heightValue[] = {{.f32 = 200.0f}};
        ArkUI_AttributeItem heightItem = {heightValue, 1};
        nativeNodeApi->setAttribute(image1, NODE_HEIGHT, &heightItem);

        ArkUI_NumberValue borderWidthValue[] = {{.f32 = 2.0f}};
        ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
        nativeNodeApi->setAttribute(image1, NODE_BORDER_WIDTH, &borderWidthItem);

        // 设置缩放类型
        // [start image_zoom]
        ArkUI_NumberValue fitValue[] = {{.i32 = ARKUI_OBJECT_FIT_CONTAIN}};
        ArkUI_AttributeItem fitItem = {fitValue, 1};
        nativeNodeApi->setAttribute(image1, NODE_IMAGE_OBJECT_FIT, &fitItem);
        // [end image_zoom]

        // 设置插值效果
        // [start image_interpolation]
        ArkUI_NumberValue interpolationValue[] = {{.i32 = ARKUI_IMAGE_INTERPOLATION_HIGH}};
        ArkUI_AttributeItem interpolationItem = {interpolationValue, 1};
        nativeNodeApi->setAttribute(image1, NODE_IMAGE_INTERPOLATION, &interpolationItem);
        // [end image_interpolation]

        // 注册事件
        nativeNodeApi->registerNodeEvent(image1, NODE_IMAGE_ON_COMPLETE, 0, nullptr);
        nativeNodeApi->registerNodeEvent(image1, NODE_IMAGE_ON_ERROR, 0, nullptr);

        // 添加到Column
        nativeNodeApi->addChild(column, image1);
    }
    return column;
}

// 函数2：添加第二张图
void AddSecondImage(ArkUI_NodeHandle column)
{
    auto nativeNodeApi = NativeModule::GetNativeNodeAPI();
    if (nativeNodeApi == nullptr || column == nullptr) {
        return;
    };

    // 创建Image组件2 - 带填充颜色的SVG
    ArkUI_NodeHandle image2 = nativeNodeApi->createNode(ARKUI_NODE_IMAGE);
    if (image2 != nullptr) {
        // 设置图片源（可以是SVG）
        // [start image_source]
        ArkUI_AttributeItem srcItem2 = {nullptr, 0, "entry/resources/rawfile/pic1.svg"};
        nativeNodeApi->setAttribute(image2, NODE_IMAGE_SRC, &srcItem2);
        // [end image_source]

        // 设置宽高
        ArkUI_NumberValue widthValue2[] = {{.f32 = 200.0f}};
        ArkUI_AttributeItem widthItem2 = {widthValue2, 1};
        nativeNodeApi->setAttribute(image2, NODE_WIDTH, &widthItem2);

        ArkUI_NumberValue heightValue2[] = {{.f32 = 200.0f}};
        ArkUI_AttributeItem heightItem2 = {heightValue2, 1};
        nativeNodeApi->setAttribute(image2, NODE_HEIGHT, &heightItem2);

        ArkUI_NumberValue borderWidthValue[] = {{.f32 = 2.0f}};
        ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
        nativeNodeApi->setAttribute(image2, NODE_BORDER_WIDTH, &borderWidthItem);

        // 设置填充颜色（蓝色）
        // [start image_fillcolor]
        ArkUI_NumberValue fillColorValue[] = {{.u32 = 0xFF007DFF}};
        ArkUI_AttributeItem fillColorItem = {fillColorValue, 1};
        nativeNodeApi->setAttribute(image2, NODE_IMAGE_FILL_COLOR, &fillColorItem);
        // [end image_fillcolor]

        // 添加到Column
        nativeNodeApi->addChild(column, image2);
    }
}

// 函数3：添加第三张图
void AddThirdImage(ArkUI_NodeHandle column)
{
    auto nativeNodeApi = NativeModule::GetNativeNodeAPI();
    if (nativeNodeApi == nullptr || column == nullptr) {
        return;
    };

    // 创建Image组件3 - 带占位图
    ArkUI_NodeHandle image3 = nativeNodeApi->createNode(ARKUI_NODE_IMAGE);
    if (image3 != nullptr) {
        // 设置网络图片源
        // [start image_source]
        ArkUI_AttributeItem srcItem3 = {nullptr, 0, "entry/resources/rawfile/pic2.png"};
        nativeNodeApi->setAttribute(image3, NODE_IMAGE_SRC, &srcItem3);
        // [end image_source]

        // 设置宽高
        ArkUI_NumberValue widthValue3[] = {{.f32 = 200.0f}};
        ArkUI_AttributeItem widthItem3 = {widthValue3, 1};
        nativeNodeApi->setAttribute(image3, NODE_WIDTH, &widthItem3);

        ArkUI_NumberValue heightValue3[] = {{.f32 = 200.0f}};
        ArkUI_AttributeItem heightItem3 = {heightValue3, 1};
        nativeNodeApi->setAttribute(image3, NODE_HEIGHT, &heightItem3);

        ArkUI_NumberValue borderWidthValue[] = {{.f32 = 2.0f}};
        ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
        nativeNodeApi->setAttribute(image3, NODE_BORDER_WIDTH, &borderWidthItem);

        // 设置占位图
        // [start image_source]
        ArkUI_AttributeItem altItem = {nullptr, 0, "entry/resources/rawfile/pic3.png"};
        nativeNodeApi->setAttribute(image3, NODE_IMAGE_ALT, &altItem);
        // [end image_source]

        // 设置解码尺寸
        // [start image_decode_size]
        ArkUI_NumberValue sourceSizeValue[] = {{.i32 = 150}, {.i32 = 150}};
        ArkUI_AttributeItem sourceSizeItem = {sourceSizeValue, 2};
        nativeNodeApi->setAttribute(image3, NODE_IMAGE_SOURCE_SIZE, &sourceSizeItem);
        // [end image_decode_size]

        // 添加到Column
        nativeNodeApi->addChild(column, image3);
    }
}
// [end image_create]

// 主函数（调用）
ArkUI_NodeHandle CreateImageExample()
{
    ArkUI_NodeHandle column = CreateImageColumnAndFirstImage();
    AddSecondImage(column);
    AddThirdImage(column);
    return column;
}
