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

// 创建一个MyRenderNode类，并绘制文本。
class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    // [Start arkts_multi_line_text_drawing_step1]
    // 绘制代码逻辑写在这里
    let canvas = context.canvas;
    // [End arkts_multi_line_text_drawing_step1]

    // [Start arkts_multi_line_text_drawing_step2]
    let myTextStyle: text.TextStyle = {
      color: {
        alpha: 255,
        red: 255,
        green: 0,
        blue: 0
      },
      fontSize: 50,
      // 当wordBreak为text.WordBreak.BREAK_HYPHEN时，需要为段落设置语言偏好，段落会在不同语言偏好下呈现不同的文本断词效果
      locale: 'en-gb'
    };
    // [End arkts_multi_line_text_drawing_step2]

    // [Start arkts_multi_line_text_drawing_step3]
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
      // 文本对齐方式
      align: text.TextAlign.LEFT,
      // 最大行数
      maxLines: 3,
      // 断词策略
      wordBreak: text.WordBreak.BREAK_WORD
    };
    // [End arkts_multi_line_text_drawing_step3]
    // [Start arkts_multi_line_text_drawing_step4]
    let fontCollection = text.FontCollection.getGlobalInstance();
    let paragraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    // 更新文本样式
    paragraphBuilder.pushStyle(myTextStyle);
    // 添加文本
    paragraphBuilder.addText('Hello World Hello World Hello World Hello World Hello World Hello World ' +
      'Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World ' +
      'Hello World Hello World Hello World Hello World Hello World ');
    // [End arkts_multi_line_text_drawing_step4]
    // 当wordBreak为text.WordBreak.BREAK_HYPHEN时，替换文本内容为：
    // paragraphBuilder.addText('Modern embedded systems require robust communication protocols and efficient memory ' +
    //   'management strategies. Developers often face challenges in optimizing performance while maintaining ' +
    //   'modularity and portability. By leveraging a layered architecture and structured logging, applications can ' +
    //   'detect anomalies and respond quickly to faults. This approach enhances reliability, especially in ' +
    //   'time-critical environments such as IoT devices and real-time operating systems.');

    // [Start arkts_multi_line_text_drawing_step5]
    // 生成段落
    let paragraph = paragraphBuilder.build();
    // 布局
    paragraph.layoutSync(1250);
    // 绘制文本
    paragraph.paint(canvas, 10, 0);
    // [End arkts_multi_line_text_drawing_step5]
  }
}

// 创建一个MyRenderNode对象
const textNode = new MyRenderNode();
// 定义newNode的像素格式
textNode.frame = {
  x: 0,
  y: 0,
  width: 400,
  height: 600
};
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
      renderNode.frame = {
        x: 0,
        y: 0,
        width: 10,
        height: 500
      }
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
struct Font08 {
  @State src: Resource = $r('app.media.startIcon');
  build() {
    Column() {
      Row() {
        NodeContainer(myNodeController)
          .height('100%')
          .width('100%')
        Image(this.src)
          .width('0%').height('0%')
          .onComplete(
            () => {
              performTask();
            })
      }
      .width('100%')
    }
  }
}