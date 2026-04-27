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
 

import CommonStyleManager from '../../default/CommonStyleManager';

const TAG = 'CommonTemplate-StyleConfiguration';

export class IconTitleBaseStyle {
  public marginLeft: Length = '24vp';
  public marginRight: Length = '16vp';
  public componentGap: Length = '8vp';
  public titleSize: Length = '24vp';
  public titleColor: ResourceColor = $r('sys.color.ohos_id_color_text_secondary');
  public borderRadius: Length= '48vp';
  public backgroundColor: ResourceColor= '#ffffff';
  public textMargin: Length = '8vp';
  public textHoverHeight: Length = '52vp';
  public textHoverWidth: Length = '136vp';
  public textHoverRadius: Length = '8vp';
  public hoverColor: ResourceColor = 'rgba(0, 0, 0, 0.05)';
  public transparentColor: ResourceColor = 'rgba(255, 255, 255, 0)';
}

export class IconComponentStyle {
  public circleWidth: number | string = '96vp';
  public circleHeight: number | string = '96vp';
  public iconWidth: Length = '48vp';
  public iconHeight: Length = '48vp';
  public iconOffBG: ResourceColor = '#1A000000';
  public iconOnBG: ResourceColor = '#FF007DFF';
  public iconOnColor: ResourceColor = '#FFFFFFFF';
  public iconOffColor: ResourceColor = $r('sys.color.ohos_id_color_secondary');
  public hoverColor: ResourceColor = 'rgba(0, 0, 0, 0.05)';
  public transparentColor: ResourceColor = 'rgba(255, 255, 255, 0)';
}

export class SimpleToggleBaseStyle {
  public circleWidth: number | string = '96vp';
  public circleHeight: number | string = '96vp';
  public iconWidth: Length = '48vp';
  public iconHeight: Length = '48vp';
  public dragCircleWidth: number | string = '120vp';
  public dragCircleHeight: number | string = '120vp';
  public dragIconWidth: Length = '72vp';
  public dragIconHeight: Length = '72vp';
  public iconOffBG: ResourceColor = '#1A000000';
  public iconOnBG: ResourceColor = '#FF007DFF';
  public iconOnColor: ResourceColor = '#FFFFFFFF';
  public iconOffColor: ResourceColor = $r('sys.color.ohos_id_color_secondary');
  public componentGap: Length = '10vp';
  public titleSize: Length = '24fp';
  public titleColor: ResourceColor = $r('sys.color.ohos_id_color_text_secondary');
  public textHoverWidth: number | string = '136vp';
  public textHoverHeight: number | string = '36vp';
  public textHoverRadius: number | string = '8vp';
  public hoverColor: ResourceColor = 'rgba(0, 0, 0, 0.05)';
  public transparentColor: ResourceColor = 'rgba(255, 255, 255, 0)';
}

export default class StyleConfiguration {
  static getIconTitleBaseStyle(): IconTitleBaseStyle {
    const key: string = TAG + '-IconTitleBase';
    return CommonStyleManager.getStyle(key, new IconTitleBaseStyle());
  }

  static getIconComponentStyle(): IconComponentStyle {
    const key: string = TAG + '-IconComponent';
    return CommonStyleManager.getStyle(key, new IconComponentStyle());
  }

  static getSimpleToggleBaseStyle(): SimpleToggleBaseStyle {
    const key: string = TAG + '-SimpleToggleBase';
    return CommonStyleManager.getStyle(key, new SimpleToggleBaseStyle());
  }
}