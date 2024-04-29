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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';

const DRIVER = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async function (done) {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.flipclock',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0x0000, 'testTag', 'StartAbility_001 end');
    })

    /**
     * 获取权限
     */
    it('RequestPermission_001', 0, async () => {
      hilog.info(0x0000, 'testTag', 'RequestPermission begin');
      let driver = Driver.create();
      await driver.delayMs(2000);
      // 获取发送通知权限
      hilog.info(0x0000, 'testTag', 'RequestPermission requestPermission');
      await driver.assertComponentExist(ON.text('允许'));
      let btnStart = await driver.findComponent(ON.text('允许'));
      await btnStart.click();
      hilog.info(0x0000, 'testTag', 'RequestPermission end');
    })

    /**
     * 进入时钟页面
     */
    it('ToIndex_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'ToIndex_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('currentTimeBox'));
      hilog.info(0x0000, 'testTag', 'ToIndex_001 end');
    })

    /**
     * 进入闹钟页面
     */
    it('ToAlarmClock_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'ToAlarmClock_001 begin');
      await DRIVER.assertComponentExist(ON.text('闹钟'));
      let alarmClock = await DRIVER.findComponent(ON.text('闹钟'));
      await alarmClock.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('add'));
      hilog.info(0x0000, 'testTag', 'ToAlarmClock_001 end');
    })

    /**
     * 添加闹钟
     */
    it('AddAlarmClock_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'AddAlarmClock_001 begin');
      let addBtn = await DRIVER.findComponent(ON.id('add'));
      await addBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('timePicker'));
      let timePicker = await DRIVER.findComponent(ON.id('timePicker'));
      let point = await timePicker.getBoundsCenter();
      await DRIVER.swipe(point.x + 20, point.y, point.x + 20, point.y - 40);
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text('是'));
      let confirmBtn = await DRIVER.findComponent(ON.text('是'));
      await confirmBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('deleteAlarmClock'));
      hilog.info(0x0000, 'testTag', 'AddAlarmClock_001 end');
    })

    /**
     * 删除闹钟
     */
    it('DeleteAlarmClock_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'DeleteAlarmClock_001 begin');
      let deleteBtn = await DRIVER.findComponent(ON.id('deleteAlarmClock'));
      await deleteBtn.click();
      await DRIVER.delayMs(1000);
      let deleteBtnAfter = await DRIVER.findComponent(ON.id('deleteAlarmClock'));
      expect(deleteBtnAfter).assertNull();
      hilog.info(0x0000, 'testTag', 'DeleteAlarmClock_001 end');
    })

    /**
     * 进入倒计时页面
     */
    it('ToCountDown_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'ToCountDown_001 begin');
      await DRIVER.assertComponentExist(ON.text('倒计时'));
      let countdown = await DRIVER.findComponent(ON.text('倒计时'));
      await countdown.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('countdownCanvas'));
      await DRIVER.assertComponentExist(ON.id('countdownTime'));
      await DRIVER.assertComponentExist(ON.id('minute'));
      await DRIVER.assertComponentExist(ON.id('reset'));
      await DRIVER.assertComponentExist(ON.id('start'));
      hilog.info(0x0000, 'testTag', 'ToCountDown_001 end');
    })

    /**
     * 开始倒计时
     */
    it('StartCountDown_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'StartCountDown_001 begin');
      // 获取分钟组件
      let minute = await DRIVER.findComponent(ON.id('minute'));
      // 获取中心点
      let point = await minute.getBoundsCenter();
      // 开始滑动页面，设置倒计时1分钟
      await DRIVER.swipe(point.x, point.y, point.x, point.y - 60);
      await DRIVER.delayMs(1000);
      // 获取播放按钮
      let startBtn = await DRIVER.findComponent(ON.id('start'));
      await startBtn.click();
      // 查看倒计时的秒数是否大于0
      let countdownTime = await DRIVER.findComponent(ON.id('countdownTime'));
      expect(parseInt((await countdownTime.getText()).split(':')[2])).assertLarger(0);
      hilog.info(0x0000, 'testTag', 'StartCountDown_001 end');
    })

    /**
     * 暂停倒计时
     */
    it('PauseCountDown_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'PauseCountDown_001 begin');
      // 获取暂停按钮
      let stopBtn = await DRIVER.findComponent(ON.id('start'));
      // 点击暂停按钮
      await stopBtn.click();
      await DRIVER.delayMs(1000);
      // 查看两次获取的时间是否相等
      let currentTime1 = await DRIVER.findComponent(ON.id('countdownTime'));
      await DRIVER.delayMs(1000);
      let currentTime2 = await DRIVER.findComponent(ON.id('countdownTime'));
      let currentTimeSecond1 = parseInt((await currentTime1.getText()).split(':')[2]);
      let currentTimeSecond2 = parseInt((await currentTime2.getText()).split(':')[2]);
      expect(currentTimeSecond1).assertEqual(currentTimeSecond2);
      hilog.info(0x0000, 'testTag', 'PauseCountDown_001 end');
    })

    /**
     * 继续倒计时
     */
    it('ContinueCountDown_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'ContinueCountDown_001 begin');
      // 获取继续按钮
      let continueBtn = await DRIVER.findComponent(ON.id('start'));
      // 点击继续按钮
      await continueBtn.click();
      await DRIVER.delayMs(1000);
      // 查看两次获取的时间
      let currentTime1 = await DRIVER.findComponent(ON.id('countdownTime'));
      let currentTimeSecond1 = parseInt((await currentTime1.getText()).split(':')[2]);
      await DRIVER.delayMs(2000);
      let currentTimeSecond2 = parseInt((await currentTime1.getText()).split(':')[2]);
      // 断言第一次获取的时间比第二次的大
      console.info(`LSQ: ${currentTimeSecond1}--${currentTimeSecond2}`)
      expect(currentTimeSecond1).assertLarger(currentTimeSecond2);
      hilog.info(0x0000, 'testTag', 'ContinueCountDown_001 end');
    })

    /**
     * 重置倒计时
     */
    it('ResetCountDown_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'ResetCountDown_001 begin');
      let resetBtn = await DRIVER.findComponent(ON.id('reset'));
      await resetBtn.click();
      await DRIVER.delayMs(1000);
      let currentTime = await DRIVER.findComponent(ON.id('countdownTime'));
      expect(await currentTime.getText()).assertEqual('00:00:00');
      hilog.info(0x0000, 'testTag', 'ResetCountDown_001 end');
    })

    /**
     * 进入设置页面
     */
    it('ToSetPage_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'ToSetPage_001 begin');
      // 底部tabBar的设置菜单
      await DRIVER.assertComponentExist(ON.text('设置'));
      let setBtn = await DRIVER.findComponent(ON.text('设置'));
      await setBtn.click();
      await DRIVER.delayMs(1000);
      // 设置页面上的设置按钮
      await DRIVER.assertComponentExist(ON.id('Setting'));
      let settingBtn = await DRIVER.findComponent(ON.id('Setting'));
      await settingBtn.click();
      await DRIVER.assertComponentExist(ON.text('全屏'));
      await DRIVER.assertComponentExist(ON.text('屏幕常亮'));
      await DRIVER.assertComponentExist(ON.text('亮度'));
      hilog.info(0x0000, 'testTag', 'ToSetPage_001 end');
    })
  })
}