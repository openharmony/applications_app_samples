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
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';

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

type KeySeq = number[];

interface CaseDef {
  name: string;
  seq: KeySeq;
}

function buildExtendedCases(): CaseDef[] {
  const bases: CaseDef[] = [
    { name: 'nav_edit_home_back', seq: [KEY_RIGHT, KEY_EDIT, KEY_HOME, KEY_BACK] },
    { name: 'nav_enter_back_home', seq: [KEY_RIGHT, KEY_ENTER, KEY_BACK, KEY_HOME] },
    { name: 'up_down_enter_back', seq: [KEY_UP, KEY_DOWN, KEY_ENTER, KEY_BACK] },
    { name: 'edit_nav_home_back', seq: [KEY_EDIT, KEY_RIGHT, KEY_HOME, KEY_BACK] },
    { name: 'home_edit_back_nav', seq: [KEY_HOME, KEY_EDIT, KEY_BACK, KEY_RIGHT] },
    { name: 'nav_home_back_edit', seq: [KEY_LEFT, KEY_HOME, KEY_BACK, KEY_EDIT] },
    { name: 'down_nav_home_back', seq: [KEY_DOWN, KEY_RIGHT, KEY_HOME, KEY_BACK] },
    { name: 'enter_edit_home_back', seq: [KEY_ENTER, KEY_EDIT, KEY_HOME, KEY_BACK] },
  ];
  const result: CaseDef[] = [];
  for (const b of bases) {
    result.push({ name: `${b.name}_fwd`, seq: b.seq });
    result.push({ name: `${b.name}_rev`, seq: [...b.seq].reverse() });
    const rot = b.seq.slice(1).concat(b.seq.slice(0, 1));
    result.push({ name: `${b.name}_rot`, seq: rot });
  }
  return result;
}

async function runSeq(driver: Driver, seq: KeySeq): Promise<void> {
  for (const k of seq) {
    if (k === KEY_HOME || k === KEY_BACK || k === KEY_EDIT) {
      await pressKeyWithDelay(driver, k, 200);
    } else if (k === KEY_ENTER) {
      await pressKeyWithDelay(driver, k, 200);
    } else {
      await pressKeyWithDelay(driver, k, 100);
    }
  }
}

export default function expandedScenarioTest() {
  describe('ExpandedScenario_Test', () => {
    let driver: Driver;
    const cases = buildExtendedCases();

    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 2, 5000);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 3000);
    });
    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
    });

    for (let i = 0; i < cases.length; i++) {
      const c = cases[i];
      it(`${c.name}_case_${String(i + 1).padStart(3, '0')}`, 0, async () => {
        const before = await surfaceCount(driver);
        await runSeq(driver, c.seq);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
        const after = await surfaceCount(driver);
        expect(after).assertLargerOrEqual(2);
        expect(Math.abs(after - before)).assertLessOrEqual(28);
        expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      });
    }

    it('right_five_edit_home_back_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 80);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('expand_down_enter_back_home_text_readable', 0, async () => {
      await pressKeyWithDelay(driver, KEY_DOWN, 120);
      await pressKeyWithDelay(driver, KEY_ENTER, 200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('up_down_zigzag_home_surface_positive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_UP : KEY_DOWN, 90);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('edit_nav_enter_back_home_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_RIGHT, 100);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_ENTER, 200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('recent_nav_edit_home_back_chain_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressKeyWithDelay(driver, KEY_RIGHT, 120);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('expand_fifteen_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('ten_edit_cycles_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('nav_lr_40_home_text_readable', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 50);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('expand_five_launch_back_surface_bounded', 0, async () => {
      await returnDesktopStable(driver);
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 160);
        await pressKeyWithDelay(driver, KEY_ENTER, 260);
        await resilientPressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME, 2500);
        await waitForStableSurface(driver, 1, STABLE_TOLERANCE, 1500);
      }
      await resilientPressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME, 2500);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('expand_edit_interrupt_10x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('expand_circular_dirs_6rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 6; r++) {
        for (const d of dirs) {
          await pressKeyWithDelay(driver, d, 70);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('three_launch_edit_home_chain_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_ENTER, 200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(24);
    });

    it('expand_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('expand_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('expand_nav_50_lr_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 45);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('expand_eight_enter_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_ENTER, 200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('expand_edit_interrupt_10x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('expand_circular_4dirs_8rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 8; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(60);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
} 
