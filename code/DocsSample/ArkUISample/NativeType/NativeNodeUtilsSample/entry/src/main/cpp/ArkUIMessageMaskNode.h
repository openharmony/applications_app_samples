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
// ArkUIMessageMaskNode.h
// 通过前景绘制实现消息蒙层示例
// [Start messageMaskNode_start]
#ifndef MYAPPLICATION_ARKUIMESSAGEMASKNODE_H
#define MYAPPLICATION_ARKUIMESSAGEMASKNODE_H

#include <cmath>
#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_color_filter.h>
#include <native_drawing/drawing_font.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_path.h>
#include <native_drawing/drawing_pen.h>
#include <native_drawing/drawing_point.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_round_rect.h>
#include <native_drawing/drawing_text_typography.h>

#include <string>

#include "ArkUINode.h"

namespace NativeModule {
class ArkUIMessageMaskNode : public ArkUINode {
public:
    // 使用自定义组件类型ARKUI_NODE_CUSTOM创建组件
    ArkUIMessageMaskNode()
        : ArkUINode(
              (NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_CUSTOM))
    {
        // 注册自定义事件监听器
        nativeModule_->addNodeCustomEventReceiver(handle_, OnStaticCustomEvent);
        // 声明自定义事件并转递自身作为自定义数据
        nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_FRONT, 0, this);
        nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW, 0, this);
        nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_BEHIND, 0, this);
    }

    ~ArkUIMessageMaskNode() override
    {
        // 反注册自定义事件监听器
        nativeModule_->removeNodeCustomEventReceiver(handle_, OnStaticCustomEvent);
        // 取消声明自定义事件
        nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_FRONT);
        nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW);
        nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_BEHIND);
    }

    // 设置消息文本
    void SetMessage(const std::string& message)
    {
        message_ = message;
        nativeModule_->markDirty(handle_, NODE_NEED_RENDER);
    }

    // 设置是否显示蒙层
    void SetMaskVisible(bool visible)
    {
        maskVisible_ = visible;
        nativeModule_->markDirty(handle_, NODE_NEED_RENDER);
    }

