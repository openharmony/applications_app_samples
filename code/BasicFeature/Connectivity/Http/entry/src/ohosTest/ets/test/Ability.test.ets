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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import inputMethod from '@ohos.inputMethod';

const DRIVER = Driver.create();
const BUNDLE = 'http';
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    /**
     * 拉起应用
     */
    it(`${BUNDLE}_StartAbility_001`, 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0xF811, 'testTag', 'StartAbility_001 begin');
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.http',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0xF811, 'testTag', 'StartAbility_001 end');
    })

    /**
     * 检查首页
     */
    it(`${BUNDLE}_CheckIndexPage_001`, 0, async () => {
      hilog.info(0xF811, 'testTag', 'CheckIndexPage_001 begin');
      await DRIVER.delayMs(1000);
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      let manager = ability.context.resourceManager;
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.configuration'))));
      await DRIVER.assertComponentExist(ON.id('GET'));
      await DRIVER.assertComponentExist(ON.id('key1'));
      await DRIVER.assertComponentExist(ON.id('value1'));
      await DRIVER.assertComponentExist(ON.id('add'));
      await DRIVER.assertComponentExist(ON.id('reduce'));
      await DRIVER.assertComponentExist(ON.id('reset'));
      await DRIVER.assertComponentExist(ON.id('submit'));
      await DRIVER.assertComponentExist(ON.id('back'));
      hilog.info(0xF811, 'testTag', 'CheckIndexPage_001 end');
    })

    /**
     * 增加两队key、value
     */
    it(`${BUNDLE}_AddParameter_001`, 0, async () => {
      hilog.info(0xF811, 'testTag', 'AddParameter_001 begin');
      await DRIVER.delayMs(1000);
      let addBtn = await DRIVER.findComponent(ON.id('add'));
      await addBtn.click();
      await DRIVER.delayMs(1000);
      await addBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('key2'));
      await DRIVER.assertComponentExist(ON.id('value2'));
      await DRIVER.assertComponentExist(ON.id('key3'));
      await DRIVER.assertComponentExist(ON.id('value3'));
      hilog.info(0xF811, 'testTag', 'AddParameter_001 end');
    })

    /**
     * 减少一对key、value
     */
    it(`${BUNDLE}_ReduceParameter_001`, 0, async () => {
      hilog.info(0xF811, 'testTag', 'ReduceParameter_001 begin');
      await DRIVER.delayMs(1000);
      let reduceBtn = await DRIVER.findComponent(ON.id('reduce'));
      await reduceBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('key2'));
      await DRIVER.assertComponentExist(ON.id('value2'));
      let key3 = await DRIVER.findComponent(ON.id('key3'));
      expect(key3).assertNull();
      hilog.info(0xF811, 'testTag', 'ReduceParameter_001 end');
    })

    /**
     * 重置一次，回到只有一对key、value
     */
    it(`${BUNDLE}_ResetParameter_001`, 0, async () => {
      hilog.info(0xF811, 'testTag', 'ResetParameter_001 begin');
      await DRIVER.delayMs(1000);
      let resetBtn = await DRIVER.findComponent(ON.id('reset'));
      await resetBtn.click();
      await DRIVER.delayMs(1000);
      let key2 = await DRIVER.findComponent(ON.id('key2'));
      expect(key2).assertNull();
      hilog.info(0xF811, 'testTag', 'ResetParameter_001 end');
    })

    /**
     * 输入网址，点击确定
     */
    it(`${BUNDLE}_SendRequest_001`, 0, async () => {
      hilog.info(0xF811, 'testTag', 'SendRequest_001 begin');
      await DRIVER.delayMs(1000);
      let ipAddress = await DRIVER.findComponent(ON.id('GET'));
      await ipAddress.inputText('https://baidu.com');
      await DRIVER.delayMs(1000);
      // 停止会话,关闭键盘
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      await DRIVER.delayMs(1000);
      let submitBtn = await DRIVER.findComponent(ON.id('submit'));
      await submitBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('succeed'));
      hilog.info(0xF811, 'testTag', 'SendRequest_001 end');
    })

    /**
     * 返回首页
     */
    it(`${BUNDLE}_BackToIndex_001`, 0, async () => {
      hilog.info(0xF811, 'testTag', 'BackToIndex_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('mainPage'));
      let mainPage = await DRIVER.findComponent(ON.id('mainPage'));
      let point = await mainPage.getBounds();
      await DRIVER.swipe(point.right / 2, point.bottom - 20, point.right / 2, point.top + 20);
      await DRIVER.delayMs(1000);
      await DRIVER.swipe(point.right / 2, point.bottom - 20, point.right / 2, point.top + 20);
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('back'));
      let backBtn = await DRIVER.findComponent(ON.id('back'));
      await backBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('submit'));
      hilog.info(0xF811, 'testTag', 'BackToIndex_001 end');
    })

    /**
     * 空参数测试错误提示
     */
    it(`${BUNDLE}_SendRequest_002`, 0, async () => {
      hilog.info(0xF811, 'testTag', 'SendRequest_002 begin');
      await DRIVER.delayMs(1000);
      let submitBtn = await DRIVER.findComponent(ON.id('submit'));
      await submitBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('failed'));
      hilog.info(0xF811, 'testTag', 'SendRequest_002 end');
    })
  })
}