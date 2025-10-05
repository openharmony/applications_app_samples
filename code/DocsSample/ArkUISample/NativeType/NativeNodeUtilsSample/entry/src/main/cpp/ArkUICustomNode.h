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
// ArkUICustomNode.h
// 自定义绘制组件示例
#ifndef MYAPPLICATION_ARKUICUSTOMNODE_H
#define MYAPPLICATION_ARKUICUSTOMNODE_H

#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_path.h>

#include "ArkUINode.h"

namespace NativeModule {

class ArkUICustomNode : public ArkUINode {
public:
    // 使用自定义组件类型ARKUI_NODE_CUSTOM创建组件。
    ArkUICustomNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_CUSTOM))
    {
        // 注册自定义事件监听器。
        nativeModule_->addNodeCustomEventReceiver(handle_, OnStaticCustomEvent);
        // 声明自定义事件并转递自身作为自定义数据。
        nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_FRONT, 0, this);
        nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW, 0, this);
        nativeModule_->registerNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_BEHIND, 0, this);
        // 绘制完成事件通知。
        OH_ArkUI_RegisterDrawCallbackOnNodeHandle(handle_, nullptr, [](void* userData) {});
    }

    ~ArkUICustomNode() override
    {
        // 反注册自定义事件监听器。
        nativeModule_->removeNodeCustomEventReceiver(handle_, OnStaticCustomEvent);
        // 取消声明自定义事件。
        nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_FRONT);
        nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW);
        nativeModule_->unregisterNodeCustomEvent(handle_, ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_BEHIND);
        OH_ArkUI_UnregisterDrawCallbackOnNodeHandle(handle_);
    }

