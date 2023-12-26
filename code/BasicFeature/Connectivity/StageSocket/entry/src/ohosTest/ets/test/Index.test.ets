/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import hilog from '@ohos.hilog';
import { Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { getString } from '../util/ResourceUtil';

const TAG = '[Sample_Socket]';
const DOMAIN = 0xF811;
const BUNDLE = 'Socket_';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();

let driver = Driver.create();

export default function IndexTest() {
  describe('IndexTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.

      // 启动Ability
      delegator.executeShellCommand('aa start -a EntryAbility -b ohos.samples.socket');

      await driver.delayMs(1000);
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /**
     * 连接服务器
     */
    it(BUNDLE + 'ConnectTcpServer_001', 0,async (done: () => void) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectTcpServer_001 begin');

      await driver.delayMs(1000);

      // 选择协议
      await checkAndClickById('selectAgreement','ConnectTcpServer_001');
      await checkAndClickByText(getString($r('app.string.tcp')),'ConnectTcpServer_001');
      await checkAndClickById('agreementConfirm','ConnectTcpServer_001');

      await driver.delayMs(1000);

      // 输入服务端IP
      await checkAndInputById('inputIp','192.168.8.160','ConnectTcpServer_001');

      // 点击登录按钮
      await checkAndClickById('login','ConnectTcpServer_001');

      await driver.delayMs(3000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectTcpServer_001 end');
    })

    /**
     * 创建房间
     */
    it(BUNDLE + 'CreateRoom_001', 0, async (done: () => void)  => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateRoom_001 begin');
      await driver.delayMs(2000);

      // 点击Text组件
      await checkAndClickById('createRoom','CreateRoom_001');

      // 输入房间号
      await checkAndInputById('inputNumber','2332','CreateRoom_001');

      // 点击确认按钮，发送房间号至客户端
      await checkAndClickById('roomConfirm','CreateRoom_001');

      await driver.delayMs(3000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateRoom_001 end');
    })

    /**
     * 聊天
     */
    it(BUNDLE + 'Chat_001', 0,async (done: () => void) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(DOMAIN, TAG, BUNDLE + 'Chat_001 begin');

      await driver.delayMs(2000);

      // 输入第一条消息
      await checkAndInputById('inputMsg','hello','Chat_001');

      // 发送第一条消息
      await checkAndClickById('sendMsg','Chat_001');

      await driver.delayMs(2000);

      // 输入第二条消息
      await checkAndInputById('inputMsg','I,am,fine,thank,you','Chat_001');

      // 发送第二条消息
      await checkAndClickById('sendMsg','Chat_001');

      await driver.delayMs(3000);

      // 点击返回按钮
      await checkAndClickById('indexBack','Chat_001');
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Chat_001 end');
    })
  })

  /**
   * 根据id拿到组件并点击
   * @param id
   */
  const checkAndClickById = async (id:string,log:string) => {
    hilog.info(DOMAIN, TAG, BUNDLE + `${log} id:${id}`);
    await driver.assertComponentExist(ON.id(id));
    let res = await driver.findComponent(ON.id(id));
    await res.click();
  }
  /**
   * 根据text拿到组件并点击
   * @param text
   */
  const checkAndClickByText = async (text:string,log:string) => {
    hilog.info(DOMAIN, TAG, BUNDLE + `${log} text:${text}`);
    await driver.assertComponentExist(ON.text(text));
    let res = await driver.findComponent(ON.text(text));
    await res.click();
  }
  /**
   * 根据id拿到组件并输入消息
   * @param id
   * @param msg
   */
  const checkAndInputById = async (id:string,msg:string,log:string) => {
    hilog.info(DOMAIN, TAG, BUNDLE + `${log} id:${id}`);
    await driver.assertComponentExist(ON.id(id));
    let res = await driver.findComponent(ON.id(id));
    await res.inputText(msg);
  }
}