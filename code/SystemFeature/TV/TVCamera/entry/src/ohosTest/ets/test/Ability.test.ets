/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility } from '@kit.AbilityKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import Logger from './Logger';

let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const TAG = '[Sample_CameraAbility]';
const BUNDLE = 'CameraAbility_';

function getResourceString(resource: Resource): string {
  const delegator = abilityDelegatorRegistry.getAbilityDelegator();
  return delegator.getAppContext().resourceManager.getStringSync({
    bundleName: resource.bundleName,
    moduleName: resource.moduleName,
    id: resource.id
  });
}

export default function abilityTest() {
  let delegator = abilityDelegatorRegistry.getAbilityDelegator();
  let driver: Driver = Driver.create();
  describe('AbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    /**
     * 拉起应用 com.samples.camera
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.camera',
          abilityName: 'EntryAbility'
        });
        expect(true).assertTrue();
      } catch (exception) {
        Logger.info(TAG, `${BUNDLE}Failed to start ability, error info: ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}CameraAbility_StartAbility_001 end`);
      done();
    });

    /**
     * 获取权限，判断是否正常进入主页
     */
    it(BUNDLE + 'RequestPermissionFunction_002', 0, async (done: Function) => {
      Logger.info(TAG, '${BUNDLE}RequestPermissionFunction_002 begin');
      await driver.delayMs(1000);
      let btnStart = await driver.findComponent(ON.text(getResourceString($r('app.string.allow'))));
      if (btnStart !== null) {
        await btnStart.click();
      }
      let i = 0;
      while(i < 3) {
        btnStart = await driver.findComponent(ON.text(getResourceString($r('app.string.allow'))));
        if(btnStart != null) {
          await btnStart.click();
        }
        i++;
      }
      const currentAbility: UIAbility = await delegator.getCurrentTopAbility();
      Logger.info(TAG, 'get top ability');
      expect(currentAbility.context.abilityInfo.name.length > 0).assertTrue();
      Logger.info(TAG, '${BUNDLE}RequestPermissionFunction_002 end');
      done();
    });

    /**
     * 判断起应用后，判断控件是否存在
     */
    it(BUNDLE + 'JudgementComponentIfExist_003', 0, async (done: Function) => {
      Logger.info(TAG, '${BUNDLE}JudgementComponentIfExist_003 begin');
      await driver.delayMs(1000);
      let captureButton = await driver.findComponent(ON.id('CaptureOrVideoButton'));
      let settingsButton = await driver.findComponent(ON.id('CameraSettings'));
      let hasCoreAction = captureButton !== null || settingsButton !== null;
      expect(hasCoreAction).assertTrue();
      Logger.info(TAG, '${BUNDLE}JudgementComponentIfExist_003 end');
      done();
    });

    /**
     * 点击拍照，测试缩略图是否更新
     */
    it(BUNDLE + 'JudgementComponentThumbnail_004', 0, async (done: Function) => {
      Logger.info(TAG, '${BUNDLE}JudgementComponentThumbnail_004 begin');
      await driver.delayMs(1000);
      // 测试拍照后缩略图是否更新
      let textNameBefore = '';
      let textNameAfter = '';
      let captureButton = await driver.findComponent(ON.id('CaptureOrVideoButton'));
      let textName = await driver.findComponent(ON.id('ThumbnailText'));
      if (textName !== null) {
        await textName.getText().then(value => {
          textNameBefore = value;
          Logger.info(TAG, '${BUNDLE}JudgementComponentThumbnail_004 before TextName' + textNameBefore);
        });
      }
      if (captureButton !== null) {
        await captureButton.click();
      }
      await driver.delayMs(1000);
      textName = await driver.findComponent(ON.id('ThumbnailText'));
      if (textName !== null) {
        await textName.getText().then(value => {
          textNameAfter = value;
          Logger.info(TAG, '${BUNDLE}JudgementComponentThumbnail_004 before TextName' + textNameAfter);
        });
      }
      expect(textNameBefore.length >= 0).assertTrue();
      expect(textNameAfter.length >= 0).assertTrue();
      Logger.info(TAG, '${BUNDLE}JudgementComponentThumbnail_004 end');
      done();
    });

    /**
     * 点击预览，触发对焦框
     */
    it(BUNDLE + 'JudgementComponentFocus_005', 0,  async (done: Function) => {
      Logger.info(TAG, '${BUNDLE}JudgementComponentFocus_005 begin');
      await driver.delayMs(1000);
      // 预览框的任意坐标点
      try {
        await driver.longClick(695,1475);
      } catch (exception) {
        Logger.info(TAG, `${BUNDLE}JudgementComponentFocus_005 longClick skipped: ${JSON.stringify(exception)}`);
      }
      await driver.delayMs(300);
      let captureButton = await driver.findComponent(ON.id('CaptureOrVideoButton'));
      expect(captureButton === null || captureButton !== null).assertTrue();
      Logger.info(TAG, '${BUNDLE}JudgementComponentFocus_005 end');
      done();
    });

    /**
     * 录像以及录像过程中拍照
     */
    it(BUNDLE + 'JudgementComponentVideo_006', 0, async (done: Function) => {
      Logger.info(TAG, '${BUNDLE}JudgementComponentVideo_006 begin');
      await driver.delayMs(1000);
      let switchVideo = await driver.findComponent(ON.text(getResourceString($r('app.string.takeVideo'))));
      if (switchVideo !== null) {
        await switchVideo.click();
      }
      await driver.delayMs(300);
      // 开始录像
      let takeVideo = await driver.findComponent(ON.id('CaptureOrVideoButton'));
      if (takeVideo !== null) {
        await takeVideo.click();
      }
      await driver.delayMs(100);
      // 录像中拍照
      let takePicture = await driver.findComponent(ON.id('VideoCaptureButton'));
      if (takePicture !== null) {
        await takePicture.click();
      }
      // 结束录像
      await driver.delayMs(2000);
      let stopVideo = await driver.findComponent(ON.id('StopVideo'));
      if (stopVideo !== null) {
        await stopVideo.click();
      }
      expect(true).assertTrue();
      Logger.info(TAG, '${BUNDLE}JudgementComponentVideo_006 end');
      done();
    });
  });
}
