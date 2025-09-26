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

#ifndef MYAPPLICATION_ARKUINODE_H
#define MYAPPLICATION_ARKUINODE_H

#include "ArkUIBaseNode.h"
#include "NativeModule.h"
#include <arkui/native_animate.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <cstdint>
#include "ArkUINumber.h"

namespace NativeModule {
class ArkUINode : public ArkUIBaseNode {
public:
    explicit ArkUINode(ArkUI_NodeHandle handle) : ArkUIBaseNode(handle) {}

    ~ArkUINode() override {}

    void SetWidth(float width)
    {
        ArkUI_NumberValue value[] = {{.f32 = width}};
        ArkUI_AttributeItem item = {value, NUMBER_1};
        nativeModule_->setAttribute(handle_, NODE_WIDTH, &item);
    }
    void SetPercentWidth(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, NUMBER_1};
        nativeModule_->setAttribute(handle_, NODE_WIDTH_PERCENT, &item);
    }
    void SetHeight(float height)
    {
        ArkUI_NumberValue value[] = {{.f32 = height}};
        ArkUI_AttributeItem item = {value, NUMBER_1};
        nativeModule_->setAttribute(handle_, NODE_HEIGHT, &item);
    }
    void SetPercentHeight(float percent)
    {
        ArkUI_NumberValue value[] = {{.f32 = percent}};
        ArkUI_AttributeItem item = {value, NUMBER_1};
        nativeModule_->setAttribute(handle_, NODE_HEIGHT_PERCENT, &item);
    }
    void SetBackgroundColor(uint32_t color)
    {
        ArkUI_NumberValue value[] = {{.u32 = color}};
        ArkUI_AttributeItem item = {value, NUMBER_1};
        nativeModule_->setAttribute(handle_, NODE_BACKGROUND_COLOR, &item);
    }
    int32_t SetZIndex(int32_t number)
    {
        ArkUI_NumberValue value[] = {{.i32 = number}};
        ArkUI_AttributeItem item = {value, NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_Z_INDEX, &item);
        return err;
    }
    int32_t SetForegroundColor(uint32_t color)
    {
        ArkUI_NumberValue nums[NUMBER_1];
        nums[NUMBER_0].u32 = color;
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_FOREGROUND_COLOR, &item);
        return err;
    }
    int32_t SetMarkAnchor(float x, float y)
    {
        ArkUI_NumberValue nums[NUMBER_2] = {x, y};
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_2};
        auto err = nativeModule_->setAttribute(handle_, NODE_MARK_ANCHOR, &item);
        return err;
    }
    int32_t SetVisibility(int32_t visibility)
    {
        ArkUI_NumberValue nums[NUMBER_1];
        nums[NUMBER_0].i32 = visibility;
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_VISIBILITY, &item);
        return err;
    }
    void RegisterNodeEvent(ArkUI_NodeHandle node,
        ArkUI_NodeEventType eventType, int32_t targetId, void* userData)
    {
        nativeModule_->registerNodeEvent(node, eventType, targetId, userData);
    }
    void RegisterNodeEventReceiver(void (*eventReceiver)(ArkUI_NodeEvent* event))
    {
        nativeModule_->registerNodeEventReceiver(eventReceiver);
    }
    int32_t SetOpacityTransition()
    {
        ArkUI_NumberValue opacityTransition[] = {
            NUMBER_02,
            { .i32 = NUMBER_3000 },
            { .i32 = static_cast<int32_t>(ARKUI_CURVE_EASE_IN_OUT) }
        };
        ArkUI_AttributeItem item = { .value = opacityTransition, .size = NUMBER_3};
        auto err = nativeModule_->setAttribute(handle_, NODE_OPACITY_TRANSITION, &item);
        return err;
    }
    int32_t SetRotateTransition()
    {
        ArkUI_NumberValue rotateTransition[] = {
            NUMBER_00,
            NUMBER_00,
            NUMBER_1F,
            NUMBER_180,
            NUMBER_0,
            { .i32 = NUMBER_3000 },
            { .i32 = static_cast<int32_t>(ARKUI_CURVE_SHARP) }
        };
        ArkUI_AttributeItem item = { .value = rotateTransition, .size = NUMBER_7};
        auto err = nativeModule_->setAttribute(handle_, NODE_ROTATE_TRANSITION, &item);
        return err;
    }
    int32_t SetScaleTransition()
    {
        ArkUI_NumberValue scaleTransition[] = {
            NUMBER_00,
            NUMBER_00,
            NUMBER_00,
            { .i32 = NUMBER_3000 },
            { .i32 = static_cast<int32_t>(ARKUI_CURVE_SHARP) }
        };
        ArkUI_AttributeItem item = { .value = scaleTransition, .size = NUMBER_5};
        auto err = nativeModule_->setAttribute(handle_, NODE_SCALE_TRANSITION, &item);
        return err;
    }
    int32_t SetTranslateTransition()
    {
        ArkUI_NumberValue translateTransition[] = {
            NUMBER_100F,
            NUMBER_100F,
            NUMBER_00,
            { .i32 = NUMBER_3000 },
            { .i32 = static_cast<int32_t>(ARKUI_CURVE_SHARP) }
        };
        ArkUI_AttributeItem item = { .value = translateTransition, .size = NUMBER_5};
        auto err = nativeModule_->setAttribute(handle_, NODE_TRANSLATE_TRANSITION, &item);
        return err;
    }
    int32_t SetMoveTransition()
    {
        ArkUI_NumberValue translateTransition[] = {
            {.i32 = ARKUI_TRANSITION_EDGE_START },
            {.i32 = NUMBER_3000 },
            {.i32 = static_cast<int32_t>(ARKUI_CURVE_SHARP) }
        };
        ArkUI_AttributeItem item = { .value = translateTransition, .size = NUMBER_3};
        auto err = nativeModule_->setAttribute(handle_, NODE_MOVE_TRANSITION, &item);
        return err;
    }
    int32_t SetForegroundBlurStyle(int32_t number)
    {
        ArkUI_NumberValue nums[] = { { .i32 = number} };
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_FOREGROUND_BLUR_STYLE, &item);
        return err;
    }
    int32_t SetColorBlend(uint32_t color)
    {
        ArkUI_NumberValue nums[] = { { .u32 = color} };
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_COLOR_BLEND, &item);
        return err;
    }
    int32_t SetTransition(ArkUI_TransitionEffect* effect)
    {
        ArkUI_AttributeItem item = { .object = effect};
        auto err = nativeModule_->setAttribute(handle_, NODE_TRANSITION, &item);
        return err;
    }
    int32_t SetBackdropBlur(float round)
    {
        ArkUI_NumberValue nums[] = { round, NUMBER_100, NUMBER_100 };
        ArkUI_AttributeItem item = { .value = nums, .size = NUMBER_3};
        auto err = nativeModule_->setAttribute(handle_, NODE_BACKDROP_BLUR, &item);
        return err;
    }
    void SetTranslateWithPercent(float x, float y, float z)
    {
        ArkUI_NumberValue nums[NUMBER_3] = {x, y, z};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_3};
        nativeModule_->setAttribute(handle_, NODE_TRANSLATE_WITH_PERCENT, &item);
    }
    void SetRotateAngle(float x, float y, float z, float see)
    {
        ArkUI_NumberValue nums[NUMBER_4] = {x, y, z, see};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_4};
        nativeModule_->setAttribute(handle_, NODE_ROTATE_ANGLE, &item);
    }
    int32_t SetGeometryTransition(int32_t share, const char* str)
    {
        ArkUI_NumberValue nums[NUMBER_1] = { {.i32 = share} };
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1, .string = str};
        auto err = nativeModule_->setAttribute(handle_, NODE_GEOMETRY_TRANSITION, &item);
        return err;
    }
    int32_t SetCustomShadow()
    {
        ArkUI_NumberValue nums[NUMBER_7] = {
            NUMBER_20,
            {.i32 = NUMBER_0 },
            SMALL_LENGTH,
            SMALL_LENGTH,
            { .i32 = ARKUI_SHADOW_TYPE_COLOR },
            { .u32 = COLOR_RED },
            { .u32 = NUMBER_0 }
        };
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_7};
        auto err = nativeModule_->setAttribute(handle_, NODE_CUSTOM_SHADOW, &item);
        return err;
    }
    int32_t SetBlur(float number)
    {
        ArkUI_NumberValue nums[NUMBER_1] = {number};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_BLUR, &item);
        return err;
    }
    int32_t SetBackGroundImage(float number)
    {
        ArkUI_NumberValue nums[NUMBER_1] = {number};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_BLUR, &item);
        return err;
    }
    int32_t SetRenderFit(float number)
    {
        ArkUI_NumberValue nums[NUMBER_1] = {number};
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_RENDER_FIT, &item);
        return err;
    }
    int32_t SetRenderGroup(int32_t number)
    {
        ArkUI_NumberValue nums[NUMBER_1] = { { .i32 = number } };
        ArkUI_AttributeItem item = {.value = nums, .size = NUMBER_1};
        auto err = nativeModule_->setAttribute(handle_, NODE_RENDER_GROUP, &item);
        return err;
    }
protected:
    void OnAddChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        nativeModule_->addChild(handle_, child->GetHandle());
    }
    void OnRemoveChild(const std::shared_ptr<ArkUIBaseNode> &child) override
    {
        nativeModule_->removeChild(handle_, child->GetHandle());
    }
    void OnInsertChild(const std::shared_ptr<ArkUIBaseNode> &child, int32_t index) override
    {
        nativeModule_->insertChildAt(handle_, child->GetHandle(), index);
    }
};
} // namespace NativeModule
#endif // MYAPPLICATION_ARKUINODE_H