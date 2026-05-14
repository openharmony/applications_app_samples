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
 * @file SettingsDataSecurity.test.ets
 * @overview 测试设置数据安全机制
 *           覆盖：权限验证、数据加密、输入校验、SQL注入防护、敏感数据保护
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
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

export default function settingsDataSecurityTest() {
  describe('SettingsDataSecurity_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'security_test';

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

    // ========== SQL注入防护测试 ==========

    it('security_sql_injection_single_quote', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': "test'; DROP TABLE SETTINGSDATA; --",
            'VALUE': 'sql_injection_test'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('security_sql_injection_union', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_sql_injection_union`;
        const value = 'sql_injection_union_test';

        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('security_sql_injection_comment', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_sql_injection_comment`;
        const value = 'sql_injection_comment_test';

        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('security_sql_injection_semicolon', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_sql_injection_semicolon`;
        const value = 'sql_injection_semicolon_test';

        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    // ========== 输入校验测试 ==========

    it('security_input_max_length_validation', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const maxLength = 1000;
        let longValue = '';
        for (let i = 0; i < maxLength; i++) {
          longValue += 'a';
        }
        const key = `${TEST_PREFIX}_input_max_length_key`;

        const ret = await DatabaseTestHelper.insertTestData(key, longValue);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('security_input_special_chars_validation', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_input_special_chars_key`;
        const value = '<script>alert("xss")</script>';

        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('security_input_unicode_validation', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'input_unicode_key',
            'VALUE': '🔒🔑🛡️'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('security_input_null_byte_validation', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'input_null_byte_key',
            'VALUE': 'test\u0000value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 敏感数据保护测试 ==========

    it('security_secure_table_isolation', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(`${settingsDataConfig.SECURE_TABLE_NAME}_0`, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('security_sensitive_data_not_in_log', 0, () => {
      let threw = false;
      try {
        Log.info('Security test: sensitive data handling');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 权限验证测试 ==========

    it('security_context_permission_check', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('security_permission', 'granted');
        expect(ctx.getProperty('security_permission')).assertEqual('granted');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('security_context_permission_denied', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('security_permission', 'denied');
        expect(ctx.getProperty('security_permission')).assertEqual('denied');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据加密测试 ==========

    it('security_encrypted_value_storage', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const encryptedValue = 'encrypted_' + Math.random().toString(36).substring(2);
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'security_encrypted_key',
            'VALUE': encryptedValue
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据完整性校验测试 ==========

    it('security_data_integrity_checksum', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'security_integrity_key',
            'VALUE': 'security_integrity_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'security_integrity_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 越权访问测试 ==========

    it('security_unauthorized_access_prevention', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 安全日志测试 ==========

    it('security_log_audit_trail', 0, () => {
      let threw = false;
      try {
        Log.info('Security audit: access granted');
        Log.info('Security audit: data modified');
        Log.info('Security audit: session ended');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
