/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import deviceInfo from '@ohos.deviceInfo';

export interface KeyStyle {
  deviceType?: string,
  basicButtonWidth: Resource,
  basicButtonHeight: Resource,
  featurePicSize: Resource,
  switchButtonWidth: Resource,
  returnPicSize: Resource,
  returnButtonWidthType_1: Resource,
  returnButtonWidthType_2: Resource,
  spaceButtonWidth_1: Resource,
  spaceButtonWidth_2: Resource,
  paddingTop: Resource,
  paddingLeftRight: Resource,
  downMenuHeight: Resource,
  downMenuPicWidth: Resource,
  downMenuPicHeight: Resource,
  downMenuWidth: Resource,
  litterNumberFontSize: Resource,
  en_fontSize: Resource,
  symbol_fontSize: Resource,
  switchNumberFontSize: Resource,
  number1234ontFSize?: Resource,
  keyboardHeight: Resource,
  editPicSize: Resource,
  editFontSize: Resource,
  editDriverLeft: Resource,
  subMenuWidth: Resource,
  editCircleSize: Resource,
  editSmallCircle: Resource,
  editSmallCircleMargin: Resource,
  editButtonSize: Resource,
  editImageSize: Resource
}

export class StyleConfiguration {
  static getSavedInputStyle(): KeyStyle {
    let style = AppStorage.get<KeyStyle>('inputStyle');
    if (style) {
      return style;
    }
    let isLandscape = AppStorage.get<boolean>('isLandscape');
    if (isLandscape === undefined) {
      isLandscape = false;
    }
    let isRkDevice = AppStorage.get<boolean>('isRkDevice');
    if (isRkDevice === undefined) {
      isRkDevice = false;
    }
    return StyleConfiguration.getInputStyle(isLandscape, isRkDevice, deviceInfo.deviceType)
  }

