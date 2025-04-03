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

export default function messageDigestComputationTest() {
  describe('messageDigestComputationTest', () => {
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
     * 点击按钮，消息摘要计算(ArkTS 摘要算法await方式)
     */
    it('testMessageDigestComputation001', 0, async () => {
      console.info('uitest: testMessageDigestComputation001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SegmentationAsync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SegmentationAsync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SegmentationAsyncSuccess'));
      console.info('uitest: testMessageDigestComputation001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(ArkTS 摘要算法同步方式)
     */
    it('testMessageDigestComputation002', 0, async () => {
      console.info('uitest: testMessageDigestComputation002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SegmentationSync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SegmentationSync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SegmentationSyncSuccess'));
      console.info('uitest: testMessageDigestComputation002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(ArkTS 分段摘要算法await方式)
     */
    it('testMessageDigestComputation003', 0, async () => {
      console.info('uitest: testMessageDigestComputation003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SingleTimeAsync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SingleTimeAsync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SingleTimeAsyncSuccess'));
      console.info('uitest: testMessageDigestComputation003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(ArkTS 分段摘要算法同步方式)
     */
    it('testMessageDigestComputation004', 0, async () => {
      console.info('uitest: testMessageDigestComputation004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SingleTimeSync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SingleTimeSync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SingleTimeSyncSuccess'));
      console.info('uitest: testMessageDigestComputation004 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(C/C++ 摘要算法)
     */
    it('testMessageDigestComputation005', 0, async () => {
      console.info('uitest: testMessageDigestComputation005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SingleTime C++'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SingleTime C++ Success Result:0'));
      console.info('uitest: testMessageDigestComputation005 end');
    })

    /**
     * 点击按钮，消息摘要计算(C/C++ 分段摘要算法)
     */
    it('testMessageDigestComputation006', 0, async () => {
      console.info('uitest: testMessageDigestComputation006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Segmentation C++'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Segmentation C++ Success Result:0'));
      console.info('uitest: testMessageDigestComputation006 end');
    })
  })
}