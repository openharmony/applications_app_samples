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

const TAG = '[Sample_Sensor]';
const DOMAIN = 0xF811;
const BUNDLE = 'Sensor_';

export default function abilityTest() {
  describe('AppTest', () => {
    /**
     * 启动应用
     */
    it(BUNDLE + 'VerifyOrientationFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyVibrationFunction_001 begin');
      let want: Want = {
        bundleName : "com.example.sensor",
        abilityName: "EntryAbility"
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyOrientationFunction_001,err.code:' + err.code);
        expect(0).assertEqual(err.code);
      });
      let driver = Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyOrientationFunction_001 end');
      done();
    });

    /**
     * 获取"方向"组件
     */
    it(BUNDLE + 'VerifyOrientationFunction_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyOrientationFunction_002 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('directionMy'));
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyOrientationFunction_002 end');
      done();
    });

    /**
     * 获取"指南针指向"组件
     */
    it(BUNDLE + 'VerifyOrientationFunction_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyOrientationFunction_003 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('compassPointing'));
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyOrientationFunction_003 end');
      done();
    });

    /**
     * 获取"倾斜角度"组件
     */
    it(BUNDLE + 'VerifyOrientationFunction_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyOrientationFunction_004 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('tiltAngle'));
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifyOrientationFunction_004 end');
      done();
    });
  })
}