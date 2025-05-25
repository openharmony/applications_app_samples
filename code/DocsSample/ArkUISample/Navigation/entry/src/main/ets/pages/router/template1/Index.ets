// 通过router.pushUrl跳转至目标页携带params参数
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

// 定义传递参数的类
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
struct Index {
  async routePage() {
    let options: router.RouterOptions = {
      url: 'pages/router/template1/second',
      params: new routerParams('这是第一页的值', [12, 45, 78])
    }
    // 建议使用this.getUIContext().getRouter().pushUrl()
    router.pushUrl(options)
      .then(() => {
        console.error(`pushUrl finish`);
      })
      .catch((err: ESObject) => {
        console.error(`pushUrl failed, code is ${(err as BusinessError).code}, message is ${(err as BusinessError).message}`);
      })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('这是第一页')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button() {
        Text('next page')
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({ top: 20 })
      .backgroundColor('#ccc')
      .onClick(() => {
        this.routePage()
      })
    }
    .width('100%')
    .height('100%')
  }
}