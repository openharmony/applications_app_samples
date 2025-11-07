/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start calendarData_indexImport]
import { BusinessError } from '@kit.BasicServicesKit';
import { calendarMgr } from '../entryability/EntryAbility';
import { calendarManager } from '@kit.CalendarKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

let calendar: calendarManager.Calendar | undefined = undefined;
// 指定日历账户信息
const calendarAccount: calendarManager.CalendarAccount = {
  // 日历账户名称
  name: 'MyCalendar',
  // 日历账户类型
  type: calendarManager.CalendarType.LOCAL,
  // 日历账户显示名称，该字段如果不填，创建的日历账户在界面显示为空字符串。
  displayName: 'MyCalendar'
};
// [End calendarData_indexImport]

// [Start calendarData_eventParam]
let eventId : number | undefined = undefined;
const date = new Date();
// [End calendarData_eventParam]

@Entry
@Component
struct Index {
  build() {
    Column() {
      Row() {
        Button('1，创建日历账户对象', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createCalendar();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('2，设置日历配置信息', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.setConfig();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('3，查询指定日历账户', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.getCalendarByParam();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('4，查询默认日历账户', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.getDefaultCalendar();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('5，查询所有日历账户', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.getAllCalendars();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('6，删除指定日历账户', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.deleteCalendar();
          })
          .width('100%')
      }.padding({ top: 10 })
    }
    .height('100%')
    .width('100%')
  }

  // 根据日历账户信息，创建一个日历账户Calendar对象。
  createCalendar() {
    // [Start calendarData_createAccount]
    // 创建日历账户
    calendarMgr?.createCalendar(calendarAccount).then((data: calendarManager.Calendar) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', `Succeeded in creating calendar data->${JSON.stringify(data)}`);
      calendar = data;
      // 请确保日历账户创建成功后，再进行后续相关操作
      // ...
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar. Code: ${error.code}, message: ${error.message}`);
    });
    // [End calendarData_createAccount]
  }

  // 日历账户创建之后，日历账户颜色默认为黑色，不指定日历账户颜色可能导致部分版本/设备深色模式下显示效果不佳。开发者需要调用setConfig()接口设置日历配置信息，包括是否打开日历账户下的日程提醒能力、设置日历账户颜色。
  setConfig() {
    // [Start calendarData_setConfig]
    const calendarAccounts: calendarManager.CalendarAccount = {
      name: 'MyCalendar',
      type: calendarManager.CalendarType.LOCAL,
      displayName: 'MyCalendar'
    };
    // 日历配置信息
    calendarMgr?.getCalendar(calendarAccounts, (err, data) => {
      //获取日历账户
      if (err) {
        hilog.error(DOMAIN, 'testTag', `Failed to get calendar, Code is ${err.code}, message is ${err.message}`);
      } else {
        const config: calendarManager.CalendarConfig = {
          // 打开日程提醒
          enableReminder: true,
          // 设置日历账户颜色
          color: '#aabbcc'
        };
        // 设置日历配置信息
        data.setConfig(config).then(() => {
          hilog.info(DOMAIN, 'testTag', '%{public}s', `Succeeded in setting config, data->${JSON.stringify(config)}`);
        }).catch((err: BusinessError) => {
          hilog.error(DOMAIN, 'testTag', `Failed to set config. Code: ${err.code}, message: ${err.message}`);
        })
      }
    });
    // [End calendarData_setConfig]
  }

  // 查询指定日历账户
  getCalendarByParam() {
    // [Start calendarData_getAccountByParam]
    calendarMgr?.getCalendar(calendarAccount).then((data: calendarManager.Calendar) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', `Succeeded in getting calendar, data -> ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to get calendar. Code: ${err.code}, message: ${err.message}`);
    });
    // [End calendarData_getAccountByParam]
  }

  // 查询默认日历账户
  getDefaultCalendar() {
    // [Start calendarData_getDefaultAccount]
    calendarMgr?.getCalendar().then((data: calendarManager.Calendar) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', `Succeeded in getting calendar, data -> ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to get calendar. Code: ${err.code}, message: ${err.message}`);
    });
    // [End calendarData_getDefaultAccount]
  }

  // 获取当前应用所有创建的日历账户及默认日历账户Calendar对象
  getAllCalendars() {
    // [Start calendarData_getAllCalendars]
    calendarMgr?.getAllCalendars().then((data: calendarManager.Calendar[]) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', `Succeeded in getting all calendars, data -> ${JSON.stringify(data)}`);
      data.forEach((calendar) => {
        const account = calendar.getAccount();
        hilog.info(DOMAIN, 'testTag', '%{public}s', `account -> ${JSON.stringify(account)}`);
      })
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to get all calendars. Code: ${err.code}, message: ${err.message}`);
    });
    // [End calendarData_getAllCalendars]
  }

  // 删除指定的日历账户，删除账户后，该账户下的所有日程会全部删除
  deleteCalendar() {
    // [Start calendarData_deleteCalendar]
    if (!calendar || calendar === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to delete calendar. calendar is null');
      return;
    }
    calendarMgr?.deleteCalendar(calendar).then(() => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', "Succeeded in deleting calendar");
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to delete calendar. Code: ${err.code}, message: ${err.message}`);
    });
    // [End calendarData_deleteCalendar]
  }
}