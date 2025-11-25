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
async function getResourceString(resource: string): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let text = await manage.getStringByName(resource);
  return text;
}
export default function ParentTest() {
  describe('IndextTest', () => {
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
     * @tc.number Interaction_0100
     * @tc.name testInteraction
     * @tc.desc 热区验证
     */
    it('Interaction_0100', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text(await getResourceString('FocusOnclick'), MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text(await getResourceString('FocusOnclickExample'), MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text(await getResourceString('button'), MatchPattern.CONTAINS));
      await button2.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number AnimatableExtendTest_001
     * @tc.name testAnimatableExtend
     * @tc.desc 测试AnimatableExtend装饰器是否显示正常
     */
    it('Interaction_0200', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text(await getResourceString('PreventBubbling'), MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text(await getResourceString('PreventBubblingExample'), MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text(await getResourceString('preventEvent'), MatchPattern.CONTAINS));
      await button2.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number Interaction_0300
     * @tc.name testInteraction
     * @tc.desc 测试AnimatableExtend装饰器是否显示正常
     */
    it('Interaction_0300', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text(await getResourceString('sampling'), MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text(await getResourceString('samplingExample'), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number Interaction_0400
     * @tc.name testInteraction
     * @tc.desc 测试AnimatableExtend装饰器是否显示正常
     */
    it('Interaction_0400', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text(await getResourceString('MultipleFingerInformation'), MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text(await getResourceString('MultipleFingerInformationExample'), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number Interaction_0500
     * @tc.name testInteraction
     * @tc.desc 测试AnimatableExtend装饰器是否显示正常
     */
    it('Interaction_0500', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text(await getResourceString('mouseMove'), MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text(await getResourceString('mouseMoveExample'), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number Interaction_0600
     * @tc.name testInteraction
     * @tc.desc 测试AnimatableExtend装饰器是否显示正常
     */
    it('Interaction_0600', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text(await getResourceString('stopPropagation'), MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text(await getResourceString('stopPropagationExample'), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number Interaction_0700
     * @tc.name testInteraction
     * @tc.desc 测试AnimatableExtend装饰器是否显示正常
     */
    it('Interaction_0700', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text(await getResourceString('onHover'), MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text(await getResourceString('onHoverExample'), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number Interaction_0800
     * @tc.name testInteraction
     * @tc.desc 测试AnimatableExtend装饰器是否显示正常
     */
    it('Interaction_0800', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text(await getResourceString('MouseButton'), MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text(await getResourceString('MouseButtonExample'), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number Interaction_0900
     * @tc.name testInteraction
     * @tc.desc 测试AnimatableExtend装饰器是否显示正常
     */
    it('Interaction_0900', 0, async (done: Function) => {
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text(await getResourceString('MouseWheel'), MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text(await getResourceString('MouseWheelExample'), MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })
  })
}