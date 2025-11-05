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
      let button = await driver.findComponent(ON.text('热区', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('热区范围', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('按钮', MatchPattern.CONTAINS));
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
      let button = await driver.findComponent(ON.text('阻止冒泡', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('阻止冒泡事件', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('如果点中了我，就阻止父组件收到触摸事件', MatchPattern.CONTAINS));
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
      let button = await driver.findComponent(ON.text('采样和历史点', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('采样和历史点事件', MatchPattern.CONTAINS));
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
      let button = await driver.findComponent(ON.text('多指信息', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('多指信息事件', MatchPattern.CONTAINS));
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
      let button = await driver.findComponent(ON.text('鼠标移动', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('鼠标移动事件', MatchPattern.CONTAINS));
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
      let button = await driver.findComponent(ON.text('阻止鼠标冒泡', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('阻止鼠标冒泡事件', MatchPattern.CONTAINS));
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
      let button = await driver.findComponent(ON.text('鼠标移入移出', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('鼠标移入移出事件', MatchPattern.CONTAINS));
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
      let button = await driver.findComponent(ON.text('鼠标按键', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('鼠标按键事件', MatchPattern.CONTAINS));
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
      let button = await driver.findComponent(ON.text('鼠标滚轮', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('鼠标滚轮事件', MatchPattern.CONTAINS));
      await button1.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
    })
  })
}