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
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility',
        parameters: {
          'targetPage': 'ProgressCase1'  // 直接跳转到进度条测试页面
        }
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1500);

      // 验证当前页面是否正确
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /**
     * @tc.number ProgressTest_001
     * @tc.name testProgressComponentsExist
     * @tc.desc 验证所有进度条组件是否存在
     */
    it('testProgressComponentsExist', 0, async (done: Function) => {
      console.info('ProgressTest: testProgressComponentsExist begin');

      // 验证标题文本
      const linearText = await driver.findComponent(ON.text('Linear Progress'));
      const ringText = await driver.findComponent(ON.text('Ring Progress'));
      const scaleRingText = await driver.findComponent(ON.text('ScaleRing Progress'));
      const eclipseText = await driver.findComponent(ON.text('Eclipse Progress'));
      const capsuleText = await driver.findComponent(ON.text('Capsule Progress'));
      expect(linearText === null).assertFalse();
      expect(ringText === null).assertFalse();
      expect(scaleRingText === null).assertFalse();
      expect(eclipseText === null).assertFalse();
      expect(capsuleText === null).assertFalse();
      console.info('ProgressTest: testProgressComponentsExist end');
      done();
    });

    /**
     * @tc.number ProgressTest_002
     * @tc.name testProgressIncrease
     * @tc.desc 测试进度条增加功能
     */
    it('testProgressIncrease', 0, async (done: Function) => {
      console.info('ProgressTest: testProgressIncrease begin');
      const increaseBtn = await driver.findComponent(ON.text('进度条+5'));
      expect(increaseBtn === null).assertFalse();
      await increaseBtn.click();
      await driver.delayMs(500);
      console.info('ProgressTest: testProgressIncrease end');
      done();
    });

    /**
     * @tc.number ProgressTest_003
     * @tc.name testProgressDecrease
     * @tc.desc 测试进度条减少功能
     */
    it('testProgressDecrease', 0, async (done: Function) => {
      console.info('ProgressTest: testProgressDecrease begin');
      const increaseBtn = await driver.findComponent(ON.text('进度条+5'));
      await increaseBtn.click();
      await increaseBtn.click();
      await driver.delayMs(500);
      const decreaseBtn = await driver.findComponent(ON.text('进度条-5'));
      expect(decreaseBtn === null).assertFalse();
      await decreaseBtn.click();
      await driver.delayMs(500);
      console.info('ProgressTest: testProgressDecrease end');
      done();
    });

    /**
     * @tc.number ProgressTest_004
     * @tc.name testProgressMaxValue
     * @tc.desc 测试进度条最大值处理
     */
    it('testProgressMaxValue', 0, async (done: Function) => {
      console.info('ProgressTest: testProgressMaxValue begin');
      const increaseBtn = await driver.findComponent(ON.text('进度条+5'));
      for (let i = 0; i < 25; i++) {
        await increaseBtn.click();
        await driver.delayMs(100);
      }
      await driver.delayMs(500);
      const decreaseBtn = await driver.findComponent(ON.text('进度条-5'));
      expect(decreaseBtn === null).assertFalse();
      await decreaseBtn.click();
      await driver.delayMs(500);
      console.info('ProgressTest: testProgressDecrease end');
      done();
    });
  });
}