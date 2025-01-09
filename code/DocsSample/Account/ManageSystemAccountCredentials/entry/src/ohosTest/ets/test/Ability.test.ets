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

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}
export default function abilityTest() {
  describe('AccountCredentialsAbilityTest', () => {

     /*
     * 打开应用，依次点击页面中按钮
     * 使用系统凭证账号接口功能
     */
    it('accountCredentialsExample',0, async (done: Function) => {
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

      const button1 = await driver.findComponent(ON.id('button1'));
      await button1.click();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.id('show'));
      let content1: string = await text.getText();
      expect(content1).assertEqual('PIN code entry successful');

      const button2 = await driver.findComponent(ON.id('button2'));
      await button2.click();
      await driver.delayMs(1000);
      let content2: string = await text.getText();
      expect(content2).assertEqual('PIN code entry successful');

      const button3 = await driver.findComponent(ON.id('button5'));
      await button3.click();
      await driver.delayMs(5000);
      let content3: string = await text.getText();
      expect(content3).assertEqual('Successfully updated PIN code credentials');

      const button4 = await driver.findComponent(ON.id('button6'));
      await button4.click();
      await driver.delayMs(1000);
      let content4: string = await text.getText();
      expect(content4).assertEqual('Query information length:1');

      const button5 = await driver.findComponent(ON.id('button7'));
      await button5.click();
      await driver.delayMs(3000);
      let content5: string = await text.getText();
      expect(content5).assertEqual('Successfully deleted PIN code credentials');
      done();
      console.info("uitest: TestUiExample end");
    })
  })
}