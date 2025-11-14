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
// ArkUIRenderNode.h
// 提供绘制节点操作的基类。
#ifndef MYAPPLICATION_ARKUIRENDERNODE_H
#define MYAPPLICATION_ARKUIRENDERNODE_H

#include <arkui/native_render.h>
#include <arkui/native_type.h>
#include <list>
#include <memory>

#include "NativeModule.h"

namespace NativeModule {

struct MaskOption {
    uint32_t fillColor;
    uint32_t strokeColor;
    int32_t strokeWidth;
};

class ArkUIRenderNode {
    public:
        explicit ArkUIRenderNode()
        {
            handle_ = OH_ArkUI_RenderNodeUtils_CreateNode();
        }

        virtual ~ArkUIRenderNode()
        {
            // 封装析构函数，实现子节点移除功能。
            if (!children_.empty()) {
                for (const auto &child : children_) {
                    OH_ArkUI_RenderNodeUtils_RemoveChild(handle_, child->GetHandle());
                }
                children_.clear();
            }
            // 封装析构函数，统一回收节点资源。
            if (floatPropertyHandle_) { OH_ArkUI_RenderNodeUtils_DisposeFloatProperty(floatPropertyHandle_); }
            if (vector2PropertyHandle_) { OH_ArkUI_RenderNodeUtils_DisposeVector2Property(vector2PropertyHandle_); }
            if (colorPropertyHandle_) { OH_ArkUI_RenderNodeUtils_DisposeColorProperty(colorPropertyHandle_); }
            if (floatAnimatablePropertyHandle_) {
                OH_ArkUI_RenderNodeUtils_DisposeFloatAnimatableProperty(floatAnimatablePropertyHandle_);
            }
            if (vector2AnimatablePropertyHandle_) {
                OH_ArkUI_RenderNodeUtils_DisposeVector2AnimatableProperty(vector2AnimatablePropertyHandle_);
            }
            if (colorAnimatablePropertyHandle_) {
                OH_ArkUI_RenderNodeUtils_DisposeColorAnimatableProperty(colorAnimatablePropertyHandle_);
            }
            OH_ArkUI_RenderNodeUtils_DisposeNode(handle_);
        }

        int32_t AddChild(const std::shared_ptr<ArkUIRenderNode> &child)
        {
            auto result = OH_ArkUI_RenderNodeUtils_AddChild(handle_, child->GetHandle());
            if (result == ARKUI_ERROR_CODE_NO_ERROR) {
                children_.emplace_back(child);
            }
            return result;
        }

        int32_t InsertChildAfter(const std::shared_ptr<ArkUIRenderNode> &child,
                const std::shared_ptr<ArkUIRenderNode> &slibing)
        {
            auto result = OH_ArkUI_RenderNodeUtils_InsertChildAfter(handle_, child->GetHandle(), slibing->GetHandle());
            if (result == ARKUI_ERROR_CODE_NO_ERROR) {
                children_.emplace_back(slibing);
            }
            return result;
        }

        int32_t RemoveChild(const std::shared_ptr<ArkUIRenderNode> &child)
        {
            auto result = OH_ArkUI_RenderNodeUtils_RemoveChild(handle_, child->GetHandle());
            if (result == ARKUI_ERROR_CODE_NO_ERROR) {
                children_.remove(child);
            }
            return result;
        }

        // 获取子节点的handle指针。
        ArkUI_RenderNodeHandle GetChildHandle(int32_t index)
        {
            ArkUI_RenderNodeHandle n1;
            OH_ArkUI_RenderNodeUtils_GetChild(handle_, index, &n1);
            return n1;
        }

        // 获取子节点的handle指针。
        ArkUI_RenderNodeHandle GetNextSibling()
        {
            ArkUI_RenderNodeHandle n1;
            OH_ArkUI_RenderNodeUtils_GetNextSibling(handle_, &n1);
            return n1;
        }

        // 获取子节点的handle指针。
        ArkUI_RenderNodeHandle GetPreviousSibling()
        {
            ArkUI_RenderNodeHandle n1;
            OH_ArkUI_RenderNodeUtils_GetPreviousSibling(handle_, &n1);
            return n1;
        }

        // 获取子节点的handle指针。
        ArkUI_RenderNodeHandle GetFirstChildHandle()
        {
            ArkUI_RenderNodeHandle n1;
            OH_ArkUI_RenderNodeUtils_GetFirstChild(handle_, &n1);
            return n1;
        }

