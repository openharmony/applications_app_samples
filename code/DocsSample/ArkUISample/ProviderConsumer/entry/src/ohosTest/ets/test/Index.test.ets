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
import { abilityDelegatorRegistry, Driver, ON, MouseButton, MatchPattern, UiDirection, On } from '@kit.TestKit';
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
  describe('IndexTest', () => {
    beforeAll(async (done: Function) => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
    })

    /**
     * @tc.number UiTest_001
     * @tc.name testTwowayBinding
     * @tc.desc 点击建立双向绑定
     */
    it('testTwowayBinding', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.Twoway_Binding'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click()
      await driver.delayMs(1000)
      await driver.pressBack();
      done();
    })
    /**
     * @tc.number UiTest_001
     * @tc.name testNoTwowayBinding
     * @tc.desc 点击未建立双向绑定
     */
    it('testNoTwowayBinding', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.No_Twoway_Binding'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click()
      await driver.delayMs(1000)
      await driver.pressBack();
      done();
    })
    /**
     * @tc.number UiTest_001
     * @tc.name testDecorativeArray
     * @tc.desc 点击装饰Array类型变量
     */
    it('testDecorativeArray', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.Decorative_Array'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click()
      await driver.delayMs(1000)
      await driver.pressBack();
      done();
    })
    /**
     * @tc.number UiTest_001
     * @tc.name testDecorativeDate
     * @tc.desc 点击装饰Date类型变量
     */
    it('testDecorativeDate', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.Decorative_Date'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click()
      await driver.delayMs(1000)
      await driver.pressBack();
      done();
    })
    /**
     * @tc.number UiTest_001
     * @tc.name testDecorativeMap
     * @tc.desc 点击装饰Map类型变量
     */
    it('testDecorativeMap', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.Decorative_Map'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click()
      await driver.delayMs(1000)
      await driver.pressBack();
      done();
    })
    /**
     * @tc.number UiTest_001
     * @tc.name testDecorativeSet
     * @tc.desc 点击装饰Set类型变量
     */
    it('testDecorativeSet', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.Decorative_Set'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click()
      await driver.delayMs(1000)
      await driver.pressBack();
      done();
    })
    /**
     * @tc.number UiTest_001
     * @tc.name testDragDrop
     * @tc.desc 点击在拖拽场景中
     */
    it('testDragDrop', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.Drag_Drop'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click()
      await driver.delayMs(1000)
      await driver.pressBack();
      done();
    })
    /**
     * @tc.number UiTest_001
     * @tc.name testDecorativeComplex
     * @tc.desc 点击装饰复杂类型变量
     */
    it('testDecorativeComplex', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.Decorative_Complex'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click()
      await driver.delayMs(1000)
      await driver.pressBack();
      done();
    })
  })
}