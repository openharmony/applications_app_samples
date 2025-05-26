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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

export default function abilityTest() {
  const TAG: string = '[Sample_NdkPicture]';
  const DOMAIN = 0xF811;
  const BUNDLE = 'NdkPicture_';
  const DELAY_TIME = 1000;
  const driver = Driver.create();
  const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  const bundleName = AbilityDelegatorRegistry.getArguments().bundleName;
  describe('ActsAbilityTest', () => {

    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    /**
     * 打开应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      console.info(TAG, 'StartAbility_001 begin');

      try {
        await abilityDelegator.startAbility({
          bundleName: bundleName,
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.error(DOMAIN, TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(3000);
      done();
      console.info(TAG, 'StartAbility_001 end');
    })
    /**
     * 解码得到Picture
     */
    it(BUNDLE + 'CreatePicture_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreatePicture_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击 Create Picture 按钮
      await driver.assertComponentExist(ON.text("Create Picture"));
      let btn = await driver.findComponent(ON.text("Create Picture"));
      await btn.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreatePicture_001 end');
      done();
    })
    /**
     * 获取主图
     */
    it(BUNDLE + 'GetMainPixelMap_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetMainPixelMap_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击 Get MainPixelMap 按钮
      await driver.assertComponentExist(ON.text("Get MainPixelMap"));
      let btn = await driver.findComponent(ON.text("Get MainPixelMap"));
      await btn.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetMainPixelMap_001 end');
      done();
    })
    /**
     * 将Picture编码到缓冲区
     */
    it(BUNDLE + 'PackToData_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PackToData_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击 Pack to Data 按钮
      await driver.assertComponentExist(ON.text("Pack to Data"));
      let btn = await driver.findComponent(ON.text("Pack to Data"));
      await btn.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'PackToData_001 end');
      done();
    })
    /**
     * 将Picture编码到图片文件
     */
    it(BUNDLE + 'PackToFile_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PackToFile_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击 Pack to File 按钮
      await driver.assertComponentExist(ON.text("Pack to File"));
      let btn = await driver.findComponent(ON.text("Pack to File"));
      await btn.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'PackToFile_001 end');
      done();
    })
    /**
     * 释放Picture
     */
    it(BUNDLE + 'ReleasePicture_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReleasePicture_001 begin');
      await driver.delayMs(DELAY_TIME);
      // 点击 Release Picture 按钮
      await driver.assertComponentExist(ON.text("Release Picture"));
      let btn = await driver.findComponent(ON.text("Release Picture"));
      await btn.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReleasePicture_001 end');
      done();
    })
  })
}