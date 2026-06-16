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
import { application } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { Logger } from './Logger';

const TAG = 'AppNameCacheManager';

// app名称缓存管理器
export class AppNameCacheManager {
  private static instance: AppNameCacheManager;
  private cache = new Map<string, string>();
  private readonly CACHE_GROUP = 'app_names';

  static getInstance(): AppNameCacheManager {
    if (!AppNameCacheManager.instance) {
      AppNameCacheManager.instance = new AppNameCacheManager();
    }
    return AppNameCacheManager.instance;
  }

  getStore() {
    return preferences.getPreferences(getContext(), this.CACHE_GROUP);
  }

  async get(bundleName: string, moduleName: string, abilityName: string, labelId: number): Promise<string> {
    const key = this.generateCacheKey(bundleName, abilityName, labelId);
    // 获取内存
    if (this.cache.has(key)) {
      const appName = this.cache.get(key);
      if (appName) {
        return appName;
      }
    }

    // 获取硬盘
    const appStore = await this.getStore();
    const appName: string = appStore.getSync(key, '') as string;
    if (appName.length) {
      this.cache.set(key, appName);
      return appName;
    }

    // 接口获取
    try {
      const context = await application.createModuleContext(globalThis.context, bundleName, moduleName);
      const appName = context.resourceManager.getStringSync(labelId);
      setTimeout(() => {
        this.cache.set(key, appName);
        this.persistToDisk(key, appName);
      }, 0);
      return appName;
    } catch (err) {
      return '';
    }
  }

  async persistToDisk(key: string, data: string) {
    try {
      const appStore = await this.getStore();
      await appStore.put(key, data);
      await appStore.flush();
    } catch (err) {
      Logger.error(TAG, 'persistToDisk err ' + JSON.stringify(err));
    }
  }

  // 生成缓存键
  private generateCacheKey(bundleName: string, abilityName: string, labelId: number): string {
    return `${bundleName}#${abilityName}#${labelId}`;
  }
}
