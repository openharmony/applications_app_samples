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
import { beforeAll, describe, expect, it } from "@ohos/hypium";
import { abilityDelegatorRegistry, Driver, MatchPattern, ON } from "@kit.TestKit";
import { UIAbility, Want } from "@kit.AbilityKit";

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;



export default function IndexTest(){
  describe('IndexTest', () => {

    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(2000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })
    /*
     * @tc.number: Clip_shape_Index_Start_001
     * @tc.name: example_one_BindSheet
     * @tc.desc: example_one_BindSheet
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it("Clip_shape_Index_Start_001", 0, async (done: Function) => {
      try {
        const want: Want = {
          bundleName: bundleName,
          abilityName: 'IndexAbility'
        };

        // 启动 IndexAbility
        await delegator.startAbility(want);
        await sleep(2000);

        const ability: UIAbility = await delegator.getCurrentTopAbility();
        expect(ability.context.abilityInfo.name).assertEqual('IndexAbility');

        done();
      } catch (error) {
        console.error("Index test failed:", error);
        done();
      }
    });
    /*
     * @tc.number: Clip_shape_Index_Click_002
     * @tc.name: example_one_clipShape
     * @tc.desc: example_one_clipShape
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Clip_shape_Index_Click_002', 0, async (done: Function) => {
      let driver = Driver.create();
      let sampleButton = await driver.findComponent(ON.id('text1_title1', MatchPattern.CONTAINS));
      expect(sampleButton !== null).assertTrue();
      await sampleButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      done();
    });
    /*
    * @tc.number: Clip_shape_Index_Click_003
    * @tc.name: example_two_clipShape
    * @tc.desc: example_two_clipShape
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('Clip_shape_Index_Click_003', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.id('text1_title2', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /*
    * @tc.number: Clip_shape_Index_Click_004
    * @tc.name: example_three_clipShape
    * @tc.desc: example_three_clipShape
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('Clip_shape_Index_Click_004', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.id('text1_title3', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
    /*
    * @tc.number: Clip_shape_Index_Click_005
    * @tc.name: example_four_clipShape
    * @tc.desc: example_four_clipShape
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('Clip_shape_Index_Click_005', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.id('text1_title4', MatchPattern.CONTAINS));
      expect(button_list !== null).assertTrue();
      await button_list.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    });
  })
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
