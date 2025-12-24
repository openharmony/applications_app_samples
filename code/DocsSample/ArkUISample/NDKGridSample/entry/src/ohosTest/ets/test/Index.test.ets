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
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;

const TAG = '[NdkGridSample]';
const DOMAIN = 0xF811;
const BUNDLE = 'NdkAddInteractionEvent_';
const ONE_SECONDS_TIME = 1000;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
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
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number testGrid
     * @tc.name testGrid_001
     * @tc.desc Test GridWithFixedColumnsAndRows.
     * @tc.size MEDIUM
     * @tc.level Level 1
     * @tc.type Function
     */
    it('testGrid_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'testGrid_001, start');
      let driver = Driver.create();
      let str = 'GridWithFixedColumnsAndRows';
      let button_list = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let fixedGrid = await driver.findComponent(ON.type('Grid'));
      expect(fixedGrid === null).assertFalse();
      let isScrollable = await fixedGrid.isScrollable();
      expect(isScrollable).assertFalse();

      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'testGrid_001, end');
      done();
    })

    /**
     * @tc.number testGrid
     * @tc.name testGrid_002
     * @tc.desc Test ScrollableGrid.
     * @tc.size MEDIUM
     * @tc.level Level 1
     * @tc.type Function
     */
    it('testGrid_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'testGrid_002, start');
      let driver = Driver.create();
      let str = 'ScrollableGrid';
      let button_list = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let scrollableGrid = await driver.findComponent(ON.type('Grid'));
      expect(scrollableGrid === null).assertFalse();
      let isScrollable = await scrollableGrid.isScrollable();
      expect(isScrollable).assertTrue();
      await driver.pressBack();

      hilog.info(DOMAIN, TAG, 'testGrid_002, end');
      done();
    })
  })
}