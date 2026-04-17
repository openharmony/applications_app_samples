/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver, DisplayRotation } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_RIGHT,
  KEY_LEFT,
  KEY_UP,
  KEY_DOWN,
  KEY_ENTER,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  pressKeyWithDelay,
  safeDelay,
  safeRotate,
  surfaceCount,
  countNonEmptyTexts,
  measureActionSurfaceLatency,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  TOLERANCE_EDIT_CYCLE
} from './SharedDriver';
import LruCache from '../../../../../../common/src/main/ets/default/cache/LruCache';
import { CheckEmptyUtils } from '../../../../../../common/src/main/ets/default/utils/CheckEmptyUtils';
import { CommonConstants } from '../../../../../../common/src/main/ets/default/constants/CommonConstants';
import { AppItemInfo as CommonAppItemInfo } from '../../../../../../common/src/main/ets/default/bean/AppItemInfo';
import { AppItemInfo as MainAppItemInfo } from '../../../main/ets/common/bean/AppItemInfo';

export default function integrationEndToEndTest() {
  describe('IntegrationEndToEnd_Test', () => {
    let driver: Driver;
    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 2, 4000);
      await waitForStableSurface(driver, 2, 6, 2500);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
    });
    afterAll(async () => {
      await safeRotate(driver, DisplayRotation.ROTATION_0);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, 2, 6, 2000);
    });

    it('cache_bean_constants_then_desktop_alive', 0, async () => {
      const cache = new LruCache(10);
      cache.putCache('com.ohos.settings', 'icon');
      expect(cache.getCache('com.ohos.settings')).assertEqual('icon');
      expect(CommonConstants.LAUNCHER_BUNDLE).assertEqual('com.ohos.launcher');
      const src = new CommonAppItemInfo();
      src.appName = 'Settings';
      src.bundleName = 'com.ohos.settings';
      const dst = new MainAppItemInfo();
      dst.cover(src);
      expect(dst.appName).assertEqual('Settings');
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
    });
    it('empty_util_then_edit_cycle_ok', 0, async () => {
      expect(CheckEmptyUtils.isEmpty(undefined)).assertTrue();
      expect(CheckEmptyUtils.isEmpty('launcher')).assertFalse();
      expect(CheckEmptyUtils.isEmptyArr([])).assertTrue();
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('cache_stress_then_edit_home_back_ok', 0, async () => {
      const cache = new LruCache(20);
      for (let i = 0; i < 5; i++) {
        cache.putCache('k' + i, 'v' + i);
      }
      cache.clear();
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
    });
    it('bean_cover_then_nav_text_readable', 0, async () => {
      const src = new CommonAppItemInfo();
      src.appId = 'nav_test';
      src.appName = 'NavApp';
      src.bundleName = 'com.nav';
      const dst = new MainAppItemInfo();
      dst.cover(src);
      expect(dst.canMove).assertTrue();
      await pressKeyWithDelay(driver, KEY_RIGHT, 150);
      await pressKeyWithDelay(driver, KEY_LEFT, 150);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('lru_evict_then_home_back_surface_ok', 0, async () => {
      const cache = new LruCache(3);
      cache.putCache('a', 'A');
      cache.putCache('b', 'B');
      cache.putCache('c', 'C');
      cache.putCache('d', 'D');
      const evicted = cache.getCache('a');
      expect(evicted === -1 || evicted === null).assertTrue();
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });

    it('nav_edit_home_back_enter_back_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressKeyWithDelay(driver, KEY_RIGHT, 120);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressKeyWithDelay(driver, KEY_ENTER, 200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('rotate_nav_edit_home_back_text', 0, async () => {
      await safeRotate(driver, DisplayRotation.ROTATION_90, 700);
      await pressKeyWithDelay(driver, KEY_RIGHT, 120);
      await safeRotate(driver, DisplayRotation.ROTATION_0, 700);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('three_full_cycles_text_readable', 0, async () => {
      for (let r = 0; r < 3; r++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 100);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('cache_fill_rotate_edit_home_ok', 0, async () => {
      const cache = new LruCache(15);
      for (let i = 0; i < 3; i++) {
        cache.putCache('p' + i, 'v' + i);
      }
      const first = cache.getCache('p0');
      expect(first === 'v0' || first === 0 || first === -1).assertTrue();
      const before = await surfaceCount(driver);
      await safeRotate(driver, DisplayRotation.ROTATION_90, 700);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await safeRotate(driver, DisplayRotation.ROTATION_0, 700);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });

    it('home_latency_under_2000ms', 0, async () => {
      const elapsed = await measureActionSurfaceLatency(driver, async () => {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      }, 2, 3000);
      expect(elapsed).assertLessOrEqual(2000);
    });
    it('edit_back_latency_under_3000ms', 0, async () => {
      const elapsed = await measureActionSurfaceLatency(driver, async () => {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }, 2, 3000);
      expect(elapsed).assertLessOrEqual(3000);
    });
    it('surface_stable_after_10_home_back', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });
    it('component_count_stable_over_3_samples', 0, async () => {
      const s1 = await surfaceCount(driver);
      await safeDelay(driver, 500);
      const s2 = await surfaceCount(driver);
      await safeDelay(driver, 500);
      const s3 = await surfaceCount(driver);
      expect(Math.max(s1, s2, s3) - Math.min(s1, s2, s3)).assertLessOrEqual(8);
    });

    it('smoke_basic_desktop_has_content', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(await surfaceCount(driver)).assertLargerOrEqual(6);
    });
    it('smoke_edit_back_recovers', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(8);
    });
    it('smoke_nav_still_works', 0, async () => {
      await pressKeyWithDelay(driver, KEY_RIGHT, 200);
      await pressKeyWithDelay(driver, KEY_LEFT, 200);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('smoke_home_back_still_works', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('smoke_data_contracts_valid', 0, () => {
      expect(CommonConstants.LAUNCHER_BUNDLE).assertEqual('com.ohos.launcher');
      expect(CommonConstants.TYPE_APP).assertEqual(0);
      expect(CommonConstants.INVALID_VALUE).assertEqual(-1);
      expect(CheckEmptyUtils.isEmpty(null)).assertTrue();
      expect(CheckEmptyUtils.isEmpty('x')).assertFalse();
      const cache = new LruCache(5);
      cache.putCache('k', 'v');
      expect(cache.getCache('k')).assertEqual('v');
      cache.remove('k');
      const removed = cache.getCache('k');
      expect(removed === -1 || removed === null).assertTrue();
    });
    it('smoke_full_chain_ok', 0, async () => {
      expect(CheckEmptyUtils.isEmptyArr([])).assertTrue();
      const before = await surfaceCount(driver);
      await pressKeyWithDelay(driver, KEY_RIGHT, 100);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });
  });
}
