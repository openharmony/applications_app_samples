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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';
import Want from '@ohos.app.ability.Want';

const TAG = '[Sample_ArkTSDistributedCalc]';
const BUNDLE = 'ArkTSDistributedCalc_';

export default function appTest() {
  let driver = Driver.create();
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('appTest', () => {
    // 启动应用
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}StartAbility_002 begin`);
      let want: Want = {
        bundleName: "ohos.samples.distributedcalc",
        abilityName: "MainAbility"
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      });
      await driver.delayMs(2000);
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    /**
     * 获取权限，并判断是否正常进入主页
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}RequestPermissionFunction_001 begin`);
      // 获取权限
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('允许'))
      let btnStart = await driver.findComponent(ON.text('允许'));
      await btnStart.click();
      await delegator.getCurrentTopAbility().then((Ability) => {
        logger.info(TAG, `${BUNDLE}get top ability`);
        expect(Ability.context.abilityInfo.name).assertEqual('MainAbility');
      })
      logger.info(TAG, `${BUNDLE}RequestPermissionFunction_001 end`);
      done();
    })

    /**
     * 检测选择设备弹窗是否能正常弹出
     */
    it(BUNDLE + 'SelectDeviceDialog_001', 0, async (done: Function ) => {
      logger.info(TAG, `${BUNDLE}SelectDeviceDialog_001 begin`);
      // 获取权限
      await driver.assertComponentExist(ON.id('selectDevice'))
      let selectDevice = await driver.findComponent(ON.id('selectDevice'));
      await selectDevice.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('选择设备', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text('取消', MatchPattern.CONTAINS));
      let cancel = await driver.findComponent(ON.text('取消', MatchPattern.CONTAINS));
      await cancel.click();
      logger.info(TAG, `${BUNDLE}SelectDeviceDialog_001 end`);
      done();
    })

    /**
     * clear功能
     */
    it(BUNDLE + 'Clear_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Clear_001 begin`);
      await driver.assertComponentExist(ON.id('7'));
      await driver.assertComponentExist(ON.id('5'));
      let five = await driver.findComponent(ON.id('5'));
      let seven = await driver.findComponent(ON.id('7'));
      await five.click();
      await seven.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('expression'));
      let expressionText = await driver.findComponent(ON.id('expression'));
      let expression = await expressionText.getText();
      expect(expression.length > 0).assertTrue();
      await driver.assertComponentExist(ON.id('C'));
      let clear = await driver.findComponent(ON.id('C'));
      await clear.click();
      await driver.delayMs(1000);
      let expression1 = await expressionText.getText();
      expect(expression1.length == 0).assertTrue();
      logger.info(TAG, `${BUNDLE}Clear_001 end`);
      done();
    })

    /**
     * Delete功能
     */
    it(BUNDLE + 'Delete_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Delete_001 begin`);
      await driver.assertComponentExist(ON.id('7'));
      await driver.assertComponentExist(ON.id('5'));
      let five = await driver.findComponent(ON.id('5'));
      let seven = await driver.findComponent(ON.id('7'));
      await five.click();
      await seven.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('expression'));
      let expressionText = await driver.findComponent(ON.id('expression'));
      let expression = await expressionText.getText();
      expect(expression.length == 2).assertTrue();
      await driver.assertComponentExist(ON.id('D'));
      let deleteOperation = await driver.findComponent(ON.id('D'));
      await deleteOperation.click();
      await driver.delayMs(1000);
      let expression1 = await expressionText.getText();
      expect(expression1.length == 1).assertTrue();
      logger.info(TAG, `${BUNDLE}Delete_001 end`);
      done();
    })

    /**
     * 简单混合运算
     */
    it(BUNDLE + 'Operation_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Operation_001 begin`);
      await driver.assertComponentExist(ON.id('C'));
      let clear = await driver.findComponent(ON.id('C'));
      await clear.click();
      await driver.assertComponentExist(ON.id('8'));
      let eight = await driver.findComponent(ON.id('8'));
      await driver.assertComponentExist(ON.id('/'));
      let div = await driver.findComponent(ON.id('/'));
      await driver.assertComponentExist(ON.id('2'));
      let two = await driver.findComponent(ON.id('2'));
      await driver.assertComponentExist(ON.id('+'));
      let add = await driver.findComponent(ON.id('+'));
      await driver.assertComponentExist(ON.id('3'));
      let three = await driver.findComponent(ON.id('3'));
      await driver.assertComponentExist(ON.id('*'));
      let mul = await driver.findComponent(ON.id('*'));
      await driver.assertComponentExist(ON.id('4'));
      let four = await driver.findComponent(ON.id('4'));
      await driver.assertComponentExist(ON.id('-'));
      let sub = await driver.findComponent(ON.id('-'));
      await driver.assertComponentExist(ON.id('5'));
      let five = await driver.findComponent(ON.id('5'));
      await eight.click();
      await div.click();
      await two.click();
      await add.click();
      await three.click();
      await mul.click();
      await four.click();
      await sub.click();
      await five.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('expression'));
      let expressionText = await driver.findComponent(ON.id('expression'));
      let expression = await expressionText.getText();
      await driver.assertComponentExist(ON.id('result'));
      let resultText = await driver.findComponent(ON.id('result'));
      let result = await resultText.getText();
      expect(expression === '8/2+3*4-5' && result === '11.000').assertTrue();
      await driver.assertComponentExist(ON.id('='));
      let equal = await driver.findComponent(ON.id('='));
      await equal.click();
      await driver.delayMs(1000);
      let expression1 = await expressionText.getText();
      expect(expression1 === '11.000').assertTrue();
      logger.info(TAG, `${BUNDLE}Operation_001 end`);
      done();
    })
  })
}