const TAG = 'NAS_loginProgress'

@CustomDialog
export struct NasLoginProgress {
  controller?: CustomDialogController

  build() {
    Row() {
      Text($r('app.string.nas_connecting'))
        .fontFamily("HarmonyOS Sans")
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .fontSize("48lpx")
      Blank()
      LoadingProgress()
        .color(Color.White)
        .width("80lpx")
        .height("80lpx")
    }
    .padding('78lpx')
    .width('100%')
    .height('100%')
  }
}