        // 获取子节点数组集。
        ArkUI_RenderNodeHandle* GetChildrenHandle()
        {
            int32_t count = 0;
            ArkUI_RenderNodeHandle *nodeList222;
            OH_ArkUI_RenderNodeUtils_GetChildren(handle_, &nodeList222, &count);
            return nodeList222;
        }

        int32_t GetChildrenCount()
        {
            // 这里设置count==-1，以-1来判断获取成功与否，或者在方法内加上返回错误码判断。
            int32_t count = -1;
            OH_ArkUI_RenderNodeUtils_GetChildrenCount(handle_, &count);
            return count;
        }
        /******** 属性设置类接口，默认单位均为px ********/
        int32_t SetSize(int32_t width, int32_t height)
        {
            return OH_ArkUI_RenderNodeUtils_SetSize(handle_, width, height);
        }
    
        int32_t GetSize(int32_t* width, int32_t* height)
        {
            return OH_ArkUI_RenderNodeUtils_GetSize(handle_, width, height);
        }
    
        int32_t SetTransform(float matrix[])
        {
            return OH_ArkUI_RenderNodeUtils_SetTransform(handle_, matrix);
        }

        int32_t SetBackgroundColor(uint32_t color)
        {
            return OH_ArkUI_RenderNodeUtils_SetBackgroundColor(handle_, color);
        }

        int32_t GetBackgroundColor(uint32_t *color)
        {
            return OH_ArkUI_RenderNodeUtils_GetBackgroundColor(handle_, color);
        }

        int32_t SetClipToFrame(int32_t clipToFrame)
        {
            return OH_ArkUI_RenderNodeUtils_SetClipToFrame(handle_, clipToFrame);
        }

        int32_t GetClipToFrame(int32_t *clipToFrame)
        {
            return OH_ArkUI_RenderNodeUtils_GetClipToFrame(handle_, clipToFrame);
        }

        int32_t SetClipToBounds(int32_t clipToBounds)
        {
            return OH_ArkUI_RenderNodeUtils_SetClipToBounds(handle_, clipToBounds);
        }

        int32_t GetClipToBounds(int32_t *clipToBounds)
        {
            return OH_ArkUI_RenderNodeUtils_GetClipToBounds(handle_, clipToBounds);
        }

        int32_t SetPosition(int32_t x, int32_t y)
        {
            return OH_ArkUI_RenderNodeUtils_SetPosition(handle_, x, y);
        }

        int32_t GetPosition(int32_t *x, int32_t *y)
        {
            return OH_ArkUI_RenderNodeUtils_GetPosition(handle_, x, y);
        }

        int32_t SetOpacity(float opacity)
        {
            return OH_ArkUI_RenderNodeUtils_SetOpacity(handle_, opacity);
        }

        int32_t GetOpacity(float* opacity)
        {
            return OH_ArkUI_RenderNodeUtils_GetOpacity(handle_, opacity);
        }

        int32_t SetPivot(float x, float y)
        {
            return OH_ArkUI_RenderNodeUtils_SetPivot(handle_, x, y);
        }

        int32_t GetPivot(float *x, float *y)
        {
            return OH_ArkUI_RenderNodeUtils_GetPivot(handle_, x, y);
        }

        int32_t SetScale(float x, float y)
        {
            return OH_ArkUI_RenderNodeUtils_SetScale(handle_, x, y);
        }

        int32_t GetScale(float *x, float *y)
        {
            return OH_ArkUI_RenderNodeUtils_GetScale(handle_, x, y);
        }

        int32_t SetTranslation(float x, float y)
        {
            return OH_ArkUI_RenderNodeUtils_SetTranslation(handle_, x, y);
        }

        int32_t GetTranslation(float *x, float *y)
        {
            return OH_ArkUI_RenderNodeUtils_GetTranslation(handle_, x, y);
        }

        int32_t SetRotation(float x, float y, float z)
        {
            return OH_ArkUI_RenderNodeUtils_SetRotation(handle_, x, y, z);
        }

        int32_t GetRotation(float *x, float *y, float *z)
        {
            return OH_ArkUI_RenderNodeUtils_GetRotation(handle_, x, y, z);
        }

        int32_t SetShadowColor(uint32_t color)
        {
            return OH_ArkUI_RenderNodeUtils_SetShadowColor(handle_, color);
        }

