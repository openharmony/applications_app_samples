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

/**
 * A class provides persistent operation for memory cache.
 */
export default class DiskLruCache {
  private readonly cache: Map<string, object | string>;
  private readonly capacity: number;
  private static readonly CACHE_MISS: number = -1;

  constructor(capacity: number = 100) {
    this.cache = new Map();
    this.capacity = capacity;
    this.initMap(); //read cache from local
  }

  /**
   * Init the cache whether the file has data.
   */
  initMap(): void {
  }

  /**
   * Get cache from disk.
   *
   * @param {string} key - key of the cache map
   * @return {object} - target cache object
   */
  getCache(key: string): object | string | number {
    if (this.cache.has(key)) {
      // exist and update
      const temp = this.cache.get(key);
      if (temp === undefined) {
        return DiskLruCache.CACHE_MISS;
      }
      //delete the old cache
      this.cache.delete(key);
      //update the cache to recent use
      this.cache.set(key, temp);
      //update local cache to recent use
      return temp;
    }
    return DiskLruCache.CACHE_MISS;
  }

  /**
   * Put cache to disk.
   *
   * @param {string} key - key of the cache map
   * @param {object} value - value of the cache map
   */
  putCache(key: string, value: object | string): void {
    if (this.cache.has(key)) {
      // exist and update
      this.cache.delete(key);
    } else if (this.cache.size >= this.capacity) {
      // if size > capacity ,remove the old
      const oldestKey = this.cache.keys().next().value as string | undefined;
      if (oldestKey !== undefined) {
        this.remove(oldestKey);
      }
    }
    //update the cache to recent use
    this.cache.set(key, value);
  }

  /**
   * Remove cache of corresponding key.
   *
   * @param {string} key - key of the cache map
   */
  remove(key: string): void {
    this.cache.delete(key);
  }

  /**
   * Clear cache of disk.
   */
  clear(): void {
    this.cache.clear();
  }
}