  static getInputStyle(islandSpace: boolean, isRkDevice: boolean, deviceType: string): KeyStyle {
    if (isRkDevice) {
      return {
        basicButtonWidth: $r('app.float.rk_basic_button_width'),
        basicButtonHeight: $r('app.float.rk_basic_button_height'),
        featurePicSize: $r('app.float.rk_feature_picSize'),
        switchButtonWidth: $r('app.float.rk_switch_button_width'),
        returnPicSize: $r('app.float.rk_return_picSize'),
        returnButtonWidthType_1: $r('app.float.rk_return_button_widthType_1'),
        returnButtonWidthType_2: $r('app.float.rk_return_button_widthType_2'),
        spaceButtonWidth_1: $r('app.float.rk_space_button_width_1'),
        spaceButtonWidth_2: $r('app.float.rk_space_button_width_2'),
        paddingTop: $r('app.float.rk_padding_top'),
        paddingLeftRight: $r('app.float.rk_padding_left_right'),
        downMenuHeight: $r('app.float.rk_downMenu_height'),
        downMenuPicWidth: $r('app.float.rk_downMenu_pic_width'),
        downMenuPicHeight: $r('app.float.rk_downMenu_pic_height'),
        downMenuWidth: $r('app.float.rk_downMenu_width'),
        litterNumberFontSize: $r('app.float.rk_litter_number_fontSize'),
        en_fontSize: $r('app.float.rk_en_fontSize'),
        symbol_fontSize: $r('app.float.rk_en_fontSize'),
        switchNumberFontSize: $r('app.float.rk_switch_number_fontSize'),
        number1234ontFSize: $r('app.float.rk_number_1234_fontSize'),
        keyboardHeight: $r('app.float.rk_keyboard_height'),
        editPicSize: $r('app.float.rk_edit_pic_size'),
        editFontSize: $r('app.float.rk_edit_font_size'),
        editDriverLeft: $r('app.float.rk_edit_driver_left'),
        subMenuWidth: $r('app.float.rk_sub_menu_width'),
        editCircleSize: $r('app.float.rk_edit_circle_size'),
        editSmallCircle: $r('app.float.rk_edit_small_circle_size'),
        editButtonSize: $r('app.float.rk_edit_button_size'),
        editImageSize: $r('app.float.rk_edit_img_size'),
        editSmallCircleMargin: $r('app.float.rk_edit_small_circle_margin')
      }
    } else if (deviceType == 'tablet') {
      if (islandSpace) {
        return {
          deviceType: 'tablet_landSpace',
          basicButtonWidth: $r('app.float.landSpace_basic_button_width'),
          basicButtonHeight: $r('app.float.landSpace_basic_button_height'),
          featurePicSize: $r('app.float.landSpace_feature_picSize'),
          switchButtonWidth: $r('app.float.landSpace_switch_button_width'),
          returnPicSize: $r('app.float.landSpace_return_picSize'),
          returnButtonWidthType_1: $r('app.float.landSpace_return_button_widthType_1'),
          returnButtonWidthType_2: $r('app.float.landSpace_return_button_widthType_2'),
          spaceButtonWidth_1: $r('app.float.landSpace_space_button_width_1'),
          spaceButtonWidth_2: $r('app.float.landSpace_space_button_width_2'),
          paddingTop: $r('app.float.landSpace_padding_top'),
          paddingLeftRight: $r('app.float.landSpace_padding_left_right'),
          downMenuHeight: $r('app.float.landSpace_downMenu_height'),
          downMenuPicWidth: $r('app.float.landSpace_downMenu_pic_width'),
          downMenuPicHeight: $r('app.float.landSpace_downMenu_pic_height'),
          downMenuWidth: $r('app.float.landSpace_downMenu_width'),
          litterNumberFontSize: $r('app.float.landSpace_litter_number_fontSize'),
          en_fontSize: $r('app.float.landSpace_en_fontSize'),
          symbol_fontSize: $r('app.float.landSpace_symbol_fontSize'),
          switchNumberFontSize: $r('app.float.landSpace_switch_number_fontSize'),
          keyboardHeight: $r('app.float.landSpace_keyboard_height'),
          editPicSize: $r('app.float.rk_edit_pic_size'),
          editFontSize: $r('app.float.rk_edit_font_size'),
          editDriverLeft: $r('app.float.rk_edit_driver_left'),
          subMenuWidth: $r('app.float.rk_sub_menu_width'),
          editCircleSize: $r('app.float.rk_edit_circle_size'),
          editSmallCircle: $r('app.float.rk_edit_small_circle_size'),
          editButtonSize: $r('app.float.rk_edit_button_size'),
          editImageSize: $r('app.float.rk_edit_img_size'),
          editSmallCircleMargin: $r('app.float.rk_edit_small_circle_margin')
        };
      } else {
        return {
          deviceType: 'tablet_portrait',
          basicButtonWidth: $r('app.float.portrait_basic_button_width'),
          basicButtonHeight: $r('app.float.portrait_basic_button_height'),
          featurePicSize: $r('app.float.portrait_feature_picSize'),
          switchButtonWidth: $r('app.float.portrait_switch_button_width'),
          returnPicSize: $r('app.float.portrait_return_picSize'),
          returnButtonWidthType_1: $r('app.float.portrait_return_button_widthType_1'),
          returnButtonWidthType_2: $r('app.float.portrait_return_button_widthType_2'),
          spaceButtonWidth_1: $r('app.float.portrait_space_button_width_1'),
          spaceButtonWidth_2: $r('app.float.portrait_space_button_width_2'),
          paddingTop: $r('app.float.portrait_padding_top'),
          paddingLeftRight: $r('app.float.portrait_padding_left_right'),
          downMenuHeight: $r('app.float.portrait_downMenu_height'),
          downMenuPicWidth: $r('app.float.portrait_downMenu_pic_width'),
          downMenuPicHeight: $r('app.float.portrait_downMenu_pic_height'),
          downMenuWidth: $r('app.float.portrait_downMenu_width'),
          litterNumberFontSize: $r('app.float.portrait_litter_number_fontSize'),
          en_fontSize: $r('app.float.portrait_en_fontSize'),
          symbol_fontSize: $r('app.float.landSpace_symbol_fontSize'),
          switchNumberFontSize: $r('app.float.portrait_switch_number_fontSize'),
          keyboardHeight: $r('app.float.portrait_keyboard_height'),
          editPicSize: $r('app.float.rk_edit_pic_size'),
          editFontSize: $r('app.float.rk_edit_font_size'),
          editDriverLeft: $r('app.float.rk_edit_driver_left'),
          subMenuWidth: $r('app.float.rk_sub_menu_width'),
          editCircleSize: $r('app.float.rk_edit_circle_size'),
          editSmallCircle: $r('app.float.rk_edit_small_circle_size'),
          editButtonSize: $r('app.float.rk_edit_button_size'),
          editImageSize: $r('app.float.rk_edit_img_size'),
          editSmallCircleMargin: $r('app.float.rk_edit_small_circle_margin')
        };
      }
    }
    else {
      if (!islandSpace) {
        return {
          basicButtonWidth: $r('app.float.s_basic_button_width'),
          basicButtonHeight: $r('app.float.s_basic_button_height'),
          featurePicSize: $r('app.float.s_feature_picSize'),
          switchButtonWidth: $r('app.float.s_switch_button_width'),
          returnPicSize: $r('app.float.return_picSize'),
          returnButtonWidthType_1: $r('app.float.s_return_button_widthType_1'),
          returnButtonWidthType_2: $r('app.float.s_return_button_widthType_2'),
          spaceButtonWidth_1: $r('app.float.s_space_button_width_1'),
          spaceButtonWidth_2: $r('app.float.s_space_button_width_2'),
          paddingTop: $r('app.float.s_padding_top'),
          paddingLeftRight: $r('app.float.s_padding_left_right'),
          downMenuHeight: $r('app.float.downMenu_height'),
          downMenuPicWidth: $r('app.float.downMenu_pic_width'),
          downMenuPicHeight: $r('app.float.downMenu_pic_height'),
          downMenuWidth: $r('app.float.downMenu_width'),
          litterNumberFontSize: $r('app.float.litter_number_fontSize'),
          en_fontSize: $r('app.float.en_fontSize'),
          symbol_fontSize: $r('app.float.en_fontSize'),
          switchNumberFontSize: $r('app.float.switch_number_fontSize'),
          number1234ontFSize: $r('app.float.number_1234_fontSize'),
          keyboardHeight: $r('app.float.keyboard_height'),
          editPicSize: $r('app.float.s_edit_pic_size'),
          editFontSize: $r('app.float.s_edit_font_size'),
          editDriverLeft: $r('app.float.s_edit_driver_left'),
          subMenuWidth: $r('app.float.s_sub_menu_width'),
          editCircleSize: $r('app.float.s_edit_circle_size'),
          editSmallCircle: $r('app.float.s_edit_small_circle_size'),
          editButtonSize: $r('app.float.s_edit_button_size'),
          editImageSize: $r('app.float.s_edit_img_size'),
          editSmallCircleMargin: $r('app.float.s_edit_small_circle_margin')
        };
      } else {
        return {
          basicButtonWidth: $r('app.float.h_basic_button_width'),
          basicButtonHeight: $r('app.float.h_basic_button_height'),
          featurePicSize: $r('app.float.h_feature_picSize'),
          switchButtonWidth: $r('app.float.h_switch_button_width'),
          returnPicSize: $r('app.float.return_picSize'),
          returnButtonWidthType_1: $r('app.float.h_return_button_widthType_1'),
          returnButtonWidthType_2: $r('app.float.h_return_button_widthType_2'),
          spaceButtonWidth_1: $r('app.float.h_space_button_width_1'),
          spaceButtonWidth_2: $r('app.float.h_space_button_width_2'),
          paddingTop: $r('app.float.h_padding_top'),
          paddingLeftRight: $r('app.float.h_padding_left_right'),
          downMenuHeight: $r('app.float.h_downMenu_height'),
          downMenuPicWidth: $r('app.float.downMenu_pic_width'),
          downMenuPicHeight: $r('app.float.downMenu_pic_height'),
          downMenuWidth: $r('app.float.downMenu_width'),
          litterNumberFontSize: $r('app.float.litter_number_fontSize'),
          en_fontSize: $r('app.float.en_fontSize'),
          symbol_fontSize: $r('app.float.en_fontSize'),
          switchNumberFontSize: $r('app.float.switch_number_fontSize'),
          number1234ontFSize: $r('app.float.number_1234_fontSize'),
          keyboardHeight: $r('app.float.keyboard_height'),
          editPicSize: $r('app.float.s_edit_pic_size'),
          editFontSize: $r('app.float.s_edit_font_size'),
          editDriverLeft: $r('app.float.s_edit_driver_left'),
          subMenuWidth: $r('app.float.s_sub_menu_width'),
          editCircleSize: $r('app.float.h_edit_circle_size'),
          editSmallCircle: $r('app.float.h_edit_small_circle_size'),
          editButtonSize: $r('app.float.h_edit_button_size'),
          editImageSize: $r('app.float.h_edit_img_size'),
          editSmallCircleMargin: $r('app.float.h_edit_small_circle_margin')
        };
      }
    }
  }
}