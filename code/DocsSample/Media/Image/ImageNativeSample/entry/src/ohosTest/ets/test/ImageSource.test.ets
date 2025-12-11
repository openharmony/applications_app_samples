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

const TAG = '[Sample_ImagesSource]';
const DOMAIN = 0xF811;
const BUNDLE = 'ImagesSource_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;
const driver = Driver.create();

// 通用的测试函数
async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btnAccept = await driver.findComponent(ON.text(buttonText));
  if (btnAccept !== undefined) {
    await btnAccept.click();
    await driver.delayMs(delayTime); // 等待操作完成
  }
  else {
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done(); // 测试完成
}

export default function ImagesSourceTest() {
  describe('ImagesSourceTest', () => {
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

    // 单独运行该测试套时将获取权限的按钮解开
    // /**
    //  * @tc.number ImagesSource_GetAccess_0001
    //  * @tc.name ImagesSource_GetAccess_0001
    //  * @tc.desc Request camera permissions
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('ImagesSource_GetAccess_0001', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'ImagesSource_GetAccess_0001', // 测试用例名称
    //     '允许', // 按钮文本
    //     2000, // 延时 2000 毫秒
    //     'GetAccess_0001', // 描述
    //     done // done 回调
    //   );
    // })

    /**
     * @tc.number ImagesSource_EnterPage_0001
     * @tc.name ImagesSource_EnterPage_0001
     * @tc.desc Enter ImagesSource page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ImagesSource_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ImagesSource_EnterPage_0001', // 测试用例名称。
        '跳转到图片编解码操作页面', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'ImagesSource_EnterPage', // 描述。
        done // done 回调
      );
    })

    /**
     * @tc.number ImageSource_CreateImageSource_0001
     * @tc.name ImageSource_CreateImageSource_0001
     * @tc.desc Create ImageSource
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ImageSource_CreateImageSource_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ImageSource_CreateImageSource_0001', // 测试用例名称。
        'CreateImageSource', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'ImageSource_CreateImageSource_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number ImagesSource_packToFileFromImageSource_0001
     * @tc.name ImagesSource_packToFileFromImageSource_0001
     * @tc.desc Pack to file from ImageSource
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ImagesSource_packToFileFromImageSource_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ImagesSource_packToFileFromImageSource_0001', // 测试用例名称。
        'packToFileFromImageSource', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'ImagesSource_packToFileFromImageSource_0001', // 描述。
        done // done 回调
      );
    })

    /**
     * @tc.number ImagesSource_GetImageInfo_0001
     * @tc.name ImagesSource_GetImageInfo_0001
     * @tc.desc Get ImageInfo
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ImagesSource_GetImageInfo_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ImagesSource_GetImageInfo_0001', // 测试用例名称。
        'GetImageInfo', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'ImagesSource_GetImageInfo_0001', // 描述。
        done // done 回调
      );
    })

    /**
     * @tc.number ImagesSource_createPixelMap_0001
     * @tc.name ImagesSource_createPixelMap_0001
     * @tc.desc Get ImageInfo
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ImagesSource_createPixelMap_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ImagesSource_createPixelMap_0001', // 测试用例名称。
        'createPixelMap', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'ImagesSource_createPixelMap_0001', // 描述。
        done // done 回调
      );
    })

    /**
     * @tc.number ImagesSource_packToFileFromPixelmap_0001
     * @tc.name ImagesSource_packToFileFromPixelmap_0001
     * @tc.desc Pack to file from Pixelmap
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ImagesSource_packToFileFromPixelmap_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ImagesSource_packToFileFromPixelmap_0001', // 测试用例名称。
        'packToFileFromPixelmap', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'ImagesSource_packToFileFromPixelmap_0001', // 描述。
        done // done 回调
      );
    })

    /**
     * @tc.number ImagesSource_CreatePixelmapUsingAllocator_0001
     * @tc.name ImagesSource_CreatePixelmapUsingAllocator_0001
     * @tc.desc Create pixelmap Using allocator
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ImagesSource_CreatePixelmapUsingAllocator_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ImagesSource_CreatePixelmapUsingAllocator_0001', // 测试用例名称。
        'CreatePixelmapUsingAllocator', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'ImagesSource_CreatePixelmapUsingAllocator_0001', // 描述。
        done // done 回调
      );
    })

    /**
     * @tc.number ImagesSource_Release_0001
     * @tc.name ImagesSource_Release_0001
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ImagesSource_Release_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ImagesSource_Release_0001', // 测试用例名称。
        'ReleaseImageSource', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'ImagesSource_Release', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number ImagesSource_EnterPage_0002
     * @tc.name ImagesSource_EnterPage_0002
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ImagesSource_EnterPage_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ImagesSource_EnterPage_0002', // 测试用例名称。
        'back', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'ImagesSource_EnterPage_0002', // 描述。
        done // done 回调
      );
    })
  })
}