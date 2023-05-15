/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
import EntryAbility from '../../../../main/ets/entryability/EntryAbility'
const delegator = abilityDelegatorRegistry.getAbilityDelegator()
export default function customExampleTest() {
  describe('customExampleTest', function () {

    /**
     * @tc.number:customExampleTest_001
     * @tc.name: customExampleTest_function
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测EntryAbility对象自定义function功能
     */
    it('customExampleTest_function',TestType.FUNCTION, async function (done) {
      console.info("uitest: TestUiExample begin");
      // start tested ability
      let want = {
        bundleName : bundleName,
        abilityName : "EntryAbility"
      }
      await delegator.startAbility(want)
      await sleep(1000);
      // check top display ability
      await delegator.getCurrentTopAbility().then((ability: EntryAbility)=>{
        console.info("get top ability");
        expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
        let result = ability.customFun();
        // 验证自定义方法返回值
        expect(result).assertEqual("custom")
      })
      done();
    })

    function sleep(time) {
      return new Promise((resolve) => setTimeout(resolve, time));
    }
  })
}