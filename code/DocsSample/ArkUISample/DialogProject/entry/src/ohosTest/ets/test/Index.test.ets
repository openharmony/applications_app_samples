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
import { abilityDelegatorRegistry, Driver, ON, MouseButton, Component, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import resource from '../../../main/ets/common/resource';


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}


export default function IndexTest() {

  describe('IndexTest', () => {

    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    it('testOpenCustomDialog', 0, async (done: Function) => {
      console.info("uitest: testOpenCustomDialog begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('openCustomDialog', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text('UI', MatchPattern.CONTAINS));
      await button_list1.click();
      let button1 = await driver.findComponent(ON.id('open'));
      await button1.click();

      let button2 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.change_dialog')), MatchPattern.CONTAINS));
      await button2.click();
      await sleep(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testCustomDialog', 0, async (done: Function) => {
      console.info("uitest: testCustomDialog begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog_nest')), MatchPattern.CONTAINS));
      await button_list1.click();

      let button_list2 = await driver.findComponent(ON.text('Click', MatchPattern.CONTAINS));
      await button_list2.click();
      let button_list3 = await driver.findComponent(ON.text('confirm', MatchPattern.CONTAINS));
      await button_list3.click();
      let button_list4 = await driver.findComponent(ON.text('close', MatchPattern.CONTAINS));
      await button_list4.click();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(1000);
      done();
    })

    it('testFixedCustomDialog', 0, async (done: Function) => {
      console.info("uitest: testFixedCustomDialog begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.FixedStyleDialog1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DatePicker_title')), MatchPattern.CONTAINS));
      await button_list1.click();

      let button_list2 = await driver.findComponent(ON.text('showDate', MatchPattern.CONTAINS));
      await button_list2.click();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(1000);
      done();
    })

    it('testMenu', 0, async (done: Function) => {
      console.info("uitest: testMenu begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Menu1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CreateMenu_title')), MatchPattern.CONTAINS));
      await button_list1.click();

      let button_list2 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.menu_bind')), MatchPattern.CONTAINS));
      await button_list2.click();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(1000);
      done();
    })

    it('testToast', 0, async (done: Function) => {
      console.info("uitest: testToast begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Toast1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.OpenCloseToast_title')), MatchPattern.CONTAINS));
      await button_list1.click();

      let button1 = await driver.findComponent(ON.text('Open', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Close', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(1000);
      done();
    })


  })
}