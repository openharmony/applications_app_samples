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

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function ParentTest() {
  describe('ParentTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number AnimatableExtendTest_001
     * @tc.name testAnimatableExtend
     * @tc.desc 测试AnimatableExtend装饰器是否显示正常
     */
    it('Parent_001', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('生命周期', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('自定义组件生命周期', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Hello World', MatchPattern.CONTAINS));
      await button2.click();
      let button3 = await driver.findComponent(ON.text('delete Child', MatchPattern.CONTAINS));
      await button3.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })
  })
}