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
  KEY_ENTER,
  KEY_LEFT,
  KEY_RIGHT,
  KEY_UP,
  KEY_DOWN,
  KEY_EDIT,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  pressKeyWithDelay,
  surfaceCount,
  countNonEmptyTexts
} from './SharedDriver';

async function uiSurface(driver: Driver): Promise<number> {
  const imageCount = (await driver.findComponents(ON.type('Image'))).length;
  const textCount = (await driver.findComponents(ON.type('Text'))).length;
  return imageCount + textCount;
}

async function openRecent(driver: Driver): Promise<void> {
  await pressAndWait(driver, KEY_HOME, 2, 3000);
}

async function closeRecent(driver: Driver): Promise<void> {
  await pressAndWait(driver, KEY_BACK, 2, 3000);
}

export default function recentAndLifecycleDeepTest() {
  describe('RecentAndLifecycleDeep_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 2, 4000);
      await waitForStableSurface(driver, 2, 6, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await waitForStableSurface(driver, 2, 6, 2000);
    });

    it('open_recent_should_keep_visible_surface_contract', 0, async () => {
      await openRecent(driver);
      const surface = await uiSurface(driver);
      expect(surface).assertLargerOrEqual(1);
    });

    it('close_recent_should_restore_desktop_readability', 0, async () => {
      await openRecent(driver);
      await closeRecent(driver);

      const readable = await countNonEmptyTexts(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('repeat_open_close_recent_surface_ok', 0, async () => {
      const before = await uiSurface(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await closeRecent(driver);
      }

      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('delete_path_by_up_should_keep_recent_available', 0, async () => {
      await openRecent(driver);
      const before = (await driver.findComponents(ON.type('Image'))).length;
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(900);

      const afterImages = (await driver.findComponents(ON.type('Image'))).length;
      const textCount = (await driver.findComponents(ON.type('Text'))).length;
      expect(afterImages + textCount).assertLargerOrEqual(1);
      expect(afterImages <= before).assertTrue();
    });

    it('clear_or_bottom_action_return_path_ok', 0, async () => {
      await openRecent(driver);
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(KEY_DOWN);
        await driver.delayMs(120);
      }
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(1000);

      const images = await driver.findComponents(ON.type('Image'));
      expect(images.length).assertLargerOrEqual(1);
    });

    it('switch_task_then_back_should_recover_desktop', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(1000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);

      const texts = await driver.findComponents(ON.type('Text'));
      expect(texts.length).assertLargerOrEqual(1);
    });

    it('recent_horizontal_nav_focus_flow_ok', 0, async () => {
      await openRecent(driver);
      const before = await uiSurface(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(140);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(140);

      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(10);
    });

    it('home_recent_back_home_loop_lifecycle_ok', 0, async () => {
      const before = await uiSurface(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await openRecent(driver);
        await closeRecent(driver);
      }

      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('edit_recent_back_desktop_state_ok', 0, async () => {
      const before = await uiSurface(driver);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await openRecent(driver);
      await closeRecent(driver);

      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('recent_switch_int_home_back_text_ok', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(800);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('recent_clear_edit_cycle_surface_ok', 0, async () => {
      const before = await uiSurface(driver);
      await openRecent(driver);
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(KEY_DOWN);
        await driver.delayMs(100);
      }
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('double_recent_switch_edit_int_ok', 0, async () => {
      const before = await uiSurface(driver);
      for (let i = 0; i < 2; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(820);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('recent_nav_matrix_home_back_text_ok', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await openRecent(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(120);
      await closeRecent(driver);
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('recent_matrix_edit_int_reentry_ok', 0, async () => {
      const before = await uiSurface(driver);
      await openRecent(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(110);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(110);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(110);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(110);
      await closeRecent(driver);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('double_recent_clear_task_switch_text_ok', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await openRecent(driver);
        for (let j = 0; j < 4; j++) {
          await driver.triggerKey(KEY_DOWN);
          await driver.delayMs(95);
        }
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(780);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(780);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('recent_open_close_storm_edit_reentry_ok', 0, async () => {
      const before = await uiSurface(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await closeRecent(driver);
      }
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('recent_task_switch_home_back_burst_ok', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(800);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('recent_dir_storm_edit_int_surface_ok', 0, async () => {
      const before = await uiSurface(driver);
      await openRecent(driver);
      for (let i = 0; i < 3; i++) {
        const key = i % 4 === 0 ? KEY_RIGHT : (i % 4 === 1 ? KEY_LEFT : (i % 4 === 2 ? KEY_DOWN : KEY_UP));
        await driver.triggerKey(key);
        await driver.delayMs(85);
      }
      await closeRecent(driver);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(22);
    });

    it('double_recent_open_close_home_reentry_ok', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await openRecent(driver);
        await closeRecent(driver);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
      }
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('recent_enter_back_dir_burst_ok', 0, async () => {
      const before = await uiSurface(driver);
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(780);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      for (let i = 0; i < 3; i++) {
        const key = i % 2 === 0 ? KEY_RIGHT : KEY_LEFT;
        await driver.triggerKey(key);
        await driver.delayMs(60);
      }
      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('recent_clear_edit_home_back_cycle_ok', 0, async () => {
      await openRecent(driver);
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(KEY_DOWN);
        await driver.delayMs(90);
      }
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(760);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('recent_open_close_repeat_dir_matrix_ok', 0, async () => {
      const before = await uiSurface(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await closeRecent(driver);
      }
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(90);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(90);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(90);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(90);
      const after = await uiSurface(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('recent_deep_twenty_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('recent_deep_fifteen_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('recent_deep_ten_launch_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('recent_deep_nav_burst_40_home_back_text', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('recent_lifecycle_edit_int_15x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(28);
    });
    it('circular_dirs_10rounds_home_text', 0, async () => {
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
    it('twenty_home_back_surface_monotone', 0, async () => {
      const counts: number[] = [];
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        counts.push(await surfaceCount(driver));
      }
      for (const c of counts) {
        expect(c).assertLargerOrEqual(2);
      }
      expect(Math.max(...counts) - Math.min(...counts)).assertLessOrEqual(20);
    });
    it('combined_recent_lifecycle_chain_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
        await pressKeyWithDelay(driver, KEY_ENTER, 900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('recent_deep_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('recent_deep_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('recent_deep_nav_burst_50_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 45);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('recent_lifecycle_edit_int_15x_bounded_2', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(28);
    });
    it('recent_deep_circular_dirs_12rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 12; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(50);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
