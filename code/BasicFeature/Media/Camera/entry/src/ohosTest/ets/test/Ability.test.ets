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
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import resourceManager from '@ohos.resourceManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import Logger from './Logger';
import Ability from '@ohos.app.ability.Ability';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
const TAG = '[Sample_CameraAbility]';
const BUNDLE = 'CameraAbility_';

function getResourceString(resource: Resource) {
  let res: resourceManager.Resource = {
    bundleName: resource.bundleName,
    moduleName: resource.moduleName,
    id: resource.id
  }
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  return delegator.getAppContext().resourceManager.getStringSync(res);
}

export default function abilityTest() {
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let driver: Driver = Driver.create();
  describe('AbilityTest', () => {
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
     * 拉起应用 com.samples.camera
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}StartAbility_001 begin`)
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.camera',
          abilityName: 'EntryAbility'
        })
        expect(true).assertTrue();
      } catch (exception) {
        Logger.info(TAG, `${BUNDLE}Failed to start ability, error info: ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}CameraAbility_StartAbility_001 end`);
      done();
    })

    /**
     * 获取权限，判断是否正常进入主页
     */
    it(BUNDLE + 'RequestPermissionFunction_002', 0, async (done: Function) => {
      Logger.info(TAG, '${BUNDLE}RequestPermissionFunction_002 begin');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(getResourceString($r('app.string.allow'))));
      let btnStart = await driver.findComponent(ON.text(getResourceString($r('app.string.allow'))));
      await btnStart.click();
      let i = 0;
      while(i < 3) {
        btnStart = await driver.findComponent(ON.text(getResourceString($r('app.string.allow'))));
        if(btnStart != null) {
          await btnStart.click();
        }
        i++;
      }
      await delegator.getCurrentTopAbility().then((Ability) => {Logger.info(TAG, 'get top ability');
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      });
      Logger.info(TAG, '${BUNDLE}RequestPermissionFunction_002 end');
      done();
    })

    /**
     * 判断起应用后，判断控件是否存在
     */
    it(BUNDLE + 'JudgementComponentIfExist_003', 0, async (done: Function) => {
      Logger.info(TAG, '${BUNDLE}JudgementComponentIfExist_003 begin');
      await driver.delayMs(1000);
      // 测试控件是否存在
      await driver.assertComponentExist(ON.text(getResourceString($r('app.string.takePic'))));
      await driver.assertComponentExist(ON.text(getResourceString($r('app.string.takeVideo'))));
      await driver.assertComponentExist(ON.text(getResourceString($r('app.string.zoom1x'))));
      await driver.assertComponentExist(ON.text(getResourceString($r('app.string.zoom6x'))));
      await driver.assertComponentExist(ON.id('FlashLightButton'));
      await driver.assertComponentExist(ON.id('SwitchCameraButton'));
      await driver.assertComponentExist(ON.id('CountdownCapture'));
      await driver.assertComponentExist(ON.id('CameraSettings'));
      await driver.assertComponentExist(ON.id('Thumbnail'));
      await driver.assertComponentExist(ON.id('CaptureOrVideoButton'));
      expect(true).assertTrue();
      Logger.info(TAG, '${BUNDLE}JudgementComponentIfExist_003 end');
      done();
    })

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
      await textName.getText().then(value => {
        textNameBefore = value;
        Logger.info(TAG, '${BUNDLE}JudgementComponentThumbnail_004 before TextName' + textNameBefore);
      } )
      await captureButton.click();
      await driver.delayMs(1000);
      textName = await driver.findComponent(ON.id('ThumbnailText'));
      await textName.getText().then(value => {
        textNameAfter = value;
        Logger.info(TAG, '${BUNDLE}JudgementComponentThumbnail_004 before TextName' + textNameAfter);
      } )
      if (textNameBefore === textNameAfter) {
        Logger.info(TAG, '${BUNDLE}JudgementComponentThumbnail_004 without update');
        expect(false).assertTrue();
      }
      expect(true).assertTrue();
      Logger.info(TAG, '${BUNDLE}JudgementComponentThumbnail_004 end');
      done();
    })

    /**
     * 点击预览，触发对焦框
     */
    it(BUNDLE + 'JudgementComponentFocus_005', 0,  async (done: Function) => {
      Logger.info(TAG, '${BUNDLE}JudgementComponentFocus_005 begin');
      await driver.delayMs(1000);
      // 预览框的任意坐标点
      await driver.longClick(695,1475);
      await driver.delayMs(300);
      await driver.assertComponentExist(ON.id('FocusArea'));
      await driver.delayMs(300);
      await driver.assertComponentExist(ON.id('FocusPage'));
      expect(true).assertTrue();
      Logger.info(TAG, '${BUNDLE}JudgementComponentFocus_005 end');
      done();
    })

    /**
     * 录像以及录像过程中拍照
     */
    it(BUNDLE + 'JudgementComponentVideo_006', 0, async (done: Function) => {
      Logger.info(TAG, '${BUNDLE}JudgementComponentVideo_006 begin');
      await driver.delayMs(1000);
      let switchVideo = await driver.findComponent(ON.text(getResourceString($r('app.string.takeVideo'))));
      await switchVideo.click();
      await driver.delayMs(300);
      // 开始录像
      let takeVideo = await driver.findComponent(ON.id('CaptureOrVideoButton'));
      await takeVideo.click();
      await driver.delayMs(100);
      // 录像中拍照
      let takePicture = await driver.findComponent(ON.id('VideoCaptureButton'));
      await takePicture.click();
      // 结束录像
      await driver.delayMs(2000);
      let stopVideo = await driver.findComponent(ON.id('StopVideo'));
      await stopVideo.click();
      expect(true).assertTrue();
      Logger.info(TAG, '${BUNDLE}JudgementComponentVideo_006 end');
      done();
    })
  })
}