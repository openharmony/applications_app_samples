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
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number PageOneTest
     * @tc.name PageOneTest
     * @tc.desc 测试PageOne是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageOneTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageOneTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageOne', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageOneTest end');
      done();
    })

    /**
     * @tc.number PageTwoTest
     * @tc.name PageTwoTest
     * @tc.desc 测试PageTwo是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageTwoTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageOneTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageTwo', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageTwo end');
      done();
    })

    /**
     * @tc.number PageThreeTest
     * @tc.name PageThreeTest
     * @tc.desc 测试PageThree是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageThreeTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageThreeTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageThree', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageThreeTest end');
      done();
    })

    /**
     * @tc.number PageFourTest
     * @tc.name PageFourTest
     * @tc.desc 测试PageFour是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageFourTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageOneTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageFour', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      let button2 = await driver.findComponent(ON.text('Click me', MatchPattern.CONTAINS));
      expect(button2 === null).assertFalse();
      await button2.click();
      await driver.pressBack();
      console.info('uitest: PageFourTest end');
      done();
    })

    /**
     * @tc.number PageFiveTest
     * @tc.name PageFiveTest
     * @tc.desc 测试PageFive是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageFiveTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageFiveTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageFive', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageFiveTest end');
      done();
    })

    /**
     * @tc.number PageComponentV2Test
     * @tc.name PageComponentV2Test
     * @tc.desc 测试PageComponentV2是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageComponentV2Test', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageComponentV2Test begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageComponentV2', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageComponentV2Test end');
      done();
    })
  })
}