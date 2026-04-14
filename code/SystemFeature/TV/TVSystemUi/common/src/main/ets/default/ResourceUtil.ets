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
 
import AbilityManager from './abilitymanager/AbilityManager'

/**
 * Resource util
 */
export class ResourceUtil {
  private resMgr;

  /**
   * Initialize ResourceManager
   */
  async initResourceManager(abilityName?: string): Promise<void> {
    if (!this.resMgr) {

      let context;
      if(abilityName === AbilityManager.ABILITY_NAME_NOTIFICATION_MANAGEMENT) {
        context = AbilityManager.getAbilityContext(abilityName);
      } else {
        context = AbilityManager.getContext(abilityName);
      }
      this.resMgr = await context.resourceManager;
    }
    return this.resMgr;
  }

  /**
   * Get string value from NormalResource instance
   *
   * @param resource - NormalResource instance
   */
  async getString(resource): Promise<string> {
    return await this.resMgr.getString(resource.id);
  }

  /**
   * Get direction value from NormalResource instance
   *
   * @param resource - NormalResource instance
   */
  async getConfiguration(): Promise<string> {
    return await this.resMgr.getConfiguration();
  }
}

let resourceUtil = new ResourceUtil();

export default resourceUtil as ResourceUtil;