        int32_t GetShadowColor(uint32_t *color)
        {
            return OH_ArkUI_RenderNodeUtils_GetShadowColor(handle_, color);
        }

        int32_t SetShadowOffset(int32_t x, int32_t y)
        {
            return OH_ArkUI_RenderNodeUtils_SetShadowOffset(handle_, x, y);
        }

        int32_t GetShadowOffset(int32_t *x, int32_t *y)
        {
            return OH_ArkUI_RenderNodeUtils_GetShadowOffset(handle_, x, y);
        }

        int32_t SetShadowAlpha(float alpha)
        {
            return OH_ArkUI_RenderNodeUtils_SetShadowAlpha(handle_, alpha);
        }

        int32_t GetShadowAlpha(float* alpha)
        {
            return OH_ArkUI_RenderNodeUtils_GetShadowAlpha(handle_, alpha);
        }

        int32_t SetShadowElevation(float elevation)
        {
            return OH_ArkUI_RenderNodeUtils_SetShadowElevation(handle_, elevation);
        }

        int32_t GetShadowElevation(float *elevation)
        {
            return OH_ArkUI_RenderNodeUtils_GetShadowElevation(handle_, elevation);
        }

        int32_t SetMarkNodeGroup(bool mark) { return OH_ArkUI_RenderNodeUtils_SetMarkNodeGroup(handle_, mark); }

        int32_t SetShadowRadius(float radius) { return OH_ArkUI_RenderNodeUtils_SetShadowRadius(handle_, radius); }

        int32_t GetShadowRadius(float *radius) { return OH_ArkUI_RenderNodeUtils_GetShadowRadius(handle_, radius); }

        int32_t SetBorderStyle(ArkUI_BorderStyle left, ArkUI_BorderStyle right, ArkUI_BorderStyle top,
                                    ArkUI_BorderStyle bottom)
        {
            auto styleOption = OH_ArkUI_RenderNodeUtils_CreateNodeBorderStyleOption();
            // 此处可以先获取节点原先的边框类型，实现根据已设置类型调整等功能逻辑。
            OH_ArkUI_RenderNodeUtils_GetBorderStyle(handle_, &styleOption);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderStyleOptionEdgeStyle(styleOption, left,
                                                                       ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_LEFT);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderStyleOptionEdgeStyle(styleOption, right,
                                                                       ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_RIGHT);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderStyleOptionEdgeStyle(styleOption, top,
                                                                       ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_TOP);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderStyleOptionEdgeStyle(styleOption, bottom,
                ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_BOTTOM);
            auto result = OH_ArkUI_RenderNodeUtils_SetBorderStyle(handle_, styleOption);
            OH_ArkUI_RenderNodeUtils_DisposeNodeBorderStyleOption(styleOption);
            return result;
        }

        int32_t SetBorderWidth(float left, float right, float top, float bottom)
        {
            auto widthOption = OH_ArkUI_RenderNodeUtils_CreateNodeBorderWidthOption();
            // 此处可以先获取节点原先的边框类型，实现根据已设置类型调整等功能逻辑。
            OH_ArkUI_RenderNodeUtils_GetBorderWidth(handle_, &widthOption);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderWidthOptionEdgeWidth(widthOption, left,
                                                                       ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_LEFT);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderWidthOptionEdgeWidth(widthOption, right,
                                                                       ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_RIGHT);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderWidthOptionEdgeWidth(widthOption, top,
                                                                       ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_TOP);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderWidthOptionEdgeWidth(
                widthOption, bottom, ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_BOTTOM);
            auto result = OH_ArkUI_RenderNodeUtils_SetBorderWidth(handle_, widthOption);
            OH_ArkUI_RenderNodeUtils_DisposeNodeBorderWidthOption(widthOption);
            return result;
        }

