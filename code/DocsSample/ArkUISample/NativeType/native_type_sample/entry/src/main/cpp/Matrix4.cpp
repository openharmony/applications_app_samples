/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <arkui/native_animate.h>
#include <arkui/native_gesture.h>
#include <arkui/native_key_event.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include "manager.h"
#include "Matrix4.h"

static ArkUI_NodeHandle scroll;
static ArkUI_NodeHandle image1;
static ArkUI_NodeHandle image2;
static ArkUI_NodeHandle image3;
static ArkUI_NodeHandle image4;
static ArkUI_NodeHandle image5;
const int32_t TARGET_ID_2 = 2;
const int32_t TARGET_ID_3 = 3;
const int32_t TARGET_ID_4 = 4;
const int32_t TARGET_ID_5 = 5;
const int32_t TARGET_ID_6 = 6;
const int32_t TARGET_ID_7 = 7;
const int32_t TARGET_ID_8 = 8;
const int32_t TARGET_ID_9 = 9;
const int32_t TARGET_ID_10 = 10;
const int32_t TARGET_ID_11 = 11;
const int32_t TARGET_ID_12 = 12;
const int32_t TARGET_ID_13 = 13;
const int32_t TARGET_ID_14 = 14;
const int32_t TARGET_ID_15 = 15;
static const float A = 0.9;
char g_src[] = "resources/base/media/startIcon.png";
float g_x;
float g_y;
float g_z;
float g_angle;
float g_centerX;
float g_centerY;

static void SetWidthPercent(ArkUI_NodeHandle &node, float width)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue nodeWidthValue[] = {width};
    ArkUI_AttributeItem nodeWidthItem = {nodeWidthValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &nodeWidthItem);
}

static void SetScrollAttribute(ArkUI_NodeHandle &scroll)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    SetWidthPercent(scroll, 1);
}

static void AddColumnChild(ArkUI_NodeHandle &column)
{
    ArkUI_NumberValue borderWidthValue[] = {2};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    Manager::nodeAPI_->setAttribute(column, NODE_BORDER_WIDTH, &borderWidthItem);
    SetWidthPercent(column, A);
    ArkUI_NumberValue marginWidthValue[] = {10};
    ArkUI_AttributeItem marginWidthItem = {marginWidthValue, 1};
    Manager::nodeAPI_->setAttribute(column, NODE_MARGIN, &marginWidthItem);
}

static void SetImageHeightAndWidthAttribute1(ArkUI_NodeHandle &image)
{
    ArkUI_NumberValue nodeHeightValue[] = {100};
    ArkUI_AttributeItem nodeHeightItem = {nodeHeightValue, 1};
    ArkUI_NumberValue marginMarginValue[] = {0, 0, 50, 0};
    ArkUI_AttributeItem marginMarginItem = {marginMarginValue, 4};
    Manager::nodeAPI_->setAttribute(image, NODE_MARGIN, &marginMarginItem);
    Manager::nodeAPI_->setAttribute(image, NODE_HEIGHT, &nodeHeightItem);
}

static void SetTextAttribute(ArkUI_NodeHandle &node)
{
    ArkUI_NumberValue btnWidthValue[] = {0.30};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    ArkUI_NumberValue marginMarginValue[] = {0, 0, 10, 0};
    ArkUI_AttributeItem marginMarginItem = {marginMarginValue, 4};
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &marginMarginItem);
}

static void SetImageAttribute1(ArkUI_NodeHandle &column)
{
    image1 = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE);
    ArkUI_AttributeItem imageItem = {.string = g_src};
    Manager::nodeAPI_->setAttribute(image1, NODE_IMAGE_SRC, &imageItem);
    SetImageHeightAndWidthAttribute1(image1);
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(text);
    ArkUI_AttributeItem TextItem1 = {.string = "   original image  "};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &TextItem1);
    Manager::nodeAPI_->addChild(column, text);
    Manager::nodeAPI_->addChild(column, image1);
}

