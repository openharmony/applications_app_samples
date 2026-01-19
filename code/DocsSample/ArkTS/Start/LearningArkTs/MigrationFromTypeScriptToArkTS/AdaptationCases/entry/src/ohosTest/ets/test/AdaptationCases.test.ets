/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
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

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function BasicAdaptationTest() {
  describe('BasicAdaptationTest', () => {

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

    it('testBasicAdaptation001', 0, async () => {
      console.info('uitest: testBasicAdaptation001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('基础适配场景'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('测试foo回调函数'));
      const button3 = await driver.findComponent(ON.text('测试printObj函数'));
      const button4 = await driver.findComponent(ON.text('测试Controller'));
      const button5 = await driver.findComponent(ON.text('测试使用type定义工厂函数或普通函数类型'));
      const button6 = await driver.findComponent(ON.text('测试Map遍历'));
      const button7 = await driver.findComponent(ON.text('测试Object.entries'));
      const button8 = await driver.findComponent(ON.text('测试Test类的foo方法'));
      const button9 = await driver.findComponent(ON.text('测试Controller in block'));
      const button10 = await driver.findComponent(ON.text('测试A类的fooApply'));
      const button11 = await driver.findComponent(ON.text('测试TestMenu Controller'));
      const button12 = await driver.findComponent(ON.text('测试C1和C2静态值'));
      const button13 = await driver.findComponent(ON.text('测试Foo静态方法'));
      await driver.delayMs(1000);

      await button2.click();
      await driver.delayMs(500);
      await button3.click();
      await driver.delayMs(500);
      await button4.click();
      await driver.delayMs(500);
      await button5.click();
      await driver.delayMs(500);
      await button6.click();
      await driver.delayMs(500);
      await button7.click();
      await driver.delayMs(500);
      await button8.click();
      await driver.delayMs(500);
      await button9.click();
      await driver.delayMs(500);
      await button10.click();
      await driver.delayMs(500);
      await button11.click();
      await driver.delayMs(500);
      await button12.click();
      await driver.delayMs(500);
      await button13.click();
      await driver.delayMs(1000);

      console.info('uitest: testBasicAdaptation001 end');
      await driver.pressBack();
    })

    it('testUsingStateVariablesOutsideOfStructs002', 0, async () => {
      console.info('uitest: testUsingStateVariablesOutsideOfStructs002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Struct组件外使用状态变量'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('change value'));
      await driver.delayMs(1000);

      await button2.click();
      await driver.delayMs(1000);

      console.info('uitest: testUsingStateVariablesOutsideOfStructs002 end');
      await driver.pressBack();
    })

    it('testUsingUnionTypesInStructs003', 0, async () => {
      console.info('uitest: testUsingUnionTypesInStructs003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Struct支持联合类型的方案'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(2000);

      console.info('uitest: testUsingUnionTypesInStructs003 end');
      await driver.pressBack();
    })
  })
}
