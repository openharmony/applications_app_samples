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

import Log from '../../../../../../utils/src/main/ets/default/baseUtil/LogDecorator';

interface SearchTextResource {
  id: number;
}

interface ResourceManagerLike {
  getString(resourceId: number): Promise<string>;
}

interface SettingsAbilityContextLike {
  resourceManager: ResourceManagerLike;
}

/**
 * Resource util
 */
export class ResourceUtil {
  private resMgr: ResourceManagerLike | null = null;

  /**
   * Initialize ResourceManager
   */
  @Log
  async initResourceManager(): Promise<void> {
    if (!this.resMgr) {
      this.resMgr = (globalThis.settingsAbilityContext as SettingsAbilityContextLike).resourceManager;
    }
  }

  /**
   * Get string value from NormalResource instance
   *
   * @param resource - NormalResource instance
   */
  @Log
  async getString(resource: SearchTextResource): Promise<string> {
    await this.initResourceManager();
    return await this.resMgr!.getString(resource.id);
  }

}

let resourceUtil = new ResourceUtil();
export default resourceUtil as ResourceUtil;
