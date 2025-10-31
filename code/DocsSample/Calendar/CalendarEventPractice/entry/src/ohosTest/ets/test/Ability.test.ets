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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import resourceManager from '@ohos.resourceManager';
import deviceInfo from '@ohos.deviceInfo';

const TAG = '[Sample_CalendarEventPracticeSample]';
const DOMAIN = 0xF811;
const BUNDLE = 'CalendarEventPracticeSample';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;
const driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      abilityDelegator.startAbility({
        bundleName: 'com.sample.calendareventpractice',
        abilityName: 'EntryAbility'
      });
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('CalendarEventPracticeSample_CreateTripCalendarAndEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateTripCalendarAndEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('1，出行服务场景 - 创建日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateTripCalendarAndEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_GetTripEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `GetTripEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('1，出行服务场景 - 查询日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `GetTripEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_UpdateTripEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `UpdateTripEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('1，出行服务场景 - 更新日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `UpdateTripEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_DeleteTripEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `DeleteTripEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('1，出行服务场景 - 删除日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `DeleteTripEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_CreateHotelCalendarAndEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateHotelCalendarAndEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('2，酒店住宿场景 - 创建日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateHotelCalendarAndEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_CreateLiveCalendarAndEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateLiveCalendarAndEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('3，直播预约场景 - 创建日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateLiveCalendarAndEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_CreateShoppingCalendarAndEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateShoppingCalendarAndEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('4，抢购预约场景 - 创建日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateShoppingCalendarAndEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_CreateRepaymentCalendarAndEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateRepaymentCalendarAndEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('5，还款提醒场景 - 创建日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateRepaymentCalendarAndEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_CreateClassCalendarAndEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateClassCalendarAndEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('6，课程提醒场景 - 创建日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateClassCalendarAndEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_CreateSportsCalendarAndEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateSportsCalendarAndEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('7，影音娱乐场景 - 创建日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateSportsCalendarAndEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_CreateSportsExerciseEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateSportsExerciseEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('8，运动训练场景 - 创建日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateSportsExerciseEvent, end`);
      done();
    })
    it('CalendarEventPracticeSample_CreateMeetingEvent', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateMeetingEvent, begin`);
      let btnAccept = await driver.findComponent(ON.text('9，会议场景 - 创建日程'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateMeetingEvent, end`);
      done();
    })
  })
}