        int32_t SetBorderColor(uint32_t left, uint32_t right, uint32_t top, uint32_t bottom)
        {
            auto colorOption = OH_ArkUI_RenderNodeUtils_CreateNodeBorderColorOption();
            // 此处可以先获取节点原先的边框类型，实现根据已设置类型调整等功能逻辑。
            OH_ArkUI_RenderNodeUtils_GetBorderColor(handle_, &colorOption);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderColorOptionEdgeColor(colorOption, left,
                                                                       ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_LEFT);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderColorOptionEdgeColor(colorOption, right,
                                                                       ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_RIGHT);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderColorOptionEdgeColor(colorOption, top,
                                                                       ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_TOP);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderColorOptionEdgeColor(
                colorOption, bottom, ArkUI_EdgeDirection::ARKUI_EDGE_DIRECTION_BOTTOM);
            auto result = OH_ArkUI_RenderNodeUtils_SetBorderColor(handle_, colorOption);
            OH_ArkUI_RenderNodeUtils_DisposeNodeBorderColorOption(colorOption);
            return result;
        }

        int32_t SetBorderRadius(int32_t topLeft, int32_t topRight, int32_t bottomLeft, int32_t bottomRight)
        {
            auto radiusOption = OH_ArkUI_RenderNodeUtils_CreateNodeBorderRadiusOption();
            // 此处可以先获取节点原先的边框类型，实现根据已设置类型调整等功能逻辑。
            OH_ArkUI_RenderNodeUtils_GetBorderRadius(handle_, &radiusOption);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderRadiusOptionCornerRadius(
                radiusOption, topLeft, ArkUI_CornerDirection::ARKUI_CORNER_DIRECTION_TOP_LEFT);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderRadiusOptionCornerRadius(
                radiusOption, topRight, ArkUI_CornerDirection::ARKUI_CORNER_DIRECTION_TOP_RIGHT);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderRadiusOptionCornerRadius(
                radiusOption, bottomLeft, ArkUI_CornerDirection::ARKUI_CORNER_DIRECTION_BOTTOM_LEFT);
            OH_ArkUI_RenderNodeUtils_SetNodeBorderRadiusOptionCornerRadius(
                radiusOption, bottomRight, ArkUI_CornerDirection::ARKUI_CORNER_DIRECTION_BOTTOM_RIGHT);
            auto result = OH_ArkUI_RenderNodeUtils_SetBorderRadius(handle_, radiusOption);
            OH_ArkUI_RenderNodeUtils_DisposeNodeBorderRadiusOption(radiusOption);
            return result;
        }
    
