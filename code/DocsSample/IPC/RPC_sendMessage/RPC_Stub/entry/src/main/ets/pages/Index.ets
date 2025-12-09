/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import hilog from '@ohos.hilog';
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, PermissionRequestResult, common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
        })

      Button('getPermission')
        .onClick(() =>  {
        try {
          let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
          atManager.requestPermissionsFromUser(this.context, ['ohos.permission.DISTRIBUTED_DATASYNC'], (err: BusinessError, data: PermissionRequestResult) => {
            if (err) {
              hilog.error(0x0000, 'testTag', 'RPC_Stub: requestPermissionsFromUser fail, code is ' + err.code + 'message is ' + err.message);
            } else {
              hilog.info(0x0000, 'testTag','RPC_Stub: requestPermissionsFromUser success, result is ' + JSON.stringify(data));
              hilog.info(0x0000, 'testTag','RPC_Stub: requestPermissionsFromUser data permissions:' + data.permissions);
              hilog.info(0x0000, 'testTag','RPC_Stub: requestPermissionsFromUser data authResults:' + data.authResults);
              hilog.info(0x0000, 'testTag','RPC_Stub: requestPermissionsFromUser data dialogShownResults:' + data.dialogShownResults);
            }
          });
        }catch (err) {
          let code = (err as BusinessError).code;
          let message = (err as BusinessError).message;
          hilog.error(0x0000, 'testTag', 'RPC_Stub: getPermission failed, code is ' + code + 'message is ' + message);
        }
      })
        .width('100%')
        .height(60)
    }
    .height('100%')
    .width('100%')
  }
}