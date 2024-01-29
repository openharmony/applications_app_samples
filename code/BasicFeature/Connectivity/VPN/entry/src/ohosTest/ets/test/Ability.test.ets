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
import { describe, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

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
    it('startAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'startAbility_001 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await startAbility();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'startAbility_001 end');
      done();
    });

    /**
     * 进入首页,标题显示正确
     */
    it('IndexPageEnter_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'IndexPageEnter_001 start');
      let driver: Driver = Driver.create();
      await terminateAbility();
      await driver.delayMs(1000);
      await startAbility();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Toy VPN'));
      let titleComponent = await driver.findComponent(ON.text('Toy VPN'));
      let titleContent = await titleComponent.getText();
      await driver.delayMs(200);
      expect('Toy VPN').assertEqual(titleContent);
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, 'IndexPageEnter_001 end');
      done();
    });

    /**
     * 在主界面启用VPN
     */
    it('StartVpn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'StartVpn_001 start');
      let driver = Driver.create();
      await terminateAbility();
      await driver.delayMs(1000);
      await startAbility();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Start VPN'));
      let startVpn = await driver.findComponent(ON.text('Start VPN'));
      await driver.delayMs(200);
      await startVpn.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, 'StartVpn_001 end');
      done();
    });

    /**
     * 在主界面启用VPN后，再创建隧道
     */
    it('CreateTunnel_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'CreateTunnel_001 start');
      let driver = Driver.create();
      await terminateAbility();
      await driver.delayMs(1000);
      await startAbility();
      await driver.delayMs(1000);
      // 点击启用VPN
      await driver.assertComponentExist(ON.text('Start VPN'));
      let startVpn = await driver.findComponent(ON.text('Start VPN'));
      await driver.delayMs(200);
      await startVpn.click();
      // 点击创建隧道
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('创建对象'));
      let createTunnel = await driver.findComponent(ON.text('创建对象'));
      await driver.delayMs(200);
      await createTunnel.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, 'CreateTunnel_001 end');
      done();
    });

    /**
     * 启用VPN后开启隧道保护
     */
    it('StartTunnelProtect_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'StartTunnelProtect_001 start');
      let driver = Driver.create();
      await terminateAbility();
      await driver.delayMs(1000);
      await startAbility();
      await driver.delayMs(1000);
      // 点击启用VPN
      await driver.assertComponentExist(ON.text('Start VPN'));
      let startVpn = await driver.findComponent(ON.text('Start VPN'));
      await driver.delayMs(200);
      await startVpn.click();
      // 点击开启隧道保护
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('隧道保护'));
      let protect = await driver.findComponent(ON.text('隧道保护'));
      await driver.delayMs(200);
      await protect.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, 'StartTunnelProtect_001 end');
      done();
    });

    /**
     * 启用VPN后启动VPN连接
     */
    it('SetupVpn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'SetupVpn_001 start');
      let driver = Driver.create();
      await terminateAbility();
      await driver.delayMs(1000);
      await startAbility();
      await driver.delayMs(1000);
      // 点击启用VPN
      await driver.assertComponentExist(ON.text('Start VPN'));
      let startVpn = await driver.findComponent(ON.text('Start VPN'));
      await driver.delayMs(200);
      await startVpn.click();
      // 点击开启vpn
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('启动vpn'));
      let setupVpn = await driver.findComponent(ON.text('启动vpn'));
      await setupVpn.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, 'SetupVpn_001 end');
      done();
    });

    /**
     * 停用VPN
     */
    it('StopVpn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'StopVpn_001 start');
      let driver = Driver.create();
      await terminateAbility();
      await driver.delayMs(1000);
      await startAbility();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Stop VPN'));
      let stopVpn = await driver.findComponent(ON.text('Stop VPN'));
      await stopVpn.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, 'StopVpn_001 end')
      done();
    });

    /**
     * 关闭VPN连接
     */
    it('CloseVpn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'CloseVpn_001 start');
      let driver = Driver.create();
      await terminateAbility();
      await driver.delayMs(1000);
      await startAbility();
      await driver.delayMs(1000);
      // 点击停用VPN
      await driver.assertComponentExist(ON.text('Stop VPN'));
      let stopVpn = await driver.findComponent(ON.text('Stop VPN'));
      await stopVpn.click();
      // 点击关闭VPN
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('关闭vpn'));
      let closeVpn = await driver.findComponent(ON.text('关闭vpn'));
      await closeVpn.click();
      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, 'CloseVpn_001 end');
      done();
    });
  });
}

/**
 * 拉起应用
 */
async function startAbility() {
  try {
    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    await abilityDelegator.startAbility({
      bundleName: "com.example.testvpnclient",
      abilityName: "EntryAbility"
    });
  } catch (err) {
    hilog.info(DOMAIN, TAG, 'startAbility err');
  }
}

/**
 * 关闭应用
 */
async function terminateAbility() {
  try {
    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    let topAbility = await abilityDelegator.getCurrentTopAbility();
    await topAbility.context.terminateSelf();
  } catch (err) {
    hilog.info(DOMAIN, TAG, 'terminateAbility err');
  }
}

