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
 * @file SettingsDataSmoke.test.ets
 * @overview 冒烟测试 - 验证核心功能基本可用
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import { Log } from '../../../main/ets/Utils/Log';
import {
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

export default function settingsDataSmokeTest() {
  describe('SettingsDataSmoke_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'smoke_test';

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

    it('smoke_db_helper_instance', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const instance = SettingsDBHelper.getInstance();
        expect(instance !== undefined).assertTrue();
      });
      expect(success).assertTrue();
    });

    it('smoke_db_helper_rdb_store', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        expect(rdbStore !== undefined).assertTrue();
      });
      expect(success).assertTrue();
    });

    it('smoke_context_instance', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const ctx = GlobalContext.getContext();
        expect(ctx !== undefined).assertTrue();
      });
      expect(success).assertTrue();
    });

    it('smoke_config_values', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        expect(settingsDataConfig.TABLE_NAME.length).assertLarger(0);
        expect(settingsDataConfig.DB_NAME.length).assertLarger(0);
      });
      expect(success).assertTrue();
    });

    it('smoke_log_operations', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        Log.info('Smoke test passed');
      });
      expect(success).assertTrue();
    });
  });
}
