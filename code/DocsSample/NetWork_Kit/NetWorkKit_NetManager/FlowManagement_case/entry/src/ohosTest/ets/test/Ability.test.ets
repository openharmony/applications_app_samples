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

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

const DOMAIN = 0xF812; // 域值
const TAG = 'NetworkStatisticsTest'; // 日志标签
const BUNDLE = 'NETWORKSTATISTICS_';
const BUNDLENAME = 'com.samples.flowmanagement';
const DELAY_TIME = 3000; // 延迟时间
let driver: Driver = Driver.create();

export default function AbilityTest() {
  describe('NetworkStatisticsAbilityTest', () => {

    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动NetworkStatisticsDemo Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, begin');
      const want: Want = {
        bundleName: BUNDLENAME,
        abilityName: 'EntryAbility',
      };
      await delegator.startAbility(want);
      await driver.delayMs(DELAY_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('title'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001, end');
    });

    // 测试获取指定网卡实时下行流量数据
    it(BUNDLE + 'GetIfaceRxBytes_Test_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetIfaceRxBytes_Test_002, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetIfaceRxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetIfaceRxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      // 显示日志
      let loggerOutput = await driver.findComponent(ON.id('logger-output'));
      let result = await loggerOutput.getText();
      expect(result).assertContain('Interface wlan0 downstream traffic');
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetIfaceRxBytes_Test_002, end');
      done();
    });

    // 测试获取指定网卡实时上行流量数据
    it(BUNDLE + 'GetIfaceTxBytes_Test_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetIfaceTxBytes_Test_003, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetIfaceTxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetIfaceTxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      // 显示日志
      let loggerOutput = await driver.findComponent(ON.id('logger-output'));
      let result = await loggerOutput.getText();
      expect(result).assertContain('Interface wlan0 upstream traffic');
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetIfaceTxBytes_Test_003, end');
      done();
    });

    // 测试获取蜂窝实时下行流量数据
    it(BUNDLE + 'GetCellularRxBytes_Test_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetCellularRxBytes_Test_004, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetCellularRxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetCellularRxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetCellularRxBytes_Test_004, end');
      done();
    });

    // 测试获取蜂窝实时上行流量数据
    it(BUNDLE + 'GetCellularTxBytes_Test_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetCellularTxBytes_Test_005, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetCellularTxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetCellularTxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetCellularTxBytes_Test_005, end');
      done();
    });

    // 测试获取所有网卡实时下行流量数据
    it(BUNDLE + 'GetAllRxBytes_Test_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetAllRxBytes_Test_006, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetAllRxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetAllRxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      // 显示日志
      let loggerOutput = await driver.findComponent(ON.id('logger-output'));
      let result = await loggerOutput.getText();
      expect(result).assertContain('All interfaces downstream traffic');
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetAllRxBytes_Test_006, end');
      done();
    });

    // 测试获取所有网卡实时上行流量数据
    it(BUNDLE + 'GetAllTxBytes_Test_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetAllTxBytes_Test_007, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetAllTxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetAllTxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      // 显示日志
      let loggerOutput = await driver.findComponent(ON.id('logger-output'));
      let result = await loggerOutput.getText();
      expect(result).assertContain('All interfaces upstream traffic');
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetAllTxBytes_Test_007, end');
      done();
    });

    // 测试获取指定应用实时下行流量数据
    it(BUNDLE + 'GetUidRxBytes_Test_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetUidRxBytes_Test_008, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetUidRxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetUidRxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetUidRxBytes_Test_008, end');
      done();
    });

    // 测试获取指定应用实时上行流量数据
    it(BUNDLE + 'GetUidTxBytes_Test_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetUidTxBytes_Test_009, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetUidTxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetUidTxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetUidTxBytes_Test_009, end');
      done();
    });

    // 测试获取指定Socket实时下行流量数据
    it(BUNDLE + 'GetSockfdRxBytes_Test_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetSockfdRxBytes_Test_010, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetSockfdRxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetSockfdRxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetSockfdRxBytes_Test_010, end');
      done();
    });

    // 测试获取指定Socket实时上行流量数据
    it(BUNDLE + 'GetSockfdTxBytes_Test_011', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetSockfdTxBytes_Test_011, begin');
      await driver.delayMs(DELAY_TIME);
      await driver.assertComponentExist(ON.id('Button_GetSockfdTxBytes'));
      let button = await driver.findComponent(ON.id('Button_GetSockfdTxBytes'));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetSockfdTxBytes_Test_011, end');
      done();
    });
  });
}
