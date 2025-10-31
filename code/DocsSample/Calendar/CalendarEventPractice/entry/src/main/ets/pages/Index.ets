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

// [Start calendarEventPractice_indexImport]
import { calendarMgr } from '../entryability/EntryAbility';
import { calendarManager } from '@kit.CalendarKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

let tripCalendar: calendarManager.Calendar | undefined = undefined;
let oriEvent: calendarManager.Event | null = null;
let id: number = 0;
// [End calendarEventPractice_indexImport]

@Entry
@Component
struct Index {
  build() {
    Column() {
      Row() {
        Button('1，出行服务场景 - 创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createTripCalendarAndEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('1，出行服务场景 - 查询日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.getTripEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('1，出行服务场景 - 更新日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.updateTripEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('1，出行服务场景 - 删除日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.deleteTripEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('2，酒店住宿场景 - 创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createHotelCalendarAndEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('3，直播预约场景 - 创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createLiveCalendarAndEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('4，抢购预约场景 - 创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createShoppingCalendarAndEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('5，还款提醒场景 - 创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createRepaymentCalendarAndEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('6，课程提醒场景 - 创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createClassCalendarAndEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('7，影音娱乐场景 - 创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createSportsCalendarAndEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('8，运动训练场景 - 创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createSportsExerciseEvent();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('9，会议场景 - 创建日程', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.createMeetingEvent();
          })
          .width('100%')
      }.padding({ top: 10 })
    }
    .height('100%')
    .width('100%')
  }

  // [Start calendarEventPractice_createTripCalendarAndEvent]
  async createTripCalendarAndEvent(): Promise<void> {
    // 指定日历账户信息
    const calendarAccount: calendarManager.CalendarAccount = {
      name: 'TripCalendar',
      type: calendarManager.CalendarType.LOCAL,
      // 日历账户显示名称：建议使用应用实际名称。
      displayName: '高铁出行'
    };
    // 日历配置信息
    const config: calendarManager.CalendarConfig = {
      // 设置日历账户颜色
      color: '#aabbcc'
    };
    const startTime = new Date('2025-10-01T08:17:00').getTime();
    const endTime = new Date('2025-10-01T12:51:00').getTime();
    // 日程配置信息
    const event: calendarManager.Event = {
      type: calendarManager.EventType.NORMAL,
      // 日程标题
      title: '行程信息：G107 上海虹桥-北京南',
      // 开始时间
      startTime: startTime,
      // 结束时间
      endTime: endTime,
      // 是否全天日程
      isAllDay:false,
      // 提醒时间
      reminderTime:[120, 240],
      // 备注
      description: '检票口：南二楼1口或北广场B2候车室 \n座位号：02车04二等座',
      // 一键服务
      service: {
        // 服务类型
        type: calendarManager.ServiceType.TRIP,
        // 服务的uri，格式为DeepLink类型。请根据“一键服务”指导文档配置。
        uri: 'demo://mobile/player?params='
      }
    }
    try {
      // 创建日历账户
      tripCalendar = await calendarMgr?.createCalendar(calendarAccount);
      if (!tripCalendar || tripCalendar === null) {
        hilog.error(DOMAIN, 'testTag', 'Failed to create calendar. tripCalendar is null.');
        return;
      }
      // 请确保日历账户创建成功后，再进行相关日程的管理
      // 设置日历配置信息，设置日历账户颜色
      await tripCalendar.setConfig(config);
      // 添加日程
      id = await tripCalendar.addEvent(event);
      oriEvent = event;
      oriEvent.id = id;
      hilog.info(DOMAIN, 'testTag',`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [End calendarEventPractice_createTripCalendarAndEvent]

  // [Start calendarEventPractice_getTripEvent]
  async getTripEvent(): Promise<void> {
    // 校验calendar是否为空
    if (!tripCalendar || tripCalendar === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to get event, calendar is null.');
      return;
    }
    try {
      // 查询行程
      const filter = calendarManager.EventFilter.filterById([id]);
      let data: calendarManager.Event[] = await tripCalendar.getEvents(filter, ['title', 'type', 'startTime', 'endTime']);
      if (data && data.length > 0) {
        oriEvent = data[0];
      }
      hilog.info(DOMAIN, 'testTag',`Succeeded in getting events, data -> ${JSON.stringify(data)}`);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `Failed to get events. Code: ${err.code}, message: ${err.message}`);
    }
  }
  // [End calendarEventPractice_getTripEvent]

  // [Start calendarEventPractice_updateTripEvent]
  async updateTripEvent(): Promise<void> {
    // 校验calendar是否为空
    if (!tripCalendar || tripCalendar === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to update event, calendar is null.');
      return;
    }
    if (!oriEvent || oriEvent === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to update event, oriEvent is null');
      return;
    }
    // 修改行程的开始时间startTime和结束时间endTime
    oriEvent.startTime = new Date('2025-10-01T07:03:00').getTime();
    oriEvent.endTime = new Date('2025-10-01T11:51:00').getTime();
    try {
      // 更新行程
      await tripCalendar.updateEvent(oriEvent);
      hilog.info(DOMAIN, 'testTag',"Succeeded in updating event");
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `Failed to update event. Code: ${err.code}, message: ${err.message}`);
    }
  }
  // [End calendarEventPractice_updateTripEvent]

  // [Start calendarEventPractice_deleteTripEvent]
  async deleteTripEvent(): Promise<void> {
    // 校验calendar是否为空
    if (!tripCalendar || tripCalendar === null) {
      hilog.error(DOMAIN, 'testTag', 'Failed to delete event, calendar is null.');
      return;
    }
    try {
      // 删除行程
      await tripCalendar.deleteEvent(id);
      oriEvent = null;
      hilog.info(DOMAIN, 'testTag',`Succeeded in deleting Event`);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `Failed to delete Event, Code is ${err.code}, message is ${err.message}`);
    }
  }
  // [End calendarEventPractice_deleteTripEvent]

  // [Start calendarEventPractice_createHotelCalendarAndEvent]
  async createHotelCalendarAndEvent(): Promise<void> {
    // 指定日历账户信息
    const calendarAccount: calendarManager.CalendarAccount = {
      name: 'hotelCalendar',
      type: calendarManager.CalendarType.LOCAL,
      // 日历账户显示名称：建议使用应用实际名称。
      displayName: '酒店住宿'
    };
    // 日历配置信息
    const config: calendarManager.CalendarConfig = {
      // 设置日历账户颜色
      color: '#aabbcc'
    };
    const startTime = new Date('2025-05-01T15:00:00').getTime();
    const endTime = new Date('2025-05-02T12:00:00').getTime();
    // 日程配置信息
    const event: calendarManager.Event = {
      type: calendarManager.EventType.NORMAL,
      title: '入住信息:酒店(上海新天地店)',
      location: {
        location: '上海新天地',
        longitude: 121.47506199999998,
        latitude: 31.219150000000013
      },
      startTime: startTime,
      endTime: endTime,
      isAllDay: true,
      // 提醒时间：全天日程是按9点往前计算分钟数
      reminderTime: [0, 1440],
      description: '入住:15:00后\n离店:12:00前',
      // 一键服务
      service: {
        type: calendarManager.ServiceType.TRIP,
        uri: 'demo://mobile/player?params='
      }
    }
    try {
      // 创建日历账户
      let data: calendarManager.Calendar | undefined= await calendarMgr?.createCalendar(calendarAccount);
      if (!data || data === null) {
        hilog.error(DOMAIN, 'testTag', 'Failed to create calendar. data is null.');
        return;
      }
      // 请确保日历账户创建成功后，再进行相关日程的管理
      // 设置日历配置信息，设置日历账户颜色
      await data.setConfig(config);
      // 添加日程
      id = await data.addEvent(event);
      hilog.info(DOMAIN, 'testTag',`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [End calendarEventPractice_createHotelCalendarAndEvent]

  // [Start calendarEventPractice_createLiveCalendarAndEvent]
  async createLiveCalendarAndEvent(): Promise<void> {
    // 指定日历账户信息
    const calendarAccount: calendarManager.CalendarAccount = {
      name: 'liveCalendar',
      type: calendarManager.CalendarType.LOCAL,
      // 日历账户显示名称：建议使用应用实际名称。
      displayName: '直播抢购'
    };
    // 日历配置信息
    const config: calendarManager.CalendarConfig = {
      // 设置日历账户颜色
      color: '#aabbcc'
    };
    const startTime = new Date('2025-11-04T21:00:00').getTime();
    const endTime = new Date('2025-11-04T22:00:00').getTime();
    // 日程配置信息
    const event: calendarManager.Event = {
      type: calendarManager.EventType.NORMAL,
      title: '直播抢购',
      startTime: startTime,
      endTime: endTime,
      isAllDay: false,
      reminderTime: [0, 10],
      description: '限时特惠,秋季最大福利就在直播间',
      // 一键服务
      service: {
        type: calendarManager.ServiceType.LIVE,
        uri: 'demo://mobile/player?params='
      }
    }
    try {
      // 创建日历账户
      let data: calendarManager.Calendar | undefined= await calendarMgr?.createCalendar(calendarAccount);
      if (!data || data === null) {
        hilog.error(DOMAIN, 'testTag', 'Failed to create calendar. data is null.');
        return;
      }
      // 请确保日历账户创建成功后，再进行相关日程的管理
      // 设置日历配置信息，设置日历账户颜色
      await data.setConfig(config);
      // 添加日程
      id = await data.addEvent(event);
      hilog.info(DOMAIN, 'testTag',`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [End calendarEventPractice_createLiveCalendarAndEvent]

  // [Start calendarEventPractice_createShoppingCalendarAndEvent]
  async createShoppingCalendarAndEvent(): Promise<void> {
    // 指定日历账户信息
    const calendarAccount: calendarManager.CalendarAccount = {
      name: 'shoppingCalendar',
      type: calendarManager.CalendarType.LOCAL,
      // 日历账户显示名称：建议使用应用实际名称。
      displayName: '购物'
    };
    // 日历配置信息
    const config: calendarManager.CalendarConfig = {
      // 设置日历账户颜色
      color: '#aabbcc'
    };
    const startTime = new Date('2025-12-19T19:00:00').getTime();
    const endTime = new Date('2025-12-19T20:00:00').getTime();
    // 日程配置信息
    const event: calendarManager.Event = {
      type: calendarManager.EventType.NORMAL,
      title: '购物节预热',
      startTime: startTime,
      endTime: endTime,
      isAllDay: false,
      reminderTime: [0, 10],
      description: '9.9限时秒杀,还有精彩福利',
      // 一键服务
      service: {
        type: calendarManager.ServiceType.SHOPPING,
        uri: 'demo://mobile/player?params='
      }
    }
    try {
      // 创建日历账户
      let data: calendarManager.Calendar | undefined= await calendarMgr?.createCalendar(calendarAccount);
      if (!data || data === null) {
        hilog.error(DOMAIN, 'testTag', 'Failed to create calendar. data is null.');
        return;
      }
      // 请确保日历账户创建成功后，再进行相关日程的管理
      // 设置日历配置信息，设置日历账户颜色
      await data.setConfig(config);
      // 添加日程
      id = await data.addEvent(event);
      hilog.info(DOMAIN, 'testTag',`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [End calendarEventPractice_createShoppingCalendarAndEvent]

  // [Start calendarEventPractice_createRepaymentCalendarAndEvent]
  async createRepaymentCalendarAndEvent(): Promise<void> {
    // 指定日历账户信息
    const calendarAccount: calendarManager.CalendarAccount = {
      name: 'repaymentCalendar',
      type: calendarManager.CalendarType.LOCAL,
      // 日历账户显示名称：建议使用应用实际名称。
      displayName: '金融理财'
    };
    // 日历配置信息
    const config: calendarManager.CalendarConfig = {
      // 设置日历账户颜色
      color: '#aabbcc'
    };
    const startTime = new Date('2025-10-20T00:00:00').getTime();
    const endTime = new Date('2025-10-20T23:59:59').getTime();
    // 日程配置信息
    const event: calendarManager.Event = {
      type: calendarManager.EventType.NORMAL,
      title: '还款提醒',
      startTime: startTime,
      endTime: endTime,
      isAllDay: true,
      // 全天日程时，提醒时间为0表示当天上午9点提醒
      reminderTime: [0],
      description: '本月账单：待还款10989.35元',
      // 一键服务
      service: {
        type: calendarManager.ServiceType.REPAYMENT,
        uri: 'demo://mobile/player?params='
      }
    }
    try {
      // 创建日历账户
      let data: calendarManager.Calendar | undefined= await calendarMgr?.createCalendar(calendarAccount);
      if (!data || data === null) {
        hilog.error(DOMAIN, 'testTag', 'Failed to create calendar. data is null.');
        return;
      }
      // 请确保日历账户创建成功后，再进行相关日程的管理
      // 设置日历配置信息，设置日历账户颜色
      await data.setConfig(config);
      // 添加日程
      id = await data.addEvent(event);
      hilog.info(DOMAIN, 'testTag',`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [End calendarEventPractice_createRepaymentCalendarAndEvent]

  // [Start calendarEventPractice_createClassCalendarAndEvent]
  async createClassCalendarAndEvent(): Promise<void> {
    // 指定日历账户信息
    const calendarAccount: calendarManager.CalendarAccount = {
      name: 'classCalendar',
      type: calendarManager.CalendarType.LOCAL,
      // 日历账户显示名称：建议使用应用实际名称。
      displayName: '我的课表'
    };
    // 日历配置信息
    const config: calendarManager.CalendarConfig = {
      // 设置日历账户颜色
      color: '#aabbcc'
    };
    const startTime = new Date('2025-11-03T09:00:00').getTime();
    const endTime = new Date('2025-11-03T09:45:00').getTime();
    // 日程配置信息
    const event: calendarManager.Event = {
      type: calendarManager.EventType.NORMAL,
      title: '语文课',
      startTime: startTime,
      endTime: endTime,
      isAllDay: false,
      reminderTime: [0, 10],
      description: '语文课上课前准备诗歌朗读',
      // 一键服务
      service: {
        type: calendarManager.ServiceType.CLASS,
        uri: 'demo://mobile/player?params='
      }
    }
    try {
      // 创建日历账户
      let data: calendarManager.Calendar | undefined= await calendarMgr?.createCalendar(calendarAccount);
      if (!data || data === null) {
        hilog.error(DOMAIN, 'testTag', 'Failed to create calendar. data is null.');
        return;
      }
      // 请确保日历账户创建成功后，再进行相关日程的管理
      // 设置日历配置信息，设置日历账户颜色
      await data.setConfig(config);
      // 添加日程
      id = await data.addEvent(event);
      hilog.info(DOMAIN, 'testTag',`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [End calendarEventPractice_createClassCalendarAndEvent]

  // [Start calendarEventPractice_createSportsCalendarAndEvent]
  async createSportsCalendarAndEvent(): Promise<void> {
    // 指定日历账户信息
    const calendarAccount: calendarManager.CalendarAccount = {
      name: 'sportsEventsCalendar',
      type: calendarManager.CalendarType.LOCAL,
      // 日历账户显示名称：建议使用应用实际名称。
      displayName: '足球比赛'
    };
    // 日历配置信息
    const config: calendarManager.CalendarConfig = {
      // 设置日历账户颜色
      color: '#aabbcc'
    };
    const startTime = new Date('2025-10-19T20:00:00').getTime();
    const endTime = new Date('2025-10-19T21:30:00').getTime();
    // 日程配置信息
    const event: calendarManager.Event = {
      type: calendarManager.EventType.NORMAL,
      title: '2026年足球联赛',
      startTime: startTime,
      endTime: endTime,
      isAllDay: false,
      reminderTime: [0, 10],
      description: 'A组 xx队首战',
      // 一键服务
      service: {
        type: calendarManager.ServiceType.SPORTS_EVENTS,
        uri: 'demo://mobile/player?params='
      }
    }
    try {
      // 创建日历账户
      let data: calendarManager.Calendar | undefined= await calendarMgr?.createCalendar(calendarAccount);
      if (!data || data === null) {
        hilog.error(DOMAIN, 'testTag', 'Failed to create calendar. data is null.');
        return;
      }
      // 请确保日历账户创建成功后，再进行相关日程的管理
      // 设置日历配置信息，设置日历账户颜色
      await data.setConfig(config);
      // 添加日程
      id = await data.addEvent(event);
      hilog.info(DOMAIN, 'testTag',`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [End calendarEventPractice_createSportsCalendarAndEvent]

  // [Start calendarEventPractice_createSportsExerciseEvent]
  async createSportsExerciseEvent(): Promise<void> {
    // 指定日历账户信息
    const calendarAccount: calendarManager.CalendarAccount = {
      name: 'sportsExerciseCalendar',
      type: calendarManager.CalendarType.LOCAL,
      // 日历账户显示名称：建议使用应用实际名称。
      displayName: '运动健康'
    };
    // 日历配置信息
    const config: calendarManager.CalendarConfig = {
      // 设置日历账户颜色
      color: '#aabbcc'
    };
    const startTime = new Date('2025-10-26T10:30:00').getTime();
    const endTime = new Date('2025-10-26T10:45:00').getTime();
    // 日程配置信息
    const event: calendarManager.Event = {
      type: calendarManager.EventType.NORMAL,
      title: '健身操·15分钟无跑跳燃脂',
      startTime: startTime,
      endTime: endTime,
      isAllDay: false,
      reminderTime: [0, 30],
      description: '训练日第17天',
      // 一键服务
      service: {
        type: calendarManager.ServiceType.SPORTS_EXERCISE,
        uri: 'demo://mobile/player?params='
      }
    }
    try {
      // 创建日历账户
      let data: calendarManager.Calendar | undefined= await calendarMgr?.createCalendar(calendarAccount);
      if (!data || data === null) {
        hilog.error(DOMAIN, 'testTag', 'Failed to create calendar. data is null.');
        return;
      }
      // 请确保日历账户创建成功后，再进行相关日程的管理
      // 设置日历配置信息，设置日历账户颜色
      await data.setConfig(config);
      // 添加日程
      id = await data.addEvent(event);
      hilog.info(DOMAIN, 'testTag',`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [End calendarEventPractice_createSportsExerciseEvent]

  // [Start calendarEventPractice_createMeetingEvent]
  async createMeetingEvent(): Promise<void> {
    // 指定日历账户信息
    const calendarAccount: calendarManager.CalendarAccount = {
      name: 'meetingCalendar',
      type: calendarManager.CalendarType.LOCAL,
      // 日历账户显示名称：建议使用应用实际名称。
      displayName: '会议'
    };
    // 日历配置信息
    const config: calendarManager.CalendarConfig = {
      // 设置日历账户颜色
      color: '#aabbcc'
    };
    // 与会人信息
    let attendee: calendarManager.Attendee[] = [
      {
        name: 'Chris',
        email: 'test1@xx.com',
        role: calendarManager.AttendeeRole.ORGANIZER
      },
      {
        name: 'Jack',
        email: 'test2@xx.com',
        role: calendarManager.AttendeeRole.PARTICIPANT,
        type: calendarManager.AttendeeType.REQUIRED
      },
      {
        name: 'Jerry',
        email: 'test3@xx.com',
        role: calendarManager.AttendeeRole.PARTICIPANT,
        type: calendarManager.AttendeeType.REQUIRED
      }
    ];
    const startTime = new Date('2025-10-20T09:00:00').getTime();
    const endTime = new Date('2025-10-20T10:00:00').getTime();
    // 日程配置信息
    const event: calendarManager.Event = {
      type: calendarManager.EventType.NORMAL,
      title: 'xxx会议',
      startTime: startTime,
      endTime: endTime,
      isAllDay: false,
      reminderTime: [0, 15],
      attendee: attendee,
      description: 'xx事务评审',
      // 一键服务
      service: {
        type: calendarManager.ServiceType.MEETING,
        uri: 'demo://mobile/player?params='
      }
    }
    try {
      // 创建日历账户
      let data: calendarManager.Calendar | undefined= await calendarMgr?.createCalendar(calendarAccount);
      if (!data || data === null) {
        hilog.error(DOMAIN, 'testTag', 'Failed to create calendar. data is null.');
        return;
      }
      // 请确保日历账户创建成功后，再进行相关日程的管理
      // 设置日历配置信息，设置日历账户颜色
      await data.setConfig(config);
      // 添加日程
      id = await data.addEvent(event);
      hilog.info(DOMAIN, 'testTag',`Succeeded in creating calendar and event, result: ${JSON.stringify(id)}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `Failed to create calendar or event. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [End calendarEventPractice_createMeetingEvent]
}