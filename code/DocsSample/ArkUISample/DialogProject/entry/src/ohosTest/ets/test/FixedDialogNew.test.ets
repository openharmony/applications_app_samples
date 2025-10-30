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
import { abilityDelegatorRegistry, Driver, ON, MouseButton, Component, MatchPattern, UiDirection } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import resource from '../../../main/ets/common/resource';


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
const ONE_SECONDS_TIME = 1000;
// const TEN_SECONDS_TIME2 = 10000;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}


export default function NewFixDialogTest() {

  describe('NewFixDialogTest', () => {

    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number testShowActionMenu001
     * @tc.name testShowActionMenu001
     * @tc.desc Test Fixed-style pop-up box.
     * @tc.size MEDIUM
     * @tc.level Level 1
     * @tc.type Function
     */
    it('testShowActionMenu_001', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.FixedStyleDialog1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      await list.scrollToBottom(50);
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.ShowActionMenu_title')), MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list2 = await driver.findComponent(ON.text('ShowActionMenu', MatchPattern.CONTAINS));
      await button_list2.click();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    /**
     * @tc.number testFixedCustomDialog_002
     * @tc.name testFixedCustomDialog_002
     * @tc.desc Test Fixed-style pop-up box.
     * @tc.size MEDIUM
     * @tc.level Level 1
     * @tc.type Function
     */
    it('testFixedCustomDialog_002', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.FixedStyleDialog1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DatePickerCustom_title')), MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list2 = await driver.findComponent(ON.text('showDatePickerDialog', MatchPattern.CONTAINS));
      await button_list2.click();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    /**
     * @tc.number testFixedCustomDialog_002
     * @tc.name testFixedCustomDialog_002
     * @tc.desc Test Fixed-style pop-up box.
     * @tc.size MEDIUM
     * @tc.level Level 1
     * @tc.type Function
     */
    it('testFixedCustomDialog_textPieckerdlg_001', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.FixedStyleDialog1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.TextPicker_cn_title')), MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list2 = await driver.findComponent(ON.text('showTextPickerDialog', MatchPattern.CONTAINS));
      await button_list2.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })
  })
}