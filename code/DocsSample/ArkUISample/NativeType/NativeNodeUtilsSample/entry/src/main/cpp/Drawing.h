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

// [Start drawing_start]
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_color.h>
#include <native_drawing/drawing_path.h>
#include <native_drawing/drawing_pen.h>
#include "common/common.h"

ArkUI_NodeHandle test_draw(ArkUI_NativeNodeAPI_1 *nodeAPI) 
{
    // 创建节点
    // [Start createColumnNode_start]
    auto column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    // [End createColumnNode_start]
    auto customNode = nodeAPI->createNode(ARKUI_NODE_CUSTOM);
    ArkUI_NumberValue value[] = {SIZE_480};
    ArkUI_AttributeItem item = {value, 1};
    // 属性设置
    nodeAPI->setAttribute(column, NODE_WIDTH, &item);
    value[0].i32 = SIZE_720;
    nodeAPI->setAttribute(column, NODE_HEIGHT, &item);
    ArkUI_NumberValue NODE_WIDTH_value[] = {SIZE_200};
    ArkUI_AttributeItem NODE_WIDTH_Item[] = {NODE_WIDTH_value, 1};
    ArkUI_NumberValue NODE_HEIGHT_value[] = {SIZE_200};
    ArkUI_AttributeItem NODE_HEIGHT_Item[] = {NODE_HEIGHT_value, 1};
    ArkUI_NumberValue NODE_BACKGROUND_COLOR_item_value[] = {{.u32 = COLOR_YELLOW}};
    ArkUI_AttributeItem NODE_BACKGROUND_COLOR_Item[] = {NODE_BACKGROUND_COLOR_item_value, 1};
    // [Start userdata_start]
    // UserData
    struct A {
        int32_t a = 6;
        bool flag = true;
        ArkUI_NodeHandle node;
    };
    A *a = new A;
    a->node = customNode;
    nodeAPI->setAttribute(customNode, NODE_WIDTH, NODE_WIDTH_Item);
    nodeAPI->setAttribute(customNode, NODE_HEIGHT, NODE_HEIGHT_Item);
    nodeAPI->setAttribute(customNode, NODE_BACKGROUND_COLOR, NODE_BACKGROUND_COLOR_Item);
    // 进行事件注册
    nodeAPI->registerNodeCustomEvent(customNode, ARKUI_NODE_CUSTOM_EVENT_ON_FOREGROUND_DRAW, 1, a);
    // 事件回调函数的编写
    nodeAPI->registerNodeCustomEventReceiver([](ArkUI_NodeCustomEvent *event)
    // 事件回调函数逻辑
    // [End userdata_start]
    {
        // 获取自定义事件的相关信息。
        // [Start nodeCustomEvent_start]
        auto type = OH_ArkUI_NodeCustomEvent_GetEventType(event);
        auto targetId = OH_ArkUI_NodeCustomEvent_GetEventTargetId(event);
        auto userData = reinterpret_cast<A *>(OH_ArkUI_NodeCustomEvent_GetUserData(event));
        // [End nodeCustomEvent_start]
        if (type == ARKUI_NODE_CUSTOM_EVENT_ON_FOREGROUND_DRAW && targetId == 1 && userData->flag) {
            // [Start drawCanvas_Start]
            // 获取自定义事件绘制的上下文。
            auto *drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
            // 获取绘制canvas指针。
            auto *canvas1 = OH_ArkUI_DrawContext_GetCanvas(drawContext);
            // 转换为OH_Drawing_Canvas指针进行绘制。
            OH_Drawing_Canvas *canvas = reinterpret_cast<OH_Drawing_Canvas *>(canvas1);
            int32_t width = SIZE_1000;
            int32_t height = SIZE_1000;
            auto path = OH_Drawing_PathCreate();
            OH_Drawing_PathMoveTo(path, width / SIZE_4, height / SIZE_4);
            OH_Drawing_PathLineTo(path, width * SIZE_3 / SIZE_4, height * SIZE_3 / SIZE_4);
            OH_Drawing_PathLineTo(path, width * SIZE_3 / SIZE_4, height * SIZE_3 / SIZE_4);
            OH_Drawing_PathLineTo(path, width * SIZE_3 / SIZE_4, height * SIZE_3 / SIZE_4);
            OH_Drawing_PathLineTo(path, width * SIZE_3 / SIZE_4, height * SIZE_3 / SIZE_4);
            OH_Drawing_PathClose(path);
            auto pen = OH_Drawing_PenCreate();
            OH_Drawing_PenSetWidth(pen, SIZE_10);
            OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(RGBA_R1, RGBA_G1, RGBA_B1, RGBA_A1));
            OH_Drawing_CanvasAttachPen(canvas, pen);
            OH_Drawing_CanvasDrawPath(canvas, path);
            // [End drawCanvas_Start]
        }
    });
    // 自定义节点上树
    nodeAPI->addChild(column, customNode);
    return column;
}
// [End drawing_start]
