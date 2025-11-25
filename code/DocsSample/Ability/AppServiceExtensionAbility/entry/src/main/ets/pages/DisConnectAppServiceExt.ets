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
// [Start app_ext_service_four_start]
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[DisConnectAppServiceExt]';
const DOMAIN_NUMBER: number = 0xFF00;

let connectionId: number;

@Entry
@Component
struct DisConnectAppServiceExt {
  build() {
    Column() {
      // [StartExclude app_ext_service_four_start]
      Text('top')
        .fontSize(20)
      // [EndExclude app_ext_service_four_start]
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            // [StartExclude app_ext_service_four_start]
            Text('list')
              .fontSize(20)
              .fontColor(Color.White)
            // [EndExclude app_ext_service_four_start]
          }
          // [StartExclude app_ext_service_four_start]
          .id('dis connect service')
          .width('100%')
          .height('100%')
          // [EndExclude app_ext_service_four_start]
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            // connectionId为调用connectServiceExtensionAbility接口时的返回值，需开发者自行维护
            context.disconnectAppServiceExtensionAbility(connectionId).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'disconnectAppServiceExtensionAbility success');
              // 成功断连后台服务
              this.getUIContext().getPromptAction().showToast({
                message: 'SuccessfullyDisconnectBackendService'
              });
            }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, 'disconnectAppServiceExtensionAbility failed');
            });
          })
        }

        // [StartExclude app_ext_service_four_start]
        .backgroundColor(Color.Blue)
        .width('100%')
        .height('50vp')
        // [EndExclude app_ext_service_four_start]
      }

      // [StartExclude app_ext_service_four_start]
      .width('100%')
      // [EndExclude app_ext_service_four_start]
    }

    // [StartExclude app_ext_service_four_start]
    .width('100%')
    // [EndExclude app_ext_service_four_start]
  }
}
// [End app_ext_service_four_start]