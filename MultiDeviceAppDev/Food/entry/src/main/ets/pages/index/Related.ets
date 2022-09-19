@Preview
@Component
export struct Related {
  @Prop relatedCurrBp: string

  build() {
    Row() {
      Text('All knowledge about vegetables comes from Baidu Encyclopedia.')
    }
    .backgroundColor('#91218cff').width('100%').height('100%')
    .alignItems((this.relatedCurrBp === 'xs' || this.relatedCurrBp === 'sm') ? VerticalAlign.Center : VerticalAlign.Top)
  }
}