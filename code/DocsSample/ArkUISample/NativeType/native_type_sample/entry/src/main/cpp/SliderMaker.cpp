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
#include "baseUtils.h"
#include "SliderMaker.h"
constexpr int32_t NUM_5 = 5;
constexpr int32_t NUM_10 = 10;
constexpr int32_t NUM_20 = 20;
// 设置BlockStyle属性
void SetSliderBlockStyleType(int32_t sliderBlockStyle, ArkUI_NodeHandle slider)
{
    ArkUI_SliderBlockStyle BlockStyleType = static_cast<ArkUI_SliderBlockStyle>(sliderBlockStyle);
    if (BlockStyleType == ARKUI_SLIDER_BLOCK_STYLE_DEFAULT) {  // 使用默认滑块（圆形）
        ArkUI_NumberValue value[] = {{.i32 = sliderBlockStyle}};
        ArkUI_AttributeItem value_item = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_BLOCK_STYLE, &value_item);
    } else if (BlockStyleType == ARKUI_SLIDER_BLOCK_STYLE_IMAGE) {  // 使用图片资源作为滑块
        const char *imageUrl = "./resources/base/media/640.jpg";
        ArkUI_NumberValue value[] = {{.i32 = sliderBlockStyle}};
        ArkUI_AttributeItem value_item = {value, sizeof(value) / sizeof(ArkUI_NumberValue), imageUrl};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_BLOCK_STYLE, &value_item);
    } else if (
        BlockStyleType ==
        ARKUI_SLIDER_BLOCK_STYLE_SHAPE) {  // 使用自定义形状作为滑块，这里以矩形为例展示如何设置自定义形状的滑块。
        int32_t shapeType = ARKUI_SHAPE_TYPE_RECTANGLE;
        float rectangleWidth = NUM_20;
        float rectangleHeight = NUM_20;
        float rectangularRoundedWidth = NUM_5;
        float rectangularRoundedHeight = NUM_5;

        ArkUI_NumberValue value[] = {{.i32 = sliderBlockStyle},        {.i32 = shapeType},
                                     {.f32 = rectangleWidth},          {.f32 = rectangleHeight},
                                     {.f32 = rectangularRoundedWidth}, {.f32 = rectangularRoundedHeight}};
        ArkUI_AttributeItem value_item = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_BLOCK_STYLE, &value_item);
        ArkUI_NumberValue colorValue[] = {{.u32 = 0xFFFF0000}};
        ArkUI_AttributeItem colorValue_item = {colorValue, sizeof(colorValue) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_BLOCK_COLOR, &colorValue_item);  // 设置滑块颜色为红色
    }
}

//  设置方向属性
void SetSliderDirectionType(int32_t sliderDirection, ArkUI_NodeHandle slider)
{
    ArkUI_SliderDirection sliderDirectionType = static_cast<ArkUI_SliderDirection>(sliderDirection);
    if (sliderDirectionType == ARKUI_SLIDER_DIRECTION_VERTICAL) {  // 方向为纵向
        ArkUI_NumberValue value[] = {{.i32 = sliderDirection}};
        ArkUI_AttributeItem value_item = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_DIRECTION, &value_item);
    } else if (sliderDirectionType == ARKUI_SLIDER_DIRECTION_HORIZONTAL) {  // 方向为横向
        ArkUI_NumberValue value[] = {{.i32 = sliderDirection}};
        ArkUI_AttributeItem value_item = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_DIRECTION, &value_item);
    }
}

void SetSliderStyle(int32_t sliderStyle, ArkUI_NodeHandle slider)
{
    // 设置滑块与滑轨显示样式
    int32_t ret = 0;
    ArkUI_SliderStyle sliderStyleType = static_cast<ArkUI_SliderStyle>(sliderStyle);
    if (sliderStyleType == ARKUI_SLIDER_STYLE_OUT_SET) {  // 滑块在滑轨上
        ArkUI_NumberValue value0[] = {{.i32 = sliderStyle}};
        ArkUI_AttributeItem value_item0 = {value0, sizeof(value0) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_STYLE, &value_item0);

        ArkUI_NumberValue value1[] = {{.f32 = -1}};
        ArkUI_AttributeItem value_item1 = {value1, sizeof(value1) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_TRACK_THICKNESS, &value_item1);
    } else if (sliderStyleType == ARKUI_SLIDER_STYLE_IN_SET) {  // 滑块在滑轨内
        ArkUI_NumberValue value0[] = {{.i32 = sliderStyle}};
        ArkUI_AttributeItem value_item0 = {value0, sizeof(value0) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_STYLE, &value_item0);

        ArkUI_NumberValue value1[] = {{.f32 = NUM_5}};
        ArkUI_AttributeItem value_item1 = {value1, sizeof(value1) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_TRACK_THICKNESS, &value_item1);
    } else if (sliderStyleType == ARKUI_SLIDER_STYLE_NONE) {  // 无滑块
        ArkUI_NumberValue value0[] = {{.i32 = sliderStyle}};
        ArkUI_AttributeItem value_item0 = {value0, sizeof(value0) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_STYLE, &value_item0);

        ArkUI_NumberValue value1[] = {{.f32 = NUM_5}};
        ArkUI_AttributeItem value_item1 = {value1, sizeof(value1) / sizeof(ArkUI_NumberValue)};
        Manager::nodeAPI_->setAttribute(slider, NODE_SLIDER_TRACK_THICKNESS, &value_item1);
    }
}

ArkUI_NodeHandle SliderMaker::SetSliderProperties(int32_t sliderBlockStyle, int32_t sliderDirection,
                                                  int32_t sliderStyle)
{
    ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    if (!column) {
        return nullptr;
    }
    ArkUI_NodeHandle slider = Manager::nodeAPI_->createNode(ARKUI_NODE_SLIDER);
    SetSliderBlockStyleType(sliderBlockStyle, slider);
    //  设置方向属性
    SetSliderDirectionType(sliderDirection, slider);
    // 设置滑块与滑轨显示样式
    SetSliderStyle(sliderStyle, slider);

    Manager::nodeAPI_->addChild(column, slider);
    return column;
}