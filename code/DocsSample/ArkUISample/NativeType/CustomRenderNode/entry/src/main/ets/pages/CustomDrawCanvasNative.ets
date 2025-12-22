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

// [Start custom_draw_canvas_native]
import bridge from 'libentry.so'; // 该 so 由 Node-API 编写并生成
import { DrawContext, FrameNode, NodeController, RenderNode } from '@kit.ArkUI';

class MyRenderNode extends RenderNode {
  private uiContext: UIContext;

  constructor(uiContext: UIContext) {
    super();
    this.uiContext = uiContext;
  }

  draw(context: DrawContext) {
    // 需要将 context 中的宽度和高度从vp转换为px
    bridge.nativeOnDraw(0, context, this.uiContext.vp2px(context.size.height),
      this.uiContext.vp2px(context.size.width));
  }
}

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    this.rootNode = new FrameNode(uiContext);

    const rootRenderNode = this.rootNode.getRenderNode();
    if (rootRenderNode !== null) {
      const renderNode = new MyRenderNode(uiContext);
      renderNode.size = { width: 100, height: 100 };
      rootRenderNode.appendChild(renderNode);
    }
    return this.rootNode;
  }
}

@Entry
@Component
export struct CustomDrawCanvasNative {
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    // [StartExclude custom_draw_canvas_native]
    NavDestination() {
      // [EndExclude custom_draw_canvas_native]
      Row() {
        NodeContainer(this.myNodeController);
      };

      // [StartExclude custom_draw_canvas_native]
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.CustomDrawCanvasNative')替换为实际资源文件，在本示例中该资源文件的value值为"C++获取Canvas，并进行自定义绘制操作"
    .title($r('app.string.CustomDrawCanvasNative'));

    // [EndExclude custom_draw_canvas_native]
  }
}

// [End custom_draw_canvas_native]