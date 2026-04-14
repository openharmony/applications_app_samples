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
 

import { ServiceExtensionAbility, Want } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager';
import VolumeWindowController from '../../../../../../../features/volumepanelcomponent/src/main/ets/com/ohos/common/VolumeWindowController';

const TAG = 'VolumePanel_ServiceExtAbility';
const realWidth = 48;
const realHeight = 284;

class ServiceExtAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    Log.showInfo(TAG, `onCreate, want:${want.abilityName}`);
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_VOLUME_PANEL, this.context);
    display.getDefaultDisplay().then((dis) => {
      let volumeRect = {
        left: 0,
        top: 0,
        width: dis.width,
        height: dis.height,
      };

      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis', {
        width: dis.width,
        height: dis.height,
      });
      WindowManager.createWindow(this.context, WindowType.VOLUME_PANEL, volumeRect, 'pages/index').then((win) => {
        Log.showInfo(TAG, 'onCreate, createWindow callback');
        VolumeWindowController.getInstance().setWindowHandle(win);
      })
        .catch((err) => Log.showError(TAG, `Can't create window, err:${JSON.stringify(err)}`));
    }).then(() => {
    }).catch((err) => {
    });

    display.on('change', (id) => {
      let volumeRect
      Log.showInfo(TAG, 'display change, data: ' + JSON.stringify(id))
      display.getDefaultDisplay().then((configInfo) => {
        volumeRect = {
          left: configInfo.width - vp2px(16) - vp2px(realWidth),
          top: (configInfo.height - vp2px(realHeight) ) / 2,
          width: vp2px(realWidth) ,
          height: vp2px(realHeight)
        };
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'rect', volumeRect);
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis', {
          width: configInfo.width,
          height: configInfo.height,
        });
      }).then(() => {
        WindowManager.resetSizeWindow(WindowType.VOLUME_PANEL, volumeRect);
      }).catch((err) => {
      });
    })

  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
