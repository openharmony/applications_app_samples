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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import vibrator from '@ohos.vibrator';
import Logger from '../util/Logger';

const TAG = 'AppTest'
const BUNDLE = 'Vibrator_'

function stopVibration() {
  vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME, (error) => {
    if (error) {
      expect().assertFail();
      Logger.error(TAG, `StopVibration error.code = ${error.code}, error.message = ${error.message}`);
      return;
    }
    Logger.info(TAG, `StopVibration  Callback returned to indicate a successful vibration`);
  })
}

export default function appTest() {
  describe('appTest', function () {
    // 启动应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      let want = {
        bundleName: "ohos.samples.etsvibrator",
        abilityName: "ohos.samples.etsvibrator.MainAbility"
      }
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
        Logger.info(TAG, `_startAbility get err ${JSON.stringify(err)}`);
        done();
        Logger.info(TAG, '_startAbility end');
      });
    });
    // 验证振动功能
    it(`${BUNDLE}VerifyVibration_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'VerifyVibration_001 begin');
      let driver: Driver = Driver.create();
      // 启动振动
      vibrator.startVibration({
        type: 'time',
        duration: 5000,
      }, {
        id: 0,
        usage: 'simulateReality'
      }, async (error) => {
        if (error) {
          expect().assertFail();
          Logger.error(TAG, `StartVibration error.code = ${error.code}, error.message = ${error.message}`);
          return;
        }
        Logger.info(TAG, `Callback returned to indicate a successful vibration`);

      });
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'VerifyVibration_001 end')
    })
    // 设置倒计时时间
    it(`${BUNDLE}SetCountdownTime_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'SetCountdownTime_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      stopVibration();
      // 点击倒计时文本
      await driver.assertComponentExist(ON.id('countdownTime'));
      let countdownTime: Component = await driver.findComponent(ON.id('countdownTime'));
      await countdownTime.click();
      await driver.delayMs(500);
      // 设置倒计时时间,8s
      for (let i = 0;i < 9; i++) {
        await driver.swipe(576, 660, 576, 600, 500);
        await driver.delayMs(500);
      }
      await driver.assertComponentExist(ON.text('确定'));
      let confirm: Component = await driver.findComponent(ON.text('确定'));
      await confirm.click();
      await driver.delayMs(500);
      Logger.info(TAG, BUNDLE + 'SetCountdownTime_001 end');
    })
    // 启动倒计时
    it(`${BUNDLE}StartCountdownTime_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'StartCountdownTime_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 点击倒计时文本
      await driver.assertComponentExist(ON.id('start'));
      let startBtn: Component = await driver.findComponent(ON.id('start'));
      await startBtn.click();
      await driver.delayMs(10000);
      await driver.assertComponentExist(ON.text('确定'));
      let confirm: Component = await driver.findComponent(ON.text('确定'));
      await confirm.click();
      await driver.delayMs(500);
      // 点击确定后，弹窗会关闭
      let dialog = await driver.findComponent(ON.id('textDialog'));
      expect(dialog === null).assertTrue();
      Logger.info(TAG, BUNDLE + 'StartCountdownTime_001 end');
    })
    // 重置定时器
    it(`${BUNDLE}ResetCountdownTime_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'ResetCountdownTime_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 点击倒计时文本
      await driver.assertComponentExist(ON.id('countdownTime'));
      let countdownTime: Component = await driver.findComponent(ON.id('countdownTime'));
      await countdownTime.click();
      await driver.delayMs(500);
      // 设置倒计时时间,8s
      for (let i = 0;i < 9; i++) {
        await driver.swipe(576, 660, 576, 600, 500);
        await driver.delayMs(500);
      }
      await driver.assertComponentExist(ON.text('确定'));
      let confirm: Component = await driver.findComponent(ON.text('确定'));
      await confirm.click();
      await driver.delayMs(500);
      // 点击倒计时文本
      await driver.assertComponentExist(ON.id('start'));
      let startBtn: Component = await driver.findComponent(ON.id('start'));
      await startBtn.click();
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.id('reset'));
      let resetBtn: Component = await driver.findComponent(ON.id('reset'));
      await resetBtn.click();
      await driver.delayMs(500);
      // 校验时间是否为0
      let timeText: string = await countdownTime.getText();
      expect(timeText).assertEqual('00:00:00');
      Logger.info(TAG, BUNDLE + 'ResetCountdownTime_001 end');
    });
  })
}