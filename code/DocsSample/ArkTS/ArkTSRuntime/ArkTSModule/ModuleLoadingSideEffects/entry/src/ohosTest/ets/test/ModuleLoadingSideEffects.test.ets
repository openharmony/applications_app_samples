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

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

export default function moduleLoadingSideEffectsTest() {
  describe('moduleLoadingSideEffectsTest', () => {

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

    it('testModuleLoadingSideEffects001', 0, async () => {
      console.info('uitest: testModuleLoadingSideEffects001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('LazyImport'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('LazyImportSideEffect'));
      const button3 = await driver.findComponent(ON.text('LazyImportOptimize'));
      await driver.delayMs(1000);
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SideEffect: undefined'));
      await driver.delayMs(1000);
      await button3.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Optimize: 100'));
      console.info('uitest: testModuleLoadingSideEffects001 end');
      await driver.pressBack();
    })

    it('testModuleLoadingSideEffects002', 0, async () => {
      console.info('uitest: testModuleLoadingSideEffects002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ModifyGlobalObject'));
      await driver.delayMs(1000);
      await button1.click();

      const button2 = await driver.findComponent(ON.text('SideEffect').type('Button'));
      const button3 = await driver.findComponent(ON.text('Optimize').type('Button'));
      await driver.delayMs(1000);

      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('sideEffect result: 200'));
      await driver.delayMs(1000);

      await button3.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('optimize result: 100'));
      console.info('uitest: testModuleLoadingSideEffects002 end');
      await driver.pressBack();
    })

    it('testModuleLoadingSideEffects003', 0, async () => {
      console.info('uitest: testModuleLoadingSideEffects003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('ModifyingGlobalVariables'));
      await driver.delayMs(1000);
      await button1.click();

      const button2 = await driver.findComponent(ON.text(resourceToString($r('app.string.circular_dependency'))));
      const button3 = await driver.findComponent(ON.text('Not Call modifyPrototype'));
      const button4 = await driver.findComponent(ON.text('Call modifyPrototype'));
      await driver.delayMs(1000);

      await button2.click();
      await button3.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text(resourceToString($r(
        'app.string.circular_dependency')) + 'error: ReferenceError: a is not initialized'));
      await driver.assertComponentExist(ON.text('SideEffect: true'));

      await driver.delayMs(1000);
      await button4.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Optimize: false'));
      console.info('uitest: testModuleLoadingSideEffects003 end');
      await driver.pressBack();
    })

    it('testModuleLoadingSideEffects004', 0, async () => {
      console.info('uitest: testModuleLoadingSideEffects004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('ModifyTheApplicationLevelArkUI'));
      await driver.delayMs(1000);
      await button.click();

      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('test100'));
      await driver.assertComponentExist(ON.text('test200'));
      console.info('uitest: testModuleLoadingSideEffects004 end');
      await driver.pressBack();
    })

    it('testModuleLoadingSideEffects005', 0, async () => {
      console.info('uitest: testModuleLoadingSideEffects005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('TopCodeModification'));
      await driver.delayMs(1000);
      await button1.click();

      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('Call top code'));
      await driver.delayMs(1000);

      await button2.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('sideEffect: Module loaded!1'));
      await driver.assertComponentExist(ON.text('optimize one: 1'));
      await driver.assertComponentExist(ON.text('optimize two: 1'));
      console.info('uitest: testModuleLoadingSideEffects005 end');
    })
  })
}