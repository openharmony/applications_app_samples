/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

import { logger as Logger } from '../util/Logger';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { getString } from '../util/ResourceUtil';

const TAG = '[Sample_Camera]';
const BUNDLE = 'Camera_';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();

let driver = Driver.create();

export default function CameraTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.

      // 启动Ability
      delegator.executeShellCommand('aa start -a EntryAbility -b com.samples.camera');

      await driver.delayMs(2000);
      // 授权
      await checkAndClickPermission(getString($r('app.string.allow')), "beforeAll");
      await checkAndClickPermission(getString($r('app.string.allow')), "beforeAll");
      await checkAndClickPermission(getString($r('app.string.allow')), "beforeAll");
      await checkAndClickPermission(getString($r('app.string.allow')), "beforeAll");
      await driver.delayMs(1000);
      done();
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
    it('TakePicture_Video', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      Logger.info(TAG, BUNDLE + 'TakePicture_video begin');
      await driver.delayMs(1000);

      // 点击拍照
      await checkAndClickById("camera", "TakePicture_video");

      // 切换录制
      await checkAndClickById("video", "TakePicture_video");

      // 点击录制
      await checkAndClickById("camera", "TakePicture_video");

      // 录制5s
      await driver.delayMs(5000);

      // 停止录制
      await checkAndClickById("camera", "TakePicture_video");

      // 切换回拍照
      await checkAndClickById("photo", "TakePicture_video");

      await driver.delayMs(1000);
      done();
      Logger.info(TAG, BUNDLE + 'TakePicture_video end');
    })

    it('Rotation', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      Logger.info(TAG, BUNDLE + 'Rotation begin');
      await driver.delayMs(1000);

      // 点击进入设置
      await checkAndClickById("setting", "Rotation");

      // 点击旋转角度
      await checkAndClickById("rotation", "Rotation");

      // 选择角度
      await checkAndClickByText(getString($r('app.string.support_90_rotate')), "Rotation");

      // 点击确定
      await checkAndClickById("confirm", "Rotation");

      // 返回首页
      await checkAndClickById("back", "Rotation");

      await driver.delayMs(1000);

      // 拍照
      await checkAndClickById("camera", "Rotation");

      await driver.delayMs(1000);
      done();
      Logger.info(TAG, BUNDLE + 'Rotation end');
    })

    it('Resolution', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      Logger.info(TAG, BUNDLE + 'Resolution begin');
      await driver.delayMs(1000);

      // 点击进入设置
      await checkAndClickById("setting", "Resolution");

      // 切换分辨率
      await checkAndClickById("resolution", "Resolution");

      // 选择分辨率
      await checkAndClickByText("1920*1080", "Resolution");

      // 点击确定
      await checkAndClickById("confirm", "Resolution");

      // 返回首页
      await checkAndClickById("back", "Resolution");

      await driver.delayMs(1000);

      // 切换录制
      await checkAndClickById("video", "TakePicture_video");

      // 点击录制
      await checkAndClickById("camera", "TakePicture_video");

      // 录制5s
      await driver.delayMs(5000);

      // 停止录制
      await checkAndClickById("camera", "TakePicture_video");

      await driver.delayMs(1000);
      done();
      Logger.info(TAG, BUNDLE + 'Resolution end');
    })

    it('IntoPhoto', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      Logger.info(TAG, BUNDLE + 'IntoPhoto begin');
      await driver.delayMs(1000);

      // 点击进入相册
      await checkAndClickById("intoPhoto", "IntoPhoto");

      await driver.delayMs(1000);
      done();
      Logger.info(TAG, BUNDLE + 'IntoPhoto end');
    })
  })

  /**
   * 根据id拿到组件并点击
   * @param id
   */
  let checkAndClickById = async (id: string, log: string) => {
    Logger.info(TAG, BUNDLE + `${log} id:${id}`);
    await driver.assertComponentExist(ON.id(id));
    let res = await driver.findComponent(ON.id(id));
    await res.click();
  }
  /**
   * 根据text拿到组件并点击
   * @param text
   */
  let checkAndClickByText = async (text: string, log: string) => {
    Logger.info(TAG, BUNDLE + `${log} text:${text}`);
    await driver.assertComponentExist(ON.text(text));
    let res = await driver.findComponent(ON.text(text));
    await res.click();
  }

  let checkAndClickPermission = async (text: string, log: string) => {
    Logger.info(TAG, BUNDLE + `${log} text:${text}`);
    await driver.delayMs(1000);
    await driver.assertComponentExist(ON.text(text, MatchPattern.CONTAINS));
    await driver.delayMs(1000);
    // 点击授权
    let res = await driver.findComponent(ON.text(text, MatchPattern.EQUALS));
    await driver.delayMs(1000);
    await res.click();
  }
}