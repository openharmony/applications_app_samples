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
import { abilityDelegatorRegistry, Driver, ON, MouseButton, Component, MatchPattern, UiDirection } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import resource from '../../../main/ets/common/resource';


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
const ONE_SECONDS_TIME = 1000;
const ONE_SECONDS_TIME2 = 10000;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}


export default function IndexTest() {

  describe('IndexTest', () => {

    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    it('testOpenCustomDialog', 0, async (done: Function) => {
      console.info("uitest: testOpenCustomDialog begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('openCustomDialog', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text('UI', MatchPattern.CONTAINS));
      await button_list1.click();
      let button1 = await driver.findComponent(ON.id('open'));
      await button1.click();

      let button2 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.change_dialog')), MatchPattern.CONTAINS));
      await button2.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testCustomDialogComponentWithTransition', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('openCustomDialog', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_customDialogComponentWithTransition = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.customDialogComponentWithTransition_title')), MatchPattern.CONTAINS));
      await button_customDialogComponentWithTransition.click();
      let text_open = await driver.findComponent(ON.text('打开弹窗', MatchPattern.CONTAINS));
      expect(text_open === null).assertFalse();
      await text_open.click();
      await sleep(5000);
      await driver.pressBack();
      await sleep(5000);
      await driver.pressBack();
      done();
    })

    it('testcustomDialogWithKeyboardAvoidDistance', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('openCustomDialog', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_customDialogWithKeyboardAvoidDistance = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.customDialogWithKeyboardAvoidDistance_title')), MatchPattern.CONTAINS));
      await button_customDialogWithKeyboardAvoidDistance.click();
      let text_customDialogWithKeyboardAvoidDistance_open = await driver.findComponent(ON.text('打开弹窗', MatchPattern.CONTAINS));
      await text_customDialogWithKeyboardAvoidDistance_open.click();
      await sleep(1000);
      let textinputComponent = await driver.findComponent(ON.type('TextInput'))
      await textinputComponent.click();
      await sleep(1000);
      await driver.pressBack();
      await sleep(1000);
      await driver.pressBack();
      await sleep(1000);
      await driver.pressBack();
      done();
    })

    it('testOpenDialogAndUpdate', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('openCustomDialog', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_customDialogWithKeyboardAvoidDistance = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.OpenDialogAndUpdate_title')), MatchPattern.CONTAINS));
      await button_customDialogWithKeyboardAvoidDistance.click();
      let text_OpenDialogAndUpdate_update_options = await driver.findComponent(ON.text('open dialog and update options', MatchPattern.CONTAINS));
      await text_OpenDialogAndUpdate_update_options.click();
      await sleep(3000);
      await driver.pressBack();
      let text_OpenDialogAndUpdate_update_content = await driver.findComponent(ON.text('open dialog and update content', MatchPattern.CONTAINS));
      await text_OpenDialogAndUpdate_update_content.click();
      await sleep(3000);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testCustomDialog', 0, async (done: Function) => {
      console.info("uitest: testCustomDialog begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog_nest')), MatchPattern.CONTAINS));
      await button_list1.click();

      let button_list2 = await driver.findComponent(ON.text('Click', MatchPattern.CONTAINS));
      await button_list2.click();
      let button_list3 = await driver.findComponent(ON.text('confirm', MatchPattern.CONTAINS));
      await button_list3.click();
      let button_list4 = await driver.findComponent(ON.text('close', MatchPattern.CONTAINS));
      await button_list4.click();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    it('testDialogFocusStrategy', 0, async (done: Function) => {
      console.info("uitest: testDialogFocusStrategy begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
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
      console.info("uitest: testGlobalOpenPopup begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Popup1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
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
      console.info("uitest: testDialogController begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
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
      console.info("uitest: testPageLevelDialog begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.fling(UiDirection.DOWN, ONE_SECONDS_TIME2);
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
      console.info("uitest: testGlobalOpenMenu begin");
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
      console.info("uitest: testDialogBoxLayer begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.fling(UiDirection.DOWN, ONE_SECONDS_TIME2);
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

    it('testDialogFocusStrategy', 0, async (done: Function) => {
      console.info("uitest: testDialogFocusStrategy begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
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
      console.info("uitest: testGlobalOpenPopup begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Popup1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
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
      console.info("uitest: testDialogController begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
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
      console.info("uitest: testPageLevelDialog begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.fling(UiDirection.DOWN, ONE_SECONDS_TIME2);
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
      console.info("uitest: testGlobalOpenMenu begin");
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
      console.info("uitest: testDialogBoxLayer begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialog1')),
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.fling(UiDirection.DOWN, ONE_SECONDS_TIME2);
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

    it('testFixedCustomDialog', 0, async (done: Function) => {
      console.info("uitest: testFixedCustomDialog begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.FixedStyleDialog1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DatePicker_title')), MatchPattern.CONTAINS));
      await button_list1.click();

      let button_list2 = await driver.findComponent(ON.text('showDatePickerDialog', MatchPattern.CONTAINS));
      await button_list2.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    /**
     * @tc.number testShowActionMenu001
     * @tc.name testShowActionMenu001
     * @tc.desc Test Fixed-style pop-up box.
     * @tc.size MEDIUM
     * @tc.level Level 1
     * @tc.type Function
     */
    it('testShowActionMenu001', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.FixedStyleDialog1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.ShowActionMenu_title')), MatchPattern.CONTAINS));
      await button_list1.click();

      let button_list2 = await driver.findComponent(ON.text('ShowActionMenu', MatchPattern.CONTAINS));
      await button_list2.click();
      await sleep(ONE_SECONDS_TIME);
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    /**
     * @tc.number testFixedCustomDialog_002
     * @tc.name testFixedCustomDialog_002
     * @tc.desc Test Fixed-style pop-up box.
     * @tc.size MEDIUM
     * @tc.level Level 1
     * @tc.type Function
     */
    it('testFixedCustomDialog_002', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.FixedStyleDialog1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DatePickerCustom_title')), MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list2 = await driver.findComponent(ON.text('showDatePickerCustomDialog', MatchPattern.CONTAINS));
      await button_list2.click();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    it('testMenu', 0, async (done: Function) => {
      console.info("uitest: testMenu begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Menu1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CreateMenu_title')), MatchPattern.CONTAINS));
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list2 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.menu_bind')), MatchPattern.CONTAINS));
      await button_list2.click();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    it('testMaskDialog', 50, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.MaskDialog')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialogAnimation_title')), MatchPattern.CONTAINS));
      await button_list1.click();

      let button_list2 = await driver.findComponent(ON.text('CustomDialogController animate', MatchPattern.CONTAINS));
      await button_list2.click();
      await sleep(2000)
      await driver.pressBack();
      await sleep(2000)
      await driver.pressBack();

      let customDialogControl_list_item = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialogControl_title')), MatchPattern.CONTAINS));
      await customDialogControl_list_item.click();
      let button_autoCancel = await driver.findComponent(ON.text('openCustomDialog autoCancel:false', MatchPattern.CONTAINS));
      await button_autoCancel.click();
      await sleep(1000);
      await driver.pressBack();

      let button_isModal = await driver.findComponent(ON.text('openCustomDialog isModal:false', MatchPattern.CONTAINS));
      await button_isModal.click();
      await sleep(1000);
      await driver.pressBack();

      let button_maskOpt = await driver.findComponent(ON.text('openCustomDialog maskOpt', MatchPattern.CONTAINS));
      await button_maskOpt.click();
      await driver.pressBack();

      let button_transition = await driver.findComponent(ON.text('openCustomDialog transition', MatchPattern.CONTAINS));
      await button_transition.click();
      await sleep(1000);
      await driver.pressBack();
      await sleep(2000);

      let button_immersiveMode = await driver.findComponent(ON.text('openCustomDialog immersiveMode', MatchPattern.CONTAINS));
      await button_immersiveMode.click();
      await sleep(1000);
      await driver.pressBack();

      let button_maskTransition = await driver.findComponent(ON.text('openCustomDialog maskTransition', MatchPattern.CONTAINS));
      await sleep(1000);
      await button_maskTransition.click();
      await sleep(2000);
      await driver.pressBack();

      await sleep(1000);
      done();
    })

    it('testToast', 0, async (done: Function) => {
      console.info("uitest: testToast begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.Toast1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.OpenCloseToast_title')), MatchPattern.CONTAINS));
      await button_list1.click();

      let button1 = await driver.findComponent(ON.text('Open', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Close', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })

    it('testOverlayManager', 0, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.OverlayManager1')), MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await sleep(ONE_SECONDS_TIME);
      let button_list1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.OverlayManager_demo1_title')), MatchPattern.CONTAINS));
      expect(button_list1 === null).assertFalse();
      await button_list1.click();
      await sleep(ONE_SECONDS_TIME);
      let button1 = await driver.findComponent(ON.text('ComponentContent', MatchPattern.CONTAINS));
      expect(button1 === null).assertFalse();
      await button1.click();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await sleep(ONE_SECONDS_TIME);
      done();
    })
  })
}