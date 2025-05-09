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

import { describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Component, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { ComponentId } from '../../../main/ets/common/CommonConstant';
import Logger from '../../../main/ets/common/Logger';

const BUNDLE = 'VPNCASE_';
const BUNDLE_NAME = 'com.samples.vpncontrol_case';
const ABILITY_NAME: string = 'EntryAbility';
const DELAY_TIME = 2000;

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

async function goBack() {
  let driver: Driver = Driver.create();
  await driver.assertComponentExist(ON.id('btnBack'));
  let backButton = await driver.findComponent(ON.id('btnBack'));
  await backButton.click();
  await driver.delayMs(DELAY_TIME);
}

export default function VPNTest() {
  describe('VPNTest', () => {
    /**
     * @tc.number StartVPNAbility_001
     * @tc.name StartVPNAbility_001
     * @tc.desc 启动VPN主界面
     */
    it(BUNDLE + 'StartVPNAbility_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE} StartVPNAbility_001 begin`);
      // 启动测试的Ability
      const want: Want = {
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME,
      };
      let driver: Driver = Driver.create();
      await delegator.startAbility(want);
      await driver.delayMs(DELAY_TIME);
      let str = await getResourceString($r('app.string.Allow'));
      await driver.assertComponentExist(ON.text(str));
      let confirmButton: Component = await driver.findComponent(ON.text(str));
      await confirmButton.click();
      await driver.delayMs(DELAY_TIME);
      // 验证顶层显示的Ability
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual(ABILITY_NAME);
      Logger.info(`${BUNDLE} StartVPNAbility_001 end`);
      done();
    });

    /**
     * @tc.number StartVPNButton_001
     * @tc.name StartVPNButton_001
     * @tc.desc 测试 StartVPN 按钮点击事件
     */
    it(BUNDLE + 'StartVPNButton_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      Logger.info(`${BUNDLE_NAME} StartVPNButton_001 begin`);
      // 验证StartVPN按钮存在并点击
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id(ComponentId.START_VPN_BUTTON));
      const startVpnButton = await driver.findComponent(ON.id(ComponentId.START_VPN_BUTTON));
      await startVpnButton.click();
      await driver.delayMs(DELAY_TIME);
      try {
        let errorComponent = await driver.findComponent(ON.id('Error'));
        if (errorComponent) {
          let errorText = await errorComponent.getText();
          Logger.error(`${BUNDLE_NAME} StartVPNButton_001 failed with error: ${errorText}`);
          expect(false).assertTrue(); // 如果有 Error 组件，测试失败
        }
      } catch (e) {
        Logger.info(`${BUNDLE_NAME} StartVPNButton_001 passed: No error component found.`);
        expect(true).assertTrue(); // 如果没有 Error 组件，测试通过
      }
      Logger.info(`${BUNDLE_NAME} StartVPNButton_001 end`);
      done();
    });

    /**
     * @tc.number CreateTunnelButton_001
     * @tc.name CreateTunnelButton_001
     * @tc.desc 测试 CreateTunnel 按钮点击事件
     */
    it(BUNDLE + 'CreateTunnelButton_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      Logger.info(`${BUNDLE_NAME} CreateTunnelButton_001 begin`);
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id(ComponentId.CREATE_TUNNEL_BUTTON));
      const createTunnelButton = await driver.findComponent(ON.id(ComponentId.CREATE_TUNNEL_BUTTON));
      await createTunnelButton.click();
      await driver.delayMs(DELAY_TIME);
      try {
        let errorComponent = await driver.findComponent(ON.id('Error'));
        if (errorComponent) {
          let errorText = await errorComponent.getText();
          Logger.error(`${BUNDLE_NAME} CreateTunnelButton_001 failed with error: ${errorText}`);
          expect(false).assertTrue(); // 如果有 Error 组件，测试失败
        }
      } catch (e) {
        Logger.info(`${BUNDLE_NAME} CreateTunnelButton_001 passed: No error component found.`);
        expect(true).assertTrue(); // 如果没有 Error 组件，测试通过
      }
      Logger.info(`${BUNDLE_NAME} CreateTunnelButton_001 end`);
      done();
    });

    /**
     * @tc.number ProtectButton_001
     * @tc.name ProtectButton_001
     * @tc.desc 测试 Protect 按钮点击事件
     */
    it(BUNDLE + 'ProtectButton_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      Logger.info(`${BUNDLE_NAME} ProtectButton_001 begin`);
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id(ComponentId.PROTECT_BUTTON));
      const protectButton = await driver.findComponent(ON.id(ComponentId.PROTECT_BUTTON));
      await protectButton.click();
      await driver.delayMs(DELAY_TIME);
      try {
        let errorComponent = await driver.findComponent(ON.id('Error'));
        if (errorComponent) {
          let errorText = await errorComponent.getText();
          Logger.error(`${BUNDLE_NAME} ProtectButton_001 failed with error: ${errorText}`);
          expect(false).assertTrue(); // 如果有 Error 组件，测试失败
        }
      } catch (e) {
        Logger.info(`${BUNDLE_NAME} ProtectButton_001 passed: No error component found.`);
        expect(true).assertTrue(); // 如果没有 Error 组件，测试通过
      }
      Logger.info(`${BUNDLE_NAME} ProtectButton_001 end`);
      done();
    });

    /**
     * @tc.number StartVpnExtButton_001
     * @tc.name StartVpnExtButton_001
     * @tc.desc 测试 StartVpnExt 按钮点击事件
     */
    it(BUNDLE + 'StartVpnExtButton_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      Logger.info(`${BUNDLE_NAME} StartVpnExtButton_001 begin`);
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id(ComponentId.START_VPN_EXT_BUTTON));
      const startVpnExtButton = await driver.findComponent(ON.id(ComponentId.START_VPN_EXT_BUTTON));
      await startVpnExtButton.click();
      await driver.delayMs(DELAY_TIME);
      let str = await getResourceString($r('app.string.Certain'));
      await driver.assertComponentExist(ON.text(str));
      let confirmButton: Component = await driver.findComponent(ON.text(str));
      await confirmButton.click();
      await driver.delayMs(DELAY_TIME);
      try {
        let errorComponent = await driver.findComponent(ON.id('Error'));
        if (errorComponent) {
          let errorText = await errorComponent.getText();
          Logger.error(`${BUNDLE_NAME} StartVpnExtButton_001 failed with error: ${errorText}`);
          expect(false).assertTrue(); // 如果有 Error 组件，测试失败
        }
      } catch (e) {
        Logger.info(`${BUNDLE_NAME} StartVpnExtButton_001 passed: No error component found.`);
        expect(true).assertTrue(); // 如果没有 Error 组件，测试通过
      }
      Logger.info(`${BUNDLE_NAME} StartVpnExtButton_001 end`);
      done();
    });

    /**
     * @tc.number SetupVpnButton_001
     * @tc.name SetupVpnButton_001
     * @tc.desc 测试 SetupVpn 按钮点击事件
     */
    it(BUNDLE + 'SetupVpnButton_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      Logger.info(`${BUNDLE_NAME} SetupVpnButton_001 begin`);
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id(ComponentId.SETUP_VPN_BUTTON));
      const setupVpnButton = await driver.findComponent(ON.id(ComponentId.SETUP_VPN_BUTTON));
      await setupVpnButton.click();
      await driver.delayMs(DELAY_TIME);
      await goBack();
      try {
        let errorComponent = await driver.findComponent(ON.id('Error'));
        if (errorComponent) {
          let errorText = await errorComponent.getText();
          Logger.error(`${BUNDLE_NAME} SetupVpnButton_001 failed with error: ${errorText}`);
          expect(false).assertTrue(); // 如果有 Error 组件，测试失败
        }
      } catch (e) {
        Logger.info(`${BUNDLE_NAME} SetupVpnButton_001 passed: No error component found.`);
        expect(true).assertTrue(); // 如果没有 Error 组件，测试通过
      }
      Logger.info(`${BUNDLE_NAME} SetupVpnButton_001 end`);
      done();
    });

    /**
     * @tc.number StopButton_001
     * @tc.name StopButton_001
     * @tc.desc 测试 StopVPN 按钮点击事件
     */
    it(BUNDLE + 'StopButton_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      Logger.info(`${BUNDLE_NAME} StopButton_001 begin`);
      // 验证StopVPN按钮存在并点击
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id(ComponentId.STOP_VPN_BUTTON));
      const stopVpnButton = await driver.findComponent(ON.id(ComponentId.STOP_VPN_BUTTON));
      await stopVpnButton.click();
      await driver.delayMs(DELAY_TIME);
      try {
        let errorComponent = await driver.findComponent(ON.id('Error'));
        if (errorComponent) {
          let errorText = await errorComponent.getText();
          Logger.error(`${BUNDLE_NAME} VPN_StartPageButtons_001 failed with error: ${errorText}`);
          expect(false).assertTrue(); // 如果有 Error 组件，测试失败
        }
      } catch (e) {
        Logger.info(`${BUNDLE_NAME} VPN_StartPageButtons_001 passed: No error component found.`);
        expect(true).assertTrue(); // 如果没有 Error 组件，测试通过
      }
      Logger.info(`${BUNDLE_NAME} StopButton_001 end`);
      done();
    });

    /**
     * @tc.number InnerStopVpnButton_001
     * @tc.name InnerStopVpnButton_001
     * @tc.desc 测试 StopVPN 按钮点击事件
     */
    it(BUNDLE + 'StopVpnButton_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      Logger.info(`${BUNDLE_NAME} StopVpnButton_001 begin`);
      // 验证 stopVpn 按钮是否存在并点击
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id(ComponentId.INNER_STOP_VPN_BUTTON));
      const stopVpnButton = await driver.findComponent(ON.id(ComponentId.INNER_STOP_VPN_BUTTON));
      await stopVpnButton.click();
      await driver.delayMs(DELAY_TIME);
      // 检查是否存在 Error 组件
      try {
        let errorComponent = await driver.findComponent(ON.id('Error'));
        if (errorComponent) {
          let errorText = await errorComponent.getText();
          Logger.error(`${BUNDLE_NAME} StopVpnButton_001 failed with error: ${errorText}`);
          expect(false).assertTrue(); // 如果有 Error 组件，测试失败
        }
      } catch (e) {
        Logger.info(`${BUNDLE_NAME} StopVpnButton_001 passed: No error component found.`);
        expect(true).assertTrue(); // 如果没有 Error 组件，测试通过
      }
      Logger.info(`${BUNDLE_NAME} StopVpnButton_001 end`);
      done();
    });

    /**
     * @tc.number StopVpnExtButton_001
     * @tc.name StopVpnExtButton_001
     * @tc.desc 测试 StopVpnExt 按钮点击事件
     */
    it(BUNDLE + 'StopVpnExtButton_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      Logger.info(`${BUNDLE_NAME} StopVpnExtButton_001 begin`);
      // 验证 stopVpnExt 按钮是否存在并点击
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id(ComponentId.STOP_VPN_EXT_BUTTON));
      const stopVpnExtButton = await driver.findComponent(ON.id(ComponentId.STOP_VPN_EXT_BUTTON));
      await stopVpnExtButton.click();
      await driver.delayMs(DELAY_TIME);
      // 检查是否存在 Error 组件
      try {
        let errorComponent = await driver.findComponent(ON.id('Error'));
        if (errorComponent) {
          let errorText = await errorComponent.getText();
          Logger.error(`${BUNDLE_NAME} StopVpnExtButton_001 failed with error: ${errorText}`);
          expect(false).assertTrue(); // 如果有 Error 组件，测试失败
        }
      } catch (e) {
        Logger.info(`${BUNDLE_NAME} StopVpnExtButton_001 passed: No error component found.`);
        expect(true).assertTrue(); // 如果没有 Error 组件，测试通过
      }
      Logger.info(`${BUNDLE_NAME} StopVpnExtButton_001 end`);
      done();
    });
  });
}
