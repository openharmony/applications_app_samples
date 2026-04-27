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
 
import ViewModel from '../viewmodel/VolumePanelVM'

import { BusinessError } from '@kit.BasicServicesKit'
import { audio } from '@kit.AudioKit'
import { commonEventManager } from '@kit.BasicServicesKit'
import { r_vp } from '../common/AutoSize'
import Log from '@ohos/common/src/main/ets/default/Log'
import AbilityManager from '@ohos/common/src/main/ets/default/abilitymanager/AbilityManager';
import Constants from '../common/Constants';
import VolumeWindowController from '../common/VolumeWindowController';

const TAG = 'VolumePanel-VolumePanelComponent'

@Preview
@Component
export default struct VolumePanelComponent {
  @StorageLink('VolumePanelMaxVolume') volumePanelMaxVolume: number = Constants.DEFAULT_MAX_VOLUME
  @StorageLink('VolumePanelMinVolume') volumePanelMinVolume: number = Constants.DEFAULT_MIN_VOLUME
  @StorageLink('VolumePanelVolumeValue') volumePanelVolumeValue: number = Constants.DEFAULT_MIN_VOLUME
  @StorageLink('VolumePanelIsMute') volumePanelIsMute: boolean = Constants.DEFAULT_MUTE_STATUS
  // 鍒ゆ柇杈撳嚭璁惧绫诲瀷
  @StorageProp('OUTPUT_STATE') volumePanelDeviceType: number = audio.DeviceType.SPEAKER

  aboutToAppear() {
    Log.showInfo(TAG, 'this is my aboutToAppear');
    ViewModel.initViewModel();
    this.registerMuteCommonEvent();
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
  }

  // 闈欓煶閿鎸変笅
  registerMuteCommonEvent() {

    commonEventManager.createSubscriber({ events: ['KEY_MUTE'] })
      .then((commonEventSubscriber) => {
        console.log('=-= createSubscriber success, commonEventSubscriber: ' + JSON.stringify(commonEventSubscriber));
        commonEventManager.subscribe(commonEventSubscriber, (err, data) => {
          console.log('=-= createSubscriber success, commonEventSubscriber: ' + JSON.stringify(commonEventSubscriber));
          if (err.code !== 0) {
            console.log('=-= subscribe err, err: ' + JSON.stringify(err));
            return;
          }
          this.onMuteBtnClick();
        })
      })
      .catch((err: BusinessError) => {
        console.log('=-= createSubscriber fail, err: ' + JSON.stringify(err));
      })
  }

  build() {
    Column({ space: px2vp(r_vp(16)) }) {
      Text(this.volumePanelVolumeValue.toString())
        .fontSize(px2vp(r_vp(42)))
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
      Column() {
        Flex({
          direction: FlexDirection.ColumnReverse,
          justifyContent: FlexAlign.SpaceEvenly,
          alignItems: ItemAlign.Center
        }) {
          ForEach(new Array(15).fill(0), (item: number, index) => {
            Row() {
            }
            .width(this.volumePanelVolumeValue - 1 == index ? '40%' : '20%')
            .margin({ left: this.volumePanelVolumeValue - 1 == index ? '20%' : 0 })
            .height(px2vp(r_vp(2)))
            .backgroundColor(index < this.volumePanelVolumeValue ? '#4482ff' : '#a8a9b3')
          },(item:number,index)=>JSON.stringify(item)+index)
        }
      }.width('100%').layoutWeight(1)

      Image(this.getVolumeIcon(
        this.volumePanelIsMute,
        this.volumePanelVolumeValue,
        this.volumePanelMaxVolume,
        this.volumePanelMinVolume
      ))
        .height(px2vp(r_vp(42)))

        .objectFit(ImageFit.Fill)
    }
    .width('100%')
    .height('100%')
    .padding({ top: px2vp(r_vp(48)), bottom: px2vp(r_vp(48)) })
    .borderRadius(px2vp(r_vp(18)))
    .backgroundColor('#000000')
    .opacity(0.85)
  }

  getVolumeIcon(isMute: boolean, volume: number, maxVolume: number, minVolume: number): ResourceStr {
    Log.showInfo(TAG,
      `getVolumeIcon, isMute: ${isMute} volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`);
    let icon: ResourceStr = ''
    if (isMute || volume === 0) {
      if (this.volumePanelDeviceType === audio.DeviceType.SPEAKER) {
        icon = $r('app.media.speakernew2')
      } else if ((this.volumePanelDeviceType === audio.DeviceType.BLUETOOTH_A2DP) ||
        (this.volumePanelDeviceType === audio.DeviceType.BLUETOOTH_SCO)) {
        icon = $r('app.media.bluetooth2')
      } else if (this.volumePanelDeviceType === audio.DeviceType.DEFAULT) {
        icon = $r('app.media.amplifiernew2')
      }
    } else {
      if (this.volumePanelDeviceType === audio.DeviceType.SPEAKER) {
        icon = $r('app.media.speakernew1')
      } else if ((this.volumePanelDeviceType === audio.DeviceType.BLUETOOTH_A2DP) ||
        (this.volumePanelDeviceType === audio.DeviceType.BLUETOOTH_SCO)) {
        icon = $r('app.media.bluetooth1')
      } else if (this.volumePanelDeviceType === audio.DeviceType.DEFAULT) {
        icon = $r('app.media.amplifiernew1')
      }
    }
    return icon
  }

  // 鍒囨崲闈欓煶鐘舵€?
  onMuteBtnClick() {
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
