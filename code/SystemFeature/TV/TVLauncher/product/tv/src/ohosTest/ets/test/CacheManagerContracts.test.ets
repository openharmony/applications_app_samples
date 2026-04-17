/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect } from '@ohos/hypium';
import AppResourceCacheManager from '../../../../../../common/src/main/ets/default/cache/AppResourceCacheManager';
import DiskLruCache from '../../../../../../common/src/main/ets/default/cache/DiskLruCache';

export default function cacheManagerContractsTest() {
  describe('CacheManagerContracts_Test', () => {
    it('disk_cache_should_return_minus_one_for_missing_key', 0, () => {
      const cache = new DiskLruCache(3);
      expect(cache.getCache('missing')).assertEqual(-1);
    });

    it('disk_cache_should_store_and_read_latest_value', 0, () => {
      const cache = new DiskLruCache(3);
      cache.putCache('icon_a', 'A');
      cache.putCache('icon_a', 'B');
      expect(cache.getCache('icon_a')).assertEqual('B');
    });

    it('disk_cache_should_evict_oldest_entry_when_capacity_reached', 0, () => {
      const cache = new DiskLruCache(2);
      cache.putCache('a', 'A');
      cache.putCache('b', 'B');
      cache.putCache('c', 'C');
      expect(cache.getCache('a')).assertEqual(-1);
      expect(cache.getCache('b')).assertEqual('B');
      expect(cache.getCache('c')).assertEqual('C');
    });

    it('disk_cache_get_should_promote_recent_entry', 0, () => {
      const cache = new DiskLruCache(2);
      cache.putCache('a', 'A');
      cache.putCache('b', 'B');
      expect(cache.getCache('a')).assertEqual('A');
      cache.putCache('c', 'C');
      expect(cache.getCache('b')).assertEqual(-1);
      expect(cache.getCache('a')).assertEqual('A');
    });

    it('disk_cache_clear_should_remove_all_entries', 0, () => {
      const cache = new DiskLruCache(4);
      cache.putCache('a', 'A');
      cache.putCache('b', 'B');
      cache.clear();
      expect(cache.getCache('a')).assertEqual(-1);
      expect(cache.getCache('b')).assertEqual(-1);
    });

    it('app_resource_cache_should_store_memory_only_non_icon_entry', 0, () => {
      const manager = new AppResourceCacheManager();
      manager.setCache('bundle_a', 'label', 'Launcher');
      expect(manager.getCache('bundle_a', 'label')).assertEqual('Launcher');
      expect(manager.getCache('bundle_a', 'icon') === null).assertTrue();
    });

    it('app_resource_cache_should_store_icon_entry_and_allow_retrieval', 0, () => {
      const manager = new AppResourceCacheManager();
      manager.setCache('bundle_icon', 'icon', 'icon-data');
      expect(manager.getCache('bundle_icon', 'icon')).assertEqual('icon-data');
    });

    it('app_resource_cache_delete_should_remove_memory_and_disk_icon_entry', 0, () => {
      const manager = new AppResourceCacheManager();
      manager.setCache('bundle_icon_del', 'icon', 'icon-del');
      manager.deleteCache('bundle_icon_del', 'icon');
      expect(manager.getCache('bundle_icon_del', 'icon') === null).assertTrue();
    });

    it('app_resource_cache_clear_should_reset_memory_entries', 0, () => {
      const manager = new AppResourceCacheManager();
      manager.setCache('bundle_label', 'label', 'Settings');
      manager.clearCache();
      expect(manager.getCache('bundle_label', 'label') === null).assertTrue();
    });

    it('app_resource_cache_should_keep_multiple_cache_types_under_same_key', 0, () => {
      const manager = new AppResourceCacheManager();
      manager.setCache('bundle_multi', 'label', 'Gallery');
      manager.setCache('bundle_multi', 'icon', 'gallery-icon');
      expect(manager.getCache('bundle_multi', 'label')).assertEqual('Gallery');
      expect(manager.getCache('bundle_multi', 'icon')).assertEqual('gallery-icon');
    });
  });
}
