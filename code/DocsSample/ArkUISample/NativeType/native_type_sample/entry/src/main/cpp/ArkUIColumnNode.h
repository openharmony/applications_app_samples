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

#ifndef MYAPPLICATION_ARKUICOLUMNNODE_H
#define MYAPPLICATION_ARKUICOLUMNNODE_H

#include "ArkUINode.h"
#include <cstdint>

namespace NativeModule {
class ArkUIColumnNode : public ArkUINode {
public:
    ArkUIColumnNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_COLUMN)) {}
    
    void SetTranslate(float x, float y, float z)
    {
        ArkUI_NumberValue nums[NUMBER_3] = {x, y, z};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_3};
        nativeModule_->setAttribute(handle_, NODE_TRANSLATE, &item);
    }
    void SetScale(float x, float y)
    {
        ArkUI_NumberValue nums[NUMBER_2] = {x, y};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_2};
        nativeModule_->setAttribute(handle_, NODE_SCALE, &item);
    }
    void SetRotate(float x, float y, float z, float angle, float center)
    {
        ArkUI_NumberValue nums[NUMBER_5] = {x, y, z, angle, center};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_5};
        nativeModule_->setAttribute(handle_, NODE_ROTATE, &item);
    }
    void SetBrightness(float light)
    {
        ArkUI_NumberValue nums[NUMBER_1] = {light};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        nativeModule_->setAttribute(handle_, NODE_BRIGHTNESS, &item);
    }
    void SetSaturate(float number)
    {
        ArkUI_NumberValue nums[NUMBER_1] = {number};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        nativeModule_->setAttribute(handle_, NODE_SATURATION, &item);
    }
    int32_t SetLinearGradient(float angle, int32_t direction, int32_t repeat)
    {
        ArkUI_NumberValue nums[NUMBER_3];
        nums[NUMBER_0].f32 = angle;
        nums[NUMBER_1].i32 = direction;
        nums[NUMBER_2].i32 = repeat;
        ArkUI_ColorStop colorStop;
        const uint32_t colors[] = {COLOR_1, COLOR_2, COLOR_3};
        float stops[] = {NUMBER_00, NUMBER_05, NUMBER_1F};
        int size = NUMBER_3;
        colorStop.colors = colors;
        colorStop.stops = stops;
        colorStop.size = size;
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_3, .object = &colorStop};
        auto err = nativeModule_->setAttribute(handle_, NODE_LINEAR_GRADIENT, &item);
        return err;
    }
    void SetOpacity(float number)
    {
        ArkUI_NumberValue nums[NUMBER_1] = {number};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        nativeModule_->setAttribute(handle_, NODE_OPACITY, &item);
    }
    void SetBorderRadius(float number)
    {
        ArkUI_NumberValue nums[NUMBER_1] = {number};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        nativeModule_->setAttribute(handle_, NODE_BORDER_RADIUS, &item);
    }
    int32_t SetClip(int32_t number)
    {
        ArkUI_NumberValue nums[NUMBER_1];
        nums[NUMBER_0].i32 = number;
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_CLIP, &item);
        return err;
    }
    int32_t SetCircleShape(int32_t number, float width, float height)
    {
        ArkUI_NumberValue nums[NUMBER_3];
        nums[NUMBER_0].i32 = number;
        nums[NUMBER_1].f32 = width;
        nums[NUMBER_2].f32 = height;
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_3};
        auto err = nativeModule_->setAttribute(handle_, NODE_CLIP_SHAPE, &item);
        return err;
    }
    int32_t SetTransform()
    {
        ArkUI_NumberValue value2[NUMBER_16];
        for (int i = NUMBER_0; i < NUMBER_16; i++) {
            value2[i].f32 = NUMBER_0;
        }
        value2[NUMBER_0].f32 = NUMBER_1;
        value2[NUMBER_1].f32 = NUMBER_1;
        ArkUI_AttributeItem item = { .value = value2, .size = NUMBER_3 };
        auto err = nativeModule_->setAttribute(handle_, NODE_TRANSFORM, &item);
        return err;
    }
    int32_t SetShadow(int32_t number)
    {
        ArkUI_NumberValue nums[NUMBER_0];
        nums[NUMBER_0].i32 = number;
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_SHADOW, &item);
        return err;
    }
    int32_t SetBackgroundBlurStyle(int32_t number)
    {
        ArkUI_NumberValue blurStyle[NUMBER_6];
        blurStyle[NUMBER_0].i32 = number;
        blurStyle[NUMBER_2].i32 = ARKUI_ADAPTIVE_COLOR_AVERAGE;
        ArkUI_AttributeItem item = { .value = blurStyle, .size = NUMBER_2};
        auto err = nativeModule_->setAttribute(handle_, NODE_BACKGROUND_BLUR_STYLE, &item);
        return err;
    }
    int32_t SetTransformCenter(float number)
    {
        ArkUI_NumberValue centerPointArray[] = {number};
        ArkUI_AttributeItem item = { .value = centerPointArray, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_TRANSFORM_CENTER, &item);
        return err;
    }
    int32_t SetSweepGradient()
    {
        ArkUI_NumberValue nums[NUMBER_6];
        nums[NUMBER_0].f32 = SMALL_LENGTH;
        nums[NUMBER_1].f32 = SMALL_LENGTH;
        nums[NUMBER_2].f32 = NUMBER_0;
        nums[NUMBER_3].f32 = NUMBER_359;
        nums[NUMBER_4].f32 = NUMBER_45;
        nums[NUMBER_5].f32 = NUMBER_1;
        ArkUI_ColorStop colorStop;
        const uint32_t colors[] = {COLOR_1, COLOR_2, COLOR_3};
        float stops[] = {NUMBER_00, NUMBER_05, NUMBER_1F};
        int size = NUMBER_3;
        colorStop.colors = colors;
        colorStop.stops = stops;
        colorStop.size = size;
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_6, .object = &colorStop };
        auto err = nativeModule_->setAttribute(handle_, NODE_SWEEP_GRADIENT, &item);
        return err;
    }
    int32_t SetRadialGradient()
    {
        ArkUI_NumberValue nums[NUMBER_4];
        nums[NUMBER_0].f32 = SMALL_LENGTH;
        nums[NUMBER_1].f32 = SMALL_LENGTH;
        nums[NUMBER_2].f32 = NUMBER_60;
        nums[NUMBER_3].f32 = NUMBER_1;
        ArkUI_ColorStop colorStop;
        const uint32_t colors[] = {COLOR_1, COLOR_2, COLOR_3};
        float stops[] = {NUMBER_00, NUMBER_05, NUMBER_1F};
        int size = NUMBER_3;
        colorStop.colors = colors;
        colorStop.stops = stops;
        colorStop.size = size;
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_4, .object = &colorStop };
        auto err = nativeModule_->setAttribute(handle_, NODE_RADIAL_GRADIENT, &item);
        return err;
    }
    int32_t SetMask()
    {
        ArkUI_NumberValue nums[NUMBER_4];
        nums[NUMBER_0].i32 = ARKUI_MASK_TYPE_PROGRESS;
        nums[NUMBER_1].f32 = NUMBER_10;
        nums[NUMBER_2].f32 = NUMBER_100;
        nums[NUMBER_3].u32 = COLOR_WHITE;
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_4 };
        auto err = nativeModule_->setAttribute(handle_, NODE_MASK, &item);
        return err;
    }
    int32_t SetGrayScale(float number)
    {
        ArkUI_NumberValue nums[] = { number };
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_GRAY_SCALE, &item);
        return err;
    }
    int32_t SetInvert(float number)
    {
        ArkUI_NumberValue nums[] = { number };
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_INVERT, &item);
        return err;
    }
    int32_t SetSepia(float number)
    {
        ArkUI_NumberValue nums[] = { number };
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_SEPIA, &item);
        return err;
    }
    int32_t SetContrast(float number)
    {
        ArkUI_NumberValue nums[] = { number };
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_CONTRAST, &item);
        return err;
    }
    ~ArkUIColumnNode() override {}
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUILISTNODE_H