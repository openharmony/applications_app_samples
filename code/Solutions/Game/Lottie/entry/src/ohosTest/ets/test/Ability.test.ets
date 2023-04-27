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
import Logger from '../../../main/ets/util/Logger';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import UIAbility from '@ohos.app.ability.UIAbility';

const TAG: string = '[Sample_Lottie]';
const BUNDLE = 'Lottie_';
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let ability: UIAbility;

export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.lottie',
          abilityName: 'EntryAbility'
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
     * 点击选择，选择动画资源
     */
    it(BUNDLE + 'SelectAnimationAssetFunction_001', 0, async () => {
      Logger.info(TAG, `${BUNDLE}SelectAnimationAssetFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(200);
      // 点击请选择，选择动画资源
      await driver.assertComponentExist(ON.id('selectAnimationBtn'));
      let selectAnimation = await driver.findComponent(ON.id('selectAnimationBtn'));
      await selectAnimation.click();
      await driver.delayMs(200);
      // 选择grunt动画
      let resourceManager = ability.context.resourceManager;
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.grunt'))));
      let grunt = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.grunt'))));
      await driver.delayMs(200);
      await grunt.click();
      await driver.delayMs(200);
      Logger.info(TAG, `${BUNDLE}SelectAnimationAssetFunction_001 end`);
    })

    /**
     *  点击上面播放/暂停按钮控制两个动画，点击下面播放/暂停按钮控制一个动画
     */
    it(BUNDLE + 'ControlAnimationFunction_001', 0, async () => {
      Logger.info(TAG, `${BUNDLE}ControlAnimationFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(200);
      // 点击上面播放/暂停按钮，控制两个动画
      await driver.assertComponentExist(ON.id('play'));
      let btnPlay = await driver.findComponent(ON.id('play'));
      // 点击播放/暂停按钮，两个动画暂停播放
      await btnPlay.click();
      await driver.delayMs(200);
      // 点击播放/暂停按钮，两个动画开始播放
      await btnPlay.click();
      await driver.delayMs(200);
      // 点击下面播放/暂停按钮，控制grunt动画
      await driver.assertComponentExist(ON.id('stop'));
      let btnStop = await driver.findComponent(ON.id('stop'));
      // 点击播放/暂停按钮，grunt动画暂停播放
      await btnStop.click();
      await driver.delayMs(200);
      // 点击播放/暂停按钮，grunt动画开始播放
      await btnStop.click();
      await driver.delayMs(200);
    })

    /**
     * 销毁动画，重新选择动画资源，进行其余功能操作
     */
    it(BUNDLE + 'DestroyAnimationFunction_001', 0, async () => {
      Logger.info(TAG, `${BUNDLE}DestroyAnimationFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('destroyAnimation'));
      let btnDestroy = await driver.findComponent(ON.id('destroyAnimation'));
      // 点击销毁动画按钮销毁动画
      await btnDestroy.click();
      await driver.delayMs(200);
      // 重新选择动画资源
      await driver.assertComponentExist(ON.id('selectAnimationBtn'));
      let selectAnimation = await driver.findComponent(ON.id('selectAnimationBtn'));
      await selectAnimation.click();
      await driver.delayMs(200);
      // 选择year动画
      let resourceMgr = ability.context.resourceManager;
      await driver.assertComponentExist(ON.text(await resourceMgr.getStringValue($r('app.string.year'))));
      let year = await driver.findComponent(ON.text(await resourceMgr.getStringValue($r('app.string.year'))));
      await driver.delayMs(200);
      await year.click();
      await driver.delayMs(200);
      // 点击播放暂停，year动画暂停
      await driver.assertComponentExist(ON.id('play'));
      let btnPlay = await driver.findComponent(ON.id('play'));
      await btnPlay.click();
      await driver.delayMs(200);
      // 点击播放暂停，year动画播放
      await btnPlay.click();
      await driver.delayMs(200);
      // 点击停止按钮，year动画停止播放
      await driver.assertComponentExist(ON.id('suspend'));
      let btnSuspend = await driver.findComponent(ON.id('suspend'));
      await btnSuspend.click();
      await driver.delayMs(200);
      // 点击开始播放，year动画播放
      await driver.assertComponentExist(ON.id('startPlay'));
      let btnStart = await driver.findComponent(ON.id('startPlay'));
      await btnStart.click();
      await driver.delayMs(200);
      // 点击暂停，year动画暂停
      await driver.assertComponentExist(ON.id('pause'));
      let btnPause = await driver.findComponent(ON.id('pause'));
      await btnPause.click();
      await driver.delayMs(200);
      // 点击开始播放，year动画恢复播放
      await btnStart.click();
      // 点击倍速，选择3倍速播放year动画
      await driver.assertComponentExist(ON.id('speed'));
      let btnSpeed = await driver.findComponent(ON.id('speed'));
      await btnSpeed.click();
      await driver.delayMs(200);
      // 选择2倍速播放
      await driver.assertComponentExist(ON.text(await resourceMgr.getStringValue($r('app.string.three_speed'))));
      let speed = await driver.findComponent(ON.text(await resourceMgr.getStringValue($r('app.string.three_speed'))));
      await speed.click();
      await driver.delayMs(200);
      // 点击播放顺序，选择反向播放year动画`
      await driver.assertComponentExist(ON.id('playOrder'));
      let btnPlayOrder = await driver.findComponent(ON.id('playOrder'));
      await btnPlayOrder.click();
      await driver.delayMs(200);
      // 选择反向
      await driver.assertComponentExist(ON.text(await resourceMgr.getStringValue($r('app.string.reverse'))));
      let reverse = await driver.findComponent(ON.text(await resourceMgr.getStringValue($r('app.string.reverse'))));
      await reverse.click();
      await driver.delayMs(200);
      Logger.info(TAG, `${BUNDLE}DestroyAnimationFunction_001 end`);
    })
  })
}