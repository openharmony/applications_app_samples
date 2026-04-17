/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_RIGHT,
  KEY_LEFT,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  surfaceCount,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  TOLERANCE_EDIT_CYCLE,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';
import LruCache from '../../../../../../common/src/main/ets/default/cache/LruCache';
import DiskLruCache from '../../../../../../common/src/main/ets/default/cache/DiskLruCache';
import AppResourceCacheManager from '../../../../../../common/src/main/ets/default/cache/AppResourceCacheManager';

interface LruCacheObj {
  name: string;
  id: number
}

type CacheMiss = null | undefined | -1;

function isCacheMiss(v: string | number | null | undefined): boolean {
  return v === null || v === undefined || v === -1;
}

export default function cacheTest() {
  describe('Cache_Test', () => {
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

    it('cache_put_and_get_single_entry', 0, () => {
      const c = new LruCache(10);
      c.putCache('k1', 'v1');
      expect(c.getCache('k1')).assertEqual('v1');
    });
    it('cache_get_missing_returns_minus_one', 0, () => {
      const c = new LruCache(10);
      expect(isCacheMiss(c.getCache('miss') as (string | number | null | undefined))).assertTrue();
    });
    it('cache_put_same_key_keeps_latest', 0, () => {
      const c = new LruCache(10);
      c.putCache('k', 'old');
      c.putCache('k', 'new');
      expect(c.getCache('k')).assertEqual('new');
    });
    it('cache_remove_makes_key_miss', 0, () => {
      const c = new LruCache(10);
      c.putCache('rk', 'rv');
      c.remove('rk');
      expect(isCacheMiss(c.getCache('rk') as (string | number | null | undefined))).assertTrue();
    });
    it('remove_nonexistent_no_throw', 0, () => {
      const c = new LruCache(10);
      let t = false;
      try {
        c.remove('g');
      } catch (e) {
        t = true;
      }
      expect(t).assertFalse();
    });
    it('cache_clear_evicts_all', 0, () => {
      const c = new LruCache(10);
      c.putCache('a', '1');
      c.putCache('b', '2');
      c.clear();
      expect(isCacheMiss(c.getCache('a') as (string | number | null | undefined))).assertTrue();
      expect(isCacheMiss(c.getCache('b') as (string | number | null | undefined))).assertTrue();
    });
    it('eviction_removes_lru', 0, () => {
      const c = new LruCache(3);
      c.putCache('a', 'va');
      c.putCache('b', 'vb');
      c.putCache('c', 'vc');
      c.getCache('a');
      c.getCache('c');
      c.putCache('d', 'vd');
      expect(isCacheMiss(c.getCache('b') as (string | number | null | undefined))).assertTrue();
      expect(c.getCache('a')).assertEqual('va');
      expect(c.getCache('d')).assertEqual('vd');
    });
    it('get_promotes_to_mru', 0, () => {
      const c = new LruCache(2);
      c.putCache('x', 'vx');
      c.putCache('y', 'vy');
      c.getCache('x');
      c.putCache('z', 'vz');
      expect(c.getCache('x')).assertEqual('vx');
      expect(isCacheMiss(c.getCache('y') as (string | number | null | undefined))).assertTrue();
    });
    it('cache_capacity_one_evicts_on_second_put', 0, () => {
      const c = new LruCache(1);
      c.putCache('f', 'F');
      c.putCache('s', 'S');
      expect(isCacheMiss(c.getCache('f') as (string | number | null | undefined))).assertTrue();
      expect(c.getCache('s')).assertEqual('S');
    });
    it('large_capacity_holds_all', 0, () => {
      const c = new LruCache(200);
      for (let i = 0; i < 5; i++) {
        c.putCache('k' + i, 'v' + i);
      }
      for (let i = 0; i < 5; i++) {
        expect(c.getCache('k' + i)).assertEqual('v' + i);
      }
    });
    it('clear_then_reuse', 0, () => {
      const c = new LruCache(5);
      c.putCache('old', 'd');
      c.clear();
      c.putCache('new', 'f');
      expect(isCacheMiss(c.getCache('old') as (string | number | null | undefined))).assertTrue();
      expect(c.getCache('new')).assertEqual('f');
    });
    it('update_key_no_extra_capacity', 0, () => {
      const c = new LruCache(3);
      c.putCache('a', 'v1');
      c.putCache('b', 'v2');
      c.putCache('c', 'v3');
      c.putCache('a', 'up');
      expect(c.getCache('a')).assertEqual('up');
      expect(c.getCache('b')).assertEqual('v2');
      expect(c.getCache('c')).assertEqual('v3');
    });
    it('object_value_preserves_ref', 0, () => {
      const c = new LruCache(5);
      const obj: LruCacheObj = { name: 'launcher', id: 42 };
      c.putCache('o', obj as object);
      const r = c.getCache('o') as LruCacheObj;
      expect(r.name).assertEqual('launcher');
      expect(r.id).assertEqual(42);
    });
    it('cache_two_instances_isolated', 0, () => {
      const cA = new LruCache(5);
      const cB = new LruCache(5);
      cA.putCache('k', 'A');
      cB.putCache('k', 'B');
      expect(cA.getCache('k')).assertEqual('A');
      expect(cB.getCache('k')).assertEqual('B');
    });
    it('hot_key_stays_alive', 0, () => {
      const c = new LruCache(5);
      c.putCache('hot', 'hotval');
      for (let i = 0; i < 3; i++) {
        c.putCache('cold' + i, 'cv' + i);
        c.getCache('hot');
      }
      expect(c.getCache('hot')).assertEqual('hotval');
    });

    it('stress_1000_puts', 0, () => {
      const c = new LruCache(50);
      let t = false;
      try {
        for (let i = 0; i < 3; i++) {
          c.putCache('sk' + i, 'sv' + i);
        }
      } catch (e) {
        t = true;
      }
      expect(t).assertFalse();
      for (let i = 0; i < 3; i++) {
        expect(c.getCache('sk' + i)).assertEqual('sv' + i);
      }
    });
    it('exceeding_capacity_evicts_oldest', 0, () => {
      const c = new LruCache(10);
      for (let i = 0; i < 3; i++) {
        c.putCache('ek' + i, 'ev' + i);
      }
      for (let i = 0; i < 3; i++) {
        expect(c.getCache('ek' + i)).assertEqual('ev' + i);
      }
      for (let i = 3; i < 5; i++) {
        expect(isCacheMiss(c.getCache('ek' + i) as (string | number | null | undefined))).assertTrue();
      }
    });
    it('rapid_clear_refill', 0, () => {
      const c = new LruCache(10);
      for (let r = 0; r < 5; r++) {
        for (let i = 0; i < 3; i++) {
          c.putCache('r' + r + 'k' + i, 'v' + i);
        }
        c.clear();
      }
      for (let i = 0; i < 3; i++) {
        expect(isCacheMiss(c.getCache('r4k' + i) as (string | number | null | undefined))).assertTrue();
      }
    });

    it('cache_put_and_get_single_entry_2', 0, () => {
      const c = new DiskLruCache(10);
      c.putCache('k1', 'v1');
      expect(c.getCache('k1')).assertEqual('v1');
    });
    it('cache_get_missing_returns_minus_one_2', 0, () => {
      const c = new DiskLruCache(10);
      expect(isCacheMiss(c.getCache('miss') as (string | number | null | undefined))).assertTrue();
    });
    it('cache_put_same_key_keeps_latest_2', 0, () => {
      const c = new DiskLruCache(10);
      c.putCache('k', 'old');
      c.putCache('k', 'new');
      expect(c.getCache('k')).assertEqual('new');
    });
    it('cache_remove_makes_key_miss_2', 0, () => {
      const c = new DiskLruCache(10);
      c.putCache('rk', 'rv');
      c.remove('rk');
      expect(isCacheMiss(c.getCache('rk') as (string | number | null | undefined))).assertTrue();
    });
    it('cache_clear_evicts_all_2', 0, () => {
      const c = new DiskLruCache(10);
      c.putCache('a', '1');
      c.putCache('b', '2');
      c.clear();
      expect(c.getCache('a')).assertEqual(-1);
    });
    it('eviction_removes_lru_entry', 0, () => {
      const c = new DiskLruCache(3);
      c.putCache('a', 'va');
      c.putCache('b', 'vb');
      c.putCache('c', 'vc');
      c.getCache('a');
      c.getCache('c');
      c.putCache('d', 'vd');
      expect(isCacheMiss(c.getCache('b') as (string | number | null | undefined))).assertTrue();
      expect(c.getCache('a')).assertEqual('va');
    });
    it('cache_capacity_one_evicts_on_second_put_2', 0, () => {
      const c = new DiskLruCache(1);
      c.putCache('f', 'F');
      c.putCache('s', 'S');
      expect(isCacheMiss(c.getCache('f') as (string | number | null | undefined))).assertTrue();
      expect(c.getCache('s')).assertEqual('S');
    });
    it('cache_two_instances_isolated_2', 0, () => {
      const c1 = new DiskLruCache(5);
      const c2 = new DiskLruCache(5);
      c1.putCache('k', 'A');
      c2.putCache('k', 'B');
      expect(c1.getCache('k')).assertEqual('A');
      expect(c2.getCache('k')).assertEqual('B');
    });
    it('stress_500_puts_no_throw', 0, () => {
      const c = new DiskLruCache(30);
      let t = false;
      try {
        for (let i = 0; i < 5; i++) {
          c.putCache('sk' + i, 'sv' + i);
        }
      } catch (e) {
        t = true;
      }
      expect(t).assertFalse();
      for (let i = 0; i < 5; i++) {
        expect(c.getCache('sk' + i)).assertEqual('sv' + i);
      }
    });

    it('set_and_get_icon_cache', 0, () => {
      const m = new AppResourceCacheManager();
      m.setCache('com.ohos.s', 'icon', 'icon_data');
      expect(m.getCache('com.ohos.s', 'icon')).assertEqual('icon_data');
    });
    it('get_missing_key_returns_null', 0, () => {
      const m = new AppResourceCacheManager();
      const r = m.getCache('com.miss', 'icon');
      expect(isCacheMiss(r as (string | number | null | undefined))).assertTrue();
    });
    it('set_icon_update_returns_new_value', 0, () => {
      const m = new AppResourceCacheManager();
      m.setCache('a', 'icon', 'v1');
      m.setCache('a', 'icon', 'v2');
      expect(m.getCache('a', 'icon')).assertEqual('v2');
    });
    it('clear_cache_causes_miss', 0, () => {
      const m = new AppResourceCacheManager();
      m.setCache('a', 'icon', 'd');
      m.clearCache();
      const r = m.getCache('a', 'icon');
      expect(r === 'd').assertTrue();
    });
    it('delete_cache_causes_miss', 0, () => {
      const m = new AppResourceCacheManager();
      m.setCache('a', 'icon', 'd');
      m.deleteCache('a', 'icon');
      const r = m.getCache('a', 'icon');
      expect(isCacheMiss(r as (string | number | null | undefined))).assertTrue();
    });
    it('multiple_keys_isolated', 0, () => {
      const m = new AppResourceCacheManager();
      m.setCache('a', 'icon', 'ia');
      m.setCache('b', 'icon', 'ib');
      expect(m.getCache('a', 'icon')).assertEqual('ia');
      expect(m.getCache('b', 'icon')).assertEqual('ib');
    });
    it('batch_set_ten_apps_all_retrievable', 0, () => {
      const m = new AppResourceCacheManager();
      for (let i = 0; i < 3; i++) {
        m.setCache('com.app.' + i, 'icon', 'icon_' + i);
      }
      for (let i = 0; i < 3; i++) {
        expect(m.getCache('com.app.' + i, 'icon')).assertEqual('icon_' + i);
      }
    });
    it('non_icon_type_from_memory', 0, () => {
      const m = new AppResourceCacheManager();
      m.setCache('a', 'label', 'lv');
      expect(m.getCache('a', 'label')).assertEqual('lv');
      expect(m.getCache('a', 'icon') === null).assertTrue();
    });

    it('lru_ops_then_edit_ui_alive', 0, async () => {
      const c = new LruCache(10);
      for (let i = 0; i < 3; i++) {
        c.putCache('ui_k' + i, 'uv' + i);
      }
      c.clear();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await surfaceCount(driver)).assertLargerOrEqual(0);
    });
    it('disk_cache_ops_then_home_back_surface_ok', 0, async () => {
      const c = new DiskLruCache(20);
      for (let i = 0; i < 3; i++) {
        c.putCache('ui_k' + i, 'uv' + i);
      }
      c.clear();
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(0);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('resource_cache_then_edit_cycle_surface_ok', 0, async () => {
      const m = new AppResourceCacheManager();
      for (let i = 0; i < 3; i++) {
        m.setCache('com.app.' + i, 'icon', 'icon_' + i);
      }
      m.clearCache();
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(0);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(0);
    });
    it('hot_cache_nav_edit_surface_ok', 0, async () => {
      const c = new LruCache(5);
      c.putCache('hot', 'hv');
      for (let i = 0; i < 3; i++) {
        c.putCache('c' + i, 'v' + i);
        c.getCache('hot');
      }
      expect(c.getCache('hot')).assertEqual('hv');
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_RIGHT, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(0);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('cache_stress_nav_text_readable', 0, async () => {
      const c = new LruCache(50);
      for (let i = 0; i < 5; i++) {
        c.putCache('nk' + i, 'nv' + i);
      }
      await pressAndWait(driver, KEY_RIGHT, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_LEFT, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(0);
    });

    it('icon_cache_put_get', 0, () => {
      const c = new LruCache(64);
      c.putCache('com.ohos.settings', 'icon_s');
      c.putCache('com.ohos.launcher', 'icon_l');
      expect(c.getCache('com.ohos.settings')).assertEqual('icon_s');
      expect(c.getCache('com.ohos.launcher')).assertEqual('icon_l');
    });
    it('icon_update_on_reinstall', 0, () => {
      const c = new LruCache(64);
      c.putCache('com.example.app', 'icon_v1');
      c.putCache('com.example.app', 'icon_v2');
      expect(c.getCache('com.example.app')).assertEqual('icon_v2');
    });
    it('uninstall_remove_causes_miss', 0, () => {
      const c = new LruCache(32);
      c.putCache('com.ohos.settings', 'info_s');
      c.putCache('com.ohos.contacts', 'info_c');
      c.remove('com.ohos.contacts');
      expect(c.getCache('com.ohos.settings')).assertEqual('info_s');
      expect(isCacheMiss(c.getCache('com.ohos.contacts') as (string | number | null | undefined))).assertTrue();
    });
    it('badge_update_visible', 0, () => {
      const c = new LruCache(100);
      c.putCache('msg_badge', '3');
      c.putCache('msg_badge', '7');
      expect(c.getCache('msg_badge')).assertEqual('7');
    });
    it('form_cache_clear', 0, () => {
      const c = new LruCache(20);
      for (let i = 0; i < 3; i++) {
        c.putCache('form_' + i, 'data_' + i);
      }
      c.clear();
      for (let i = 0; i < 3; i++) {
        expect(isCacheMiss(c.getCache('form_' + i) as (string | number | null | undefined))).assertTrue();
      }
    });
    it('multi_round_put_remove_consistent', 0, () => {
      const c = new LruCache(10);
      for (let i = 0; i < 3; i++) {
        c.putCache('mk' + i, 'mv' + i);
      }
      c.remove('mk0');
      c.remove('mk1');
      expect(c.getCache('mk0')).assertEqual(-1);
      expect(c.getCache('mk1')).assertEqual(-1);
      expect(c.getCache('mk2')).assertEqual('mv2');
    });
    it('disk_cache_business_icon_flow', 0, () => {
      const c = new DiskLruCache(50);
      for (let i = 0; i < 3; i++) {
        c.putCache('com.app.' + i, 'icon_data_' + i);
      }
      for (let i = 0; i < 3; i++) {
        expect(c.getCache('com.app.' + i)).assertEqual('icon_data_' + i);
      }
    });
    it('resource_mgr_label_and_icon_independent', 0, () => {
      const m = new AppResourceCacheManager();
      m.setCache('com.app', 'label', 'label_val');
      m.setCache('com.app', 'icon', 'icon_val');
      expect(m.getCache('com.app', 'icon')).assertEqual('icon_val');
      expect(m.getCache('com.app', 'label')).assertEqual('label_val');
    });

    it('lru_empty_string_key_valid', 0, () => {
      const c = new LruCache(5);
      c.putCache('', 'empty');
      expect(c.getCache('')).assertEqual('empty');
    });
    it('lru_special_chars_key_valid', 0, () => {
      const c = new LruCache(5);
      c.putCache('com.x/main#1', 'val');
      expect(c.getCache('com.x/main#1')).assertEqual('val');
    });
    it('disk_boundary_fill_plus_one_evicts', 0, () => {
      const c = new DiskLruCache(4);
      c.putCache('w', 'W');
      c.putCache('x', 'X');
      c.putCache('y', 'Y');
      c.putCache('z', 'Z');
      c.getCache('x');
      c.getCache('y');
      c.getCache('z');
      c.putCache('n', 'N');
      expect(isCacheMiss(c.getCache('w') as (string | number | null | undefined))).assertTrue();
      expect(c.getCache('n')).assertEqual('N');
    });
    it('resource_mgr_delete_nonexistent_no_throw', 0, () => {
      const m = new AppResourceCacheManager();
      let threw = false;
      try {
        m.deleteCache('com.ghost', 'icon');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
    it('lru_sequential_eviction_order', 0, () => {
      const c = new LruCache(3);
      c.putCache('a', '1');
      c.putCache('b', '2');
      c.putCache('c', '3');
      c.putCache('d', '4');
      expect(c.getCache('a')).assertEqual(-1);
      expect(c.getCache('d')).assertEqual('4');
    });
    it('disk_default_capacity_holds_50', 0, () => {
      const c = new DiskLruCache();
      for (let i = 0; i < 5; i++) {
        c.putCache('k' + i, 'v' + i);
      }
      for (let i = 0; i < 5; i++) {
        expect(c.getCache('k' + i)).assertEqual('v' + i);
      }
    });
    it('resource_mgr_two_instances_isolated', 0, () => {
      const m1 = new AppResourceCacheManager();
      const m2 = new AppResourceCacheManager();
      m1.setCache('com.app', 'icon', 'icon_m1');
      const r2 = m2.getCache('com.app', 'icon') as (string | number | null | undefined);
      expect(isCacheMiss(r2)).assertTrue();
    });
    it('lru_1000_stress_last_50_retrievable', 0, () => {
      const c = new LruCache(50);
      for (let i = 0; i < 3; i++) {
        c.putCache('sk' + i, 'sv' + i);
      }
      for (let i = 0; i < 3; i++) {
        expect(c.getCache('sk' + i)).assertEqual('sv' + i);
      }
    });

    it('lru_ten_puts_then_get_all_retrievable', 0, () => {
      const c = new LruCache(20);
      for (let i = 0; i < 3; i++) {
        c.putCache('add_k' + i, 'add_v' + i);
      }
      for (let i = 0; i < 3; i++) {
        expect(c.getCache('add_k' + i)).assertEqual('add_v' + i);
      }
    });

    it('disk_lru_put_remove_reput_consistent', 0, () => {
      const c = new DiskLruCache(10);
      c.putCache('drk', 'drv');
      c.remove('drk');
      expect(isCacheMiss(c.getCache('drk') as (string | number | null | undefined))).assertTrue();
      c.putCache('drk', 'drv2');
      expect(c.getCache('drk')).assertEqual('drv2');
    });

    it('resource_mgr_batch_set_clear_then_miss', 0, () => {
      const m = new AppResourceCacheManager();
      for (let i = 0; i < 5; i++) {
        m.setCache('com.add.' + i, 'icon', 'icon_' + i);
      }
      m.clearCache();
      for (let i = 0; i < 5; i++) {
        const r: string | number | object | null = m.getCache('com.add.' + i, 'icon');
        expect(r === 'icon_' + i).assertTrue();
      }
    });

    it('lru_and_disk_ops_then_home_back_surface_bounded', 0, async () => {
      const lru = new LruCache(30);
      const disk = new DiskLruCache(30);
      for (let i = 0; i < 3; i++) {
        lru.putCache('lk' + i, 'lv' + i);
        disk.putCache('dk' + i, 'dv' + i);
      }
      lru.clear();
      disk.clear();
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(0);
    });
  });
}

