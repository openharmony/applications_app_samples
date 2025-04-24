// Index.ets
import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI'
import { UIContext } from '@kit.ArkUI'
import { text } from '@kit.ArkGraphics2D'
class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    // 创建画布canvas对象
    const canvas = context.canvas
    // 获取全局字体集实例
    let fontCollection = text.FontCollection.getGlobalInstance() //获取Arkui全局FC
    // 注册自定义字体
    fontCollection.loadFontSync('myFamilyName', 'file:///system/fonts/NotoSansMalayalamUI-SemiBold.ttf')
    // 使用自定义字体
    let myFontFamily: Array<string> = ["myFamilyName"] // 如果已经注册自定义字体，填入自定义字体的字体家族名
    // 设置文本样式
    let myTextStyle: text.TextStyle = {
      color: { alpha: 255, red: 255, green: 0, blue: 0 },
      fontSize: 30,
      // 在文本样式中加入可使用的自定义字体
      fontFamilies: myFontFamily
    };
    // 创建一个段落样式对象，以设置排版风格
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
      align: 3,
      wordBreak:text.WordBreak.NORMAL
    };
    // 创建一个段落生成器
    let ParagraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection)
    // 在段落生成器中设置文本样式
    ParagraphGraphBuilder.pushStyle(myTextStyle);
    // 在段落生成器中设置文本内容
    ParagraphGraphBuilder.addText("Custom font test");
    // 通过段落生成器生成段落
    let paragraph = ParagraphGraphBuilder.build();
    // 布局
    paragraph.layoutSync(1000);
    paragraph.paint(canvas, 0, 400);
  }
}

// 创建一个MyRenderNode对象
const newNode = new MyRenderNode();
// 定义newNode的大小和位置
newNode.frame = { x: 0, y: 0, width: 400, height: 600 };


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
      Row(){
        Button("Draw Text")
          .fontSize('16fp')
          .fontWeight(500)
          .margin({ bottom: 24, right: 12 })
          .onClick(() => {
            this.myNodeController.clearNodes()
            this.myNodeController.addNode(newNode)
          })
          .width('50%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
  }
}