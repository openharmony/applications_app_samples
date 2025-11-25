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

// [Start calendarEvent_indexImport]
import { BusinessError } from '@kit.BasicServicesKit';
import { calendarMgr } from '../entryability/EntryAbility';
import { calendarManager } from '@kit.CalendarKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

let calendar: calendarManager.Calendar | undefined = undefined;
// 指定日历账户信息
const calendarAccount: calendarManager.CalendarAccount = {
  name: 'MyCalendar',
  type: calendarManager.CalendarType.LOCAL,
  // 日历账户显示名称，该字段如果不填，创建的日历账户在界面显示为空字符串。
  displayName: 'MyCalendar'
};
// 日历配置信息
const config: calendarManager.CalendarConfig = {
  // 打开日程提醒
  enableReminder: true,
  // 设置日历账户颜色
  color: '#aabbcc'
};
// [End calendarEvent_indexImport]

// [Start calendarEvent_eventParam]
let eventId : number | undefined = undefined;
const date = new Date();
// [End calendarEvent_eventParam]

@Entry
@Component
struct Index {
  build() {
    Column() {
      Row() {
        Button('1，创建日历账户', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createCalendar();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('2，创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.addEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('3，修改日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.updateEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('4，查询所有日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.getEvents();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('5，查询指定日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.getEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('6，删除指定日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.deleteEvent();
          })
          .width('100%')
      }.padding({ top: 10 })
    }
    .height('100%')
    .width('100%')
  }

  // 根据日历账户信息创建Calendar对象，用于进行日程管理。设置日历配置信息，可以根据需要打开日程提醒、设置日历账户颜色
  createCalendar() {
    // [Start calendarEvent_createCalendar]
    // 创建日历账户
    calendarMgr?.createCalendar(calendarAccount).then((data: calendarManager.Calendar) => {
      hilog.info(DOMAIN, 'testTag', `Succeeded in creating calendar data->${JSON.stringify(data)}`);
      calendar = data;
      // 请确保日历账户创建成功后，再进行相关日程的管理

      // 设置日历配置信息，打开日程提醒、设置日历账户颜色
      calendar.setConfig(config).then(() => {
        hilog.info(DOMAIN, 'testTag', `Succeeded in setting config, data->${JSON.stringify(config)}`);
      }).catch((err: BusinessError) => {
        hilog.error(DOMAIN, 'testTag', `Failed to set config. Code: ${err.code}, message: ${err.message}`);
      });
      // ...
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar. Code: ${error.code}, message: ${error.message}`);
    });
    // [End calendarEvent_createCalendar]
  }

  // 目前支持以下两种方式来创建日程。
  // 方式一：可以在日历账户下通过addEvent()或addEvents()接口创建日程。其中可使用addEvent()接口创建单个日程，也可以使用addEvents()接口批量创建日程，此处以创建单个日程为例。
  // 方式二：在获取到日历管理器对象后，可通过editEvent()接口创建单个日程。调用此接口创建日程时，会跳转到日程创建页面，在日程创建页面进行相关操作完成日程的创建, editEvent()不支持自定义周期性日程创建。
  addEvent() {
    if (!calendar || calendar === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to add event. calendar is null');
      return;
    }
    // [Start calendarEvent_addEvent]
    const event: calendarManager.Event = {
      // 日程标题
      title: 'title',
      // 日程类型，不推荐三方开发者使用calendarManager.EventType.IMPORTANT，重要日程类型不支持一键服务跳转功能及无法自定义提醒时间
      type: calendarManager.EventType.NORMAL,
      // 日程开始时间
      startTime: date.getTime(),
      // 日程结束时间
      endTime: date.getTime() + 60 * 60 * 1000,
      // 距开始时间提前10分钟提醒
      reminderTime: [10],
      // 日程重复规则，可选属性。如果日程为周期性日程需要填写该属性。
      recurrenceRule: {
        // 日程重复规则类型，支持按天、按周、按月、按年重复
        recurrenceFrequency: calendarManager.RecurrenceFrequency.DAILY,
        // 日程重复次数，该字段和expire属性只需要填写一个，如果两个都填写按照count属性计算。
        count: 100,
        // 重复日程间隔时间，与recurrenceFrequency相关，此示例表示日程每隔2天进行重复。
        interval: 2,
        // 日程过期时间，该字段和count属性只需要填写一个，如果两个都填写按照count属性计算。
        expire: date.getTime() + 60 * 60 * 1000 * 3,
        // 日程排除日期，将该日期从重复日程中排除掉
        excludedDates: [date.getTime() + 60 * 60 * 1000 * 2]
      },
      // 日程服务，可选字段，需要一键服务功能的日程，填写该属性。
      service: {
        // 服务类型，比如一键查看、一键入会、一键追剧等。
        type: calendarManager.ServiceType.TRIP,
        // 服务的uri。可以跳转到三方应用相应界面，格式为DeepLink。使用DeepLink方式需要在华为HAG云侧进行注册，注册提供的信息为应用包名、应用的服务类型。
        // DeepLink包括scheme、host、path以及参数（不包含参数值）
        uri: 'xxx://xxx.xxx.com/xxx',
        // 服务辅助描述信息，可选字段
        description: '一键服务'
      }

    };
    // 方式一
    calendar.addEvent(event).then((data: number) => {
      hilog.info(DOMAIN, 'testTag', `Succeeded in adding event, id -> ${data}`);
      eventId = data;
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to addEvent. Code: ${err.code}, message: ${err.message}`);
    });
    // 方式二
    const eventInfo: calendarManager.Event = {
      // 日程标题
      title: 'title',
      // 日程类型
      type: calendarManager.EventType.NORMAL,
      // 日程开始时间
      startTime: date.getTime(),
      // 日程结束时间
      endTime: date.getTime() + 60 * 60 * 1000
    };
    calendarMgr?.editEvent(eventInfo).then((id: number): void => {
      hilog.info(DOMAIN, 'testTag', `create Event id = ${id}`);
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to create Event. Code: ${err.code}, message: ${err.message}`);
    });
    // [End calendarEvent_addEvent]
  }

  // 按照日程id进行当前日历账户指定日程的更新，更新日程相关信息。
  updateEvent() {
    if (!calendar || calendar === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to update event. calendar is null');
      return;
    }
    // [Start calendarEvent_updateEvent]
    const updateEvent: calendarManager.Event = {
      title: 'updateTitle',
      description: 'updateEventTest',
      type: calendarManager.EventType.NORMAL,
      id: eventId,
      startTime: date.getTime(),
      endTime: date.getTime() + 60 * 60 * 1000
    };
    calendar.updateEvent(updateEvent).then(() => {
      hilog.info(DOMAIN, 'testTag', `Succeeded in updating event`);
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to update event. Code: ${err.code}, message: ${err.message}`);
    });
    // [End calendarEvent_updateEvent]
  }

