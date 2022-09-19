@Preview
@Component
export struct Contact {
  build() {
    Column() {
      Divider().strokeWidth(1).color('#19001111')
      Column() {
        Text('Contact us')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)
        Text('Address:410 JiangHong Road, ZhangLi')
          .width('100%')
          .textAlign(TextAlign.Start)
        Text('Tel:0000-00000000')
          .width('100%')
          .textAlign(TextAlign.Start)
        Text('Email:test@test.com')
          .width('100%')
          .textAlign(TextAlign.Start)
      }
    }.height('100%').justifyContent(FlexAlign.Center)
  }
}