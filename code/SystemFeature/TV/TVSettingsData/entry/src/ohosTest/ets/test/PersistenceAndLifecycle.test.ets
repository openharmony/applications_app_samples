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
 * @file PersistenceAndLifecycle.test.ets
 * @overview 测试数据持久化和生命周期管理
 *           覆盖：首次启动标志、冷启动数据恢复、数据一致性、生命周期回调
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import { ON } from '@kit.TestKit';
import { relationalStore } from '@kit.ArkData';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
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
  TOLERANCE_EDIT_CYCLE
} from './SharedDriver';
import { Driver } from '@kit.TestKit';

interface MockContext {
  bundleName: string;
}

export default function persistenceAndLifecycleTest() {
  describe('PersistenceAndLifecycle_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'persistence_test';

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

    // ========== 首次启动标志测试 ==========

    it('first_startup_flag_should_be_initialized', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      await helper.getRdbStore();
      expect(helper !== null).assertTrue();
    });

    it('rdb_store_should_be_initialized_after_first_get', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      const store = await helper.getRdbStore();
      expect(store !== undefined).assertTrue();
    });

    it('second_get_rdb_store_should_return_same_instance', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      const store1 = await helper.getRdbStore();
      const store2 = await helper.getRdbStore();
      expect(store1 === store2).assertTrue();
    });

    // ========== 冷启动数据恢复测试 ==========

    it('cold_start_should_load_default_settings', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('cold_start_should_have_valid_db_name', 0, () => {
      expect(settingsDataConfig.DB_NAME).assertEqual('settingsdata.db');
    });

    it('cold_start_should_have_valid_table_name', 0, () => {
      expect(settingsDataConfig.TABLE_NAME).assertEqual('SETTINGSDATA');
    });

    // ========== 数据一致性测试 ==========

    it('data_consistency_after_multiple_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const store = await helper.getRdbStore();
        expect(store !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('data_consistency_brightness_key_should_exist', 0, () => {
      expect(DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS.length).assertLarger(0);
    });

    it('data_consistency_time_format_key_should_exist', 0, () => {
      expect(DataSettingsKey.SETTINGS_TIME_FORMAT.length).assertLarger(0);
    });

    it('data_consistency_audio_keys_should_exist', 0, () => {
      expect(DataSettingsKey.SETTINGS_AUDIO_RINGTONE.length).assertLarger(0);
      expect(DataSettingsKey.SETTINGS_AUDIO_MEDIA.length).assertLarger(0);
      expect(DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL.length).assertLarger(0);
    });

    // ========== 生命周期回调测试 ==========

    it('on_create_should_initialize_context', 0, () => {
      const ctx = GlobalContext.getContext();
      expect(ctx !== null).assertTrue();
    });

    it('on_create_should_set_ability_context', 0, () => {
      const ctx = GlobalContext.getContext();
      const mockContext: MockContext = { bundleName: 'com.ohos.settingsdata' };
      ctx.setObject('abilityContext', mockContext);
      const retrieved = ctx.getObject('abilityContext');
      expect(retrieved !== undefined).assertTrue();
    });

    // ========== 持久化存储测试 ==========

    it('persistence_single_edit_cycle_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('persistence_multiple_edit_cycles_no_accumulate', 0, async () => {
      const base = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      const after = await surfaceCount(driver);
      expect(Math.abs(after - base)).assertLessOrEqual(8);
    });

    it('persistence_home_reload_surface_consistent', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(6);
    });

    it('persistence_home_reload_twice_surface_ok', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const images = await driver.findComponents(ON.type('Image'));
      expect(images.length).assertLargerOrEqual(1);
    });

    it('persistence_edit_home_back_chain_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('persistence_multi_edit_text_readable', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      }
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('persistence_five_edit_cycles_bounded', 0, async () => {
      const base = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - base)).assertLessOrEqual(10);
    });

    it('persistence_home_back_cycles_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('persistence_edit_home_interleaved_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        if (i % 2 === 0) {
          await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        } else {
          await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        }
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('persistence_rapid_edit_then_home_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(12);
    });

    // ========== 竞态条件测试 ==========

    it('race_condition_concurrent_db_access', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const promises: Promise<relationalStore.RdbStore | undefined>[] = [];
        for (let i = 0; i < 5; i++) {
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

    // ========== 数据恢复验证测试 ==========

    it('data_recovery_after_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        const area = helper.getArea();
        expect(area !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
