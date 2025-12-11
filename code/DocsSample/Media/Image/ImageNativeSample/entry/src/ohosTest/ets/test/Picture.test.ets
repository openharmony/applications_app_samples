/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import resourceManager from '@ohos.resourceManager';
import deviceInfo from '@ohos.deviceInfo';

const TAG = '[Sample_Picture]';
const DOMAIN = 0xF811;
const BUNDLE = 'Picture_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;
const driver = Driver.create();

// 通用的测试函数。
async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btnAccept = await driver.findComponent(ON.text(buttonText));
  if (btnAccept !== undefined) {
    await btnAccept.click();
    await driver.delayMs(delayTime); // 等待操作完成。
  }
  else {
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done(); // 测试完成。
}

export default function PictureTest() {
  describe('PictureTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      abilityDelegator.startAbility({
        bundleName: 'com.sample.ndkImage',
        abilityName: 'EntryAbility'
      });
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

    // 单独运行该测试套时将获取权限的按钮解开。
    // /**
    //  * @tc.number Picture_GetAccess_0001
    //  * @tc.name Picture_GetAccess_0001
    //  * @tc.desc Request camera permissions
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('Picture_GetAccess_0001', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'Picture_GetAccess_0001', // 测试用例名称。
    //     '允许', // 按钮文本。
    //     2000, // 延时 2000 毫秒。
    //     'GetAccess_0001', // 描述。
    //     done // done 回调。
    //   );
    // })

    /**
     * @tc.number Picture_EnterPage_0001
     * @tc.name Picture_EnterPage_0001
     * @tc.desc Enter Picture page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Picture_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Picture_EnterPage_0001', // 测试用例名称。
        '跳转到picture编解码演示页面', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Picture_EnterPage', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Picture_SetDesiredAuxiliaryPictures_0001
     * @tc.name Picture_SetDesiredAuxiliaryPictures_0001
     * @tc.desc Set desired auxiliaryPictures
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Picture_SetDesiredAuxiliaryPictures_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Picture_SetDesiredAuxiliaryPictures_0001', // 测试用例名称。
        'SetDesiredAuxiliaryPictures', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Picture_SetDesiredAuxiliaryPictures_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Picture_CreatePictureByImageSource_0001
     * @tc.name Picture_CreatePictureByImageSource_0001
     * @tc.desc Create picture by imageSource
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Picture_CreatePictureByImageSource_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Picture_CreatePictureByImageSource_0001', // 测试用例名称
        'CreatePictureByImageSource', // 按钮文本
        2000, // 延时 2000 毫秒
        'Picture_CreatePictureByImageSource_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Picture_packToDataFromPicture_0001
     * @tc.name Picture_packToDataFromPicture_0001
     * @tc.desc Pack to data from picture
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Picture_packToDataFromPicture_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Picture_packToDataFromPicture_0001', // 测试用例名称
        'packToDataFromPicture', // 按钮文本
        2000, // 延时 2000 毫秒
        'Picture_packToDataFromPicture_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Picture_packToFileFromPicture_0001
     * @tc.name Picture_packToFileFromPicture_0001
     * @tc.desc Pack to file from picture
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Picture_packToFileFromPicture_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Picture_packToFileFromPicture_0001', // 测试用例名称
        'packToFileFromPicture', // 按钮文本
        2000, // 延时 2000 毫秒
        'Picture_packToFileFromPicture_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Picture_Release_0001
     * @tc.name Picture_Release_0001
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Picture_Release_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Picture_Release_0001', // 测试用例名称
        'ReleasePictureSource', // 按钮文本
        2000, // 延时 2000 毫秒
        'Picture_Release', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Picture_EnterPage_0002
     * @tc.name Picture_EnterPage_0002
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Picture_EnterPage_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Picture_EnterPage_0002', // 测试用例名称
        'back', // 按钮文本
        2000, // 延时 2000 毫秒
        'Picture_EnterPage_0002', // 描述
        done // done 回调
      );
    })
  })
}