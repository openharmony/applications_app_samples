import { fpChangeLpx, vpChangeLpx } from "../models/IssueDetailInfo"

class tagItem {
  key: string = ''
  color: ResourceColor = ''
}

@Component
export default struct cardItem {
  itemLabel: ResourceStr = ''
  @Prop itemValue: string = ''
  isBold: boolean = false
  isDecItem: boolean = false
  @State isShowAllDec: boolean = false
  isShow: boolean = false
  @Prop isFocus: boolean

  @Builder
  tagBuilder(btnKey: string, btnColor: ResourceColor) {
    if (this.isShow) {
      Row() {
        Text(btnKey)
          .fontSize(fpChangeLpx(36))
          .fontColor(Color.White)
          .fontWeight(900)
      }
      .borderRadius(8)
      .backgroundColor(btnColor)
      .height(vpChangeLpx(51))
      .padding({ left: vpChangeLpx(9), right: vpChangeLpx(9) })
    }
  }

  tagItem: tagItem = new tagItem()

  build() {
    if (!this.isDecItem) {
      Row() {
        Column() {
          Text(this.itemLabel)
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .fontSize(fpChangeLpx(36))
            .fontWeight(600)
        }

        Row({ space: vpChangeLpx(12) }) {
          this.tagBuilder(this.tagItem.key, this.tagItem.color)
          Text(this.itemValue)
            .fontSize(fpChangeLpx(36))
            .fontWeight(this.isBold ? 900 : 400)
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'))
        }
        .justifyContent(FlexAlign.End)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    } else {
      Column() {
        Column() {
          Text(this.itemLabel)
            .fontSize(fpChangeLpx(36))
            .fontWeight(600)
            .width('100%')
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'))
        }
        .margin({ bottom: vpChangeLpx(18) })


        Column() {
          Text(this.itemValue)
            .width('100%')
            .fontSize(fpChangeLpx(36))
            .fontWeight(400)
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(this.isShowAllDec ? 1000 : 3)

        }
        .width('100%')
        .margin({ bottom: this.itemValue.length > 70 ? '24lpx' : 0 })
      }
      .width('100%')
    }
  }
}