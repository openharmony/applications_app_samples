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

import StorageModel from '../model/StorageModel'
import { CustomDatePicker } from '../common/CustomDataPicker'
import { MyDataSource } from '../common/DataSource'
import reminderAgentManager from '@ohos.reminderAgentManager'
import log from '../model/Logger'

const TAG: string = 'AlarmClock'

@Component
export struct AlarmClock {
  @State total: number = 0
  @State listItems: MyDataSource = new MyDataSource([])
  private datePicker: CustomDialogController = null
  private storage: StorageModel = StorageModel.getInstance()

  async getTest(): Promise<void> {
    this.listItems.replaceData([])
    let amount = await this.storage.getStorageValue('amount')
    if (amount !== 'null') {
      this.total = parseInt(amount)
    }
    for (let i = 0; i <= this.total; i++) {
      let alarmClock = await this.storage.getStorageValue(`alarmClock${i}`)
      if (alarmClock !== 'null') {
        let dataTime = JSON.parse(alarmClock).hour + ':' + JSON.parse(alarmClock).minute
        this.listItems.pushData({
          key: `alarmClock${i}`,
          value: dataTime,
          reminderId: JSON.parse(alarmClock).reminderId
        })
      }
    }
  }

  aboutToAppear() {
    this.storage.getFromStorage().then(() => {
      this.getTest()
    })
  }

  countChange(result): void {
    this.total = result
    this.getTest()
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.alarmClock'))
          .fontSize(30)
        Text('+')
          .key('add')
          .width('60%')
          .height('100%')
          .fontSize(50)
          .margin({ right: 20 })
          .textAlign(TextAlign.End)
          .onClick(() => {
            if (this.datePicker === null) {
              this.datePicker = new CustomDialogController({
                builder: CustomDatePicker({ total: this.total, countChange: this.countChange.bind(this) }),
                autoCancel: true
              })
            }
            this.datePicker.open()
          })
      }
      .height(62)
      .margin({ top: 40, bottom: 40 })
      .padding({ left: '3%', right: '3%' })

      Scroll() {
        List() {
          LazyForEach(this.listItems, (item, index) => {
            ListItem() {
              Row() {
                Text(item.value)
                  .width('50%')
                  .fontSize(30)
                Button($r('app.string.delete'))
                  .margin({ left: '20%' })
                  .onClick(async () => {
                    await this.storage.deleteSync(item.key)
                    this.listItems['dataArray'].splice(index, 1)
                    this.listItems.notifyDataReload()
                    try {
                      reminderAgentManager.cancelReminder(item.reminderId, (err, data) => {
                        if (err) {
                          log.info(TAG, `callback err code: ${err.code} message: ${err.message}`)
                        } else {
                          log.info(TAG, `cancelReminder callback`)
                        }
                      })
                    } catch (error) {
                      log.info(TAG, `cancelReminder code: ${error.code} message: ${error.message}`)
                    }
                  })
                  .width('20%')
                  .height('100%')
                  .backgroundColor($r('app.color.button_bg'))
              }
              .padding(10)
              .width('100%')
            }
            .height(62)
            .borderRadius(24)
            .margin({ bottom: 5 })
            .backgroundColor($r('app.color.divider_bg'))
          }, (item, index) => {
            return JSON.stringify(item) + index
          })
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
