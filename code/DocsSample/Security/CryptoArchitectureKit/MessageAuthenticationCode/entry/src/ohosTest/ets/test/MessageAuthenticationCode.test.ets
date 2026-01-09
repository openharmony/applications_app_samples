/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function messageAuthenticationCodeTest() {
  describe('messageAuthenticationCodeTest', () => {
    /**
     * 打开应用
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      await driver.delayMs(1000);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * 点击按钮，消息认证码计算(HMAC await方式)
     */
    it('testMessageAuthenticationCode001', 0, async () => {
      console.info('uitest: testMessageAuthenticationCode001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Segmentation Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Segmentation Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Segmentation Async Success'));
      console.info('uitest: testMessageAuthenticationCode001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息认证码计算(HMAC 同步方式)
     */
    it('testMessageAuthenticationCode002', 0, async () => {
      console.info('uitest: testMessageAuthenticationCode002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Segmentation Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Segmentation Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Segmentation Sync Success'));
      console.info('uitest: testMessageAuthenticationCode002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息认证码计算(分段HMAC await方式)
     */
    it('testMessageAuthenticationCode003', 0, async () => {
      console.info('uitest: testMessageAuthenticationCode003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SingleTime Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SingleTime Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SingleTime Async Success'));
      console.info('uitest: testMessageAuthenticationCode003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息认证码计算(分段HMAC 同步方式)
     */
    it('testMessageAuthenticationCode004', 0, async () => {
      console.info('uitest: testMessageAuthenticationCode004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SingleTime Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SingleTime Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SingleTime Sync Success'));
      console.info('uitest: testMessageAuthenticationCode004 end');
      await driver.pressBack();
    })
    it('testMessageAuthenticationCode005', 0, async () => {
      console.info('uitest: testMessageAuthenticationCode005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('CMAC Segmentation Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CMAC Segmentation Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('CMAC Segmentation Async Success'));
      console.info('uitest: testMessageAuthenticationCode005 end');
      await driver.pressBack();
    })
    it('testMessageAuthenticationCode006', 0, async () => {
      console.info('uitest: testMessageAuthenticationCode006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('CMAC Segmentation Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CMAC Segmentation Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('CMAC Segmentation Sync Success'));
      console.info('uitest: testMessageAuthenticationCode006 end');
      await driver.pressBack();
    })
    it('testMessageAuthenticationCode007', 0, async () => {
      console.info('uitest: testMessageAuthenticationCode007 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('CMAC SingleTime Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CMAC SingleTime Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('CMAC SingleTime Async Success'));
      console.info('uitest: testMessageAuthenticationCode007 end');
      await driver.pressBack();
    })
    it('testMessageAuthenticationCode008', 0, async () => {
      console.info('uitest: testMessageAuthenticationCode008 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('CMAC SingleTime Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CMAC SingleTime Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('CMAC SingleTime Sync Success'));
      console.info('uitest: testMessageAuthenticationCode008 end');
  })

   /**
     * 点击按钮，消息认证码计算(C/C++ 消息认证码算法)
     */
     it('testMessageAuthenticationCode009', 0, async () => {
      console.info('uitest: testMessageAuthenticationCode009 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Cpp Test'));
      await driver.delayMs(500);
      await button1.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent(ON.text('Call CMAC SingleTime C++'));
      await button2.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('CMAC SingleTime C++ Success'));
      await driver.delayMs(500);
      const button3 = await driver.findComponent(ON.text('Call CMAC Segmentation C++'));
      await button3.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('CMAC Segmentation C++ Success'));
      await driver.delayMs(500);
      const button4 = await driver.findComponent(ON.text('Call HMAC SingleTime C++'));
      await button4.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('HMAC SingleTime C++ Success'));
      await driver.delayMs(500);
      const button5 = await driver.findComponent(ON.text('Call HMAC Segmentation C++'));
      await button5.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('HMAC Segmentation C++ Success'));
      await driver.delayMs(500);
      console.info('uitest: testMessageAuthenticationCode009 end');
      await driver.pressBack();
    })
  })
}