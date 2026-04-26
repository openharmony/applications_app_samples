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
 

import VolumePanelComponent from './VolumePanelComponent'
import StyleManager from '../common/StyleManager'
import { GlobalThis, Len } from '@ohos/common/src/main/ets/util/GlobalThis'
import { r_vp } from '../common/AutoSize'
import Log from '@ohos/common/src/main/ets/default/Log'
import CommonStyleManager from '@ohos/common/src/main/ets/default/CommonStyleManager'
import AbilityManager, { displayAttribute } from '@ohos/common/src/main/ets/default/abilitymanager/AbilityManager'
import { Rect } from '@ohos/common/src/main/ets/default/Constants'
import WindowManager,{WindowType} from '@ohos/common/src/main/ets/default/WindowManager'

const TAG = 'VolumePanel-Index'

@Entry
@Component
struct Index {
  private screenWidth: number = 0;
  private screenHeight: number = 0;

  aboutToAppear() {
    this.screenWidth = GlobalThis.getLength(Len.Width)
    this.screenHeight = GlobalThis.getLength(Len.Height)
    Log.showInfo(TAG, `screenWidth:${this.screenWidth}---screenHeight:${this.screenHeight}`)
    const rawDis = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis');
    if (rawDis === undefined || typeof rawDis !== 'object') {
      Log.showError(TAG, 'missing volume panel display config');
      return;
    }
    const configInfo: displayAttribute = rawDis as displayAttribute;
    let volumeRect: Rect;
    if (configInfo.width > configInfo.height) { // Pad、PC Mode
      volumeRect = {
        left: this.screenWidth * 0.875,
        // top: this.screenHeight * 0.173,
        // width: this.screenWidth * 0.075,
        // height: this.screenHeight * 0.654
        top: this.screenHeight * 0.5 - this.screenHeight * 0.5 * 0.5,
        width: r_vp(100),
        height: this.screenHeight * 0.5
      };
    } else { // Phone Mode
      const realWidth = 80;
      const realHeight = 310;
      volumeRect = {
        left: configInfo.width - vp2px(16) - vp2px(realWidth),
        top: configInfo.height * 0.1,
        width: realWidth,
        height: realHeight
      };
    }
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'rect', volumeRect);
    WindowManager.resetSizeWindow(WindowType.VOLUME_PANEL, volumeRect);
    Log.showInfo(TAG, `获取屏幕的宽高2:${JSON.stringify(volumeRect)}`);
    CommonStyleManager.setAbilityPageName(TAG)
    Log.showDebug(TAG, `configInfo Start, configInfo ${JSON.stringify(configInfo)}`);
    if (configInfo.width > configInfo.height) { // Pad、PC Mode
      StyleManager.setStyle();
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  build() {
    Column() {
      VolumePanelComponent()
    }
    .width('100%')
    .height('100%')
  }
}
