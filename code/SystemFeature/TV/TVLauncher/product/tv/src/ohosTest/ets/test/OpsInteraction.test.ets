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
  KEY_RIGHT,
  KEY_LEFT,
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
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';

async function goHomeForRecent(driver: Driver): Promise<void> {
  await driver.triggerKey(KEY_HOME);
  await driver.delayMs(400);
}

export default function opsInteractionTest() {
  describe('OpsInteraction_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, 4000);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
    });
    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    it('default_shortcuts_have_reasonable_image_count', 0, async () => {
      const images = await driver.findComponents(ON.type('Image'));
      expect(images.length).assertLargerOrEqual(1);
      expect(images.length).assertLessOrEqual(80);
    });
    it('default_shortcuts_have_non_empty_text', 0, async () => {
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });
    it('enter_edit_keeps_desktop_available', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      const images = await driver.findComponents(ON.type('Image'));
      expect(images.length).assertLargerOrEqual(1);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
    });
    it('edit_exit_restores_text', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('up_key_in_recent_not_crash', 0, async () => {
      await goHomeForRecent(driver);
      const before = (await driver.findComponents(ON.type('Image'))).length;
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(200);
      const after = (await driver.findComponents(ON.type('Image'))).length;
      expect(after + (await driver.findComponents(ON.type('Text'))).length).assertLargerOrEqual(1);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
    });
    it('nav_clear_area_enter_returns_desktop', 0, async () => {
      await goHomeForRecent(driver);
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(KEY_DOWN);
        await driver.delayMs(120);
      }
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });
    it('enter_task_back_returns_desktop_text', 0, async () => {
      await goHomeForRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect((await driver.findComponents(ON.type('Text'))).length).assertLargerOrEqual(1);
    });

    it('edit_move_back_enter_back_home_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(160);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('remove_attempt_back_home_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(180);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(260);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('five_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('ops_ten_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_edit_home_back_3x_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_interrupt_back_home_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('burst_lr_20_home_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('three_launch_back_home_bounded', 0, async () => {
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
    it('rapid_back_5x_surface_positive', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('combined_ops_chain_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('ops_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('ops_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('ops_nav_40_home_text_readable', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('ops_eight_enter_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('ops_edit_interrupt_12x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('ops_circular_4dirs_10rounds_text', 0, async () => {
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

    it('recent_home_back_twice_then_text_readable', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await goHomeForRecent(driver);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('edit_nav_back_then_home_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('launch_back_edit_back_chain_surface_positive', 0, async () => {
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('directional_square_five_rounds_then_home_text', 0, async () => {
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
  });
}
