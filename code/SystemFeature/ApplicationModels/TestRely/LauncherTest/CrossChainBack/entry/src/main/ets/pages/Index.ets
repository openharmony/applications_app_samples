@Entry
@Component
struct Index {
  @State message: string = 'UIAbility1'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .id('UIAbility1')
        Button("UIAbility2")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            globalThis.startAbility();
          })
          .id("UIAbility2")
      }
      .width('100%')
    }
    .height('100%')
  }
}