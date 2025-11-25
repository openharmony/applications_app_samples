/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start FuncAbilityA]
// [Start FuncAbilityA_Result]
// [Start FuncAbilityA_For_Result]
// [Start FuncAbility_Cold]
// [Start FuncAbility_Hot]
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[MainPage]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct MainPage {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      List({ initialIndex: 0, space: 8 }) {

        // [StartExclude FuncAbility_Hot]
        // [StartExclude FuncAbility_Cold]
        // [StartExclude FuncAbilityA_Result]
        // [StartExclude FuncAbilityA_For_Result]
        ListItem() {
          Row() {
            // [StartExclude FuncAbilityA]
            // app.string.Start_AbilityA资源文件中的value值为'StartFuncAbilityA'
            Button($r('app.string.Start_AbilityA'))
              .width('60%');
            // [EndExclude FuncAbilityA]
          }
          .onClick(() => {
            // context为Ability对象的成员，在非Ability对象内部调用需要
            // 将Context对象传递过去
            let wantInfo: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.uiabilityinteraction',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'FuncAbilityA',
              parameters: {
                // 自定义信息
                // app.string.main_page_return_info资源文件中的value值为'来自EntryAbility MainPage页面'
                info: $r('app.string.main_page_return_info')
              },
            };
            // context为调用方UIAbility的UIAbilityContext
            this.context.startAbility(wantInfo).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'startAbility success.');
            }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, 'startAbility failed.');
            });
          })
        }
        // [EndExclude FuncAbilityA_For_Result]
        // [EndExclude FuncAbilityA_Result]

        // [StartExclude FuncAbilityA]
        ListItem() {
          Row() {
            // [StartExclude FuncAbilityA_Result]
            // [StartExclude FuncAbilityA_For_Result]
            // app.string.Start_AbilityA_Result资源文件中的value值为'StartFuncAbilityAWithResult'
            Button($r('app.string.Start_AbilityA_Result'))
              .width('60%');
            // [EndExclude FuncAbilityA_For_Result]
            // [EndExclude FuncAbilityA_Result]
          }
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            const RESULT_CODE: number = 1001;
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.uiabilityinteraction',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'FuncAbilityA',
              parameters: {
                // 自定义信息
                // app.string.main_page_return_info资源文件中的value值为'来自EntryAbility MainPage页面'
                info: $r('app.string.main_page_return_info')
              }
            };
            context.startAbilityForResult(want).then((data) => {
              if (data?.resultCode === RESULT_CODE) {
                // 解析被调用方UIAbility返回的信息
                let info = data.want?.parameters?.info;
                hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(info) ?? '');
                if (info !== null) {
                  this.getUIContext().getPromptAction().showToast({
                    message: JSON.stringify(info)
                  });
                }
              }
              hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(data.resultCode) ?? '');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability for result. Code is ${err.code}, message is ${err.message}`);
            });
          })
        }
        // [EndExclude FuncAbility_Cold]

        // [StartExclude FuncAbilityA_Result]
        // [StartExclude FuncAbilityA_For_Result]
        ListItem() {
          Row() {
            // [StartExclude FuncAbility_Cold]
            // app.string.Cold_Start_Page资源文件中的value值为'ColdStartPage'
            Button($r('app.string.Cold_Start_Page'))
              .width('60%');
            // [EndExclude FuncAbility_Cold]
          }
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.uiabilityinteraction',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'ColdStartAbility',
              parameters: { // 自定义参数传递页面信息
                router: 'funcA'
              }
            };
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting ability.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
            });
          })
        }
        // [EndExclude FuncAbility_Hot]

        // [StartExclude FuncAbility_Cold]
        ListItem() {
          Row() {
            // [StartExclude FuncAbility_Hot]
            // app.string.Hot_Start_Page资源文件中的value值为'HotStartPage'
            Button($r('app.string.Hot_Start_Page'))
              .width('60%');
            // [EndExclude FuncAbility_Hot]
          }
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.uiabilityinteraction',
              moduleName: 'entry', // moduleName非必选
              abilityName: 'HotStartAbility',
              parameters: { // 自定义参数传递页面信息
                router: 'funcA'
              }
            };
            // context为调用方UIAbility的UIAbilityContext
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting ability.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
            });
          })
        }
        // [EndExclude FuncAbility_Cold]
        // [EndExclude FuncAbilityA_For_Result]
        // [EndExclude FuncAbilityA_Result]
        // [EndExclude FuncAbilityA]
      }
      // [StartExclude FuncAbilityA]
      // [StartExclude FuncAbilityA_Result]
      // [StartExclude FuncAbilityA_For_Result]
      // [StartExclude FuncAbility_Cold]
      // [StartExclude FuncAbility_Hot]
      .alignListItem(ListItemAlign.Center)
      // [EndExclude FuncAbility_Hot]
      // [EndExclude FuncAbility_Cold]
      // [EndExclude FuncAbilityA_For_Result]
      // [EndExclude FuncAbilityA_Result]
      // [EndExclude FuncAbilityA]
    }
    // [StartExclude FuncAbilityA]
    // [StartExclude FuncAbilityA_Result]
    // [StartExclude FuncAbilityA_For_Result]
    // [StartExclude FuncAbility_Cold]
    // [StartExclude FuncAbility_Hot]
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    // [EndExclude FuncAbility_Hot]
    // [EndExclude FuncAbility_Cold]
    // [EndExclude FuncAbilityA_For_Result]
    // [EndExclude FuncAbilityA_Result]
    // [EndExclude FuncAbilityA]
  }
}
// [End FuncAbility_Hot]
// [End FuncAbility_Cold]
// [End FuncAbilityA_For_Result]
// [End FuncAbilityA_Result]
// [End FuncAbilityA]