  getEvents() {
    if (!calendar || calendar === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to get events. calendar is null');
      return;
    }
    // [Start calendarEvent_getEvents]
    calendar.getEvents().then((data: calendarManager.Event[]) => {
      hilog.info(DOMAIN, 'testTag', `Succeeded in getting events, data -> ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to get events. Code: ${err.code}, message: ${err.message}`);
    });
    // [End calendarEvent_getEvents]
  }

  // 还支持根据日程id、日程开始和结束时间、日程标题等查询条件来查询日程。
  getEvent() {
    if (!calendar || calendar === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to get event. calendar is null');
      return;
    }
    // [Start calendarEvent_getEvent]
    // 根据日程id查询
    const filterId = calendarManager.EventFilter.filterById([eventId]);
    calendar.getEvents(filterId).then((data: calendarManager.Event[]) => {
      hilog.info(DOMAIN, 'testTag', `Succeeded in getting events filter by eventId, data -> ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to get events. Code: ${err.code}, message: ${err.message}`);
    });

    // 根据日程标题查询
    const filterTitle = calendarManager.EventFilter.filterByTitle('update');
    calendar.getEvents(filterTitle).then((data: calendarManager.Event[]) => {
      hilog.info(DOMAIN, 'testTag', `Succeeded in getting events filter by title, data -> ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to get events. Code: ${err.code}, message: ${err.message}`);
    });

    // 根据日程开始和结束时间查询
    const filterTime = calendarManager.EventFilter.filterByTime(1686931200000, 1687017600000);
    calendar.getEvents(filterTime).then((data: calendarManager.Event[]) => {
      hilog.info(DOMAIN, 'testTag', `Succeeded in getting events filter by time, data -> ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to filter by time. Code: ${err.code}, message: ${err.message}`);
    });
    // [End calendarEvent_getEvent]
  }

  deleteEvent() {
    if (!calendar || calendar === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to delete event. calendar is null');
      return;
    }
    // [Start calendarEvent_deleteEvent]
    calendar.deleteEvent(eventId).then(() => {
      hilog.info(DOMAIN, 'testTag', "Succeeded in deleting event");
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `Failed to delete event. Code: ${err.code}, message: ${err.message}`);
    });
    // [End calendarEvent_deleteEvent]
  }
}