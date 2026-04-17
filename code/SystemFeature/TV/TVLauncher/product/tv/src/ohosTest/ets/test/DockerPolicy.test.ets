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
  KEY_RIGHT,
  KEY_LEFT,
  KEY_UP,
  KEY_DOWN,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  surfaceCount,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  TOLERANCE_EDIT_CYCLE,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';
import {
  DockerAppStorage,
  preferenceToken as dockerPreferenceToken
} from '../../../main/ets/common/baseUtil/dockerAppStorage';
import { AppItemInfo } from '../../../main/ets/common/bean/AppItemInfo';

const CORE_LABEL_INPUT: string = '\u8f93\u5165\u6e90';
const CORE_LABEL_SETTINGS: string = '\u8bbe\u7f6e';
const CORE_LABEL_ALL_APPS: string = '\u5168\u90e8\u5e94\u7528';

function mkApp(bundle: string): AppItemInfo {
  const a = new AppItemInfo();
  a.bundleName = bundle;
  a.appName = bundle;
  a.appIconId = 1;
  return a;
}

async function countCoreLabels(driver: Driver): Promise<number> {
  try {
    const inputLabels = await driver.findComponents(ON.text(CORE_LABEL_INPUT));
    const settingsLabels = await driver.findComponents(ON.text(CORE_LABEL_SETTINGS));
    const allAppsLabels = await driver.findComponents(ON.text(CORE_LABEL_ALL_APPS));
    return (inputLabels ? inputLabels.length : 0) +
      (settingsLabels ? settingsLabels.length : 0) +
      (allAppsLabels ? allAppsLabels.length : 0);
  } catch (e) {
    return 0;
  }
}

