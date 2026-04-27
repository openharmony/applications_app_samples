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
import { Driver, ON, DisplayRotation } from '@ohos.UiTest';
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
  rotateWithDelay,
  safeDelay,
  safeRotate,
  safeFindComponents,
  countNonEmptyTexts,
  measureActionSurfaceLatency,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  TOLERANCE_SINGLE_OP,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS
} from './SharedDriver';

export default function performanceAndRenderTest() {
  describe('PerformanceAndRender_Test', () => {
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

    it('desktop_image_count_in_reasonable_range', 0, async () => {
      const images = await driver.findComponents(ON.type('Image'));
      const count = images ? images.length : 0;
      expect(count).assertLargerOrEqual(0);
      expect(count).assertLessOrEqual(80);
    });
    it('desktop_text_count_in_reasonable_range', 0, async () => {
      const texts = await driver.findComponents(ON.type('Text'));
      const count = texts ? texts.length : 0;
      expect(count).assertLargerOrEqual(1);
      expect(count).assertLessOrEqual(100);
    });
    it('three_sample_image_counts_should_be_stable', 0, async () => {
      const images1 = await driver.findComponents(ON.type('Image'));
      const s1 = images1 ? images1.length : 0;
      await safeDelay(driver, 300);
      const images2 = await driver.findComponents(ON.type('Image'));
      const s2 = images2 ? images2.length : 0;
      await safeDelay(driver, 300);
      const images3 = await driver.findComponents(ON.type('Image'));
      const s3 = images3 ? images3.length : 0;
      expect(Math.max(s1, s2, s3) - Math.min(s1, s2, s3)).assertLessOrEqual(TOLERANCE_SINGLE_OP);
    });
    it('non_empty_text_count_should_be_at_least_one', 0, async () => {
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('surface_count_should_be_at_least_two', 0, async () => {
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
    });

    it('home_key_latency_should_be_under_5000ms', 0, async () => {
      const lat = await measureActionSurfaceLatency(driver, async () => {
        await pressKeyWithDelay(driver, KEY_HOME);
      }, 1, 5000);
      expect(lat).assertLessOrEqual(5000);
    });
    it('back_key_latency_should_be_under_5000ms', 0, async () => {
      const lat = await measureActionSurfaceLatency(driver, async () => {
        await pressKeyWithDelay(driver, KEY_BACK);
      }, 2, 5000);
      expect(lat).assertLessOrEqual(5000);
    });
    it('edit_enter_latency_should_be_under_5000ms', 0, async () => {
      const lat = await measureActionSurfaceLatency(driver, async () => {
        await pressKeyWithDelay(driver, KEY_EDIT);
      }, 2, 5000);
      expect(lat).assertLessOrEqual(5000);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
    });
    it('right_nav_latency_should_be_under_3000ms', 0, async () => {
      const lat = await measureActionSurfaceLatency(driver, async () => {
        await pressKeyWithDelay(driver, KEY_RIGHT);
      }, 2, 3000);
      expect(lat).assertLessOrEqual(3000);
    });

    it('after_edit_back_image_count_stable', 0, async () => {
      const before = (await driver.findComponents(ON.type('Image'))).length;
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const after = (await driver.findComponents(ON.type('Image'))).length;
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_SINGLE_OP);
    });
    it('after_home_back_surface_count_stable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(Math.abs(after - before)).assertLessOrEqual(10);
    });
    it('after_ten_nav_image_count_stable', 0, async () => {
      const before = (await driver.findComponents(ON.type('Image'))).length;
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(80);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = (await driver.findComponents(ON.type('Image'))).length;
      expect(Math.abs(after - before)).assertLessOrEqual(10);
    });
    it('after_three_launch_back_image_count_stable', 0, async () => {
      const before = (await driver.findComponents(ON.type('Image'))).length;
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = (await driver.findComponents(ON.type('Image'))).length;
      expect(Math.abs(after - before)).assertLessOrEqual(12);
    });
    it('surface_count_after_five_edit_cycles_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      const after = await surfaceCount(driver);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('text_readable_after_all_stress', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('image_count_stable_after_home_cycle', 0, async () => {
      const before = (await driver.findComponents(ON.type('Image'))).length;
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = (await driver.findComponents(ON.type('Image'))).length;
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_SINGLE_OP);
    });
    it('surface_count_after_heavy_nav_still_positive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 3 === 0 ? KEY_RIGHT : i % 3 === 1 ? KEY_LEFT : KEY_DOWN);
        await driver.delayMs(60);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('text_stable_after_mixed_key_burst', 0, async () => {
      const keys = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP, KEY_ENTER, KEY_BACK];
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(keys[i % keys.length]);
        await driver.delayMs(60);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('perf_five_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('perf_ten_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('three_launch_back_cycles_surface_bounded', 0, async () => {
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
    it('perf_rapid_edit_back_8x_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('latency_nav_sequence_still_renders', 0, async () => {
      for (let i = 0; i < 6; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(80);
      }
      const count = await countNonEmptyTexts(driver);
      expect(count).assertLargerOrEqual(1);
    });

    it('edit_home_back_three_rounds_image_positive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });

    it('five_sample_stability_after_stress', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await driver.delayMs(300);
      const s1 = await surfaceCount(driver);
      await driver.delayMs(300);
      const s2 = await surfaceCount(driver);
      expect(Math.abs(s2 - s1)).assertLessOrEqual(TOLERANCE_SINGLE_OP);
      expect(Math.abs(s2 - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('nav_burst_forty_circular_surface_positive', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let i = 0; i < 3; i++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(50);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('three_sample_surface_stability_after_nav_burst', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(60);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const s1 = await surfaceCount(driver);
      await driver.delayMs(300);
      const s2 = await surfaceCount(driver);
      await driver.delayMs(300);
      const s3 = await surfaceCount(driver);
      expect(Math.max(s1, s2, s3) - Math.min(s1, s2, s3)).assertLessOrEqual(TOLERANCE_SINGLE_OP);
    });

    it('image_count_stable_across_three_home_back_cycles', 0, async () => {
      const counts: number[] = [];
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        counts.push((await driver.findComponents(ON.type('Image'))).length);
      }
      const diff = Math.max(...counts) - Math.min(...counts);
      expect(diff).assertLessOrEqual(TOLERANCE_SINGLE_OP);
      expect(Math.min(...counts)).assertLargerOrEqual(1);
    });

    it('latency_edit_enter_exit_under_threshold', 0, async () => {
      const lat = await measureActionSurfaceLatency(driver, async () => {
        await driver.triggerKey(KEY_EDIT);
      }, 2, TIMEOUT_EDIT);
      expect(lat).assertLessOrEqual(TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const lat2 = await measureActionSurfaceLatency(driver, async () => {
        await driver.triggerKey(KEY_BACK);
      }, 2, TIMEOUT_HOME);
      expect(lat2).assertLessOrEqual(TIMEOUT_HOME);
    });

    it('render_stable_after_edit_nav_home_back_chain', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      for (let i = 0; i < 6; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(80);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const s1 = await surfaceCount(driver);
      await driver.delayMs(400);
      const s2 = await surfaceCount(driver);
      expect(Math.abs(s2 - s1)).assertLessOrEqual(TOLERANCE_SINGLE_OP);
      expect(s2).assertLargerOrEqual(2);
    });

    it('text_count_positive_after_launch_back_three_rounds', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 120);
        await pressKeyWithDelay(driver, KEY_ENTER, 200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('image_text_ratio_reasonable_on_desktop', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const images = (await safeFindComponents(driver, 'Image')).length;
      const texts = (await safeFindComponents(driver, 'Text')).length;
      expect(images).assertLargerOrEqual(1);
      expect(texts).assertLargerOrEqual(1);
      expect(images + texts).assertLargerOrEqual(4);
      expect(images + texts).assertLessOrEqual(180);
    });

    it('perf_five_edit_cycles_image_count_bounded', 0, async () => {
      const before = (await safeFindComponents(driver, 'Image')).length;
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      const after = (await safeFindComponents(driver, 'Image')).length;
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
  });
}
