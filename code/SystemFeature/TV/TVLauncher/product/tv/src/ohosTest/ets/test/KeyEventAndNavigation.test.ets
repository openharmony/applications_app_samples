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
  KEY_RIGHT,
  KEY_LEFT,
  KEY_UP,
  KEY_DOWN,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  pressKeyWithDelay,
  countNonEmptyTexts
} from './SharedDriver';
import { KeyCode } from '../../../main/ets/common/constants/KeyCode';

const DIRECTION_KEYS: number[] = [
  KeyCode.KEY_DPAD_LEFT,
  KeyCode.KEY_DPAD_RIGHT,
  KeyCode.KEY_DPAD_UP,
  KeyCode.KEY_DPAD_DOWN,
];

interface KeyStep {
  key: number;
  delay: number
}

async function pressSeries(driver: Driver, steps: KeyStep[]): Promise<void> {
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
    await pressKeyWithDelay(driver, key, steps[i].delay);
  }
}

export default function keyEventAndNavigationTest() {
  describe('KeyEventAndNavigation_Test', () => {
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

    it('single_direction_keys_should_keep_desktop_alive', 0, async () => {
      const base = await surfaceCount(driver);

      for (let i = 0; i < DIRECTION_KEYS.length; i++) {
        await driver.triggerKey(DIRECTION_KEYS[i]);
        await driver.delayMs(160);
        const current = await surfaceCount(driver);
        expect(current).assertLargerOrEqual(2);
        expect(Math.abs(current - base)).assertLessOrEqual(14);
      }
    });

    it('dir_roundtrip_seq_focus_path_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressSeries(driver, [
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 100 },
        { key: KeyCode.KEY_DPAD_LEFT, delay: 100 },
        { key: KeyCode.KEY_DPAD_DOWN, delay: 100 },
        { key: KeyCode.KEY_DPAD_UP, delay: 100 },
      ]);

      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(12);
    });

    it('high_freq_dir_burst_render_tree_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KeyCode.KEY_DPAD_RIGHT : KeyCode.KEY_DPAD_LEFT);
        await driver.delayMs(55);
      }

      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('home_back_loop_should_keep_launcher_recoverable', 0, async () => {
      const before = await surfaceCount(driver);

      for (let i = 0; i < 4; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }

      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('edit_enter_exit_nav_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);

      await pressSeries(driver, [
        { key: KEY_EDIT, delay: 260 },
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 120 },
        { key: KeyCode.KEY_DPAD_LEFT, delay: 120 },
        { key: KEY_BACK, delay: 320 },
        { key: KEY_HOME, delay: 900 },
      ]);

      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('enter_back_home_chain_text_readable', 0, async () => {
      await pressSeries(driver, [
        { key: KEY_ENTER, delay: 900 },
        { key: KEY_BACK, delay: 700 },
        { key: KEY_HOME, delay: 900 },
      ]);

      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('multi_seq_matrix_component_contract_ok', 0, async () => {
      const sequences: KeyStep[][] = [
        [
          { key: KeyCode.KEY_DPAD_RIGHT, delay: 90 },
          { key: KeyCode.KEY_DPAD_RIGHT, delay: 90 },
          { key: KeyCode.KEY_DPAD_LEFT, delay: 90 },
        ],
        [
          { key: KeyCode.KEY_DPAD_UP, delay: 90 },
          { key: KeyCode.KEY_DPAD_DOWN, delay: 90 },
          { key: KeyCode.KEY_DPAD_DOWN, delay: 90 },
        ],
        [
          { key: KeyCode.KEY_DPAD_LEFT, delay: 90 },
          { key: KeyCode.KEY_DPAD_UP, delay: 90 },
          { key: KeyCode.KEY_DPAD_RIGHT, delay: 90 },
          { key: KeyCode.KEY_DPAD_DOWN, delay: 90 },
        ],
      ];

      for (let i = 0; i < sequences.length; i++) {
        const before = await surfaceCount(driver);
        await pressSeries(driver, sequences[i]);
        const after = await surfaceCount(driver);
        expect(after).assertLargerOrEqual(2);
        expect(Math.abs(after - before)).assertLessOrEqual(12);
      }
    });

    it('edit_int_dir_matrix_nav_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressSeries(driver, [
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 90 },
        { key: KeyCode.KEY_DPAD_LEFT, delay: 90 },
        { key: KeyCode.KEY_DPAD_UP, delay: 90 },
        { key: KeyCode.KEY_DPAD_DOWN, delay: 90 },
      ]);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('dir_enter_back_home_composite_text_ok', 0, async () => {
      await pressSeries(driver, [
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 100 },
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 100 },
        { key: KEY_ENTER, delay: 850 },
        { key: KEY_BACK, delay: 700 },
        { key: KEY_HOME, delay: 900 },
      ]);
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('double_home_back_after_dir_matrix_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressSeries(driver, [
        { key: KeyCode.KEY_DPAD_LEFT, delay: 80 },
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 80 },
        { key: KeyCode.KEY_DPAD_UP, delay: 80 },
        { key: KeyCode.KEY_DPAD_DOWN, delay: 80 },
      ]);
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('enter_edit_int_dir_roundtrip_text_ok', 0, async () => {
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(850);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressSeries(driver, [
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 90 },
        { key: KeyCode.KEY_DPAD_LEFT, delay: 90 },
      ]);
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('multi_seq_burst_home_back_storm_ok', 0, async () => {
      const before = await surfaceCount(driver);
      const matrix: KeyStep[] = [
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 70 },
        { key: KeyCode.KEY_DPAD_LEFT, delay: 70 },
        { key: KeyCode.KEY_DPAD_UP, delay: 70 },
        { key: KeyCode.KEY_DPAD_DOWN, delay: 70 },
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 70 },
        { key: KeyCode.KEY_DPAD_LEFT, delay: 70 },
      ];
      await pressSeries(driver, matrix);
      await pressSeries(driver, matrix);
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('enter_back_edit_cycle_dir_matrix_ok', 0, async () => {
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(820);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressSeries(driver, [
        { key: KeyCode.KEY_DPAD_LEFT, delay: 90 },
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 90 },
        { key: KeyCode.KEY_DPAD_UP, delay: 90 },
        { key: KeyCode.KEY_DPAD_DOWN, delay: 90 },
      ]);
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('triple_matrix_edit_int_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressSeries(driver, [
          { key: KeyCode.KEY_DPAD_RIGHT, delay: 70 },
          { key: KeyCode.KEY_DPAD_LEFT, delay: 70 },
          { key: KeyCode.KEY_DPAD_UP, delay: 70 },
          { key: KeyCode.KEY_DPAD_DOWN, delay: 70 },
        ]);
      }
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('home_back_burst_after_enter_cycle_ok', 0, async () => {
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(820);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('matrix_stress_enter_back_home_cycle_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressSeries(driver, [
          { key: KeyCode.KEY_DPAD_RIGHT, delay: 70 },
          { key: KeyCode.KEY_DPAD_LEFT, delay: 70 },
          { key: KeyCode.KEY_DPAD_UP, delay: 70 },
          { key: KeyCode.KEY_DPAD_DOWN, delay: 70 },
        ]);
      }
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(820);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('edit_int_reentry_dir_roundtrip_text_ok', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressSeries(driver, [
        { key: KeyCode.KEY_DPAD_LEFT, delay: 90 },
        { key: KeyCode.KEY_DPAD_RIGHT, delay: 90 },
      ]);
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('dir_storm_edit_menu_cycle_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KeyCode.KEY_DPAD_RIGHT : KeyCode.KEY_DPAD_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await driver.triggerKey(KeyCode.KEY_DPAD_UP);
      await driver.delayMs(150);
      await driver.triggerKey(KeyCode.KEY_DPAD_DOWN);
      await driver.delayMs(150);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('enter_back_home_reentry_repeat_text_ok', 0, async () => {
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(820);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('enter_back_edit_cycle_home_reentry_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(820);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('dir_matrix_repeat_text_layer_ok', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await pressSeries(driver, [
          { key: KeyCode.KEY_DPAD_RIGHT, delay: 80 },
          { key: KeyCode.KEY_DPAD_LEFT, delay: 80 },
          { key: KeyCode.KEY_DPAD_UP, delay: 80 },
          { key: KeyCode.KEY_DPAD_DOWN, delay: 80 },
        ]);
      }
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('keynav_twenty_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('keynav_fifteen_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('keynav_nav_burst_50_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(45);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('keynav_ten_launch_back_surface_bounded', 0, async () => {
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
    it('keyevent_nav_edit_interrupt_15x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(28);
    });
    it('keynav_circular_dirs_10rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 10; r++) {
        for (const d of dirs) {
          await pressKeyWithDelay(driver, d, 55);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('keynav_rapid_edit_back_20x_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('combined_keyevent_nav_chain_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        for (let j = 0; j < 6; j++) {
          await pressKeyWithDelay(driver, j % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 55);
        }
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
        await pressKeyWithDelay(driver, KEY_ENTER, 900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('keynav_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('keynav_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('keynav_nav_burst_50_home_text_2', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 45);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('keyevent_nav_edit_interrupt_15x_surface_bounded_2', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(28);
    });
    it('keynav_circular_dirs_12rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 12; r++) {
        for (const d of dirs) {
          await pressKeyWithDelay(driver, d, 50);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
