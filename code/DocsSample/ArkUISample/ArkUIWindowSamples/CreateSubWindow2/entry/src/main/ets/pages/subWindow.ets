// [Start create_sub_window2_subwindow]
// subWindow.ets
@Entry
@Component
struct SubWindow {
  @State message: string = 'Hello subWindow';
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor('#0D9FFB')
  }
}
// [End create_sub_window2_subwindow]