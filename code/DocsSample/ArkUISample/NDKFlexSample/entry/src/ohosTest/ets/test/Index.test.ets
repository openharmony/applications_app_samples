/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

const TAG = '[NDKFlexSample]';
const DOMAIN = 0xF811;
const BUNDLE = 'NDKFlexSample_';
const ONE_SECONDS_TIME = 1000;

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
      await sleep(ONE_SECONDS_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number testFlex_001
     * @tc.name testFlex_001
     * @tc.desc Test show and hide native flex layout.
     * @tc.size MEDIUM
     * @tc.level Level 1
     * @tc.type Function
     */
    it('testFlex_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'testFlex_001, start');
      let driver = Driver.create();

      let showButton = await driver.findComponent(ON.text('显示Native布局', MatchPattern.CONTAINS));
      expect(showButton === null).assertFalse();

      let toggleButton = await driver.findComponent(ON.id('btn', MatchPattern.CONTAINS));
      expect(toggleButton === null).assertFalse();
      await toggleButton.click();
      await sleep(ONE_SECONDS_TIME);

      let pageHeader = await driver.findComponent(ON.text('Flex / Row / Column', MatchPattern.CONTAINS));
      expect(pageHeader === null).assertFalse();
      let rowItem = await driver.findComponent(ON.text('Row 1', MatchPattern.CONTAINS));
      expect(rowItem === null).assertFalse();

      let hideButton = await driver.findComponent(ON.text('隐藏Native布局', MatchPattern.CONTAINS));
      expect(hideButton === null).assertFalse();
      toggleButton = await driver.findComponent(ON.id('btn', MatchPattern.CONTAINS));
      expect(toggleButton === null).assertFalse();
      await toggleButton.click();
      await sleep(ONE_SECONDS_TIME);

      pageHeader = await driver.findComponent(ON.text('Flex / Row / Column', MatchPattern.CONTAINS));
      expect(pageHeader === null).assertTrue();

      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'testFlex_001, end');
      done();
    })
  })
}
