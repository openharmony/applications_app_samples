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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../utils/Logger';
import { Component, Driver, ON } from '@kit.TestKit';
import { beforeAll } from '@ohos/hypium';
import { describe } from '@ohos/hypium';
import { it } from '@ohos/hypium';

const TAG = '[Sample_NetworkObserver]';
const DELAY_MS_500: number = 500; // 指定500ms的延迟
const DELAY_MS_2000: number = 2000; // 指定2000ms的延迟

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      Logger.info(TAG, 'beforeAll begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.networkobserver',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        Logger.info(TAG, `beforeAll exception = ${JSON.stringify(err)}`);
      }
      await driver.delayMs(DELAY_MS_2000);
      Logger.info(TAG, 'beforeAll end');
      done();
    });

    const driver: Driver = Driver.create();

    // 查看页面显示是否正常，是否可以正常进行页面切换
    it('网络状态监听', 0, async (done: Function) => {
      await driver.assertComponentExist(ON.text('自动播放设置'));
      await driver.assertComponentExist(ON.id('id_network_status_observer_video'));

      const autoPlaySetting: Component = await driver.findComponent(ON.text('自动播放设置'));
      await driver.delayMs(DELAY_MS_500);
      await autoPlaySetting.click();
      await driver.delayMs(DELAY_MS_500);

      await driver.assertComponentExist(ON.text('自动播放设置'));
      await driver.assertComponentExist(ON.text('3G/4G/5G自动播放'));
      await driver.assertComponentExist(ON.id('id_network_status_observer_cellular_toggle'));
      await driver.assertComponentExist(ON.text('WI-FI自动播放'));
      await driver.assertComponentExist(ON.id('id_network_status_observer_wifi_toggle'));

      const cellularAutoPlay: Component =
        await driver.findComponent(ON.id('id_network_status_observer_cellular_toggle'));
      await driver.delayMs(DELAY_MS_500);
      await cellularAutoPlay.click();
      await driver.delayMs(DELAY_MS_500);
      const wifiAutoPlay: Component = await driver.findComponent(ON.id('id_network_status_observer_wifi_toggle'));
      await driver.delayMs(DELAY_MS_500);
      await wifiAutoPlay.click();
      await driver.delayMs(DELAY_MS_500);

      await driver.pressBack();
      await driver.delayMs(DELAY_MS_500);
      done();
    })
  })
}