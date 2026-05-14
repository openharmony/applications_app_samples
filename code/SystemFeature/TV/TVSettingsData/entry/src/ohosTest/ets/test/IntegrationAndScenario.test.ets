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
 * @file IntegrationAndScenario.test.ets
 * @overview 测试集成场景和端到端流程
 *           覆盖：完整业务流程、多模块协作、端到端验证
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import { IContent, TableType } from '../../../main/ets/common/Common';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import { Log } from '../../../main/ets/Utils/Log';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_LEFT,
  KEY_RIGHT,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  STABLE_TOLERANCE,
  STABLE_ROUNDS,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS
} from './SharedDriver';
import { Driver } from '@kit.TestKit';

interface MockContext {
  bundleName: string;
}

interface ChainTestObj {
  step: number;
}

interface RegressionTestObj {
  status: string;
}

export default function integrationAndScenarioTest() {
  describe('IntegrationAndScenario_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'integration_test';

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

    // ========== 完整业务流程测试 ==========

    it('integration_full_settings_workflow', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();

        Log.info('Integration test: workflow completed');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('integration_context_db_log_chain', 0, async () => {
      let threw = false;
      try {
        Log.info('Starting integration chain test');

        const ctx = GlobalContext.getContext();
        const chainObj: ChainTestObj = { step: 1 };
        ctx.setObject('chain_test', chainObj);

        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();

        Log.info('Integration chain test completed');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 多模块协作测试 ==========

    it('integration_config_db_helper_cooperation', 0, async () => {
      let threw = false;
      try {
        const tableName = settingsDataConfig.TABLE_NAME;
        expect(tableName.length).assertLarger(0);

        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();

        const area = helper.getArea();
        expect(area !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('integration_constants_and_data_operations', 0, async () => {
      let threw = false;
      try {
        const brightnessKey = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
        expect(brightnessKey.length).assertLarger(0);

        const defaultKey = DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT;
        expect(defaultKey.length).assertLarger(0);

        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 端到端验证测试 ==========

    it('integration_e2e_settings_initialization', 0, async () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();

        const area = helper.getArea();
        expect(area !== undefined).assertTrue();

        Log.info('E2E initialization completed');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('integration_e2e_data_load_workflow', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();

        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', 'e2e_test_key');
        entry.set('value', 'e2e_test_value');
        const content: IContent = {
          settings: [entry],
          user: [],
          userSecure: []
        };
        await helper.loadTableData(content, TableType.SETTINGS, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 场景回归测试 ==========

    it('scenario_home_edit_back_chain', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('scenario_nav_home_back_chain', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(100);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('scenario_multiple_edit_cycles', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      const after = await surfaceCount(driver);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('scenario_home_back_multiple_times', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    // ========== 数据一致性场景测试 ==========

    it('scenario_data_consistency_after_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();

        const area1 = helper.getArea();
        const area2 = helper.getArea();
        expect(area1).assertEqual(area2);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 完整回归测试 ==========

    it('regression_full_workflow', 0, async () => {
      let threw = false;
      try {
        Log.info('Regression test starting');

        const ctx = GlobalContext.getContext();
        const regressionObj: RegressionTestObj = { status: 'running' };
        ctx.setObject('regression_test', regressionObj);

        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();

        const content: IContent = {
          settings: [],
          user: [],
          userSecure: []
        };
        await helper.loadTableData(content, TableType.SETTINGS, 0);

        Log.info('Regression test completed');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
