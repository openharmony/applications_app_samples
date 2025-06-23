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

import { describe, it, expect } from '@ohos/hypium';

export default function dynamicImportTest() {
  describe('dynamicImportTest', () => {

    it('testDynamicImport001', 0, async () => {
      console.info('uitest: testDynamicImport001 begin');
      let har: ESObject = await import('harlibrary');
      expect(har.Calc.staticAdd(8, 9)).assertEqual(17);
      let calc: ESObject = new har.Calc();
      expect(calc.instanceAdd(10, 11)).assertEqual(21);
      expect(har.addHarlibrary(6, 7)).assertEqual(13);

      let className = 'Calc';
      let methodName = 'instanceAdd';
      let staticMethod = 'staticAdd';
      let functionName = 'addHarlibrary';
      expect(har[className][staticMethod](12, 13)).assertEqual(25);
      let calc1: ESObject = new har[className]();
      expect(calc1[methodName](14, 15)).assertEqual(29);
      expect(har[functionName](16, 17)).assertEqual(33);
      console.info('uitest: testDynamicImport001 end');
    })

    it('testDynamicImport002', 0, async () => {
      console.info('uitest: testDynamicImport002 begin');
      let har: ESObject = await import('myhar');
      expect(har.add(2, 3)).assertEqual(5);
      console.info('uitest: testDynamicImport002 end');
    })

    it('testDynamicImport003', 0, async () => {
      console.info('uitest: testDynamicImport003 begin');
      let har: ESObject = await import('myhar/Index');
      expect(har.add(2, 3)).assertEqual(5);
      console.info('uitest: testDynamicImport003 end');
    })

    it('testDynamicImport004', 0, async () => {
      console.info('uitest: testDynamicImport004 begin');
      let hsp: ESObject = await import('myhsp');
      expect(hsp.add(2, 3)).assertEqual(5);
      console.info('uitest: testDynamicImport004 end');
    })

    it('testDynamicImport005', 0, async () => {
      console.info('uitest: testDynamicImport005 begin');
      let hsp: ESObject = await import('myhsp/Index');
      expect(hsp.add(2, 3)).assertEqual(5);
      console.info('uitest: testDynamicImport005 end');
    })

    it('testDynamicImport006', 0, async () => {
      console.info('uitest: testDynamicImport006 begin');
      let har: ESObject = await import('@ohos/crypto-js');
      expect(har.CryptoJS.src).assertUndefined();
      console.info('uitest: testDynamicImport006 end');
    })

    it('testDynamicImport007', 0, async () => {
      console.info('uitest: testDynamicImport007 begin');
      let ohpm: ESObject = await import('@ohos/hypium');
      expect(ohpm.TestType.FUNCTION).assertEqual(1);
      console.info('uitest: testDynamicImport007 end');
    })

    it('testDynamicImport008', 0, async () => {
      console.info('uitest: testDynamicImport008 begin');
      let singleFile: ESObject = await import('../../../../src/main/ets/Calc');
      expect(singleFile.add(3, 5)).assertEqual(8);
      console.info('uitest: testDynamicImport008 end');
    })

    it('testDynamicImport009', 0, async () => {
      console.info('uitest: testDynamicImport009 begin');
      let native: ESObject = await import('libentry.so');
      expect(native.default.add(2, 3)).assertEqual(5);
      console.info('uitest: testDynamicImport009 end');
    })

    it('testDynamicImport010', 0, async () => {
      console.info('uitest: testDynamicImport010 begin');
      let systemApp: ESObject = await import('@system.app');
      expect(systemApp.default.getInfo()).assertNull();
      console.info('uitest: testDynamicImport010 end');
    })

    it('testDynamicImport011', 0, async () => {
      console.info('uitest: testDynamicImport011 begin');
      let curves: ESObject = await import('@ohos.curves');
      expect(curves.default.springMotion(0.555, 0.75, 0.001).interpolate(1)).assertEqual(0);
      console.info('uitest: testDynamicImport011 end');
    })

    it('testDynamicImport012', 0, async () => {
      console.info('uitest: testDynamicImport012 begin');
      let matrix4: ESObject = await import('@ohos.matrix4');
      expect(matrix4.default.identity().transformPoint([1, 2])[0]).assertEqual(1);
      console.info('uitest: testDynamicImport012 end');
    })

    it('testDynamicImport013', 0, async () => {
      console.info('uitest: testDynamicImport013 begin');
      let hilog: ESObject = await import('@ohos.hilog');
      expect(hilog.default.LogLevel.DEBUG).assertEqual(3);
      console.info('uitest: testDynamicImport013 end');
    })

    it('testDynamicImport014', 0, async () => {
      console.info('uitest: testDynamicImport014 begin');
      let harName = 'myhar';
      let har: ESObject = await import(harName);
      expect(har.add(3, 5)).assertEqual(8);
      console.info('uitest: testDynamicImport014 end');
    })

    it('testDynamicImport015', 0, async () => {
      console.info('uitest: testDynamicImport015 begin');
      let filePath = '../../../main/ets/utils/Calc';
      let file: ESObject = await import(filePath);
      expect(file.add(3, 5)).assertEqual(8);
      console.info('uitest: testDynamicImport015 end');
    })

    it('testDynamicImport016', 0, async () => {
      console.info('uitest: testDynamicImport016 begin');
      let harPackageName = 'myhar';
      let har: ESObject = await import(harPackageName);
      expect(har.add(3, 5)).assertEqual(8);
      console.info('uitest: testDynamicImport016 end');
    })

    it('testDynamicImport017', 0, async () => {
      console.info('uitest: testDynamicImport017 begin');
      let hspPackageName = 'myhsp';
      let hsp: ESObject = await import(hspPackageName);
      expect(hsp.add(3, 5)).assertEqual(8);
      console.info('uitest: testDynamicImport017 end');
    })

    it('testDynamicImport018', 0, async () => {
      console.info('uitest: testDynamicImport018 begin');
      let remoteHarPackageName = '@ohos/crypto-js';
      let har: ESObject = await import(remoteHarPackageName);
      expect(har.CryptoJS.src).assertUndefined();
      console.info('uitest: testDynamicImport018 end');
    })

    it('testDynamicImport019', 0, async () => {
      console.info('uitest: testDynamicImport019 begin');
      let ohpmPackageName = '@ohos/hypium';
      let ohpm: ESObject = await import(ohpmPackageName);
      expect(ohpm.TestType.FUNCTION).assertEqual(1);
      console.info('uitest: testDynamicImport019 end');
    })

    it('testDynamicImport020', 0, async () => {
      console.info('uitest: testDynamicImport020 begin');
      let calcFilePath = '../../../../src/main/ets/Calc';
      let singleFile: ESObject = await import(calcFilePath);
      expect(singleFile.add(3, 5)).assertEqual(8);
      console.info('uitest: testDynamicImport020 end');
    })

    it('testDynamicImport021', 0, async () => {
      console.info('uitest: testDynamicImport021 begin');
      let soName = 'libentry.so';
      let native: ESObject = await import(soName);
      expect(native.default.add(2, 3)).assertEqual(5);
      console.info('uitest: testDynamicImport021 end');
    })

    it('testDynamicImport022', 0, async () => {
      console.info('uitest: testDynamicImport022 begin');
      let packageName = '@system.app';
      let systemApp: ESObject = await import(packageName);
      expect(systemApp.default.getInfo()).assertNull();
      console.info('uitest: testDynamicImport022 end');
    })

    it('testDynamicImport023', 0, async () => {
      console.info('uitest: testDynamicImport023 begin');
      let packageName = '@ohos.curves';
      let curves: ESObject = await import(packageName);
      expect(curves.default.springMotion(0.555, 0.75, 0.001).interpolate(1)).assertEqual(0);
      console.info('uitest: testDynamicImport023 end');
    })

    it('testDynamicImport024', 0, async () => {
      console.info('uitest: testDynamicImport024 begin');
      let packageName = '@ohos.matrix4';
      let matrix4: ESObject = await import(packageName);
      expect(matrix4.default.identity().transformPoint([1, 2])[0]).assertEqual(1);
      console.info('uitest: testDynamicImport024 end');
    })

    it('testDynamicImport025', 0, async () => {
      console.info('uitest: testDynamicImport025 begin');
      let packageName = '@ohos.hilog';
      let hilog: ESObject = await import(packageName);
      expect(hilog.default.LogLevel.DEBUG).assertEqual(3);
      console.info('uitest: testDynamicImport025 end');
    })

    it('testDynamicImport026', 0, async () => {
      console.info('uitest: testDynamicImport026 begin');
      let harName = 'har1';
      let har: ESObject = await import(harName);
      expect(har.addHar1(4, 5)).assertEqual(9);
      console.info('uitest: testDynamicImport026 end');
    })
  })
}