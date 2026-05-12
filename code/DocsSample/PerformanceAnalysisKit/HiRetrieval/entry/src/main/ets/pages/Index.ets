import { hiRetrieval } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  @State userTypeStr: string = "";
  @State deviceTypeStr: string = "";
  @State deviceModelStr: string = "";

  build() {
    List() {
      ListItem() {
        Button($r('app.string.init'))
          .id('InitBtn')
          .fontSize($r('app.float.btn_font_size'))
          .fontWeight(FontWeight.Bold)
          .margin({
            left: $r('app.float.btn_margin'),
            top: $r('app.float.btn_margin'),
            bottom: $r('app.float.btn_margin'),
          })
          .width($r('app.float.btn_width'))
          .height($r('app.float.btn_height'))
          .onClick(() => {
            hiRetrieval.init()
            console.info('succeed to init hiRetrieval')
          })
      }
      ListItem() {
        RelativeContainer() {
          Text($r('app.string.user_type'))
            .id('UserTypeTx')
            .fontSize($r('app.float.text_font_size'))
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              left: { anchor: '__container__', align: HorizontalAlign.Start}
            })
            .height('100%')
            .width('wrapContent')
          TextInput({ placeholder: $r('app.string.user_type_input'), text: $$this.userTypeStr})
            .id('UserTypeInput')
            .fontSize($r('app.float.text_font_size'))
            .borderWidth(1)
            .borderColor(Color.Black)
            .placeholderColor($r('app.color.input_place_holder_color'))
            .alignRules({
              top: { anchor: 'UserTypeTx', align: VerticalAlign.Top },
              left: { anchor: 'UserTypeTx', align: HorizontalAlign.End },
              bottom: { anchor: 'UserTypeTx', align: VerticalAlign.Bottom },
            })
            .constraintSize({
              'minWidth': '50%',
              'maxWidth': '60%'
            })
        }
        .width('100%')
        .height($r('app.float.config_item_height'))
        .padding($r('app.float.config_item_container_padding'))
      }
      ListItem() {
        RelativeContainer() {
          Text($r('app.string.device_type'))
            .id('DeviceTypeTx')
            .fontSize($r('app.float.text_font_size'))
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              left: { anchor: '__container__', align: HorizontalAlign.Start}
            })
            .height('100%')
            .width('wrapContent')
          TextInput({ placeholder: $r('app.string.device_type_input'), text: $$this.deviceTypeStr})
            .id('DeviceTypeInput')
            .fontSize($r('app.float.text_font_size'))
            .borderWidth(1)
            .borderColor(Color.Black)
            .placeholderColor($r('app.color.input_place_holder_color'))
            .alignRules({
              top: { anchor: 'DeviceTypeTx', align: VerticalAlign.Top },
              left: { anchor: 'DeviceTypeTx', align: HorizontalAlign.End },
              bottom: { anchor: 'DeviceTypeTx', align: VerticalAlign.Bottom },
            })
            .constraintSize({
              'minWidth': '50%',
              'maxWidth': '60%'
            })
        }
        .width('100%')
        .height($r('app.float.config_item_height'))
        .padding($r('app.float.config_item_container_padding'))
      }
      ListItem() {
        RelativeContainer() {
          Text($r('app.string.device_model'))
            .id('DeviceModelTx')
            .fontSize($r('app.float.text_font_size'))
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              left: { anchor: '__container__', align: HorizontalAlign.Start}
            })
            .height('100%')
            .width('wrapContent')
          TextInput({ placeholder: $r('app.string.device_model_input'), text: $$this.deviceModelStr})
            .id('DeviceTypeInput')
            .fontSize($r('app.float.text_font_size'))
            .borderWidth(1)
            .borderColor(Color.Black)
            .placeholderColor($r('app.color.input_place_holder_color'))
            .alignRules({
              top: { anchor: 'DeviceModelTx', align: VerticalAlign.Top },
              left: { anchor: 'DeviceModelTx', align: HorizontalAlign.End },
              bottom: { anchor: 'DeviceModelTx', align: VerticalAlign.Bottom },
            })
            .constraintSize({
              'minWidth': '50%',
              'maxWidth': '60%'
            })
        }
        .width('100%')
        .height($r('app.float.config_item_height'))
        .padding($r('app.float.config_item_container_padding'))
      }
      ListItem() {
        Button($r('app.string.participate'))
          .id('ParticipateBtn')
          .fontSize($r('app.float.btn_font_size'))
          .fontWeight(FontWeight.Bold)
          .margin({
            left: $r('app.float.btn_margin'),
            top: $r('app.float.btn_margin'),
            bottom: $r('app.float.btn_margin'),
          })
          .width($r('app.float.btn_width'))
          .height($r('app.float.btn_height'))
          .onClick(() => {
            let cfg: hiRetrieval.HiRetrievalConfig = {
              userType: this.userTypeStr,
              deviceType: this.deviceTypeStr,
              deviceModel: this.deviceModelStr
            }
            try {
              hiRetrieval.participate(cfg)
            } catch (e) {
            }
            console.info('succeed to participate hiRetrieval')
          })
      }
      ListItem() {
        Button($r('app.string.run'))
          .id('RunBtn')
          .fontSize($r('app.float.btn_font_size'))
          .fontWeight(FontWeight.Bold)
          .margin({
            left: $r('app.float.btn_margin'),
            top: $r('app.float.btn_margin'),
            bottom: $r('app.float.btn_margin'),
          })
          .width($r('app.float.btn_width'))
          .height($r('app.float.btn_height'))
          .onClick(() => {
            try {
              hiRetrieval.run()
            } catch (e) {
            }
            console.info('succeed to run hiRetrieval')
          })
      }
      ListItem() {
        Button($r('app.string.quit'))
          .id('QuitBtn')
          .fontSize($r('app.float.btn_font_size'))
          .fontWeight(FontWeight.Bold)
          .margin({
            left: $r('app.float.btn_margin'),
            top: $r('app.float.btn_margin'),
            bottom: $r('app.float.btn_margin'),
          })
          .width($r('app.float.btn_width'))
          .height($r('app.float.btn_height'))
          .onClick(() => {
            try {
              hiRetrieval.quit()
            } catch (e) {
            }
            console.info('succeed to quit hiRetrieval')
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}