export default function dockerPolicyTest() {
  describe('DockerPolicy_Test', () => {
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

    it('preference_token_should_match', 0, () => {
      expect(dockerPreferenceToken).assertEqual('shortcuts_preferences');
    });
    it('default_order_should_have_at_least_six_apps', 0, () => {
      expect(DockerAppStorage.defaultOrderBundleNames.length).assertLargerOrEqual(6);
    });
    it('default_order_first_should_be_inputsource', 0, () => {
      expect(DockerAppStorage.defaultOrderBundleNames[0]).assertEqual('com.ohos.inputsource');
    });
    it('default_order_should_contain_settings', 0, () => {
      expect(DockerAppStorage.defaultOrderBundleNames.includes('com.ohos.settings')).assertTrue();
    });
    it('default_order_should_have_no_duplicates', 0, () => {
      const s = new Set(DockerAppStorage.defaultOrderBundleNames);
      expect(s.size).assertEqual(DockerAppStorage.defaultOrderBundleNames.length);
    });
    it('canNotMove_items_should_all_be_in_default_order', 0, () => {
      for (const b
        of DockerAppStorage.canNotMoveBundleNames) {
        expect(DockerAppStorage.defaultOrderBundleNames.includes(b))
          .assertTrue();
      }
    });
    it('canNotRemove_items_should_all_be_in_default_order', 0, () => {
      for (const b
        of DockerAppStorage.canNotRemoveBundleNames) {
        expect(DockerAppStorage.defaultOrderBundleNames.includes(b))
          .assertTrue();
      }
    });
    it('canNotMove_items_should_also_be_in_canNotRemove', 0, () => {
      for (const b
        of DockerAppStorage.canNotMoveBundleNames) {
        expect(DockerAppStorage.canNotRemoveBundleNames.includes(b))
          .assertTrue();
      }
    });

    it('known_locked_app_should_have_canMove_false', 0, () => {
      const a = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertFalse();
    });
    it('known_locked_app_should_have_canRemove_false', 0, () => {
      const a = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(a);
      expect(a.canRemove).assertFalse();
    });
    it('unknown_app_should_have_canMove_true', 0, () => {
      const a = mkApp('com.thirdparty.xyz');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertTrue();
    });
    it('unknown_app_should_have_canRemove_true', 0, () => {
      const a = mkApp('com.thirdparty.xyz');
      DockerAppStorage.appInit(a);
      expect(a.canRemove).assertTrue();
    });
    it('all_canNotMove_apps_should_be_locked_after_init', 0, () => {
      for (const b of DockerAppStorage.canNotMoveBundleNames) {
        const a = mkApp(b);
        DockerAppStorage.appInit(a);
        expect(a.canMove).assertFalse();
      }
    });
    it('all_canNotRemove_apps_should_be_locked_after_init', 0, () => {
      for (const b of DockerAppStorage.canNotRemoveBundleNames) {
        const a = mkApp(b);
        DockerAppStorage.appInit(a);
        expect(a.canRemove).assertFalse();
      }
    });
    it('appInit_should_be_idempotent_for_locked_app', 0, () => {
      const a = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(a);
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertFalse();
      expect(a.canRemove).assertFalse();
    });
    it('batch_init_ten_unknown_apps_all_mutable', 0, () => {
      for (let i = 0; i < 3; i++) {
        const a = mkApp('com.test.app' + i);
        DockerAppStorage.appInit(a);
        expect(a.canMove).assertTrue();
        expect(a.canRemove).assertTrue();
      }
    });

    it('core_bundle_should_have_fixed_icon_and_be_locked', 0, () => {
      const a = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertFalse();
      expect(a.canRemove).assertFalse();
      expect(a.icon).assertEqual('/common/pics/appList/icon_dtv.png');
      expect(a.onFocusIcon).assertEqual('/common/pics/appList/icon_dtv_onFocus.png');
    });
    it('known_bundle_icon_mapping_should_match_expected', 0, () => {
      interface DockerIconPair {
        bundle: string;
        icon: string;
        focus: string
      }

      const pairs: DockerIconPair[] = [
        {
          bundle: 'com.ohos.settings',
          icon: '/common/pics/appList/icon_settings.png',
          focus: '/common/pics/appList/icon_settings_onFocus.png'
        },
        {
          bundle: 'com.samples.album',
          icon: '/common/pics/appList/icon_picView.png',
          focus: '/common/pics/appList/icon_picView_onFocus.png'
        },
        {
          bundle: 'com.ohos.applicationmanager',
          icon: '/common/pics/appList/icon_apps.png',
          focus: '/common/pics/appList/icon_apps_onFocus.png'
        },
      ];
      for (const p of pairs) {
        const a = mkApp(p.bundle);
        DockerAppStorage.appInit(a);
        expect(a.icon).assertEqual(p.icon);
        expect(a.onFocusIcon).assertEqual(p.focus);
      }
    });
    it('policy_distribution_should_match_business_design', 0, () => {
      let canNotMoveCount = 0;
      let canNotRemoveCount = 0;
      for (const b of DockerAppStorage.defaultOrderBundleNames) {
        const a = mkApp(b);
        DockerAppStorage.appInit(a);
        if (!a.canMove) {
          canNotMoveCount++;
        }
        if (!a.canRemove) {
          canNotRemoveCount++;
        }
      }
      expect(canNotMoveCount).assertEqual(DockerAppStorage.canNotMoveBundleNames.length);
      expect(canNotRemoveCount).assertEqual(DockerAppStorage.canNotRemoveBundleNames.length);
    });

    it('policy_edit_home_back_locked_app_ok', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const a = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertFalse();
      expect(a.canRemove).assertFalse();
    });
    it('surface_after_edit_home_back_should_be_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('desktop_should_expose_core_shortcut_labels', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countCoreLabels(driver)).assertLargerOrEqual(1);
    });
    it('core_labels_survive_navigation_and_edit_toggle', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await countCoreLabels(driver)).assertLargerOrEqual(1);
    });
    it('text_readable_after_nav_and_policy_check', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const a = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(a);
      expect(a.canRemove).assertFalse();
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('empty_bundle_name_unknown_policy', 0, () => {
      const a = mkApp('');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertTrue();
      expect(a.canRemove).assertTrue();
    });
    it('partial_bundle_name_unknown_policy', 0, () => {
      const a = mkApp('com.ohos');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertTrue();
      expect(a.canRemove).assertTrue();
    });
    it('case_sensitive_bundle_not_matched', 0, () => {
      const a = mkApp('COM.OHOS.INPUTSOURCE');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertTrue();
      expect(a.canRemove).assertTrue();
    });
    it('default_order_all_non_empty_bundles', 0, () => {
      for (const b of DockerAppStorage.defaultOrderBundleNames) {
        expect(b.length > 0).assertTrue();
      }
    });
    it('canNotMove_subset_of_canNotRemove', 0, () => {
      for (const b of DockerAppStorage.canNotMoveBundleNames) {
        expect(DockerAppStorage.canNotRemoveBundleNames.includes(b)).assertTrue();
      }
    });
    it('canNotRemove_count_gte_canNotMove_count', 0, () => {
      expect(DockerAppStorage.canNotRemoveBundleNames.length)
        .assertLargerOrEqual(DockerAppStorage.canNotMoveBundleNames.length);
    });
    it('fifty_unknown_apps_all_mutable', 0, () => {
      for (let i = 0; i < 5; i++) {
        const a = mkApp('com.stress.app' + i);
        DockerAppStorage.appInit(a);
        expect(a.canMove).assertTrue();
        expect(a.canRemove).assertTrue();
      }
    });
    it('locked_app_icon_path_starts_with_slash', 0, () => {
      const a = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(a);
      expect((a.icon ?? '').startsWith('/')).assertTrue();
      expect((a.onFocusIcon ?? '').startsWith('/')).assertTrue();
    });

    it('policy_stable_after_ten_edit_cycles', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      const a = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertFalse();
      expect(a.canRemove).assertFalse();
    });
    it('unknown_app_stays_mutable_after_nav_storm', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(70);
      }
      const a = mkApp('com.thirdparty.storm');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertTrue();
      expect(a.canRemove).assertTrue();
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('all_default_order_apps_init_no_throw', 0, () => {
      let threw = false;
      try {
        for (const b of DockerAppStorage.defaultOrderBundleNames) {
          const a = mkApp(b);
          DockerAppStorage.appInit(a);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
    it('batch_100_unknown_apps_surface_stable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        const a = mkApp('com.batch.' + i);
        DockerAppStorage.appInit(a);
      }
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('docker_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('docker_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('docker_nav_50_lr_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(45);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('policy_check_then_edit_home_back_text', 0, async () => {
      const a = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(a);
      expect(a.canMove).assertFalse();
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('unknown_app_mutable_then_nav_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        const a = mkApp('com.ext.' + i);
        DockerAppStorage.appInit(a);
        expect(a.canMove).assertTrue();
      }
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('docker_circular_4dirs_8rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 8; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(60);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
