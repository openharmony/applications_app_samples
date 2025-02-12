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
     * 点击按钮，进入使用TaskPool执行多个耗时任务页面，点击Hello World执行
     */
    it('testMultiTimeConsumingTasks', 0, async (done: Function) => {
      console.log('uitest: UsingMultiTimeConsumingTasks begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.MultiTime_consumingTasks'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
	  console.log('uitest: UsingMultiTimeConsumingTasks end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入TaskPool任务与宿主线程通信页面，点击Hello World执行
     */
    it('testTaskSendDataUsage', 0, async (done: Function) => {
      console.log('uitest: UsingTaskSendDataUsage begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.TaskSend_dataUsage'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
	  console.log('uitest: UsingTaskSendDataUsage end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入Worker同步调用宿主线程的接口页面，点击Hello World执行
     */
    it('testWorkerCallGlobalUsage', 0, async (done: Function) => {
      console.log('uitest: UsingWorkerCallGlobalUsage begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.WorkerCall_globalUsage'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
	  console.log('uitest: UsingWorkerCallGlobalUsage end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入Worker和宿主线程的即时消息通信，点击Hello World执行
     */
    it('testWorkerCommunicatesWithMainthread', 0, async (done: Function) => {
      console.log('uitest: UsingWorkerCommunicatesWithMainthread begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.WorkerCommunicates_with_mainthread'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
	  console.log('uitest: UsingWorkerCommunicatesWithMainthread end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入使用TaskPool执行独立的耗时任务页面，点击Hello World执行
     */
    it('testIndependentTimeConsumingTask', 0, async (done: Function) => {
      console.log('uitest: UsingIndependentTimeConsumingTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.IndependentTime_consuming_task'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
	  console.log('uitest: UsingIndependentTimeConsumingTask end');
      await driver.pressBack();
      done();
    })
  })
}