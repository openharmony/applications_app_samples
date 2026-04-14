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
 

import Log from '../../../../../../../../common/src/main/ets/default/Log';
import Constants from '../common/Constants';
import { AudioVolumeType, VolumeInfo } from '../common/Constants';
import VolumePanelService from '../model/VolumePanelService';
import VolumeWindowController from '../common/VolumeWindowController';

// VolumePanelVM 通过 AppStorage 将音量状态共享给 UI 组件树，
// 使用具名 key 而非直接传参，是因为 TV 音量面板可能由多个独立页面节点观察同一状态，
// AppStorage 的响应式绑定机制能保证所有订阅者自动刷新，无需手动广播。
export const VOLUME_PANEL_MAX_VOLUME_KEY = 'VolumePanelMaxVolume';

export const VOLUME_PANEL_MIN_VOLUME_KEY = 'VolumePanelMinVolume';

export const VOLUME_PANEL_VOLUME_VALUE_KEY = 'VolumePanelVolumeValue';

export const VOLUME_PANEL_IS_MUTE_KEY = 'VolumePanelIsMute';

const TAG = 'VolumePanelVM';

export class VolumePanelVM {
  public mIsStart = false;
  public mMaxVolume: SubscribedAbstractProperty<number>;
  public mMinVolume: SubscribedAbstractProperty<number>;
  public mVolumeValue: SubscribedAbstractProperty<number>;
  public mIsMute: SubscribedAbstractProperty<boolean>;
  public mAllVolumeTypes = [
    AudioVolumeType.VOICE_CALL,
    AudioVolumeType.RINGTONE,
    AudioVolumeType.MEDIA,
    AudioVolumeType.VOICE_ASSISTANT
  ];
  public mVolumeBaseMap = {};
  public mCurrentAudioVolumeType: number = AudioVolumeType.MEDIA;
  public mCurrentAudioVolume: number;
  private mUpdatingAudioVolume: number;
  private mVolumeBeforeMute: number;

  constructor() {
    Log.showInfo(TAG, 'constructor');
  }

  initViewModel(): void {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, 'initViewModel ');
    this.mIsStart = true;

    // 初始化时预取所有音量类型的上下限，是因为 TV 不同音频流（媒体/通话/铃声）
    // 的最大最小值可能因硬件配置而不同，需在第一次显示前填充好 mVolumeBaseMap，
    // 防止用户刚打开音量面板时滑块比例计算错误导致 UI 抖动。
    this.mMaxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_VOLUME_KEY, Constants.DEFAULT_MAX_VOLUME);
    this.mMinVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_VOLUME_KEY, Constants.DEFAULT_MIN_VOLUME);
    this.mVolumeValue = AppStorage.setAndLink(VOLUME_PANEL_VOLUME_VALUE_KEY, Constants.DEFAULT_MIN_VOLUME);
    this.mIsMute = AppStorage.setAndLink(VOLUME_PANEL_IS_MUTE_KEY, Constants.DEFAULT_MUTE_STATUS);
    this.mAllVolumeTypes.forEach((volumeType: AudioVolumeType) => {
      this.mVolumeBaseMap[volumeType] = {
        maxVolume: Constants.DEFAULT_MAX_VOLUME,
        minVolume: Constants.DEFAULT_MIN_VOLUME
      };
    });
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

  // 初始化时按优先级探测当前活跃音频流类型（通话 > 铃声 > 媒体 > 语音助手），
  // 而非直接取 MEDIA，是为了保证用户在通话中打开音量面板时调节的是通话音量而非媒体音量。
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
      callback(undefined);
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
    this.mVolumeBaseMap[volumeType].maxVolume = value;
    Log.showInfo(TAG, `updateMaxVolume, mVolumeBaseMap: ${JSON.stringify(this.mVolumeBaseMap)}`);
  }

  updateMinVolume(volumeType: AudioVolumeType, value: number): void {
    Log.showInfo(TAG, `updateMinVolume, volumeType: ${volumeType} value: ${value}`);
    this.mVolumeBaseMap[volumeType].minVolume = value;
    Log.showInfo(TAG, `updateMinVolume, mVolumeBaseMap: ${JSON.stringify(this.mVolumeBaseMap)}`);
  }

  // updateVolumeInfo 是 VolumeListener 回调入口，只有当 updateUi 为 true 或静音状态发生变化时
  // 才真正刷新 AppStorage，避免遥控器快速连按时产生大量无效的 UI 重绘帧，保障 TV 帧率稳定。
  updateVolumeInfo(volumeInfo: VolumeInfo): void {
    Log.showInfo(TAG,
      `updateVolumeInfo, volumeInfo: ${JSON.stringify(volumeInfo)} , mCurrentAudioVolumeType: ${this.mCurrentAudioVolumeType}`);
    if (!volumeInfo.updateUi && this.mIsMute.get() == volumeInfo.isMute) {
      return;
    }
    let volumeType = volumeInfo.volumeType;
    let maxVolume: number = this.mVolumeBaseMap[volumeType].maxVolume;
    let minVolume: number = this.mVolumeBaseMap[volumeType].minVolume;
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
      isMute = undefined;
    }
    VolumePanelService.setVolumeAndMute(this.mCurrentAudioVolumeType, volume, isMute);
    VolumeWindowController.getInstance().updateVolumeInfo(null);
  }

  // mute 切换时需记住静音前的音量（mVolumeBeforeMute），
  // 这样取消静音时能恢复用户上次设定的音量，而不是强制从最小值开始，符合 TV 用户的操作直觉。
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
