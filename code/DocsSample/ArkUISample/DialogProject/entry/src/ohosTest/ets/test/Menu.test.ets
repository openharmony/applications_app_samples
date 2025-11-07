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

export default function MenuTest() {

  describe('MenuTest', () => {

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
     * @tc.name testPopVibrateMenu
     * @tc.desc 测试菜单弹出时振动效果示例
     * @tc.level: Level 1
     */
    it('testPopVibrateMenu', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testPopVibrateMenu begin');
      let driver = Driver.create();
      let button_list =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Menu1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.PopVibrateMenu_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();
      await driver.delayMs(1000);

      let PopupOptionsButton = await driver.findComponent(ON.id('click for Menu', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testPopVibrateMenu end');
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testSupportAvoidCentralAxisMenu
     * @tc.desc 测试菜单支持避让中轴示例
     * @tc.level: Level 1
     */
    it('testSupportAvoidCentralAxisMenu', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSupportAvoidCentralAxisMenu begin');
      let driver = Driver.create();
      let button_list =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Menu1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.SupportAvoidCentralAxisMenu_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();
      await driver.delayMs(1000);

      let PopupOptionsButton = await driver.findComponent(ON.id('hoverMode_start', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testSupportAvoidCentralAxisMenu end');
      done();
    })

    /**
     * @tc.number UiTest_003
     * @tc.name testEventTransSubWindowMenu
     * @tc.desc 测试控制子窗菜单的事件透传示例
     * @tc.level: Level 1
     */
    it('testEventTransSubWindowMenu', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testEventTransSubWindowMenu begin');
      let driver = Driver.create();
      let button_list =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Menu1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.EventTransSubWindowMenu_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();
      await driver.delayMs(1000);

      let PopupOptionsButton = await driver.findComponent(ON.id('click', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testEventTransSubWindowMenu end');
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testBindComponentMenu
     * @tc.desc 测试基于绑定组件指定位置弹出菜单示例
     * @tc.level: Level 1
     */
    it('testBindComponentMenu', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testBindComponentMenu begin');
      let driver = Driver.create();
      let button_list =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Menu1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.BindComponentMenu_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testBindComponentMenu end');
      done();
    })

    /**
     * @tc.number UiTest_005
     * @tc.name testCreateDefaultMenu
     * @tc.desc 测试创建默认样式的菜单示例
     * @tc.level: Level 1
     */
    it('testCreateDefaultMenu', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCreateDefaultMenu begin');
      let driver = Driver.create();
      let button_list =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Menu1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 800, 100, 0);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CreateDefaultMenu_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();
      await driver.delayMs(1000);

      let PopupOptionsButton = await driver.findComponent(ON.id('click for Menu', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testCreateDefaultMenu end');
      done();
    })

    /**
     * @tc.number UiTest_006
     * @tc.name testBuilderCustomMenu
     * @tc.desc 测试使用@Builder自定义菜单内容示例
     * @tc.level: Level 1
     */
    it('testBuilderCustomMenu', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testBuilderCustomMenu begin');
      let driver = Driver.create();
      let button_list =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Menu1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 800, 100, 0);

      let TextButton =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.BuilderCustomMenu_title')),
          MatchPattern.CONTAINS));
      expect(TextButton === null).assertFalse();
      await TextButton.click();
      await driver.delayMs(1000);

      let PopupOptionsButton = await driver.findComponent(ON.id('click for Menu', MatchPattern.CONTAINS));
      expect(PopupOptionsButton === null).assertFalse();
      await PopupOptionsButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testBuilderCustomMenu end');
      done();
    })
  })
}