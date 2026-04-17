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
 * A class provides memory cache operation.
 */
export default class LruCache {
  private readonly cache: Map<string, object | string>;
  private readonly capacity: number;
  private static readonly CACHE_MISS: number = -1;

  constructor(capacity: number = 100) {
    this.cache = new Map();
    this.capacity = capacity; //the capacity of cache
  }

  /**
   * Get cache from memory.
   *
   * @param {string} key - key of the cache map
   * @return {any} - cache from memory
   */
  getCache(key: string): object | string | number {
    if (this.cache.has(key)) {
      // exist and update
      const temp = this.cache.get(key);
      if (temp === undefined) {
        return LruCache.CACHE_MISS;
      }
      //delete the old cache
      this.cache.delete(key);
      //update the cache to recent use
      this.cache.set(key, temp);
      return temp;
    }
    return LruCache.CACHE_MISS;
  }

  /**
   * Put cache to disk.
   *
   * @param {string} key - key of the cache map
   * @param {any} value - value of the cache map
   */
  putCache(key: string, value: object | string): void {
    if (this.cache.has(key)) {
      // exist and update
      this.cache.delete(key);
    } else if (this.cache.size >= this.capacity) {
      // if size > capacity ,remove the old
      const oldestKey = this.cache.keys().next().value as string | undefined;
      if (oldestKey !== undefined) {
        this.cache.delete(oldestKey);
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
   * Clear cache of memory.
   */
  clear(): void {
    this.cache.clear();
  }
}
