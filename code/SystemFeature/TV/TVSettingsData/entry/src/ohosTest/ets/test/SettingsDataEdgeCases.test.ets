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

/**
 * @file SettingsDataEdgeCases.test.ets
 * @overview 测试设置数据边界情况和极端场景
 *           覆盖：空值处理、极值测试、特殊字符、异常输入、边界条件
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
import { IContent, TableType } from '../../../main/ets/common/Common';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import { Log } from '../../../main/ets/Utils/Log';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_COLD_START,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';
import { Driver } from '@kit.TestKit';
import { dataSharePredicates, relationalStore } from '@kit.ArkData';

interface EmptyKeyObject {
  empty_key_object: boolean;
}

export default function settingsDataEdgeCasesTest() {
  describe('SettingsDataEdgeCases_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'edgecases_test';

    beforeAll(async () => {
      SettingsDBHelper.resetInstance();
      TestDataCleaner.reset();

      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);

      const ctx = GlobalContext.getContext();
      const abilityContext = getContext() as Context;
      ctx.setObject('abilityContext', abilityContext);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    beforeEach(async () => {
      TestDataCleaner.reset();
    });

    afterEach(async () => {
      await TestDataCleaner.cleanTestDataByPrefix(TEST_PREFIX);
    });

    // ========== 空值处理测试 ==========

    it('edge_empty_string_key', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = '';
        const value = 'empty_key_value';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('edge_empty_string_value', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_empty_value_key`;
        const value = '';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('edge_empty_content_load', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const content: IContent = {
          settings: [],
          user: [],
          userSecure: []
        };
        await helper.loadTableData(content, TableType.SETTINGS, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 极值测试 ==========

    it('edge_max_length_key', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        let maxKey = '';
        for (let i = 0; i < 900; i++) {
          maxKey += 'K';
        }
        const value = 'max_length_key_value';
        
        const ret = await DatabaseTestHelper.insertTestData(maxKey, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('edge_max_length_value', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_max_length_value_key`;
        let maxValue = '';
        for (let i = 0; i < 900; i++) {
          maxValue += 'V';
        }
        
        const ret = await DatabaseTestHelper.insertTestData(key, maxValue);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('edge_min_length_key', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = 'a';
        const value = 'min_length_key_value';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('edge_min_length_value', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_min_length_value_key`;
        const value = 'a';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    // ========== 特殊字符测试 ==========

    it('edge_special_chars_in_key', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = 'edge_special!@#$%^&*()_+-=[]{}|;:,.<>?';
        const value = 'special_chars_value';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('edge_special_chars_in_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge_special_chars_value_key',
            'VALUE': 'value!@#$%^&*()_+-=[]{}|;:,.<>?'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_newline_chars_in_key', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge\nnewline\rkey',
            'VALUE': 'newline_chars_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_newline_chars_in_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge_newline_chars_value_key',
            'VALUE': 'value\nwith\rnewlines'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_tab_chars_in_key', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge\ttab\tkey',
            'VALUE': 'tab_chars_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_tab_chars_in_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge_tab_chars_value_key',
            'VALUE': 'value\twith\ttabs'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== Unicode测试 ==========

    it('edge_unicode_chinese_key', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': '设置键名',
            'VALUE': 'unicode_chinese_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_unicode_chinese_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge_unicode_chinese_value_key',
            'VALUE': '设置值内容'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_unicode_emoji_key', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge_emoji_🔑',
            'VALUE': 'unicode_emoji_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_unicode_emoji_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge_unicode_emoji_value_key',
            'VALUE': '🔒🔑🛡️'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_unicode_japanese_key', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': '設定キー',
            'VALUE': 'unicode_japanese_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_unicode_korean_key', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': '설정키',
            'VALUE': 'unicode_korean_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 重复数据测试 ==========

    it('edge_duplicate_key_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket1: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge_duplicate_key',
            'VALUE': 'duplicate_value_1'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket1);

          const valuesBucket2: relationalStore.ValuesBucket = {
            'KEYWORD': 'edge_duplicate_key',
            'VALUE': 'duplicate_value_2'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket2);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 上下文边界测试 ==========

    it('edge_context_empty_key_property', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('', 'empty_key_property_value');
        expect(ctx.getProperty('')).assertEqual('empty_key_property_value');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_context_empty_key_object', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const emptyKeyObj: EmptyKeyObject = { empty_key_object: true };
        ctx.setObject('', emptyKeyObj);
        expect(ctx.getObject('') !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_context_very_long_key', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        let longKey = '';
        for (let i = 0; i < 500; i++) {
          longKey += 'L';
        }
        ctx.setProperty(longKey, 'very_long_key_value');
        expect(ctx.getProperty(longKey)).assertEqual('very_long_key_value');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_context_very_long_value', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        let longValue = '';
        for (let i = 0; i < 5000; i++) {
          longValue += 'V';
        }
        ctx.setProperty('edge_context_very_long_value_key', longValue);
        expect(ctx.getProperty('edge_context_very_long_value_key')).assertEqual(longValue);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志边界测试 ==========

    it('edge_log_empty_message', 0, () => {
      let threw = false;
      try {
        Log.info('');
        Log.debug('');
        Log.warn('');
        Log.error('');
        Log.fatal('');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('edge_log_very_long_message', 0, () => {
      let threw = false;
      try {
        let longMessage = '';
        for (let i = 0; i < 10000; i++) {
          longMessage += 'L';
        }
        Log.info(longMessage);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
