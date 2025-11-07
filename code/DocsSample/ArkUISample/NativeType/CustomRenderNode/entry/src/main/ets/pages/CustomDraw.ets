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

// [Start custom_draw]
import { FrameNode, NodeController, RenderNode } from '@kit.ArkUI';
import { drawing } from '@kit.ArkGraphics2D';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

class MyRenderNode extends RenderNode {
  public width: number = 200;

  draw(context: DrawContext) {
    // 获取canvas对象
    const canvas = context.canvas;
    // 创建笔刷
    const brush = new drawing.Brush();
    // 设置笔刷颜色
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    canvas.attachBrush(brush);
    // 绘制矩阵
    canvas.drawRect({
      left: 0,
      right: this.width,
      top: 0,
      bottom: 200
    });
    canvas.detachBrush();
    hilog.info(DOMAIN, 'testTag', `RenderNode draw width = ${this.width}`);
  }
}

const renderNode = new MyRenderNode();
renderNode.frame = {
  x: 0,
  y: 0,
  width: 300,
  height: 300
};
renderNode.backgroundColor = 0xff0000ff;
renderNode.opacity = 0.5;

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    this.rootNode = new FrameNode(uiContext);

    const rootRenderNode = this.rootNode?.getRenderNode();
    if (rootRenderNode !== null) {
      rootRenderNode.frame = {
        x: 0,
        y: 0,
        width: 500,
        height: 500
      };
      rootRenderNode.appendChild(renderNode);
    }

    return this.rootNode;
  }
}

@Entry
@Component
export struct CustomDraw {
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    // [StartExclude custom_draw]
    NavDestination() {
      // [EndExclude custom_draw]
      Column() {
        NodeContainer(this.myNodeController)
          .width('100%');
        Button('Invalidate')
          .onClick(() => {
            // 同步调用多次，仅触发一次重绘，draw回调中的日志仅打印一次
            renderNode.width += 10;
            renderNode.invalidate();
            renderNode.invalidate();
          });
      };

      // [StartExclude custom_draw]
    }
    .backgroundColor('#f1f2f3')
    // $r('app.string.CustomDraw')需要替换为开发者所需的字符串资源文件
    .title($r('app.string.CustomDraw'));

    // [EndExclude custom_draw]
  }
}

// [End custom_draw]