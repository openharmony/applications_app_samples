@Entry
@Component
struct SecurityHome {
  build() {
    Column() {
      Text('尊敬的开发者您好，该设备为非标准设备，无法使用此应用。')
        .fontSize('150lpx')
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}