private:
    int32_t NUM_2 = 2;
    int32_t NUM_3 = 3;
    int32_t NUM_4 = 4;
    int32_t NUM_5 = 5;

    static void OnStaticCustomEvent(ArkUI_NodeCustomEvent *event)
    {
        // 获取组件实例对象，调用相关实例方法。
        auto targetId = OH_ArkUI_NodeCustomEvent_GetEventTargetId(event);
        auto handle =  OH_ArkUI_NodeCustomEvent_GetNodeHandle(event);
        auto customNode = reinterpret_cast<ArkUICustomNode *>(OH_ArkUI_NodeCustomEvent_GetUserData(event));
        auto type = OH_ArkUI_NodeCustomEvent_GetEventType(event);
        switch (type) {
            //绘制层级由低到高。
            case ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_BEHIND:
                customNode->OnDrawBehind(event);
                break;
            case ARKUI_NODE_CUSTOM_EVENT_ON_DRAW:
                customNode->OnDraw(event);
                break;
            case ARKUI_NODE_CUSTOM_EVENT_ON_DRAW_FRONT:
                customNode->OnDrawFront(event);
                break;
            case ARKUI_NODE_CUSTOM_EVENT_ON_FOREGROUND_DRAW:
                customNode->OnDrawForeGround(event);
                break;
            case ARKUI_NODE_CUSTOM_EVENT_ON_OVERLAY_DRAW:
                customNode->OnDrawOverLay(event);
                break;
            default:
                break;
        }
    }

    // 自定义绘制逻辑。
    void OnDrawBehind(ArkUI_NodeCustomEvent *event)
    {
        auto drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
        // 获取图形绘制对象。
        auto drawCanvas = reinterpret_cast<OH_Drawing_Canvas *>(OH_ArkUI_DrawContext_GetCanvas(drawContext));
        // 获取组件大小。
        auto size = OH_ArkUI_DrawContext_GetSize(drawContext);
        // 绘制自定义内容。
        auto path = OH_Drawing_PathCreate();
        OH_Drawing_PathMoveTo(path, size.width / NUM_5, size.height / NUM_5);
        OH_Drawing_PathLineTo(path, size.width * NUM_4 / NUM_5, size.height / NUM_5);
        OH_Drawing_PathLineTo(path, size.width * NUM_4 / NUM_5, size.height * NUM_4 / NUM_5);
        OH_Drawing_PathLineTo(path, size.width / NUM_5, size.height * NUM_4 / NUM_5);
        OH_Drawing_PathLineTo(path, size.width / NUM_5, size.height / NUM_5);
        OH_Drawing_PathClose(path);
        auto brush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(brush, 0xFFF0FAFF); // 蓝白色
        OH_Drawing_CanvasAttachBrush(drawCanvas, brush);
        OH_Drawing_CanvasDrawPath(drawCanvas, path);
        // 释放资源
        OH_Drawing_BrushDestroy(brush);
        OH_Drawing_PathDestroy(path);
    }

    void OnDraw(ArkUI_NodeCustomEvent *event)
    {
        auto drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
        // 获取图形绘制对象。
        auto drawCanvas = reinterpret_cast<OH_Drawing_Canvas *>(OH_ArkUI_DrawContext_GetCanvas(drawContext));
        // 获取组件大小。
        auto size = OH_ArkUI_DrawContext_GetSize(drawContext);
        // 绘制自定义内容。
        auto path = OH_Drawing_PathCreate();
        OH_Drawing_PathMoveTo(path, size.width / NUM_4, size.height / NUM_4);
        OH_Drawing_PathLineTo(path, size.width * NUM_3 / NUM_4, size.height / NUM_4);
        OH_Drawing_PathLineTo(path, size.width * NUM_3 / NUM_4, size.height * NUM_3 / NUM_4);
        OH_Drawing_PathLineTo(path, size.width / NUM_4, size.height * NUM_3 / NUM_4);
        OH_Drawing_PathLineTo(path, size.width / NUM_4, size.height / NUM_4);
        OH_Drawing_PathClose(path);
        auto brush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(brush, 0xff2787D9); // 浅蓝色
        OH_Drawing_CanvasAttachBrush(drawCanvas, brush);
        OH_Drawing_CanvasDrawPath(drawCanvas, path);
        // 释放资源
        OH_Drawing_BrushDestroy(brush);
        OH_Drawing_PathDestroy(path);
    }

    void OnDrawFront(ArkUI_NodeCustomEvent *event)
    {
        auto drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
        // 获取图形绘制对象。
        auto drawCanvas = reinterpret_cast<OH_Drawing_Canvas *>(OH_ArkUI_DrawContext_GetCanvas(drawContext));
        // 获取组件大小。
        auto size = OH_ArkUI_DrawContext_GetSize(drawContext);
        // 绘制自定义内容。
        auto path = OH_Drawing_PathCreate();
        OH_Drawing_PathMoveTo(path, size.width / NUM_3, size.height / NUM_3);
        OH_Drawing_PathLineTo(path, size.width * NUM_2 / NUM_3, size.height / NUM_3);
        OH_Drawing_PathLineTo(path, size.width * NUM_2 / NUM_3, size.height * NUM_2 / NUM_3);
        OH_Drawing_PathLineTo(path, size.width / NUM_3, size.height * NUM_2 / NUM_3);
        OH_Drawing_PathLineTo(path, size.width / NUM_3, size.height / NUM_3);
        OH_Drawing_PathClose(path);
        auto brush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(brush, 0xFF00NUM_4AAF); // 深蓝色
        OH_Drawing_CanvasAttachBrush(drawCanvas, brush);
        OH_Drawing_CanvasDrawPath(drawCanvas, path);
        // 释放资源
        OH_Drawing_BrushDestroy(brush);
        OH_Drawing_PathDestroy(path);
    }

    void OnDrawForeGround(ArkUI_NodeCustomEvent *event)
    {
        auto drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
        // 获取图形绘制对象。
        auto drawCanvas = reinterpret_cast<OH_Drawing_Canvas *>(OH_ArkUI_DrawContext_GetCanvas(drawContext));
        // 获取组件大小。
        auto size = OH_ArkUI_DrawContext_GetSize(drawContext);
        // 绘制自定义内容。
        auto path = OH_Drawing_PathCreate();
        OH_Drawing_PathMoveTo(path, size.width / NUM_2, size.height / NUM_2);
        OH_Drawing_PathLineTo(path, size.width * NUM_2 / NUM_2, size.height / NUM_2);
        OH_Drawing_PathLineTo(path, size.width * NUM_2 / NUM_2, size.height * NUM_2 / NUM_2);
        OH_Drawing_PathLineTo(path, size.width / NUM_2, size.height * NUM_2 / NUM_2);
        OH_Drawing_PathLineTo(path, size.width / NUM_2, size.height / NUM_2);
        OH_Drawing_PathClose(path);
        auto brush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(brush, 0xFFFF0000); // 红色
        OH_Drawing_CanvasAttachBrush(drawCanvas, brush);
        OH_Drawing_CanvasDrawPath(drawCanvas, path);
        // 释放资源
        OH_Drawing_BrushDestroy(brush);
        OH_Drawing_PathDestroy(path);
    }

    void OnDrawOverLay(ArkUI_NodeCustomEvent *event)
    {
        auto drawContext = OH_ArkUI_NodeCustomEvent_GetDrawContextInDraw(event);
        // 获取图形绘制对象。
        auto drawCanvas = reinterpret_cast<OH_Drawing_Canvas *>(OH_ArkUI_DrawContext_GetCanvas(drawContext));
        // 获取组件大小。
        auto size = OH_ArkUI_DrawContext_GetSize(drawContext);
        // 绘制自定义内容。
        auto path = OH_Drawing_PathCreate();
        OH_Drawing_PathMoveTo(path, size.width, size.height);
        OH_Drawing_PathLineTo(path, size.width, size.height);
        OH_Drawing_PathLineTo(path, size.width * NUM_2, size.height * NUM_2);
        OH_Drawing_PathLineTo(path, size.width, size.height * NUM_2);
        OH_Drawing_PathLineTo(path, size.width, size.height / NUM_2);
        OH_Drawing_PathClose(path);
        auto brush = OH_Drawing_BrushCreate();
        OH_Drawing_BrushSetColor(brush, 0xFF00FF00); // 绿色
        OH_Drawing_CanvasAttachBrush(drawCanvas, brush);
        OH_Drawing_CanvasDrawPath(drawCanvas, path);
        // 释放资源
        OH_Drawing_BrushDestroy(brush);
        OH_Drawing_PathDestroy(path);
    }
};

} // namespace NativeModule

#endif // MYAPPLICATION_ARKUICUSTOMNODE_H