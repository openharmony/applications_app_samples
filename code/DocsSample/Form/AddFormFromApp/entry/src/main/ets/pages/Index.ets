import { formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { Prompt } from '@kit.ArkUI';

@Entry
@Component
struct Index {

  build() {
    Row() {
      Column() {
        //添加拉起卡片管理页面按钮，点击按钮后调用openFormManager方法，拉起卡片管理页面1··
        Button('拉起卡片管理页面')
          .onClick(() => {
            const want: Want = {
              bundleName: 'com.example.myapplication',
              abilityName: 'EntryFormAbility',
              parameters: {
                'ohos.extra.param.key.form_dimension': 2,
                'ohos.extra.param.key.form_name': 'widget',
                'ohos.extra.param.key.module_name': 'entry'
              },
            };
            try {
              formProvider.openFormManager(want);
              Prompt.showToast({ message: "暂不对外开放" })
            } catch (error) {
              console.error(`catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message})`);
            }
          })
          .margin({ top: 10, bottom: 10 })
      }
      .width('100%')
    }
    .height('100%')
  }
}