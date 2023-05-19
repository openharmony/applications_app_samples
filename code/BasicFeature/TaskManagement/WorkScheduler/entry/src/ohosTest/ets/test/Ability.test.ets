/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import wifiManager from '@ohos.wifiManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import { Logger } from '../utils/Logger';

const DRIVER = Driver.create();

let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async (done) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      Logger.info('StartAbility_001 begin');
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.workschedulerextensionability',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      Logger.info('StartAbility_001 end');
    })

    /**
     * 检查版本
     */
    it('CheckoutVersion_001', 0, async () => {
      Logger.info('CheckoutVersion_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('version'));
      let version = await DRIVER.findComponent(ON.id('version'));
      // 断言当前版本为1.0
      expect((await version.getText()).split('：')[1]).assertEqual('1.0');
      Logger.info('CheckoutVersion_001 end');
    })

    /**
     * 控制wifi
     */
    it('ControlWifi_001', 0, async (done) => {
      Logger.info('ControlWifi_001 begin');
      // 如果没有打开wifi，就打开wifi
      if (!wifiManager.isWifiActive()) {
        wifiManager.enableWifi();
      } else {
        // 如果已经打开wifi了，就重新连接
        try {
          wifiManager.disableWifi();
        } catch (err) {
          Logger.info('disableWifi failed', `${JSON.stringify(err)}`);
        }
        await DRIVER.delayMs(5000);
        try {
          wifiManager.enableWifi();
        } catch (err) {
          Logger.info('enableWifi failed', `${JSON.stringify(err)}`);
        }
        await DRIVER.delayMs(5000);
      }
      Logger.info('ControlWifi_001 end');
      done();
    })

    /**
     * 更新sample
     */
    it('UpdateApp_001', 1, async () => {
      Logger.info('UpdateApp_001 begin');
      // 等待文件下载并保存
      await DRIVER.delayMs(12000);
      // 点击确定开始装包
      await DRIVER.assertComponentExist(ON.id('confirm'));
      let confirmBtn = await DRIVER.findComponent(ON.id('confirm'));
      await DRIVER.delayMs(1000);
      await confirmBtn.click();
      Logger.info('UpdateApp_001 end');
    })
  })
}