static void MatrixTranslate(ArkUI_NodeHandle &image)
{
    auto matrix = OH_ArkUI_Matrix4_CreateIdentity();
    auto translate = OH_ArkUI_Matrix4TranslationOptions_Create();
    g_x = 200.0f;
    g_y = 10.0f;
    g_z = 10.0f;
    float x1;
    float y1;
    float z1;
    OH_ArkUI_Matrix4TranslationOptions_SetX(translate, g_x);
    OH_ArkUI_Matrix4TranslationOptions_SetY(translate, g_y);
    OH_ArkUI_Matrix4TranslationOptions_SetZ(translate, g_z);
    OH_ArkUI_Matrix4TranslationOptions_GetX(translate, &x1);
    OH_ArkUI_Matrix4TranslationOptions_GetY(translate, &y1);
    OH_ArkUI_Matrix4TranslationOptions_GetZ(translate, &z1);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "matrix4",
                 "translate  x = %{public}f  y = %{public}f  z = %{public}f  ",
                 x1, y1, z1);
    OH_ArkUI_Matrix4_Translate(matrix, translate);
    ArkUI_AttributeItem item = {.size = 0, .object = matrix};
    Manager::nodeAPI_->setAttribute(image, NODE_TRANSFORM, &item);
    OH_ArkUI_Matrix4TranslationOptions_Dispose(translate);
    OH_ArkUI_Matrix4_Dispose(matrix);
}

static void SetImageAttribute2(ArkUI_NodeHandle &column)
{
    image2 = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE);
    ArkUI_AttributeItem imageItem = {.string = g_src};
    Manager::nodeAPI_->setAttribute(image2, NODE_IMAGE_SRC, &imageItem);
    SetImageHeightAndWidthAttribute1(image2);
    MatrixTranslate(image2);
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(text);
    ArkUI_AttributeItem TextItem1 = {.string = " translate image"};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &TextItem1);
    Manager::nodeAPI_->addChild(column, text);
    Manager::nodeAPI_->addChild(column, image2);
}

static void MatrixScale(ArkUI_NodeHandle &image)
{
    auto matrix = OH_ArkUI_Matrix4_CreateIdentity();
    auto scale = OH_ArkUI_Matrix4ScaleOptions_Create();
    g_x = 0.5f;
    g_y = 0.5f;
    g_z = 1.0f;
    g_centerX = 0.5f;
    g_centerY = 0.0f;
    float x1;
    float y1;
    float z1;
    float centerX1;
    float centerY1;
    OH_ArkUI_Matrix4ScaleOptions_SetX(scale, g_x);
    OH_ArkUI_Matrix4ScaleOptions_SetY(scale, g_y);
    OH_ArkUI_Matrix4ScaleOptions_SetZ(scale, g_z);
    OH_ArkUI_Matrix4ScaleOptions_SetCenterX(scale, g_centerX);
    OH_ArkUI_Matrix4ScaleOptions_SetCenterY(scale, g_centerY);
    OH_ArkUI_Matrix4ScaleOptions_GetX(scale, &x1);
    OH_ArkUI_Matrix4ScaleOptions_GetY(scale, &y1);
    OH_ArkUI_Matrix4ScaleOptions_GetZ(scale, &z1);
    OH_ArkUI_Matrix4ScaleOptions_GetCenterX(scale, &centerX1);
    OH_ArkUI_Matrix4ScaleOptions_GetCenterY(scale, &centerY1);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "matrix4",
                 "scale  x = %{public}f  y = %{public}f  z = %{public}f  centerX = %{public}f  centerY = %{public}f",
                 x1, y1, z1, centerX1, centerY1);
    OH_ArkUI_Matrix4_Scale(matrix, scale);
    ArkUI_AttributeItem item = {.size = 0, .object = matrix};
    Manager::nodeAPI_->setAttribute(image, NODE_TRANSFORM, &item);
    OH_ArkUI_Matrix4ScaleOptions_Dispose(scale);
    OH_ArkUI_Matrix4_Dispose(matrix);
}

