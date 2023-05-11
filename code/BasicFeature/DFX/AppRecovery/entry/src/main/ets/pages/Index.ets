
/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { TitleBar } from '../common/TitleBar'

@Entry
@Component
struct FirstPage {
  storage = LocalStorage.GetShared();
  @State launchReason : string = "";
  @State lastExitReason : string = "";
  @State callerAbility : string = "";
  aboutToAppear() {
    this.launchReason = this.storage.get<string>("launchReason") ?? "Unknown";
    this.lastExitReason = this.storage.get<string>("lastExitReason") ?? "Unknown";
    this.callerAbility = this.storage.get<string>("CurrentAbilityName") ?? "Unknown";
  }

  build() {
    Row() {
      Column() {
        TitleBar()
        Column() {
          Row() {
            Text($r('app.string.current_ability'))
              .fontSize(40)
              .textAlign(TextAlign.Center)
              .margin({ left: 2, right: 4 })
            Text(this.callerAbility)
              .fontSize(40)
              .margin({ left: 4, right: 2 })
              .textAlign(TextAlign.Center)
          }.height('30%')
          Row() {
            Text($r('app.string.launch_reason'))
              .fontSize(40)
              .textAlign(TextAlign.Center)
              .margin({ left: 2, right: 4 })
            Text(this.launchReason)
              .fontSize(40)
              .margin({ left: 4, right: 2 })
              .textAlign(TextAlign.Center)
          }.height('30%')
          Row() {
            Text($r('app.string.last_exit_reason'))
              .fontSize(40)
              .textAlign(TextAlign.Center)
              .margin({ left: 2, right: 4 })
            Text(this.lastExitReason)
              .fontSize(40)
              .margin({ left: 4, right: 2 })
              .textAlign(TextAlign.Center)
          }.height('30%')
        }.height('50%')
        Column() {
          Button($r('app.string.trigger_fault'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
            .onClick( () => {
              router.push({ url: "pages/FaultTriggerPage"});
            });
        }.height('90%')
      }.width('100%')
    }
  }
}