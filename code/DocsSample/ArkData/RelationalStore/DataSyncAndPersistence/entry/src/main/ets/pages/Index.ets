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

import { setDefaultDistributedTables } from './datasync/RdbDataSync';
import { setCollaborationDistributedTables } from './datasync/RdbDataSync';
import { dataChange } from './datasync/RdbDataSync';
import { syncPush } from './datasync/RdbDataSync';
import { syncPull } from './datasync/RdbDataSync';
import { remoteQuery } from './datasync/RdbDataSync';
import { rdbDataPersistence } from './datapersistence/RdbDataPersistence';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Button() {
        Text('setDefaultDistributedTables')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width("70%")
      .height("5%")
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        setDefaultDistributedTables();
      })

      Button() {
        Text('setCollaborationDistributedTables')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width("70%")
      .height("5%")
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        setCollaborationDistributedTables();
      })

      Button() {
        Text('dataChange')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width("70%")
      .height("5%")
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        dataChange();
      })

      Button() {
        Text('syncPush')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width("70%")
      .height("5%")
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        syncPush();
      })

      Button() {
        Text('syncPull')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width("70%")
      .height("5%")
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        syncPull();
      })
      Button() {
        Text('remoteQuery')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width("70%")
      .height("5%")
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        remoteQuery();
      })

      Button() {
        Text('dataPersistence')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width("70%")
      .height("5%")
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        rdbDataPersistence();
      })
    }
    .height('100%')
    .width('100%')
  }
}