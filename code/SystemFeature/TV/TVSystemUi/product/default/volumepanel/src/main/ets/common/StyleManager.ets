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
import StyleConfiguration, {
  VolumePanelComponentStyle
} from '../../../../../../../features/volumepanelcomponent/src/main/ets/com/ohos/common/StyleConfiguration';

interface configuration {
  width: number
  height: number
}

const TAG = 'VolumePanel-StyleManager';

export default class StyleManager {
  static readonly STANDARD_DISPLAY_WIDTH: number = 2560;
  public static maxWidth: = StyleManager.STANDARD_DISPLAY_WIDTH;
  public static maxWidth: number = StyleManager.STANDARD_DISPLAY_WIDTH;

  static setStyle(): void {
    Log.showDebug(TAG, 'setStyle');

    let config: configuration = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis');
    StyleManager.maxWidth = config.width;

    // Pad、PC Mode
    {
      let style: VolumePanelComponentStyle = StyleConfiguration.getVolumePanelComponentStyle();
      style.volumePanelSliderMarginTop = StyleManager.calcScaleSizePx(40);
      style.volumePanSliderWidth = px2vp(StyleManager.calcScaleSize(8)).toString() + 'vp';
      style.volumePanSliderHeight = StyleManager.calcScaleSizePx(320);
      style.volumePanelSliderMarginBottom = StyleManager.calcScaleSizePx(40);
      style.volumePanelMutBtnIconSize = StyleManager.calcScaleSizePx(48);
      style.volumePanelMutBtnIconMarginBottom = StyleManager.calcScaleSizePx(24);
      style.volumePanelMuteBtnHeight = StyleManager.calcScaleSizePx(72);
      style.volumePanelSettingIconSize = StyleManager.calcScaleSizePx(48);
      style.volumePanelSettingButtonSize = StyleManager.calcScaleSizePx(96);
      style.volumePanelBackground = '#99FFFFFF';
      style.volumePanelSliderBlockColor = '#FFFFFFFF';
      style.volumePanelDividerHeight = StyleManager.calcScaleSizePx(1);
      style.volumePanelBorderRadius = StyleManager.calcScaleSizePx(48);
      style.volumeDividerWidth = StyleManager.calcScaleSizePx(60);
      style.volumeSliderTrackColor = '#FFAEE6E6';
      style.volumeSelectedColor = '#FF007DFF';
      style.volumeButtonBackgroundColor = '#00000000';
      style.volumePanelRingModeColor = '#FF007DFF';
      style.volumePanelDividerColor = '#FF9BCECE';
      style.volumePanelSettingColor = '#FF4D6666';
    }

  }

  static number2px(n: number): string {
    return n.toString() + 'px';
  }

  static calcScaleSize(n: number): number {
    return n * StyleManager.maxWidth / StyleManager.STANDARD_DISPLAY_WIDTH;
  }

  static calcScaleSizePx(n: number): string {
    return StyleManager.number2px(StyleManager.calcScaleSize(n));
  }
}