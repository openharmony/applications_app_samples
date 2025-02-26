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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';

const BUNDLE = 'WebSocket_C_';
const TAG: string = '[Sample_WebSocketConnection]';
const DOMAIN = 0xF811; // 域名设置为0xF811
const DELAY_TIME = 500; // 延迟时间
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver = Driver.create();

function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number LaunchIndexPage_001
     * @tc.name LaunchIndexPage_001
     * @tc.desc 启动应用
     */
    it(BUNDLE + 'LaunchIndexPage_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'LaunchIndexPage_001, begin');
      try {
        await delegator.startAbility({
          bundleName: bundleName,
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'LaunchIndexPage_001, error');
        expect(0).assertEqual(err.code)
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'LaunchIndexPage_001, end');
    })

    /**
     * @tc.number WebSocketConnectionFunction_002
     * @tc.name WebSocketConnectionFunction_002
     * @tc.desc WebSocket连接
     */
    it(BUNDLE + 'WebSocketConnectionFunction_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WebSocketConnectionFunction_002, begin');
      await driver.delayMs(DELAY_TIME);
      // 点击TextInput输入'wss://echo.websocket.org'文本
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.WebSocket_address'))));
      await driver.assertComponentExist(ON.id('textInput_address'));
      let textInput_address = await driver.findComponent(ON.id('textInput_address'));
      await textInput_address.inputText('wss://echo.websocket.org');
      await driver.assertComponentExist(ON.id('Connect'));
      let buttonConnect = await driver.findComponent(ON.id('Connect'));
      await buttonConnect.click();
      await driver.delayMs(DELAY_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WebSocketConnectionFunction_002, end');
    })

    /**
     * @tc.number WebSocketSendMessageFunction_003
     * @tc.name WebSocketSendMessageFunction_003
     * @tc.desc WebSocket发送消息
     */
    it(BUNDLE + 'WebSocketSendMessageFunction_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WebSocketSendMessageFunction_003, begin');
      await driver.delayMs(DELAY_TIME);
      // 点击TextInput输入'Hello World!'文本
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.Content'))));
      await driver.assertComponentExist(ON.id('textInput_content'));
      let textInput_content = await driver.findComponent(ON.id('textInput_content'));
      await textInput_content.inputText('Hello World!');
      await driver.assertComponentExist(ON.id('Send'));
      let buttonSend = await driver.findComponent(ON.id('Send'));
      await buttonSend.click();
      await driver.delayMs(DELAY_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WebSocketSendMessageFunction_003, end');
    })

    /**
     * @tc.number WebSocketCloseFunction_004
     * @tc.name WebSocketCloseFunction_004
     * @tc.desc WebSocket连接释放
     */
    it(BUNDLE + 'WebSocketCloseFunction_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WebSocketCloseFunction_004, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Close'));
      let buttonClose = await driver.findComponent(ON.id('Close'));
      await buttonClose.click();
      await driver.delayMs(DELAY_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WebSocketCloseFunction_004, end');
    })
  })
}