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
 

import { Want } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import { ServiceExtensionAbility } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Rect } from '@ohos/common/src/main/ets/default/Constants';
import Log from '@ohos/common/src/main/ets/default/Log';
import WindowManager,{WindowType} from '@ohos/common/src/main/ets/default/WindowManager';
import AbilityManager, {
  displayAttribute,
  type AbilityData
} from '@ohos/common/src/main/ets/default/abilitymanager/AbilityManager';
import VolumeWindowController from '../common/VolumeWindowController';

const TAG = 'VolumePanel_ServiceExtAbility';

//ServiceExtensionAbility是一种专门用于后台服务的ExtensionAbility类型，它不能直接显示在界面上，只能被拉起运行。
class ServiceExtAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    Log.showInfo(TAG, `onCreate, want:${want.abilityName}`);
    // 'SystemUi_VolumePanel_Context对应this.context'
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_VOLUME_PANEL, this.context);
    let dis: display.Display | null = null;
    try {
      dis = display.getDefaultDisplaySync();
      let volumeRect: Rect = {
        left: 0,
        top: 0,
        width: dis.width,
        height: dis.height,
      };
      const disAttrs: displayAttribute = {
        width: dis.width,
        height: dis.height,
      };
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis', disAttrs as AbilityData);
      WindowManager.createWindow(this.context, WindowType.VOLUME_PANEL, volumeRect, 'pages/index')
        .then((win) => {
          win.setWindowBackgroundColor('#00000000') // 放这里可以生效
          Log.showInfo(TAG, 'onCreate, createWindow callback');
          VolumeWindowController.getInstance().setWindowHandle(win);
        })
        .catch((err: BusinessError) => Log.showError(TAG, `Can't create window, err:${JSON.stringify(err)}`));
    } catch (exception) {
      Log.showError(TAG, `Failed to obtain the default display object. Code: ${JSON.stringify(exception)}`)
    }
  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
