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
import Logger from '../util/Logger';

const BUNDLE = 'Npm_'
const TAG = 'AppTestPage'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, 'StartAbility start')
      let want = {
        bundleName: 'ohos.samples.npm',
        abilityName: 'MainAbility'
      }
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err, data) => {
        Logger.info(TAG, `StartAbility get err ${JSON.stringify(err)}`)
        done()
        Logger.info(TAG, 'StartAbility end');
      })
    })
    /**
     * 获取验证码
     */
    it(BUNDLE + 'IndexPage_getCode_001', 0, async function () {
      Logger.info(TAG, 'IndexPage_getCode_001 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击获取验证码
      await driver.assertComponentExist(ON.id('getCode'));
      let btnGetCode = await driver.findComponent(ON.id('getCode'));
      await btnGetCode.click();
      await driver.delayMs(1000);
      // 校验二维码
      await driver.assertComponentExist(ON.id('checkCode'));
      let checkCode = await driver.findComponent(ON.id('checkCode'));
      let checkCodeText = await checkCode.getText();
      if (checkCodeText) {
        // 验证二维码的长度
        if (checkCodeText.length === 6) {
          Logger.info(TAG, 'get code success');
        } else {
          expect().assertFail();
        }
      } else {
        expect().assertFail();
      }
      // 点击下一页
      await driver.assertComponentExist(ON.id('indexNextPage'));
      let indexNextPage = await driver.findComponent(ON.id('indexNextPage'));
      await indexNextPage.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'IndexPage_getCode_001 end');
    })
    /**
     * 计算延迟推进日期
     */
    it(BUNDLE + 'DatePage_InputDate_001', 0, async function () {
      Logger.info(TAG, 'DatePage_InputDate_001 start')
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击确认验证弹窗
      await driver.assertComponentExist(ON.id('confirm'));
      let comfirmBtn = await driver.findComponent(ON.id('confirm'));
      await comfirmBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('确定'));
      let comfirm = await driver.findComponent(ON.text('确定'));
      await comfirm.click();
      await driver.delayMs(1000);
      // 点击输入需要计算的日期
      await driver.assertComponentExist(ON.id('computeDate'));
      let computeDate = await driver.findComponent(ON.id('computeDate'));
      await computeDate.inputText('2000-01-05');
      await driver.delayMs(1000);
      await driver.delayMs(1000);
      // 点击向前推多少天
      await driver.assertComponentExist(ON.id('beforeDays'));
      let beforeDays = await driver.findComponent(ON.id('beforeDays'));
      await beforeDays.inputText('3');
      ;
      await driver.delayMs(1000);
      // 点击向后推多少天
      await driver.assertComponentExist(ON.id('afterDays'));
      let afterDays = await driver.findComponent(ON.id('afterDays'));
      await afterDays.inputText('3');
      await driver.delayMs(1000);
      // 点击确认推进以及延迟后的日期
      await comfirmBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('beforeDaysText'));
      let beforeDaysText = await driver.findComponent(ON.id('beforeDaysText'));
      expect('2000-1-2').assertEqual(await beforeDaysText.getText());
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('afterDaysText'));
      let afterDaysText = await driver.findComponent(ON.id('afterDaysText'));
      expect('2000-1-8').assertEqual(await afterDaysText.getText());
      await driver.delayMs(1000);
      // 跳转下一页
      await driver.assertComponentExist(ON.id('dateNextPage'));
      let nextPage = await driver.findComponent(ON.id('dateNextPage'));
      await nextPage.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'DatePage_InputDate_001 end');
    })
    /**
     * 拼接字符串
     */
    it(BUNDLE + 'LocalLibrarry_InputString_001', 0, async function () {
      Logger.info(TAG, 'LocalLibrarry_InputString_001 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('confirmBtn'));
      let comfirmBtn = await driver.findComponent(ON.id('confirmBtn'));
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('确定'));
      let comfirm = await driver.findComponent(ON.text('确定'));
      await comfirm.click();
      await driver.delayMs(1000);
      // 点击输入第一个字符串
      await driver.assertComponentExist(ON.id('firstStrTextArea'));
      let computeDate = await driver.findComponent(ON.id('firstStrTextArea'));
      await driver.delayMs(1000);
      await computeDate.inputText('hello');
      await driver.delayMs(1000);
      // 输入第二个字符串
      await driver.assertComponentExist(ON.id('secondStrTextArea'));
      let secondStrTextArea = await driver.findComponent(ON.id('secondStrTextArea'));
      await secondStrTextArea.inputText('world');
      await driver.delayMs(1000);
      // 点击确认生成拼接后的字符串
      await comfirmBtn.click();
      await driver.delayMs(1000);
      // 验证拼接字符串
      await driver.assertComponentExist(ON.id('montage'));
      let montage = await driver.findComponent(ON.id('montage'));
      let montageText = await montage.getText();
      await driver.delayMs(1000);
      expect('helloworld').assertEqual(montageText)
      await driver.delayMs(1000);
      Logger.info(TAG, 'LocalLibrarry_InputString_001 end');
    });
  })
}
