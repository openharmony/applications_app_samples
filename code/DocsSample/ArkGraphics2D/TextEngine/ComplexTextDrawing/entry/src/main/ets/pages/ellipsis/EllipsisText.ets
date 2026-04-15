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

import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI'
import { UIContext } from '@kit.ArkUI'
import { text } from '@kit.ArkGraphics2D'

// 创建一个MyRenderNode类，并绘制带省略号的文本。
class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    let canvas = context.canvas;
    // [Start arkts_ellipsis_text_step1]
    // 设置文本样式，包含省略号字符串和省略号模式
    let myTextStyle: text.TextStyle = {
      color: {
        alpha: 255,
        red: 0,
        green: 0,
        blue: 0
      },
      fontSize: 40,
      // 设置省略号字符串
      ellipsis: '...',
      // 设置省略号模式为尾部省略
      ellipsisMode: text.EllipsisMode.END
    };
    // [End arkts_ellipsis_text_step1]
    // [Start arkts_ellipsis_text_step2]
    // 设置段落样式，包含最大行数
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
      // 设置最大显示行数为2
      maxLines: 2
    };
    let fontCollection = text.FontCollection.getGlobalInstance();
    let paragraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    paragraphBuilder.pushStyle(myTextStyle);
    paragraphBuilder.addText('This is a long text that will be truncated with ellipsis at the end. ' +
      'When the text exceeds the maximum number of lines, the ellipsis will be shown.');
    let paragraph = paragraphBuilder.build();
    paragraph.layoutSync(800);
    // 绘制尾部省略文本
    paragraph.paint(canvas, 10, 0);
    // [End arkts_ellipsis_text_step2]
    // [Start arkts_ellipsis_text_step3]
    // 设置省略号模式为头部省略
    let textStyleStart: text.TextStyle = {
      color: {
        alpha: 255,
        red: 0,
        green: 0,
        blue: 0
      },
      fontSize: 40,
      ellipsis: '...',
      ellipsisMode: text.EllipsisMode.START
    };
    let paragraphStyleStart: text.ParagraphStyle = {
      textStyle: textStyleStart,
      maxLines: 2
    };
    let builderStart = new text.ParagraphBuilder(paragraphStyleStart, fontCollection);
    builderStart.pushStyle(textStyleStart);
    builderStart.addText('This is a long text that will be truncated with ellipsis at the start. ' +
      'When the text exceeds the maximum number of lines, the ellipsis will be shown at the beginning.');
    let paragraphStart = builderStart.build();
    paragraphStart.layoutSync(800);
    // 绘制头部省略文本
    paragraphStart.paint(canvas, 10, 120);
    // [End arkts_ellipsis_text_step3]
    // [Start arkts_ellipsis_text_step4]
    // 设置省略号模式为中部省略
    let textStyleMiddle: text.TextStyle = {
      color: {
        alpha: 255,
        red: 0,
        green: 0,
        blue: 0
      },
      fontSize: 40,
      ellipsis: '...',
      ellipsisMode: text.EllipsisMode.MIDDLE
    };
    let paragraphStyleMiddle: text.ParagraphStyle = {
      textStyle: textStyleMiddle,
      maxLines: 2
    };
    let builderMiddle = new text.ParagraphBuilder(paragraphStyleMiddle, fontCollection);
    builderMiddle.pushStyle(textStyleMiddle);
    builderMiddle.addText('This is a long text that will be truncated with ellipsis in the middle. ' +
      'When the text exceeds the maximum number of lines, the ellipsis will be shown in the middle.');
    let paragraphMiddle = builderMiddle.build();
    paragraphMiddle.layoutSync(800);
    // 绘制中部省略文本
    paragraphMiddle.paint(canvas, 10, 240);
    // [End arkts_ellipsis_text_step4]
  }
}

const textNode = new MyRenderNode();
textNode.frame = { x: 0, y: 0, width: 400, height: 600 };
textNode.pivot = { x: 0.2, y: 0.8 };
textNode.scale = { x: 1, y: 1 };

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode == null) {
      return this.rootNode;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) {
      renderNode.frame = { x: 0, y: 0, width: 10, height: 500 };
    }
    return this.rootNode;
  }

  addNode(node: RenderNode): void {
    if (this.rootNode == null) {
      return;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) {
      renderNode.appendChild(node);
    }
  }

  clearNodes(): void {
    if (this.rootNode == null) {
      return;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) {
      renderNode.clearChildren();
    }
  }
}

let myNodeController: MyNodeController = new MyNodeController();

async function performTask() {
  myNodeController.clearNodes();
  myNodeController.addNode(textNode);
}

@Entry
@Component
struct EllipsisText {
  @State src: Resource = $r('app.media.startIcon');
  build() {
    Column() {
      Row() {
        NodeContainer(myNodeController)
          .height('100%')
          .width('100%')
        Image(this.src)
          .width('0%').height('0%')
          .onComplete(() => {
            performTask();
          })
      }
      .width('100%')
    }
  }
}
