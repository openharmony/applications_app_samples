/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { describe, expect, it } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import UIAbility from '@ohos.app.ability.UIAbility';
import Logger from '../util/Logger';
import inputMethod from '@ohos.inputMethod';

const TAG = 'AppTest';
const BUNDLE = 'CrossAppDataShare_';
let driver: Driver = Driver.create();
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
let ability: UIAbility;

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartProvider_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'StartProvider_001 begin');
      let want1 = {
        bundleName: 'ohos.samples.crossappdatashare',
        abilityName: 'ohos.samples.dataprovider.MainAbility'
      }
      await abilityDelegatorRegistry.startAbility(want1).then(
        (err) => {
          Logger.info(TAG, `_startAbility get err ${JSON.stringify(err)}`);
        });
    });
    it(BUNDLE + 'StartAbility_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      let want = {
        bundleName: 'ohos.samples.crossappdatashare',
        abilityName: 'ohos.samples.datauser.MainAbility'
      }
      await abilityDelegatorRegistry.startAbility(want).then(
        (err) => {
          Logger.info(TAG, `_startAbility get err ${JSON.stringify(err)}`);
        });
      ability = await abilityDelegatorRegistry.getCurrentTopAbility();
    });
    // 新增联系人
    it(`${BUNDLE}AddContact_001`, 0, async () => {
      let inputMethodController = inputMethod.getController();
      Logger.info(TAG, BUNDLE + 'AddContact_001 begin');
      await driver.delayMs(1000);
      // 点击+按钮进入创建联系人页面
      await driver.assertComponentExist(ON.id('addBtn'));
      let addBtn = await driver.findComponent(ON.id('addBtn'));
      await addBtn.click();
      // 输入名称以及电话号
      await driver.assertComponentExist(ON.id('contactMsg0'));
      let nameInput = await driver.findComponent(ON.id('contactMsg0'));
      await driver.delayMs(1000);
      await nameInput.inputText('mst');
      inputMethodController.stopInputSession();
      await driver.delayMs(1000);
      let nameText = await nameInput.getText();
      await driver.delayMs(1000);
      expect('mst').assertEqual(nameText);
      await driver.assertComponentExist(ON.id('phoneInput'));
      let inputPhone = await driver.findComponent(ON.id('phoneInput'));
      await driver.delayMs(1000);
      await inputPhone.inputText('18837982616');
      inputMethodController.stopInputSession();
      await driver.delayMs(1000);
      let phoneText = await inputPhone.getText();
      await driver.delayMs(1000);
      expect('18837982616').assertEqual(phoneText);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('finish'));
      let finish = await driver.findComponent(ON.id('finish'));
      await driver.delayMs(1000);
      await finish.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('mst'));
      // 再次新建联系人
      await driver.assertComponentExist(ON.id('addBtn'));
      await driver.delayMs(1000);
      await addBtn.click();
      await driver.delayMs(1000);
      // 输入名字
      await driver.assertComponentExist(ON.id('contactMsg0'));
      nameInput = await driver.findComponent(ON.id('contactMsg0'));
      await driver.delayMs(1000);
      await nameInput.inputText('ash');
      inputMethodController.stopInputSession();
      await driver.delayMs(1000);
      nameText = await nameInput.getText();
      await driver.delayMs(1000);
      expect('ash').assertEqual(nameText);
      await driver.delayMs(1000);
      // 输入电话
      await driver.assertComponentExist(ON.id('phoneInput'));
      inputPhone = await driver.findComponent(ON.id('phoneInput'));
      await driver.delayMs(1000);
      await inputPhone.inputText('13393527802');
      inputMethodController.stopInputSession();
      await driver.delayMs(1000);
      phoneText = await inputPhone.getText();
      await driver.delayMs(1000);
      expect('13393527802').assertEqual(phoneText);
      await driver.delayMs(1000);
      // 完成创建
      await driver.assertComponentExist(ON.id('finish'));
      finish = await driver.findComponent(ON.id('finish'));
      await driver.delayMs(1000);
      await finish.click();
      await driver.delayMs(1000);
      // 校验是否创建成功
      await driver.assertComponentExist(ON.text('ash'));
      Logger.info(TAG, BUNDLE + 'AddContact_001 end');
    })
    // 联系人助手覆盖联系人，用例只支持RK3568
    it(`${BUNDLE}OverwriteContact_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'OverwriteContact_001 begin');
      await driver.delayMs(1000);
      // 切换到设置
      await driver.assertComponentExist(ON.id('tabBar1'));
      let setText = await driver.findComponent(ON.id('tabBar1'));
      await driver.delayMs(1000);
      await setText.click();
      // 打开联系人助手覆盖联系人开关
      await driver.assertComponentExist(ON.id('overwriteContact'));
      let overwriteContact = await driver.findComponent(ON.id('overwriteContact'));
      await driver.delayMs(1000);
      await overwriteContact.click();
      // 返回主页
      await driver.assertComponentExist(ON.id('tabBar0'));
      let contactTitle = await driver.findComponent(ON.id('tabBar0'));
      await driver.delayMs(1000);
      await contactTitle.click();
      await driver.delayMs(1000);
      // 点击同步联系人
      await driver.assertComponentExist(ON.id('syncContact'));
      let syncContact = await driver.findComponent(ON.id('syncContact'));
      Logger.info(TAG, BUNDLE + 'HomeContent, syncContact click');
      await driver.delayMs(1000);
      await syncContact.click();
      await driver.delayMs(1000);
      await driver.click(360, 1244);
      let resourceManager = ability.context.resourceManager;
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.contact'))));
      let contactApply = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.contact'))));
      await driver.delayMs(1000);
      await contactApply.click();
      await driver.delayMs(5000);
      // 校验是否覆盖成功
      if (!await driver.findComponent(ON.text('mst'))) {
        Logger.info(TAG, 'overwriteAssistant failed')
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + 'OverwriteContact_001 end');
    });
    // 编辑联系人
    it(`${BUNDLE}EditContact_001`, 0, async () => {
      let inputMethodController = inputMethod.getController();
      Logger.info(TAG, BUNDLE + 'EditContact_001 begin');
      await driver.delayMs(1000);
      // 进入联系人详情页面
      await driver.assertComponentExist(ON.text('mst'));
      let contactName = await driver.findComponent(ON.text('mst'));
      await driver.delayMs(1000);
      await contactName.click();
      // 点击编辑按钮
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('operateContact0'));
      let editContact = await driver.findComponent(ON.id('operateContact0'));
      await driver.delayMs(1000);
      await editContact.click();
      await driver.assertComponentExist(ON.id('contactMsg0'));
      let nameInput = await driver.findComponent(ON.id('contactMsg0'));
      await driver.delayMs(1000);
      // 清空文本
      await nameInput.clearText();
      await driver.delayMs(1000);
      // 输入文本
      await nameInput.inputText('msw');
      inputMethodController.stopInputSession();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('finish'));
      let finish = await driver.findComponent(ON.id('finish'));
      await driver.delayMs(1000);
      await finish.click();
      await driver.delayMs(5000);
      // 验证是否修改成功
      if (!await driver.findComponent(ON.text('msw'))) {
        Logger.info(TAG, 'edit failed');
        expect().assertFail();
      }
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'EditContact_001 end');
    });
    // 删除联系人，用例只支持RK3568
    it(`${BUNDLE}DeleteContact_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'DeleteContact_001 begin');
      await driver.delayMs(1000);
      // 点击删除按钮
      await driver.assertComponentExist(ON.id(`operateContact1`));
      let deleteContact = await driver.findComponent(ON.id(`operateContact1`));
      await driver.delayMs(1000);
      await deleteContact.click();
      await driver.delayMs(1000);
      // 坐标基于rk3568
      await driver.click(210, 1136);
      await driver.delayMs(2000);
      // 验证是否删除成功
      if (await driver.findComponent(ON.text('msw'))) {
        Logger.info(TAG, 'delete failed');
        expect().assertFail();
      }
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'DeleteContact_001 end');
    });
    // 内置联系人应用创建联系人
    it(`${BUNDLE}AddInsertContact_001`, 0, async () => {
      let inputMethodController = inputMethod.getController();
      Logger.info(TAG, BUNDLE + 'AddInsertContact_001 begin');
      await driver.delayMs(1000);
      // 点击+按钮进入创建联系人页面
      await driver.assertComponentExist(ON.id('addContact'));
      let addBtn = await driver.findComponent(ON.id('addContact'));
      await addBtn.click();
      // 输入名称
      await driver.assertComponentExist(ON.id('contactMsg0'));
      let nameInput = await driver.findComponent(ON.id('contactMsg0'));
      await driver.delayMs(1000);
      await nameInput.inputText('msg');
      inputMethodController.stopInputSession();
      await driver.delayMs(1000);
      // 获取内容
      let nameText = await nameInput.getText();
      await driver.delayMs(1000);
      // 校验输入内容
      expect('msg').assertEqual(nameText);
      // 输入电话
      await driver.assertComponentExist(ON.id('phoneInput'));
      let inputPhone = await driver.findComponent(ON.id('phoneInput'));
      await driver.delayMs(1000);
      await inputPhone.inputText('18837982616');
      inputMethodController.stopInputSession();
      await driver.delayMs(1000);
      // 获取电话输入框内容
      let phoneText = await inputPhone.getText();
      await driver.delayMs(1000);
      // 校验内容
      expect('18837982616').assertEqual(phoneText);
      await driver.delayMs(1000);
      // 完成创建
      await driver.assertComponentExist(ON.id('finish'));
      let finish = await driver.findComponent(ON.id('finish'));
      await driver.delayMs(1000);
      await finish.click();
      await driver.delayMs(1000);
      // 校验是否创建成功
      await driver.assertComponentExist(ON.text('msg'));
      await driver.delayMs(1000);
      // 再次新建联系人
      await driver.assertComponentExist(ON.id('addContact'));
      await driver.delayMs(1000);
      await addBtn.click();
      await driver.delayMs(1000);
      // 输入名字
      await driver.assertComponentExist(ON.id('contactMsg0'));
      nameInput = await driver.findComponent(ON.id('contactMsg0'));
      await driver.delayMs(1000);
      await nameInput.inputText('msq');
      inputMethodController.stopInputSession();
      await driver.delayMs(1000);
      nameText = await nameInput.getText();
      await driver.delayMs(1000);
      expect('msq').assertEqual(nameText);
      await driver.delayMs(1000);
      // 输入电话
      await driver.assertComponentExist(ON.id('phoneInput'));
      inputPhone = await driver.findComponent(ON.id('phoneInput'));
      await driver.delayMs(1000);
      await inputPhone.inputText('13393527802');
      inputMethodController.stopInputSession();
      await driver.delayMs(1000);
      phoneText = await inputPhone.getText();
      await driver.delayMs(1000);
      expect('13393527802').assertEqual(phoneText);
      await driver.delayMs(1000);
      // 完成创建
      await driver.assertComponentExist(ON.id('finish'));
      finish = await driver.findComponent(ON.id('finish'));
      await driver.delayMs(1000);
      await finish.click();
      await driver.delayMs(1000);
      // 校验是否创建成功
      await driver.assertComponentExist(ON.text('msq'));
      Logger.info(TAG, BUNDLE + 'AddInsertContact_001 end');
    })
    // 联系人覆盖联系人助手，用例只支持RK3568
    it(`${BUNDLE}OverwriteAssistant_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'OverwriteAssistant_001 begin');
      await driver.delayMs(1000);
      // 返回桌面坐标基于rk3568
      await driver.click(360, 1244);
      await driver.delayMs(1000);
      let resourceManager = ability.context.resourceManager;
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.dataUser_desc'))));
      let contactAssistant = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.dataUser_desc'))));
      await driver.delayMs(1000);
      await contactAssistant.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('tabBar1'));
      let setText = await driver.findComponent(ON.id('tabBar1'));
      await driver.delayMs(1000);
      await setText.click();
      // 打开联系人覆盖联系人助手开关
      await driver.assertComponentExist(ON.id('overwriteAssistant'));
      let deduplication = await driver.findComponent(ON.id('overwriteAssistant'));
      await driver.delayMs(1000);
      await deduplication.click();
      // 返回主页
      await driver.assertComponentExist(ON.id('tabBar0'));
      let contactTitle = await driver.findComponent(ON.id('tabBar0'));
      await driver.delayMs(1000);
      await contactTitle.click();
      await driver.delayMs(1000);
      // 点击同步联系人
      await driver.assertComponentExist(ON.id('syncContact'));
      let syncContact = await driver.findComponent(ON.id('syncContact'));
      await driver.delayMs(1000);
      await syncContact.click();
      await driver.delayMs(3000);
      // 校验是否覆盖成功
      await driver.assertComponentExist(ON.text('msg'));
      if (!await driver.findComponent(ON.text('msg'))) {
        Logger.info(TAG, 'overwriteAssistant failed');
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + 'OverwriteAssistant_001 end');
    });
    // 去重
    it(`${BUNDLE}SynchronousContact_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'SynchronousContact_001 begin');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('tabBar1'));
      let setText = await driver.findComponent(ON.id('tabBar1'));
      await driver.delayMs(1000);
      await setText.click();
      // 打开联系人覆盖联系人助手开关
      await driver.assertComponentExist(ON.id('deduplication'));
      let deduplication = await driver.findComponent(ON.id('deduplication'));
      await driver.delayMs(1000);
      await deduplication.click();
      // 返回主页
      await driver.assertComponentExist(ON.id('tabBar0'));
      let contactTitle = await driver.findComponent(ON.id('tabBar0'));
      await driver.delayMs(1000);
      await contactTitle.click();
      await driver.delayMs(1000);
      // 点击同步联系人
      await driver.assertComponentExist(ON.id('syncContact'));
      let syncContact = await driver.findComponent(ON.id('syncContact'));
      await driver.delayMs(1000);
      await syncContact.click();
      await driver.delayMs(1000);
      // 验证去重是否成功
      await driver.assertComponentExist(ON.text('msg'));
      let contacts = await driver.findComponents(ON.text('msg'));
      if (contacts.length > 1) {
        Logger.info(TAG, 'syncContact failed');
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + 'SynchronousContact_001 end');
    })
  })
}