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

// [Start arkts_punctuation_compress_example_text]
import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI'
import { UIContext } from '@kit.ArkUI'
import { text, drawing } from '@kit.ArkGraphics2D'

class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    let canvas = context.canvas;
    // 开启行首标点挤压
    let myTextStyle: text.TextStyle = {
      color: { alpha: 255, red: 0, green: 0, blue: 0 },
      fontSize: 40
    };
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
      compressHeadPunctuation: true
    };
    let fontCollection = text.FontCollection.getGlobalInstance();
    let paragraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    paragraphBuilder.pushStyle(myTextStyle);
    paragraphBuilder.addText('《你好世界》这是一个中文标点压缩的示例文字，用于展示标点在行首的挤压效果。通过对比可以观察到挤压前后的差异。');
    let paragraph = paragraphBuilder.build();
    paragraph.layoutSync(800);
    let backgroundPen = new drawing.Pen();
    backgroundPen.setColor({ alpha: 255, red: 255, green: 0, blue: 0 });
    canvas.attachPen(backgroundPen);
    canvas.drawRect({ left: 10, top: 0, right: 810, bottom: paragraph.getHeight() });
    canvas.detachPen();
    paragraph.paint(canvas, 10, 0);
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
    if (this.rootNode == null) { return this.rootNode; }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) { renderNode.frame = { x: 0, y: 0, width: 10, height: 500 }; }
    return this.rootNode;
  }
  addNode(node: RenderNode): void {
    if (this.rootNode == null) { return; }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) { renderNode.appendChild(node); }
  }
  clearNodes(): void {
    if (this.rootNode == null) { return; }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) { renderNode.clearChildren(); }
  }
}

let myNodeController: MyNodeController = new MyNodeController();
async function performTask() { myNodeController.clearNodes(); myNodeController.addNode(textNode); }

@Entry
@Component
struct PunctuationText {
  @State src: Resource = $r('app.media.startIcon');
  build() {
    Column() {
      Row() {
        NodeContainer(myNodeController).height('100%').width('100%')
        Image(this.src).width('0%').height('0%').onComplete(() => { performTask(); })
      }.width('100%')
    }
  }
}
// [End arkts_punctuation_compress_example_text]