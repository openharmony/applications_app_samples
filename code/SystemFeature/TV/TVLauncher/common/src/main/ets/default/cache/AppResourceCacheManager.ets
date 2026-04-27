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

import { Log } from '../utils/Log';
import LruCache from './LruCache';
import DiskLruCache from './DiskLruCache';

const TAG = 'AppResourceCacheManager';
const KEY_ICON = 'icon';
const KEY_NAME = 'name';
const KEY_LABEL = 'label';

class CacheData {
  public icon: object | string | null = null;
  public name: object | string | null = null;
}

/**
 * A Manager class that provides get/set/clear cache methods for app image data.
 */
export default class AppResourceCacheManager {
  private readonly memoryCache: LruCache;
  private readonly diskCache: DiskLruCache;

  constructor() {
    this.memoryCache = new LruCache();
    this.diskCache = new DiskLruCache();
  }

  /**
   * Get cache from disk or memory.
   *
   * @param {string} cacheKey - cacheKey of the cache map
   * @return {object} - cache get from memory or disk
   */
  getCache(cacheKey: string, cacheType: string): object | string | null {
    const cache = this.getCacheFromMemory(cacheKey, cacheType);
    if (cache == undefined || cache == null || cache == '') {
      if (cacheType === KEY_ICON) {
        const cacheFromDisk = this.getCacheFromDisk(cacheKey);
        if (cacheFromDisk !== null) {
          this.setCacheToMemory(cacheKey, cacheType, cacheFromDisk);
        }
        return cacheFromDisk;
      }
      return null;
    } else {
      return cache;
    }
  }

  /**
   * Set cache to disk or memory.
   *
   * @param {string} cacheKey - cacheKey of the cache map
   * @param {object} value - value of the cache map
   */
  setCache(cacheKey: string, cacheType: string, value: object | string): void {
    Log.showDebug(TAG, `setCache cacheKey: ${cacheKey}, cacheType: ${cacheType}`);
    this.setCacheToMemory(cacheKey, cacheType, value);
    if (cacheType === KEY_ICON) {
      this.setCacheToDisk(cacheKey, value);
    }
  }

  /**
   * Clear cache of both disk and memory.
   */
  clearCache(): void {
    Log.showDebug(TAG, 'clearCache');
    this.memoryCache.clear();
  }

  deleteCache(cacheKey: string, cacheType: string): void {
    this.memoryCache.remove(cacheKey);
    if (cacheType === KEY_ICON) {
      this.diskCache.remove(cacheKey);
    }
  }

  private getCacheFromMemory(cacheKey: string, cacheType: string): object | string | null {
    const cache = this.memoryCache.getCache(cacheKey);
    if (cache == undefined || cache == null || cache === -1 || cache == '') {
      return null;
    }
    const cacheData = cache as CacheData;
    if (cacheType === KEY_ICON) {
      return cacheData.icon;
    }
    if (cacheType === KEY_NAME || cacheType === KEY_LABEL) {
      return cacheData.name;
    }
    return null;
  }

  private setCacheToMemory(cacheKey: string, cacheType: string, value: object | string): void {
    const cachedValue = this.memoryCache.getCache(cacheKey);
    let cache: CacheData | null = null;
    if (cachedValue !== undefined && cachedValue !== null && cachedValue !== -1) {
      cache = cachedValue as CacheData;
    }
    if (cache == undefined || cache == null) {
      cache = new CacheData();
    }
    if (cacheType === KEY_ICON) {
      cache.icon = value;
    } else if (cacheType === KEY_NAME || cacheType === KEY_LABEL) {
      cache.name = value;
    }
    this.memoryCache.putCache(cacheKey, cache);
  }

  private getCacheFromDisk(cacheKey: string): object | string | null {
    const data = this.diskCache.getCache(cacheKey);
    return data === -1 ? null : data as (object | string | null);
  }

  private setCacheToDisk(cacheKey: string, value: object | string): void {
    this.diskCache.putCache(cacheKey, value);
  }
}
