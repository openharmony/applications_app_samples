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
// [Start app_ext_service_one_start]
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[StartAppServiceExt]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct StartAppServiceExt {
  build() {
    Column() {
      // [StartExclude app_ext_service_one_start]
      Text('top')
        .fontSize(20)
      // [EndExclude app_ext_service_one_start]
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            // [StartExclude app_ext_service_one_start]
            Text('list')
              .fontSize(20)
              .fontColor(Color.White)
            // [EndExclude app_ext_service_one_start]
          }
          // [StartExclude app_ext_service_one_start]
          .id('start service')
          .width('100%')
          .height('100%')
          // [EndExclude app_ext_service_one_start]
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '',
              bundleName: 'com.samples.appserviceextensionability',
              abilityName: 'MyAppServiceExtAbility'
            };
            context.startAppServiceExtensionAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting AppServiceExtensionAbility.');
              // 成功启动后台服务
              this.getUIContext().getPromptAction().showToast({
                message: 'SuccessfullyStartBackendService'
              });
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,
                `Failed to start AppServiceExtensionAbility. Code is ${err.code}, message is ${err.message}`);
            });
          })
        }

        // [StartExclude app_ext_service_one_start]
        .backgroundColor(Color.Blue)
        .width('100%')
        .height('50vp')
        // [EndExclude app_ext_service_one_start]
      }
      // [StartExclude app_ext_service_one_start]
      .width('100%')
      // [EndExclude app_ext_service_one_start]
    }

    // [StartExclude app_ext_service_one_start]
    .width('100%')
    // [EndExclude app_ext_service_one_start]
  }
}
// [End app_ext_service_one_start]