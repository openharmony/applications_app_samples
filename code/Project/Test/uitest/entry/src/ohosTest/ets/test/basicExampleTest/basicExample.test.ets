/*
* Copyright (c) 2023-2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License")
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

import { describe, it, expect, TestType } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}
export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    /**
     * @tc.number:basicExampleTest_001
     * @tc.name: testUiExample
     * @tc.type: TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 验证UI操作点击指定按钮后，界面变化是否符合预期
     */
    it('testUiExample',0, async (done: Function) => {
      console.info("uitest: TestUiExample begin");
      //start tested ability
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      }
      await delegator.startAbility(want);
      await sleep(1000);
      //check top display ability
      await delegator.getCurrentTopAbility().then((Ability: UIAbility)=>{
        console.info("get top ability");
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      })
      //ui test code
      //init driver
      let driver = Driver.create();
      await driver.delayMs(1000);
      //find button on text 'Next'
      let button = await driver.findComponent(ON.text('Next'));
      //click button
      await button.click();
      await driver.delayMs(1000);
      //check text
      await driver.assertComponentExist(ON.text('after click'));
      await driver.pressBack();
      done();
    })
  })
}