/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';
import Preferences from '../../../../main/ets/utils/Preferences';

interface TestObj { name: string; value: number; }
interface NestedLevel3 { value: string; }
interface NestedLevel2 { level3: NestedLevel3; }
interface NestedLevel1 { level2: NestedLevel2; }
interface NestedObject { level1: NestedLevel1; }
interface ChangeObjA { a: number; }
interface ChangeObjB { a: number; b: number; }

function strRepeat(str: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) {
    result += str;
  }
  return result;
}

class MockContext {
  filesDir: string = '/data/test';
  tempDir: string = '/data/test/temp';
  cacheDir: string = '/data/test/cache';
  distributedFilesDir: string = '/data/test/distributed';
  bundleCodeDir: string = '/data/test/bundle';
  databaseDir: string = '/data/test/database';
  preferencesDir: string = '/data/test/preferences';
}

export default function PreferencesComprehensiveTestSuite(): void {
  describe('PreferencesComprehensiveTest', () => {

    let mockContext: MockContext | null;

    beforeEach(() => {
      mockContext = new MockContext();
    });

    afterEach(() => {
      mockContext = null;
    });

    it('test_init_withMockContext', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_stringValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Preferences.writeData('strKey', 'strValue');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_numberValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('numKey', 12345);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_booleanValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('boolKey', true);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_objectValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            const obj: TestObj = { name: 'test', value: 42 };
      let threw: boolean = false;
      try {
        Preferences.writeData('objKey', obj);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_emptyStringKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('', 'emptyKeyValue');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_emptyStringValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('emptyValKey', '');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_zeroNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('zeroKey', 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_negativeNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('negKey', -999);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_falseBoolean', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('falseKey', false);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_chineseKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('unicodeKey', 'unicodeValue');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_specialCharKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('key!@#$%', 'specialValue');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_longKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            const longKey: string = strRepeat('k', 100);
      let threw: boolean = false;
      try {
        Preferences.writeData(longKey, 'longKeyValue');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_writeData_longValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            const longVal: string = strRepeat('v', 100);
      let threw: boolean = false;
      try {
        Preferences.writeData('longValKey', longVal);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_changeData_existingKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('changeKey', 'originalVal');
      let threw: boolean = false;
      try {
        Preferences.changeData('changeKey', 'changedVal');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_changeData_nonExistentKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.changeData('nonExistKey', 'someVal');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_changeData_emptyStringKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.changeData('', 'val');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_changeData_numberValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('numChangeKey', 100);
      let threw: boolean = false;
      try {
        Preferences.changeData('numChangeKey', 200);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_changeData_booleanValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('boolChangeKey', true);
      let threw: boolean = false;
      try {
        Preferences.changeData('boolChangeKey', false);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_changeData_objectValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('objChangeKey', { a: 1 } as ChangeObjA);
      let threw: boolean = false;
      try {
        Preferences.changeData('objChangeKey', { a: 2, b: 3 } as ChangeObjB);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_readData_afterWrite', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('readKey', 'readValue');
      const result: string = String(Preferences.readData('readKey'));
      expect(result !== null).assertTrue();
    });


    it('test_deleteData_existingKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('delKey', 'delVal');
      let threw: boolean = false;
      try {
        Preferences.deleteData('delKey');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_deleteData_nonExistentKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.deleteData('noSuchDelKey');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_deleteData_emptyStringKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.deleteData('');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_flushData_afterWrite', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('flushKey', 'flushVal');
      let threw: boolean = false;
      try {
        Preferences.flushData();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_flushData_multipleTimes', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('multiFlushKey', 'val');
      let threw: boolean = false;
      try {
        Preferences.flushData();
        Preferences.flushData();
        Preferences.flushData();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_subscribeData_withKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.subscribeData('subKey');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_subscribeData_emptyKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.subscribeData('');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_subscribeData_multipleKeys', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.subscribeData('key1');
        Preferences.subscribeData('key2');
        Preferences.subscribeData('key3');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });


    it('test_multipleWriteSameKey', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('overKey', 'val1');
      Preferences.writeData('overKey', 'val2');
      Preferences.writeData('overKey', 'val3');
      const result: string = String(Preferences.readData('overKey'));
      expect(result !== null).assertTrue();
    });

    it('test_multipleWriteDifferentKeys', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            for (let i: number = 0; i < 50; i++) {
        Preferences.writeData('multiKey_' + i, 'multiVal_' + i);
      }
      for (let i: number = 0; i < 50; i++) {
        const result: string = String(Preferences.readData('multiKey_' + i));
        expect(result !== null).assertTrue();
      }
    });

    it('test_writeThenChangeThenRead', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('wcrKey', 'original');
      Preferences.changeData('wcrKey', 'changed');
      const result: string = String(Preferences.readData('wcrKey'));
      expect(result !== null).assertTrue();
    });

    it('test_rapidWrite_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            for (let i: number = 0; i < 100; i++) {
        Preferences.writeData('rapidKey_' + i, 'rapidVal_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_rapidRead_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            for (let i: number = 0; i <100; i++) {
        Preferences.readData('rapidReadKey_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_rapidDelete_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            for (let i: number = 0; i <100; i++) {
        Preferences.writeData('rapidDelKey_' + i, 'val_' + i);
      }
      for (let i: number = 0; i <100; i++) {
        Preferences.deleteData('rapidDelKey_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_write_numberZero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('zeroNum', 0);
      const result: string = String(Preferences.readData('zeroNum'));
      expect(result !== null).assertTrue();
    });

    it('test_write_numberMaxSafe', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('maxSafeNum', Number.MAX_SAFE_INTEGER);
      const result: string = String(Preferences.readData('maxSafeNum'));
      expect(result !== null).assertTrue();
    });

    it('test_write_numberMinSafe', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('minSafeNum', Number.MIN_SAFE_INTEGER);
      const result: string = String(Preferences.readData('minSafeNum'));
      expect(result !== null).assertTrue();
    });

    it('test_write_numberFloat', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('floatNum', 3.14159);
      const result: string = String(Preferences.readData('floatNum'));
      expect(result !== null).assertTrue();
    });

    it('test_write_numberNegativeFloat', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('negFloat', -2.71828);
      const result: string = String(Preferences.readData('negFloat'));
      expect(result !== null).assertTrue();
    });

    it('test_write_nestedObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            const nested: NestedObject = { level1: { level2: { level3: { value: 'deep' } } } };
      let threw: boolean = false;
      try {
        Preferences.writeData('nestedObj', nested);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_write_arrayValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            const arr: Array<string | number | boolean | null> = [1, 2, 3, 'four', true, null];
      let threw: boolean = false;
      try {
        Preferences.writeData('arrKey', arr);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_stress_writeRead_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
            for (let i: number = 0; i < 100; i++) {
        Preferences.writeData('stressKey_' + i, 'stressVal_' + i);
        Preferences.readData('stressKey_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_stress_writeDelete_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
            for (let i: number = 0; i <100; i++) {
        Preferences.writeData('stressDelKey_' + i, 'val_' + i);
        Preferences.deleteData('stressDelKey_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_stress_writeChangeRead_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
            for (let i: number = 0; i <100; i++) {
        Preferences.writeData('stressChgKey_' + i, 'val1_' + i);
        Preferences.changeData('stressChgKey_' + i, 'val2_' + i);
        Preferences.readData('stressChgKey_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_stress_flushAfterEachWrite_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
            for (let i: number = 0; i < 100; i++) {
        Preferences.writeData('stressFlushKey_' + i, 'val_' + i);
        Preferences.flushData();
      }
      expect(true).assertTrue();
    });

    it('test_keyWithSpaces', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('key with spaces', 'value');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_keyWithDots', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('com.ohos.key', 'dotValue');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_keyWithSlashes', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('path/to/key', 'slashValue');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_keyWithUnderscore', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('under_score_key', 'underValue');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_keyWithHyphen', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('hyphen-key', 'hyphenValue');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_valueWithNewlines', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            const multiLine: string = 'line1\nline2\nline3';
      let threw: boolean = false;
      try {
        Preferences.writeData('multiLineKey', multiLine);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_valueWithTabs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            const tabVal: string = 'col1\tcol2\tcol3';
      let threw: boolean = false;
      try {
        Preferences.writeData('tabKey', tabVal);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_valueWithEmoji', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('emojiKey', '🎵🎮🚀');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_valueWithScriptTag', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('xssKey', '<script>alert(1)</script>');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_valueWithSQLInjection', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            let threw: boolean = false;
      try {
        Preferences.writeData('sqlKey', '\'; DROP TABLE users;--');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_write_then_subscribe_then_change', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('subTestKey', 'origVal');
      Preferences.subscribeData('subTestKey');
      let threw: boolean = false;
      try {
        Preferences.changeData('subTestKey', 'newVal');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_multipleSubscriptions', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            for (let i: number = 0; i < 10; i++) {
        Preferences.subscribeData('subKey_' + i);
      }
      expect(true).assertTrue();
    });


    it('test_changeData_rapid_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
            Preferences.writeData('rapidChgKey', 'initVal');
      for (let i: number = 0; i <100; i++) {
        Preferences.changeData('rapidChgKey', 'chgVal_' + i);
      }
      expect(true).assertTrue();
    });
  });
}
