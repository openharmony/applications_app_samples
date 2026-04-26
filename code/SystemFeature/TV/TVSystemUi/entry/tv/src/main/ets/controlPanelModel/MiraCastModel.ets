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
import AbilityManager from '@ohos/common/src/main/ets/default/abilitymanager/AbilityManager';

export class MiraCastModel {
  setMiraCastStatus(value: string): void {
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
