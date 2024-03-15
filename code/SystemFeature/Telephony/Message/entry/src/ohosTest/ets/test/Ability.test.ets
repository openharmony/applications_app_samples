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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import inputMethod from '@ohos.inputMethod';

const DRIVER = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async function (done) {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.message',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0x0000, 'testTag', 'StartAbility_001 end');
    })

    /**
     * 联系人弹窗
     */
    it('CreateContactDialog_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'CreateContactDialog_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('newContact'));
      let addBtn = await DRIVER.findComponent(ON.id('newContact'));
      await addBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('nameInput'));
      await DRIVER.assertComponentExist(ON.id('telInput'));
      await DRIVER.assertComponentExist(ON.id('confirm'));
      hilog.info(0x0000, 'testTag', 'CreateContactDialog_001 end');
    })

    /**
     * 新建联系人
     */
    it('CreateContact_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'CreateContact_001 begin');
      let nameInput = await DRIVER.findComponent(ON.id('nameInput'));
      await nameInput.inputText('monster');
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      await DRIVER.delayMs(1000);
      let telInput = await DRIVER.findComponent(ON.id('telInput'));
      await telInput.inputText('13333333333');
      inputMethodController.stopInputSession();
      await DRIVER.delayMs(1000);
      let confirm = await DRIVER.findComponent(ON.id('confirm'));
      await confirm.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('monster'));
      hilog.info(0x0000, 'testTag', 'CreateContact_001 end');
    })

    /**
     * 检查发消息的页面
     */
    it('CheckSendMessage_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'CheckSendMessage_001 begin');
      // 点击发送信息
      let sendMessage = await DRIVER.findComponent(ON.id('monster'));
      await sendMessage.click();
      await DRIVER.delayMs(1000);
      // 判断页面标题
      await DRIVER.assertComponentExist(ON.text('monster'));
      await DRIVER.assertComponentExist(ON.text('13333333333'));
      // 编辑短信内容
      await DRIVER.assertComponentExist(ON.id('messageContent'));
      await DRIVER.assertComponentExist(ON.id('send'));
      hilog.info(0x0000, 'testTag', 'CheckSendMessage_001 end');
    })

    /**
     * 发消息
     */
    it('SendMessage_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'SendMessage_001 begin');
      let messageContent = await DRIVER.findComponent(ON.id('messageContent'));
      await messageContent.inputText('this is a message info');
      let send = await DRIVER.findComponent(ON.id('send'));
      await send.click();
      await DRIVER.delayMs(1000);
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      await DRIVER.assertComponentExist(ON.id('messageInfo'));
      let messageInfo = await DRIVER.findComponent(ON.id('messageInfo'));
      expect(await messageInfo.getText()).assertEqual('this is a message info');
      hilog.info(0x0000, 'testTag', 'SendMessage_001 end');
    })

    /**
     * 返回主页并且点击管理
     */
    it('ManageContact_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'ManageContact_001 begin');
      await DRIVER.assertComponentExist(ON.id('back'));
      let backBtn = await DRIVER.findComponent(ON.id('back'));
      await backBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('manage'));
      let manageBtn = await DRIVER.findComponent(ON.id('manage'));
      await manageBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('delete_monster'));
      hilog.info(0x0000, 'testTag', 'ManageContact_001 end');
    })

    /**
     * 删除联系人
     */
    it('DeleteContact_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'DeleteContact_001 begin');
      let deleteBtn = await DRIVER.findComponent(ON.id('delete_monster'));
      await deleteBtn.click();
      await DRIVER.delayMs(1000);
      let monster = await DRIVER.findComponent(ON.id('monster'));
      // 数据被删除后，断言id为monster的组件为null
      expect(monster).assertNull();
      hilog.info(0x0000, 'testTag', 'DeleteContact_001 end');
    })
  })
}