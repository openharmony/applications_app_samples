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
import { describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';


const DELAY_SHORT = 1000; // 短时间延迟
const DELAY_MEDIUM = 3000; // 正常时间延迟
const DELAY_LONG = 5000; // 长时间延迟

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const DOMAIN = 0xF811; // 域值
const TAG = 'WebSocketCaseTest'; // 日志标签
const BUNDLE = 'WebSocketCASE_';
const BUNDLENAME = 'com.samples.websocket';
let driver: Driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */

    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      const want: Want = {
        bundleName: BUNDLENAME,
        abilityName: 'EntryAbility'
      }
      await delegator.startAbility(want);
      await driver.delayMs(DELAY_MEDIUM);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * @tc.number WebSocket_case_001
     * @tc.name WebSocket_case_001
     * @tc.desc 测试 连接 WebSocket 按钮
     */
    it(BUNDLE + 'WebSocket_case_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'WebSocket_case_001 begin');
      await driver.delayMs(DELAY_SHORT);
      await driver.assertComponentExist(ON.id('Connect_WebSocket'));
      let stack = await driver.findComponent(ON.id('Connect_WebSocket'));
      await stack.click();
      await driver.delayMs(DELAY_LONG * 2);
      // 验证界面上是否显示了"通过"或"失败"
      let resultText = await driver.findComponent(ON.id('connectionStatus')); // 或者 ON.text('失败')
      let result = await resultText.getText();
      expect(result).assertContain('Connected');
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'WebSocket_case_001 end');
      done();
    });

    /**
     * @tc.number WebSocket_case_002
     * @tc.name WebSocket_case_002
     * @tc.desc 测试 发送消息 按钮
     */
    it(BUNDLE + 'WebSocket_case_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'WebSocket_case_002 begin');
      await driver.delayMs(DELAY_MEDIUM);
      await driver.assertComponentExist(ON.id('SendMessage'));
      let stack = await driver.findComponent(ON.id('SendMessage'));
      await stack.click();
      await driver.delayMs(DELAY_LONG);
      // 验证界面上是否显示了 消息发送成功
      let resultText = await driver.findComponent(ON.id('sendMessageResult')); // 或者 ON.text('失败')
      let result = await resultText.getText();
      expect(result).assertContain('Message sent successfully');
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'WebSocket_case_002 end');
      done();
    })

    /**
     * @tc.number WebSocket_case_003
     * @tc.name WebSocket_case_003
     * @tc.desc 测试 断开连接 按钮
     */
    it(BUNDLE + 'WebSocket_case_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'WebSocket_case_0023begin');
      await driver.delayMs(DELAY_MEDIUM);
      await driver.assertComponentExist(ON.id('DisConnect'));
      let stack = await driver.findComponent(ON.id('DisConnect'));
      await stack.click();
      await driver.delayMs(DELAY_MEDIUM);
      // 验证界面上是否显示了 消息发送成功
      let resultText = await driver.findComponent(ON.id('closeConnection')); // 或者 ON.text('失败')
      let result = await resultText.getText();
      expect(result).assertContain('Connection closed successfully');
      hilog.info(DOMAIN, TAG, BUNDLENAME + 'WebSocket_case_003 end');
      done();
    })
  })
}