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
 * @file SettingsDataContract.test.ets
 * @overview 契约测试 - 验证模块间接口契约
 *           覆盖：接口签名验证、数据类型契约、返回值契约、异常契约
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
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
import { TestDataCleaner } from './TestUtils';

interface ContractTestObj {
  contract_test: boolean;
}

export default function settingsDataContractTest() {
  describe('SettingsDataContract_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'contract_test';

    beforeAll(async () => {
      SettingsDBHelper.resetInstance();

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

    // ========== 接口签名验证 ==========

    it('contract_settings_db_helper_get_instance_returns_singleton', 0, () => {
      let threw = false;
      try {
        const instance1 = SettingsDBHelper.getInstance();
        const instance2 = SettingsDBHelper.getInstance();
        expect(instance1 === instance2).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_settings_db_helper_get_rdb_store_returns_promise', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        expect(rdbStore !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_global_context_get_context_returns_singleton', 0, () => {
      let threw = false;
      try {
        const ctx1 = GlobalContext.getContext();
        const ctx2 = GlobalContext.getContext();
        expect(ctx1 === ctx2).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据类型契约验证 ==========

    it('contract_settings_data_config_table_name_is_string', 0, () => {
      let threw = false;
      try {
        const tableName = settingsDataConfig.TABLE_NAME;
        expect(typeof tableName === 'string').assertTrue();
        expect(tableName.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_settings_data_config_db_name_is_string', 0, () => {
      let threw = false;
      try {
        const dbName = settingsDataConfig.DB_NAME;
        expect(typeof dbName === 'string').assertTrue();
        expect(dbName.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_settings_data_config_field_id_is_string', 0, () => {
      let threw = false;
      try {
        const fieldId = settingsDataConfig.FIELD_ID;
        expect(typeof fieldId === 'string').assertTrue();
        expect(fieldId.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_settings_data_config_field_keyword_is_string', 0, () => {
      let threw = false;
      try {
        const fieldKeyword = settingsDataConfig.FIELD_KEYWORD;
        expect(typeof fieldKeyword === 'string').assertTrue();
        expect(fieldKeyword.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_settings_data_config_field_value_is_string', 0, () => {
      let threw = false;
      try {
        const fieldValue = settingsDataConfig.FIELD_VALUE;
        expect(typeof fieldValue === 'string').assertTrue();
        expect(fieldValue.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 返回值契约验证 ==========

    it('contract_insert_returns_row_id', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': `${TEST_PREFIX}_insert_key`,
            'VALUE': 'contract_insert_value'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(typeof ret === 'number').assertTrue();
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_query_returns_resultset', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet !== undefined).assertTrue();
          expect(typeof resultSet.rowCount === 'number').assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_update_returns_affected_rows', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', `${TEST_PREFIX}_insert_key`);
          const valuesBucket: relationalStore.ValuesBucket = {
            'VALUE': 'contract_insert_value_updated'
          };
          const ret = await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          expect(typeof ret === 'number').assertTrue();
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_delete_returns_affected_rows', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', `${TEST_PREFIX}_insert_key`);
          const ret = await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
          expect(typeof ret === 'number').assertTrue();
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 上下文契约验证 ==========

    it('contract_context_set_property_returns_void', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty(`${TEST_PREFIX}_property_key`, 'contract_property_value');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_context_get_property_returns_value', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty(`${TEST_PREFIX}_get_property_key`, 'contract_get_property_value');
        const value = ctx.getProperty(`${TEST_PREFIX}_get_property_key`);
        expect(value).assertEqual('contract_get_property_value');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_context_set_object_returns_void', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const contractObj: ContractTestObj = { contract_test: true };
        ctx.setObject(`${TEST_PREFIX}_object_key`, contractObj);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_context_get_object_returns_object', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const contractObj: ContractTestObj = { contract_test: true };
        ctx.setObject(`${TEST_PREFIX}_get_object_key`, contractObj);
        const obj = ctx.getObject(`${TEST_PREFIX}_get_object_key`);
        expect(obj !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志契约验证 ==========

    it('contract_log_info_returns_void', 0, () => {
      let threw = false;
      try {
        Log.info('Contract test info message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_log_debug_returns_void', 0, () => {
      let threw = false;
      try {
        Log.debug('Contract test debug message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_log_warn_returns_void', 0, () => {
      let threw = false;
      try {
        Log.warn('Contract test warn message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_log_error_returns_void', 0, () => {
      let threw = false;
      try {
        Log.error('Contract test error message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('contract_log_fatal_returns_void', 0, () => {
      let threw = false;
      try {
        Log.fatal('Contract test fatal message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 异常契约验证 ==========

    it('contract_query_nonexistent_table_should_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query('nonexistent_table', predicates, []);
          if (resultSet === undefined || resultSet.rowCount < 0) {
            throw new Error('Query failed for nonexistent table');
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });
  });
}
