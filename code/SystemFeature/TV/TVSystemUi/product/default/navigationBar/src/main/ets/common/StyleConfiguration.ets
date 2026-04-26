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
 

import CommonStyleManager from '../../../../../../../common/src/main/ets/default/CommonStyleManager';

const TAG = 'NavigationBar-StyleConfiguration';

export class KeyButtonStyle {
  public buttonWidth: Length = $r('app.float.navigation_bar_button_width');
  public buttonHeight: Length = $r('app.float.navigation_bar_button_height');
  public buttonBorderRadius: Length = $r('app.float.navigation_bar_button_radius');
  public buttonIconWidth: Length = $r('app.float.navigation_bar_button_icon_width');
  private buttonIconHeight: Length = $r('app.float.navigation_bar_button_icon_height');
}

export default class StyleConfiguration {
  static getKeyButtonStyle(): KeyButtonStyle {
    const key: string = TAG + '-KeyButton';
    return CommonStyleManager.getStyle(key, new KeyButtonStyle());
  }
}