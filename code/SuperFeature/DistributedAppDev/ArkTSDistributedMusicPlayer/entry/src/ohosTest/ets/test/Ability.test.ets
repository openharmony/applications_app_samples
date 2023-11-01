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

import { describe, it } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../../../main/ets/model/Logger';
import UIAbility from '@ohos.app.ability.UIAbility';

const TAG: string = '[Sample_DistributedMusicPlayer]';
const BUNDLE = 'DistributedMusicPlayer_';
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let ability: UIAbility;

async function controlMusicPlay() {
  Logger.info(TAG, `${BUNDLE}controlMusicPlay begin`);
  let driver = Driver.create();
  await driver.delayMs(200);
  await driver.assertComponentExist(ON.id('image3'));
  let btnPlay = await driver.findComponent(ON.id('image3'));
  await btnPlay.click();
  await driver.delayMs(200);
  Logger.info(TAG, `${BUNDLE}controlMusicPlay end`);
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.distributedmusicplayer',
          abilityName: 'MainAbility'
        })
        done();
      } catch (expection) {
        Logger.info(TAG, `StartAbility end ${JSON.stringify(expection)}`);
        done();
      }
      ability = await abilityDelegator.getCurrentTopAbility();
      Logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
    })

    /**
     * 点击允许，授权使用多设备协同
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async () => {
      Logger.info(TAG, `${BUNDLE}RequestPermissionFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(2000);
      // 获取通讯录访问权限
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 requestPermission');
      let resourceManager = ability.context.resourceManager;
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.accept'))));
      let btnAccept = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.accept'))));
      await driver.delayMs(200);
      await btnAccept.click();
      await driver.delayMs(200);
      Logger.info(TAG, `${BUNDLE}RequestPermissionFunction_001 end`);
    })

    /**
     * 音乐播放控制
     */
    it(BUNDLE + 'ControlMusicFunction_001', 0, async () => {
      Logger.info(TAG, `${BUNDLE}ControlMusicFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(200);
      // 点击上一曲，播放音乐
      await driver.assertComponentExist(ON.id('image2'));
      let imagePrev = await driver.findComponent(ON.id('image2'));
      await imagePrev.click();
      await driver.delayMs(200);
      // 点击播放/暂停按钮，暂停播放音乐
      await controlMusicPlay();
      // 点击下一曲，播放下一曲音乐
      await driver.assertComponentExist(ON.id('image4'));
      let imageNext = await driver.findComponent(ON.id('image4'));
      await imageNext.click();
      await driver.delayMs(200);
      await controlMusicPlay();
      Logger.info(TAG, `${BUNDLE}ControlMusicFunction_001 end`);
    })
  })
}