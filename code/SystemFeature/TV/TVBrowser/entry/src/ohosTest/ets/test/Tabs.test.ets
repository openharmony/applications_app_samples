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
import { Driver, Component } from '@kit.TestKit';
import {
  createFreshDriver,
  clickById,
  safeFindAllById,
  safeFindById,
  safeFindByType,
  waitForStableSurface,
  waitForId,
  countSurface,
  openBrowserHome,
  backToSafeHome,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  safeDelay
} from './SharedDriver';
import { TestConstants, TestTimeouts, TestData, TabTestConstants } from './TestConstants';

const TAB_SWITCH_DELAY: number = TabTestConstants.SWITCH_DELAY;
const TAB_SWITCH_CHECK_TIMEOUT: number = TabTestConstants.SWITCH_CHECK_TIMEOUT;
const TAB_SWITCH_SURFACE_MIN: number = TabTestConstants.SWITCH_SURFACE_MIN;
const TAB_SWITCH_SURFACE_THRESHOLD: number = TabTestConstants.SWITCH_SURFACE_THRESHOLD;
const MULTI_TAB_ADD_DELAY: number = TabTestConstants.MULTI_TAB_ADD_DELAY;
const MULTI_TAB_CHECK_TIMEOUT: number = TabTestConstants.MULTI_TAB_CHECK_TIMEOUT;
const MULTI_TAB_SURFACE_THRESHOLD: number = TabTestConstants.MULTI_TAB_SURFACE_THRESHOLD;

export default function tabsTest(): void {
  describe('Browser_Tabs_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await openBrowserHome(driver);
    });

    afterAll(async () => {
      await backToSafeHome(driver);
    });

    it('tab_switching_should_not_cause_surface_abnormality', 0, async () => {
      const beforeSurface: number = await countSurface(driver);
      const closeButtons: Component[] = await safeFindAllById(driver, 'cancelBtn');
      if (closeButtons.length > 0) {
        try {
          await closeButtons[0].click();
        } catch (error) {
        }
      }
      await safeDelay(driver, TAB_SWITCH_DELAY);
      const stable: boolean =
        await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, TAB_SWITCH_CHECK_TIMEOUT);
      const afterSurface: number = await countSurface(driver);
      expect(stable).assertTrue();
      expect(afterSurface).assertLargerOrEqual(3);
      expect(Math.abs(afterSurface - beforeSurface)).assertLessOrEqual(TAB_SWITCH_SURFACE_THRESHOLD);
    });

    it('single_tab_should_not_expose_multiple_close_buttons', 0, async () => {
      const closeButtons: Component[] = await safeFindAllById(driver, 'cancelBtn');
      expect(closeButtons.length).assertLessOrEqual(1);
    });

    it('multiple_tab_additions_should_keep_surface_stable', 0, async () => {
      const beforeSurface: number = await countSurface(driver);
      let addedCount: number = 0;
      const addResult1: boolean = await clickById(driver, 'actionButton1', MULTI_TAB_ADD_DELAY);
      if (addResult1) {
        addedCount++;
      }
      const addResult2: boolean = await clickById(driver, 'actionButton1', MULTI_TAB_ADD_DELAY);
      if (addResult2) {
        addedCount++;
      }
      const addResult3: boolean = await clickById(driver, 'actionButton1', MULTI_TAB_ADD_DELAY);
      if (addResult3) {
        addedCount++;
      }
      const stable: boolean =
        await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, MULTI_TAB_CHECK_TIMEOUT);
      const closeButtons: Component[] = await safeFindAllById(driver, 'cancelBtn');
      const afterSurface: number = await countSurface(driver);
      expect(stable).assertTrue();
      if (addedCount > 0) {
        expect(closeButtons.length).assertLargerOrEqual(1);
      }
      expect(Math.abs(afterSurface - beforeSurface)).assertLessOrEqual(MULTI_TAB_SURFACE_THRESHOLD);
    });
  });
}
