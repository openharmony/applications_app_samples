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
import hilog from '@ohos.hilog';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const TAG = '[Sample_CustomComponentsMixingUse]';
const DOMAIN = 0xF811;
const BUNDLE = 'MyCustomComponentsMixingUse_';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number MixingUseofCustomComponentsTest_001
     * @tc.name testMixingUseofCustomComponents
     * @tc.desc 测试自定义组件混用显示是否正常
     */
    it('MixingUseofCustomComponentsTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'MixingUseofCustomComponentsTest_001 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('MixingUseofCustomComponents', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('ObserveNestedClasses_ObservedAndObjectLink', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      let button3 = await driver.findComponent(ON.text('ObserveNestedClasses_ObsevedV2AndTrace', MatchPattern.CONTAINS));
      await button3.click();
      await driver.pressBack();
      let button4 = await driver.findComponent(ON.text('V1CommonVariablesToV2CustomComponent', MatchPattern.CONTAINS));
      await button4.click();
      await driver.pressBack();
      let button5 = await driver.findComponent(ON.text('V1InV2', MatchPattern.CONTAINS));
      await button5.click();
      await driver.pressBack();
      let button6 = await driver.findComponent(ON.text('V1StateVariablesToV2CustomComponent', MatchPattern.CONTAINS));
      await button6.click();
      await driver.pressBack();
      let button7 = await driver.findComponent(ON.text('V2CommonVariablesToV1CustomComponent', MatchPattern.CONTAINS));
      await button7.click();
      await driver.pressBack();
      let button8 = await driver.findComponent(ON.text('V2InV1', MatchPattern.CONTAINS));
      await button8.click();
      await driver.pressBack();
      let button9 = await driver.findComponent(ON.text('V2StateVariablesToV1CustomComponent', MatchPattern.CONTAINS));
      await button9.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'MixingUseofCustomComponentsTest_001 end');
      done();
    })
  })
}