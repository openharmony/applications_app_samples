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

export default function IntroductionToArkTSTest() {
  describe('IntroductionToArkTSTest', () => {

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

    it('testBasicKnowledge001', 0, async () => {
      console.info('uitest: testBasicKnowledge001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('基本知识'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('测试浮点数类型'));
      const button3 = await driver.findComponent(ON.text('测试BigInt类型'));
      const button4 = await driver.findComponent(ON.text('测试Bool类型'));
      const button5 = await driver.findComponent(ON.text('测试运算符'));
      const button6 = await driver.findComponent(ON.text('测试instanceof'));
      const button7 = await driver.findComponent(ON.text('测试if-else'));
      const button8 = await driver.findComponent(ON.text('测试条件表达式'));
      const button9 = await driver.findComponent(ON.text('测试for-of循环'));
      const button10 = await driver.findComponent(ON.text('测试Aliases类型'));
      const button11 = await driver.findComponent(ON.text('测试异常处理(正常)'));
      const button12 = await driver.findComponent(ON.text('测试异常处理(除零错误)'));
      const button13 = await driver.findComponent(ON.text('测试数据处理'));
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

      console.info('uitest: testBasicKnowledge001 end');
      await driver.pressBack();
    })

    it('testFunction002', 0, async () => {
      console.info('uitest: testFunction002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('函数'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('测试hello函数(无参数)'));
      const button3 = await driver.findComponent(ON.text('测试hello函数(带参数)'));
      const button4 = await driver.findComponent(ON.text('测试可选参数函数'));
      const button5 = await driver.findComponent(ON.text('测试剩余参数'));
      const button6 = await driver.findComponent(ON.text('测试hi1函数'));
      const button7 = await driver.findComponent(ON.text('测试hi2函数'));
      const button8 = await driver.findComponent(ON.text('测试作用域'));
      const button9 = await driver.findComponent(ON.text('测试函数调用'));
      const button10 = await driver.findComponent(ON.text('测试闭包'));
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
      await driver.delayMs(1000);

      console.info('uitest: testFunction002 end');
      await driver.pressBack();
    })

    it('testClass003', 0, async () => {
      console.info('uitest: testClass003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('类'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('测试类的基本用法'));
      const button3 = await driver.findComponent(ON.text('测试实例字段'));
      const button4 = await driver.findComponent(ON.text('测试类的Setter/Getter'));
      const button5 = await driver.findComponent(ON.text('测试Setter错误处理'));
      const button6 = await driver.findComponent(ON.text('测试实例方法'));
      const button7 = await driver.findComponent(ON.text('测试静态方法'));
      const button8 = await driver.findComponent(ON.text('测试Record类型'));
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
      await driver.delayMs(1000);

      console.info('uitest: testClass003 end');
      await driver.pressBack();
    })

    it('testGenericTypesAndFunctions004', 0, async () => {
      console.info('uitest: testGenericTypesAndFunctions004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('泛型类型和函数'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('测试泛型类型'));
      await driver.delayMs(1000);

      await button2.click();
      await driver.delayMs(1000);

      console.info('uitest: testGenericTypesAndFunctions004 end');
      await driver.pressBack();
    })
  })
}