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
import resource from '../../../main/ets/util/resource';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

let want: Want;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
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
     * 点击按钮，进入异步锁页面，点击Hello World执行
     */
    it('testArktsAsyncLockIntroduction', 0, async (done: Function) => {
      console.log('uitest: TestArktsAsyncLockIntroduction begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Arkts_asyncLock_introduction'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
	  console.log('uitest: TestArktsAsyncLockIntroduction end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入ASON解析与生成页面，点击Hello World执行
     */
    it('testAsonParsingGeneration', 0, async (done: Function) => {
      console.log('uitest: TestAsonParsingGeneration begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Ason_parsing_generation'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
	  console.log('uitest: TestAsonParsingGeneration end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入共享容器页面，点击Hello World执行
     */
    it('testArktsCollectionsIntroduction', 0, async (done: Function) => {
      console.log('uitest: TestArktsCollectionsIntroduction begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Arkts_collections_introduction'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
	  console.log('uitest: TestArktsCollectionsIntroduction end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入共享模块页面，点击MainThread print count,Taskpool print count,
     * MainThread increase count,Taskpool increase count执行
     */
    it('testArktsSendableModule', 0, async (done: Function) => {
      console.log('uitest: TestArktsSendableModule begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Arkts_sendable_module'))));
      await text.click();
      await driver.delayMs(1000);
      const mainThreadPrint = await driver.findComponent(ON.id('MainThread print count'));
      await mainThreadPrint.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('MainThread print count').text('success'));

      await driver.delayMs(1000);
      const taskpoolPrint = await driver.findComponent(ON.id('Taskpool print count'));
      await taskpoolPrint.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Taskpool print count').text('success'));

      await driver.delayMs(1000);
      const mainThreadIncrease = await driver.findComponent(ON.id('MainThread increase count'));
      await mainThreadIncrease.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('MainThread increase count').text('success'));

      await driver.delayMs(1000);
      const taskpoolIncrease = await driver.findComponent(ON.id('Taskpool increase count'));
      await taskpoolIncrease.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Taskpool increase count').text('success'));
	  console.log('uitest: TestArktsSendableModule end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入Sendable对象冻结页面，点击Sendable freezeObj Test执行
     */
    it('testSendableFreeze', 0, async (done: Function) => {
      console.log('uitest: TestSendableFreeze begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Sendable_freeze'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Sendable freezeObj Test'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
	  console.log('uitest: TestSendableFreeze end');
      await driver.pressBack();
      done();
    })
  })
}