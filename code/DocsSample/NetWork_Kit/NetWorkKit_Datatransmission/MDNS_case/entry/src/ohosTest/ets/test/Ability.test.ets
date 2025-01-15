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

import { describe, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import Logger from '../../../main/ets/common/Logger';
import { ComponentId } from '../../../main/ets/common/ComponentId';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

const BUNDLE: string = 'MDNSCASE';
const BUNDLE_NAME: string = 'com.samples.mdns_case';
const ABILITY_NAME: string = 'EntryAbility';

const delayTime: number = 2000;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    it(BUNDLE + 'assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      Logger.info('it begin');
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    })


    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE}StartAbility_001 begin`);
      const want: Want = {
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME
      };
      await delegator.startAbility(want);
      await sleep(delayTime);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual(ABILITY_NAME);
      done();
      Logger.info(`${BUNDLE}StartAbility_001 end`);
    });

    /**
     * @tc.number Mdns_StartDiscovery_001
     * @tc.name Mdns_StartDiscovery_001
     * @tc.desc 测试启动 mDNS 服务发现按钮
     */
    it(BUNDLE + 'Mdns_StartDiscovery_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME} Mdns_StartDiscovery_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(delayTime);
      await driver.assertComponentExist(ON.id(ComponentId.START_DISCOVERY_SERVICE_BTN));

      let stack = await driver.findComponent(ON.id(ComponentId.START_DISCOVERY_SERVICE_BTN));
      await stack.click();
      await driver.delayMs(delayTime);

      let str = await getResourceString($r('app.string.mDNS_Start'));
      let resultText = await driver.findComponent(ON.id(ComponentId.SERVICE_DISCOVERY_STATUS));
      let result = await resultText.getText();
      expect(result).assertEqual(str);

      Logger.info(`${BUNDLE_NAME} Mdns_StartDiscovery_001 end`);
      done();
    });

    /**
     * @tc.number Mdns_AddLocalService_001
     * @tc.name Mdns_AddLocalService_001
     * @tc.desc 测试添加本地服务按钮
     */
    it(BUNDLE + 'Mdns_AddLocalService_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME} Mdns_AddLocalService_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(delayTime);
      await driver.assertComponentExist(ON.id(ComponentId.ADD_SERVICE_BTN));

      let stack = await driver.findComponent(ON.id(ComponentId.ADD_SERVICE_BTN));
      await stack.click();
      await driver.delayMs(delayTime);

      let str = await getResourceString($r('app.string.Add_Status'));
      let resultText = await driver.findComponent(ON.id(ComponentId.SERVICE_ADD_STATUS));
      let result = await resultText.getText();
      expect(result).assertEqual(str);

      Logger.info(`${BUNDLE_NAME} Mdns_AddLocalService_001 end`);
      done();
    });

    /**
     * @tc.number Mdns_ResolveLocalService_001
     * @tc.name Mdns_ResolveLocalService_001
     * @tc.desc 测试解析本地服务按钮
     */
    it(BUNDLE + 'Mdns_ResolveLocalService_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME} Mdns_ResolveLocalService_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(delayTime);
      await driver.assertComponentExist(ON.id(ComponentId.RESOLVE_SERVICE_BTN));

      let stack = await driver.findComponent(ON.id(ComponentId.RESOLVE_SERVICE_BTN));
      await stack.click();
      await driver.delayMs(delayTime);

      let str = await getResourceString($r('app.string.Parse_Status'));
      let resultText = await driver.findComponent(ON.id(ComponentId.SERVICE_RESOLVE_STATUS));
      let result = await resultText.getText();

      expect(result).assertEqual(str);

      Logger.info(`${BUNDLE_NAME} Mdns_ResolveLocalService_001 end`);
      done();
    });

    /**
     * @tc.number Mdns_RemoveLocalService_001
     * @tc.name Mdns_RemoveLocalService_001
     * @tc.desc 测试移除本地服务按钮
     */
    it(BUNDLE + 'Mdns_RemoveLocalService_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME} Mdns_RemoveLocalService_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(delayTime);
      await driver.assertComponentExist(ON.id(ComponentId.REMOVE_SERVICE_BTN));

      let stack = await driver.findComponent(ON.id(ComponentId.REMOVE_SERVICE_BTN));
      await stack.click();
      await driver.delayMs(delayTime);

      let str = await getResourceString($r('app.string.Remove_Status'));
      let resultText = await driver.findComponent(ON.id(ComponentId.SERVICE_REMOVE_STATUS));
      let result = await resultText.getText();

      expect(result).assertEqual(str);

      Logger.info(`${BUNDLE_NAME} Mdns_RemoveLocalService_001 end`);
      done();
    });

    /**
     * @tc.number Mdns_StopDiscovery_001
     * @tc.name Mdns_StopDiscovery_001
     * @tc.desc 测试停止 mDNS 服务发现按钮
     */
    it(BUNDLE + 'Mdns_StopDiscovery_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME } Mdns_StopDiscovery_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(delayTime);
      await driver.assertComponentExist(ON.id(ComponentId.STOP_DISCOVERY_SERVICE_BTN));

      let stack = await driver.findComponent(ON.id(ComponentId.STOP_DISCOVERY_SERVICE_BTN));
      await stack.click();
      await driver.delayMs(delayTime);

      let str = await getResourceString($r('app.string.mDNS_Stop'));
      let resultText = await driver.findComponent(ON.id(ComponentId.SERVICE_DISCOVERY_STATUS));
      let result = await resultText.getText();

      expect(result).assertEqual(str);

      Logger.info(`${BUNDLE_NAME } Mdns_StopDiscovery_001 end`);
      done();
    });
  })
}