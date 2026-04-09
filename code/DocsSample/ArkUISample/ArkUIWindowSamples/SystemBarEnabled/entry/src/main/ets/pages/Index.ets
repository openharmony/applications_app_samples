@Entry
@Component
struct Index {
  @StorageProp(`topAvoidHeight`)
  topAvoidHeight: number = 0;
  @StorageProp(`bottomAvoidHeight`)
  bottomAvoidHeight: number = 0;

  text = `Lorem ipsum dolor sit amet, consectetur adipiscing elit.`.repeat(10)

  build() {
    Column() {
      Row() {
        Text(`Top Container`).fontSize(40).textAlign(TextAlign.Center).width(`100%`)
      }
      .backgroundColor(`#2786d9`)
      .padding({ top: this.getUIContext().px2vp(this.topAvoidHeight) + 10, bottom: 10})

      Row() {
        Text(this.text).fontSize(20)
      }.backgroundColor(Color.White).padding(20).borderRadius(15).width(`80%`)

      Row() {
        Text(`Bottom Container`).fontSize(40).textAlign(TextAlign.Center).width(`100%`)
      }
      .backgroundColor(`#96dffa`)
      .padding({ top: 10, bottom: this.getUIContext().px2vp(this.bottomAvoidHeight) + 10})
    }
    .width(`100%`)
    .height(`100%`)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(`#d5d5d5`)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}