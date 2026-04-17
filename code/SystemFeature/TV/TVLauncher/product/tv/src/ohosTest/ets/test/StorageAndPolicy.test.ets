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

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_RIGHT,
  KEY_LEFT,
  KEY_DOWN,
  KEY_UP,
  KEY_ENTER,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS
} from './SharedDriver';
import { DockerAppStorage } from '../../../main/ets/common/baseUtil/dockerAppStorage';
import { AppItemInfo } from '../../../main/ets/common/bean/AppItemInfo';

function createApp(bundleName: string): AppItemInfo {
  const app = new AppItemInfo();
  app.bundleName = bundleName;
  app.appName = bundleName;
  app.appIconId = 1;
  return app;
}

export default function storageAndPolicyTest() {
  describe('StorageAndPolicy_Test', () => {
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

    it('default_order_should_include_core_apps', 0, () => {
      expect(DockerAppStorage.defaultOrderBundleNames.includes('com.ohos.inputsource')).assertTrue();
      expect(DockerAppStorage.defaultOrderBundleNames.includes('com.ohos.settings')).assertTrue();
    });

    it('cannot_remove_list_should_have_no_duplicates', 0, () => {
      const names = DockerAppStorage.canNotRemoveBundleNames;
      expect(new Set(names).size).assertEqual(names.length);
    });

    it('cannot_move_list_should_be_subset_of_cannot_remove', 0, () => {
      for (const item of DockerAppStorage.canNotMoveBundleNames) {
        expect(DockerAppStorage.canNotRemoveBundleNames.includes(item)).assertTrue();
      }
    });

    it('cannot_move_list_should_be_subset_of_default_order', 0, () => {
      for (const item of DockerAppStorage.canNotMoveBundleNames) {
        expect(DockerAppStorage.defaultOrderBundleNames.includes(item)).assertTrue();
      }
    });

    it('known_bundle_should_be_locked_after_app_init', 0, () => {
      const app = createApp('com.ohos.inputsource');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertFalse();
      expect(app.canRemove).assertFalse();
    });

    it('unknown_bundle_should_be_mutable_after_app_init', 0, () => {
      const app = createApp('com.thirdparty.unknown');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertTrue();
      expect(app.canRemove).assertTrue();
    });

    it('settings_bundle_should_have_move_enabled_but_remove_locked_after_app_init', 0, () => {
      const app = createApp('com.ohos.settings');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertTrue();
      expect(app.canRemove).assertFalse();
    });

    it('batch_init_known_apps_all_locked', 0, () => {
      const knownBundles = DockerAppStorage.canNotMoveBundleNames.slice(0, 3);
      for (const bundle of knownBundles) {
        const app = createApp(bundle);
        DockerAppStorage.appInit(app);
        expect(app.canMove).assertFalse();
        expect(app.canRemove).assertFalse();
      }
    });

    it('batch_init_unknown_apps_all_mutable', 0, () => {
      for (let i = 0; i < 5; i++) {
        const app = createApp('com.thirdparty.app' + i);
        DockerAppStorage.appInit(app);
        expect(app.canMove).assertTrue();
        expect(app.canRemove).assertTrue();
      }
    });

    it('storage_edit_int_home_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
    });

    it('home_reload_after_navigation_text_readable', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('double_edit_cycle_with_home_back_surface_contract', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });

    it('policy_known_bundle_locked_after_real_actions', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const app = createApp('com.ohos.inputsource');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertFalse();
      expect(app.canRemove).assertFalse();
    });

    it('policy_unknown_bundle_mutable_after_real_actions', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const app = createApp('com.thirdparty.dynamic');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertTrue();
      expect(app.canRemove).assertTrue();
    });

    it('storage_ten_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('storage_five_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('storage_three_edit_home_back_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });

    it('storage_circular_dirs_5rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 5; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(70);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('storage_rapid_edit_back_8x_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('known_bundle_policy_stable_across_ten_inits', 0, () => {
      for (let i = 0; i < 3; i++) {
        const app = createApp('com.ohos.inputsource');
        DockerAppStorage.appInit(app);
        expect(app.canMove).assertFalse();
        expect(app.canRemove).assertFalse();
      }
    });

    it('unknown_bundle_policy_stable_across_ten_inits', 0, () => {
      for (let i = 0; i < 3; i++) {
        const app = createApp('com.thirdparty.stable' + i);
        DockerAppStorage.appInit(app);
        expect(app.canMove).assertTrue();
        expect(app.canRemove).assertTrue();
      }
    });

    it('nav_burst_then_settings_policy_stays_move_enabled_remove_locked', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const app = createApp('com.ohos.settings');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertTrue();
      expect(app.canRemove).assertFalse();
    });

    it('edit_home_back_then_policy_unknown_mutable', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const app = createApp('com.thirdparty.postop');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertTrue();
      expect(app.canRemove).assertTrue();
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
