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

import { describe, it, expect, beforeAll, TestType, Level, Size,  } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import resource from '../../../main/ets/common/resource';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
const BUNDLE = 'Watch_';
const TAG = '[Sample_Watch]';
const DOMAIN = 0xF811;

export default function abilityTest() {
  describe('abilityTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /*
      * @tc.number: Watch_AbilityTest_001
      * @tc.name: Watch_AbilityTest_001
      * @tc.desc: Set watch
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'AbilityTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Watch_AbilityTest_001_begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.watch_text1'))));
      await button1.click();
      await driver.delayMs(1000);

      let button2 = await driver.findComponent(ON.text('add to basket'));
      await button2.click();
      await driver.delayMs(500);
      await button2.click();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'Watch_AbilityTest_001_end');
    })

    /*
      * @tc.number: Watch_AbilityTest_002
      * @tc.name: Watch_AbilityTest_002
      * @tc.desc: Set watch
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'AbilityTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Watch_AbilityTest_002_begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.watch_text2')), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(1000);

      let button2 = await driver.findComponent(ON.text('Add to basket'));
      await button2.click();
      await driver.delayMs(500);
      await button2.click();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'Watch_AbilityTest_002_end');
    })

    /*
      * @tc.number: Watch_AbilityTest_003
      * @tc.name: Watch_AbilityTest_003
      * @tc.desc: Set watch
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'AbilityTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Watch_AbilityTest_003_begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.watch_text3')), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(1000);

      let button2 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.watch_text9'))));
      await button2.click();
      await driver.delayMs(500);
      await button2.click();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'Watch_AbilityTest_003_end');
    })

    /*
      * @tc.number: Watch_AbilityTest_004
      * @tc.name: Watch_AbilityTest_004
      * @tc.desc: Set watch
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'AbilityTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Watch_AbilityTest_004_begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.watch_text4')), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(1000);

      let button2 = await driver.findComponent(ON.text('Add apples'));
      await button2.click();
      await driver.delayMs(500);
      await button2.click();
      await driver.delayMs(500);

      let button3 = await driver.findComponent(ON.text('Add cabbages'));
      await button3.click();
      await driver.delayMs(500);
      await button3.click();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'Watch_AbilityTest_004_end');
    })
  })
}