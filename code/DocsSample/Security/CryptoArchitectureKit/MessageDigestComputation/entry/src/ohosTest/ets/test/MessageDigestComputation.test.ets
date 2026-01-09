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
     * 点击按钮，消息摘要计算(sha3 ArkTS 摘要算法await方式)
     */
    it('testMessageDigestComputation007', 0, async () => {
      console.info('uitest: testMessageDigestComputation007 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SHA3 SingleTimeAsync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SHA3 SingleTimeAsync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SHA3 SingleTimeAsync Success'));
      console.info('uitest: testMessageDigestComputation007 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(ArkTS 摘要算法同步方式)
     */
    it('testMessageDigestComputation008', 0, async () => {
      console.info('uitest: testMessageDigestComputation008 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SHA3 SingleTimeSync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SHA3 SingleTimeSync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SHA3 SingleTimeSync Success'));
      console.info('uitest: testMessageDigestComputation008 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(ArkTS 分段摘要算法await方式)
     */
    it('testMessageDigestComputation009', 0, async () => {
      console.info('uitest: testMessageDigestComputation009 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SHA3 SegmentationAsync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SHA3 SegmentationAsync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SHA3 SegmentationAsync Success'));
      console.info('uitest: testMessageDigestComputation009 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(ArkTS 分段摘要算法同步方式)
     */
    it('testMessageDigestComputation010', 0, async () => {
      console.info('uitest: testMessageDigestComputation010 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SHA3 SegmentationSync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SHA3 SegmentationSync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SHA3 SegmentationSync Success'));
      console.info('uitest: testMessageDigestComputation010 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(sha3 ArkTS 摘要算法await方式)
     */
    it('testMessageDigestComputation011', 0, async () => {
      console.info('uitest: testMessageDigestComputation011 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call MD5 SingleTimeAsync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call MD5 SingleTimeAsync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('MD5 SingleTimeAsync Success'));
      console.info('uitest: testMessageDigestComputation011 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(ArkTS 摘要算法同步方式)
     */
    it('testMessageDigestComputation012', 0, async () => {
      console.info('uitest: testMessageDigestComputation012 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call MD5 SingleTimeSync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call MD5 SingleTimeSync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('MD5 SingleTimeSync Success'));
      console.info('uitest: testMessageDigestComputation012 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(ArkTS 分段摘要算法await方式)
     */
    it('testMessageDigestComputation013', 0, async () => {
      console.info('uitest: testMessageDigestComputation013 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call MD5 SegmentationAsync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call MD5 SegmentationAsync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('MD5 SegmentationAsync Success'));
      console.info('uitest: testMessageDigestComputation013 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(ArkTS 分段摘要算法同步方式)
     */
    it('testMessageDigestComputation014', 0, async () => {
      console.info('uitest: testMessageDigestComputation014 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call MD5 SegmentationSync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call MD5 SegmentationSync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('MD5 SegmentationSync Success'));
      console.info('uitest: testMessageDigestComputation014 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，消息摘要计算(C/C++ 摘要算法)
     */
    it('testMessageDigestComputation015', 0, async () => {
      console.info('uitest: testMessageDigestComputation015 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Cpp Test'));
      await driver.delayMs(500);
      await button1.click();
      await driver.delayMs(500);
      const button2 = await driver.findComponent(ON.text('SingleTime C++'));
      await button2.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('SHA256 SingleTime C++ Success'));
      await driver.delayMs(500);
      const button3 = await driver.findComponent(ON.text('Segmentation C++'));
      await button3.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('SHA256 Segmentation C++ Success'));
      await driver.delayMs(500);
      const button4 = await driver.findComponent(ON.text('SHA3 SingleTime C++'));
      await button4.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('SHA3 SingleTime C++ Success'));
      await driver.delayMs(500);
      const button5 = await driver.findComponent(ON.text('SHA3 Segmentation C++'));
      await button5.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('SHA3 Segmentation C++ Success'));
      await driver.delayMs(500);
      const button6 = await driver.findComponent(ON.text('MD5 SingleTime C++'));
      await button6.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('MD5 SingleTime C++ Success'));
      await driver.delayMs(500);
      const button7 = await driver.findComponent(ON.text('MD5 Segmentation C++'));
      await button7.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('MD5 Segmentation C++ Success'));
      console.info('uitest: testMessageDigestComputation015 end');
      await driver.pressBack();
    })
  })
}