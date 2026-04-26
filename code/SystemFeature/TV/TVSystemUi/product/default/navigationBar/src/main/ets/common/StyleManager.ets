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
import StyleConfiguration from './StyleConfiguration';

const TAG = 'StatusBar-StyleManager';

export default class StyleManager {
  public static readonly PAD_STANDARD_DISPLAY_WIDTH = 1280;
  public static readonly PAD_STANDARD_DISPLAY_HEIGHT = 800;
  public static readonly PHONE_STANDARD_DISPLAY_WIDTH = 720;
  public static readonly PHONE_STANDARD_DISPLAY_HEIGHT = 1280;
  public static maxWidth: number = StyleManager.PAD_STANDARD_DISPLAY_WIDTH;
  public static rumMode = 'pad';

  static setPadStyle(): void {
    Log.showDebug(TAG, 'setPadStyle');

    let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
    StyleManager.maxWidth = config.maxWidth;
    StyleManager.rumMode = 'pad';

    // keyButton
    {
      let style = StyleConfiguration.getKeyButtonStyle();
      style.buttonWidth = StyleManager.calcScaleSizePx(88);
      style.buttonHeight = StyleManager.calcScaleSizePx(44);
      style.buttonBorderRadius = StyleManager.calcScaleSizePx(22);
      style.buttonIconWidth = StyleManager.calcScaleSizePx(15);
      style.buttonIconHeight = StyleManager.calcScaleSizePx(15);
    }
  }

  static setPhoneStyle(): void {
    Log.showDebug(TAG, 'setPhoneStyle');

    let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
    StyleManager.maxWidth = config.maxWidth;
    StyleManager.rumMode = 'phone';

    // keyButton
    {
      let style = StyleConfiguration.getKeyButtonStyle();
      style.buttonWidth = StyleManager.calcScaleSizePx(144);
      style.buttonHeight = StyleManager.calcScaleSizePx(72);
      style.buttonBorderRadius = StyleManager.calcScaleSizePx(36);
      style.buttonIconWidth = StyleManager.calcScaleSizePx(24);
      style.buttonIconHeight = StyleManager.calcScaleSizePx(24);
    }
  }

  static number2px(n: number): string {
    return n.toString() + 'px';
  }

  static calcScaleSize(n: number): number {
    return n * StyleManager.maxWidth / (StyleManager.rumMode == 'pad' ? StyleManager.PAD_STANDARD_DISPLAY_WIDTH : StyleManager.PHONE_STANDARD_DISPLAY_WIDTH);
  }

  static calcScaleSizePx(n: number): string {
    return StyleManager.number2px(StyleManager.calcScaleSize(n));
  }
}