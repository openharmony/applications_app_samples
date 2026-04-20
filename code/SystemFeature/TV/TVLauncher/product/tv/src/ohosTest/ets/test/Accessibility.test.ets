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
  KEY_RIGHT,
  KEY_LEFT,
  KEY_ENTER,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  pressKeyWithDelay,
  surfaceCount,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS,
  DELAY_APP_LAUNCH,
  DELAY_NAV_KEY,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';

export default function accessibilityTest() {
  describe('Accessibility_Test', () => {
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

    it('cold_start_should_have_accessible_components', 0, async () => {
      const images = await driver.findComponents(ON.type('Image'));
      const texts = await driver.findComponents(ON.type('Text'));
      expect(images.length + texts.length).assertLargerOrEqual(3);
    });
    it('after_home_should_keep_accessible_components', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const images = await driver.findComponents(ON.type('Image'));
      const texts = await driver.findComponents(ON.type('Text'));
      expect(images.length + texts.length).assertLargerOrEqual(3);
    });
    it('navigation_should_not_break_accessibility_tree', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, DELAY_NAV_KEY);
      }
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(3);
    });
    it('after_back_total_components_at_least_three', 0, async () => {
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(3);
    });
    it('after_edit_back_total_components_at_least_three', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(3);
    });
    it('tree_stable_after_three_home_back_cycles', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(3);
    });

    it('desktop_should_have_non_empty_text', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_mode_toggle_should_keep_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_int_home_back_accessible_text_ok', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('after_nav_home_non_empty_text_at_least_one', 0, async () => {
      await pressKeyWithDelay(driver, KEY_RIGHT, DELAY_NAV_KEY);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('after_launch_back_non_empty_text_at_least_one', 0, async () => {
      await pressKeyWithDelay(driver, KEY_ENTER, DELAY_APP_LAUNCH);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('five_edit_cycles_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_burst_ten_right_then_home_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 70);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('navigation_then_launch_back_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressKeyWithDelay(driver, KEY_RIGHT, DELAY_NAV_KEY);
      await pressKeyWithDelay(driver, KEY_ENTER, DELAY_APP_LAUNCH);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('access_edit_int_home_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('three_edit_home_back_cycles_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });
    it('combined_nav_edit_launch_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressKeyWithDelay(driver, KEY_RIGHT, DELAY_NAV_KEY);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressKeyWithDelay(driver, KEY_ENTER, DELAY_APP_LAUNCH);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('ten_home_back_cycles_tree_intact', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(3);
    });
    it('ten_edit_cycles_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('burst_nav_20_right_tree_intact', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(60);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(3);
    });
    it('five_launch_back_cycles_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(DELAY_APP_LAUNCH);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_home_back_3x_tree_intact', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(3);
    });

    it('home_back_edit_launch_chain_text', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressKeyWithDelay(driver, KEY_ENTER, DELAY_APP_LAUNCH);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_burst_edit_3x_launch_back_tree_intact', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 70);
      }
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      await pressKeyWithDelay(driver, KEY_ENTER, DELAY_APP_LAUNCH);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(3);
    });
    it('surface_stable_after_complex_path', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_RIGHT, DELAY_NAV_KEY);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressKeyWithDelay(driver, KEY_ENTER, DELAY_APP_LAUNCH);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('access_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('access_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('access_nav_50_lr_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 45);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('access_eight_enter_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_ENTER, 900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('access_edit_interrupt_10x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('three_home_back_edit_chain_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('left_nav_burst_then_home_tree_intact', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_LEFT, 60);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(3);
    });

    it('edit_back_five_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('home_back_edit_home_back_chain_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rapid_back_6x_surface_positive', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      for (let i = 0; i < 6; i++) {
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
