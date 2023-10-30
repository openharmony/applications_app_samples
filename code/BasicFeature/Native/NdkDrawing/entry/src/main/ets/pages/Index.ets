import XComponentContext from "../interface/XComponentContext";

const TAG = '[Sample_DrawingAPI]';

@Entry
@Component
struct Index {
  private xComponentContext: XComponentContext | undefined = undefined;

  build() {
    Column() {
      Row() {
        XComponent({ id: 'xcomponentId', type: 'surface', libraryname: 'entry' })
          .onLoad((xComponentContext) => {
            this.xComponentContext = xComponentContext as XComponentContext;
          })
      }.height('88%')

      Row() {
        Button('Draw Path')
          .fontSize('16fp')
          .fontWeight(500)
          .margin({ bottom: 24, right: 12 })
          .onClick(() => {
            console.log(TAG, "Draw Path click");
            if (this.xComponentContext) {
              console.log(TAG, "Draw Path");
              this.xComponentContext.drawPattern();
            }
          })
          .width('33.6%')
          .height(40)
          // .shadow(ShadowStyle.OUTER_DEFAULT_LG)
        Button('Draw Text')
          .fontSize('16fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 12 })
          .onClick(() => {
            console.log(TAG, "draw text click");
            if (this.xComponentContext) {
              console.log(TAG, "draw text");
              this.xComponentContext.drawText();
            }
          })
          .width('33.6%')
          .height(40)
          // .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      // .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
  }
}
