// [Start index]
// entry/src/main/ets/pages/index.ets
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { formProvider } from '@kit.FormKit';

@Entry
@Component
struct Index {
  build() {
    Column({ space: 20 }) {
      Button("reloadForms")
        .onClick(() => {
          try {
            let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let moduleName: string = 'entry';
            let abilityName: string = 'EntryFormAbility';
            let formName: string = 'reloadByUIAbilityCard';
            formProvider.reloadForms(context, moduleName, abilityName, formName).then((reloadNum: number) => {
              console.info(`reloadForms success, reload number: ${reloadNum}`);
            }).catch((error: BusinessError) => {
              console.error(`promise error, code: ${error.code}, message: ${error.message})`);
            });
          } catch (error) {
            console.error(`catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message})`);
          }
        })
      Button("reloadAllForms")
        .onClick(() => {
          try {
            let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            formProvider.reloadAllForms(context).then((reloadNum: number) => {
              console.info(`reloadAllForms success, reload number: ${reloadNum}`);
            }).catch((error: BusinessError) => {
              console.error(`promise error, code: ${error.code}, message: ${error.message})`);
            });
          } catch (error) {
            console.error(`catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message})`);
          }
        })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}
// [end index]