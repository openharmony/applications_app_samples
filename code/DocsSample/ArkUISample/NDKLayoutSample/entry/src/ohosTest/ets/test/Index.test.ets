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

const TAG = '[NDKLayoutSample]';
const DOMAIN = 0xF811;
const BUNDLE = 'NDKLayoutSample_';
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
     * @tc.number testLayout_001
     * @tc.name testLayout_001
     * @tc.desc Test show and hide native layout attribute examples.
     * @tc.size MEDIUM
     * @tc.level Level 1
     * @tc.type Function
     */
    it('testLayout_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'testLayout_001, start');
      let driver = Driver.create();

      let showButton = await driver.findComponent(ON.text('显示Native布局', MatchPattern.CONTAINS));
      expect(showButton === null).assertFalse();

      let toggleButton = await driver.findComponent(ON.id('btn', MatchPattern.CONTAINS));
      expect(toggleButton === null).assertFalse();
      await toggleButton.click();
      await sleep(ONE_SECONDS_TIME);

      let sizeSection = await driver.findComponent(ON.text('尺寸与宽高比', MatchPattern.CONTAINS));
      expect(sizeSection === null).assertFalse();
      let sizeItem = await driver.findComponent(ON.text('width=30%', MatchPattern.CONTAINS));
      expect(sizeItem === null).assertFalse();

      let hideButton = await driver.findComponent(ON.text('隐藏Native布局', MatchPattern.CONTAINS));
      expect(hideButton === null).assertFalse();
      toggleButton = await driver.findComponent(ON.id('btn', MatchPattern.CONTAINS));
      expect(toggleButton === null).assertFalse();
      await toggleButton.click();
      await sleep(ONE_SECONDS_TIME);

      sizeSection = await driver.findComponent(ON.text('尺寸与宽高比', MatchPattern.CONTAINS));
      expect(sizeSection === null).assertTrue();

      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'testLayout_001, end');
      done();
    })
  })
}
