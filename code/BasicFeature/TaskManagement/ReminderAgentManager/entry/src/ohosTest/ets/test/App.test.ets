/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import UIAbility from '@ohos.app.ability.UIAbility';
import data_preferences from '@ohos.data.preferences'
import reminderAgent from '@ohos.reminderAgentManager';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../util/Logger';

interface Reminder {
  audioSrc: string,
  audioTimeouts: number,
  isStart: boolean,
  isVibrator: boolean,
  reminderName: string,
  reminderId: number,
  vibratorTimeouts: number,
  reminderRequestAlarm?: reminderAgent.ReminderRequestAlarm,
  reminderRequestCalendar?: reminderAgent.ReminderRequestCalendar,
}

const BUNDLE = 'reminderAgentManagerTest_';
const TAG = 'ReminderAgentAppTestPage';
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
let uiAbility: UIAbility = undefined;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegatorRegistry.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

// 获取存储数据
async function getPerferenceData(key: string) {
  let preferences = await data_preferences.getPreferences(uiAbility.context, 'ReminderAgentManager');
  let getValue = [];
  if (await preferences.get(key, 'default')) {
    try {
      let result = <string> await preferences.get(key, 'default');
      getValue = JSON.parse(result);
    } catch (err) {
      Logger.error(TAG, `this getData err is ${JSON.stringify(err)}`);
    }
  } else {
    Logger.info(TAG, `this abouttoappear is unexist`);
  }
  return getValue;
}

