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
import { abilityDelegatorRegistry, Driver, ON, MouseButton, Component, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import resource from '../../../main/ets/common/resource';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function PopupTest() {

  describe('PopupTest', () => {

    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name testTextPrompts
     * @tc.desc 测试文本提示气泡示例
     * @tc.level: Level 1
     */
    it('testTextPrompts', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testTextPrompts begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Popup', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      let TextButton = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.TextPopup_title')),
        MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();
      // await driver.delayMs(1000);

      let PopupOptionsButton = await driver.findComponent(ON.id('PopupOptions', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testTextPrompts end');
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testPopupStateChange
     * @tc.desc 测试添加气泡状态变化的事件示例
     * @tc.level: Level 1
     */
    it('testPopupStateChange', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testPopupStateChange begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Popup', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.onStateChange_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();

      let PopupOptionsButton = await driver.findComponent(ON.id('PopupOptions', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testPopupStateChange end');
      done();
    })

    /**
     * @tc.number UiTest_003
     * @tc.name testButtonPopup
     * @tc.desc 测试带按钮的提示气泡示例
     * @tc.level: Level 1
     */
    it('testButtonPopup', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testButtonPopup begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Popup', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      let TextButton = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.button_popup')),
        MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();

      let PopupOptionsButton = await driver.findComponent(ON.id('PopupOptions', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      let buttonComponent = await driver.findComponent(ON.text('Confirm', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testButtonPopup end');
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testPopupAnimation
     * @tc.desc 测试气泡的动画示例
     * @tc.level: Level 1
     */
    it('testPopupAnimation', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testPopupAnimation begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Popup', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.AnimationPopup_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();

      let PopupOptionsButton = await driver.findComponent(ON.id('PopupOptions', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);

      let buttonComponent = await driver.findComponent(ON.id('CustomPopupOptions', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testPopupAnimation end');
      done();
    })

    /**
     * @tc.number UiTest_005
     * @tc.name testCustomPopup
     * @tc.desc 测试自定义气泡示例
     * @tc.level: Level 1
     */
    it('testCustomPopup', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCustomPopup begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Popup', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.custom_popup')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();

      let PopupOptionsButton = await driver.findComponent(ON.id('CustomPopupOptions', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testCustomPopup end');
      done();
    })

    /**
     * @tc.number UiTest_006
     * @tc.name testPopupStyle
     * @tc.desc 测试气泡样式示例
     * @tc.level: Level 1
     */
    it('testPopupStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testPopupStyle begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Popup', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.StylePopup_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();

      let PopupOptionsButton = await driver.findComponent(ON.id('PopupOptions', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testPopupStyle end');
      done();
    })

    /**
     * @tc.number UiTest_007
     * @tc.name testPopupAvoidSoftKeyboard
     * @tc.desc 测试气泡避让软键盘示例
     * @tc.level: Level 1
     */
    it('testPopupAvoidSoftKeyboard', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testPopupAvoidSoftKeyboard begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Popup', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 800, 100, 300);
      await driver.delayMs(1000);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.AvoidSoftKeyboardPopupExample_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();

      let PopupOptionsButton = await driver.findComponent(ON.id('PopupOptions', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testPopupAvoidSoftKeyboard end');
      done();
    })

    /**
     * @tc.number UiTest_008
     * @tc.name testPopupPolymorphicEffect
     * @tc.desc 测试设置气泡内的多态效果示例
     * @tc.level: Level 1
     */
    it('testPopupPolymorphicEffect', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testPopupPolymorphicEffect begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Popup', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 800, 100, 100);
      await driver.delayMs(1000);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.PolymorphicEffectPopupExample_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();

      let PopupOptionsButton = await driver.findComponent(ON.id('click me', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testPopupPolymorphicEffect end');
      done();
    })

    /**
     * @tc.number UiTest_009
     * @tc.name testPopupSupportedAvoidAxis
     * @tc.desc 测试气泡支持避让中轴示例
     * @tc.level: Level 1
     */
    it('testPopupSupportedAvoidAxis', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testPopupSupportedAvoidAxis begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Popup', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 800, 100, 0);
      await driver.delayMs(1000);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.SupportedAvoidAxisPopupExample_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();

      let PopupOptionsButton = await driver.findComponent(ON.id('Popup', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testPopupSupportedAvoidAxis end');
      done();
    })
  })
}