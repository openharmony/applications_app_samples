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

import { describe, it, expect } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}
export default function abilityTest() {
  describe('DomainAccountAbilityTest', () => {
    /*
     * 打开应用，依次点击页面中按钮
     * 使用域账号接口功能
     */
    it('DomainAccountsExample', 0, async (done: Function) => {
      console.info("uitest: TestUiExample begin");
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      }
      await delegator.startAbility(want);
      await sleep(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('ManageDomainAccountsPlugin'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.id('button1'));
      await button2.click();
      await driver.delayMs(1000);
      const text0 = await driver.findComponent(ON.id('show'));
      let content0: string = await text0.getText();
      expect(content0).assertEqual('Successfully registered plugin');

      const button3 = await driver.findComponent(ON.id('button3'));
      await button3.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.id('button1'));
      await button5.click();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.id('show'));
      let content1: string = await text.getText();
      expect(content1).assertEqual('Domain account already exists');

      const button6 = await driver.findComponent(ON.id('button2'));
      await button6.click();
      await driver.delayMs(10000);
      let content2: string = await text.getText();
      expect(content2).assertEqual('Account creation information: "testAccountName"');

      const button7 = await driver.findComponent(ON.id('button3'));
      await button7.click();
      await driver.delayMs(10000);
      let content3: string = await text.getText();
      expect(content3).assertEqual('Successfully deleted account');

      const button8 = await driver.findComponent(ON.id('button4'));
      await button8.click();
      await driver.delayMs(1000);
      let content4: string = await text.getText();
      expect(content4).assertEqual('Queried account information: "testAccountName"');

      const button9 = await driver.findComponent(ON.id('button5'));
      await button9.click();
      await driver.delayMs(1000);

      const button10 = await driver.findComponent(ON.id('button1'));
      await button10.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.id('show'));
      let content5: string = await text1.getText();
      expect(content5).assertEqual('Successfully authenticated domain account using password');

      const button11 = await driver.findComponent(ON.id('button2'));
      await button11.click();
      await driver.delayMs(10000);
      let content6: string = await text1.getText();
      expect(content6).assertEqual('No domain account is bound');

      const button12 = await driver.findComponent(ON.id('button3'));
      await button12.click();
      await driver.delayMs(1000);

      const button13 = await driver.findComponent(ON.id('button2'));
      await button13.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.id('show'));
      let content7: string = await text2.getText();
      expect(content7).assertEqual('unregisterPlugin success');
      done();
      console.info("uitest: TestUiExample end");
    })
  })
}