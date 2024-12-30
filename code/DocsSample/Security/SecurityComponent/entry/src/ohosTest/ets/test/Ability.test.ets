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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import Logger from '../utils/Logger';

const BUNDLE = 'SecurityComponent_';
const DELAY_TIME = 1000;
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let manage = abilityDelegator.getAppContext().resourceManager;

async function getResourceString(resource: Resource): Promise<string> {
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  let driver = Driver.create();
  describe('SecurityComponentTest', (done: Function) => {
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.securitycomponent',
          abilityName: 'EntryAbility'
        })
        done();
      } catch (exception) {
        Logger.info(`StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
        done();
      }
      Logger.info(BUNDLE + 'StartAbility_001 end');
    })
    /**
     * 获取定位信息
     */
    it(BUNDLE + 'GetLocation_001', 0, async (done: Function) => {
      Logger.info(BUNDLE + 'GetLocation_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击Location
      await driver.assertComponentExist(ON.id('Location'));
      let location = await driver.findComponent(ON.id('Location'));
      await location.click();
      await driver.delayMs(DELAY_TIME);
      // 点击LocationButton获取定位信息
      await driver.assertComponentExist(ON.type('LocationButton'));
      let locationButton = await driver.findComponent(ON.type('LocationButton'));
      await locationButton.click();
      await driver.delayMs(DELAY_TIME);
      // 点击允许
      let str = await getResourceString($r('app.string.admit'));
      await driver.assertComponentExist(ON.text(str));
      let button = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME * 5);
      // 返回
      await driver.pressBack();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'GetLocation_001 end');
      done();
    })

    /**
     * 获取剪贴板内容
     */
    it(BUNDLE + 'GetPasteContent_001', 0, async (done: Function) => {
      Logger.info(BUNDLE + 'GetPasteContent_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击Paste
      await driver.assertComponentExist(ON.id('Paste'));
      let paste = await driver.findComponent(ON.id('Paste'));
      await paste.click();
      await driver.delayMs(DELAY_TIME);
      // 点击TextInput输入'123456'文本
      await driver.assertComponentExist(ON.type('TextInput'));
      let textInput = await driver.findComponent(ON.type('TextInput'));
      await textInput.inputText('123456');
      await textInput.longClick();
      await driver.delayMs(DELAY_TIME);
      // 点击全选按钮
      let str = await getResourceString($r('app.string.select_all'));
      await driver.assertComponentExist(ON.text(str));
      let selectButton = await driver.findComponent(ON.text(str));
      await selectButton.click();
      await driver.delayMs(DELAY_TIME);
      // 点击剪切选项
      str = await getResourceString($r('app.string.cut'));
      await driver.assertComponentExist(ON.text(str));
      let cutButton = await driver.findComponent(ON.text(str));
      await cutButton.click();
      await driver.delayMs(DELAY_TIME);
      // 隐藏输入法
      await driver.pressBack();
      await driver.delayMs(DELAY_TIME);
      // 点击pasteButton 粘贴'123456'文本
      await driver.assertComponentExist(ON.type('PasteButton'));
      let copyButton = await driver.findComponent(ON.type('PasteButton'));
      await copyButton.click();
      await driver.delayMs(DELAY_TIME);
      // 返回主页
      await driver.pressBack();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'GetPasteContent_001 end');
      done();
    })

    /**
     * 保存图片到媒体库
     */
    it(BUNDLE + 'Save_001', 0, async (done: Function) => {
      Logger.info(BUNDLE + 'Save_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击Save
      await driver.assertComponentExist(ON.id('Save'));
      let save = await driver.findComponent(ON.id('Save'));
      await save.click();
      await driver.delayMs(DELAY_TIME);
      // 点击LocationButton获取定位信息
      await driver.assertComponentExist(ON.type('SaveButton'));
      let saveButton = await driver.findComponent(ON.type('SaveButton'));
      await saveButton.click();
      await driver.delayMs(DELAY_TIME);
      // 点击允许
      let str = await getResourceString($r('app.string.admit'));
      await driver.assertComponentExist(ON.text(str));
      let Button = await driver.findComponent(ON.text(str));
      await Button.click();
      await driver.delayMs(DELAY_TIME);
      // 返回
      await driver.pressBack();
      await driver.delayMs(DELAY_TIME);
      Logger.info(BUNDLE + 'Save_001 end');
      done();
    })
  })
}

