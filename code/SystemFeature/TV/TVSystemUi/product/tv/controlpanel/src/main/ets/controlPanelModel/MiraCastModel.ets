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
 

import { settings } from '@kit.BasicServicesKit';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager';

// MiraCast（无线投屏）状态通过系统 Settings 数据库的 DEVICE_SHARED 域持久化，
// 而非存入 AppStorage，是因为投屏状态需要跨进程（设置应用、投屏服务）共享，
// DEVICE_SHARED 域保证了设备重启后状态依然有效。
export class MiraCastModel {
  setMiraCastStatus(value: string): void {
    // 写入 DEVICE_SHARED 域而非 USER_PROPERTY，确保所有用户账户下的投屏快速启动开关保持一致，
    // 避免多用户场景下因域隔离导致投屏状态不同步。
    let res = settings.setValueSync(
      AbilityManager.getContext(AbilityManager.ABILITY_NAME_CONTROL_PANEL) as Context,
      'settings.wifi.miracast.quickplay',
      value,
      settings.domainName.DEVICE_SHARED
    );
  }

  getMiraCastStatus(): string {
    const miraCastStatus: string =
      settings.getValueSync(
        AbilityManager.getContext(AbilityManager.ABILITY_NAME_CONTROL_PANEL) as Context,
        'settings.wifi.miracast.quickplay',
        '0',
        settings.domainName.DEVICE_SHARED
      );
    return miraCastStatus;
  }
}

// 创建实例
const miraCastModeInstance = new MiraCastModel();

// 导出实例
export default miraCastModeInstance;
