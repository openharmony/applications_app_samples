import testNapi from 'libentry.so';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Button() {
        Text('getVectorStore_NDK')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width("50%")
      .height("8%")
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        testNapi.add();
      })
    }
    .height('100%')
    .width('100%')
  }
}
