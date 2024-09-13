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

import StorageModel from '../model/StorageModel';
import { CustomDatePicker } from '../common/CustomDataPicker';
import { MyDataSource, ContactSource, Contact } from '../common/DataSource';
import reminderAgentManager from '@ohos.reminderAgentManager';
import Logger from '../model/Logger';
import { calendarManager } from '@kit.CalendarKit';
import { calendarMgr } from '../entryability/EntryAbility';
import { BusinessError } from '@kit.BasicServicesKit';
import deviceInfo from '@ohos.deviceInfo';

const TAG: string = 'AlarmClock';

@Component
export struct AlarmClock {
  @State total: number = 0;
  @State listItems: ContactSource = new ContactSource([]);
  private datePicker: CustomDialogController | null = null;
  private storage: StorageModel = StorageModel.getInstance();
  private calendar : calendarManager.Calendar | undefined = undefined;
  @State isDefault: boolean= false;

  async getTest(): Promise<void> {
    this.listItems.replaceData([]);
    let amount = await this.storage.getStorageValue('amount');
    if (amount !== 'null') {
      this.total = parseInt(amount.toString());
    }
    for (let i = 0; i <= this.total; i++) {
      let alarmClock = await this.storage.getStorageValue(`alarmClock${i}`);
      Logger.info(`alarmClock` + JSON.stringify(alarmClock));
      if (alarmClock !== 'null') {
        let dataTime = JSON.parse(alarmClock.toString()).hour + ':' + JSON.parse(alarmClock.toString()).minute;
        Logger.info(`dataTime` + JSON.stringify(dataTime));
        this.listItems.pushData(new Contact(`alarmClock${i}`, dataTime, JSON.parse(alarmClock.toString()).reminderId));
        Logger.info(`this.listItems` + JSON.stringify(this.listItems));
      }
    }
  }

  // 获取设备类型
  async getDeviceType() {
    try {
      let deviceType = deviceInfo.deviceType;
      Logger.info(`deviceType` + JSON.stringify(deviceType));
      if (deviceType === 'default') {
        this.isDefault = true;
      } else {
        this.isDefault = false;
      }
    } catch (e) {
      Logger.info(`getSync unexpected error: ${e}`);
    }
  }

  aboutToAppear() {
    this.getDeviceType();
    this.storage.getFromStorage().then(() => {
      this.getTest();
    })
  }

  countChange(result: number): void {
    this.total = result;
    this.getTest();
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.alarmClock'))
          .fontSize(30)
        Text('+')
          .id('add')
          .width('60%')
          .height('100%')
          .fontSize(50)
          .margin({ right: 20 })
          .textAlign(TextAlign.End)
          .onClick(() => {
            if (this.datePicker === null) {
              this.datePicker = new CustomDialogController({
                builder: CustomDatePicker({ total: this.total, countChange: this.countChange.bind(this), isDefault: this.isDefault }),
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
          LazyForEach(this.listItems, (item: Contact, index) => {
            ListItem() {
              Row() {
                Text(item.value)
                  .width('50%')
                  .fontSize(30)
                Button($r('app.string.delete'))
                  .id('deleteAlarmClock')
                  .margin({ left: '20%' })
                  .onClick(async () => {
                    await this.storage.deleteSync(item.key);
                    this.listItems.dataArray.splice(index, 1);
                    this.listItems.notifyDataReload();
                    Logger.info(`item.reminderId` + JSON.stringify(item.reminderId));
                    try {
                      if (this.isDefault === true) {
                        reminderAgentManager.cancelReminder(item.reminderId, (err, data) => {
                          if (err) {
                            Logger.info(TAG, `callback err code: ${err.code} message: ${err.message}`);
                          } else {
                            Logger.info(TAG, `cancelReminder callback`);
                          }
                        });
                      } else {
                        calendarMgr?.getCalendar(async (err: BusinessError, data:calendarManager.Calendar) => {
                          if (err) {
                            Logger.error(`Failed to get calendar. Code: {err.code}, message: {err.code}, message: {err.message}`);
                          } else {
                            Logger.info(`Succeeded in getting calendar, data -> {JSON.stringify(data)}`);
                            this.calendar = data;
                            await this.calendar.deleteEvent(item.reminderId).then(() => {
                              Logger.info(`Succeeded in deleting event`);
                            })
                          }
                        });
                      }
                    } catch (error) {
                      Logger.info(TAG, `cancelReminder code: ${error.code} message: ${error.message}`);
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
          }, (item: Contact, index) => {
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