static void SetImageAttribute3(ArkUI_NodeHandle &column)
{
    image3 = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE);
    ArkUI_AttributeItem imageItem = {.string = g_src};
    Manager::nodeAPI_->setAttribute(image3, NODE_IMAGE_SRC, &imageItem);
    SetImageHeightAndWidthAttribute1(image3);
    MatrixScale(image3);
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(text);
    ArkUI_AttributeItem TextItem1 = {.string = "     scale image  "};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &TextItem1);
    Manager::nodeAPI_->addChild(column, text);
    Manager::nodeAPI_->addChild(column, image3);
}

static void MatrixRotate(ArkUI_NodeHandle &image)
{
    auto matrix = OH_ArkUI_Matrix4_CreateIdentity();
    auto rotate = OH_ArkUI_Matrix4RotationOptions_Create();
    g_x = 0.5f;
    g_y = 0.5f;
    g_z = 1.0f;
    g_centerX = 0.5f;
    g_centerY = 0.0f;
    g_angle = 60.0f;
    float x1;
    float y1;
    float z1;
    float centerX1;
    float centerY1;
    float angle1;
    OH_ArkUI_Matrix4RotationOptions_SetX(rotate, g_x);
    OH_ArkUI_Matrix4RotationOptions_SetY(rotate, g_y);
    OH_ArkUI_Matrix4RotationOptions_SetZ(rotate, g_z);
    OH_ArkUI_Matrix4RotationOptions_SetAngle(rotate, g_angle);
    OH_ArkUI_Matrix4RotationOptions_SetCenterX(rotate, g_centerX);
    OH_ArkUI_Matrix4RotationOptions_SetCenterY(rotate, g_centerY);
    OH_ArkUI_Matrix4RotationOptions_GetX(rotate, &x1);
    OH_ArkUI_Matrix4RotationOptions_GetY(rotate, &y1);
    OH_ArkUI_Matrix4RotationOptions_GetZ(rotate, &z1);
    OH_ArkUI_Matrix4RotationOptions_GetAngle(rotate, &angle1);
    OH_ArkUI_Matrix4RotationOptions_GetCenterX(rotate, &centerX1);
    OH_ArkUI_Matrix4RotationOptions_GetCenterY(rotate, &centerY1);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "matrix4",
                 "rotate  x = %{public}f  y = %{public}f  z = %{public}f  angle = %{public}f  centerX = %{public}f "
                 " centerY = %{public}f", x1, y1, z1, angle1, centerX1, centerY1);
    OH_ArkUI_Matrix4_Rotate(matrix, rotate);
    ArkUI_AttributeItem item = {.size = 0, .object = matrix};
    Manager::nodeAPI_->setAttribute(image, NODE_TRANSFORM, &item);
    OH_ArkUI_Matrix4RotationOptions_Dispose(rotate);
    OH_ArkUI_Matrix4_Dispose(matrix);
}

static void SetImageAttribute4(ArkUI_NodeHandle &column)
{
    image4 = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE);
    ArkUI_AttributeItem imageItem = {.string = g_src};
    Manager::nodeAPI_->setAttribute(image4, NODE_IMAGE_SRC, &imageItem);
    SetImageHeightAndWidthAttribute1(image4);
    MatrixRotate(image4);
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(text);
    ArkUI_AttributeItem TextItem1 = {.string = "     rotate image  "};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &TextItem1);
    Manager::nodeAPI_->addChild(column, text);
    Manager::nodeAPI_->addChild(column, image4);
}

