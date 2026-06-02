@Entry
@Component
struct FloatWindow {
  @State message: string = 'FloatWindow';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('FloatWindowHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome FloatWindow';
        })
    }
    .height('100%')
    .width('100%')
  }
}