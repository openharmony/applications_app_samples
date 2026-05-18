
@Component
export struct headerBar {
  build() {
    Column() {
      Row() {
        Text($r('app.string.allApp'))
          .fontSize('60lpx')
          .fontWeight(500)
          .fontColor('rgba(255, 255, 255, 0.86)')
          .margin({
            left: '96lpx'
          })
        Blank()
        Text($r('app.string.mune_tips'))
          .fontSize('36lpx')
          .fontColor('#DDFFFFFF')
          .margin({
            right: '96lpx'
          })
      }
      .height('15%')
      .width('100%')
    }
  }
}