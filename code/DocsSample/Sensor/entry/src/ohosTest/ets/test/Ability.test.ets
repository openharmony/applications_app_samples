/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { Driver, ON } from '@ohos.UiTest';
import Want from '@ohos.app.ability.Want';
import { MatchPattern } from '@kit.TestKit';

const TAG = '[Sample_Haptic]';
const DOMAIN = 0xF811;
const BUNDLE = 'Haptic_';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('AppTest', () => {
    /**
     * 启动应用
     */
    it(BUNDLE + 'VerifySensorFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_001 begin');
      let want: Want = {
        bundleName : "com.samples.sensor",
        abilityName: "EntryAbility"
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_001,err.code:' + err.code);
        expect(0).assertEqual(err.code);
      });
      let driver = Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_001 end');
      done();
    });

    /**
     * 输入数据采样频率
     */
    it(BUNDLE + 'VerifySensorFunction_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_002 begin');
      let driver = Driver.create();
      //点击切换按钮
      await driver.assertComponentExist(ON.id('sampleRate'));
      let btnChang = await driver.findComponent(ON.id('sampleRate'));
      await btnChang.click();
      await driver.delayMs(1000);
      //输入数据采样频率
      await driver.assertComponentExist(ON.id('sampleRate'));
      let modifySampleRateInput = await driver.findComponent(ON.id('sampleRate'));
      await modifySampleRateInput.inputText('100000000');
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_002 end');
      done();
    });

    /**
     * 进入切换按钮选择accelerometer类型传感器
     */
    it(BUNDLE + 'VerifySensorFunction_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_003 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      //点击切换按钮
      await driver.assertComponentExist(ON.id('sensorType'));
      let btnChang = await driver.findComponent(ON.id('sensorType'));
      await btnChang.click();
      await driver.delayMs(1000);
      //确认
      await driver.assertComponentExist(ON.text('确定'));
      let btnYes = await driver.findComponent(ON.text('确定'));
      await btnYes.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_003 end');
      done();
    });

    /**
     * 订阅传感器
     */
    it(BUNDLE + 'VerifySensorFunction_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_004 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.on')), MatchPattern.CONTAINS));
      let indexDiscover = await driver.findComponent(ON.text(await getResourceString($r('app.string.on')),
        MatchPattern.CONTAINS));
      await indexDiscover.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_004 end');
      done();
    });

    /**
     * 取消订阅传感器
     */
    it(BUNDLE + 'VerifySensorFunction_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_005 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.off')), MatchPattern.CONTAINS));
      let indexDiscover = await driver.findComponent(ON.text(await getResourceString($r('app.string.off')),
        MatchPattern.CONTAINS));
      await indexDiscover.click();
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_005 end');
      done();
    });

    /**
     * 订阅一次传感器
     */
    it(BUNDLE + 'VerifySensorFunction_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_006 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.once')), MatchPattern.CONTAINS));
      let indexDiscover = await driver.findComponent(ON.text(await getResourceString($r('app.string.once')),
        MatchPattern.CONTAINS));
      await indexDiscover.click();
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'VerifySensorFunction_006 end');
      done();
    });
  })
}