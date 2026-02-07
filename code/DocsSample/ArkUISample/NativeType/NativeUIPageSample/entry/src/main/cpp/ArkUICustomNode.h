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
// [Start Cpp_ArkUICustomNode_h]
// ArkUICustomNode.h
// 自定义绘制组件示例
#ifndef NATIVEUIPAGESAMPLE_ARKUICUSTOMNODE_H
#define NATIVEUIPAGESAMPLE_ARKUICUSTOMNODE_H

#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_path.h>

#include "ArkUINode.h"

namespace NativeModule {
class ArkUICustomNode : public ArkUINode {
public:
    // 使用自定义组件类型ARKUI_NODE_CUSTOM创建组件。
    ArkUICustomNode();

    ~ArkUICustomNode() override;

private:
    int32_t NUM_2 = 2;
    int32_t NUM_3 = 3;
    int32_t NUM_4 = 4;
    int32_t NUM_5 = 5;

    static void OnStaticCustomEvent(ArkUI_NodeCustomEvent *event);

    // 自定义绘制逻辑。
    void OnDrawBehind(ArkUI_NodeCustomEvent *event);

    void OnDraw(ArkUI_NodeCustomEvent *event);

    void OnDrawFront(ArkUI_NodeCustomEvent *event);
};

} // namespace NativeModule

#endif // NATIVEUIPAGESAMPLE_ARKUICUSTOMNODE_H
// [End Cpp_ArkUICustomNode_h]
