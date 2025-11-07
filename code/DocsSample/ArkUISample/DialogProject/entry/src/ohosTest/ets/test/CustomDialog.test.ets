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


export default function CustomDialogTest() {

  describe('CustomDialogTest', () => {

    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    it('testCustomDialog', 60000, async (done: Function) => {
      console.info('uitest: testCustomDialog begin');
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
      await sleep(1000);

      let button_createCustomDialog1 = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CreateCustomDialogNew_title')), MatchPattern.CONTAINS));
      await button_createCustomDialog1.click();
      let button_createCustomDialog1_click = await driver.findComponent(ON.text('click me', MatchPattern.CONTAINS));
      await button_createCustomDialog1_click.click();
      await driver.pressBack();
      await driver.pressBack();

      let button_dialogInteractionUseConstructor = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DialogInteractionUseConstructor_title')), MatchPattern.CONTAINS));
      await button_dialogInteractionUseConstructor.click();
      let button_dialogInteractionUseConstructor_click = await driver.findComponent(ON.text('click me', MatchPattern.CONTAINS));
      await button_dialogInteractionUseConstructor_click.click();
      let button_dialogInteractionUseConstructor_confirm = await driver.findComponent(ON.text('confirm', MatchPattern.CONTAINS));
      await button_dialogInteractionUseConstructor_confirm.click();
      await driver.pressBack();

      let stackList = await driver.findComponent(ON.type('List'));
      await stackList.scrollSearch(ON.text(resource.resourceToString($r('app.string.DialogInteractionUseButton_title'))));

      let button_dialogInteractionUseButton = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DialogInteractionUseButton_title')), MatchPattern.CONTAINS));
      await button_dialogInteractionUseButton.click();
      let button_dialogInteractionUseButton_click = await driver.findComponent(ON.text('click me', MatchPattern.CONTAINS));
      await button_dialogInteractionUseButton_click.click();
      let button_dialogInteractionUseButton_confirm = await driver.findComponent(ON.text('confirm', MatchPattern.CONTAINS));
      await button_dialogInteractionUseButton_confirm.click();
      let button_dialogInteractionUseButton_return = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.click_and_return')), MatchPattern.CONTAINS));
      await button_dialogInteractionUseButton_return.click();
      await sleep(1000);
      await driver.pressBack();
      await sleep(1000);

      await stackList.scrollSearch(ON.text(resource.resourceToString($r('app.string.DialogAnimationNew_title'))));
      let button_dialogAnimationNew = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DialogAnimationNew_title')), MatchPattern.CONTAINS));
      await button_dialogAnimationNew.click();
      let button_dialogAnimationNew_click = await driver.findComponent(ON.text('click me', MatchPattern.CONTAINS));
      await button_dialogAnimationNew_click.click();
      await driver.pressBack();
      await driver.pressBack();

      await stackList.scrollSearch(ON.text(resource.resourceToString($r('app.string.DialogStyleNew_title'))));
      let button_dialogStyleNew = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DialogStyleNew_title')), MatchPattern.CONTAINS));
      await button_dialogStyleNew.click();
      let button_dialogStyleNew_click = await driver.findComponent(ON.text('click me', MatchPattern.CONTAINS));
      await button_dialogStyleNew_click.click();
      await driver.pressBack();
      await driver.pressBack();

      await stackList.scrollSearch(ON.text(resource.resourceToString($r('app.string.NestDialogNew_title'))));
      let button_nestDialogNew = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.NestDialogNew_title')), MatchPattern.CONTAINS));
      await button_nestDialogNew.click();
      let button_nestDialogNew_click = await driver.findComponent(ON.text('Click Me', MatchPattern.CONTAINS));
      await button_nestDialogNew_click.click();
      let button_nestDialogNew_open = await driver.findComponent(ON.text('Open Second Dialog Box and close this box', MatchPattern.CONTAINS));
      await button_nestDialogNew_open.click();
      let button_nestDialogNew_create_text = await driver.findComponent(ON.text('Create Text', MatchPattern.CONTAINS));
      await button_nestDialogNew_create_text.click();
      let button_nestDialogNew_close = await driver.findComponent(ON.text('Close Second Dialog Box', MatchPattern.CONTAINS));
      await button_nestDialogNew_close.click();
      await driver.pressBack();

      await stackList.scrollToBottom()
      let button_dialogWithPhysicalBack = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DialogWithPhysicalBack_title')), MatchPattern.CONTAINS));
      await button_dialogWithPhysicalBack.click();
      let button_dialogWithPhysicalBack_click = await driver.findComponent(ON.text('click me', MatchPattern.CONTAINS));
      await button_dialogWithPhysicalBack_click.click();
      let button_dialogWithPhysicalBack_confirm = await driver.findComponent(ON.text('confirm', MatchPattern.CONTAINS));
      await button_dialogWithPhysicalBack_confirm.click();
      await driver.pressBack();

      let button_getDialogStatus = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.GetDialogStatus_title')), MatchPattern.CONTAINS));
      await button_getDialogStatus.click();
      let button_button_getDialogStatus_click = await driver.findComponent(ON.text('click me', MatchPattern.CONTAINS));
      await button_button_getDialogStatus_click.click();
      let button_button_getDialogStatus_custom = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.search_by_dialog')), MatchPattern.CONTAINS));
      await button_button_getDialogStatus_custom.click();
      let button_button_getDialogStatus_custom_controller = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.search_by_dialog_controller')), MatchPattern.CONTAINS));
      await button_button_getDialogStatus_custom_controller.click();
      let button_button_getDialogStatus_close = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.close_widows')), MatchPattern.CONTAINS));
      await button_button_getDialogStatus_close.click();
      await driver.pressBack();
      await sleep(5000);

      let button_dialogAvoidSoftKeyboard = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.DialogAvoidSoftKeyboard_title')), MatchPattern.CONTAINS));
      await button_dialogAvoidSoftKeyboard.click();
      let text_dialogWithPhysicalBack_open = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.open_windows')), MatchPattern.CONTAINS));
      await text_dialogWithPhysicalBack_open.click();
      await sleep(1000);
      let textinputComponent = await driver.findComponent(ON.type('TextInput'))
      await textinputComponent.click();
      await sleep(1000);
      await driver.pressBack();
      await sleep(1000);
      await driver.pressBack();
      await sleep(1000);
      await driver.pressBack();

      await sleep(ONE_SECONDS_TIME);
      done();
    })
  })
}