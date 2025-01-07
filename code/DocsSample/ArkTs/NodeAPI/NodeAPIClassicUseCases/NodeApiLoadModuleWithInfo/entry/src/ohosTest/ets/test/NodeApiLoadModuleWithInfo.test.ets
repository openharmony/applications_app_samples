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

export default function nodeApiLoadModuleWithInfoTest() {
  describe('nodeApiLoadModuleWithInfoTest', () => {

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
     * 点击按钮，加载模块内文件路径
     */
    it('testNodeApiLoadModuleWithInfo001', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleWithInfo001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call loadModuleFile'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('loadModuleFile success'));
      console.info('uitest: testNodeApiLoadModuleWithInfo001 end');
    })

    /**
     * 点击按钮，加载HAR模块名
     */
    it('testNodeApiLoadModuleWithInfo002', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleWithInfo002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call loadModuleHarName'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('loadModuleHarName success'));
      console.info('uitest: testNodeApiLoadModuleWithInfo002 end');
    })

    /**
     * 点击按钮，加载远程HAR模块名
     */
    it('testNodeApiLoadModuleWithInfo003', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleWithInfo003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call loadModuleRemoteHar'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('loadModuleRemoteHar success'));
      console.info('uitest: testNodeApiLoadModuleWithInfo003 end');
    })

    /**
     * 点击按钮，加载API模块
     */
    it('testNodeApiLoadModuleWithInfo004', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleWithInfo004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call loadModuleAPI'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('loadModuleAPI success'));
      console.info('uitest: testNodeApiLoadModuleWithInfo004 end');
    })

    /**
     * 点击按钮，加载Native库
     */
    it('testNodeApiLoadModuleWithInfo005', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleWithInfo005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call loadModuleNative'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('loadModuleNative success'));
      console.info('uitest: testNodeApiLoadModuleWithInfo005 end');
    })

    /**
     * 点击按钮，调用loadModuleHarToHar相关函数
     */
    it('testNodeApiLoadModuleWithInfo006', 0, async (done: Function) => {
      console.info('uitest: testNodeApiLoadModuleWithInfo006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call loadModuleHarToHar'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('loadModuleHarToHar success'));
      console.info('uitest: testNodeApiLoadModuleWithInfo006 end');
      done();
    })
  })
}