@CustomDialog
export struct AboutDialog {
  controller: CustomDialogController

  build() {
    Column() {
      Text('Veggies 1.0\n').fontWeight(FontWeight.Bold).fontSize(20).margin({ top: 10 })
      Text('Build Version: 1.0, built on July 14, 2022\n\nCopyright (c) 2022 Huawei')
      Row() {
        Button('OK', { type: ButtonType.Normal })
          .backgroundColor('#cccccc')
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .borderRadius(10)
          .onClick(() => {
            this.controller.close()
          })
      }.width('100%').justifyContent(FlexAlign.End).margin({ right: 20, bottom: 10 })
    }
  }
}