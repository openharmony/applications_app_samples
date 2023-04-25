/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
const delegator = abilityDelegatorRegistry.getAbilityDelegator()
const TAG = '[basicExampleTest]'
const DOMAIN = 0xF811
const BUNDLE = 'basic_'
export default function basicExampleTest() {
  describe('basicExampleTest', function () {

    /**
     * @tc.number:basicExampleTest_001
     * @tc.name: testUiExample
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测 uitest click 功能
     */
    it('testUiExample',0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + "001, begin")
      //start tested ability
      await delegator.executeShellCommand('aa start -b com.samples.uitest -a EntryAbility').then(result =>{
        console.info('Uitest, start ability finished:' + result)
      }).catch(err => {
        console.info('Uitest, start ability failed: ' + err)
      })
      await sleep(1000);
      // check top display ability
      await delegator.getCurrentTopAbility().then((Ability)=>{
        console.info("get top ability");
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      })
      // ui test code
      // init driver
      let  driver = await Driver.create();
      await driver.delayMs(1000);
      // find button on text 'Next'
      var button = await driver.findComponent(ON.text('Next'));
      expect(button !== null).assertTrue();
      // click button
      await button.click();
      await driver.delayMs(1000);
      // check text
      await driver.assertComponentExist(ON.text('after click'));
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + "001, end")
      done();
    })
    function sleep(time) {
      return new Promise((resolve) => setTimeout(resolve, time));
    }
  })
}