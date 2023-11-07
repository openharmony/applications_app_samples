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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../../../main/ets/data/Logger';
import inputMethod from '@ohos.inputMethod';

const BUNDLE = 'Contact';
const TAG: string = '[Sample_Contact]';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let resMgr = abilityDelegator.getAppContext().resourceManager;
  let text = await resMgr.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.contact',
          abilityName: 'EntryAbility'
        })
        done();
      } catch (expection) {
        expect(0).assertEqual(expection.code);
        Logger.info(TAG, `StartAbility end ${JSON.stringify(expection)}`);
        done();
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 获取通讯录访问权限
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 requestPermission');
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.allow'))));
      let btnAccept = await driver.findComponent(ON.text(await getResourceString($r('app.string.allow'))));
      await btnAccept.click();
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * 点击切换tab
     */
    it(BUNDLE + 'SwitchTabFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'SwitchTabFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击电话
      Logger.info(TAG, BUNDLE + 'SwitchTabFunction_001 clickTelephone');
      await driver.assertComponentExist(ON.id('tab0'));
      let telephone = await driver.findComponent(ON.id('tab0'));
      await telephone.click();
      await driver.delayMs(1000);
      // 点击收藏
      Logger.info(TAG, BUNDLE + 'SwitchTabFunction_001 clickTelephone');
      await driver.assertComponentExist(ON.id('tab2'));
      let collection = await driver.findComponent(ON.id('tab2'));
      await collection.click();
      await driver.delayMs(1000);
      // 点击联系人
      Logger.info(TAG, BUNDLE + 'SwitchTabFunction_001 clickTelephone');
      await driver.assertComponentExist(ON.id('tab1'));
      let contact = await driver.findComponent(ON.id('tab1'));
      await contact.click();
      await driver.delayMs(1000);
      // 成功跳转联系人页面(即进入应用主页)
      await driver.assertComponentExist(ON.id('add'));
      await driver.assertComponentExist(ON.id('setting'));
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'SwitchTabFunction_001 end');
    })

    /**
     * 点击首页添加按钮
     */
    it(BUNDLE + 'AddFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'AddFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击添加按钮
      await driver.assertComponentExist(ON.id('add'));
      let btnAdd = await driver.findComponent(ON.id('add'));
      await btnAdd.click();
      await driver.delayMs(1000);
      // 跳转新建联系人页面
      await driver.assertComponentExist(ON.id('cancel'));
      await driver.assertComponentExist(ON.id('confirm'));
      // 点击取消
      let btnCancel = await driver.findComponent(ON.id('cancel'));
      await btnCancel.click();
      await driver.delayMs(1000);
      // 返回主页
      await driver.assertComponentExist(ON.id('add'));
      await driver.assertComponentExist(ON.id('setting'));
      // 再次点击添加按钮
      await btnAdd.click();
      await driver.delayMs(1000)
      // 跳转新建联系人页面
      await driver.assertComponentExist(ON.id('cancel'));
      await driver.assertComponentExist(ON.id('confirm'));
      Logger.info(TAG, BUNDLE + 'AddFunction_001 end');
    })

    /**
     * 添加联系人
     */
    it(BUNDLE + 'AddContactFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'AddContactFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 输入姓名
      await driver.assertComponentExist(ON.id('inputName'));
      let name = await driver.findComponent(ON.id('inputName'));
      await name.inputText('zs');
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      let nameValue = await name.getText();
      Logger.info(TAG, `AddContactFunction_001 name:${nameValue}`);
      expect(nameValue).assertEqual('zs');
      // 输入地址
      await driver.assertComponentExist(ON.id('inputAddress'));
      let address = await driver.findComponent(ON.id('inputAddress'));
      await address.inputText('hangzhou');
      inputMethodController.stopInputSession();
      let addressValue = await address.getText();
      Logger.info(TAG, `AddContactFunction_001 address:${addressValue}`);
      expect(addressValue).assertEqual('hangzhou');
      // 输入电话
      await driver.assertComponentExist(ON.id('inputTelephone'));
      let telephone = await driver.findComponent(ON.id('inputTelephone'));
      // 不符合规则号码
      await telephone.inputText('12321465987');
      inputMethodController.stopInputSession();
      let illegalTelephoneValue = await telephone.getText();
      Logger.info(TAG, `AddContactFunction_001 illegalTelephone:${illegalTelephoneValue}`);
      expect(illegalTelephoneValue).assertEqual('12321465987');
      // 输入邮箱
      await driver.assertComponentExist(ON.id('inputMail'));
      let mail = await driver.findComponent(ON.id('inputMail'));
      await mail.inputText('1505678900@163.com');
      inputMethodController.stopInputSession();
      let mailValue = await mail.getText();
      Logger.info(TAG, `AddContactFunction_001 mail:${mailValue}`);
      expect(mailValue).assertEqual('1505678900@163.com');
      // 点击确认按钮
      await driver.assertComponentExist(ON.id('confirm'));
      let btnConfirm = await driver.findComponent(ON.id('confirm'));
      await btnConfirm.click();
      // 返回主页失败，添加联系人失败，当前仍停留在添加联系人页面，并弹出toast提示：please input phone number，toast弹窗暂不支持测试
      await driver.assertComponentExist(ON.id('cancel'));
      await driver.assertComponentExist(ON.id('confirm'));
      // 再次输入电话，输入符合规则号码
      await telephone.inputText('15321465987');
      inputMethodController.stopInputSession();
      let legalTelephoneValue = await telephone.getText();
      Logger.info(TAG, `AddContactFunction_001 legalTelephone:${legalTelephoneValue}`);
      expect(legalTelephoneValue).assertEqual('15321465987');
      // 点击确认按钮
      await btnConfirm.click();
      await driver.delayMs(1000);
      // 返回主页
      await driver.assertComponentExist(ON.id('add'));
      await driver.assertComponentExist(ON.id('setting'));
      Logger.info(TAG, BUNDLE + 'AddContactFunction_001 end');
    })

    /**
     * 编辑联系人
     */
    it(BUNDLE + 'EditContactFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'EditContactFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击联系人列表
      await driver.assertComponentExist(ON.id('contactList'));
      let contactList = await driver.findComponent(ON.id('contactList'));
      await contactList.click();
      // 跳转联系人卡片详情页
      await driver.assertComponentExist(ON.id('back'));
      await driver.assertComponentExist(ON.id('editContact'));
      await driver.assertComponentExist(ON.id('deleteContact'));
      // 点击编辑按钮
      let btnEdit = await driver.findComponent(ON.id('editContact'));
      await btnEdit.click();
      await driver.delayMs(1000);
      // 跳转到编辑联系人页面
      await driver.assertComponentExist(ON.id('cancelEdit'));
      await driver.assertComponentExist(ON.id('confirmEdit'));
      // 点击取消
      await driver.assertComponentExist(ON.id('cancelEdit'));
      let btnCancel = await driver.findComponent(ON.id('cancelEdit'));
      await btnCancel.click();
      await driver.delayMs(1000);
      // 跳转联系人卡片详情页
      await driver.assertComponentExist(ON.id('back'));
      await driver.assertComponentExist(ON.id('editContact'));
      await driver.assertComponentExist(ON.id('deleteContact'));
      // 再次点击编辑按钮
      await driver.delayMs(1000);
      await btnEdit.click();
      // 跳转到编辑联系人页面
      await driver.assertComponentExist(ON.id('cancelEdit'));
      await driver.assertComponentExist(ON.id('confirmEdit'));
      // 更新联系人姓名
      await driver.assertComponentExist(ON.id('updateName'));
      let updateName = await driver.findComponent(ON.id('updateName'));
      await updateName.inputText('lisi');
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      let nameValue = await updateName.getText();
      Logger.info(TAG, `EditContactFunction_001 name:${nameValue}`);
      expect(nameValue).assertEqual('lisi');
      // 更新联系人地址
      await driver.assertComponentExist(ON.id('updateAddress'));
      let updateAddress = await driver.findComponent(ON.id('updateAddress'));
      await updateAddress.inputText('beijing');
      inputMethodController.stopInputSession();
      let addressValue = await updateAddress.getText();
      Logger.info(TAG, `EditContactFunction_001 address:${addressValue}`);
      expect(addressValue).assertEqual('beijing');
      // 更新电话(输入不符合规则号码)
      await driver.assertComponentExist(ON.id('updateTelephone'));
      let updateTelephone = await driver.findComponent(ON.id('updateTelephone'));
      await updateTelephone.inputText('12326421968');
      inputMethodController.stopInputSession();
      let illegalUpdatePhoneNumber = await updateTelephone.getText();
      Logger.info(TAG, `EditContactFunction_001 illegalUpdatePhoneNumber:${illegalUpdatePhoneNumber}`);
      expect(illegalUpdatePhoneNumber).assertEqual('12326421968');
      // 更新邮箱
      await driver.assertComponentExist(ON.id('updateMail'));
      let updateMail = await driver.findComponent(ON.id('updateMail'));
      await updateMail.inputText('1506589700@qq.com');
      inputMethodController.stopInputSession();
      let mailValue = await updateMail.getText();
      Logger.info(TAG, `EditContactFunction_001 mail:${mailValue}`);
      expect(mailValue).assertEqual('1506589700@qq.com');
      // 点击确认按钮
      await driver.assertComponentExist(ON.id('confirmEdit'));
      let btnConfirm = await driver.findComponent(ON.id('confirmEdit'));
      await btnConfirm.click();
      // 返回主页失败，更新联系人失败，当前仍停留在更新联系人页面，并弹出toast提示：please input phone number，toast弹窗暂不支持测试
      await driver.assertComponentExist(ON.id('cancelEdit'));
      await driver.assertComponentExist(ON.id('confirmEdit'));
      // 再次输入电话，输入符合规则号码
      await updateTelephone.inputText('15321143568');
      inputMethodController.stopInputSession();
      let legalUpdatePhoneNumber = await updateTelephone.getText();
      Logger.info(TAG, `EditContactFunction_001 legalUpdatePhoneNumber:${legalUpdatePhoneNumber}`);
      expect(legalUpdatePhoneNumber).assertEqual('15321143568');
      // 点击确认按钮
      await btnConfirm.click();
      await driver.delayMs(1000);
      // 跳转回主页
      await driver.assertComponentExist(ON.id('add'));
      await driver.assertComponentExist(ON.id('setting'));
      Logger.info(TAG, BUNDLE + 'EditContactFunction_001 end');
    })

    /**
     * 查询联系人
     */
    it(BUNDLE + 'QueryContactFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'QueryContactFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 输入要查询的联系人号码
      await driver.assertComponentExist(ON.id('inputContact'));
      let inputContact = await driver.findComponent(ON.id('inputContact'));
      await inputContact.inputText('15321143568');
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      let contactInfo = await inputContact.getText();
      Logger.info(TAG, `QueryContactFunction_001 contact:${contactInfo}`);
      expect(contactInfo).assertEqual('15321143568');
      // 点击键盘回车键跳转到卡片详情页
      await driver.triggerKey(2054);
      await driver.delayMs(1000);
      // 跳转联系人卡片详情页
      await driver.assertComponentExist(ON.id('back'));
      await driver.assertComponentExist(ON.id('editContact'));
      await driver.assertComponentExist(ON.id('deleteContact'));
      Logger.info(TAG, BUNDLE + 'QueryContactFunction_001 end');
    })

    /**
     * 删除联系人
     */
    it(BUNDLE + 'DeleteContactFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'DeleteContactFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击删除按钮删除联系人
      await driver.assertComponentExist(ON.id('deleteContact'));
      let deleteContact = await driver.findComponent(ON.id('deleteContact'));
      await deleteContact.click();
      // 弹出警告弹窗

      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.cancel'))));
      // 点击取消按钮，弹窗消失
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.cancel'))));
      let btnCancel = await driver.findComponent(ON.text(await getResourceString($r('app.string.cancel'))));
      await btnCancel.click();
      // 停留在联系人卡片详情页
      await driver.assertComponentExist(ON.id('back'));
      await driver.assertComponentExist(ON.id('editContact'));
      await driver.assertComponentExist(ON.id('deleteContact'));
      // 再次点击删除
      await deleteContact.click();
      await driver.delayMs(1000);
      // 点击确认
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm'))));
      let btnConfirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.confirm'))));
      await btnConfirm.click();
      await driver.delayMs(1000);
      // 跳转回主页
      await driver.assertComponentExist(ON.id('add'));
      await driver.assertComponentExist(ON.id('setting'));
      Logger.info(TAG, BUNDLE + 'DeleteContactFunction_001 end');
    })

    /**
     * 设置
     */
    it(BUNDLE + 'ClickSettingFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'ClickMoreFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击设置按钮
      await driver.assertComponentExist(ON.id('setting'));
      let btnSetting = await driver.findComponent(ON.id('setting'));
      await btnSetting.click();
      // 跳转到设置页面
      await driver.assertComponentExist(ON.id('addBack'));
      await driver.assertComponentExist(ON.id('addContact'));
      await driver.assertComponentExist(ON.id('importFile'));
      await driver.assertComponentExist(ON.id('exportFile'));
      // 点击导入文件
      let importFile = await driver.findComponent(ON.id('importFile'));
      await importFile.click();
      // 点击导出文件
      let exportFile = await driver.findComponent(ON.id('exportFile'));
      await exportFile.click();
      // 点击新建联系人
      let addNewContact = await driver.findComponent(ON.id('addContact'));
      await addNewContact.click();
      await driver.delayMs(1000);
      // 跳转到新建联系人界面
      await driver.assertComponentExist(ON.id('cancel'));
      await driver.assertComponentExist(ON.id('confirm'));
      // 输入姓名
      await driver.assertComponentExist(ON.id('inputName'));
      let contactName = await driver.findComponent(ON.id('inputName'));
      await contactName.inputText('liyi');
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      let name = await contactName.getText();
      Logger.info(TAG, `ClickSettingFunction_001 name:${name}`);
      expect(name).assertEqual('liyi');
      // 输入地址
      await driver.assertComponentExist(ON.id('inputAddress'));
      let address = await driver.findComponent(ON.id('inputAddress'));
      await address.inputText('shanghai');
      inputMethodController.stopInputSession();
      let addressValue = await address.getText();
      Logger.info(TAG, `ClickSettingFunction_001 address:${addressValue}`);
      expect(addressValue).assertEqual('shanghai');
      // 输入电话
      await driver.assertComponentExist(ON.id('inputTelephone'));
      let phone = await driver.findComponent(ON.id('inputTelephone'));
      // 不符合规则号码
      await phone.inputText('12695874569');
      inputMethodController.stopInputSession();
      let illegalPhoneNumber = await phone.getText();
      Logger.info(TAG, `ClickSettingFunction_001 illegalPhoneNumber:${illegalPhoneNumber}`);
      expect(illegalPhoneNumber).assertEqual('12695874569');
      // 输入邮箱
      await driver.assertComponentExist(ON.id('inputMail'));
      let mail = await driver.findComponent(ON.id('inputMail'));
      await mail.inputText('1607365260@139.com');
      inputMethodController.stopInputSession();
      let mailValue = await mail.getText();
      Logger.info(TAG, `ClickSettingFunction_001 mail:${mailValue}`);
      expect(mailValue).assertEqual('1607365260@139.com');
      // 点击确认按钮
      await driver.assertComponentExist(ON.id('confirm'));
      let btnConfirm = await driver.findComponent(ON.id('confirm'));
      await btnConfirm.click();
      // 返回主页失败，添加联系人失败，当前仍停留在添加联系人页面，并弹出toast提示：please input phone number，toast弹窗暂不支持测试
      await driver.assertComponentExist(ON.id('cancel'));
      await driver.assertComponentExist(ON.id('confirm'));
      // 再次输入电话，输入符合规则号码
      await phone.inputText('17322305685');
      inputMethodController.stopInputSession();
      let legalPhoneNumber = await phone.getText();
      Logger.info(TAG, `ClickSettingFunction_001 legalPhoneNumber:${legalPhoneNumber}`);
      expect(legalPhoneNumber).assertEqual('17322305685');
      // 点击确认按钮
      await btnConfirm.click();
      await driver.delayMs(1000);
      // 返回主页
      await driver.assertComponentExist(ON.id('add'));
      await driver.assertComponentExist(ON.id('setting'));
      Logger.info(TAG, BUNDLE + 'ClickSettingFunction_001 end');
    })
  })
}
