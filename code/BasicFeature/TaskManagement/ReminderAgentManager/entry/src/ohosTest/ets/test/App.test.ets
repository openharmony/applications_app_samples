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
import reminderAgent from '@ohos.reminderAgent'
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
const TIME_OUT = 1000;
let ability: UIAbility = undefined;


// 获取存储数据
async function getPerferenceData(key: string) {
  let preferences = await data_preferences.getPreferences(ability.context, 'ReminderAgentManager');
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
  describe('abilityTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility', 0, async function (done) {
      Logger.info(TAG, 'StartAbility start')
      let want = {
        bundleName: "ohos.samples.reminderagentmanager",
        abilityName: "MainAbility"
      };
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
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
      ability = await abilityDelegator.waitAbilityMonitor(monitor, TIME_OUT);
      Logger.info(TAG, 'StartAbility end')
    })
    /**
     * 获取通知使能
     */
    it(`${BUNDLE}RequestEnableNotification`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'RequestEnableNotification begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('允许'));
      let agreeNotication: Component = await driver.findComponent(ON.text('允许'));
      await agreeNotication.click();
      await driver.delayMs(1000);
      // 校验是否使能成功
      let timer = {
        reminderType: reminderAgent.ReminderType.REMINDER_TYPE_TIMER,
        triggerTimeInSeconds: 10
      }
      let reminderId = await reminderAgent.publishReminder(timer);
      if (!reminderId) {
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + 'RequestEnableNotification end');
    })
    /**
     * 设置闹钟
     */
    it(`${BUNDLE}setClock`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'createClock begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 添加时钟并设置时间
      await driver.assertComponentExist(ON.id('addClock'));
      let addClock: Component = await driver.findComponent(ON.id('addClock'));
      await addClock.click();
      await driver.delayMs(500);
      await driver.swipe(445, 940, 445, 900, 600);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('确定'));
      let confirm: Component = await driver.findComponent(ON.text('确定'));
      await confirm.click();
      await driver.delayMs(500);
      // 打开闹钟开关
      await driver.assertComponentExist(ON.id(`clockSwitch0`));
      let clockSwitch: Component = await driver.findComponent(ON.id(`clockSwitch0`));
      await clockSwitch.click();
      await driver.delayMs(500);
      // 获取闹钟数据
      let clockData: Reminder[] = await getPerferenceData('alarmClock');
      let lastReminderName: string = clockData[clockData.length-1].reminderName;
      // 删除闹钟
      await driver.delayMs(500);
      await driver.swipe(423, 798, 373, 798, 600);
      await driver.delayMs(500);
      // 校验删除
      let clockDataDel: Reminder[] = await getPerferenceData('alarmClock');
      if (clockDataDel !== undefined) {
        let isExistName = clockDataDel.find(element => element.reminderName === lastReminderName) !== undefined;
        if (isExistName) {
          expect().assertFail();
        }
      }
      // 再次新建一个闹钟
      await addClock.click();
      await driver.delayMs(500);
      await driver.swipe(445, 940, 445, 900, 600);
      await driver.delayMs(500);
      await driver.swipe(445, 940, 445, 900, 600);
      await driver.delayMs(500);
      await driver.swipe(445, 940, 445, 900, 600);
      await driver.delayMs(500);
      await confirm.click();
      await driver.delayMs(500);
      // 点击时钟，默认点击第一个
      await driver.assertComponentExist(ON.id('clock0'));
      let clock: Component = await driver.findComponent(ON.id('clock0'));
      await clock.click();
      await driver.delayMs(500);
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
      await vibrationSwitch.click();
      // 选择震动音乐
      await driver.assertComponentExist(ON.id('selectMusic0'));
      let selectMusic: Component = await driver.findComponent(ON.id('selectMusic0'));
      await selectMusic.click();
      await driver.assertComponentExist(ON.text('Demo'));
      let music: Component = await driver.findComponent(ON.text('Demo'));
      await music.click();
      await driver.assertComponentExist(ON.text('确认'));
      let clockConfirm: Component = await driver.findComponent(ON.text('确认'));
      await clockConfirm.click();
      await driver.delayMs(500);
      await clockSwitch.click();
      //验证是否在设置的时间之后收到通知
      await driver.delayMs(130000);
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('闹钟'));
      await driver.delayMs(500);
      await driver.swipe(180, 50, 180, 0, 600);
      await driver.delayMs(500);
      Logger.info(TAG, BUNDLE + 'createClock end');
    });
    /**
     * 设置日历
     */
    it(`${BUNDLE}setCalendar`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'createCalendar begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('日历'));
      let calendarTab: Component = await driver.findComponent(ON.text('日历'));
      await calendarTab.click();
      // 新建一个日历
      await driver.assertComponentExist(ON.id('addCalendar'));
      let addCalendar: Component = await driver.findComponent(ON.id('addCalendar'));
      await addCalendar.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('确定'));
      let confirm: Component = await driver.findComponent(ON.text('确定'));
      await confirm.click();
      await driver.delayMs(500);
      // 开启开关
      await driver.assertComponentExist(ON.id('calendarSwitch0'));
      let calendarSwitch: Component = await driver.findComponent(ON.id('calendarSwitch0'));
      await calendarSwitch.click();
      await driver.delayMs(2000);
      // 获取日历数据
      let calenderData: Reminder[] = await getPerferenceData('Calendar');
      let lastReminderName: string = calenderData[calenderData.length-1].reminderName;
      // 删除日历
      await driver.delayMs(1000);
      await driver.swipe(423, 189, 373, 189, 800);
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      await addCalendar.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('确定'));
      await confirm.click();
      await driver.delayMs(500);
      // 打开日历并设置时间
      await driver.assertComponentExist(ON.id('calendar0'));
      let calendarComp: Component = await driver.findComponent(ON.id('calendar0'));
      await calendarComp.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('calendarTime0'));
      let calendarTime: Component = await driver.findComponent(ON.id('calendarTime0'));
      await calendarTime.click();
      await driver.delayMs(500);
      await driver.swipe(445, 940, 445, 900, 600);
      await driver.delayMs(500);
      await driver.swipe(445, 940, 445, 900, 600);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('确定'));
      let timeConfirm: Component = await driver.findComponent(ON.text('确定'));
      await timeConfirm.click();
      await driver.delayMs(500);
      // 打开震动
      await driver.assertComponentExist(ON.id('vibrationSwitch0'));
      let vibrationSwitch: Component = await driver.findComponent(ON.id('vibrationSwitch0'));
      await vibrationSwitch.click();
      await driver.delayMs(500);
      // 选择音乐
      await driver.assertComponentExist(ON.id('music0'));
      let selectMusic: Component = await driver.findComponent(ON.id('music0'));
      await selectMusic.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('Demo'));
      let music: Component = await driver.findComponent(ON.text('Demo'));
      await music.click();
      await driver.assertComponentExist(ON.text('确认'));
      let calendarConfirm: Component = await driver.findComponent(ON.text('确认'));
      await calendarConfirm.click();
      await driver.delayMs(500);
      // 开启开关
      await calendarSwitch.click();
      //验证是否在设置的时间之后收到通知
      await driver.delayMs(115000);
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('日历'));
      await driver.delayMs(500);
      await driver.swipe(180, 50, 180, 0, 600);
      await driver.delayMs(500);
      Logger.info(TAG, BUNDLE + 'set end');
    });
    // 设置计时器
    it(`${BUNDLE}setCalculagraph`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'calculagraph begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('计时器'));
      let calculagraphTab: Component = await driver.findComponent(ON.text('计时器'));
      await calculagraphTab.click();
      await driver.delayMs(500);
      // 设置计时器时间
      for (let i = 0; i < 6; i++) {
        await driver.swipe(505, 793, 505, 750, 600);
        await driver.delayMs(500);
      }
      // 启动计时器
      await driver.assertComponentExist(ON.id('countDown'));
      let countDown: Component = await driver.findComponent(ON.id('countDown'));
      await driver.assertComponentExist(ON.id('startCalculagraph'));
      let startCalculagraph: Component = await driver.findComponent(ON.id('startCalculagraph'));
      await startCalculagraph.click();
      let timeTime: string = await countDown.getText();
      if (timeTime !== '00:00:06') {
        expect().assertFail();
      }
      //验证是否在设置的时间之后收到通知
      await driver.delayMs(6000);
      await driver.swipe(180, 0, 180, 50, 600);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('计时器'));
      await driver.delayMs(500);
      await driver.swipe(180, 50, 180, 0, 600);
      await driver.delayMs(500);
      // 再次设置计时器时间
      for (let i = 0; i < 6; i++) {
        await driver.swipe(505, 793, 505, 740, 600);
        await driver.delayMs(500);
      }
      await startCalculagraph.click();
      timeTime = await countDown.getText();
      await driver.delayMs(500);
      // 暂停
      await startCalculagraph.click();
      await driver.delayMs(500);
      // 重置计时器
      await driver.assertComponentExist(ON.id('resetCalculagraph'));
      let resetCalculagraph: Component = await driver.findComponent(ON.id('resetCalculagraph'));
      await resetCalculagraph.click();
      timeTime = await countDown.getText();
      if (timeTime !== '00:00:00') {
        expect().assertFail();
      }
      await driver.delayMs(500);
      Logger.info(TAG, BUNDLE + 'calculagraph end');
    });
  })
}