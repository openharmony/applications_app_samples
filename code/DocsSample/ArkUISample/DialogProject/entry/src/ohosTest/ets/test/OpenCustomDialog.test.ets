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


export default function OpenCustomDialogTest() {

  describe('OpenCustomDialogTest', () => {

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

    it('testCustomDialogComponentWithTransition', 60000, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('openCustomDialog', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let button_CustomDialogComponentWithTransition = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialogComponentWithTransition_title')), MatchPattern.CONTAINS));
      await button_CustomDialogComponentWithTransition.click();
      let text_open = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.open_windows')), MatchPattern.CONTAINS));
      expect(text_open === null).assertFalse();
      await text_open.click();
      await sleep(5000);
      await driver.pressBack();
      await sleep(5000);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testCustomDialogComponentWithTransition2', 60000, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('openCustomDialog', MatchPattern.CONTAINS));
      await button_list.click();
      let button_customDialogAndUpdate = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.OpenDialogAndUpdate_title')), MatchPattern.CONTAINS));
      await button_customDialogAndUpdate.click();
      let text_OpenDialogAndUpdate_update_options = await driver.findComponent(ON.text('open dialog and update options', MatchPattern.CONTAINS));
      await text_OpenDialogAndUpdate_update_options.click();
      await sleep(3000);
      await driver.pressBack();
      let text_OpenDialogAndUpdate_update_content = await driver.findComponent(ON.text('open dialog and update content', MatchPattern.CONTAINS));
      await text_OpenDialogAndUpdate_update_content.click();
      await sleep(3000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      done()
    })

    it('testCustomDialogComponentWithTransition3', 60000, async (done: Function) => {
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('openCustomDialog', MatchPattern.CONTAINS));
      await button_list.click();
      let button_CustomDialogWithKeyboardAvoidDistance = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.CustomDialogWithKeyboardAvoidDistance_title')), MatchPattern.CONTAINS));
      await button_CustomDialogWithKeyboardAvoidDistance.click();
      let text_CustomDialogWithKeyboardAvoidDistance_open = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.open_windows')), MatchPattern.CONTAINS));
      await text_CustomDialogWithKeyboardAvoidDistance_open.click();
      await sleep(1000);
      let textinputComponent = await driver.findComponent(ON.type('TextInput'))
      await textinputComponent.click();
      await sleep(1000);
      await driver.pressBack();
      await sleep(1000);
      await driver.pressBack();
      await sleep(1000);
      await driver.pressBack();
      await driver.pressBack();
      done()
    })
  })
}