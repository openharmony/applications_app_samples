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
import hilog from '@ohos.hilog';
@Entry
@Component
struct Index {
  storage = LocalStorage.GetShared();
  @State launchParam : string = "";
  @State wantParam : string = "";
  aboutToAppear() {
    this.launchParam = this.storage.get<string>("launchParam") ?? "UnknownLaunchParam";
    this.wantParam = this.storage.get<string>("wantParam") ?? "UnknownWantParam";
  }

  build() {
    Row() {
      Column() {
        Text('RecoveryPage')
          .fontSize(50)
          .fontWeight(FontWeight.Bold);
        Divider();
        Button("TextAbility")
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .onClick( () => {
            if (globalThis.curActiveAbility == undefined) {
              return;
            }
            let want = {
              bundleName: "com.samples.recovery",
              abilityName: "SecondAbility"
            };
            globalThis.curActiveAbility.context.startAbility(want);
          });
        Divider();
        Button("EntryAbility")
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .onClick( () => {
            if (globalThis.curActiveAbility == undefined) {
              return;
            }
            let want = {
              bundleName: "com.samples.recovery",
              abilityName: "EntryAbility"
            };
            globalThis.curActiveAbility.context.startAbility(want);
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}