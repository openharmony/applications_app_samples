
@Entry
@Component
struct PageEmptyWindow {
  private storage: LocalStorage | undefined = this.getUIContext()?.getSharedLocalStorage();
  private windowName: string | undefined = this.storage?.get<string>('windowName');

  build() {
    Row() {
      Column() {
        Text(this.windowName)
          .fontSize(20)
          .size({ width: '100%', height: '50' })
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
    }
    .height('100%')
  }
}