static void MatrixChange(ArkUI_NodeHandle &image)
{
    float matrixValue[16] = {1.0f, 1.0f, 1.0f, 0.0f,
                             0.0f, 1.0f, 1.0f, 0.0f,
                             0.0f, 0.0f, 8.0f, 9.0f,
                             0.0f, 1.0f, 0.0f, 3.0f};
    auto matrix = OH_ArkUI_Matrix4_CreateByElements(matrixValue);
    auto matrixCopy = OH_ArkUI_Matrix4_Copy(matrix);
    OH_ArkUI_Matrix4_Invert(matrixCopy);
    OH_ArkUI_Matrix4_Combine(matrix, matrixCopy);
    OH_ArkUI_Matrix4_Skew(matrix, 2.0f, 2.0f);
    ArkUI_PointF oriPoint = {1.0f, 1.0f};
    ArkUI_PointF result = {0.0f, 0.0f};
    OH_ArkUI_Matrix4_TransformPoint(matrix, &oriPoint, &result);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "matrix4",
                 "result.x = %{public}f result.y = %{public}f", result.x, result.y);
    ArkUI_PointF src1[4] = {{0, 0}, {500, 0}, {0, 500}, {500, 500}};
    ArkUI_PointF dst[4] = {{0, 0}, {500, 0}, {0, 500}, {750, 1000}};
    OH_ArkUI_Matrix4_SetPolyToPoly(matrix, src1, dst, TARGET_ID_4);
    OH_ArkUI_Matrix4_GetElements(matrix, matrixValue);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "matrix4",
                 "matrixValue = %{public}f  %{public}f  %{public}f  %{public}f %{public}f  %{public}f  %{public}f "
                 "%{public}f  %{public}f  %{public}f  %{public}f  %{public}f  %{public}f  %{public}f  %{public}f"
                 "%{public}f", matrixValue[0], matrixValue[1], matrixValue[TARGET_ID_2], matrixValue[TARGET_ID_3],
                 matrixValue[TARGET_ID_4], matrixValue[TARGET_ID_5], matrixValue[TARGET_ID_6], matrixValue[TARGET_ID_7],
                 matrixValue[TARGET_ID_8], matrixValue[TARGET_ID_9], matrixValue[TARGET_ID_10],
                 matrixValue[TARGET_ID_11], matrixValue[TARGET_ID_12], matrixValue[TARGET_ID_13],
                 matrixValue[TARGET_ID_14], matrixValue[TARGET_ID_15]);
    ArkUI_AttributeItem item = {.size = 0, .object = matrix};
    Manager::nodeAPI_->setAttribute(image, NODE_TRANSFORM, &item);
    OH_ArkUI_Matrix4_Dispose(matrix);
}

static void SetImageAttribute5(ArkUI_NodeHandle &column)
{
    image5 = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE);
    ArkUI_AttributeItem imageItem = {.string = g_src};
    Manager::nodeAPI_->setAttribute(image5, NODE_IMAGE_SRC, &imageItem);
    SetImageHeightAndWidthAttribute1(image5);
    MatrixChange(image5);
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(text);
    ArkUI_AttributeItem TextItem1 = {.string = "  matrix change"};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &TextItem1);
    Manager::nodeAPI_->addChild(column, text);
    Manager::nodeAPI_->addChild(column, image5);
}

static void AddScrollChild(ArkUI_NodeHandle &scroll)
{
    ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    AddColumnChild(column);
    SetImageAttribute1(column);
    SetImageAttribute2(column);
    SetImageAttribute3(column);
    SetImageAttribute4(column);
    SetImageAttribute5(column);
    Manager::nodeAPI_->addChild(scroll, column);
}

ArkUI_NodeHandle Matrix4Maker::CreateNativeNode()
{
    if (!Manager::nodeAPI_) {
        return nullptr;
    }
    // 创建父子滚动容器
    scroll = Manager::nodeAPI_->createNode(ARKUI_NODE_SCROLL);
    // 设置属性
    SetScrollAttribute(scroll);
    AddScrollChild(scroll);
    return scroll;
}