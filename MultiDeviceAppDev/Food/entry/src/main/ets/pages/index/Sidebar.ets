@Preview
@Component
export struct Sidebar {
  @Prop sidebarCurrBp: string
  @State clickFontColor: ResourceColor = Color.Black

  build() {
    Column() {
      Text('External links')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .fontColor(this.clickFontColor)
        .onClick(() => {
          this.clickFontColor = Color.Red
        })
      Text('Cook vegetables')
        .width('100%')
        .textAlign(TextAlign.Start)
        .decoration({ type: TextDecorationType.Underline })
      Text('Pollution-free vegetables')
        .width('100%')
        .textAlign(TextAlign.Start)
        .decoration({ type: TextDecorationType.Underline })
      Text('Distribution of vegetables')
        .width('100%')
        .textAlign(TextAlign.Start)
        .decoration({ type: TextDecorationType.Underline })
    }.backgroundColor('#4d3b9900').height('100%')
    .justifyContent((this.sidebarCurrBp !== 'lg') ? FlexAlign.Center : FlexAlign.Start)
  }
}