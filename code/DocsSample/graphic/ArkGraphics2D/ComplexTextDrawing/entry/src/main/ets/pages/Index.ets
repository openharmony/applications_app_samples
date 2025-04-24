import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI'
import { UIContext } from '@kit.ArkUI'
import { drawing } from '@kit.ArkGraphics2D'
import { text } from '@kit.ArkGraphics2D'
import { common2D } from '@kit.ArkGraphics2D'

// 创建一个MyRenderNode类，并绘制文本。
class MyRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    // 绘制代码逻辑写在这里
    let canvas = context.canvas;

    // 初始化装饰线对象
    let decorations: text.Decoration =
      {
        // 装饰线类型，支持上划线、下划线、删除线
        textDecoration: text.TextDecorationType.UNDERLINE,
        // 装饰线颜色
        color: {
          alpha: 255,
          red: 255,
          green: 0,
          blue: 0
        },
        // 装饰线样式，支持波浪，虚线，直线等
        decorationStyle:text.TextDecorationStyle.SOLID,
        // 装饰线的高度
        decorationThicknessScale: 1
      };

    let myTextStyle: text.TextStyle = {
      color: {
        alpha: 255,
        red: 255,
        green: 0,
        blue: 0
      },
      fontSize: 150,
      // 设置装饰线
      decoration: decorations,
      // 可变字体
      fontVariations: [{axis: 'wght', value: 555}],
      // 文本阴影
      textShadows: [{color: { alpha: 0xFF, red: 0xFF, green: 0x00, blue: 0x00 }, point: {x:10,y:10}, blurRadius: 10}],
      // 开启字体特征
      fontFeatures: [{name: 'frac', value: 1}]
    };

    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle
    };

    let fontCollection = text.FontCollection.getGlobalInstance();
    let ParagraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);

    // 初始化占位符对象
    let myPlaceholderSpan: text.PlaceholderSpan = {
      width: 150,//宽度
      height: 150,//高度
      align: text.PlaceholderAlignment.BOTTOM_OF_ROW_BOX, //基线对齐策略
      baseline: text.TextBaseline.ALPHABETIC,//使用的文本基线类型
      baselineOffset: 100//相比基线的偏移量。只有对齐策略是OFFSET_AT_BASELINE时生效
    };
    // 添加占位符
    ParagraphGraphBuilder.addPlaceholder(myPlaceholderSpan)

    // 更新文本样式
    ParagraphGraphBuilder.pushStyle(myTextStyle);
    // 添加文本
    ParagraphGraphBuilder.addText("1/2 1/3 1/4 ");

    // 生成段落
    let paragraph = ParagraphGraphBuilder.build();
    // 布局
    paragraph.layoutSync(600);
    // 绘制文本
    paragraph.paint(canvas, 0, 0);

    let placeholderRects = paragraph.getRectsForPlaceholders();//获取全部占位符的数组
    let left = placeholderRects[0].rect.left// 获取第一个占位符的左边界
    let top = placeholderRects[0].rect.top// 获取第一个占位符的上边界
    let right = placeholderRects[0].rect.right// 获取第一个占位符的有边界
    let bottom = placeholderRects[0].rect.bottom// 获取第一个占位符的下边界
    let pen: drawing.Pen =  new drawing.Pen()
    let pen_color : common2D.Color = { alpha: 0xFF, red: 0xFF, green: 0x00, blue: 0x00 }
    pen.setColor(pen_color)
    canvas.attachPen(pen)
    canvas.drawRect(left,top,right,bottom)// 使用draw方法绘制占位符矩形框
  }
}

// 创建一个MyMultilingualTextRenderNode类，并绘制文本。
class MyMultilingualTextRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    // 绘制代码逻辑写在这里
    let canvas = context.canvas;

    //初始化文本样式
    let myTextStyle: text.TextStyle = {
      color: {
        alpha: 255,
        red: 255,
        green: 0,
        blue: 0
      },
      fontSize: 50,
      // 设置语言偏好为简体中文
      locale: "zh-Hans"
    };
    //初始化段落样式
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
    };

    //初始化段落对象，并添加文本
    let fontCollection = text.FontCollection.getGlobalInstance();
    let ParagraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    // 更新文本样式
    ParagraphGraphBuilder.pushStyle(myTextStyle);
    // 添加文本
    ParagraphGraphBuilder.addText("你好，世界");

    // 生成段落
    let paragraph = ParagraphGraphBuilder.build();
    // 布局
    paragraph.layoutSync(1250);
    // 绘制文本
    paragraph.paint(canvas, 10, 0);

  }
}


// 创建一个MyRenderNode类，并绘制文本。
class MyMultiLineRenderNode extends RenderNode {
  async draw(context: DrawContext) {
    // 绘制代码逻辑写在这里
    let canvas = context.canvas;

    //初始化文本样式
    let myTextStyle: text.TextStyle = {
      color: {
        alpha: 255,
        red: 255,
        green: 0,
        blue: 0
      },
      fontSize: 30,
    };
    //初始化段落样式
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
      // 本文对齐方式
      align: text.TextAlign.LEFT,
      // 最大行数
      maxLines: 3,
      // 断词策略
      wordBreak: text.WordBreak.BREAK_WORD
    };

    //初始化段落对象，并添加占位符和文本
    let fontCollection = text.FontCollection.getGlobalInstance();
    let ParagraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    // 更新文本样式
    ParagraphGraphBuilder.pushStyle(myTextStyle);
    // 添加文本
    ParagraphGraphBuilder.addText("Hello World Hello World Hello World Hello World Hello WorldHelloWorld " +
      "Hello World Hello World Hello World Hello World Hello World Hello World Hello WorldHelloWorld " +
      "Hello World Hello World Hello World Hello WorldHelloWorld ");

    // 生成段落
    let paragraph = ParagraphGraphBuilder.build();
    // 布局
    paragraph.layoutSync(550);
    // 绘制文本
    paragraph.paint(canvas, 10, 0);

  }
}

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext)
    if (this.rootNode == null) {
      return this.rootNode
    }
    const renderNode = this.rootNode.getRenderNode()
    if (renderNode != null) {
      renderNode.frame = {
        x: 0,
        y: 0,
        width: 10,
        height: 500
      }
      renderNode.pivot = { x: 50, y: 50 }
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

// 创建一个MyRenderNode对象
const textNode = new MyRenderNode();
// 定义textNode的大小和位置
textNode.frame = { x: 0, y: 0, width: 400, height: 600 };

// 创建一个MyMultilingualTextRenderNode对象
const multilingualTextNode = new MyMultilingualTextRenderNode();
// 定义newNode的大小和位置
multilingualTextNode.frame = { x: 0, y: 0, width: 400, height: 600 };

// 创建一个MyMultiLineRenderNode对象
const multiLineTextNode = new MyMultiLineRenderNode();
// 定义multiLineTextNode的大小和位置
multiLineTextNode.frame = { x: 0, y: 0, width: 400, height: 600 };

@Entry
@Component
struct RenderTest {
  private myNodeController: MyNodeController = new MyNodeController()
  build() {
    Column() {
      Row(){
        NodeContainer(this.myNodeController)
          .height('100%')
          .position({x : 50, y: 25})
        Button("Draw complex text")
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.myNodeController.clearNodes()
            this.myNodeController.addNode(textNode)
          })
          .width('30.3%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button("Multilingual text")
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.myNodeController.clearNodes()
            this.myNodeController.addNode(multilingualTextNode)
          })
          .width('33.3%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button("Multi-line text")
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.myNodeController.clearNodes()
            this.myNodeController.addNode(multiLineTextNode)
          })
          .width('33.3%')
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