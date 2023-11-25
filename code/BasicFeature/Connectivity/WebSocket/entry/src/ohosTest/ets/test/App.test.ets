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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Component, Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import inputMethod from '@ohos.inputMethod';

const BUNDLE = 'WebSocket'
const TAG = '[Sample_WebSocket]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + ' StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.websocket',
          abilityName: 'MainAbility'
        });
        done();
      } catch (expection) {
        expect(0).assertEqual(expection.code);
        hilog.info(DOMAIN, TAG, ' StartAbility end err:' + JSON.stringify(expection));
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + ' StartAbility_001 end');
    })
    /**
     * 绑定服务器
     */
    it(BUNDLE + 'bindServer_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + ' bindServer begin')
      let driver = await Driver.create()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + ' bindServer input ip address')
      // 输入服务器地址
      await driver.assertComponentExist(ON.id('text_ip_input'))
      let ipInput = await driver.findComponent(ON.id('text_ip_input'))
      // 校验输入的IP地址格式是否正确
      await ipInput.inputText("xxx.xxx.xxx.xxx")
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + ' bindServer bind server')
      // 点击绑定按钮,显示格式不正确
      await driver.assertComponentExist(ON.id('btn_bind'))
      let btnBind = await driver.findComponent(ON.id('btn_bind'))
      await btnBind.click()
      await driver.delayMs(500)
      // 重新输入正确格式的IP地址
      await ipInput.inputText("192.168.43.244")
      await driver.delayMs(1000)
      // 点击绑定按钮
      await btnBind.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + ' bindServer end')
    })
    /**
     * 发送信息
     */
    it(BUNDLE + 'sendMessage_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(500)

      // 输入内容
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_001 input message')
      await driver.assertComponentExist(ON.id('text_input'))
      let mesInput = await driver.findComponent(ON.id('text_input'))
      await mesInput.inputText("hello")
      await driver.delayMs(1000)

      // 发送信息
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_001 send')
      await driver.assertComponentExist(ON.id('btn_send'))
      let btnBind = await driver.findComponent(ON.id('btn_send'))
      await btnBind.click()
      await driver.delayMs(500)
      // 停止会话,关闭键盘
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();

      // 校验内容
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_001 check message')
      await driver.assertComponentExist(ON.text('hello'))
      let replyList = await driver.findComponents(ON.text("\"StringHandler\""))
      expect(replyList).assertNull()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_001 end')
    })
    /**
     * 连接服务器
     */
    it(BUNDLE + 'connectServer_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + ' connectServer begin')
      let driver = await Driver.create()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + ' connectServer connect')
      // 点击连接按钮
      await driver.assertComponentExist(ON.id('btn_connect'))
      let btnBind = await driver.findComponent(ON.id('btn_connect'))
      await btnBind.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + ' connectServer end')
    })
    /**
     * 发送信息
     */
    it(BUNDLE + 'sendMessage_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_002 begin')
      let driver = await Driver.create()
      await driver.delayMs(500)

      // 输入内容
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_002 input message')
      await driver.assertComponentExist(ON.id('text_input'))
      let mesInput = await driver.findComponent(ON.id('text_input'))
      await mesInput.inputText("hello1")
      await driver.delayMs(1000)

      // 发送信息
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_002 send')
      await driver.assertComponentExist(ON.id('btn_send'))
      let btnBind = await driver.findComponent(ON.id('btn_send'))
      await btnBind.click()
      await driver.delayMs(500)

      // 输入内容
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_002 input message')
      await mesInput.inputText("hello2")
      await driver.delayMs(1000)

      // 发送信息
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_002 send')
      await btnBind.click()
      await driver.delayMs(500)
      // 停止会话,关闭键盘
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();

      // 校验内容
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_002 check message')
      await driver.assertComponentExist(ON.text('hello1'))
      await driver.assertComponentExist(ON.text('hello2'))
      let replyList = await driver.findComponents(ON.text("\"StringHandler\""))
      expect(2).assertEqual(replyList.length)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage end')
    })
    /**
     * 断开服务器
     */
    it(BUNDLE + 'disconnectServer_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + ' disconnectServer_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + ' disconnectServer_001 connect')
      // 点击连接按钮
      await driver.assertComponentExist(ON.id('btn_connect'))
      let btnBind = await driver.findComponent(ON.id('btn_connect'))
      await btnBind.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + ' disconnectServer_001 end')
    })
    /**
     * 发送信息
     */
    it(BUNDLE + 'sendMessage_003', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_003 begin')
      let driver = await Driver.create()
      await driver.delayMs(500)

      // 输入内容
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_003 input message')
      await driver.assertComponentExist(ON.id('text_input'))
      let mesInput = await driver.findComponent(ON.id('text_input'))
      await mesInput.inputText("hello3")
      await driver.delayMs(1000)

      // 发送信息
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_003 send')
      await driver.assertComponentExist(ON.id('btn_send'))
      let btnBind = await driver.findComponent(ON.id('btn_send'))
      await btnBind.click()
      await driver.delayMs(500)
      // 停止会话,关闭键盘
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();

      // 校验内容
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_003 check message')
      await driver.assertComponentExist(ON.text('hello3'))
      let replyList = await driver.findComponents(ON.text("\"StringHandler\""))
      expect(2).assertEqual(replyList.length)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + ' sendMessage_003 end')
    })
  })
}