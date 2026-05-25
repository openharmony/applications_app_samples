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
import preferences from '@ohos.data.preferences';

interface CacheMetadata {
  data: string; // Base64编码的图标
  size: number; // 数据大小
  timestamp: number; // 缓存时间
  accessCount: number; // 访问次数
}

const TAG = 'DiskCache';

// 磁盘缓存实现
export class DiskCache {
  private readonly CACHE_GROUP = 'app_icons';
  private readonly MAX_SIZE = 1024 * 1024 * 20; // 20MB

  // 存储结构
  private cacheMetadata = new Map<string, CacheMetadata>();

  getStore() {
    return preferences.getPreferences(getContext(), this.CACHE_GROUP);
  }

  async get(key: string): Promise<string | null> {
    const appStore = await this.getStore();
    const item: CacheMetadata = appStore.getSync(key, '') as CacheMetadata;

    if (!item) {
      return null;
    }
    // 更新访问信息
    item.accessCount++;
    item.timestamp = Date.now();

    // 获取Base64数据
    const base64Data = item.data;

    return base64Data;
  }

  async set(key: string, base64Data: string): Promise<void> {
    const size = base64Data.length * 0.75; // 近似字节数

    // 检查容量
    await this.ensureCapacity(size);
    // 保存
    const data: CacheMetadata = {
      data: base64Data,
      size,
      timestamp: Date.now(),
      accessCount: 0
    };
    this.cacheMetadata.set(key, data);
    // 异步持久化
    await this.persistToDisk(key, data);
  }

  async persistToDisk(key: string, data: CacheMetadata) {
    try {
      const appStore = await this.getStore();
      await appStore.put(key, data);
      await appStore.flush();
    } catch (err) {
      console.error(TAG, 'persistToDisk err ' + JSON.stringify(err));
    }
  }

  private async ensureCapacity(neededSize: number): Promise<void> {
    let totalSize = Array.from(this.cacheMetadata.values())
      .reduce((sum, item) => sum + item.size, 0);

    // 如果空间不足，清理最不常用的
    while (totalSize + neededSize > this.MAX_SIZE && this.cacheMetadata.size > 0) {
      // 找到最不常用的（访问最少、最旧）
      let lruKey = '';
      let minScore = Infinity;

      for (const entry of this.cacheMetadata.entries()) {
        // 评分：访问次数少、时间久远的分高
        const score = (Date.now() - entry[1].timestamp) / (entry[1].accessCount + 1);
        if (score < minScore) {
          minScore = score;
          lruKey = entry[0];
        }
      }

      if (lruKey) {
        const removed = this.cacheMetadata.get(lruKey)!;
        this.cacheMetadata.delete(lruKey);
        totalSize -= removed.size;
      }
    }
  }
}