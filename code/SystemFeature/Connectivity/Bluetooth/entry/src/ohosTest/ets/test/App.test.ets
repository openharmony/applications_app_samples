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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import bluetoothManager from '@ohos.bluetoothManager';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import UIAbility from '@ohos.app.ability.UIAbility';
import Logger from '../util/Logger';

const TAG = 'AppTest';
const BUNDLE = 'Bluetooth_';
let driver: Driver = Driver.create();
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
let ability: UIAbility;

export default function appTest() {
  describe('appTest', function () {
    // 启动应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, `${BUNDLE}StartAbility start`);
      let want = {
        bundleName: 'ohos.samples.bluetooth',
        abilityName: 'MainAbility'
      }
      abilityDelegatorRegistry.startAbility(want, (err) => {
        Logger.info(TAG, `${BUNDLE}StartAbility get err ${JSON.stringify(err)}`);
        done();
      });
      ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      Logger.info(TAG, `${BUNDLE}StartAbility end`);
    });
    // 打开蓝牙
    it(`${BUNDLE}OpenBlueTooth_001`, 0, async () => {
      Logger.info(TAG, `${BUNDLE}OpenBlueTooth_001 begin`);
      await driver.delayMs(3000);
      // 点击允许，应用获取设备位置
      let resourceManager = ability.context.resourceManager;
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.only_accept_during_use'))));
      let addBtn = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.only_accept_during_use'))));
      await driver.delayMs(1000);
      await addBtn.click();
      await driver.delayMs(1000);
      // 打开蓝牙开关
      try {
        let blueToothState = bluetoothManager.getState();
        if (!blueToothState) {
          await driver.assertComponentExist(ON.id('toggleBtn'));
          let blueTooth = await driver.findComponent(ON.id('toggleBtn'));
          await driver.delayMs(1000);
          await blueTooth.click();
          await driver.delayMs(3000);
          blueToothState = bluetoothManager.getState();
          await driver.delayMs(3000);
          if(!blueToothState){
            Logger.info(TAG,'Failed to open');
            expect().assertFail();
          }
        }
      } catch (err) {
        Logger.error(TAG, `Abnormal opening of Bluetooth, err:${JSON.stringify(err)}`);
      }
      Logger.info(TAG, `${BUNDLE}OpenBlueTooth_001 end`);
    })
    // 匹配设备
    it(`${BUNDLE}MatchingDevices_001`, 0, async () => {
      Logger.info(TAG, `${BUNDLE}MatchingDevices_001 begin`);
      await driver.delayMs(3000);
      // 获取识别到的数据
      if(await driver.findComponent(ON.id(`pairedDevice0`))){
        let pairedDevice = await driver.findComponent(ON.id(`pairedDevice0`));
        await driver.delayMs(1000);
        await pairedDevice.click();
        await driver.delayMs(1000);
        let resourceManager = ability.context.resourceManager;
        if(await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.match_request'))))){
          await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.match'))));
          let pairBtn = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.match'))));
          await driver.delayMs(1000);
          await pairBtn.click();
        }
      }
      Logger.info(TAG, `${BUNDLE}MatchingDevices_001 end`);
    })
  })
}