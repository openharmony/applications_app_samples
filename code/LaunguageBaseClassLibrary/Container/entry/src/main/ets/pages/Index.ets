/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { AddDialog } from '../common/AddDialog'
import Information from '../model/Information'
import Logger from '../model/Logger'
import ArrayList from '@ohos.util.ArrayList'

class MyDataSource {
  public dataArray: ArrayList<Information> = new ArrayList()
  private listeners: DataChangeListener[] = []

  constructor(ele) {
    for (var index = 0;index < ele.length; index++) {
      this.dataArray.add(ele[index])
    }
  }

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): Information {
    return this.dataArray[index]
  }

  public addData(index: number, data: Information): void {
    this.dataArray.removeByIndex(index)
    this.notifyDataAdd(index)
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }
}

const TAG = '[index]'

@Entry
@Component
struct Index {
  @State writeInformation: Information = new Information(0, '', NaN, '')
  @State isInserted: boolean = false
  @State list: MyDataSource = new MyDataSource([])
  private informations: ArrayList<Information> = new ArrayList()
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({
      isInserted: this.isInserted,
      saveData: (isInserted: boolean, writeInformation: Information) => {
        if (!isInserted) {
          return;
        }
        if (this.informations.length === 0) {
          writeInformation.id = 0
          Logger.info(TAG, `writeInformation.id= ${writeInformation.id}`)
        } else {
          writeInformation.id = this.informations.length
          Logger.info(TAG, `writeInformation.id= ${writeInformation.id}`)
        }
        this.informations.add(writeInformation)
        this.list['dataArray'] = this.informations
        this.list.notifyDataReload()
        Logger.info(TAG, `this.list= ${this.list}`)
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default
  })

  build() {
    Column() {
      Row() {
        Text($r('app.string.entry_MainAbility'))
          .width('90%')
          .fontColor(Color.White)
          .fontSize(30)
        Button() {
          Image($r('app.media.add'))
            .height(45)
            .width('100%')
            .objectFit(ImageFit.Contain)
            .align(Alignment.End)
        }
        .key('addBtn')
        .width('10%')
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.header_bg'))
        .align(Alignment.End)
        .onClick(() => {
          this.dialogController.open()
          Logger.info(TAG, `enter the AddDialog`)
        })
      }
      .height(100)
      .width('100%')
      .backgroundColor($r('app.color.header_bg'))
      .padding({ left: 15, right: 15 })

      List({ space: 20, initialIndex: 0 }) {
        LazyForEach(this.list, (item, index) => {
          ListItem() {
            Row() {
              Image($r('app.media.contact'))
                .width('20%')
                .objectFit(ImageFit.Contain)
              Column() {
                Row() {
                  Text($r("app.string.contact_name"))
                    .fontSize(24)
                    .fontColor(Color.Black)
                  Text(item.name)
                    .fontColor(Color.Black)
                    .fontSize(24)
                }
                .width('100%')
                .margin({ top: 5 })

                Row() {
                  Text($r("app.string.contact_age"))
                    .fontColor(Color.Black)
                    .fontSize(24)
                  Text(item.age.toString())
                    .fontColor(Color.Black)
                    .fontSize(24)
                }
                .width('100%')
                .margin({ top: 5 })

                Row() {
                  Text($r("app.string.contact_phone"))
                    .fontColor(Color.Black)
                    .fontSize(24)
                  Text(item.phone)
                    .fontColor(Color.Black)
                    .fontSize(24)
                }
                .width('100%')
                .margin({ top: 5 })
              }
              .width('55%')
              .margin({ left: 10 })
              .justifyContent(FlexAlign.Start)

              Blank()
              Button() {
                Text($r('app.string.button_delete'))
                  .key('delContact')
                  .fontColor(Color.Red)
                  .fontSize(19)
                  .width(100)
                  .textAlign(TextAlign.Center)
              }
              .type(ButtonType.Capsule)
              .backgroundColor($r('app.color.button_bg'))
              .height(40)
              .onClick(() => {
                this.informations.removeByIndex(index)
                this.list['dataArray'] = this.informations
                this.list.notifyDataReload()
              })
            }
            .width('100%')
            .padding(10)
            .align(Alignment.Center)
            .borderRadius(20)
            .backgroundColor(Color.White)
          }
        }, (item, index) => {
          return JSON.stringify(item) + index
        })
      }
      .padding({ left: 10, right: 10, top: 10 })
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 2, color: $r('app.color.divider_bg'), startMargin: 10, endMargin: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.index_bg'))
  }
}