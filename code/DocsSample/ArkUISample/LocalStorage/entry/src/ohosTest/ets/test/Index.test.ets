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
      await driver.pressBack();
      console.info('uitest: PageFiveTest end');
      done();
    })

    /**
     * @tc.number PageSixTest
     * @tc.name PageSixTest
     * @tc.desc 测试PageSix是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageSixTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageSixTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageSix', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageSixTest end');
      done();
    })

    /**
     * @tc.number PageSevenTest
     * @tc.name PageSevenTest
     * @tc.desc 测试PageSeven是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageSevenTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageSevenTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageSeven', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageSevenTest end');
      done();
    })

    /**
     * @tc.number PageEightTest
     * @tc.name PageEightTest
     * @tc.desc 测试PageEight是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageEightTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageEightTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageEight', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageEightTest end');
      done();
    })

    /**
     * @tc.number PageNineTest
     * @tc.name PageNineTest
     * @tc.desc 测试PageNine是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageNineTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageNineTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageNine', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageNineTest end');
      done();
    })

    /**
     * @tc.number PageTenTest
     * @tc.name PageTenTest
     * @tc.desc 测试PageTen是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageTenTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageTenTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageTen', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageTenTest end');
      done();
    })

    /**
     * @tc.number PageTwelveTest
     * @tc.name PageTwelveTest
     * @tc.desc 测试PageTwelve是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageTwelveTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageTwelveTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageTwelve', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      let button2 = await driver.findComponent(ON.text('set new one', MatchPattern.CONTAINS));
      expect(button2 === null).assertFalse();
      await button2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageTwelveTest end');
      done();
    })

    /**
     * @tc.number PageThirteenTest
     * @tc.name PageThirteenTest
     * @tc.desc 测试PageThirteen是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageThirteenTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageThirteenTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageThirteen', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      let button2 = await driver.findComponent(ON.text('init map', MatchPattern.CONTAINS));
      expect(button2 === null).assertFalse();
      await button2.click();
      await driver.delayMs(1000);
      let button3 = await driver.findComponent(ON.text('set new one', MatchPattern.CONTAINS));
      expect(button3 === null).assertFalse();
      await button3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageThirteenTest end');
      done();
    })

    /**
     * @tc.number PageFourteenTest
     * @tc.name PageThirteenTest
     * @tc.desc 测试PageThirteen是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageFourteenTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageFourteenTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageFourteen', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      let button2 = await driver.findComponent(ON.text('increase the year by 1', MatchPattern.CONTAINS));
      expect(button2 === null).assertFalse();
      await button2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageFourteenTest end');
      done();
    })

    /**
     * @tc.number PageFifteenTest
     * @tc.name PageFifteenTest
     * @tc.desc 测试PageFifteen是否显示正常
     * @tc.level : Level1
     * @tc.size : MediumTest
     * @tc.type : Function
     */
    it('PageFifteenTest', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      console.info('uitest: PageThirteenTest begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('PageFifteen', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageFifteenTest end');
      done();
    })

  })
}