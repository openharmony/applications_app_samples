/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import Want from '@ohos.app.ability.Want';

const TAG = '[Sample_Haptic]';
const DOMAIN = 0xF811;
const BUNDLE = 'Haptic_';

export default function abilityTest() {
  describe('AppTest', () => {
    /**
     * 启动应用
     */
    it(BUNDLE + 'VerifyVibrationFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_001 begin');
      let want: Want = {
        bundleName : "com.samples.haptic",
        abilityName: "EntryAbility"
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_001,err.code:' + err.code);
        expect(0).assertEqual(err.code);
      });
      let driver = Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_001 end');
      done();
    });

    /**
     * 进入"我的"界面
     */
    it(BUNDLE + 'VerifyVibrationFunction_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_002 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('indexMy'));
      let indexMy = await driver.findComponent(ON.id('indexMy'));
      await indexMy.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_002 end');
      done();
    });

    /**
     * 进入振动强度选择
     */
    it(BUNDLE + 'VerifyVibrationFunction_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_003 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('intensitySelect'));
      let intensitySelect = await driver.findComponent(ON.id('intensitySelect'));
      await intensitySelect.click();
      await driver.delayMs(1000);
      await driver.click(100, 500)
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_003 end');
      done();
    });

    /**
     * 返回主界面
     */
    it(BUNDLE + 'VerifyVibrationFunction_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_004 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('indexDiscover'));
      let indexDiscover = await driver.findComponent(ON.id('indexDiscover'));
      await indexDiscover.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_004 end');
      done();
    });

    /**
     * 验证振效库功能
     */
    it(BUNDLE + 'VerifyVibrationFunction_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_005 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('audioHaptic'));
      let racingItem = await driver.findComponent(ON.id('audioHaptic'));
      await racingItem.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_005 end');
      done();
    });

    /**
     * 验证振感视频播放
     */
    it(BUNDLE + 'VerifyVibrationFunction_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_006 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('videoPreview'));
      let videoPreview = await driver.findComponent(ON.id('videoPreview'));
      await videoPreview.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_006 end');
      done();
    });

    /**
     * 返回主界面
     */
    it(BUNDLE + 'VerifyVibrationFunction_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_007 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('videoBack'));
      let videoBack = await driver.findComponent(ON.id('videoBack'));
      await videoBack.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_007 end');
      done();
    });
  })
}
