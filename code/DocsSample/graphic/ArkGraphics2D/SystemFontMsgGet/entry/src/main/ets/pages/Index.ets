// Index.ets
import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI'
import { UIContext } from '@kit.ArkUI'
import { text } from '@kit.ArkGraphics2D'
import { font } from '@kit.ArkUI'

class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    // 创建画布canvas对象
    const canvas = context.canvas
    // 获取全局字体集实例
    let fontCollection = text.FontCollection.getGlobalInstance() //获取Arkui全局FC
    // 设置文本样式
    let textStyle1: text.TextStyle = {
      color: { alpha: 255, red: 255, green: 0, blue: 0 },
      fontSize: 100,
      fontFamilies:['HarmonyOS Sans SC']
    };
    let textStyle2: text.TextStyle = {
      color: { alpha: 255, red: 255, green: 0, blue: 0 },
      fontSize: 100,
      fontFamilies:['HarmonyOS Sans TC']
    };
    // 创建一个段落样式对象，以设置排版风格
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: textStyle1,
      align: 3,
      wordBreak:text.WordBreak.NORMAL
    };
    // 创建一个段落生成器
    let ParagraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection)
    // 在段落生成器中设置文本样式
    ParagraphGraphBuilder.pushStyle(textStyle1);
    // 在段落生成器中设置文本内容
    ParagraphGraphBuilder.addText("模块描述\n");
    // 将textStyle2添加到段落样式中，再添加文字
    ParagraphGraphBuilder.pushStyle(textStyle2);
    ParagraphGraphBuilder.addText("模块描述\n");
    // 通过段落生成器生成段落
    let paragraph = ParagraphGraphBuilder.build();
    // 布局
    paragraph.layoutSync(1000);
    paragraph.paint(canvas, 0, 400);
  }
}

// 创建一个MyRenderNode对象
const textNode = new MyRenderNode();
// 定义newNode的大小和位置
textNode.frame = { x: 0, y: 0, width: 400, height: 600 };


class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;
  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext)
    if (this.rootNode == null) {
      return this.rootNode
    }
    const renderNode = this.rootNode.getRenderNode()
    if (renderNode != null) {
      renderNode.frame = { x: 0, y: 0, width: 300, height: 50 }
      renderNode.pivot = { x: 0, y: 0 }
    }
    return this.rootNode
  }
  addNode(node: RenderNode): void {
    if (this.rootNode == null) {
      return
    }
    const renderNode = this.rootNode.getRenderNode()
    if (renderNode != null) {
      renderNode.appendChild(node)
    }
  }
  clearNodes(): void {
    if (this.rootNode == null) {
      return
    }
    const renderNode = this.rootNode.getRenderNode()
    if (renderNode != null) {
      renderNode.clearChildren()
    }
  }
}

@Entry
@Component
struct RenderTest {
  private myNodeController: MyNodeController = new MyNodeController()

  build() {
    Column() {
      Row() {
        NodeContainer(this.myNodeController)
          .height('100%')
      }
      .height('90%')
      .backgroundColor(Color.White)

      Row() {
        Button("getUIFontConfig")
          .width('60%')
          .height('6%')
          .margin(50)
          .onClick(() => {
            this.myNodeController.clearNodes()
            this.myNodeController.addNode(textNode)
            let fontConfig = font.getUIFontConfig();
            console.info("sysFontMfg::font-dir -----------" + String(fontConfig.fontDir.length));
            for (let i = 0; i < fontConfig.fontDir.length; i++) {
              console.info(fontConfig.fontDir[i]);
            }
            console.info("sysFontMfg::generic-------------" + String(fontConfig.generic.length));
            for (let i = 0; i < fontConfig.generic.length; i++) {
              console.info("sysFontMfg::family:" + fontConfig.generic[i].family);
              for (let j = 0; j < fontConfig.generic[i].alias.length; j++) {
                console.info(fontConfig.generic[i].alias[j].name + " " + fontConfig.generic[i].alias[j].weight);
              }
            }
            console.info("sysFontMfg::fallback------------" + String(fontConfig.fallbackGroups.length));
            for (let i = 0; i < fontConfig.fallbackGroups.length; i++) {
              console.info("sysFontMfg::fontSetName:" + fontConfig.fallbackGroups[i].fontSetName);
              for (let j = 0; j < fontConfig.fallbackGroups[i].fallback.length; j++) {
                console.info("sysFontMfg::language:" + fontConfig.fallbackGroups[i].fallback[j].language + " family:" +
                fontConfig.fallbackGroups[i].fallback[j].family);
              }
            }
          })
          .margin({ bottom: 40 , left : 80})
      }.width('100%')
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .layoutWeight(1)
  }
}