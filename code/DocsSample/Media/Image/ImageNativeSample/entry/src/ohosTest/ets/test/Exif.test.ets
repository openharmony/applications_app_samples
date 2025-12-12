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
import inputMethod from '@ohos.inputMethod'

const TAG = '[Sample_Exif]';
const DOMAIN = 0xF811;
const BUNDLE = 'Exif_';
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

export default function ExifTest() {
  describe('ExifTest', () => {
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
    /**
     * @tc.number Exif_GetAccess_0001
     * @tc.name Exif_GetAccess_0001
     * @tc.desc Request camera permissions
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_GetAccess_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Exif_GetAccess_0001', // 测试用例名称。
        '允许', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'GetAccess_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Exif_EnterPage_0001
     * @tc.name Exif_EnterPage_0001
     * @tc.desc Enter Exif page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Exif_EnterPage_0001', // 测试用例名称。
        '跳转到读取和修改Exif信息页面', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Exif_EnterPage', // 描述。
        done // done 回调。
      );
    })

    // 创建ImageSource。
    /**
     * @tc.number Exif_CreateImageSource_0001
     * @tc.name Exif_CreateImageSource_0001
     * @tc.desc Create ImageSource
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_CreateImageSource_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Exif_CreateImageSource_0001', // 测试用例名称。
        'CreateImageSource', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Exif_CreateImageSource_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Exif_Key_0001
     * @tc.name Exif_Key_0001
     * @tc.desc Specify the property key value
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_Key_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Exif_Key_0001', // 测试用例名称
        'ChoosePropertyKey', // 按钮文本
        2000, // 延时 2000 毫秒
        'Exif_Key_0001', // 描述
        done // done 回调
      );
    })

    // 选择fNumber。
    /**
     * @tc.number Exif_fNumber_0001
     * @tc.name Exif_fNumber_0001
     * @tc.desc Select fNumber
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_fNumber_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Exif_fNumber_0001', // 测试用例名称
        'FNumber', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Exif_fNumber_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Exif_GetImageProperty_0001
     * @tc.name Exif_GetImageProperty_0001
     * @tc.desc GetImageProperty
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_GetImageProperty_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Exif_GetImageProperty_0001', // 测试用例名称
        'GetImageProperty', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Exif_GetImageProperty_0001', // 描述。
        done // done 回调。
      );
    })

    // 输入指定property的key值
    /**
     * @tc.number Exif_ValueInput_0001
     * @tc.name Exif_ValueInput_0001
     * @tc.desc Enter the key value of the specified property
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_ValueInput_0001', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + `Exif_ValueInput_0001, begin`);

      let btnAccept = await driver.findComponent(ON.id('valueInput'));
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(200); // 等待操作完成
      }

      let fNumber = await driver.findComponent(ON.text('1'));
      if (fNumber !== undefined) {
        await fNumber.click();
        await driver.delayMs(200); // 等待操作完成
      }

      let im = inputMethod.getController()
      im.stopInputSession()
      await driver.delayMs(200); // 等待操作完成

      hilog.info(DOMAIN, TAG, BUNDLE + `Exif_ValueInput_0001, end`);
      done(); // 测试完成
    })
    /**
     * @tc.number Exif_Modify_0001
     * @tc.name Exif_Modify_0001
     * @tc.desc Modify Exif information
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_Modify_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Exif_Modify_0001', // 测试用例名称
        'ModifyImageProperty', // 按钮文本
        2000, // 延时 2000 毫秒
        'Exif_Modify_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Exif_Release_0001
     * @tc.name Exif_Release_0001
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_Release_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Exif_Release_0001', // 测试用例名称
        'ReleaseImageSource', // 按钮文本
        2000, // 延时 2000 毫秒
        'Exif_Release', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Exif_EnterPage_0002
     * @tc.name Exif_EnterPage_0002
     * @tc.desc Enter index page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Exif_EnterPage_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Exif_EnterPage_0002', // 测试用例名称。
        'back', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Exif_EnterPage_0002', // 描述。
        done // done 回调。
      );
    })
  })
}