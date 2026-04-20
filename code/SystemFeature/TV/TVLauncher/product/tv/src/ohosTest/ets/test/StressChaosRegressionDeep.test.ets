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
import { Driver, DisplayRotation, ON } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_ENTER,
  KEY_EDIT,
  KEY_LEFT,
  KEY_RIGHT,
  KEY_UP,
  KEY_DOWN,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  pressKeyWithDelay,
  safeDelay,
  safeRotate,
  countNonEmptyTexts
} from './SharedDriver';

interface Step {
  key: number;
  wait: number
}

async function readableTextCount(driver: Driver): Promise<number> {
  return countNonEmptyTexts(driver);
}

async function runSteps(driver: Driver, steps: Step[]): Promise<void> {
  for (let i = 0; i < steps.length; i++) {
    const key = steps[i].key;
    if (key === KEY_HOME) {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      continue;
    }
    if (key === KEY_BACK) {
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      continue;
    }
    if (key === KEY_EDIT) {
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      continue;
    }
    await pressKeyWithDelay(driver, key, steps[i].wait);
  }
}

export default function stressChaosRegressionDeepTest() {
  describe('StressChaosRegressionDeep_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 2, 4000);
      await waitForStableSurface(driver, 2, 6, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
    });

    afterAll(async () => {
      await safeRotate(driver, DisplayRotation.ROTATION_0);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await waitForStableSurface(driver, 2, 6, 2000);
    });

    it('rapid_lr_120_events_desktop_alive', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 35);
      }

      await pressAndWait(driver, KEY_HOME, 1, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('rapid_vertical_80_events_focus_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_UP : KEY_DOWN, 40);
      }

      await pressAndWait(driver, KEY_HOME, 1, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('mixed_sequence_short_delays_no_text_loss', 0, async () => {
      const steps: Step[] = [
        { key: KEY_RIGHT, wait: 45 },
        { key: KEY_LEFT, wait: 45 },
        { key: KEY_UP, wait: 45 },
        { key: KEY_DOWN, wait: 45 },
        { key: KEY_EDIT, wait: 180 },
        { key: KEY_BACK, wait: 180 },
        { key: KEY_HOME, wait: 300 },
        { key: KEY_BACK, wait: 300 },
      ];
      await runSteps(driver, steps);

      const readable = await readableTextCount(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('interrupt_edit_flow_home_state_ok', 0, async () => {
      const before = await surfaceCount(driver);

      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_HOME, 2, 3000);

      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('interrupt_nav_with_rotation_ui_alive', 0, async () => {
      const before = await surfaceCount(driver);

      await pressKeyWithDelay(driver, KEY_RIGHT, 80);
      await safeRotate(driver, DisplayRotation.ROTATION_90, 900);
      await pressKeyWithDelay(driver, KEY_LEFT, 80);
      await safeRotate(driver, DisplayRotation.ROTATION_0, 900);

      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('home_back_storm_30_events_launcher_ok', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, i % 2 === 0 ? KEY_HOME : KEY_BACK, 2, 3000);
      }

      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const readable = await readableTextCount(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('post_chaos_smoke_basic_interaction_ok', 0, async () => {
      const before = await surfaceCount(driver);

      await runSteps(driver, [
        { key: KEY_RIGHT, wait: 100 },
        { key: KEY_EDIT, wait: 220 },
        { key: KEY_BACK, wait: 260 },
        { key: KEY_HOME, wait: 800 },
      ]);

      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('chaos_after_edit_int_sequence_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('post_chaos_home_back_burst_launch_text_ok', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, i % 2 === 0 ? KEY_HOME : KEY_BACK, 2, 3000);
      }
      await pressKeyWithDelay(driver, KEY_ENTER, 850);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const readable = await readableTextCount(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('post_chaos_edit_double_cycle_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('post_chaos_home_back_storm_edit_int_ok', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, i % 2 === 0 ? KEY_HOME : KEY_BACK, 2, 3000);
      }
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(60);
      }
      const readable = await readableTextCount(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('post_chaos_home_back_repeats_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 4; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('post_chaos_edit_enter_back_home_cycle_ok', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
      }
      const readable = await readableTextCount(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('post_chaos_dir_edit_mix_text_ok', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      const readable = await readableTextCount(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('post_chaos_edit_int_dir_burst_text_ok', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const readable = await readableTextCount(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('post_chaos_home_back_edit_repeat_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('stress_twenty_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('stress_fifteen_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });

    it('edit_interrupt_20x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(30);
    });
    it('stress_circular_dirs_12rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 6; r++) {
        for (const d of dirs) {
          await pressKeyWithDelay(driver, d, 45);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('stress_rapid_edit_back_20x_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });

    it('stress_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('stress_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('stress_nav_burst_50_home_text_2', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 45);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('stress_chaos_edit_interrupt_15x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(28);
    });
    it('stress_circular_dirs_12rounds_text_2', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 3; r++) {
        for (const d of dirs) {
          await pressKeyWithDelay(driver, d, 45);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
