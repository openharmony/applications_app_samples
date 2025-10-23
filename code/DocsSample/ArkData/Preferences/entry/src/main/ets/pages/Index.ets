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

import { PreferencesInterface } from './PreferencesInterface';

let preferences: PreferencesInterface = new PreferencesInterface();

@Entry
@Component
struct Index {
  @State text: string = 'The green button calls the interface, and the blue button sets the properties.';

  @State encryptSelect:number = 0
  private encryptLst:string[] = ['false','true']

  build() {
    Column({space:2}) {
      Row({space:2}) {
        Button('GetPreferencesSync').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.GetPreferencesSync();
          })
        Button('GetPreferencesSyncGSKV').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.GetPreferencesSyncGSKV();
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('99%')
      .height('6%')
      .margin({ bottom: 10 })

      Row({space:2}) {
        Button('PutSync').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.PutSync();
          })
        Button('GetSync').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.GetSync();
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('99%')
      .height('6%')
      .margin({ bottom: 10 })

      Row({space:2}) {
        Button('DeleteSync').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.DeleteSync();
          })
        Button('Flush').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.Flush();
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('99%')
      .height('6%')
      .margin({ bottom: 10 })

      Row({space:2}) {
        Button('XMLOn').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.XMLOn();
          })
        Button('GSKVOn').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.GSKVOn();
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('99%')
      .height('6%')
      .margin({ bottom: 10 })

      Row({space:2}) {
        Button('DeleteXMLPreferences').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.DeleteXMLPreferences();
          })
        Button('DeleteGSKVPreferences').fontSize(10).fontWeight(FontWeight.Normal).type(ButtonType.Capsule).margin({}).width('50%').height('100%')
          .onClick(() => {
            preferences.DeleteGSKVPreferences();
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('99%')
      .height('6%')
      .margin({ bottom: 10 })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}