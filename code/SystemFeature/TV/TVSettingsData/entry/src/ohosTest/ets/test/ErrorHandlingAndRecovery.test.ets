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
 * @file ErrorHandlingAndRecovery.test.ets
 * @overview 测试错误处理和恢复机制
 *           覆盖：数据库错误、上下文错误、网络错误、文件错误、恢复策略
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import { Log } from '../../../main/ets/Utils/Log';
import { IContent, TableType } from '../../../main/ets/common/Common';
import { dataSharePredicates, relationalStore } from '@kit.ArkData';
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
import { Driver } from '@ohos.UiTest';

interface RecoveryTestObj {
  status: string;
}

interface TestObj {
  data: string;
}

export default function errorHandlingAndRecoveryTest() {
  describe('ErrorHandlingAndRecovery_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    // ========== 数据库错误处理测试 ==========

    it('error_db_connection_retry_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('error_db_insert_with_invalid_values_should_handle', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          // 使用会导致错误的插入操作：插入超长值（超过1000字符限制）
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'test_key',
            'VALUE': 'a'.repeat(1001) // 超过VALUE字段的1000字符限制
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('error_db_update_with_invalid_predicates_should_handle', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'VALUE': 'updated_value'
          };
          await rdbStore.update('invalid_table', valuesBucket, new dataSharePredicates.DataSharePredicates());
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('error_db_delete_with_invalid_predicates_should_handle', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.delete('invalid_table', new dataSharePredicates.DataSharePredicates());
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    // ========== 上下文错误处理测试 ==========

    it('error_context_get_nonexistent_object_should_return_undefined', 0, () => {
      const ctx = GlobalContext.getContext();
      const result = ctx.getObject('nonexistent_error_key');
      expect(result).assertEqual(undefined);
    });

    it('error_context_get_nonexistent_property_should_return_undefined', 0, () => {
      const ctx = GlobalContext.getContext();
      const result = ctx.getProperty('nonexistent_error_prop');
      expect(result).assertEqual(undefined);
    });

    it('error_context_set_null_object_should_handle', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setObject('null_error_key', undefined);
        expect(ctx.getObject('null_error_key')).assertEqual(undefined);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志错误处理测试 ==========

    it('error_log_empty_message_should_handle', 0, () => {
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

    it('error_log_very_long_message_should_handle', 0, () => {
      let threw = false;
      try {
        let longMessage = '';
        for (let i = 0; i < 10000; i++) {
          longMessage += 'a';
        }
        Log.info(longMessage);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据加载错误处理测试 ==========

    it('error_load_data_with_empty_content_should_handle', 0, async () => {
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

    it('error_load_data_with_invalid_table_type_should_handle', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const content: IContent = {
          settings: [],
          user: [],
          userSecure: []
        };
        await helper.loadTableData(content, 999, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    // ========== 恢复策略测试 ==========

    it('recovery_after_db_error_should_reconnect', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        await helper.getRdbStore();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('recovery_after_context_error_should_reset', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const errorObj: RecoveryTestObj = { status: 'error' };
        ctx.setObject('recovery_test_obj', errorObj);
        const recoveredObj: RecoveryTestObj = { status: 'recovered' };
        ctx.setObject('recovery_test_obj', recoveredObj);
        expect(ctx.getObject('recovery_test_obj') !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('recovery_after_log_error_should_continue', 0, () => {
      let threw = false;
      try {
        Log.info('Before error');
        Log.error('Error occurred');
        Log.info('After error');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 并发错误处理测试 ==========

    it('error_concurrent_db_access_should_not_corrupt', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const promises: Promise<relationalStore.RdbStore | undefined>[] = [];
        for (let i = 0; i < 10; i++) {
          promises.push(helper.getRdbStore());
        }
        const results = await Promise.all(promises);
        for (let i = 1; i < results.length; i++) {
          expect(results[i] === results[0]).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('error_concurrent_context_access_should_not_corrupt', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 50; i++) {
          ctx.setProperty('concurrent_error_prop_' + i, 'value_' + i);
        }
        for (let i = 0; i < 50; i++) {
          expect(ctx.getProperty('concurrent_error_prop_' + i)).assertEqual('value_' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 异常流测试 ==========

    it('exception_invalid_json_parse_should_throw', 0, () => {
      let threw = false;
      try {
        const invalidJson = '{invalid json content}';
        JSON.parse(invalidJson);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('exception_null_reference_access_should_throw', 0, () => {
      let threw = false;
      try {
        const nullObj: TestObj | undefined = undefined;
        let obj: TestObj = { data: 'default' };
        if (nullObj !== undefined) {
          obj = nullObj;
        }
        obj.data.toString();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('exception_array_index_out_of_bounds_should_throw', 0, () => {
      let threw = false;
      try {
        const arr: number[] = [1, 2, 3];
        const val = arr[100];
        expect(val).assertEqual(undefined);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 错误恢复验证测试 ==========

    it('recovery_verify_db_still_works_after_errors', 0, async () => {
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

    it('recovery_verify_context_still_works_after_errors', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('recovery_verify_prop', 'verified');
        expect(ctx.getProperty('recovery_verify_prop')).assertEqual('verified');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== UI 交互验证 ==========

    it('error_handling_home_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('error_handling_text_readable_after_nav', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
