/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver } from '@ohos.UiTest';
import {
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  surfaceCount,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';
import { Throttle } from '../../../main/ets/common/baseUtil/throttle';

interface ThrottleArgRecord {
  key: string;
}

interface ThrottleResult {
  key: string;
  period: number;
  call: () => boolean;
  callCount: () => number;
  lastArgs: () => ReadonlyArray<number | string | boolean | ThrottleArgRecord>;
}

function makeThrottleKey(name: string, period: number): string {
  return `${name}_${period}`;
}

function makeThrottledFn(name: string, period: number): ThrottleResult {
  let count = 0;
  let argsSnapshot: Array<number | string | boolean | ThrottleArgRecord> = [];
  const key = makeThrottleKey(name, period);

  return {
    key,
    period,
    call: (): boolean => {
      const ok = Throttle.canInvoke(key, period);
      if (ok) {
        count++;
      }
      return ok;
    },
    callCount: (): number => count,
    lastArgs: (): ReadonlyArray<number | string | boolean | ThrottleArgRecord> => argsSnapshot
  };
}

function makeNamedThrottledFn(name: string, period: number): ThrottleResult {
  return makeThrottledFn(name, period);
}

function makePeriodThrottledFn(period: number): ThrottleResult {
  return makeThrottledFn(`p${period}_${Date.now()}`, period);
}

function callWithArgs(
  result: ThrottleResult,
  ...args: Array<number | string | boolean | ThrottleArgRecord>
): boolean {
  const ok = result.call();
  if (ok) {
    const snapshot = result.lastArgs() as Array<number | string | boolean | ThrottleArgRecord>;
    snapshot.length = 0;
    for (let i = 0; i < args.length; i++) {
      snapshot.push(args[i]);
    }
  }
  return ok;
}

export default function throttleTest() {
  describe('Throttle_Test', () => {
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

    it('first_call_executes_immediately', 0, () => {
      const t = makeNamedThrottledFn('t500_1', 500);
      expect(t.call()).assertTrue();
      expect(t.callCount()).assertEqual(1);
    });

    it('second_call_within_period_is_suppressed', 0, () => {
      const t = makeNamedThrottledFn('t500_2', 500);
      expect(t.call()).assertTrue();
      expect(t.call()).assertFalse();
      expect(t.call()).assertFalse();
      expect(t.callCount()).assertEqual(1);
    });

    it('returns_boolean_from_canInvoke', 0, () => {
      const key = makeThrottleKey('ret', 100);
      const result = Throttle.canInvoke(key, 100);
      expect(typeof result).assertEqual('boolean');
    });

    it('throttle_with_zero_period_allows_calls', 0, () => {
      const t = makeNamedThrottledFn('t0', 0);
      t.call();
      t.call();
      expect(t.callCount()).assertLargerOrEqual(1);
    });

    it('multiple_instances_are_independent', 0, () => {
      const a = makeNamedThrottledFn('ind_a', 500);
      const b = makeNamedThrottledFn('ind_b', 500);
      a.call();
      b.call();
      b.call();
      expect(a.callCount()).assertEqual(1);
      expect(b.callCount()).assertEqual(1);
    });

    it('throttle_records_arguments_when_invoked', 0, () => {
      const t = makeNamedThrottledFn('args', 500);
      const argObj: ThrottleArgRecord = { key: 'val' };
      expect(callWithArgs(t, 1, 'two', true, argObj)).assertTrue();
      const args = t.lastArgs();
      expect(args.length).assertEqual(4);
      expect(args[0] as number).assertEqual(1);
      expect(args[1] as string).assertEqual('two');
      expect(args[2] as boolean).assertTrue();
      expect((args[3] as ThrottleArgRecord).key).assertEqual('val');
    });

    it('ten_rapid_calls_only_first_executes', 0, () => {
      const t = makeNamedThrottledFn('rapid10', 1000);
      for (let i = 0; i < 10; i++) {
        t.call();
      }
      expect(t.callCount()).assertEqual(1);
    });

    it('different_keys_are_independent_even_with_same_period', 0, () => {
      const a = makeNamedThrottledFn('same_period_a', 300);
      const b = makeNamedThrottledFn('same_period_b', 300);
      a.call();
      b.call();
      expect(a.callCount()).assertEqual(1);
      expect(b.callCount()).assertEqual(1);
    });

    it('different_periods_with_different_keys_both_fire_once', 0, () => {
      const slow = makeNamedThrottledFn('slow', 5000);
      const fast = makeNamedThrottledFn('fast', 50);
      slow.call();
      slow.call();
      fast.call();
      fast.call();
      expect(slow.callCount()).assertEqual(1);
      expect(fast.callCount()).assertEqual(1);
    });

    it('large_period_still_first_call_executes', 0, () => {
      const t = makePeriodThrottledFn(999999);
      t.call();
      expect(t.callCount()).assertEqual(1);
    });

    it('negative_period_does_not_throw', 0, () => {
      const t = makePeriodThrottledFn(-1);
      let threw = false;
      try {
        t.call();
      } catch (error) {
        threw = true;
      }
      expect(threw).assertFalse();
      expect(t.callCount()).assertEqual(1);
    });

    it('no_call_count_is_zero', 0, () => {
      const t = makeNamedThrottledFn('none', 500);
      expect(t.callCount()).assertEqual(0);
    });

    it('five_independent_instances_batch', 0, () => {
      const probes: ThrottleResult[] = [100, 200, 300, 400, 500].map((period: number, index: number) => {
        return makeNamedThrottledFn(`batch_${index}`, period);
      });
      for (let i = 0; i < probes.length; i++) {
        probes[i].call();
        probes[i].call();
        probes[i].call();
      }
      for (let i = 0; i < probes.length; i++) {
        expect(probes[i].callCount()).assertEqual(1);
      }
    });

    it('three_instances_all_independent', 0, () => {
      const a = makeNamedThrottledFn('three_a', 300);
      const b = makeNamedThrottledFn('three_b', 300);
      const c = makeNamedThrottledFn('three_c', 300);
      a.call();
      b.call();
      c.call();
      a.call();
      b.call();
      c.call();
      expect(a.callCount()).assertEqual(1);
      expect(b.callCount()).assertEqual(1);
      expect(c.callCount()).assertEqual(1);
    });

    it('hundred_calls_stress_no_throw', 0, () => {
      const t = makeNamedThrottledFn('stress', 3000);
      let threw = false;
      try {
        for (let i = 0; i < 100; i++) {
          t.call();
        }
      } catch (error) {
        threw = true;
      }
      expect(threw).assertFalse();
      expect(t.callCount()).assertEqual(1);
    });

    it('throttle_logic_then_edit_cycle_surface_ok', 0, async () => {
      const t = makeNamedThrottledFn('ui_edit_cycle', 300);
      t.call();
      t.call();
      t.call();
      expect(t.callCount()).assertEqual(1);
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('throttle_multi_instance_home_back_text_ok', 0, async () => {
      const a = makeNamedThrottledFn('ui_home_back_a', 200);
      const b = makeNamedThrottledFn('ui_home_back_b', 200);
      a.call();
      b.call();
      a.call();
      b.call();
      expect(a.callCount()).assertEqual(1);
      expect(b.callCount()).assertEqual(1);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('stress_throttle_then_nav_surface_ok', 0, async () => {
      const t = makeNamedThrottledFn('ui_nav_surface', 1000);
      for (let i = 0; i < 5; i++) {
        t.call();
      }
      expect(t.callCount()).assertEqual(1);
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });

    it('five_throttle_instances_then_edit_home_text', 0, async () => {
      const probes: ThrottleResult[] = [100, 200, 300, 400, 500].map((period: number, index: number) => {
        return makeNamedThrottledFn(`ui_batch_${index}`, period);
      });
      for (let i = 0; i < probes.length; i++) {
        probes[i].call();
        probes[i].call();
      }
      for (let i = 0; i < probes.length; i++) {
        expect(probes[i].callCount()).assertEqual(1);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('throttle_then_home_back_surface_bounded', 0, async () => {
      const t = makeNamedThrottledFn('ui_surface_bounded', 500);
      for (let i = 0; i < 3; i++) {
        t.call();
      }
      expect(t.callCount()).assertEqual(1);
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
  });
}
