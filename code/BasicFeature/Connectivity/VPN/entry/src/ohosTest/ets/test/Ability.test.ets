/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const BUNDLE = 'VpnConnect_';
const TAG = '[Sample_VpnConnect]';
const DOMAIN = 0xF811;

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}
export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 启动Ability
     */
    it(BUNDLE + 'startAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'startAbility_001 start');
      try {
        await abilityDelegator.startAbility({
          bundleName: "com.samples.testvpnclient",
          abilityName: "EntryAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'startAbility_001 end');
    });

    /**
     * 进入首页
     */
    it(BUNDLE + 'IndexPageEnter_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'IndexPageEnter_001 start');
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.app_name')), MatchPattern.CONTAINS));
      let titleComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.app_name')), MatchPattern.CONTAINS));
      let titleContent = await titleComponent.getText();
      await driver.delayMs(200);
      expect(await getResourceString($r('app.string.app_name'))).assertEqual(titleContent);
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'IndexPageEnter_001 end');
    });

    /**
     * 启用VNP
     */
    it(BUNDLE + 'StartVpn_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartVpn_001 start');
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('Start VPN'));
      let startVpn = await driver.findComponent(ON.text('Start VPN'));
      await driver.delayMs(200);
      await startVpn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartVpn_001 end');
    });

    /**
     * 启用VPN后创建隧道
     */
    it(BUNDLE + 'CreateTunnel_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartTunnelProtect_001 start');
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('创建对象'));
      let createTunnel = await driver.findComponent(ON.text('创建对象'));
      await driver.delayMs(200);
      await createTunnel.click();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateTunnel_001 end');
    });

    /**
     * 启用VPN后开启隧道保护
     */
    it(BUNDLE + 'StartTunnelProtect_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartTunnelProtect_001 start');
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('隧道保护'));
      let protect = await driver.findComponent(ON.text('隧道保护'));
      await driver.delayMs(200);
      await protect.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartTunnelProtect_001 end');
    });

    /**
     * 启用VPN后启动VPN连接
     */
    it(BUNDLE + 'SetupVpn_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SetupVpn_001 start');
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('启动vpn'));
      let setupVpn = await driver.findComponent(ON.text('启动vpn'));
      await setupVpn.click();
      await driver.delayMs(200);
    });

    /**
     * 停用VPN
     */
    it(BUNDLE + 'StopVpn_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopVpn_001 start');
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('Stop VPN'));
      let stopVpn = await driver.findComponent(ON.text('Stop VPN'));
      await stopVpn.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopVpn_001 end');
    });

    /**
     * 关闭VPN连接
     */
    it(BUNDLE + 'CloseVpn_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseVpn_001 start');
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('关闭vpn'));
      let closeVpn = await driver.findComponent(ON.text('关闭vpn'));
      await closeVpn.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseVpn_001 end');
    });
  });
}
