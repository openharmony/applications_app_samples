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
 
import Log from '../../../../../../../common/src/main/ets/default/Log'
import CommonStyleManager from '../../../../../../../common/src/main/ets/default/CommonStyleManager'
import VolumePanelComponent from '../../../../../../../features/volumepanelcomponent/src/main/ets/com/ohos/pages/VolumePanelComponent'
import AbilityManager,{ displayAttribute, rectAttribute } from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager'
import StyleManager from '../common/StyleManager'
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager'

const TAG = 'VolumePanel-Index'

@Entry
@Component
struct Index {
  // aboutToAppear 中根据屏幕宽高比区分 Pad/PC 模式和 Phone 模式来计算音量面板位置，
  // Phone 模式将面板固定在屏幕高度 10% 处而非垂直居中，是为了避免遮挡屏幕中央的内容区域，
  // 让用户在调节音量时仍能看到正在播放的视频或当前页面主体内容。
  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
    let configInfo: displayAttribute = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis');
    let volumeRect: rectAttribute;
    if (configInfo.width > configInfo.height) { // Pad、PC Mode
      const realWidth = 48;
      const realHeight = 284;
      volumeRect = {
        left: configInfo.width - vp2px(16) - vp2px(realWidth),
        top: (configInfo.height - vp2px(realHeight) ) / 2,
        width: vp2px(realWidth) ,
        height: vp2px(realHeight)
      };
    } else { // Phone Mode
      const realWidth = 48;
      const realHeight = 284;
      volumeRect = {
        left: configInfo.width - vp2px(16) - vp2px(realWidth),
        top: configInfo.height * 0.1,
        width: vp2px(realWidth) ,
        height: vp2px(realHeight)
      };
    }
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'rect', volumeRect);
    WindowManager.resetSizeWindow(WindowType.VOLUME_PANEL, volumeRect);

    // 将应用背景设为全透明而非依赖窗口透明，是因为音量面板组件本身带有半透明圆角背景，
    // 若应用层有不透明背景会出现白色方块遮挡底层内容，影响沉浸式体验。
    setAppBgColor('#00000000');
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
