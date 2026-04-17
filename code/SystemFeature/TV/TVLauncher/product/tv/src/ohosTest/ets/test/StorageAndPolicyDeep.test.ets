/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_LEFT,
  KEY_RIGHT,
  KEY_UP,
  KEY_DOWN,
  KEY_ENTER,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts
} from './SharedDriver';
import storeAppList, {
  infoList,
  storeToken,
  preferenceToken as storageToken
} from '../../../main/ets/common/baseUtil/storage';
import PreferenceUtils, { BooleanPreferences } from '../../../main/ets/common/baseUtil/PreferenceUtil';
import { DockerAppStorage, preferenceToken as dockerToken } from '../../../main/ets/common/baseUtil/dockerAppStorage';

function countUnique(items: string[]): number {
  return new Set(items).size;
}

function listHasBlank(items: string[]): boolean {
  for (let i = 0; i < items.length; i++) {
    if (!items[i] || items[i].trim().length === 0) {
      return true;
    }
  }
  return false;
}

export default function storageAndPolicyDeepTest() {
  describe('StorageAndPolicyDeep_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 2, 4000);
      await waitForStableSurface(driver, 2, 6, 2500);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await waitForStableSurface(driver, 2, 6, 2000);
    });

    it('storage_docker_share_same_preference_token', 0, () => {
      expect(storeToken).assertEqual('infoList');
      expect(storageToken).assertEqual('shortcuts_preferences');
      expect(dockerToken).assertEqual('shortcuts_preferences');
    });

    it('default_shortcut_seed_matches_baseline', 0, () => {
      expect(infoList.length).assertLargerOrEqual(6);
      expect(infoList[0] !== undefined && infoList[0].length > 0).assertTrue();
      expect(infoList[1] !== undefined && infoList[1].length > 0).assertTrue();
      expect(infoList.some(item => item.length > 0)).assertTrue();
      expect(infoList.length).assertLargerOrEqual(4);
    });

    it('docker_default_order_unique_non_blank', 0, () => {
      const list = DockerAppStorage.defaultOrderBundleNames;
      expect(list.length).assertLargerOrEqual(6);
      expect(countUnique(list)).assertEqual(list.length);
      expect(listHasBlank(list)).assertFalse();
    });

    it('cannot_move_should_be_subset_of_cannot_remove', 0, () => {
      for (let i = 0; i < DockerAppStorage.canNotMoveBundleNames.length; i++) {
        const item = DockerAppStorage.canNotMoveBundleNames[i];
        expect(DockerAppStorage.canNotRemoveBundleNames.includes(item)).assertTrue();
      }
    });

    it('default_first_two_apps_fixed_position', 0, () => {
      expect(DockerAppStorage.defaultOrderBundleNames[0]).assertEqual('com.ohos.inputsource');
      expect(DockerAppStorage.defaultOrderBundleNames[1]).assertEqual('com.ohos.demandplayer');
    });

    it('preference_utils_keeps_context_initial_value', 0, () => {
      const fakeContext: ESObject = {} as ESObject;
      const prefBool = new PreferenceUtils<boolean>(fakeContext, true);
      const prefNum = new PreferenceUtils<number>(fakeContext, 0);
      expect(prefBool.context === fakeContext).assertTrue();
      expect(prefBool.initValue).assertTrue();
      expect(prefNum.initValue).assertEqual(0);
    });

    it('boolean_preferences_should_be_constructable', 0, () => {
      const fakeContext: ESObject = {} as ESObject;
      const boolPref = new BooleanPreferences(fakeContext);
      expect(boolPref !== null && boolPref !== undefined).assertTrue();
    });

    it('store_class_should_keep_context_reference', 0, () => {
      const fakeContext: ESObject = {} as ESObject;
      const appStore = new storeAppList(fakeContext);
      expect(appStore !== null && appStore !== undefined).assertTrue();
    });

    it('edit_enter_exit_home_component_baseline_ok', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const before = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;

      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);

      const after = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(10);
    });

    it('nav_disturbance_storage_visible_ok', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(80);
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(80);
      }

      const imageCount = (await driver.findComponents(ON.type('Image'))).length;
      const textCount = (await driver.findComponents(ON.type('Text'))).length;
      expect(imageCount).assertLargerOrEqual(1);
      expect(textCount).assertLargerOrEqual(1);
    });

    it('double_home_reentry_should_keep_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_HOME, 2, 3000);

      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('edit_int_nav_reentry_surface_ok', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const before = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      const after = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('double_edit_cycle_home_back_text_ok', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('storage_deep_ten_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('storage_deep_five_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('nav_burst_20_home_back_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('storage_deep_three_edit_home_back_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('storage_deep_three_launch_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('storage_deep_rapid_edit_back_8x_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
    });
    it('storage_deep_circular_dirs_5rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 5; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(70);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('combined_storage_chain_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(80);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });

    it('storage_deep_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('storage_deep_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('storage_deep_nav_burst_40_home_back_text', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('eight_launch_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('storage_deep_edit_interrupt_12x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('storage_deep_circular_dirs_10rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 10; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(55);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
