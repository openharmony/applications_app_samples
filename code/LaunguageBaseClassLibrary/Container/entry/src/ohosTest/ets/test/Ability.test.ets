/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '[Sample_Container]';
const DOMAIN = 0xF811;
const BUNDLE = 'Container_';
const DRIVER = Driver.create();

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let parameter = {
        bundleName: 'ohos.samples.container',
        abilityName: 'EntryAbility'
      };
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegatorRegistry.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code);
        expect(0).assertEqual(err.code);
        done();
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
      })
    })
    /**
     * 点击添加
     */
    it(BUNDLE + 'ClickAddFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 begin');
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickAddBtn');
      // 点击添加按钮
      await DRIVER.assertComponentExist(ON.id('addBtn'));
      let btnAdd = await DRIVER.findComponent(ON.id('addBtn'));
      await btnAdd.click();
      await DRIVER.delayMs(1000);
      try {
        await DRIVER.assertComponentExist(ON.id('addDialog'));
      } catch (err) {
        hilog.error(DOMAIN, TAG, BUNDLE + `addDialog err: ${JSON.stringify(err)}`);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 end');
    })
    /**
     * 联系人信息弹窗中输入姓名、年龄、电话
     */
    it(BUNDLE + 'InputContactInformationFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 begin');
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 inputName');
      // 输入姓名
      await DRIVER.assertComponentExist(ON.id('inputName'));
      let nameInput = await DRIVER.findComponent(ON.id('inputName'));
      await nameInput.inputText('zhangsan');
      let nameVal = await nameInput.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 nameVal');
      expect('zhangsan').assertEqual(nameVal);
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 inputAge');
      // 输入年龄
      await DRIVER.assertComponentExist(ON.id('inputAge'));
      let ageInput = await DRIVER.findComponent(ON.id('inputAge'));
      await ageInput.inputText('18');
      let ageVal = await ageInput.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 ageVal');
      expect('18').assertEqual(ageVal);
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 inputPhone');
      // 输入电话
      await DRIVER.assertComponentExist(ON.id('inputPhone'));
      let phoneInput = await DRIVER.findComponent(ON.id('inputPhone'));
      await phoneInput.inputText('18156349865');
      let phoneVal = await phoneInput.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 phoneVal');
      expect('18156349865').assertEqual(phoneVal);
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 clickConfirm');
      // 点击确认
      await DRIVER.assertComponentExist(ON.id('confirm'));
      let btnConfirm = await DRIVER.findComponent(ON.id('confirm'));
      await btnConfirm.click();
      await DRIVER.delayMs(1000);
      let afterDeleteArray = await DRIVER.findComponents(ON.id('dataItem'));
      expect(afterDeleteArray.length).assertEqual(1);
    })
    /**
     * 删除联系人信息
     */
    it(BUNDLE + 'DelContactInformationFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DelContactInformationFunction_001 begin');
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DelContactInformationFunction_001 clickDelContact');
      // 点击删除
      await DRIVER.assertComponentExist(ON.id('zhangsan_delContact'));
      let btnDel = await DRIVER.findComponent(ON.id('zhangsan_delContact'));
      await btnDel.click();
      await DRIVER.delayMs(1000);
      let dataItem = await DRIVER.findComponents(ON.id('dataItem'));
      expect(dataItem).assertNull();
    })
  })
}