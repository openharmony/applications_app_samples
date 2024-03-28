/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

import { describe, it, expect } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
// @ts-ignore
import { Driver, ON } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG = '[Sample_AVRecorder]'
const BUNDLE = 'AVRecorder'
const driver = Driver.create();
const abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 拉起应用
     */
    it(BUNDLE + '_StartAbility', 0, async function () {
      logger.info(TAG, BUNDLE + '_StartAbility start');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.avrecorder',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        logger.info(TAG, BUNDLE + '_StartAbility error');
        expect().assertFail();
      }
      logger.info(TAG, BUNDLE + '_StartAbility end');
    })

    /**
     * 允许权限
     */
    it(BUNDLE + '_Permission', 0, async () => {
      logger.info(TAG, BUNDLE + '_Permission begin');
      await driver.delayMs(1000);
      let ability = abilityDelegatorRegistry.getAppContext();
      let manager = ability.resourceManager;
      for (let i = 0; i < 4; i++) {
        let btnAccept = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.allow'))));
        if (btnAccept !== undefined) {
          await btnAccept.click();
          await driver.delayMs(500);
        }
      }
      logger.info(TAG, BUNDLE + '_Permission end');
    })

    /**
     * 音频录制参数选择
     */
    it(BUNDLE + '_TestSetParameter', 0, async () => {
      logger.info(TAG, BUNDLE + '_TestSetParameter begin');
      let audioRecordPage = await driver.findComponent(ON.id('audioRecorderPage'));
      if (audioRecordPage !== undefined) {
        await audioRecordPage.click();
        await driver.delayMs(1000);
      }
      let settingBtn = await driver.findComponent(ON.id('audioSetting'));
      if (settingBtn !== undefined) {
        await settingBtn.click();
        await driver.delayMs(1000);
      }
      let confirmBtn = await driver.findComponent(ON.id('audioConfirm'));
      if (confirmBtn !== undefined) {
        await confirmBtn.click();
        await driver.delayMs(1000);
      }
      logger.info(TAG, BUNDLE + '_TestSetParameter end');
    })
    /**
     * 音频录制状态切换（开始录制-暂停录制-恢复录制-停止录制）
     */
    it(BUNDLE + '_TestRecorderFunc', 0, async () => {
      logger.info(TAG, BUNDLE + '_TestRecorderFunc begin');
      let startBtn = await driver.findComponent(ON.id('audioStart'));
      if (startBtn !== undefined) {
        await startBtn.click();
        await driver.delayMs(3000);
      }
      let pauseBtn = await driver.findComponent(ON.id('audioPause'));
      if (pauseBtn !== undefined) {
        await pauseBtn.click();
        await driver.delayMs(3000);
      }
      let resumeBtn = await driver.findComponent(ON.id('audioResume'));
      if (resumeBtn !== undefined) {
        await resumeBtn.click();
        await driver.delayMs(3000);
      }
      let stopBtn = await driver.findComponent(ON.id('audioStop'));
      if (stopBtn !== undefined) {
        await stopBtn.click();
      }
      logger.info(TAG, BUNDLE + '_TestRecorderFunc end');
    })
  })
}