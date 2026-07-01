/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const TAG = '[Sample_DistributedSoftbusConversation]';
const DOMAIN = 0xF811;
const BUNDLE = 'DistributedSoftbusConversation_';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用，处理权限弹窗，验证主界面加载成功
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      const driver = Driver.create();
      await delegator.startAbility(want);
      await driver.delayMs(2000);

      // 处理权限弹窗，应用申请了DISTRIBUTED_DATASYNC和ACCESS_UDID两个权限
      try {
        let btnAllow = await driver.findComponent(ON.text('允许'));
        if (btnAllow !== null) {
          await btnAllow.click();
          hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, clicked allow 1');
          await driver.delayMs(2000);
        }
      } catch (e) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, no permission dialog 1');
      }
      try {
        let btnAllow = await driver.findComponent(ON.text('允许'));
        if (btnAllow !== null) {
          await btnAllow.click();
          hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, clicked allow 2');
          await driver.delayMs(2000);
        }
      } catch (e) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, no permission dialog 2');
      }
      await driver.delayMs(1000);

      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, abilityName: ' + ability.context.abilityInfo.name);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, end');
      done();
    });

    /**
     * 验证页面标题显示
     */
    it(BUNDLE + 'PageTitle_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTitle_001, begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Distributed SoftBus Conversation Test'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'PageTitle_001, end');
      done();
    });

    /**
     * 点击"Get Trusted Devices"按钮，验证获取可信设备功能不出现异常
     */
    it(BUNDLE + 'GetTrustedDevices_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetTrustedDevices_001, begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const btn = await driver.findComponent(ON.text('Get Trusted Devices'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetTrustedDevices_001, btn found: ' + (btn !== null));
      if (btn !== null) {
        await btn.click();
        await driver.delayMs(1000);
      }
      expect(btn !== null).assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetTrustedDevices_001, end');
      done();
    });

    /**
     * 点击"Register Listener"按钮，验证注册监听器功能不出现异常
     */
    it(BUNDLE + 'RegisterListener_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RegisterListener_001, begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const btn = await driver.findComponent(ON.text('Register Listener'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'RegisterListener_001, btn found: ' + (btn !== null));
      if (btn !== null) {
        await btn.click();
        await driver.delayMs(1000);
      }
      expect(btn !== null).assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'RegisterListener_001, end');
      done();
    });

    /**
     * 点击"Unregister Listener"按钮，验证注销监听器功能不出现异常
     */
    it(BUNDLE + 'UnregisterListener_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UnregisterListener_001, begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const btn = await driver.findComponent(ON.text('Unregister Listener'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'UnregisterListener_001, btn found: ' + (btn !== null));
      if (btn !== null) {
        await btn.click();
        await driver.delayMs(1000);
      }
      expect(btn !== null).assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UnregisterListener_001, end');
      done();
    });

    /**
     * 点击"Send Message"按钮，验证发送消息功能不出现异常
     */
    it(BUNDLE + 'SendMessage_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessage_001, begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const btn = await driver.findComponent(ON.text('Send Message'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessage_001, btn found: ' + (btn !== null));
      if (btn !== null) {
        await btn.click();
        await driver.delayMs(1000);
      }
      expect(btn !== null).assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessage_001, end');
      done();
    });
  });
}
