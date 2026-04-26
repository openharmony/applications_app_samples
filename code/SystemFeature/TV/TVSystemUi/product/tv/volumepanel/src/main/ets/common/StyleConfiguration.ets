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
 

import Constants from './Constants';
import CommonStyleManager from '@ohos/common/src/main/ets/default/CommonStyleManager';

const TAG = 'VolumePanel-StyleConfiguration';

export class VolumePanelComponentStyle {
  public volumePanelSliderMarginTop: Length = $r('app.float.volume_panel_component_slider_margin_top');
  public volumePanSliderWidth: Length = $r('app.float.volume_panel_component_slider_width');
  public volumePanSliderHeight: Length = $r('app.float.volume_panel_component_slider_height');
  public volumePanelSliderMarginBottom: Length = $r('app.float.volume_panel_component_slider_margin_bottom');
  public volumePanelMutBtnIconSize: Length = $r('app.float.volume_panel_component_mute_btn_icon_size');
  public volumePanelMutBtnIconMarginBottom: Length = $r('app.float.volume_panel_component_mute_btn_icon_margin_bottom');
  public volumePanelMuteBtnHeight: Length = $r('app.float.volume_panel_component_mute_btn_height');
  public volumePanelSettingIconSize: Length = $r('app.float.volume_panel_component_setting_icon_size');
  public volumePanelBackground: ResourceColor = $r('app.color.panel_background');
  public volumePanelSliderBlockColor: ResourceColor = $r('app.color.volume_slider_block_color');
  public static volumePanelSettingButtonSize: Length =$r('app.float.volume_panel_component_setting_btn_icon_size');
  public volumePanelBorderRadius: Length = $r('app.float.volume_panel_border_radius');
  public volumeDividerWidth: Length = $r('app.float.volume_divider_width');
  public volumeSliderTrackColor: ResourceColor = $r('app.color.volume_slider_track_color');
  public volumeSelectedColor: ResourceColor = $r('app.color.volume_slider_selected_color');
  public volumeButtonBackgroundColor: ResourceColor = $r('app.color.volume_button_background_color');
  public volumePanelRingModeColor: ResourceColor = $r('app.color.volume_ring_mode_color');
  public volumePanelDividerColor: ResourceColor = $r('app.color.volume_divider_color');
  public volumePanelSettingColor: ResourceColor = $r('sys.color.ohos_id_color_secondary');
  public volumePanelSettingButtonSize: Length = $r('app.float.volume_panel_component_setting_btn_icon_size');
}


export class IndexStyle {
}

export default class StyleConfiguration {
  static getIndexStyle(): IndexStyle {
    const key: string = TAG + '-Index';
    return CommonStyleManager.getStyle(key, new IndexStyle());
  }

  static getVolumePanelComponentStyle(): VolumePanelComponentStyle {
    const key: string = TAG + '-VolumePanelComponent';
    return CommonStyleManager.getStyle(key, new VolumePanelComponentStyle());
  }
}