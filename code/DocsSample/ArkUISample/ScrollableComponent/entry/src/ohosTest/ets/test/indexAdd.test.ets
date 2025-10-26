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

import { describe, it, expect, beforeAll, Level } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MouseButton,MatchPattern, UiDirection } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { Point } from '@ohos.UiTest';


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function IndexTest() {
  describe('IndexTestAdd', () => {
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
    /**要
     * @tc.number UiTest_001
     * @tc.name SlidingHandEvent
     * @tc.desc 支持滑动离手事件
     */
    it('SlidingHandEvent', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      await list.scrollToBottom(1000);
      let str = await getResourceString($r('app.string.Sliding_Hand_Event'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click()
      await driver.delayMs(1000)
      await driver.pressBack();
      await driver.pressBack();
      done();
    })
  })
}