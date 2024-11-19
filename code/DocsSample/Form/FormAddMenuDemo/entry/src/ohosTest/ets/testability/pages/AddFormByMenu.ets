// index.ets
import { AddFormMenuItem } from '@kit.ArkUI';
import { formBindingData } from '@kit.FormKit';
import Logger from '../../logger/Logger';

@Component
export default struct AddFormByMenu {
  @State message: string = '长按显示菜单';
  @State city: string = '南京';
  @State time: string = '--';
  private compId: string = '12345678';

  @Builder
  MyMenu() {
    Menu() {
      AddFormMenuItem(
        {
          bundleName: 'com.example.formSample', // 包名
          abilityName: 'EntryAbility', // 模块ability名称
          parameters: {
            'ohos.extra.param.key.form_dimension': 2,
            'ohos.extra.param.key.form_name': 'widget',
            'ohos.extra.param.key.module_name': 'entry'
          },
        },
        this.compId,
        {
          formBindingData: formBindingData.createFormBindingData({
            'city': this.city,
            'time': this.time
          }),
          // formBindingData: formBindingData.createFormBindingData({ data: 'share' }),
          callback: (error, formId) => {
            Logger.info('callback info：error: ' + error + ' formId:' + formId);
          },
          style: {
            options: {
              startIcon: $r('app.media.startIcon'), // 菜单图标,可以自己提供。系统默认采用"sys.media.ic_public_add"
              content: $r('app.string.add_form'), // 菜单内容，可以自己提供。默认使用"sys.string.ohos_add_form_to_desktop"
              //   endIcon: $r("app.media.icon") // 菜单图标，可以自己提供
            }
          }
        }
      )
    }
  }

  aboutToAppear(): void {
    this.time = new Date().toLocaleTimeString();
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .margin({ top: 30, bottom: 20 })

        Text(this.city)
          .fontSize(30)
          .margin({ bottom: 20 })

        Text(this.time)
          .fontSize(30)
          .margin({ bottom: 20 })
      }
      .backgroundImage($r('app.media.CardEvent'))
      .backgroundImageSize(ImageSize.Cover)
      .id(this.compId)
      .width(200)
      .height(200)
      .borderRadius(10)
      .bindContextMenu(this.MyMenu, ResponseType.LongPress, {
        placement: Placement.TopLeft
      })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height('100%')
  }
}