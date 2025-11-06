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

const TAG = '[Sample_CalendarManagerSample]';
const DOMAIN = 0xF811;
const BUNDLE = 'CalendarManagerSample';
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
        bundleName: 'com.sample.calendarmanager',
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
    it('CalendarManagerSample_CreateCalendar', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateCalendar, begin`);
      let btnAccept = await driver.findComponent(ON.text('1，创建日历账户对象'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `CreateCalendar, end`);
      done();
    })
    it('CalendarManagerSample_SetConfig', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `SetConfig, begin`);
      let btnAccept = await driver.findComponent(ON.text('2，设置日历配置信息'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `SetConfig, end`);
      done();
    })
    it('CalendarManagerSample_GetCalendarByParam', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `GetCalendarByParam, begin`);
      let btnAccept = await driver.findComponent(ON.text('3，查询指定日历账户'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `GetCalendarByParam, end`);
      done();
    })
    it('CalendarManagerSample_GetDefaultCalendar', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `GetDefaultCalendar, begin`);
      let btnAccept = await driver.findComponent(ON.text('4，查询默认日历账户'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `GetDefaultCalendar, end`);
      done();
    })
    it('CalendarManagerSample_GetAllCalendars', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `GetAllCalendars, begin`);
      let btnAccept = await driver.findComponent(ON.text('5，查询所有日历账户'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `GetAllCalendars, end`);
      done();
    })
    it('CalendarManagerSample_DeleteCalendar', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `DeleteCalendar, begin`);
      let btnAccept = await driver.findComponent(ON.text('6，删除指定日历账户'))
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(2000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + `DeleteCalendar, end`);
      done();
    })
  })
}