/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_ZipLib]';
const DOMAIN = 0xF811;
const BUNDLE = 'ZipLib_';

export default function appTest() {
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number     : ZipLib_StartAbilityFunction_001
     * @tc.name       : ZipLib_StartAbilityFunction_001
     * @tc.desc       : test start ability
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('ZipLib_StartAbilityFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.ziplib',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
    })
    /**
     * @tc.number     : ZipLib_AddFileFunction_001
     * @tc.name       : ZipLib_AddFileFunction_001
     * @tc.desc       : test file compression and uncompression
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('ZipLib_AddFileFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 clickAddBtn');
      // 进入zipLib解压缩文件页面
      let zipLibDecompression = await driver.findComponent(ON.id('zipLibDecompression'));
      await zipLibDecompression.click();
      await driver.delayMs(1000);
      // 点击添加
      await driver.assertComponentExist(ON.id('addFileBtn'));
      let btnAdd = await driver.findComponent(ON.id('addFileBtn'));
      await btnAdd.click();
      await driver.delayMs(1000);
      // 输入文件名称
      await driver.assertComponentExist(ON.id('inputFileName'));
      let fileNameInput = await driver.findComponent(ON.id('inputFileName'));
      await fileNameInput.inputText('fileName');
      // 输入文件内容
      await driver.assertComponentExist(ON.id('inputFileContent'));
      let fileContentInput = await driver.findComponent(ON.id('inputFileContent'));
      await fileContentInput.inputText('fileContent');
      // 点击确认
      await driver.assertComponentExist(ON.id('confirmBtn'));
      let confirmBtn = await driver.findComponent(ON.id('confirmBtn'));
      await confirmBtn.click();
      await driver.delayMs(1000);
      // 点击压缩
      await driver.assertComponentExist(ON.id('compress_0'));
      let compressBtn = await driver.findComponent(ON.id('compress_0'));
      await compressBtn.click();
      await driver.delayMs(1000);
      // 点击解压
      await driver.assertComponentExist(ON.id('compress_1'));
      let decompressBtn = await driver.findComponent(ON.id('compress_1'));
      await decompressBtn.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 end');
      done();
    })

    /**
     * @tc.number     : ZipLib_CompressFiles_001
     * @tc.name       : ZipLib_CompressFiles_001
     * @tc.desc       : test multiple file compression
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('ZipLib_CompressFiles_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CompressFiles_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('zlibInterface'));
      let btnZipLib = await driver.findComponent(ON.id('zlibInterface'));
      await btnZipLib.click();
      await driver.delayMs(1000);
      // 点击压缩多个文件
      await driver.assertComponentExist(ON.id('compressFiles'));
      let compressFiles = await driver.findComponent(ON.id('compressFiles'));
      await compressFiles.click();
      await driver.delayMs(1000);
      // 点击添加
      await driver.assertComponentExist(ON.id('addFile'));
      let btnAddOne = await driver.findComponent(ON.id('addFile'));
      await btnAddOne.click();
      await driver.delayMs(1000);
      // 输入文件名称
      await driver.assertComponentExist(ON.id('inputFileName'));
      let fileNameInputOne = await driver.findComponent(ON.id('inputFileName'));
      await fileNameInputOne.inputText('fileName');
      // 输入文件内容
      await driver.assertComponentExist(ON.id('inputFileContent'));
      let fileContentInputOne = await driver.findComponent(ON.id('inputFileContent'));
      await fileContentInputOne.inputText('fileContent');
      // 点击确认
      await driver.assertComponentExist(ON.id('confirmBtn'));
      let confirmBtnOne = await driver.findComponent(ON.id('confirmBtn'));
      await confirmBtnOne.click();
      await driver.delayMs(1000);
      //点击添加
      await driver.assertComponentExist(ON.id('addFile'));
      let btnAddTwo = await driver.findComponent(ON.id('addFile'));
      await btnAddTwo.click();
      await driver.delayMs(1000);
      // 输入文件名称
      await driver.assertComponentExist(ON.id('inputFileName'));
      let fileNameInputTwo = await driver.findComponent(ON.id('inputFileName'));
      await fileNameInputTwo.inputText('fileName1');
      // 输入文件内容
      await driver.assertComponentExist(ON.id('inputFileContent'));
      let fileContentInputTwo = await driver.findComponent(ON.id('inputFileContent'));
      await fileContentInputTwo.inputText('fileContent1');
      // 点击确认
      await driver.assertComponentExist(ON.id('confirmBtn'));
      let confirmBtnTwo = await driver.findComponent(ON.id('confirmBtn'));
      await confirmBtnTwo.click();
      await driver.delayMs(1000);
      // 选中要压缩的文件
      await driver.assertComponentExist(ON.id('file_0'));
      let fileOne = await driver.findComponent(ON.id('file_0'));
      await fileOne.click();
      await driver.delayMs(1000);
      // 选中要压缩的文件
      await driver.assertComponentExist(ON.id('file_1'));
      let fileTwo = await driver.findComponent(ON.id('file_1'));
      await fileTwo.click();
      await driver.delayMs(1000);
      // 点击压缩
      await driver.assertComponentExist(ON.id('compress'));
      let compressBtn = await driver.findComponent(ON.id('compress'));
      await compressBtn.click();
      await driver.delayMs(3000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'CompressFiles_001 end');
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      done()
    })

    /**
     * @tc.number     : ZipLib_GzipInterface_001
     * @tc.name       : ZipLib_GzipInterface_001
     * @tc.desc       : test gzip decompression and compression function
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('ZipLib_GzipInterface_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GzipInterface_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);

      // 点击gzip接口调用
      await driver.assertComponentExist(ON.id('gzipinterface'));
      let gzipinterface = await driver.findComponent(ON.id('gzipinterface'));
      await gzipinterface.click();
      await driver.delayMs(5000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'GzipInterface_001 end');
      await driver.delayMs(1000);
      done()
    })

    /**
     * @tc.number     : ZipLib_ZlibInterface_001
     * @tc.name       : ZipLib_ZlibInterface_001
     * @tc.desc       : test zlib decompression and compression function
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('ZipLib_ZlibInterface_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ZlibInterface_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);

      // 点击zlib接口调用
      await driver.assertComponentExist(ON.id('zlibinterface'));
      let zlibinterface = await driver.findComponent(ON.id('zlibinterface'));
      await zlibinterface.click();
      await driver.delayMs(3000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'ZlibInterface_001 end');
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      done()
    })
  })
}