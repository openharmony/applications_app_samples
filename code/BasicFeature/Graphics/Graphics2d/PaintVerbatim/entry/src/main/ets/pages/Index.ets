import { NodeController, FrameNode, RenderNode, DrawContext, Size, LengthMetrics } from '@ohos.arkui.node';
import NativeRenderComponent from './NativeRender';
import drawing from '@ohos.graphics.drawing';
import {text} from '@kit.ArkGraphics2D';

@Entry
@Component
struct Index {
  @State str: string = 'ABABCEWQ，CACAEWQF，QWADWEA，QWEWQEE， eweeweweweew23131231231';
  build() {
    Column() {
      Row() {
        // file path test
        NativeRenderComponent({ drawFunction: (context: DrawContext) => {
          let x = 0;
          let y = 0;
          for (let i = 0;  i < this.str.length; i++) {
            // 首行缩进
            let isFirst = false;
            if (i == 0) {
              x += 120;
              isFirst = true;
            }
            drawParagraph(context.canvas, this.str.charAt(i), x, y, isFirst)
            x += 60;
          }
        }})
          .id('paint-verbatim')
          .backgroundColor(0x00ff00)
          .width('1200px')
          .height(300)
      }
    }
    .height('100%')
  }
}

let fontCollection = new text.FontCollection();
function drawParagraph(canvas: drawing.Canvas, str: string, x: number, y:number, isFirst: boolean) {
  let builder = new text.ParagraphBuilder({}, fontCollection);
  let myTextStyle: text.TextStyle = {
    color : {alpha: 255, red: 255, green: 0, blue: 0},
    fontSize: 60,
  };
  // 首字加粗
  if (isFirst) {
    myTextStyle = {
      color : {alpha: 255, red: 255, green: 0, blue: 0},
      fontSize: 70,
      fontWeight: text.FontWeight.W900
    };
  }
  builder.pushStyle(myTextStyle);
  builder.addText(str);
  let paragraph = builder.build();
  // 行数处理
  let index = Math.floor(x / 1200);
  // 获取位置x为横轴，y为纵轴
  if (index > 0) {
    y += index * 60;
    x -= index * 1200;
  }
  paragraph.layoutSync(1000);
  paragraph.paint(canvas, x, y);
  // 获取metrics属性
  let metrics = paragraph.getLineMetrics();
  metrics.forEach(metric => {
    // 获取属性
    let startIndex = metric.startIndex
    let endIndex = metric.endIndex
    let ascent = metric.ascent
    let descent = metric.descent
    let height = metric.height
    let width = metric.width
    let left = metric.left
  })
}