//Index.ets
@Entry
@Component
struct UseEffectExample {
  @State isUse: boolean = true;

  build() {
    Stack() {
      Image($r("app.media.mountain"))
        .autoResize(true)
      EffectComponent() {
        Column({ space: 20 }) {
          Column() {
          }
          .position({ x: 0, y: 0 })
          .width(150)
          .height(800)
          .useEffect(this.isUse, EffectType.WINDOW_EFFECT)

          Column() {
          }
          .position({ x: 200, y: 20 })
          .width(150)
          .height(300)
          .useEffect(this.isUse, EffectType.DEFAULT)

          Column() {
          }
          .position({ x: 400, y: 20 })
          .width(150)
          .height(300)
          .useEffect(this.isUse)
        }
        .width('100%')
        .height('100%')
      }
      .backgroundBlurStyle(BlurStyle.Thin)

      Column() {
      }
      .position({ x: 600, y: 0 })
      .width(150)
      .height(800)
      .useEffect(this.isUse, EffectType.WINDOW_EFFECT)

      Row() {
        Button('useEffect')
          .margin(30)
          .onClick(() => {
            this.isUse = !this.isUse;
          })
      }
      .position({ x: 300, y: 450 })
    }
    .backgroundColor(Color.Black)
    .width('100%')
  }
}