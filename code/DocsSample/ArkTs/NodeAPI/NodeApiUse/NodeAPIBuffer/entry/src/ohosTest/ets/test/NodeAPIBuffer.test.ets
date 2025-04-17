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

export default function nodeAPIBufferTest() {
  describe('nodeAPIBufferTest', () => {
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
     * 点击按钮，调用napiCreateBuffer相关函数
     */
    it('testNodeAPIBuffer001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBuffer001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiCreateBuffer'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateBufferSuccess'));
      console.info('uitest: testNodeAPIBuffer001 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateBufferCopy相关函数
     */
    it('testNodeAPIBuffer002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBuffer002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiCreateBufferCopy'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateBufferCopySuccess'));
      console.info('uitest: testNodeAPIBuffer002 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateExternalBuffer相关函数
     */
    it('testNodeAPIBuffer003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBuffer003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiCreateExternalBuffer'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateExternalBufferSuccess'));
      console.info('uitest: testNodeAPIBuffer003 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetBufferInfo相关函数
     */
    it('testNodeAPIBuffer004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBuffer004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('4.napiGetBufferInfo'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetBufferInfoSuccess'));
      console.info('uitest: testNodeAPIBuffer004 end');
      done();
    })

    /**
     * 点击按钮，调用napiIsBuffer相关函数
     */
    it('testNodeAPIBuffer005', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBuffer005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('5.napiIsBuffer'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiIsBufferSuccess'));
      console.info('uitest: testNodeAPIBuffer005 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateExternalArraybuffer相关函数
     */
    it('testNodeAPIBuffer006', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBuffer006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('6.napiCreateExternalArraybuffer'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateExternalArraybufferSuccess'));
      console.info('uitest: testNodeAPIBuffer006 end');
      done();
    })
  })
}