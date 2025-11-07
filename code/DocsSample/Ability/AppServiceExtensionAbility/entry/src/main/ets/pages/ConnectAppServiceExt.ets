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
// [Start app_ext_service_three_start]
import { common, Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[ConnectAppServiceExt]';
const DOMAIN_NUMBER: number = 0xFF00;

let connectionId: number;
let want: Want = {
  deviceId: '',
  bundleName: 'com.samples.appserviceextensionability',
  abilityName: 'MyAppServiceExtAbility'
};

let options: common.ConnectOptions = {
  onConnect(elementName, remote: rpc.IRemoteObject): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onConnect callback');
    if (remote === null) {
      hilog.info(DOMAIN_NUMBER, TAG, `onConnect remote is null`);
      return;
    }
    // 通过remote进行通信
  },
  onDisconnect(elementName): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onDisconnect callback');
  },
  onFailed(code: number): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onFailed callback', JSON.stringify(code));
  }
};

@Entry
@Component
struct ConnectAppServiceExt {
  build() {
    Column() {
      // [StartExclude app_ext_service_three_start]
      Text('top')
        .fontSize(20)
      // [EndExclude app_ext_service_three_start]
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            // [StartExclude app_ext_service_three_start]
            Text('list')
              .fontSize(20)
              .fontColor(Color.White)
            // [EndExclude app_ext_service_three_start]
          }
          // [StartExclude app_ext_service_three_start]
          .id('connect service')
          .width('100%')
          .height('100%')
          // [EndExclude app_ext_service_three_start]
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // UIAbilityContext
            // 建立连接后返回的Id需要保存下来，在解绑服务时需要作为参数传入
            connectionId = context.connectAppServiceExtensionAbility(want, options);
            // 成功连接后台服务
            this.getUIContext().getPromptAction().showToast({
              message: 'SuccessfullyConnectBackendService'
            });
            hilog.info(DOMAIN_NUMBER, TAG, `connectionId is : ${connectionId}`);
          })
        }

        // [StartExclude app_ext_service_three_start]
        .backgroundColor(Color.Blue)
        .width('100%')
        .height('50vp')
        // [EndExclude app_ext_service_three_start]
      }

      // [StartExclude app_ext_service_three_start]
      .width('100%')
      // [EndExclude app_ext_service_three_start]
    }

    // [StartExclude app_ext_service_three_start]
    .width('100%')
    // [EndExclude app_ext_service_three_start]
  }
}
// [End app_ext_service_three_start]