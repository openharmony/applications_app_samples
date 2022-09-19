import { AboutDialog } from './AboutDialog'

@Preview
@Component
export struct Menus {
  gridNum: number = 1
  diaController: CustomDialogController = new CustomDialogController({
    builder: AboutDialog()
  })

  @Styles pressedStyles() {
    .backgroundColor('#2d099999')
  }

  build() {
    GridRow() {
      GridCol({ span: { xs: 12, sm: 12, md: 3 } }) {
        Text('Home').width('100%')
          .stateStyles({ pressed: this.pressedStyles })
      }.borderWidth(1).borderColor(0xAFEEEE)

      GridCol({ span: { xs: 12, sm: 12, md: 3 } }) {
        Text('Products').width('100%')
          .stateStyles({ pressed: this.pressedStyles })
      }.borderWidth(1).borderColor(0xAFEEEE)

      GridCol({ span: { xs: 12, sm: 12, md: 3 } }) {
        Text('Market').width('100%')
          .stateStyles({ pressed: this.pressedStyles })
      }.borderWidth(1).borderColor(0xAFEEEE)

      GridCol({ span: { xs: 12, sm: 12, md: 3 } }) {
        Text('About').textAlign(TextAlign.Start).width('100%')
          .stateStyles({ pressed: this.pressedStyles })
          .onClick(() => {
            this.diaController.open()
          })
      }.borderWidth(1).borderColor(0xAFEEEE)
    }
  }
}