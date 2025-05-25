// 在second页面中接收传递过来的参数
import { router } from '@kit.ArkUI';

class innerParams {
  array: number[];

  constructor(tuple: number[]) {
    this.array = tuple;
  }
}

class routerParams {
  text: string;
  data: innerParams;

  constructor(str: string, tuple: number[]) {
    this.text = str;
    this.data = new innerParams(tuple);
  }
}

@Entry
@Component
struct Second {
  private content: string = "这是第二页";
  // 建议使用this.getUIContext().getRouter().getParams()
  @State text: string = (this.getUIContext().getRouter().getParams() as routerParams).text;
  @State data: object = (this.getUIContext().getRouter().getParams() as routerParams).data;
  @State secondData: string = '';

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(`${this.content}`)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Text(this.text)
        .fontSize(30)
        .onClick(() => {
          this.secondData = (this.data['array'][1]).toString();
        })
        .margin({ top: 20 })
      Text(`第一页传来的数值:${this.secondData}`)
        .fontSize(20)
        .margin({ top: 20 })
        .backgroundColor('red')
    }
    .width('100%')
    .height('100%')
  }
}