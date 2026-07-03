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
const TAG = 'MemoryCache';

// 内存缓存实现
export class MemoryCache {
  private cache = new Map<string, PixelMap>();
  private accessOrder: string[] = []; // LRU实现
  private maxSize: number = 50;

  get(key: string): PixelMap | undefined {
    const icon = this.cache.get(key);
    if (icon) {
      // 更新访问顺序
      this.updateAccessOrder(key);
    }
    return icon;
  }

  set(key: string, icon: PixelMap): void {
    // LRU淘汰策略
    if (this.cache.size >= this.maxSize) {
      const oldestKey = this.accessOrder.shift();
      if (oldestKey) {
        this.cache.delete(oldestKey);
      }
    }
    this.cache.set(key, icon);
    this.updateAccessOrder(key);
  }

  private updateAccessOrder(key: string): void {
    // 移除旧位置
    const index = this.accessOrder.indexOf(key);
    if (index > -1) {
      this.accessOrder.splice(index, 1);
    }
    // 添加到末尾（最新）
    this.accessOrder.push(key);
  }
}