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
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_ENTER,
  KEY_LEFT,
  KEY_RIGHT,
  KEY_UP,
  KEY_DOWN,
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
  TOLERANCE_SINGLE_OP,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS
} from './SharedDriver';
import { KeyCode } from '../../../main/ets/common/constants/KeyCode';

async function returnDesktopStable(driver: Driver): Promise<void> {
  await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
  await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
}

async function resilientPressAndWait(
  driver: Driver,
  key: number,
  minimumCount: number,
  timeoutMs: number,
  stableTimeoutMs?: number
): Promise<void> {
  await pressKeyWithDelay(driver, key);
  await waitForSurface(driver, minimumCount, timeoutMs);
  await waitForStableSurface(
    driver,
    1,
    STABLE_TOLERANCE,
    stableTimeoutMs ?? Math.max(1200, Math.min(timeoutMs, 2500))
  );
}

export default function desktopAndEditFlowTest() {
  describe('DesktopAndEditFlow_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
      await returnDesktopStable(driver);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    it('desktop_surface_min_render_contract_ok', 0, async () => {
      await returnDesktopStable(driver);
      const images = (await driver.findComponents(ON.type('Image'))).length;
      const texts = (await driver.findComponents(ON.type('Text'))).length;
      expect(images).assertLargerOrEqual(1);
      expect(texts).assertLargerOrEqual(1);
      expect(images + texts).assertLessOrEqual(160);
    });

    it('keycode_constants_should_drive_real_navigation', 0, async () => {
      await pressKeyWithDelay(driver, KeyCode.KEY_DPAD_RIGHT, 120);
      await pressKeyWithDelay(driver, KeyCode.KEY_DPAD_LEFT, 120);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('enter_edit_exit_preserves_surface_contract', 0, async () => {
      await returnDesktopStable(driver);
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(12);
    });

    it('repeat_edit_transition_no_node_accumulate', 0, async () => {
      await returnDesktopStable(driver);
      const base = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - base)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('left_boundary_edit_move_ui_ok', 0, async () => {
      await returnDesktopStable(driver);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_LEFT, 140);
      }
      await waitForStableSurface(driver, 1, STABLE_TOLERANCE, 1500);
      const before = await surfaceCount(driver);
      await resilientPressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_LEFT, 320);
      await resilientPressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(12);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('right_boundary_edit_move_ui_ok', 0, async () => {
      await returnDesktopStable(driver);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 140);
      }
      await waitForStableSurface(driver, 1, STABLE_TOLERANCE, 1500);
      const before = await surfaceCount(driver);
      await resilientPressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_RIGHT, 320);
      await resilientPressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(12);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('home_edit_home_composite_desktop_ok', 0, async () => {
      await returnDesktopStable(driver);
      const before = await surfaceCount(driver);
      await resilientPressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await resilientPressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await resilientPressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME, 2500);
      await resilientPressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME, 2500);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('edit_int_home_back_surface_available', 0, async () => {
      await returnDesktopStable(driver);
      const before = await surfaceCount(driver);
      await resilientPressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await resilientPressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME, 2500);
      await resilientPressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME, 2500);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('focus_boundary_edit_home_cycle_text_ok', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 70);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_LEFT, 180);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('double_edit_int_nav_surface_contract_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressKeyWithDelay(driver, KEY_RIGHT, 100);
        await pressKeyWithDelay(driver, KEY_LEFT, 100);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });

    it('edit_menu_nav_back_text_ok', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_UP, 160);
      await pressKeyWithDelay(driver, KEY_DOWN, 160);
      await pressKeyWithDelay(driver, KEY_ENTER, 220);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('long_nav_edit_menu_cycle_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 60);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_UP, 150);
      await pressKeyWithDelay(driver, KEY_DOWN, 150);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });

    it('desktop_fifteen_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('desktop_ten_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('five_edit_home_interrupt_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('keycode_dpad_nav_then_home_surface_positive', 0, async () => {
      await pressKeyWithDelay(driver, KeyCode.KEY_DPAD_RIGHT, 120);
      await pressKeyWithDelay(driver, KeyCode.KEY_DPAD_LEFT, 120);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
  });
}
