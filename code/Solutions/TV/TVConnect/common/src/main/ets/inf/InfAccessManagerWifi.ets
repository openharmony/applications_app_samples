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

import wifiManager from '@ohos.wifiManager';
import { common, Want } from '@kit.AbilityKit';
import { InfAccessManager } from './InfAccessManager';
import { PermissionsClass } from '../utils/PermissionUtil';
import { Logger } from '../utils/Logger';
import { getProtocolCode, ProtocolType } from './TypeEnum';

const WIFI_TAG = 'IotAccessManagerWifi';

export class InfAccessManagerWifi implements InfAccessManager {
  async isEnable(): Promise<boolean> {
    let isWifiActive = wifiManager.isWifiActive();
    Logger.debug(WIFI_TAG, `isWifiActive ${isWifiActive}`);
    return isWifiActive;
  }

  async applyAccess(context: Context): Promise<boolean> {
    Logger.debug(WIFI_TAG, `applyAccess start`);
    try {
      // wifiManager.enableWifi只能在full sdk使用，app使用跳转系统设置wifi页面的方式开启wifi开关
      let abilityContext = context as common.UIAbilityContext;
      let want: Want = {
        bundleName: 'com.huawei.hmos.settings',
        abilityName: 'com.huawei.hmos.settings.MainAbility',
        uri: 'wifi_entry',
      };
      await abilityContext.startAbilityForResult(want);
      let isWifiActive = wifiManager.isWifiActive();
      Logger.debug(WIFI_TAG, `startAbilityForResult isWifiActive ${isWifiActive}`);
      return isWifiActive;
    } catch (error) {
      Logger.error(WIFI_TAG, `applyAccess error ${error?.message}`);
      return false;
    }
  }

  getAccessCode(): string {
    return getProtocolCode(ProtocolType.WIFI);
  }

  getAccessName(): Resource {
    return $r('app.string.access_name_wifi');
  }

  getUserAuthPermission(): PermissionsClass[] {
    return [];
  }
}