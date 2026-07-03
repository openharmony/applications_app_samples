/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { LoginEvent, NavBar } from '@ohos/common';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { LoginCloud } from '@ohos/mine/src/main/ets/model/cloud/LoginCloud';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';

@HMRouter({ pageUrl: 'AccountSecurityPage' })
@Component
export struct AccountSecurityPage {
  build() {
    Column() {
      NavBar({ title: $r('app.string.Account_security') });
      Column() {
        Button($r('app.string.Cancel_account'))
          .width('100%')
          .margin(10)
          .fontColor(Color.Red)
          .backgroundColor(0xe4e7e9)
          .onClick(() => {
            LoginCloud.cancelAccount().then((isSuccess) => {
              if (isSuccess) {
                LoginEvent.sendOutLoginEvent();
                HMRouterMgr.pop({ pageUrl: 'CategoryPage' });
              } else {
                promptAction.showToast({
                  message: $r('app.string.Account_cancellation_failure'),
                  duration: 2000
                });
              }
            }).catch((err: BusinessError) => {
              promptAction.showToast({
                message: $r('app.string.Account_cancellation_failure'),
                duration: 2000
              });
            });
          });
      }
      .backgroundColor(Color.Transparent)
      .borderRadius(15)
      .margin({
        left: 10,
        right: 10,
        top: 5,
        bottom: 5
      });
    }.width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}