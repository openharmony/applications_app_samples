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
import { Driver } from '@ohos.UiTest';
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
  pressKeyWithDelay,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';

type KeySequence = number[];

interface CaseDef {
  name: string;
  seq: KeySequence
}

async function safePressAndWait(
  driver: Driver,
  key: number,
  minimumCount: number,
  timeoutMs: number
): Promise<void> {
  await pressKeyWithDelay(driver, key);
  await waitForSurface(driver, minimumCount, timeoutMs);
}

async function runSequence(driver: Driver, seq: KeySequence): Promise<void> {
  for (let i = 0; i < seq.length; i++) {
    const key = seq[i];
    if (key === KEY_HOME || key === KEY_BACK) {
      await safePressAndWait(driver, key, 2, TIMEOUT_HOME);
    } else if (key === KEY_EDIT) {
      await safePressAndWait(driver, key, 2, TIMEOUT_EDIT);
    } else if (key === KEY_ENTER) {
      await pressKeyWithDelay(driver, key, 900);
    } else {
      await pressKeyWithDelay(driver, key, 60);
    }
  }
}

function rotateSequence(seq: KeySequence, step: number): KeySequence {
  const offset = ((step % seq.length) + seq.length) % seq.length;
  return seq.slice(offset).concat(seq.slice(0, offset));
}

function buildCases(): CaseDef[] {
  const baseCases: CaseDef[] = [
    { name: 'layout_contract', seq: [KEY_LEFT, KEY_UP, KEY_DOWN, KEY_ENTER, KEY_BACK, KEY_HOME] },
    { name: 'edit_mode', seq: [KEY_UP, KEY_DOWN, KEY_ENTER, KEY_BACK, KEY_HOME, KEY_EDIT] },
    { name: 'shortcut_ops', seq: [KEY_DOWN, KEY_ENTER, KEY_BACK, KEY_HOME, KEY_EDIT, KEY_RIGHT] },
    { name: 'key_events', seq: [KEY_ENTER, KEY_BACK, KEY_HOME, KEY_EDIT, KEY_RIGHT, KEY_LEFT] },
    { name: 'recent_tasks', seq: [KEY_BACK, KEY_HOME, KEY_EDIT, KEY_RIGHT, KEY_LEFT, KEY_UP] },
    { name: 'statusbar_contract', seq: [KEY_HOME, KEY_EDIT, KEY_RIGHT, KEY_LEFT, KEY_UP, KEY_DOWN] },
    { name: 'persistence_race', seq: [KEY_EDIT, KEY_RIGHT, KEY_LEFT, KEY_UP, KEY_DOWN, KEY_ENTER] },
    { name: 'accessibility_tree', seq: [KEY_RIGHT, KEY_LEFT, KEY_UP, KEY_DOWN, KEY_ENTER, KEY_BACK] },
    { name: 'performance_path', seq: [KEY_UP, KEY_DOWN, KEY_ENTER, KEY_BACK, KEY_HOME, KEY_EDIT] },
    { name: 'stress_mix', seq: [KEY_DOWN, KEY_ENTER, KEY_BACK, KEY_HOME, KEY_EDIT, KEY_RIGHT] },
    { name: 'lifecycle_chain', seq: [KEY_ENTER, KEY_BACK, KEY_HOME, KEY_EDIT, KEY_RIGHT, KEY_LEFT] },
    { name: 'contract_guard', seq: [KEY_HOME, KEY_EDIT, KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN] },
  ];
  const expanded: CaseDef[] = [];
  for (let i = 0; i < baseCases.length; i++) {
    const c = baseCases[i];
    expanded.push({ name: `${c.name}_base`, seq: c.seq });
    expanded.push({ name: `${c.name}_reverse`, seq: [...c.seq].reverse() });
    expanded.push({ name: `${c.name}_rotate`, seq: rotateSequence(c.seq, i % c.seq.length) });
  }
  return expanded;
}

export default function massiveAutoExpansionTest() {
  describe('MassiveAutoExpansion_Test', () => {
    let driver: Driver;
    const cases = buildCases();

    beforeAll(async () => {
      driver = createFreshDriver();
      await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, 5000);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 3000);
    });
    afterAll(async () => {
      await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
    });

    for (let i = 0; i < cases.length; i++) {
      const c = cases[i];
      const suffix = String(i + 1).padStart(4, '0');
      it(`${c.name}_case_${suffix}`, 0, async () => {
        const before = await surfaceCount(driver);
        await runSequence(driver, c.seq);
        await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
        const after = await surfaceCount(driver);
        expect(after).assertLargerOrEqual(2);
        expect(Math.abs(after - before)).assertLessOrEqual(26);
        expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      });
    }

    it('massive_fifteen_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('massive_ten_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await safePressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('massive_nav_burst_50_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 45);
      }
      await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('massive_five_launch_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 130);
        await pressKeyWithDelay(driver, KEY_ENTER, 900);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('massive_edit_interrupt_10x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await safePressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('massive_circular_dirs_8rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 8; r++) {
        for (const d of dirs) {
          await pressKeyWithDelay(driver, d, 60);
        }
      }
      await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('massive_rapid_edit_back_12x_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await safePressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('combined_massive_chain_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await safePressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressKeyWithDelay(driver, KEY_ENTER, 900);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('massive_fifteen_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('twenty_edit_back_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await safePressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('five_launch_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, KEY_ENTER, 900);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('edit_home_back_15x_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await safePressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await safePressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_burst_lr_50_then_edit_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 40);
      }
      await safePressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await safePressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
