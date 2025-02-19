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
     * 点击按钮，进入CPU密集型任务开发指导页面，点击Hello World执行
     */
    it('testCpuIntensiveTaskDevelopment', 0, async (done: Function) => {
      console.log('uitest: UsingCpuIntensiveTaskDevelopment begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Cpu_intensive_task_development'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
      console.log('uitest: UsingCpuIntensiveTaskDevelopment end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入I/O密集型任务开发指导页面，点击Hello World执行
     */
    it('testIoIntensiveTaskDevelopment', 0, async (done: Function) => {
      console.log('uitest: UsingIoIntensiveTaskDevelopment begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Io_intensive_task_development'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
      console.log('uitest: UsingIoIntensiveTaskDevelopment end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入同步任务开发指导页面，点击Hello World执行
     */
    it('testSyncTaskDevelopment', 0, async (done: Function) => {
      console.log('uitest: UsingSyncTaskDevelopment begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Sync_task_development'))));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
      console.log('uitest: UsingSyncTaskDevelopment end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入长时任务开发指导页面，点击Add listener和Delete listener执行
     */
    it('testLongTimeTaskGuide', 0, async (done: Function) => {
      console.log('uitest: UsingLongTimeTaskGuide begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Long_time_task_guide'))));
      await text.click();
      await driver.delayMs(1000);
      const addListener = await driver.findComponent(ON.id('Add listener'));
      await addListener.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Add listener').text('success'));
      await driver.delayMs(1000);
      const deleteListener = await driver.findComponent(ON.id('Delete listener'));
      await deleteListener.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Delete listener').text('success'));
      console.log('uitest: UsingLongTimeTaskGuide end');
      await driver.pressBack();
      done();
    })
    /**
     * 点击按钮，进入常驻任务开发指导页面，点击Listener task执行
     */
    it('testResidentTaskGuide', 0, async (done: Function) => {
      console.log('uitest: UsingResidentTaskGuide begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Resident_task_guide'))));
      await text.click();
      await driver.delayMs(1000);
      const listener = await driver.findComponent(ON.text('Listener task'));
      await listener.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
      console.log('uitest: UsingResidentTaskGuide end');
      await driver.pressBack();
      done();
    })
  })
}