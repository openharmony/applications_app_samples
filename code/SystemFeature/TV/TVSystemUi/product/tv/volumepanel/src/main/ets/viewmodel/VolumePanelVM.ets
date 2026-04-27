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
 

import { deviceInfo } from '@kit.BasicServicesKit';
import Log from '@ohos/common/src/main/ets/default/Log';
import VolumePanelService from '../model/VolumePanelService';
import Constants, { AudioVolumeType, VolumeInfo } from '../common/Constants';
import VolumeWindowController from '../common/VolumeWindowController';

class VolumeBounds {
  public maxVolume: number = Constants.DEFAULT_MAX_VOLUME;
  public minVolume: number = Constants.DEFAULT_MIN_VOLUME;
}

export const VOLUME_PANEL_MAX_VOLUME_KEY = 'VolumePanelMaxVolume';

export const VOLUME_PANEL_MIN_VOLUME_KEY = 'VolumePanelMinVolume';

export const VOLUME_PANEL_VOLUME_VALUE_KEY = 'VolumePanelVolumeValue';

export const VOLUME_PANEL_IS_MUTE_KEY = 'VolumePanelIsMute';

const TAG = 'VolumePanelVM';

export class VolumePanelVM {
  public mIsStart = false;
  public mMaxVolume!: SubscribedAbstractProperty<number>;
  public mMinVolume!: SubscribedAbstractProperty<number>;
  public mVolumeValue!: SubscribedAbstractProperty<number>;
  public mIsMute!: SubscribedAbstractProperty<boolean>;
  public mAllVolumeTypes = [AudioVolumeType.MEDIA, AudioVolumeType.RINGTONE];
  public mVolumeBaseMap: Map<AudioVolumeType, VolumeBounds> = new Map();
  public mCurrentAudioVolumeType: number = AudioVolumeType.MEDIA;
  public mCurrentAudioVolume!: number;
  public mUpdatingAudioVolume: number | undefined;
  public mVolumeBeforeMute!: number;

  constructor() {
    Log.showInfo(TAG, 'constructor');
  }

  initViewModel(): void {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, 'initViewModel ');
    this.mIsStart = true;

