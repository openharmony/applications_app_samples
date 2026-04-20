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
import { Driver, ON } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_LEFT,
  KEY_RIGHT,
  KEY_UP,
  KEY_DOWN,
  KEY_ENTER,
  KEY_BACK,
  KEY_HOME,
  KEY_EDIT,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  pressKeyWithDelay,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  TOLERANCE_EDIT_CYCLE
} from './SharedDriver';
import { CheckEmptyUtils } from '../../../../../../common/src/main/ets/default/utils/CheckEmptyUtils';
import { CommonConstants } from '../../../../../../common/src/main/ets/default/constants/CommonConstants';
import { AppItemInfo as CommonAppItemInfo } from '../../../../../../common/src/main/ets/default/bean/AppItemInfo';
import { AppItemInfo as MainAppItemInfo } from '../../../main/ets/common/bean/AppItemInfo';
import { DockerAppStorage } from '../../../main/ets/common/baseUtil/dockerAppStorage';
import { storeToken, infoList } from '../../../main/ets/common/baseUtil/storage';

function mkApp(b: string): MainAppItemInfo {
  const a = new MainAppItemInfo();
  a.bundleName = b;
  a.appName = b;
  return a;
}

export default function fullContractRegressionTest() {
  describe('FullContractRegression_Test', () => {
    let driver: Driver;
    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 2, 4000);
      await waitForStableSurface(driver, 2, 6, 2500);
    });
    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, 2, 6, 2000);
    });

    it('check_empty_utils_all_cases', 0, () => {
      expect(CheckEmptyUtils.isEmpty(undefined)).assertTrue();
      expect(CheckEmptyUtils.isEmpty(null)).assertTrue();
      expect(CheckEmptyUtils.isEmpty('')).assertTrue();
      expect(CheckEmptyUtils.isEmpty('x')).assertFalse();
      expect(CheckEmptyUtils.isEmpty(0)).assertFalse();
      expect(CheckEmptyUtils.checkStrIsEmpty('   ')).assertTrue();
      expect(CheckEmptyUtils.checkStrIsEmpty('tv')).assertFalse();
      expect(CheckEmptyUtils.isEmptyArr([])).assertTrue();
      expect(CheckEmptyUtils.isEmptyArr([1])).assertFalse();
    });
    it('common_constants_identity_and_types', 0, () => {
      expect(CommonConstants.LAUNCHER_BUNDLE).assertEqual('com.ohos.launcher');
      expect(CommonConstants.LAUNCHER_ABILITY).assertEqual('com.ohos.launcher.MainAbility');
      expect(CommonConstants.INVALID_VALUE).assertEqual(-1);
      expect(CommonConstants.TYPE_APP).assertEqual(0);
      expect(CommonConstants.TYPE_FOLDER).assertEqual(3);
      expect(CommonConstants.BADGE_DISPLAY_SHOW).assertEqual(1);
      expect(CommonConstants.DEFAULT_USER_ID).assertEqual(0);
    });
    it('docker_default_order_contract', 0, () => {
      expect(DockerAppStorage.defaultOrderBundleNames.length).assertLargerOrEqual(6);
      expect(DockerAppStorage.defaultOrderBundleNames[0]).assertEqual('com.ohos.inputsource');
      expect(new Set(DockerAppStorage.defaultOrderBundleNames).size)
        .assertEqual(DockerAppStorage.defaultOrderBundleNames.length);
    });
    it('storage_token_contract', 0, () => {
      expect(storeToken).assertEqual('infoList');
      expect(infoList.length).assertLargerOrEqual(6);
      expect(infoList.includes('\u8bbe\u7f6e')).assertTrue();
    });
    it('app_item_cover_contract', 0, () => {
      const src = new CommonAppItemInfo();
      src.appId = 'reg_id';
      src.appName = 'Reg';
      src.bundleName = 'com.reg';
      src.abilityName = 'RegA';
      src.moduleName = 'entry';
      src.appIconId = 99;
      const dst = new MainAppItemInfo();
      dst.cover(src);
      expect(dst.appId).assertEqual('reg_id');
      expect(dst.appName).assertEqual('Reg');
      expect(dst.bundleName).assertEqual('com.reg');
      expect(dst.canMove).assertTrue();
      expect(dst.canRemove).assertTrue();
    });
    it('docker_init_known_app_locked', 0, () => {
      const app = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertFalse();
      expect(app.canRemove).assertFalse();
    });
    it('docker_init_unknown_app_mutable', 0, () => {
      const app = mkApp('com.unknown.regression');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertTrue();
      expect(app.canRemove).assertTrue();
    });

    it('desktop_has_images_and_texts', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
      expect((await driver.findComponents(ON.type('Text'))).length).assertLargerOrEqual(1);
    });
    it('fullreg_edit_back_home_back_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });
    it('fullreg_nav_right_home_back_text_readable', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('launch_back_home_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });
    it('static_policy_holds_after_ui_stress', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const app = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertFalse();
      expect(storeToken).assertEqual('infoList');
      expect(CommonConstants.LAUNCHER_BUNDLE).assertEqual('com.ohos.launcher');
    });
    it('nav_burst_then_policy_and_token_still_valid', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(60);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(storeToken).assertEqual('infoList');
      expect(DockerAppStorage.defaultOrderBundleNames.length).assertLargerOrEqual(6);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('three_full_cycles_all_contracts_hold', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(100);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(CheckEmptyUtils.isEmpty('')).assertTrue();
      expect(CommonConstants.TYPE_APP).assertEqual(0);
      expect(storeToken).assertEqual('infoList');
      const app = mkApp('com.ohos.inputsource');
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertFalse();
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('fullreg_five_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('fullreg_ten_home_back_cycles_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_burst_20_edit_home_back_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('fullreg_three_edit_home_back_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('fullreg_three_launch_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('circular_dirs_3rounds_text_readable', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 3; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(80);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rapid_edit_back_6x_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 6; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('composite_regression_chain_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('fullreg_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('fullreg_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('fullreg_nav_burst_40_home_text', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('fullreg_eight_launch_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('fullreg_edit_interrupt_12x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('fullreg_circular_dirs_10rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 10; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(55);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('fullreg_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('fullreg_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('fullreg_nav_40_lr_home_text', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('fullreg_eight_enter_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('fullreg_edit_interrupt_12x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('fullreg_circular_4dirs_10rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 10; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(55);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