private:
    static constexpr int starDecorationCount = 3;
    static constexpr int starPointCount = 5;
    static constexpr float starStartAngleDegrees = -90.0f;
    static constexpr float starAngleStepDegrees = 72.0f;
    static constexpr float starInnerAngleOffsetDegrees = 36.0f;
    static constexpr float starInnerRadiusRatio = 0.4f;
    static constexpr float degreeToRadian = 3.14159265f / 180.0f;
    static constexpr float messageTextFontSize = 23.0f;

    static void OnStaticCustomEvent(ArkUI_NodeCustomEvent* event)
    {
        auto customNode = reinterpret_cast<ArkUIMessageMaskNode*>(OH_ArkUI_NodeCustomEvent_GetUserData(event));
        auto type = OH_ArkUI_NodeCustomEvent_GetEventType(event);
        switch (type) {
            case ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_BEHIND:
                customNode->OnDrawBehind(event);
                break;
            case ARKUI_NODE_CUSTOM_EVENT_ON_DRAW:
                customNode->OnDraw(event);
                break;
            case ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_FRONT:
                customNode->OnDrawFront(event);
                break;
            default:
                break;
        }
    }

    // 自定义内容层背景：绘制聊天界面背景
    void OnDrawBehind(ArkUI_NodeCustomEvent* event)
    {
        auto drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
        auto canvas = reinterpret_cast<OH_Drawing_Canvas*>(OH_ArkUI_DrawContext_GetCanvas(drawContext));
        auto size = OH_ArkUI_DrawContext_GetSize(drawContext);

        // 绘制浅灰色背景
        auto bgRect = OH_Drawing_RectCreate(0, 0, size.width, size.height);
        auto brush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(brush, 0xFFF5F5F5);
        OH_Drawing_CanvasAttachBrush(canvas, brush);
        OH_Drawing_CanvasDrawRect(canvas, bgRect);
        OH_Drawing_CanvasDetachBrush(canvas);
        OH_Drawing_BrushDestroy(brush);
        OH_Drawing_RectDestroy(bgRect);
    }

    // 自定义内容层
    void OnDraw(ArkUI_NodeCustomEvent* event)
    {
        auto drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
        auto canvas = reinterpret_cast<OH_Drawing_Canvas*>(OH_ArkUI_DrawContext_GetCanvas(drawContext));
        auto size = OH_ArkUI_DrawContext_GetSize(drawContext);

        float padding = 50.0f;
        float bubbleWidth = size.width - 2 * padding;
        float bubbleHeight = size.height - 2 * padding;
        float cornerRadius = 8.0f;
        float textX = padding + 15.0f;
        float textY = padding + 20.0f;
        float textMaxWidth = bubbleWidth - 30.0f;

        // 绘制气泡阴影
        auto shadowRect = OH_Drawing_RectCreate(
            padding + 2, padding + 2, padding + bubbleWidth + 2, padding + bubbleHeight + 2);
        auto* shadowRoundRect = OH_Drawing_RoundRectCreate(shadowRect, cornerRadius, cornerRadius);
        auto shadowBrush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(shadowBrush, 0x30000000);
        OH_Drawing_CanvasAttachBrush(canvas, shadowBrush);
        OH_Drawing_CanvasDrawRoundRect(canvas, shadowRoundRect);
        OH_Drawing_CanvasDetachBrush(canvas);
        OH_Drawing_BrushDestroy(shadowBrush);
        OH_Drawing_RoundRectDestroy(shadowRoundRect);
        OH_Drawing_RectDestroy(shadowRect);

        // 绘制绿色气泡背景
        auto bubbleRect = OH_Drawing_RectCreate(padding, padding, padding + bubbleWidth, padding + bubbleHeight);
        auto* bubbleRoundRect = OH_Drawing_RoundRectCreate(bubbleRect, cornerRadius, cornerRadius);
        auto bubbleBrush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(bubbleBrush, 0xFF95EC69);
        OH_Drawing_CanvasAttachBrush(canvas, bubbleBrush);
        OH_Drawing_CanvasDrawRoundRect(canvas, bubbleRoundRect);
        OH_Drawing_CanvasDetachBrush(canvas);
        OH_Drawing_BrushDestroy(bubbleBrush);

        // 绘制气泡边框
        auto pen = OH_Drawing_PenCreate();
        OH_Drawing_PenSetWidth(pen, 1.0f);
        OH_Drawing_PenSetColor(pen, 0xFF7FD65A);
        OH_Drawing_CanvasAttachPen(canvas, pen);
        OH_Drawing_CanvasDrawRoundRect(canvas, bubbleRoundRect);
        OH_Drawing_CanvasDetachPen(canvas);
        OH_Drawing_PenDestroy(pen);
        OH_Drawing_RoundRectDestroy(bubbleRoundRect);
        OH_Drawing_RectDestroy(bubbleRect);

        // 绘制消息文本
        DrawMessageText(canvas, textX, textY, textMaxWidth);
    }

    // 自定义内容前景层：绘制装饰性蒙层
    void OnDrawFront(ArkUI_NodeCustomEvent* event)
    {
        if (!maskVisible_) {
            return;
        }

        auto drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
        auto canvas = reinterpret_cast<OH_Drawing_Canvas*>(OH_ArkUI_DrawContext_GetCanvas(drawContext));

        float padding = 50.0f;

        auto starBrush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(starBrush, 0x88FFFFFF);
        OH_Drawing_CanvasAttachBrush(canvas, starBrush);

        const float starRadius = 13.0f;
        const float textLeftX = padding + 26.0f;
        const float textRightX = padding + 146.0f;
        const float starBottomY = padding + 50.0f;
        const float starTopY = padding + 10.0f;
        for (int i = 0; i < starDecorationCount; ++i) {
            float t = static_cast<float>(i) / static_cast<float>(starDecorationCount - 1);
            float starX = textLeftX + (textRightX - textLeftX) * t;
            float starY = starBottomY + (starTopY - starBottomY) * t;
            DrawStar(canvas, starX, starY, starRadius);
        }

        OH_Drawing_CanvasDetachBrush(canvas);
        OH_Drawing_BrushDestroy(starBrush);
    }

    // 绘制五角星
    void DrawStar(OH_Drawing_Canvas* canvas, float cx, float cy, float radius)
    {
        auto path = OH_Drawing_PathCreate();
        for (int i = 0; i < starPointCount; ++i) {
            float angle = starStartAngleDegrees + i * starAngleStepDegrees;
            float rad = angle * degreeToRadian;
            float x = cx + radius * std::cos(rad);
            float y = cy + radius * std::sin(rad);
            if (i == 0) {
                OH_Drawing_PathMoveTo(path, x, y);
            } else {
                OH_Drawing_PathLineTo(path, x, y);
            }

            // 内角点
            float innerAngle = angle + starInnerAngleOffsetDegrees;
            float innerRad = innerAngle * degreeToRadian;
            float innerX = cx + radius * starInnerRadiusRatio * std::cos(innerRad);
            float innerY = cy + radius * starInnerRadiusRatio * std::sin(innerRad);
            OH_Drawing_PathLineTo(path, innerX, innerY);
        }

        OH_Drawing_PathClose(path);
        OH_Drawing_CanvasDrawPath(canvas, path);
        OH_Drawing_PathDestroy(path);
    }

    // 绘制消息文本
    void DrawMessageText(OH_Drawing_Canvas* canvas, float x, float y, float maxWidth)
    {
        // 创建字体集合
        auto* fontCollection = OH_Drawing_CreateFontCollection();

        // 创建排版样式
        auto* typographyStyle = OH_Drawing_CreateTypographyStyle();
        OH_Drawing_SetTypographyTextAlign(typographyStyle, TEXT_ALIGN_LEFT);

        // 创建排版处理器
        auto* typographyHandler = OH_Drawing_CreateTypographyHandler(typographyStyle, fontCollection);

        // 创建文本样式
        auto* textStyle = OH_Drawing_CreateTextStyle();
        OH_Drawing_SetTextStyleColor(textStyle, 0xFF000000); // 纯黑
        OH_Drawing_SetTextStyleFontSize(textStyle, messageTextFontSize);
        OH_Drawing_SetTextStyleFontWeight(textStyle, FONT_WEIGHT_400);
        auto textBrush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(textBrush, 0xFF000000);
        OH_Drawing_SetTextStyleForegroundBrush(textStyle, textBrush);

        // 添加文本
        OH_Drawing_TypographyHandlerPushTextStyle(typographyHandler, textStyle);
        OH_Drawing_TypographyHandlerAddText(typographyHandler, message_.c_str());
        OH_Drawing_TypographyHandlerPopTextStyle(typographyHandler);

        // 创建排版对象并绘制
        auto* typography = OH_Drawing_CreateTypography(typographyHandler);
        OH_Drawing_TypographyLayout(typography, maxWidth);
        OH_Drawing_TypographyPaint(typography, canvas, x, y);

        // 释放资源
        OH_Drawing_DestroyTextStyle(textStyle);
        OH_Drawing_DestroyTypography(typography);
        OH_Drawing_DestroyTypographyHandler(typographyHandler);
        OH_Drawing_DestroyTypographyStyle(typographyStyle);
        OH_Drawing_DestroyFontCollection(fontCollection);
        OH_Drawing_BrushDestroy(textBrush);
    }

    std::string message_ = "这是一条消息提示";
    bool maskVisible_ = false;
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIMESSAGEMASKNODE_H
// [End messageMaskNode_start]