    this.mMaxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_VOLUME_KEY, Constants.DEFAULT_MAX_VOLUME);
    this.mMinVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_VOLUME_KEY, Constants.DEFAULT_MIN_VOLUME);
    this.mVolumeValue = AppStorage.setAndLink(VOLUME_PANEL_VOLUME_VALUE_KEY, Constants.DEFAULT_MIN_VOLUME);
    this.mIsMute = AppStorage.setAndLink(VOLUME_PANEL_IS_MUTE_KEY, Constants.DEFAULT_MUTE_STATUS);
    this.mAllVolumeTypes.forEach((volumeType: AudioVolumeType) => {
      this.mVolumeBaseMap.set(volumeType, new VolumeBounds());
    });
    console.log(TAG, `deviceInfo-->${deviceInfo.productModel}-${deviceInfo.osFullName}-${deviceInfo.brand}`)
    this.registerVolume();
  }

  registerVolume() {
    VolumePanelService.startService();
    VolumePanelService.registerListener(this);
    this.mAllVolumeTypes.forEach((volumeType: AudioVolumeType) => {
      VolumePanelService.getMaxVolume(volumeType,
        (volumeType: AudioVolumeType, value: number) => this.updateMaxVolume(volumeType, value));
      VolumePanelService.getMinVolume(volumeType,
        (volumeType: AudioVolumeType, value: number) => this.updateMinVolume(volumeType, value));
    });
    this.getInitVolumeInfo();
  }

  getInitVolumeInfo(): void {
    this.getActiveVolumeType(JSON.parse(JSON.stringify(this.mAllVolumeTypes)), (activeVolumeType: AudioVolumeType) => {
      Log.showInfo(TAG, `getInitVolumeInfo, activeVolumeType: ${activeVolumeType}`);
      if (activeVolumeType == undefined) {
        activeVolumeType = AudioVolumeType.MEDIA;
      }
      this.mCurrentAudioVolumeType = activeVolumeType;
      VolumePanelService.getVolumeInfo(activeVolumeType);
    });
  }

  getActiveVolumeType(volumeTypes: number[], callback: (volumeType: AudioVolumeType) => void): void {
    Log.showInfo(TAG, `getActiveVolumeType, volumeTypes: ${JSON.stringify(volumeTypes)}`);
    if (volumeTypes.length == 0) {
      callback(AudioVolumeType.MEDIA);
      return;
    }
    VolumePanelService.isActive(volumeTypes[0], (volumeType: AudioVolumeType, data: boolean) => {
      Log.showInfo(TAG, `getActiveVolumeType, volumeType: ${volumeType} data: ${data}`);
      if (data) {
        callback(volumeType);
      } else {
        volumeTypes.splice(0, 1);
        this.getActiveVolumeType(volumeTypes, callback);
      }
    });
  }

  updateMaxVolume(volumeType: AudioVolumeType, value: number): void {
    Log.showInfo(TAG, `updateMaxVolume, volumeType: ${volumeType} value: ${value}`);
    const entry = this.mVolumeBaseMap.get(volumeType);
    if (entry !== undefined) {
      entry.maxVolume = value;
    }
    Log.showInfo(TAG, `updateMaxVolume, mVolumeBaseMap size: ${this.mVolumeBaseMap.size}`);
  }

  updateMinVolume(volumeType: AudioVolumeType, value: number): void {
    Log.showInfo(TAG, `updateMinVolume, volumeType: ${volumeType} value: ${value}`);
    const entry = this.mVolumeBaseMap.get(volumeType);
    if (entry !== undefined) {
      entry.minVolume = value;
    }
    Log.showInfo(TAG, `updateMinVolume, mVolumeBaseMap size: ${this.mVolumeBaseMap.size}`);
  }

  updateVolumeInfo(volumeInfo: VolumeInfo): void {
    Log.showInfo(TAG,
      `updateVolumeInfo, volumeInfo: ${JSON.stringify(volumeInfo)} , mCurrentAudioVolumeType: ${this.mCurrentAudioVolumeType}`);
    if (!volumeInfo.updateUi && this.mIsMute.get() == volumeInfo.isMute) {
      Log.showInfo(TAG, `updateVolumeInfo, mCurrentAudioVolume in`);
      this.mCurrentAudioVolume = volumeInfo.volume;
      return;
    }
    if (this.mVolumeBaseMap.size === 0) {
      return;
    }
    Log.showInfo(TAG, `updateVolumeInfo, volumeInfo in`);
    let volumeType = volumeInfo.volumeType;
    const bounds = this.mVolumeBaseMap.get(volumeType);
    if (bounds === undefined) {
      return;
    }
    let maxVolume: number = bounds.maxVolume;
    let minVolume: number = bounds.minVolume;
    this.mMaxVolume.set(maxVolume);
    this.mMinVolume.set(minVolume);
    Log.showInfo(TAG, `updateVolumeInfo, mMaxVolume: ${this.mMaxVolume.get()} , mMinVolume: ${this.mMinVolume.get()}`);

    this.mCurrentAudioVolume = volumeInfo.volume;
    this.mCurrentAudioVolumeType = volumeType;
    Log.showInfo(TAG,
      `updateVolumeInfo, mCurrentAudioVolume: ${this.mCurrentAudioVolume} , mCurrentAudioVolumeType: ${this.mCurrentAudioVolumeType}`);

    this.mVolumeBeforeMute = minVolume;
    if (volumeInfo.isMute != this.mIsMute.get()) {
      this.mIsMute.set(volumeInfo.isMute);
    }
    Log.showInfo(TAG, `updateVolumeInfo, mIsMute: ${this.mIsMute.get()} `);

    this.updateDisplayVolume(volumeInfo.isMute ? minVolume : volumeInfo.volume, maxVolume, minVolume);
  }

  updateDisplayVolume(volume: number, maxVolume: number, minVolume: number): void {
    Log.showInfo(TAG, `updateDisplayVolume, volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`);
    let displayVolume: number = volume + minVolume;
    this.mVolumeValue.set(displayVolume);
    Log.showInfo(TAG, `updateDisplayVolume, mVolumeValue: ${this.mVolumeValue.get()}`);
  }

  calcVolumeByDisplayVolume(displayVolume: number): number {
    let volume: number = displayVolume + this.mMinVolume.get();
    Log.showInfo(TAG, `calcVolumeByDisplayVolume, volume: ${volume}`);
    return volume;
  }

  setVolume(displayVolume: number): void {
    Log.showInfo(TAG, `setVolume, displayVolume: ${displayVolume} `);
    let volume: number = this.calcVolumeByDisplayVolume(displayVolume);
    if (this.mUpdatingAudioVolume != undefined && volume == this.mUpdatingAudioVolume) {
      return;
    }
    this.mUpdatingAudioVolume = volume;
    let isMute = volume == this.mMinVolume.get();
    if (isMute == this.mIsMute.get()) {
      VolumePanelService.setVolume(this.mCurrentAudioVolumeType, volume);
    } else {
      VolumePanelService.setVolumeAndMute(this.mCurrentAudioVolumeType, volume, isMute);
    }
    VolumeWindowController.getInstance().updateVolumeInfo(null);
  }

  mute(): void {
    Log.showInfo(TAG, `mute, isMute: ${this.mIsMute.get()} mCurrentAudioVolume: ${this.mCurrentAudioVolume}`);
    this.mUpdatingAudioVolume = undefined;
    let isMute: boolean = this.mIsMute.get();
    isMute = !isMute;
    let maxVolume: number = this.mMaxVolume.get();
    let minVolume: number = this.mMinVolume.get();
    let volume = isMute ? minVolume : (minVolume == this.mVolumeBeforeMute ? (minVolume + 1) : this.mVolumeBeforeMute);
    let currentAudioVolume = this.mCurrentAudioVolume;
    let volumeType = this.mCurrentAudioVolumeType;
    VolumePanelService.setVolumeAndMute(volumeType, volume, isMute, () => {
      Log.showInfo(TAG, 'mute, setVolumeAndMute callback');
      if (volumeType == this.mCurrentAudioVolumeType && this.mIsMute.get()) {
        this.mVolumeBeforeMute = currentAudioVolume;
      }
    });
    VolumeWindowController.getInstance().updateVolumeInfo(null);
  }
}

let volumePanelVM = new VolumePanelVM();

export default volumePanelVM;
