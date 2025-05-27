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

// Index.ets
import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI';
import { UIContext } from '@kit.ArkUI';
import { text } from '@kit.ArkGraphics2D';

// 创建一个自定义的渲染节点类，用于绘制文本
class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    // 获取画布canvas对象
    const canvas = context.canvas;
    // 配置文本样式（红色，字号100px）
    let myTextStyle: text.TextStyle = {
      color: {
        alpha: 255,
        red: 255,
        green: 0,
        blue: 0
      },
      fontSize: 100
    };
    // 创建一个段落样式对象，以设置排版风格
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
      wordBreak: text.WordBreak.NORMAL
    };
    // 创建一个段落生成器
    let paragraphBuilder = new text.ParagraphBuilder(myParagraphStyle, new text.FontCollection());
    // 在段落生成器中设置文本样式
    paragraphBuilder.pushStyle(myTextStyle);
    // 在段落生成器中设置文本内容
    paragraphBuilder.addText("文本测量测试");
    // 通过段落生成器生成段落
    let paragraph = paragraphBuilder.build();
    // 布局
    paragraph.layoutSync(1000);
    // case1: 获取排版后最长行行宽
    let longestLineWidth = paragraph.getLongestLine();
    console.info("longestLineWidth = " + longestLineWidth);

    // case2: 获取排版后最长行行宽(包含缩进)
    let longestLineWithIndentWidth = paragraph.getLongestLineWithIndent();
    console.info("longestLineWithIndentWidth = " + longestLineWithIndentWidth);

    // case3: 获取排版后所有行对象
    let textLines = paragraph.getTextLines();
    for (let index = 0; index < textLines.length; index++) {
      const textline = textLines[index];
      let curLineRange = textline.getTextRange();
      let curLineGlyCnt = textline.getGlyphCount();
      console.info("MetricsMSG: 第" + (index + 1) + "行 TextRange start: " + curLineRange.start + " TextRange end: " + curLineRange.end);
      console.info("MetricsMSG: 第" + (index + 1) + "行字形数量为: " + curLineGlyCnt);
    }

    // case4: 获取排版后指定行对应的度量信息
    let lineCnt = paragraph.getLineCount();
    for (let index = 0; index < lineCnt; index++) {
      let lineMetrics = paragraph.getLineMetrics(index);
      if (lineMetrics) {
        console.info("MetricsMSG: 第" + (index + 1) + "行 lineMetrics width: " + lineMetrics.width);
        console.info("MetricsMSG: 第" + (index + 1) + "行 lineMetrics start index: " + lineMetrics.startIndex + ", end index: " +
        lineMetrics.endIndex);
      }
    }

    // case5: 获取排版后所有行度量信息数组
    let allLineMetrics = paragraph.getLineMetrics();
    console.info("MetricsMSG: 第1行 lineMetrics width: " + allLineMetrics[0].width);
    paragraph.paint(canvas, 0, 800);
  }
}

// 创建文本渲染节点实例
const textNode = new MyRenderNode();
// 定义newNode的大小和位置
textNode.frame = { x: 0, y: 0, width: 400, height: 600 };

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
        width: 300,
        height: 50
      };
      renderNode.pivot = { x: 0, y: 0 };
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

@Entry
@Component
struct RenderTest {
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    Column() {
      Row() {
        NodeContainer(this.myNodeController)
          .height('100%')
          .position({x : 30, y: 25})

        Button($r("app.string.Button_label"))
          .fontSize('16fp')
          .fontWeight(500)
          .margin({ bottom: 24, right: 12 })
          .onClick(() => {
            this.myNodeController.clearNodes();
            this.myNodeController.addNode(textNode);
          })
          .width('50%')
          .height(40)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center) // 设置当前Row容器内子元素在主轴上居中对齐
      .alignItems(VerticalAlign.Bottom) // 设置当前Row容器内子元素在交叉轴（垂直方向）上的对齐方式为底部对齐
      .layoutWeight(1) // 设置当前Row在父容器Column中的布局权重为1
    }
  }
}