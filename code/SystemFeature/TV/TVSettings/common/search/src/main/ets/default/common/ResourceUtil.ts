/**
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import ConfigData from '../../../../../../utils/src/main/ets/default/baseUtil/ConfigData';
//import ResMgr from '@ohos.resourceManager';
import Log from '../../../../../../utils/src/main/ets/default/baseUtil/LogDecorator';

/**
 * Resource util
 */
export class ResourceUtil {
  private resMgr: any;

  /**
   * Initialize ResourceManager
   */
  @Log
  async initResourceManager(): Promise<void> {
    if (!this.resMgr) {
      this.resMgr = await  globalThis.settingsAbilityContext.resourceManager;
    }
  }

  /**
   * Get string value from NormalResource instance
   *
   * @param resource - NormalResource instance
   */
  @Log
  async getString(resource): Promise<string> {
    await this.initResourceManager();
    return await this.resMgr.getString(resource.id);
  }

}

let resourceUtil = new ResourceUtil();
export default resourceUtil as ResourceUtil;
