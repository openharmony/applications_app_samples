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

import Log from '../../../../../../../../common/src/main/ets/default/Log'
import AbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager'
import StyleConfiguration, { vvolumePanelComponentStyle } from '../common/StyleConfiguration'
import Constants from '../common/Constants'
import ViewModel from '../viewmodel/VolumePanelVM'
import VolumeWindowController from '../common/VolumeWindowController'

const TAG = 'VolumePanel-VolumePanelComponent'

@Component
export default struct VolumePanelComponent {
  @StorageLink('volumePanelMaxVolume') volumePanelMaxVolume: number = Constants.DEFAULT_MAX_VOLUME
  @StorageLink('volumePanelMinVolume') volumePanelMinVolume: number = Constants.DEFAULT_MIN_VOLUME
  @StorageLink('volumePanelVolumeValue') volumePanelVolumeValue: number = Constants.DEFAULT_MIN_VOLUME
  @StorageLink('volumePanelIsMute') volumePanelIsMute: boolean = Constants.DEFAULT_MUTE_STATUS
  @State style: vvolumePanelComponentStyle = StyleConfiguration.getvvolumePanelComponentStyle()

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear');
    ViewModel.initViewModel()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    Column() {
      Text(this.volumePanelVolumeValue.toString())
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#f0f0f0')
        .margin({top: 10})

      Slider({
        value: this.volumePanelVolumeValue,
        min: this.volumePanelMinVolume,
        max: this.volumePanelMaxVolume,
        step: 1,
        style: SliderStyle.InSet,
        direction: Axis.Vertical,
        reverse: true
      })
        .margin({top: this.style.volumePanelSliderMarginTop, bottom: this.style.volumePanelSliderMarginBottom})
        .trackThickness(11)
        .blockColor('#f0f0f0')
        .trackColor('#37ffffff')
        .selectedColor('#f0f0f0')
        .onChange(this.onVolumeChange.bind(this))
        .flexGrow(1)
        .flexShrink(1)

      Image(this.getVolumeIcon(
        this.vvolumePanelIsMute, this.volumePanelVolumeValue, this.volumePanelMaxVolume, this.volumePanelMinVolume))
        .width(20)
        .height(20)
        .margin({bottom: 24})
        .fillColor($r('sys.color.ohos_id_color_activated'))

    }
    .width('100%')
    .height('100%')
    .borderRadius(5)
    .backgroundColor('#25ffffff')
  }

  getVolumeIcon(isMute: boolean, volume: number, maxVolume: number, minVolume: number) {
    Log.showInfo(TAG,
      `getVolumeIcon, isMute: ${isMute} volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`);
    let icon: Resource
    if (isMute) {
      icon = $r('app.media.ic_public_mute')
    } else {
      if (volume >= (((maxVolume - minVolume) / 3) * 2 + minVolume)) {
        icon = $r('app.media.ic_public_sound_03')
      } else if (volume >= ((maxVolume - minVolume) / 3 + minVolume)) {
        icon = $r('app.media.ic_public_sound_02')
      } else if (volume == minVolume) {
        icon = $r('app.media.ic_public_sound_04')
      } else {
        icon = $r('app.media.ic_public_sound_01')
      }
    }
    return icon
  }

  onVolumeChange(value: number, mode: SliderChangeMode) {
    Log.showInfo(TAG, `onVolumeChange, value: ${value} mode: ${mode}`);
    ViewModel.setVolume(value)
  }

  onMuteBtnClick(event: ClickEvent) {
    Log.showInfo(TAG, `onMuteBtnClick`);
    ViewModel.mute();
  }

  onSettingsBtnClick(event: ClickEvent) {
    Log.showInfo(TAG, `onSettingsBtnClick`);
    AbilityManager.startAbility(AbilityManager.getContext(AbilityManager.ABILITY_NAME_VOLUME_PANEL), {
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.MainAbility',
    });
    VolumeWindowController.getInstance().setWindowState(false);
  }
}