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

const TAG = '[Sample_Codec]';
const DOMAIN = 0xF811;
const BUNDLE = 'Codec_';
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

export default function codecTest() {
  describe('CodecTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      abilityDelegator.startAbility({
        bundleName: 'com.sample.jsImage',
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

    /**
     * @tc.number Codec_GetAccess_0001
     * @tc.name Codec_GetAccess_0001
     * @tc.desc Request camera permissions
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_GetAccess_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_GetAccess_0001', // 测试用例名称
        '允许', // 按钮文本
        2000, // 延时 2000 毫秒
        'GetAccess_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_GetAccess_0002
     * @tc.name Codec_GetAccess_0002
     * @tc.desc Request microphone permission
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_GetAccess_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_GetAccess_0002', // 测试用例名称
        '允许', // 按钮文本
        2000, // 延时 2000 毫秒
        'GetAccess_0002', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_GetAccess_0003
     * @tc.name Codec_GetAccess_0003
     * @tc.desc Request media permission
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_GetAccess_0003', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_GetAccess_0003', // 测试用例名称
        '允许', // 按钮文本
        2000, // 延时 2000 毫秒
        'GetAccess_0003', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_GetAccess_0004
     * @tc.name Codec_GetAccess_0004
     * @tc.desc Request file permission
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_GetAccess_0004', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_GetAccess_0004', // 测试用例名称
        '允许', // 按钮文本
        2000, // 延时 2000 毫秒
        'GetAccess_0004', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_EnterPage_0001
     * @tc.name Codec_EnterPage_0001
     * @tc.desc Enter pixelMap decode page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_EnterPage_0001', // 测试用例名称
        '跳转到图片解码页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_EnterPage', // 描述
        done // done 回调
      );
    })

    // 选择jpeg类型的资源解码图片
    /**
     * @tc.number Codec_ChooseSource_Jpeg_0001
     * @tc.name Codec_ChooseSource_Jpeg_0001
     * @tc.desc Select decoding file type
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_Jpeg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_Jpeg_0001', // 测试用例名称
        'JPEG', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_Jpeg_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBox_Jpeg_0001
     * @tc.name Codec_DecodingPixelBox_Jpeg_0001
     * @tc.desc Decoding PixelMap created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBox_Jpeg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBox_Jpeg_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBox_Jpeg_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelFd_Jpeg_0001
     * @tc.name Codec_DecodingPixelFd_Jpeg_0001
     * @tc.desc Decoding PixelMap created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelFd_Jpeg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelFd_Jpeg_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelFd_Jpeg_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBuffer_Jpeg_0001
     * @tc.name Codec_DecodingPixelBuffer_Jpeg_0001
     * @tc.desc Decoding PixelMap created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBuffer_Jpeg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBuffer_Jpeg_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBuffer_Jpeg', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelRawFd_Jpeg_0001
     * @tc.name Codec_DecodingPixelRawFd_Jpeg_0001
     * @tc.desc Decoding PixelMap created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelRawFd_Jpeg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelRawFd_Jpeg_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelRawFd_Jpeg', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_Release_0001
     * @tc.name Codec_Release_0001
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0001', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    })

    //选择png类型的资源解码图片
    /**
     * @tc.number Codec_ChooseSource_Png_0001
     * @tc.name Codec_ChooseSource_Png_0001
     * @tc.desc Select decoding file type
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_Png_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_Png_0001', // 测试用例名称
        'PNG', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_Png_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBox_Png_0001
     * @tc.name Codec_DecodingPixelBox_Png_0001
     * @tc.desc Decoding PixelMap created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBox_Png_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBox_Png_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBox_Png_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelFd_Png_0001
     * @tc.name Codec_DecodingPixelFd_Png_0001
     * @tc.desc Decoding PixelMap created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelFd_Png_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelFd_Png_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelFd_Png_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBuffer_Png_0001
     * @tc.name Codec_DecodingPixelBuffer_Png_0001
     * @tc.desc Decoding PixelMap created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBuffer_Png_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBuffer_Png_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBuffer_Png', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelRawFd_Png_0001
     * @tc.name Codec_DecodingPixelRawFd_Png_0001
     * @tc.desc Decoding PixelMap created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelRawFd_Png_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelRawFd_Png_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelRawFd_Png', // 描述
        done                                          // done 回调
      );
    });

    /**
     * @tc.number Codec_Release_0002
     * @tc.name Codec_Release_0002
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0002', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    //选择Webp类型的资源解码图片
    /**
     * @tc.number Codec_ChooseSource_Webp_0001
     * @tc.name Codec_ChooseSource_Webp_0001
     * @tc.desc Select decoding file type
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_Webp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_Webp_0001', // 测试用例名称
        'WebP', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_Webp_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBox_Webp_0001
     * @tc.name Codec_DecodingPixelBox_Webp_0001
     * @tc.desc Decoding PixelMap created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBox_Webp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBox_Webp_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBox_Webp_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelFd_Webp_0001
     * @tc.name Codec_DecodingPixelFd_Webp_0001
     * @tc.desc Decoding PixelMap created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelFd_Webp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelFd_Webp_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelFd_Webp_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBuffer_Webp_0001
     * @tc.name Codec_DecodingPixelBuffer_Webp_0001
     * @tc.desc Decoding PixelMap created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBuffer_Webp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBuffer_Webp_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBuffer_Webp', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelRawFd_Webp_0001
     * @tc.name Codec_DecodingPixelRawFd_Webp_0001
     * @tc.desc Decoding PixelMap created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelRawFd_Webp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelRawFd_Webp_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelRawFd_Webp', // 描述
        done                                          // done 回调
      );
    });

    /**
     * @tc.number Codec_Release_0003
     * @tc.name Codec_Release_0003
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0003', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0003', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    //选择BMP类型的资源解码图片
    /**
     * @tc.number Codec_ChooseSource_Bmp_0001
     * @tc.name Codec_ChooseSource_Bmp_0001
     * @tc.desc Select decoding file type
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_Bmp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_Bmp_0001', // 测试用例名称
        'BMP', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_Bmp_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBox_Bmp_0001
     * @tc.name Codec_DecodingPixelBox_Bmp_0001
     * @tc.desc Decoding PixelMap created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBox_Bmp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBox_Bmp_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBox_Bmp_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelFd_Bmp_0001
     * @tc.name Codec_DecodingPixelFd_Bmp_0001
     * @tc.desc Decoding PixelMap created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelFd_Bmp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelFd_Bmp_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelFd_Bmp_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBuffer_Bmp_0001
     * @tc.name Codec_DecodingPixelBuffer_Bmp_0001
     * @tc.desc Decoding PixelMap created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBuffer_Bmp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBuffer_Bmp_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBuffer_Bmp', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelRawFd_Bmp_0001
     * @tc.name Codec_DecodingPixelRawFd_Bmp_0001
     * @tc.desc Decoding PixelMap created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelRawFd_Bmp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelRawFd_Bmp_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelRawFd_Bmp', // 描述
        done                                          // done 回调
      );
    });

    /**
     * @tc.number Codec_Release_0004
     * @tc.name Codec_Release_0004
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0004', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0004', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    //选择Svg类型的资源解码图片
    /**
     * @tc.number Codec_ChooseSource_Svg_0001
     * @tc.name Codec_ChooseSource_Svg_0001
     * @tc.desc Select decoding file type
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_Svg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_Svg_0001', // 测试用例名称
        'SVG', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_Svg_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBox_Svg_0001
     * @tc.name Codec_DecodingPixelBox_Svg_0001
     * @tc.desc Decoding PixelMap created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBox_Svg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBox_Svg_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBox_Svg_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelFd_Svg_0001
     * @tc.name Codec_DecodingPixelFd_Svg_0001
     * @tc.desc Decoding PixelMap created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelFd_Svg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelFd_Svg_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelFd_Svg_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBuffer_Svg_0001
     * @tc.name Codec_DecodingPixelBuffer_Svg_0001
     * @tc.desc Decoding PixelMap created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBuffer_Svg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBuffer_Svg_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBuffer_Svg', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelRawFd_Svg_0001
     * @tc.name Codec_DecodingPixelRawFd_Svg_0001
     * @tc.desc Decoding PixelMap created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelRawFd_Svg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelRawFd_Svg_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelRawFd_Svg', // 描述
        done                                          // done 回调
      );
    });

    /**
     * @tc.number Codec_Release_0005
     * @tc.name Codec_Release_0005
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0005', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0005', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    //选择Ico类型的资源解码图片
    /**
     * @tc.number Codec_ChooseSource_Ico_0001
     * @tc.name Codec_ChooseSource_Ico_0001
     * @tc.desc Select decoding file type
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_Ico_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_Ico_0001', // 测试用例名称
        'ICO', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_Ico_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBox_Ico_0001
     * @tc.name Codec_DecodingPixelBox_Ico_0001
     * @tc.desc Decoding PixelMap created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBox_Ico_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBox_Ico_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBox_Ico_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelFd_Ico_0001
     * @tc.name Codec_DecodingPixelFd_Ico_0001
     * @tc.desc Decoding PixelMap created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelFd_Ico_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelFd_Ico_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelFd_Ico_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBuffer_Ico_0001
     * @tc.name Codec_DecodingPixelBuffer_Ico_0001
     * @tc.desc Decoding PixelMap created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBuffer_Ico_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBuffer_Ico_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBuffer_Ico', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelRawFd_Ico_0001
     * @tc.name Codec_DecodingPixelRawFd_Ico_0001
     * @tc.desc Decoding PixelMap created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelRawFd_Ico_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelRawFd_Ico_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelRawFd_Ico', // 描述
        done                                          // done 回调
      );
    });

    /**
     * @tc.number Codec_Release_0006
     * @tc.name Codec_Release_0006
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0006', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0006', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    //选择HEIF类型的资源解码图片
    /**
     * @tc.number Codec_ChooseSource_HEIF_0001
     * @tc.name Codec_ChooseSource_HEIF_0001
     * @tc.desc Select decoding file type
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_HEIF_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_HEIF_0001', // 测试用例名称
        'HEIF', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_HEIF_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBox_HEIF_0001
     * @tc.name Codec_DecodingPixelBox_HEIF_0001
     * @tc.desc Decoding PixelMap created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBox_HEIF_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBox_HEIF_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBox_HEIF_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelFd_HEIF_0001
     * @tc.name Codec_DecodingPixelFd_HEIF_0001
     * @tc.desc Decoding PixelMap created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelFd_HEIF_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelFd_HEIF_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelFd_HEIF_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBuffer_HEIF_0001
     * @tc.name Codec_DecodingPixelBuffer_HEIF_0001
     * @tc.desc Decoding PixelMap created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBuffer_HEIF_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBuffer_HEIF_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBuffer_HEIF', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelRawFd_HEIF_0001
     * @tc.name Codec_DecodingPixelRawFd_HEIF_0001
     * @tc.desc Decoding PixelMap created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelRawFd_HEIF_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelRawFd_HEIF_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelRawFd_HEIF', // 描述
        done                                          // done 回调
      );
    });

    /**
     * @tc.number Codec_Release_0007
     * @tc.name Codec_Release_0007
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0007', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0007', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    //选择HDR类型的资源解码图片
    /**
     * @tc.number Codec_ChooseSource_HDR_0001
     * @tc.name Codec_ChooseSource_HDR_0001
     * @tc.desc Select decoding file type
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_HDR_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_HDR_0001', // 测试用例名称
        'HDR', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_HDR_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBox_HDR_0001
     * @tc.name Codec_DecodingPixelBox_HDR_0001
     * @tc.desc Decoding PixelMap created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBox_HDR_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBox_HDR_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBox_HDR_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelFd_HDR_0001
     * @tc.name Codec_DecodingPixelFd_HDR_0001
     * @tc.desc Decoding PixelMap created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelFd_HDR_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelFd_HDR_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelFd_HDR_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelBuffer_HDR_0001
     * @tc.name Codec_DecodingPixelBuffer_HDR_0001
     * @tc.desc Decoding PixelMap created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelBuffer_HDR_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelBuffer_HDR_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelBuffer_HDR', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPixelRawFd_HDR_0001
     * @tc.name Codec_DecodingPixelRawFd_HDR_0001
     * @tc.desc Decoding PixelMap created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPixelRawFd_HDR_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPixelRawFd_HDR_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPixelRawFd_HDR', // 描述
        done                                          // done 回调
      );
    });

    /**
     * @tc.number Codec_Release_0008
     * @tc.name Codec_Release_0008
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0008', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0008', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    /**
     * @tc.number Codec_EnterPage_0002
     * @tc.name Codec_EnterPage_0002
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_EnterPage_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_EnterPage_0002', // 测试用例名称
        'back', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_EnterPage_0002', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_EnterPage_0003
     * @tc.name Codec_EnterPage_0003
     * @tc.desc Enter picture decode page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_EnterPage_0003', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_EnterPage_0003', // 测试用例名称
        '跳转到多图解码页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_EnterPage_0003', // 描述
        done // done 回调
      );
    })

    // 多图jpeg解码
    /**
     * @tc.number Codec_ChooseSource_Jpeg_0002
     * @tc.name Codec_ChooseSource_Jpeg_0002
     * @tc.desc Select picture decoding file type: Jpeg
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_Jpeg_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_Jpeg_0002', // 测试用例名称
        'JPEG', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_Jpeg_0002', // 描述
        done // done 回调
      );
    })
    /**
     * @tc.number Codec_DecodingPictureBox_Jpeg_0001
     * @tc.name Codec_DecodingPictureBox_Jpeg_0001
     * @tc.desc Decoding Picture created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPictureBox_Jpeg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPictureBox_Jpeg_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPictureBox_Jpeg_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPictureFd_Jpeg_0001
     * @tc.name Codec_DecodingPictureFd_Jpeg_0001
     * @tc.desc Decoding Picture created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPictureFd_Jpeg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPictureFd_Jpeg_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPictureFd_Jpeg_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPictureBuffer_Jpeg_0001
     * @tc.name Codec_DecodingPictureBuffer_Jpeg_0001
     * @tc.desc Decoding Picture created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPictureBuffer_Jpeg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPictureBuffer_Jpeg_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPictureBuffer_Jpeg', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPictureRawFd_Jpeg_0001
     * @tc.name Codec_DecodingPictureRawFd_Jpeg_0001
     * @tc.desc Decoding Picture created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPictureRawFd_Jpeg_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPictureRawFd_Jpeg_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPictureRawFd_Jpeg', // 描述
        done                                          // done 回调
      );
    });

    /**
     * @tc.number Codec_Release_0009
     * @tc.name Codec_Release_0009
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0009', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0009', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    //多图HEIF解码
    /**
     * @tc.number Codec_ChooseSource_HEIF_0002
     * @tc.name Codec_ChooseSource_HEIF_0002
     * @tc.desc Select picture decoding file type: HEIF
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_ChooseSource_HEIF_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_ChooseSource_HEIF_0002', // 测试用例名称
        'HEIF', // 按钮文本
        2000, // 延时 2000 毫秒
        'ChooseSource_HEIF_0002', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPictureBox_HEIF_0001
     * @tc.name Codec_DecodingPictureBox_HEIF_0001
     * @tc.desc Decoding Picture created by the box's filePath
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPictureBox_HEIF_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPictureBox_HEIF_0001', // 测试用例名称
        '沙箱路径', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPictureBox_HEIF_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPictureFd_HEIF_0001
     * @tc.name Codec_DecodingPictureFd_HEIF_0001
     * @tc.desc Decoding Picture created by the file descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPictureFd_HEIF_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPictureFd_HEIF_0001', // 测试用例名称
        '文件描述符fd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPictureFd_HEIF_0001', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPictureBuffer_HEIF_0001
     * @tc.name Codec_DecodingPictureBuffer_HEIF_0001
     * @tc.desc Decoding Picture created by the buffer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPictureBuffer_HEIF_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPictureBuffer_HEIF_0001', // 测试用例名称
        '缓冲区数组', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPictureBuffer_HEIF', // 描述
        done                                          // done 回调
      );
    })

    /**
     * @tc.number Codec_DecodingPictureRawFd_HEIF_0001
     * @tc.name Codec_DecodingPictureRawFd_HEIF_0001
     * @tc.desc Decoding Picture created by the Resource File Descriptor
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_DecodingPictureRawFd_HEIF_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_DecodingPictureRawFd_HEIF_0001', // 测试用例名称
        '资源文件的RawFd', // 按钮文本
        2000, // 延时 2000 毫秒
        'DecodingPictureRawFd_HEIF', // 描述
        done                                          // done 回调
      );
    });

    /**
     * @tc.number Codec_Release_0010
     * @tc.name Codec_Release_0010
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0010', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0010', // 测试用例名称
        '资源释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });
    // 图片编码
    /**
     * @tc.number Codec_EnterPage_0004
     * @tc.name Codec_EnterPage_0004
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_EnterPage_0004', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_EnterPage_0004', // 测试用例名称
        'back', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_EnterPage_0004', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_EnterPage_0005
     * @tc.name Codec_EnterPage_0005
     * @tc.desc Enter image encode page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_EnterPage_0005', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_EnterPage_0005', // 测试用例名称
        '跳转到图片编码页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_EnterPage_0005', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_PackPixelToData_0001
     * @tc.name Codec_PackPixelToData_0001
     * @tc.desc Pack pixelMap to data
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_PackPixelToData_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_PackPixelToData_0001', // 测试用例名称
        'packPixelMapToData', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_PackPixelToData_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_PackSourceToData_0001
     * @tc.name Codec_PackSourceToData_0001
     * @tc.desc Pack imageSource to data
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_PackSourceToData_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_PackSourceToData_0001', // 测试用例名称
        'packImageSourceToData', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_PackSourceToData_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_PackPixelToFile_0001
     * @tc.name Codec_PackPixelToFile_0001
     * @tc.desc Pack pixelMap to file
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_PackPixelToFile_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_PackPixelToFile_0001', // 测试用例名称
        'packPixelMapToFile', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_PackPixelToFile_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_PackSourceToFile_0001
     * @tc.name Codec_PackSourceToFile_0001
     * @tc.desc Pack imageSource to file
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_PackSourceToFile_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_PackSourceToFile_0001', // 测试用例名称
        'packImageSourceToFile', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_PackSourceToFile_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_Release_0011
     * @tc.name Codec_Release_0011
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0011', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0011', // 测试用例名称
        '释放编码资源', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    // 多图编码
    /**
     * @tc.number Codec_EnterPage_0006
     * @tc.name Codec_EnterPage_0006
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_EnterPage_0006', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_EnterPage_0006', // 测试用例名称
        'back', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_EnterPage_0006', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_EnterPage_0007
     * @tc.name Codec_EnterPage_0007
     * @tc.desc Enter picture encode page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_EnterPage_0007', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_EnterPage_0007', // 测试用例名称
        '跳转到多图编码页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_EnterPage_0007', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_PackPictureToData_0001
     * @tc.name Codec_PackPictureToData_0001
     * @tc.desc Pack picture to data
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_PackPictureToData_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_PackPictureToData_0001', // 测试用例名称
        'packPictureToData', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_PackPictureToData_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_PackPictureToFile_0001
     * @tc.name Codec_PackPictureToFile_0001
     * @tc.desc Pack picture to file
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_PackPictureToFile_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_PackPictureToFile_0001', // 测试用例名称
        'packPictureToFile', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_PackPictureToFile_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Codec_Release_0012
     * @tc.name Codec_Release_0012
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_Release_0012', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_Release_0012', // 测试用例名称
        '释放编码资源', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_Release', // 描述
        done // done 回调
      );
    });

    /**
     * @tc.number Codec_EnterPage_0008
     * @tc.name Codec_EnterPage_0008
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Codec_EnterPage_0008', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Codec_EnterPage_0008', // 测试用例名称
        'back', // 按钮文本
        2000, // 延时 2000 毫秒
        'Codec_EnterPage_0008', // 描述
        done // done 回调
      );
    })
  })
}