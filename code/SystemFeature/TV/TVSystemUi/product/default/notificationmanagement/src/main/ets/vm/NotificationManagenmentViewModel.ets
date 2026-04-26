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
 

import Log from '../../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager';
import BundleResourceModel
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/bundleResourceModel';
import { display } from '@kit.ArkUI';
import NoDisturbComponentViewModel
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/vm/noDisturbComponentViewModel';
import { router as Router } from '@kit.ArkUI';

const TAG = 'NotificationManagement-NotificationManagenmentViewModel';

export default class NotificationManagenmentViewModel extends NoDisturbComponentViewModel {
  public isPhone = false;

  viewModelInit(): void {
    Log.showDebug(TAG, 'ViewModelInit');
    super.viewModelInit();
    this.migrateTo();
    this.judgeDeviceType();
  }

  refreshNoDisturbState(): void {
    super.viewModelInit();
  }

  // migrateTo 在 ViewModel 初始化时检查启动 Want 中是否携带 migrateUri 和 migrateBundle，
  // 这是为了支持从其他应用（如通知点击）直接跳转到某个应用的通知设置子页面，
  // 检查完后立即清除 Want，防止页面重建时重复触发跳转。
  migrateTo(): void {
    Log.showDebug(TAG, 'MigrateTo');
    //get the want
    let want = globalThis[AbilityManager.ABILITY_NAME_NOTIFICATION_MANAGEMENT + '_want'];
    Log.showDebug(TAG, `aboutToAppear want:${JSON.stringify(want)}`);
    if (!want || !want.parameters.migrateUri || !want.parameters.migrateBundle) {
      return;
    }
    let migrateUri = want.parameters.migrateUri;
    let bundleName = want.parameters.migrateBundle;
    Log.showDebug(TAG, `aboutToAppear migrateUri:${migrateUri} migrateBundle:${JSON.stringify(bundleName)}`);

    let dataModel: BundleResourceModel = new BundleResourceModel();
    void dataModel.getBundleInfo(bundleName, (bundleInfo) => {
      Log.showInfo(TAG, `MigrateTo bundleInfo:${JSON.stringify(bundleInfo)}`);
      //to next page
      Router.push({
        uri: migrateUri, params: bundleInfo
      });
    });
    //clear want
    globalThis[AbilityManager.ABILITY_NAME_NOTIFICATION_MANAGEMENT + '_want'] = null;
  }

  // 通过比较屏幕宽高判断设备形态而非读取设备类型常量，
  // 是因为平板横屏与手机竖屏的通知管理页面布局差异主要由宽高比决定，
  // 此方法比 deviceInfo.deviceType 更能准确反映当前实际显示模式。
  async judgeDeviceType() {
    Log.showDebug(TAG, 'judgeDeviceType');
    let configInfo = await display.getDefaultDisplay();
    Log.showDebug(TAG, `judgeDeviceType, configInfo: ${configInfo} `);
    if (configInfo.width < configInfo.height) {
      this.isPhone = true;
    }
  }
}

export class AppInfo {
  public appIcon: string = '';
  public appTitle: string = '';
  public appSummary: string = '';
  public appArrow: string = '';
  public appUri: string = '';
  public appBundleName: string = '';
  public appUid: number = 0;
  public slotSettingUrl: string = '';
}

export class SlotInfo {
  public type: string = '';
  private sound: string = '';
  private level: number = 0;
}
