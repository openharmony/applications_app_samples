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

import { describe, beforeAll, it, expect, Level, Size, TestType } from '@ohos/hypium'
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MouseButton, Component, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;

const TAG = '[Sample_SupportingAgingFriendly]';
const DOMAIN = 0xF811;
const BUNDLE = 'SupportingAgingFriendly_';

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
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number: SideBarContainerTest_001
     * @tc.name: SideBarContainer component
     * @tc.desc: Test sideBarContainer component triggers senior-friendly
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('SideBarContainerTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SideBarContainerTest_001, begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('SideBarContainer', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'SideBarContainerTest_001, end');
      done();
    })

    /**
     * @tc.number: TextPickerDialogTest_001
     * @tc.name: TextPickerDialog component
     * @tc.desc: Test textPickerDialog component triggers senior-friendly
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('TextPickerDialogTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TextPickerDialogTest_001, begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('TextPickerDialog', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'TextPickerDialogTest_001, end');
      done();
    })
  })
}