        void SetRectShapeMask(float top, float right, float bottom, float left, MaskOption option)
        {
            auto rectShape = OH_ArkUI_RenderNodeUtils_CreateRectShapeOption();
            OH_ArkUI_RenderNodeUtils_SetRectShapeOptionEdgeValue(rectShape, top, right, bottom, left);
            auto rectMask = OH_ArkUI_RenderNodeUtils_CreateRenderNodeMaskOptionFromRectShape(rectShape);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionFillColor(rectMask, option.fillColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeColor(rectMask, option.strokeColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeWidth(rectMask, option.strokeWidth);
            OH_ArkUI_RenderNodeUtils_SetMask(handle_, rectMask);
            OH_ArkUI_RenderNodeUtils_DisposeRectShapeOption(rectShape);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeMaskOption(rectMask);
        }

        void SetRoundShapeMask(float top, float right, float bottom, float left, MaskOption option)
        {
            auto roundShape = OH_ArkUI_RenderNodeUtils_CreateRoundRectShapeOption();
            OH_ArkUI_RenderNodeUtils_SetRoundRectShapeOptionEdgeValue(roundShape, top, right, bottom, left);
            OH_ArkUI_RenderNodeUtils_SetRoundRectShapeOptionCornerXY(roundShape, 0, 0,
                                                                     ArkUI_CornerDirection::ARKUI_CORNER_DIRECTION_ALL);
            auto rectMask = OH_ArkUI_RenderNodeUtils_CreateRenderNodeMaskOptionFromRoundRectShape(roundShape);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionFillColor(rectMask, option.fillColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeColor(rectMask, option.strokeColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeWidth(rectMask, option.strokeWidth);
            OH_ArkUI_RenderNodeUtils_SetMask(handle_, rectMask);
            OH_ArkUI_RenderNodeUtils_DisposeRoundRectShapeOption(roundShape);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeMaskOption(rectMask);
        }
    
        void SetCircleShapeMask(float x, float y, float radius, MaskOption option)
        {
            auto circleShape = OH_ArkUI_RenderNodeUtils_CreateCircleShapeOption();
            OH_ArkUI_RenderNodeUtils_SetCircleShapeOptionCenterX(circleShape, x);
            OH_ArkUI_RenderNodeUtils_SetCircleShapeOptionCenterY(circleShape, y);
            OH_ArkUI_RenderNodeUtils_SetCircleShapeOptionRadius(circleShape, radius);
            auto rectMask = OH_ArkUI_RenderNodeUtils_CreateRenderNodeMaskOptionFromCircleShape(circleShape);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionFillColor(rectMask, option.fillColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeColor(rectMask, option.strokeColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeWidth(rectMask, option.strokeWidth);
            OH_ArkUI_RenderNodeUtils_SetMask(handle_, rectMask);
            OH_ArkUI_RenderNodeUtils_DisposeCircleShapeOption(circleShape);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeMaskOption(rectMask);
        }


        void SetOvalShapeMask(float top, float right, float bottom, float left, MaskOption option)
        {
            auto rectShape = OH_ArkUI_RenderNodeUtils_CreateRectShapeOption();
            OH_ArkUI_RenderNodeUtils_SetRectShapeOptionEdgeValue(rectShape, top, right, bottom, left);
            auto rectMask = OH_ArkUI_RenderNodeUtils_CreateRenderNodeMaskOptionFromOvalShape(rectShape);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionFillColor(rectMask, option.fillColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeColor(rectMask, option.strokeColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeWidth(rectMask, option.strokeWidth);
            OH_ArkUI_RenderNodeUtils_SetMask(handle_, rectMask);
            OH_ArkUI_RenderNodeUtils_DisposeRectShapeOption(rectShape);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeMaskOption(rectMask);
        }


        void SetCommandPathMask(char* commands, MaskOption option)
        {
            auto commandPath = OH_ArkUI_RenderNodeUtils_CreateCommandPathOption();
            OH_ArkUI_RenderNodeUtils_SetCommandPathOptionCommands(commandPath, commands);
            auto rectMask = OH_ArkUI_RenderNodeUtils_CreateRenderNodeMaskOptionFromCommandPath(commandPath);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionFillColor(rectMask, option.fillColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeColor(rectMask, option.strokeColor);
            OH_ArkUI_RenderNodeUtils_SetRenderNodeMaskOptionStrokeWidth(rectMask, option.strokeWidth);
            OH_ArkUI_RenderNodeUtils_SetMask(handle_, rectMask);
            OH_ArkUI_RenderNodeUtils_DisposeCommandPathOption(commandPath);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeMaskOption(rectMask);
        }

        void SetRectShapeClip(float top, float right, float bottom, float left)
        {
            auto rectShape = OH_ArkUI_RenderNodeUtils_CreateRectShapeOption();
            OH_ArkUI_RenderNodeUtils_SetRectShapeOptionEdgeValue(rectShape, top, right, bottom, left);
            auto rectClip = OH_ArkUI_RenderNodeUtils_CreateRenderNodeClipOptionFromRectShape(rectShape);
            OH_ArkUI_RenderNodeUtils_SetClip(handle_, rectClip);
            OH_ArkUI_RenderNodeUtils_DisposeRectShapeOption(rectShape);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeClipOption(rectClip);
        }

        void SetRoundShapeClip(float top, float right, float bottom, float left)
        {
            auto roundShape = OH_ArkUI_RenderNodeUtils_CreateRoundRectShapeOption();
            OH_ArkUI_RenderNodeUtils_SetRoundRectShapeOptionEdgeValue(roundShape, top, right, bottom, left);
            OH_ArkUI_RenderNodeUtils_SetRoundRectShapeOptionCornerXY(roundShape, 0, 0,
                                                                     ArkUI_CornerDirection::ARKUI_CORNER_DIRECTION_ALL);
            auto rectClip = OH_ArkUI_RenderNodeUtils_CreateRenderNodeClipOptionFromRoundRectShape(roundShape);
            OH_ArkUI_RenderNodeUtils_SetClip(handle_, rectClip);
            OH_ArkUI_RenderNodeUtils_DisposeRoundRectShapeOption(roundShape);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeClipOption(rectClip);
        }

        void SetCircleShapeClip(float x, float y, float radius)
        {
            auto circleShape = OH_ArkUI_RenderNodeUtils_CreateCircleShapeOption();
            OH_ArkUI_RenderNodeUtils_SetCircleShapeOptionCenterX(circleShape, x);
            OH_ArkUI_RenderNodeUtils_SetCircleShapeOptionCenterY(circleShape, y);
            OH_ArkUI_RenderNodeUtils_SetCircleShapeOptionRadius(circleShape, radius);
            auto rectClip = OH_ArkUI_RenderNodeUtils_CreateRenderNodeClipOptionFromCircleShape(circleShape);
            OH_ArkUI_RenderNodeUtils_SetClip(handle_, rectClip);
            OH_ArkUI_RenderNodeUtils_DisposeCircleShapeOption(circleShape);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeClipOption(rectClip);
        }


        void SetOvalShapeClip(float top, float right, float bottom, float left)
        {
            auto rectShape = OH_ArkUI_RenderNodeUtils_CreateRectShapeOption();
            OH_ArkUI_RenderNodeUtils_SetRectShapeOptionEdgeValue(rectShape, top, right, bottom, left);
            auto rectClip = OH_ArkUI_RenderNodeUtils_CreateRenderNodeClipOptionFromOvalShape(rectShape);
            OH_ArkUI_RenderNodeUtils_SetClip(handle_, rectClip);
            OH_ArkUI_RenderNodeUtils_DisposeRectShapeOption(rectShape);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeClipOption(rectClip);
        }

        void SetCommandPathClip(char *commands)
        {
            auto commandPath = OH_ArkUI_RenderNodeUtils_CreateCommandPathOption();
            OH_ArkUI_RenderNodeUtils_SetCommandPathOptionCommands(commandPath, commands);
            auto rectClip = OH_ArkUI_RenderNodeUtils_CreateRenderNodeClipOptionFromCommandPath(commandPath);
            OH_ArkUI_RenderNodeUtils_SetClip(handle_, rectClip);
            OH_ArkUI_RenderNodeUtils_DisposeCommandPathOption(commandPath);
            OH_ArkUI_RenderNodeUtils_DisposeRenderNodeClipOption(rectClip);
        }

        int32_t SetDrawRegion(float x, float y, float width, float height)
        {
            return OH_ArkUI_RenderNodeUtils_SetDrawRegion(handle_, x, y, width, height);
        }
    
        // 自定义绘制依赖modifier，对接N个property作为参数传递，使用自定义绘制能力时需先调用该方法。
        void CreateContentModifier()
        {
            renderContentModifierHandle_ = OH_ArkUI_RenderNodeUtils_CreateContentModifier();
            OH_ArkUI_RenderNodeUtils_AttachContentModifier(handle_, renderContentModifierHandle_);
        }
    
        void CreateOrSetFloatProperty(float value)
        {
            if (floatPropertyHandle_ == nullptr) {
                floatPropertyHandle_ = OH_ArkUI_RenderNodeUtils_CreateFloatProperty(value);
                OH_ArkUI_RenderNodeUtils_AttachFloatProperty(renderContentModifierHandle_, floatPropertyHandle_);
            } else {
                OH_ArkUI_RenderNodeUtils_SetFloatPropertyValue(floatPropertyHandle_, value);
            }
        }
    
        void GetFloatProperty(float* value)
        {
            if (floatPropertyHandle_ != nullptr) {
                OH_ArkUI_RenderNodeUtils_GetFloatPropertyValue(floatPropertyHandle_, value);
            }
        }

        void CreateOrSetVector2Property(float x, float y)
        {
            if (vector2PropertyHandle_ == nullptr) {
                vector2PropertyHandle_ = OH_ArkUI_RenderNodeUtils_CreateVector2Property(x, y);
                OH_ArkUI_RenderNodeUtils_AttachVector2Property(renderContentModifierHandle_, vector2PropertyHandle_);
            } else {
                OH_ArkUI_RenderNodeUtils_SetVector2PropertyValue(vector2PropertyHandle_, x, y);
            }
        }

        void GetVector2Property(float* x, float* y)
        {
            if (vector2PropertyHandle_ != nullptr) {
                OH_ArkUI_RenderNodeUtils_GetVector2PropertyValue(vector2PropertyHandle_, x, y);
            }
        }

        void CreateOrSetColorProperty(uint32_t value)
        {
            if (colorPropertyHandle_ == nullptr) {
                colorPropertyHandle_ = OH_ArkUI_RenderNodeUtils_CreateColorProperty(value);
                OH_ArkUI_RenderNodeUtils_AttachColorProperty(renderContentModifierHandle_, colorPropertyHandle_);
            } else {
                OH_ArkUI_RenderNodeUtils_SetColorPropertyValue(colorPropertyHandle_, value);
            }
        }

        void GetColorProperty(uint32_t *value)
        {
            if (colorPropertyHandle_ != nullptr) {
                OH_ArkUI_RenderNodeUtils_GetColorPropertyValue(colorPropertyHandle_, value);
            }
        }

        void CreateOrSetFloatAnimatableProperty(float value)
        {
            if (floatAnimatablePropertyHandle_ == nullptr) {
                floatAnimatablePropertyHandle_ = OH_ArkUI_RenderNodeUtils_CreateFloatAnimatableProperty(value);
                OH_ArkUI_RenderNodeUtils_AttachFloatAnimatableProperty(
                    renderContentModifierHandle_, floatAnimatablePropertyHandle_);
            } else {
                OH_ArkUI_RenderNodeUtils_SetFloatAnimatablePropertyValue(floatAnimatablePropertyHandle_, value);
            }
        }

        void GetFloatAnimatableProperty(float *value)
        {
            if (floatAnimatablePropertyHandle_ != nullptr) {
                OH_ArkUI_RenderNodeUtils_GetFloatAnimatablePropertyValue(floatAnimatablePropertyHandle_, value);
            }
        }

        void CreateOrSetVector2AnimatableProperty(float x, float y)
        {
            if (vector2AnimatablePropertyHandle_ == nullptr) {
                vector2AnimatablePropertyHandle_ = OH_ArkUI_RenderNodeUtils_CreateVector2AnimatableProperty(x, y);
                OH_ArkUI_RenderNodeUtils_AttachVector2AnimatableProperty(renderContentModifierHandle_,
                    vector2AnimatablePropertyHandle_);
            } else {
                OH_ArkUI_RenderNodeUtils_SetVector2AnimatablePropertyValue(vector2AnimatablePropertyHandle_, x, y);
            }
        }

        void GetVector2AnimatableProperty(float* x, float* y)
        {
            if (vector2AnimatablePropertyHandle_ != nullptr) {
                OH_ArkUI_RenderNodeUtils_GetVector2AnimatablePropertyValue(vector2AnimatablePropertyHandle_, x, y);
            }
        }

        void CreateOrSetColorAnimatableProperty(uint32_t value)
        {
            if (colorAnimatablePropertyHandle_ == nullptr) {
                colorAnimatablePropertyHandle_ = OH_ArkUI_RenderNodeUtils_CreateColorAnimatableProperty(value);
                OH_ArkUI_RenderNodeUtils_AttachColorAnimatableProperty(renderContentModifierHandle_,
                    colorAnimatablePropertyHandle_);
            } else {
                OH_ArkUI_RenderNodeUtils_SetColorAnimatablePropertyValue(colorAnimatablePropertyHandle_, value);
            }
        }

        void GetColorAnimatableProperty(uint32_t *value)
        {
            if (colorAnimatablePropertyHandle_ != nullptr) {
                OH_ArkUI_RenderNodeUtils_GetColorAnimatablePropertyValue(colorAnimatablePropertyHandle_, value);
            }
        }

        void SetContentModifierOnDraw(void *userData, void (*callback)(ArkUI_DrawContext *context, void *userData))
        {
            if (renderContentModifierHandle_ == nullptr) {
                return;
            }
            OH_ArkUI_RenderNodeUtils_SetContentModifierOnDraw(renderContentModifierHandle_, userData, callback);
        }

        ArkUI_RenderNodeHandle GetHandle() const { return handle_; }

    protected:
        ArkUI_RenderNodeHandle handle_;

    private:
        std::list<std::shared_ptr<ArkUIRenderNode>> children_;
        ArkUI_FloatProperty* floatPropertyHandle_ = nullptr;
        ArkUI_Vector2Property* vector2PropertyHandle_ = nullptr;
        ArkUI_ColorProperty* colorPropertyHandle_ = nullptr;
        ArkUI_FloatAnimatableProperty* floatAnimatablePropertyHandle_ = nullptr;
        ArkUI_Vector2AnimatableProperty* vector2AnimatablePropertyHandle_ = nullptr;
        ArkUI_ColorAnimatableProperty* colorAnimatablePropertyHandle_ = nullptr;
        ArkUI_RenderContentModifier* renderContentModifierHandle_ = nullptr;
    };
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIRENDERNODE_H