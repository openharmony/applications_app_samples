/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import Logger from '../../utils/Logger';

const TAG: string = '[Sample_AuthorizedButton]';
const DOMAIN = '0xF811';
const BUNDLE = 'AuthorizedButton_';

const DELAY_TIME = 1000;

export default function abilityTest() {
  let driver = Driver.create();
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('ActsAbilityTest',  () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async  (done: Function) => {
      Logger.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.authorizedbutton',
          abilityName: 'EntryAbility'
        })
        done();
      } catch (exception) {
        Logger.info(DOMAIN, TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      Logger.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
    * 获取定位信息
    */
    it(BUNDLE + 'GetLocation_001', 0, async () =>{
      Logger.info(DOMAIN, TAG, BUNDLE + 'GetLocation_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击Location
      await driver.assertComponentExist(ON.id('Location'));
      let location = await driver.findComponent(ON.id('Location'));
      await location.click();
      await driver.delayMs(DELAY_TIME);
      // 点击LocationButton获取定位信息
      await driver.assertComponentExist(ON.id('locationButton'));
      let locationButton = await driver.findComponent(ON.id('locationButton'));
      await locationButton.click();
      await driver.delayMs(DELAY_TIME);
      // 点击确定
      await driver.assertComponentExist(ON.text('知道了'));
      let Button = await driver.findComponent(ON.text('知道了'));
      await Button.click();
      // 返回
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
      Logger.info(DOMAIN, TAG,  BUNDLE + 'GetLocation_001 end');
    })

    /**
    * 获取剪贴板内容
    */
    it(BUNDLE + 'GetPasteContent_001', 0, async () =>{
      Logger.info(DOMAIN, TAG, BUNDLE + 'GetPasteContent_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击Paste
      await driver.assertComponentExist(ON.id('Paste'));
      let paste = await driver.findComponent(ON.id('Paste'));
      await paste.click();
      await driver.delayMs(DELAY_TIME);
      // 点击CopyButton复制“天天开心”文本
      await driver.assertComponentExist(ON.id('copyButton'));
      let copyButton = await driver.findComponent(ON.id('copyButton'));
      await copyButton.click();
      await driver.delayMs(DELAY_TIME);
      // 点击PasteButton粘贴“天天开心”文本，固定坐标只支持RK3568，其他设备需要调整
      await driver.click(360,1100);
      await driver.delayMs(DELAY_TIME);
      // 返回
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
      Logger.info(DOMAIN, TAG, BUNDLE + 'GetPasteContent_001 end');
    })

    /**
    * 保存图片到媒体库
    */
    it(BUNDLE + 'Save_001', 0, async () =>{
      Logger.info(DOMAIN, TAG, BUNDLE + 'Save_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击Save
      await driver.assertComponentExist(ON.id('Save'));
      let save = await driver.findComponent(ON.id('Save'));
      await save.click();
      await driver.delayMs(DELAY_TIME);
      // 点击LocationButton获取定位信息
      await driver.assertComponentExist(ON.id('saveButton'));
      let saveButton = await driver.findComponent(ON.id('saveButton'));
      await saveButton.click();
      await driver.delayMs(DELAY_TIME);
      // 点击确定
      await driver.assertComponentExist(ON.text('知道了'));
      let Button = await driver.findComponent(ON.text('知道了'));
      await Button.click();
      // 返回
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.delayMs(500);
      Logger.info(DOMAIN, TAG, BUNDLE + 'Save_001 end');
    })
  })
}