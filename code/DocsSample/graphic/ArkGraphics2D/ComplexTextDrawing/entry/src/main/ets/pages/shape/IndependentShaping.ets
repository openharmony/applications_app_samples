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

// [Start arkts_independent_shaping_text]
import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI'
import { UIContext } from '@kit.ArkUI'
import { text } from '@kit.ArkGraphics2D'
import { drawing } from '@kit.ArkGraphics2D'
import { common2D } from '@kit.ArkGraphics2D'

@Builder
export function PageBuilder(_: string) {
  Index();
}


@Entry
@Component
export default struct Index {
  @State message: string = 'Hello World';
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    NavDestination() {
      Column() {
        Row() {
          NodeContainer(this.myNodeController)
            .height('100%')
            .width('100%')
        }
        .width('100%')
      }
    }
  }
}

// 绘制代码逻辑写在这里
function drawText(canvas: drawing.Canvas) {
  let myTextStyle: text.TextStyle = {
    // 文本大小
    fontSize: 60
  };
  let myParagraphStyle: text.ParagraphStyle = {
    textStyle: myTextStyle,
  };
  let fontCollection = text.FontCollection.getGlobalInstance();
  let paragraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
  // 添加文本
  paragraphBuilder.addText('Hello World');
  // 生成行
  let lineTypeSet: text.LineTypeset = paragraphBuilder.buildLineTypeset()
  let textLine: text.TextLine = lineTypeSet.createLine(0, 11);

  // 获取塑形结果
  let runs: text.Run[] = textLine.getGlyphRuns();
  let x: number = 0;
  let y: number = 0;
  for (let index = 0; index < runs.length; index++) {
    const run = runs[index];
    // 绘制字形
    let glyphs: number[] = run.getGlyphs();
    let font: drawing.Font = run.getFont();
    let advances: common2D.Point[] = run.getAdvances({ start: 0, end: 0 });

    // 创建字形buffer，通过drawing接口进行字形独立绘制
    let runBuffer: drawing.TextBlobRunBuffer[] = [];
    for (let i = 0; i < glyphs.length; i++) {
      runBuffer.push({ glyph: glyphs[i], positionX: x, positionY: y });
      x += advances[i].x + 10;
      y += advances[i].y + 30
      0;
    }
    let textBlob: drawing.TextBlob = drawing.TextBlob.makeFromRunBuffer(runBuffer, font, null);
    // 自定义绘制一串具有相同属性的一系列连续字形
    canvas.drawTextBlob(textBlob, 20, 100);
  }
  // [End arkts_independent_shaping_text]
}

// 创建一个MyRenderNode类，并绘制文本。
class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    drawText(context.canvas);
  }
}

// 创建一个MyRenderNode对象
const textNode = new MyRenderNode();
// 定义newNode的像素格式
textNode.frame = {
  x: 0,
  y: 0,
  width: 300,
  height: 300
}

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
        width: 500,
        height: 500
      }
      renderNode.appendChild(textNode);
    }
    return this.rootNode;
  }
}
// [End arkts_independent_shaping_text]