/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { adminManager, deviceControl, EnterpriseAdminExtensionAbility, restrictions } from '@kit.MDMKit';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { CommonEventValue } from '../utils/CommonEventValue';
import { CommonEventManagerHelper } from '../utils/CommonEventManagerHelper';
import Logger from '../common/Logger';
import { common, Want } from '@kit.AbilityKit';
import { DataPreferencesHelper } from '../utils/DataPreferencesHelper';


export default class EnterpriseAdminAbility extends EnterpriseAdminExtensionAbility {
  private commonEventManagerHelper = new CommonEventManagerHelper();
  private wantTemp: Want = {
    bundleName: 'com.example.mdmsample',
    abilityName: 'EnterpriseAdminAbility',
  };
  private context = getContext(this) as common.UIAbilityContext;
  private dataPreferenceHelper: DataPreferencesHelper | null = null;
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      CommonEventValue.EVENT_DISABLE_WIFI,
      CommonEventValue.EVENT_ENABLE_WIFI,
      CommonEventValue.EVENT_QUERY_WIFI_STATUS,
      CommonEventValue.EVENT_DISABLE_ADMIN,
      CommonEventValue.EVENT_REBOOT,
    ],
  };

  onStart(): void {
    if (this.dataPreferenceHelper == null) {
      this.dataPreferenceHelper = new DataPreferencesHelper(this.context.getApplicationContext());
    }
    this.commonEventManagerHelper.createSubscriber(this.subscribeInfo, (error, data) => {
      this.handleEvent(data.event);
    });
  }

  private handleEvent(event: string) {
    switch (event) {
      case CommonEventValue.EVENT_DISABLE_WIFI:
        this.setWifi(true);
        break;
      case CommonEventValue.EVENT_ENABLE_WIFI:
        this.setWifi(false);
        break;
      case CommonEventValue.EVENT_QUERY_WIFI_STATUS:
        this.getWifiStatus();
        break;
      case CommonEventValue.EVENT_DISABLE_ADMIN:
        this.disableAdmin();
        break;
      case CommonEventValue.EVENT_REBOOT:
        this.reboot();
        break;
    }
  }

  private async setWifi(isDisallow: boolean) {
    try {
      restrictions.setDisallowedPolicy(this.wantTemp, 'wifi', isDisallow);
      this.sendResult(CommonEventValue.STATUS_RESULT, isDisallow ?
        this.getStringByResource($r('app.string.disable_wifi_suc')) :
        this.getStringByResource($r('app.string.enable_wifi_suc')));
      this.getWifiStatus();
    } catch (err) {
      this.sendResult(CommonEventValue.STATUS_RESULT, isDisallow ?
        this.getStringByResource($r('app.string.disable_wifi_fail')) :
        this.getStringByResource($r('app.string.enable_wifi_fail')));
    }
  }

  private async getWifiStatus() {
    try {
      let ret = restrictions.getDisallowedPolicy(this.wantTemp, 'wifi');
      this.sendResult(CommonEventValue.STATUS_WIFI, ret ?
        this.getStringByResource($r('app.string.disabled')) :
        this.getStringByResource($r('app.string.enabled')));
    } catch (err) {
      this.sendResult(CommonEventValue.STATUS_WIFI, this.getStringByResource($r('app.string.get_wifi_status_failed')));
    }
  }

  private async reboot() {
    try {
      deviceControl.operateDevice(this.wantTemp, 'reboot');
    } catch (err) {
      this.sendResult(CommonEventValue.STATUS_RESULT, this.getStringByResource($r('app.string.reboot_fail')));
    }
  }

  private async disableAdmin() {
    await adminManager.disableAdmin(this.wantTemp).then(() => {
      this.sendResult(CommonEventValue.STATUS_RESULT, this.getStringByResource($r('app.string.deactivate_suc')));
    }).catch(() => {
      this.sendResult(CommonEventValue.STATUS_RESULT, this.getStringByResource($r('app.string.deactivate_fail')));
    })
  }

  onAppStart(bundleName: string): void {
    Logger.error(`onAppStart bundleName:` + bundleName);
  }

  private getStringByResource(res: Resource): string {
    return this.context.resourceManager.getStringSync(res);
  }

  private async sendResult(code: number, result: string) {
    commonEventManager.publish(CommonEventValue.EVENT_RESULT, {
      code: code,
      data: result
    }, (err: BusinessError) => {
      if (err) {
        Logger.error(`PublishCallBack err = ${JSON.stringify(err)}`);
      } else {
        Logger.info(`Publish success`);
      }
    });
  }

  // 设备管理器应用激活回调方法，应用可在此回调函数中进行初始化策略设置。
  onAdminEnabled() {
    console.info('onAdminEnabled');
    this.sendResult(CommonEventValue.STATUS_ACTIVE, this.getStringByResource($r('app.string.activated')));
    this.dataPreferenceHelper?.save(DataPreferencesHelper.EXTRA_ACTIVE_STATUS,
      this.getStringByResource($r('app.string.activated')));
  }

  // 设备管理器应用去激活回调方法，应用可在此回调函数中通知企业管理员设备已脱管。
  onAdminDisabled() {
    console.info('onAdminDisabled');
    this.sendResult(CommonEventValue.STATUS_ACTIVE, this.getStringByResource($r('app.string.no_active')));
    this.dataPreferenceHelper?.save(DataPreferencesHelper.EXTRA_ACTIVE_STATUS,
      this.getStringByResource($r('app.string.no_active')));
  }

  // 应用安装回调方法，应用可在此回调函数中进行事件上报，通知企业管理员。
  onBundleAdded(bundleName: string) {
    console.info('EnterpriseAdminAbility onBundleAdded bundleName:' + bundleName);
  }

  // 应用卸载回调方法，应用可在此回调函数中进行事件上报，通知企业管理员。
  onBundleRemoved(bundleName: string) {
    console.info('EnterpriseAdminAbility onBundleRemoved bundleName' + bundleName);
  }
};