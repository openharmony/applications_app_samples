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
import { Driver } from '@kit.TestKit';
import {
  createFreshDriver,
  clickById,
  typeToInput,
  waitForStableSurface,
  countSurface,
  countReadableTexts,
  openBrowserHome,
  backToSafeHome,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  safeDelay
} from './SharedDriver';
import { TestConstants, TestTimeouts, TestData, StressTestConstants } from './TestConstants';

const STRESS_ITERATIONS: number = StressTestConstants.ITERATIONS;
const SURFACE_CHANGE_THRESHOLD: number = StressTestConstants.SURFACE_CHANGE_THRESHOLD;
const HOME_SURFACE_MIN: number = 3;
const HOME_SURFACE_THRESHOLD: number = StressTestConstants.HOME_SURFACE_THRESHOLD;

export default function stressTest(): void {
  describe('Browser_Stress_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await openBrowserHome(driver);
    });

    afterAll(async () => {
      await backToSafeHome(driver);
    });

    it('repeated_submit_and_refresh_should_keep_surface_bounded', 0, async () => {
      const beforeSurface: number = await countSurface(driver);
      for (let round: number = 0; round < STRESS_ITERATIONS - 1; round++) {
        await typeToInput(driver, 'inputUrl', round % 2 === 0 ? 'www.baidu.com' : 'www.bing.com');
        await clickById(driver, 'actionButton0', 1400);
        await clickById(driver, 'navigationButton2', 800);
        await safeDelay(driver, 100);
      }
      const stable: boolean = await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 5000);
      const afterSurface: number = await countSurface(driver);
      expect(stable).assertTrue();
      expect(Math.abs(afterSurface - beforeSurface)).assertLessOrEqual(SURFACE_CHANGE_THRESHOLD);
    });

    it('burst_tab_creation_should_keep_texts_visible', 0, async () => {
      for (let round: number = 0; round < STRESS_ITERATIONS; round++) {
        await clickById(driver, 'actionButton1', 550);
        await safeDelay(driver, 50);
      }
      const readableTexts: number = await countReadableTexts(driver);
      expect(readableTexts).assertLargerOrEqual(1);
    });

    it('repeated_home_resets_should_not_drop_browser_surface', 0, async () => {
      const beforeSurface: number = await countSurface(driver);
      for (let round: number = 0; round < STRESS_ITERATIONS; round++) {
        await clickById(driver, 'navigationButton3', 900);
        await safeDelay(driver, 100);
      }
      await safeDelay(driver, 1200);
      const afterSurface: number = await countSurface(driver);
      expect(afterSurface).assertLargerOrEqual(HOME_SURFACE_MIN);
      expect(Math.abs(afterSurface - beforeSurface)).assertLessOrEqual(HOME_SURFACE_THRESHOLD);
    });
  });
}