export default function appTest() {
  describe('appTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility', 0, async function (done) {
      Logger.info(TAG, 'StartAbility start')
      let want = {
        bundleName: "ohos.samples.reminderagentmanager",
        abilityName: "MainAbility"
      };
      abilityDelegatorRegistry.startAbility(want, (err) => {
        Logger.info(TAG, `_startAbility get err ${JSON.stringify(err)}`);
        done();
        Logger.info(TAG, '_startAbility end');
      });

      function onAbilityCreateCallback() {
        Logger.info(TAG, 'onAbilityCreateCallback');
      }

      let monitor: AbilityDelegatorRegistry.AbilityMonitor = {
        abilityName: 'MainAbility',
        onAbilityCreate: onAbilityCreateCallback
      }
      uiAbility = await abilityDelegatorRegistry.waitAbilityMonitor(monitor);
      Logger.info(TAG, 'StartAbility end')
    })
    /**
     * 获取通知使能
     */
    it(`${BUNDLE}RequestEnableNotification`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'RequestEnableNotification begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await getResourceString(($r('app.string.agree')))));
      let agreeNotication: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.agree')))));
      await driver.delayMs(1000);
      await agreeNotication.click();
      await driver.delayMs(1000);
      // 校验是否使能成功
      let timer = {
        reminderType: reminderAgent.ReminderType.REMINDER_TYPE_TIMER,
        triggerTimeInSeconds: 10
      }
      let reminderId = await reminderAgent.publishReminder(timer);
      if (!reminderId) {
        Logger.info(TAG, 'RequestEnableNotification failed');
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + 'RequestEnableNotification end');
    })

    /**
     * 设置日历，用例只支持RK3568
     */
    it(`${BUNDLE}setCalendar`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'createCalendar begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString(($r('app.string.calendar')))));
      let calendarTab: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.calendar')))));
      await driver.delayMs(1000);
      await calendarTab.click();
      await driver.delayMs(1000);
      // 新建一个日历
      await driver.assertComponentExist(ON.id('addCalendar'));
      let addCalendar: Component = await driver.findComponent(ON.id('addCalendar'));
      await driver.delayMs(1000);
      await addCalendar.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString(($r('app.string.determine')))));
      let confirm: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.determine')))));
      await driver.delayMs(1000);
      await confirm.click();
      await driver.delayMs(1000);
      // 开启开关
      await driver.assertComponentExist(ON.id('calendarSwitch0'));
      let calendarSwitch: Component = await driver.findComponent(ON.id('calendarSwitch0'));
      await driver.delayMs(1000);
      await calendarSwitch.click();
      await driver.delayMs(3000);
      // 获取日历数据
      let calenderData: Reminder[] = await getPerferenceData('Calendar');
      let lastReminderName: string = calenderData[calenderData.length-1].reminderName;
      // 删除日历
      await driver.delayMs(1000);
      // 坐标基于rk3568
      await driver.swipe(473, 197, 373, 197, 800);
      await driver.delayMs(1000);
      // 校验删除功能
      let calenderDataDel: Reminder[] = await getPerferenceData('Calendar');
      if (calenderDataDel !== undefined) {
        let isExistName = calenderDataDel.find(element => element.reminderName === lastReminderName) !== undefined;
        if (isExistName) {
          expect().assertFail();
        } else {
          Logger.info(TAG, 'mst success')
        }
      }
      // 再次新建一个日历
      await driver.delayMs(1000);
      await addCalendar.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString(($r('app.string.determine')))));
      let confirmBtn: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.determine')))));
      await confirmBtn.click();
      await driver.delayMs(1000);
      // 打开日历并设置时间
      await driver.assertComponentExist(ON.id('calendar0'));
      let calendarComp: Component = await driver.findComponent(ON.id('calendar0'));
      await driver.delayMs(1000);
      await calendarComp.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('calendarTime0'));
      let calendarTime: Component = await driver.findComponent(ON.id('calendarTime0'));
      await driver.delayMs(1000);
      await calendarTime.click();
      await driver.delayMs(1000);
      let date = new Date;
      // 坐标基于rk3568
      if (date.getMinutes() >= 57) {
        await driver.swipe(188, 934, 188, 850, 600);
        await driver.delayMs(1000);
      }
      await driver.swipe(534, 934, 534, 850, 600);
      await driver.delayMs(1000);
      await driver.swipe(534, 934, 534, 850, 600);
      await driver.delayMs(1000);
      await driver.swipe(534, 934, 534, 850, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString(($r('app.string.determine')))));
      let timeConfirm: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.determine')))));
      await driver.delayMs(1000);
      await timeConfirm.click();
      await driver.delayMs(1000);
      // 打开震动
      await driver.assertComponentExist(ON.id('vibrationSwitch0'));
      let vibrationSwitch: Component = await driver.findComponent(ON.id('vibrationSwitch0'));
      await driver.delayMs(1000);
      await vibrationSwitch.click();
      await driver.delayMs(1000);
      // 选择音乐
      await driver.assertComponentExist(ON.id('music0'));
      let selectMusic: Component = await driver.findComponent(ON.id('music0'));
      await driver.delayMs(1000);
      await selectMusic.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Demo'));
      let music: Component = await driver.findComponent(ON.text('Demo'));
      await driver.delayMs(1000);
      await music.click();

      await driver.delayMs(1000);
      // 完成配置点击确定
      await driver.assertComponentExist(ON.text(await getResourceString(($r('app.string.confirm')))));
      let calendarConfirm: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.confirm')))));
      await driver.delayMs(1000);
      await calendarConfirm.click();
      await driver.delayMs(1000);
      // 开启开关
      await driver.assertComponentExist(ON.id('calendarSwitch0'));
      let currentCalendarSwitch: Component = await driver.findComponent(ON.id('calendarSwitch0'));
      await driver.delayMs(1000);
      await currentCalendarSwitch.click();
      //验证是否在设置的时间之后收到通知
      await driver.delayMs(180000);
      // 坐标基于rk3568
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(1000);
      let calendar: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.calendar')))))
      await driver.delayMs(1000);
      if (!calendar) {
        Logger.info(TAG, 'No calendar notifications');
        // 坐标基于rk3568
        await driver.click(207, 1245);
        await driver.delayMs(1000);
        expect().assertFail();
      } else {
        await driver.delayMs(1000);
        // 坐标基于rk3568
        await driver.click(207, 1245);
        await driver.delayMs(1000);
      }
      Logger.info(TAG, BUNDLE + 'set end');
    });

    /**
     * 设置闹钟，用例只支持RK3568
     */
    it(`${BUNDLE}setClock_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'setClock_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(5000);
      // 点击闹钟
      await driver.assertComponentExist(ON.text(await getResourceString(($r('app.string.alarm_clock')))));
      let clockTab: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.alarm_clock')))));
      await driver.delayMs(1000);
      await clockTab.click();
      await driver.delayMs(1000);
      // 添加时钟并设置时间
      await driver.assertComponentExist(ON.id('addClock'));
      let addClock: Component = await driver.findComponent(ON.id('addClock'));
      await driver.delayMs(1000);
      await addClock.click();
      await driver.delayMs(1000);
      // 坐标基于rk3568
      await driver.swipe(522, 934, 522, 850, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.determine'))));
      let confirm: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.determine')))));
      await driver.delayMs(1000);
      await confirm.click();
      await driver.delayMs(1000);
      // 打开闹钟开关
      await driver.assertComponentExist(ON.id(`clockSwitch0`));
      let clockSwitch: Component = await driver.findComponent(ON.id(`clockSwitch0`));
      await driver.delayMs(1000);
      await clockSwitch.click();
      await driver.delayMs(1000);
      // 获取闹钟数据
      let clockData: Reminder[] = await getPerferenceData('alarmClock');
      let lastReminderName: string = clockData[clockData.length-1].reminderName;
      // 删除闹钟
      await driver.delayMs(1000);
      // 坐标基于rk3568
      await driver.swipe(473, 806, 373, 806, 600);
      await driver.delayMs(4000);
      // 校验删除
      let clockDataDel: Reminder[] = await getPerferenceData('alarmClock');
      if (clockDataDel !== undefined) {
        let isExistName = clockDataDel.find(element => element.reminderName === lastReminderName) !== undefined;
        if (isExistName) {
          Logger.info(TAG, 'Deleting failed');
          expect().assertFail();
        } else {
          Logger.info(TAG, 'Deleting success');
        }
      }
      // 再次新建一个闹钟
      await addClock.click();
      await driver.delayMs(1000);
      let date = new Date;
      if (date.getMinutes() >= 56) {
        await driver.swipe(188, 934, 188, 850, 600);
        await driver.delayMs(1000);
      }
      // 坐标基于rk3568
      await driver.swipe(522, 934, 522, 850, 600);
      await driver.delayMs(1000);
      await driver.swipe(522, 934, 522, 850, 600);
      await driver.delayMs(1000);
      await driver.swipe(522, 934, 522, 850, 600);
      await driver.delayMs(1000);
      await driver.swipe(522, 934, 522, 850, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.determine'))));
      let confirmBtn: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.determine'))));
      await driver.delayMs(1000);
      await confirmBtn.click();
      await driver.delayMs(1000);
      // 点击时钟，默认点击第一个
      await driver.assertComponentExist(ON.id('clock0'));
      let clock: Component = await driver.findComponent(ON.id('clock0'));
      await clock.click();
      await driver.delayMs(1000);
      // 设置提醒天数默认设置为全周
      for (let i = 0;i < 7; i++) {
        await driver.assertComponentExist(ON.id(`day0${i}`));
        let reminderDays: Component = await driver.findComponent(ON.id(`day0${i}`));
        await reminderDays.click();
      }
      // 增加间隔次数
      let intervalAdd: Component[] = await driver.findComponents(ON.text('+'));
      let intervalDel: Component[] = await driver.findComponents(ON.text('-'));
      await driver.assertComponentExist(ON.id('timeCounter'));
      let addIntervalTime: Component = intervalAdd[0];
      for (let i = 0;i < 2; i++) {
        await addIntervalTime.click();
      }
      // 减少间隔次数
      let delIntervalTime: Component = intervalDel[0];
      for (let i = 0;i < 1; i++) {
        await delIntervalTime.click();
      }
      // 增加间隙
      let addIntervalDuration: Component = intervalAdd[1];
      for (let i = 0;i < 2; i++) {
        await addIntervalDuration.click();
      }
      // 减少间隔次数
      let delIntervalDuration: Component = intervalDel[1];
      for (let i = 0;i < 1; i++) {
        await delIntervalDuration.click();
      }
      // 开启震动
      await driver.assertComponentExist(ON.id('vibrationSwitch0'));
      let vibrationSwitch: Component = await driver.findComponent(ON.id('vibrationSwitch0'));
      await driver.delayMs(1000);
      await vibrationSwitch.click();
      // 选择震动音乐
      await driver.assertComponentExist(ON.id('selectMusic0'));
      let selectMusic: Component = await driver.findComponent(ON.id('selectMusic0'));
      await driver.delayMs(1000);
      await selectMusic.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Demo'));
      let music: Component = await driver.findComponent(ON.text('Demo'));
      await driver.delayMs(1000);
      await music.click();
      await driver.delayMs(1000);
      // 完成配置点击确定
      await driver.assertComponentExist(ON.text(await getResourceString(($r('app.string.confirm')))));
      let clockConfirm: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.confirm')))));
      await driver.delayMs(1000);
      await clockConfirm.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id(`clockSwitch0`));
      let currentClockSwitch: Component = await driver.findComponent(ON.id(`clockSwitch0`));
      await driver.delayMs(1000);
      await currentClockSwitch.click();
      //验证是否在设置的时间之后收到通知
      await driver.delayMs(180000);
      // 坐标基于rk3568
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(1000);
      if (!await driver.findComponent(ON.text(await getResourceString($r('app.string.alarm_clock'))))) {
        Logger.info(TAG, 'No alarm notifications');
        // 坐标基于rk3568
        await driver.click(207, 1245);
        await driver.delayMs(1000);
        expect().assertFail();
      } else {
        await driver.delayMs(1000);
        // 坐标基于rk3568
        await driver.click(207, 1245);
        await driver.delayMs(1000);
      }
      Logger.info(TAG, BUNDLE + 'setClock_001 end');
    });

    // 设置计时器，用例只支持RK3568
    it(`${BUNDLE}setCalculagraph`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'calculagraph begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString(($r('app.string.timer')))));
      let calculagraphTab: Component = await driver.findComponent(ON.text(await getResourceString(($r('app.string.timer')))));
      await driver.delayMs(1000);
      await calculagraphTab.click();
      await driver.delayMs(1000);
      // 设置计时器时间
      for (let i = 0; i < 6; i++) {
        // 坐标基于rk3568
        await driver.swipe(505, 793, 505, 740, 600);
        await driver.delayMs(1000);
      }
      // 启动计时器
      await driver.assertComponentExist(ON.id('countDown'));
      let countDown: Component = await driver.findComponent(ON.id('countDown'));
      await driver.assertComponentExist(ON.id('startCalculagraph'));
      let startCalculagraph: Component = await driver.findComponent(ON.id('startCalculagraph'));
      await driver.delayMs(1000);
      await startCalculagraph.click();
      await driver.delayMs(1000);
      let timeTime: string = await countDown.getText();
      //验证是否在设置的时间之后收到通知
      await driver.delayMs(9000);
      // 坐标基于rk3568
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(1000);
      if (!await driver.findComponent(ON.text(await getResourceString(($r('app.string.timer')))))) {
        Logger.info(TAG, 'No calendar notifications');
        // 坐标基于rk3568
        await driver.click(207, 1245);
        await driver.delayMs(1000);
        expect().assertFail();
      } else {
        await driver.delayMs(1000);
        // 坐标基于rk3568
        await driver.click(207, 1245);
        await driver.delayMs(1000);
      }
      // 再次设置计时器时间
      for (let i = 0; i < 6; i++) {
        // 坐标基于rk3568
        await driver.swipe(505, 793, 505, 740, 600);
        await driver.delayMs(1000);
      }
      await driver.delayMs(1000);
      await startCalculagraph.click();
      await driver.delayMs(1000);
      timeTime = await countDown.getText();
      await driver.delayMs(1000);
      // 暂停
      await startCalculagraph.click();
      await driver.delayMs(1000);
      // 重置计时器
      await driver.assertComponentExist(ON.id('resetCalculagraph'));
      let resetCalculagraph: Component = await driver.findComponent(ON.id('resetCalculagraph'));
      await driver.delayMs(1000);
      await resetCalculagraph.click();
      await driver.delayMs(1000);
      timeTime = await countDown.getText();
      await driver.delayMs(1000);
      if (timeTime !== '00:00:00') {
        expect().assertFail();
      }
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'calculagraph end');
    });
  })
}