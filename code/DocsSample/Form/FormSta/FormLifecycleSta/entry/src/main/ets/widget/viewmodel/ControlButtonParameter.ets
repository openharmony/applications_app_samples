/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export class ControlButtonParameter {
  /**
   * Title content.
   */
  public title?: ResourceStr;
  /**
   * Title color.
   */
  public titleColor?: ResourceColor;
  /**
   * Title opacity.
   */
  public titleOpacity?: number | Resource;
  /**
   * Title shadow.
   */
  public titleShadow?: ShadowOptions | ShadowStyle;
  /**
   * Secondary text.
   */
  public secondaryText?: ResourceStr;
  /**
   * Secondary text color.
   */
  public secondaryTextColor?: ResourceColor;
  /**
   * Secondary text opacity.
   */
  public secondaryTextOpacity?: number | Resource;
  /**
   * Secondary text shadow.
   */
  public secondaryTextShadow?: ShadowOptions | ShadowStyle;
  /**
   * Logo icon.
   */
  public logo?: ResourceStr;
  /**
   * Button icon.
   */
  public buttonIcon?: ResourceStr;
  /**
   * Button text.
   */
  public buttonText?: ResourceStr;
  /**
   * Button text color.
   */
  public buttonTextColor?: ResourceColor;
  /**
   * Button text opacity.
   */
  public buttonTextOpacity?: number | Resource;
  /**
   * Button text shadow.
   */
  public buttonTextShadow?: ShadowOptions | ShadowStyle;
  /**
   * NButton border.
   */
  public buttonBorder?: BorderOptions;
  /**
   * Card bottom background blur style.
   */
  public bottomBackgroundBlurStyle: BlurStyle = BlurStyle.COMPONENT_ULTRA_THIN;
  /**
   * Card background color.
   */
  public backgroundColor?: ResourceColor;
  /**
   * Background image.
   */
  public backgroundImage?: ResourceStr;
  /**
   * ImageSize of background image.
   */
  public backgroundImageSize?: ImageSize;
  /**
   * Bottom item list.
   */
  public bottomItemList: BottomItem[] = [];
  /**
   * Control the button show.
   */
  public buttonVisible?: boolean;
  /**
   * The auxiliary font color.
   */
  public auxiliaryTextColor?: ResourceColor;
  /**
   * The start color of card.
   */
  public linearStartColor?: ResourceStr;
  /**
   * The end color of card.
   */
  public linearEndColor?: ResourceStr;

  constructor(bottomItemList: BottomItem[], bottomBackgroundBlurStyle: BlurStyle,
    backgroundColor?: ResourceColor,
    backgroundImage?: ResourceStr, backgroundImageSize?: ImageSize, title?: ResourceStr, titleColor?: ResourceColor,
    titleOpacity?: number | Resource, titleShadow?: ShadowOptions | ShadowStyle, secondaryText?: ResourceStr,
    secondaryTextColor?: ResourceColor, secondaryTextOpacity?: number | Resource,
    secondaryTextShadow?: ShadowOptions | ShadowStyle, logo?: ResourceStr, buttonIcon?: ResourceStr,
    buttonText?: ResourceStr, buttonTextColor?: ResourceColor, buttonTextOpacity?: number | Resource,
    buttonTextShadow?: ShadowOptions | ShadowStyle, buttonBorder?: BorderOptions, buttonVisible?: boolean,
    auxiliaryTextColor?: ResourceColor, linearStartColor?: ResourceStr, linearEndColor?: ResourceStr) {
    this.bottomItemList = bottomItemList;
    this.backgroundColor = backgroundColor;
    this.bottomBackgroundBlurStyle = bottomBackgroundBlurStyle;
    this.backgroundImage = backgroundImage;
    this.backgroundImageSize = backgroundImageSize;
    this.title = title;
    this.titleColor = titleColor;
    this.titleOpacity = titleOpacity;
    this.titleShadow = titleShadow;
    this.secondaryText = secondaryText;
    this.secondaryTextColor = secondaryTextColor;
    this.secondaryTextOpacity = secondaryTextOpacity;
    this.secondaryTextShadow = secondaryTextShadow;
    this.logo = logo;
    this.buttonIcon = buttonIcon;
    this.buttonText = buttonText;
    this.buttonTextColor = buttonTextColor;
    this.buttonTextOpacity = buttonTextOpacity;
    this.buttonTextShadow = buttonTextShadow;
    this.buttonBorder = buttonBorder;
    this.buttonVisible = buttonVisible;
    this.auxiliaryTextColor = auxiliaryTextColor;
    this.linearStartColor = linearStartColor;
    this.linearEndColor = linearEndColor;
  }
}

export interface BottomItem {
  formLinkParam?: FormLinkOptions;
  title: ResourceStr;
  icon: ResourceStr;
}