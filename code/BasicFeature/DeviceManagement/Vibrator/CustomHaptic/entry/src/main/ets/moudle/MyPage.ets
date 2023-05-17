import Menu from '@ohos.prompt'
@Component
export default struct SelectorIndex {
  @State selectContent:string = '低强度模式'
  @Link vibrationIntensity:string
  build() {
    Column({space:30}) {
      Column({space:10}) {
        Row({ space: 10 }) {
          Image($r("app.media.set")).height(20).width(20)
          Text('振动强度设置:').fontColor(Color.White).fontSize(20)
          Text(this.selectContent).fontSize(16).fontColor("#ffcbc2c2")
          Image($r("app.media.xiala")).height(16).width(16)
        }.height("100%").width("80%")
        .onClick(() => {
          ActionSheet.show({
            title: '振动强度设置',
            message: '强度选择',
            autoCancel: true,
            confirm: {
              value: '取消',
              action: () => {
                console.log('Get Alert Dialog handled')
              }
            },
            cancel: () => {
              console.log('actionSheet canceled')
            },
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: -10 },
            sheets: [
/*              {
                icon:$r("app.media.icon"),
                title: 'OHOS音频转振动',
                action: () => {
                  this.selectContent = 'OHOS'
                  this.vibrationIntensity = 'OHOS'
                  console.log('OHOS音频转振动')
                }
              },*/
              {
                icon:$r("app.media.high"),
                title: '高强度模式',
                action: () => {
                  this.selectContent = '高强度模式'
                  this.vibrationIntensity = 'H'
                  console.log('高强度模式')
                }
              },
              {
                icon:$r("app.media.middle"),
                title: '中强度模式',
                action: () => {
                  this.selectContent = '中强度模式'
                  this.vibrationIntensity = 'M'
                  console.log('中强度模式')
                }
              },
              {
                icon:$r("app.media.low"),
                title: '低强度模式',
                action: () => {
                  this.selectContent = '低强度模式'
                  this.vibrationIntensity = 'L'
                  console.log('低强度模式')
                }
              }
            ]
          })
        }).width("80%")
        Row() {
        }.height(1).width("85%").backgroundColor('#ff404048')
      }
      Column({space:10}) {
        Row({ space: 10 }) {
          Image($r("app.media.banben")).width(20).height(20)
          Text('版本:               ').fontColor(Color.White).fontSize(20).backgroundColor('#cc191a32')
          Text('v1.0').fontSize(20).fontColor("#ff706666")
        }.width("80%")

        Row() {
        }.height(1).width("85%").backgroundColor("#ff404048")
      }
      Column({space:10}) {
        Row({ space: 10 }) {
          Image($r("app.media.bangzhu")).width(20).height(20)
          Text('帮助与支持:    ').fontColor(Color.White).fontSize(20).backgroundColor('#cc191a32')
          Text('无').fontSize(20).fontColor("#ff706666")
        }.width("80%")
        Row() {
        }.height(1).width("85%").backgroundColor("#ff27272b")
      }
      Column({space:10}) {
        Row({ space: 10 }) {
          Image($r("app.media.xinxi")).width(20).height(20)
          Text('开发人员信息:').fontColor(Color.White).fontSize(20).backgroundColor('#cc191a32')
          Text('无').fontSize(20).fontColor("#ff706666")
        }.width("80%")

        Row() {
        }.height(1).width("85%").backgroundColor("#ff27272b")
      }
    }
  }
}