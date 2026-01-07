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

import { describe, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import { ComponentId } from '../../../main/ets/common/CommonConstant';
import Logger from '../../../main/ets/common/Logger';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

const BUNDLE = 'DNSCASE_';
const BUNDLE_NAME = 'com.samples.dns_case';
const ABILITY_NAME: string = 'EntryAbility';
const DELAY_MS = 3000;
let driver: Driver = Driver.create();

export default function AbilityTest() {
  describe('AbilityTest', () => {
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
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_TITLE));
      await driver.delayMs(DELAY_MS);
      done();
      Logger.info(`${BUNDLE}StartAbility_001 end`);
    })

    /**
     * @tc.number Ascii_case_001
     * @tc.name Ascii_case_001
     * @tc.desc 测试netHandle.getAddressByName获取中文域名的IP地址
     */
    it(BUNDLE + 'Ascii_case_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Ascii_case_001 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.ASCII_BTN));
      let button = await driver.findComponent(ON.id(ComponentId.ASCII_BTN));
      await button.click();
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.UN_CHANGE_GET_IPADDRESS));
      let stack = await driver.findComponent(ON.id(ComponentId.UN_CHANGE_GET_IPADDRESS));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Ascii_case_001 end`);
      done();
    })

    /**
     * @tc.number Ascii_case_002
     * @tc.name Ascii_case_002
     * @tc.desc 测试netHandle.getAddressByName获取中文域名转Ascii编码后的IP地址
     */
    it(BUNDLE + 'Ascii_case_002', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Ascii_case_002 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.GET_ASCII));
      let stack = await driver.findComponent(ON.id(ComponentId.GET_ASCII));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Ascii_case_002 end`);
      done();
    })

    /**
     * @tc.number Ascii_case_003
     * @tc.name Ascii_case_003
     * @tc.desc 测试Ascii编码转Unicode编码
     */
    it(BUNDLE + 'Ascii_case_003', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Ascii_case_003 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.GET_ASCII));
      let stack = await driver.findComponent(ON.id(ComponentId.GET_ASCII));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Ascii_case_003 end`);
      done();
    })

    /**
     * @tc.number Dns_case_001
     * @tc.name Dns_case_001
     * @tc.desc 测试connection.getAddressByName获取所有类型IP地址
     */
    it(BUNDLE + 'Dns_case_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Dns_case_001 begin`);
      await driver.pressBack();
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.DNS_BTN));
      let button = await driver.findComponent(ON.id(ComponentId.DNS_BTN));
      await button.click();
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.GET_ADDRESS_BY_NAME));
      let stack = await driver.findComponent(ON.id(ComponentId.GET_ADDRESS_BY_NAME));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Dns_case_001 end`);
      done();
    })

    /**
     * @tc.number Dns_case_002
     * @tc.name Dns_case_002
     * @tc.desc 测试connection.getAddressesByNameWithOptions获取IPV4类型地址
     */
    it(BUNDLE + 'Dns_case_002', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Dns_case_002 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.GET_ADDRESS_BY_NAME_WITH_OPTIONS));
      let stack = await driver.findComponent(ON.id(ComponentId.GET_ADDRESS_BY_NAME_WITH_OPTIONS));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Dns_case_002 end`);
      done();
    })

    /**
     * @tc.number Dns_case_003
     * @tc.name Dns_case_003
     * @tc.desc 测试netHandle.getAddressesByNameWithOptions获取IPV4类型地址
     */
    it(BUNDLE + 'Dns_case_003', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Dns_case_003 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.NET_HANDLE));
      let stack = await driver.findComponent(ON.id(ComponentId.NET_HANDLE));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Dns_case_003 end`);
      done();
    })

  })
}