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

// /pages/Index.ets
import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI';
import { UIContext } from '@kit.ArkUI';
import { text } from '@kit.ArkGraphics2D';

// 创建一个自定义的渲染节点类，用于绘制文本
class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    // 获取画布canvas对象
    const canvas = context.canvas;
    // 设置文本样式
    let myTextStyle: text.TextStyle = {
      color: { alpha: 255, red: 255, green: 0, blue: 0 },
      fontSize: 33
    };
    // 创建一个段落样式对象，以设置排版风格
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
      align: 3,
      wordBreak:text.WordBreak.NORMAL
    };
    // 获取字体管理器全局FontCollection实例
    let fontCollection = text.FontCollection.getGlobalInstance(); // 获取Arkui全局FC
    // 创建一个段落生成器
    let paragraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    // 在段落生成器中设置文本样式
    paragraphGraphBuilder.pushStyle(myTextStyle);
    // 在段落生成器中设置文本内容
    paragraphGraphBuilder.addText("Hello World. \nThis is the theme font.");
    // 通过段落生成器生成段落
    let paragraph = paragraphGraphBuilder.build();
    // 布局
    paragraph.layoutSync(2500);
    paragraph.paint(canvas, 0, 400);
  }
}
// 创建渲染节点数组
const renderNodeMap: Array<RenderNode> = new Array();
// 导出渲染节点更新函数
export function updateRenderNodeData() {
  renderNodeMap.forEach((node) => {
    // 主动触发节点重绘制
    node.invalidate();
  });
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
      renderNode.frame = { x: 0, y: 0, width: 300, height: 50 };
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
      // 将节点添加到渲染节点数组中
      renderNodeMap.push(node);
    }
  }
  clearNodes(): void {
    if (this.rootNode == null) {
      return;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode != null) {
      renderNode.clearChildren();
      // 将节点从渲染节点数组中移除
      renderNodeMap.pop();
    }
  }
}

// 创建一个TextRenderNode对象
const textNode = new MyRenderNode();
// 定义textNode的像素格式
textNode.frame = {
  x: 0,
  y: 100,
  width: 600,
  height: 800
};
textNode.pivot = { x: 0.2, y: 0.8 };
textNode.scale = { x: 1, y: 1 };

@Entry
@Component
struct RenderTest {
  private myNodeController: MyNodeController = new MyNodeController();
  build() {
    Column() {
      Row() {
        NodeContainer(this.myNodeController)
          .height('100%')
      }
      .height('90%')
      .backgroundColor(Color.White)
      Row(){
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
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center) // 设置当前Row容器内子元素在主轴上居中对齐
      .shadow(ShadowStyle.OUTER_DEFAULT_SM) // 设置Row容器外阴影效果
      .alignItems(VerticalAlign.Bottom) // 设置当前Row容器内子元素在交叉轴（垂直方向）上的对齐方式为底部对齐
      .layoutWeight(1) // 设置当前Row在父容器Column中的布局权重为1
    }
  }
}

