/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *sss
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
import systemDateTime from '@ohos.systemDateTime';
import { Logger } from '../logger/Logger';

@Entry
@Component
struct Index {
  @State message: string = 'EntryAbility'
  @State date: string = '--:--:--'
  @State time: string = '--:--:--'
  @State detailDate: string = '--:--:--'
  private context

  build() {
    Row() {
      Column() {
        Text(this.date)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .id("date")
        Text(this.time)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .id("time")
        Button("StartEntryAbility")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.context.startAbility({
              bundleName: "com.acts.startrecentability",
              abilityName: "EntryAbility",
            }).then(() => {
              Logger.debug("startAbility successful");
            }).catch((err) => {
              Logger.debug("startAbility failed");
            })
          })
          .id("startEntryAbility")
        Button("startSingletonAbility")
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.context.startAbility({
              bundleName: "com.acts.startrecentability",
              abilityName: "SecondAbility",
            }).then(() => {
              Logger.debug("EntryAbility startAbility successful.");
            }).catch((err) => {
              Logger.debug("EntryAbility startAbility dailed.");
            })
          })
          .id("startSingletonAbility")
        Text(this.detailDate)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .id("detailDate")
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear() {
    this.context = getContext(this) as any
    systemDateTime.getDate().then((date) => {
      let dateStr = JSON.stringify(date);
      this.detailDate = dateStr;
      this.date = dateStr.substr(1, dateStr.indexOf('T') - 1);
      this.time = dateStr.substr(dateStr.indexOf('T') + 1, dateStr.length - (dateStr.indexOf('T') + 1) -2);
    });
  }
}