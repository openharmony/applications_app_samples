// xxx.ets
@Entry
@Component
struct ForegroundEffectExample {
  build() {
    Row() {
      Image($r('app.media.icon'))
        .width(100)
        .height(100)
        .foregroundEffect({ radius: 20 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}