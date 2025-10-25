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
import { abilityDelegatorRegistry, Driver, ON, MouseButton, Component, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import resource from '../../../main/ets/common/resource';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function IndexTest() {

  describe('IndexTest', () => {

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
     * @tc.number UiTest_001
     * @tc.name testSingleGestureTap
     * @tc.desc 测试点击手势示例
     */
    it('testSingleGestureTap', 0, async (done: Function) => {
      console.info('uitest: testSingleGestureTap begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('gesture', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.singlegesture_Index_TapGesture_title')), MatchPattern.CONTAINS));
      await button_list1.click();
      //已进入测试界面
      let button2 = await driver.findComponent(ON.text('twice', MatchPattern.CONTAINS));
      await button2.doubleClick();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSingleGestureTap end');
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testSingleGestureLong
     * @tc.desc 测试长按手势示例
     */
    it('testSingleGestureLong', 0, async (done: Function) => {
      console.info('uitest: testSingleGestureLong begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('gesture', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.singlegesture_Index_LongPress_title')), MatchPattern.CONTAINS));
      await button_list1.click();
      //已进入测试界面
      let button2 = await driver.findComponent(ON.text('Long', MatchPattern.CONTAINS));
      await button2.longClick();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSingleGestureLong end');
      done();
    })

    /**
     * @tc.number UiTest_003
     * @tc.name testSingleGestureJudge
     * @tc.desc 测试手势拦截示例
     */
    it('testSingleGestureJudge', 0, async (done: Function) => {
      console.info('uitest: testSingleGestureJudge begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('GestureJudge', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.gesture_Index_GestureJudge_title')), MatchPattern.CONTAINS));
      await button_list1.click();
      //已进入测试界面
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: testSingleGestureJudge end');
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testSingleGestureTouch
     * @tc.desc 测试点击事件示例
     */
    it('testSingleGestureTouch', 0, async (done: Function) => {
      console.info('uitest: testSingleGestureTouch begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('TouchEvent', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Touch_Index_ClickEvent_title')), MatchPattern.CONTAINS));
      await button_list1.click();
      //已进入测试界面
      let button = await driver.findComponent(ON.text('show', MatchPattern.CONTAINS));
      await button.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSingleGestureTouch end');
      done();
    })


  })
}