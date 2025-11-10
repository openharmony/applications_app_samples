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
import { abilityDelegatorRegistry, Driver, ON, MatchPattern, UiDirection } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import resource from '../../../main/ets/common/resource';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
const ONE_SECONDS_TIME = 1000;
const SCROLL_DISTANCE = 7000;
const TEN_SECONDS_TIME = 10000;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function DialogFocusStrategyTest() {

  describe('DialogFocusStrategyTest', () => {

    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(0xff00, 'index', 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    it('testDialogFocusStrategy', 0,
      async (done: Function) => {
        hilog.info(0xff00, 'index', 'uitest: testDialogFocusStrategy begin');
        let driver = Driver.create();
        let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
          MatchPattern.CONTAINS));
        expect(button_list === null).assertFalse();
        await button_list.click();
        let list = await driver.findComponent(ON.type('List'));
        expect(list === null).assertFalse();
        await list.scrollToBottom(SCROLL_DISTANCE);
        let button_list1 =
          await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog_focus')),
            MatchPattern.CONTAINS));
        await button_list1.click();
        await sleep(ONE_SECONDS_TIME);
        await driver.pressBack();
        await driver.pressBack();
        await sleep(ONE_SECONDS_TIME);
        done();
      })

    it('testGlobalOpenPopup', 0, async (done: Function) => {
      hilog.info(0xff00, 'index', 'uitest: testGlobalOpenPopup begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Popup1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      await list.scrollToBottom(SCROLL_DISTANCE);
      let button_list1 =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.StylePopup_global')),
          MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list2 = await driver.findComponent(ON.text('openPopup', MatchPattern.CONTAINS));
      await button_list2.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list3 = await driver.findComponent(ON.text('Update', MatchPattern.CONTAINS));
      await button_list3.click();
      let button_list4 = await driver.findComponent(ON.text('Close', MatchPattern.CONTAINS));
      await button_list4.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    it('testDialogController', 0, async (done: Function) => {
      hilog.info(0xff00, 'index', 'uitest: testDialogController begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      await list.scrollToBottom(SCROLL_DISTANCE);
      let button_list1 =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog_controller')),
          MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    it('testPageLevelDialog', 0, async (done: Function) => {
      hilog.info(0xff00, 'index', 'uitest: testPageLevelDialog begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.fling(UiDirection.DOWN, TEN_SECONDS_TIME);
      let button_list1 =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog_page_level')),
          MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    it('testGlobalOpenMenu', 0, async (done: Function) => {
      hilog.info(0xff00, 'index', 'uitest: testGlobalOpenMenu begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Menu1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list1 =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.OpenMenu_title')),
          MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    it('testDialogBoxLayer', 0, async (done: Function) => {
      hilog.info(0xff00, 'index', 'uitest: testDialogBoxLayer begin');
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.fling(UiDirection.DOWN, TEN_SECONDS_TIME);
      let button_list1 =
        await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog_box_layer')),
          MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

  })
}