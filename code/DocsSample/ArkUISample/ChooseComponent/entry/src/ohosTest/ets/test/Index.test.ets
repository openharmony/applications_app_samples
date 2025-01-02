/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;


function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}


export default function IndexTest() {

  describe('IndexTest', () => {

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

    it('testCreateButton', 0, async (done: Function) => {
      console.info("uitest: testCreateButton begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Button', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let str = await getResourceString($r('app.string.CreateButton_title'));
      let button_search = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_search === null).assertFalse();
      await button_search.click();

      let button_normal = await driver.findComponent(ON.id('button'));
      let button_back = await driver.findComponent(ON.id('button_back'));
      expect(button_normal === null).assertFalse();
      expect(button_back === null).assertFalse();
      await button_normal.click();
      await button_back.click();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testSetButtonType', 0, async (done: Function) => {
      console.info("uitest: testSetButtonType begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Button', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let str = await getResourceString($r('app.string.SetButtonType_test'));
      let button_search = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_search === null).assertFalse();
      await button_search.click();

      let button_Capsule = await driver.findComponent(ON.id('Capsule'));
      let button_Circle = await driver.findComponent(ON.id('Circle'));
      let button_Normal = await driver.findComponent(ON.id('Normal'));
      let button_Round = await driver.findComponent(ON.id('Round'));
      expect(button_Capsule === null).assertFalse();
      expect(button_Circle === null).assertFalse();
      expect(button_Normal === null).assertFalse();
      expect(button_Round === null).assertFalse();
      await button_Capsule.click();
      await button_Circle.click();
      await button_Normal.click();
      await button_Round.click();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testCustomStyle', 0, async (done: Function) => {
      console.info("uitest: testCustomStyle begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Button', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let str = await getResourceString($r('app.string.ButtonCustomStyle_test'));
      let button_search = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_search === null).assertFalse();
      await button_search.click();

      let button_circle = await driver.findComponent(ON.id('circle_border'));
      let button_font = await driver.findComponent(ON.id('font_style'));
      let button_color = await driver.findComponent(ON.id('background_color'));
      expect(button_circle === null).assertFalse();
      expect(button_font === null).assertFalse();
      expect(button_color === null).assertFalse();
      await button_circle.click();
      await button_font.click();
      await button_color.click();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testSubmitForm', 0, async (done: Function) => {
      console.info("uitest: testSubmitForm begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Button', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let str = await getResourceString($r('app.string.SubmitForm'));
      let button_search = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_search === null).assertFalse();
      await button_search.click();

      let username = await driver.findComponent(ON.id('username'));
      let password = await driver.findComponent(ON.id('password'));
      let registerButton = await driver.findComponent(ON.id('register'));
      expect(username === null).assertFalse();
      expect(password === null).assertFalse();
      expect(registerButton === null).assertFalse();
      await username.inputText('username');
      await password.inputText('password');
      expect(await username.getText() === 'username').assertTrue();

      let point = await password.getBoundsCenter();
      await driver.mouseClick({
        x: point.x + 300, y: point.y
      }, MouseButton.MOUSE_BUTTON_LEFT, 0, 0);
      expect(await password.getText() === 'password').assertTrue();
      await registerButton.click();
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testFloatingButton', 0, async (done: Function) => {
      console.info("uitest: testFloatingButton begin");
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Button', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let str = await getResourceString($r('app.string.FloatingButton'));
      let button_search = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_search === null).assertFalse();
      await button_search.click();

      let floatingButton = await driver.findComponent(ON.id('Button'));
      let stackList = await driver.findComponent(ON.id('List'));
      expect(floatingButton === null).assertFalse();
      expect(stackList === null).assertFalse();
      await floatingButton.click();
      await stackList.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testToggleUiExample1', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Toggle', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let str = await getResourceString($r('app.string.CreateToggle_title'));
      let button_search = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_search === null).assertFalse();
      await button_search.click();

      let toggle1: Component = await driver.findComponent(ON.id('toggle1'));
      let toggle2: Component = await driver.findComponent(ON.id('toggle2'));
      let toggle3: Component = await driver.findComponent(ON.id('toggle3'));
      let toggle4: Component = await driver.findComponent(ON.id('toggle4'));
      let toggle5: Component = await driver.findComponent(ON.id('toggle5'));
      let toggle6: Component = await driver.findComponent(ON.id('toggle6'));
      await toggle1.click();
      await toggle2.click();
      await toggle3.click();
      await toggle4.click();
      await toggle5.click();
      await toggle6.click();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testToggleUiExample2', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Toggle', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let str = await getResourceString($r('app.string.ToggleCustomStyle_title'));
      let button_search = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_search === null).assertFalse();
      await button_search.click();
      let toggle1: Component = await driver.findComponent(ON.id('toggle1'));
      let toggle2: Component = await driver.findComponent(ON.id('toggle2'));
      let toggle3: Component = await driver.findComponent(ON.id('toggle3'));
      let toggle4: Component = await driver.findComponent(ON.id('toggle4'));
      let toggle5: Component = await driver.findComponent(ON.id('toggle5'));
      await toggle1.click();
      await toggle2.click();
      await toggle3.click();
      await toggle4.click();
      await toggle5.click();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    it('testToggleUiExample3', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('Toggle', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      let str = await getResourceString($r('app.string.Sample'));
      let button_search = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(button_search === null).assertFalse();
      await button_search.click();
      let message: Component = await driver.findComponent(ON.id('message'));
      expect(await message.getText() === 'Bluetooth Mode: off').assertTrue();
      let toggle: Component = await driver.findComponent(ON.id('toggle'));
      await toggle.click();
      expect(await message.getText() === 'Bluetooth Mode: on').assertTrue();
      await driver.pressBack();
      await driver.pressBack();
      done();
    })
  })
}